module CanvasApp where

import Prelude

import Data.Color (toCss)
import Data.Draw (Draw(..))
import Data.GridLoc (GridLoc(..))
import Data.InputEvent (InputEvent(..))
import Data.Int (toNumber)
import Data.Key (mapKey)
import Data.Maybe (Maybe(..))
import Data.Model (Model)
import Data.Queue (Queue, emptyQueue, enqueue)
import Data.Traversable (traverse_)
import Data.Tuple (Tuple(..))
import Data.Types (Frame)
import Data.World (mkWorld)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import GameLogic (step, view)
import Graphics.Canvas
  ( CanvasElement
  , Context2D
  , clearRect
  , fillRect
  , fillText
  , getCanvasElementById
  , getContext2D
  , setCanvasHeight
  , setCanvasWidth
  , setFillStyle
  , setFont
  )
import Load (loadText)
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (EventListener, addEventListener, eventListener)
import Web.HTML (Window)
import Web.HTML as HTML
import Web.HTML.Window as Window
import Web.UIEvent.KeyboardEvent as KeyboardEvent

main ∷ Effect Unit
main = do
  win ← HTML.window
  elemM ← getCanvasElementById "canvas"
  case elemM of
    Nothing → Window.alert "This HTML does not contain a canvas element with id 'canvas'." win
    Just canvas → do
      inputQ ← Ref.new emptyQueue
      ctx ← initialize win canvas inputQ
      launchGame win ctx inputQ

initialize ∷ Window → CanvasElement → Ref.Ref (Queue InputEvent) → Effect Context2D
initialize win canvas inputQ = do
  ctx ← getContext2D canvas
  setFont ctx "16px monospace"
  registerKeyboardListener win inputQ
  registerResizeListener win canvas inputQ
  _ ← resizeCanvas win canvas
  pure ctx

registerKeyboardListener ∷ Window → Ref.Ref (Queue InputEvent) → Effect Unit
registerKeyboardListener win inputQ =
  let
    keyboardListenerEffect ∷ Effect EventListener
    keyboardListenerEffect = eventListener \evt →
      case KeyboardEvent.fromEvent evt of
        Nothing → pure unit
        Just kEvt →
          let
            key = KeyboardEvent.key kEvt
          in
            Ref.modify_ (\q → enqueue q (KeyDown (mapKey key))) inputQ
  in
    keyboardListenerEffect >>= \listener → addEventListener (EventType "keydown") listener false $ Window.toEventTarget
      win

registerResizeListener ∷ Window → CanvasElement → Ref.Ref (Queue InputEvent) → Effect Unit
registerResizeListener win canvas inputQ =
  let
    resizeListenerEffect ∷ Effect EventListener
    resizeListenerEffect = eventListener \_ → do
      Tuple newWidth newHeight ← resizeCanvas win canvas
      Ref.modify_ (\q → enqueue q (DragResize newWidth newHeight)) inputQ
  in
    resizeListenerEffect >>= \listener → addEventListener (EventType "resize") listener false $ Window.toEventTarget win

resizeCanvas ∷ Window → CanvasElement → Effect (Tuple Int Int)
resizeCanvas win canvas = do
  windowWidth ← Window.innerWidth win
  windowHeight ← Window.innerHeight win
  let
    Tuple newWidth newHeight = maintainAspectRatio windowWidth windowHeight
  setCanvasWidth canvas $ toNumber newWidth
  setCanvasHeight canvas $ toNumber newHeight
  pure $ Tuple newWidth newHeight

maintainAspectRatio ∷ Int → Int → Tuple Int Int
maintainAspectRatio windowWidth windowHeight =
  let
    targetWidth = 16
    targetHeight = 9
  in
    if windowWidth * targetHeight >= windowHeight * targetWidth then
      Tuple ((windowHeight * targetWidth) `div` targetHeight) windowHeight
    else
      Tuple windowWidth $ (windowWidth * targetHeight) `div` targetWidth

launchGame ∷ Window → Context2D → Ref.Ref (Queue InputEvent) → Effect Unit
launchGame win ctx inputQ = launchAff_ do
  map ← loadText "./4thwest.txt"
  windowWidth ← liftEffect $ Window.innerWidth win
  windowHeight ← liftEffect $ Window.innerHeight win
  let
    Tuple width height = maintainAspectRatio windowWidth windowHeight
    initialModel = { world: mkWorld map, visibleWidth: width, visibleHeight: height, seed: 0, elapsed: 0 }
  liftEffect $ gameLoop win ctx inputQ initialModel

gameLoop ∷ Window → Context2D → Ref.Ref (Queue InputEvent) → Model → Effect Unit
gameLoop win ctx inputQ model = do
  clearRect ctx { x: 0.0, y: 0.0, width: toNumber model.visibleWidth, height: toNumber model.visibleHeight }
  q ← Ref.read inputQ
  let model' = step q model
  render ctx $ view model'
  Ref.write emptyQueue inputQ
  void $ Window.requestAnimationFrame (gameLoop win ctx inputQ model') win

render ∷ Context2D → Frame → Effect Unit
render ctx frame = traverse_ loop frame
  where
  loop ∷ Draw → Effect Unit
  loop (Clear width height) = fillRect ctx { x: 0.0, y: 0.0, width, height }
  loop (DrawText (GridLoc x y) color s) = do
    setFillStyle ctx $ toCss color
    fillText ctx s (toNumber x * 16.0) (toNumber y * 16.0)
