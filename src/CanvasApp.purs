module CanvasApp where

import Prelude

import Data.Color (toCss)
import Data.Draw (Draw(..))
import Data.InputEvent (InputEvent(..))
import Data.Int (toNumber)
import Data.Key (mapKey)
import Data.Maybe (Maybe(..))
import Data.Model (Model)
import Data.Point (Point(..))
import Data.Queue (Queue, enqueue, make)
import Data.Traversable (traverse_)
import Data.Tuple (Tuple(..))
import Data.Types (Frame)
import Data.World (mkWorld)
import Effect (Effect)
import Effect.Console (log)
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
  elemM <- getCanvasElementById "canvas"
  case elemM of
    Nothing -> log "This HTML does not contain a canvas element with id 'canvas'."
    Just canvas -> do
      inputQ <- Ref.new make
      Tuple w ctx <- initialize canvas inputQ
      gameLoop w ctx inputQ

initialize :: CanvasElement -> Ref.Ref (Queue InputEvent) -> Effect (Tuple Window Context2D)
initialize canvas inputQ = do
  w <- HTML.window
  ctx <- getContext2D canvas
  setFont ctx "16px monospace"
  registerKeyboardListener w inputQ
  pure $ Tuple w ctx

registerKeyboardListener :: Window -> Ref.Ref (Queue InputEvent) -> Effect Unit
registerKeyboardListener w inputQ =
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
    keyboardListenerEffect >>= \listener -> addEventListener (EventType "keydown") listener false $ Window.toEventTarget w

gameLoop :: Window -> Context2D -> Ref.Ref (Queue InputEvent) -> Effect Unit
gameLoop w ctx inputQ = loop initialModel
  where
  initialWorld = mkWorld
  initialModel = { world: initialWorld, seed: 0, elapsed: 0 }

  loop :: Model -> Effect Unit
  loop model = do
    clearRect ctx { height: 450.0, width: 800.0, x: 0.0, y: 0.0 }
    q <- Ref.read inputQ
    -- log $ "InputQueue: " <> show q
    let
      model' = step q model
      frame = view model'
    -- log $ "Frame: " <> show frame
    render ctx frame
    write make inputQ
    void $ Window.requestAnimationFrame (loop model') w

render :: Context2D -> Frame -> Effect Unit
render ctx frame = traverse_ loop frame
  where
  loop :: Draw -> Effect Unit
  loop Clear = fillRect ctx { x: 0.0, y: 0.0, width: 800.0, height: 450.0 }
  loop (DrawText (Point x y) color s) = do
    setFillStyle ctx $ toCss color
    fillText ctx s (toNumber x * 16.0) (toNumber y * 16.0)
