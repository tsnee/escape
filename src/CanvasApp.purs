module CanvasApp where

import Prelude

import Data.Color (toCss)
import Data.Draw (Draw(..))
import Data.InputEvent (InputEvent(..))
import Data.Int (toNumber)
import Data.Key (mapKey)
import Data.Maybe (Maybe(..))
import Data.Model (Model)
import Data.GridLoc (GridLoc(..))
import Data.Queue (Queue, enqueue, make)
import Data.Traversable (traverse_)
import Data.Types (Frame)
import Data.World (mkWorld)
import Effect (Effect)
import Effect.Ref (write)
import Effect.Ref as Ref
import GameLogic (step, view)
import Graphics.Canvas (CanvasElement, Context2D, clearRect, fillRect, fillText, getCanvasElementById, getContext2D, setFillStyle, setFont)
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (EventListener, addEventListener, eventListener)
import Web.HTML (Window)
import Web.HTML as HTML
import Web.HTML.Window as Window
import Web.UIEvent.KeyboardEvent as KeyboardEvent

main :: Effect Unit
main = do
  win <- HTML.window
  elemM <- getCanvasElementById "canvas"
  case elemM of
    Nothing -> Window.alert "This HTML does not contain a canvas element with id 'canvas'." win
    Just canvas -> do
      inputQ <- Ref.new make
      ctx <- initialize win canvas inputQ
      gameLoop win ctx inputQ

initialize :: Window -> CanvasElement -> Ref.Ref (Queue InputEvent) -> Effect Context2D
initialize win canvas inputQ = do
  ctx <- getContext2D canvas
  setFont ctx "16px monospace"
  registerKeyboardListener win inputQ
  registerResizeListener win inputQ
  pure ctx

registerKeyboardListener :: Window -> Ref.Ref (Queue InputEvent) -> Effect Unit
registerKeyboardListener win inputQ =
  let
    keyboardListenerEffect :: Effect EventListener
    keyboardListenerEffect = eventListener \evt ->
      case KeyboardEvent.fromEvent evt of
        Nothing -> pure unit
        Just kEvt ->
          let
            key = KeyboardEvent.key kEvt
          in
            Ref.modify_ (\q -> enqueue q (KeyDown (mapKey key))) inputQ
  in
    keyboardListenerEffect >>= \listener -> addEventListener (EventType "keydown") listener false $ Window.toEventTarget win

registerResizeListener :: Window -> Ref.Ref (Queue InputEvent) -> Effect Unit
registerResizeListener win inputQ =
  let
    resizeListenerEffect :: Effect EventListener
    resizeListenerEffect = eventListener \_ -> do
      newWidth <- Window.innerWidth win
      newHeight <- Window.innerHeight win
      Ref.modify_ (\q -> enqueue q (Resize newWidth newHeight)) inputQ
  in
    resizeListenerEffect >>= \listener -> addEventListener (EventType "resize") listener false $ Window.toEventTarget win

gameLoop :: Window -> Context2D -> Ref.Ref (Queue InputEvent) -> Effect Unit
gameLoop win ctx inputQ = initialModelEffect >>= loop
  where
  initialModelEffect = do
    width <- Window.innerWidth win
    height <- Window.innerHeight win
    pure { world: mkWorld, visibleWidth: width, visibleHeight: height, seed: 0, elapsed: 0 }

  loop :: Model -> Effect Unit
  loop model = do
    clearRect ctx { x: 0.0, y: 0.0, width: toNumber model.visibleWidth, height: toNumber model.visibleHeight }
    q <- Ref.read inputQ
    -- log $ "InputQueue: " <> show q
    let
      model' = step q model
      frame = view model'
    -- log $ "Frame: " <> show frame
    render ctx frame
    write make inputQ
    void $ Window.requestAnimationFrame (loop model') win

render :: Context2D -> Frame -> Effect Unit
render ctx frame = traverse_ loop frame
  where
  loop :: Draw -> Effect Unit
  loop (Clear width height) = fillRect ctx { x: 0.0, y: 0.0, width, height }
  loop (DrawText (GridLoc x y) color s) = do
    setFillStyle ctx $ toCss color
    fillText ctx s (toNumber x * 16.0) (toNumber y * 16.0)
