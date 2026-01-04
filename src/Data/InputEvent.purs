module Data.InputEvent (InputEvent(..)) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Key (Key)
import Data.Show.Generic (genericShow)

data InputEvent
  = KeyDown Key
  | DragResize Int Int

derive instance genericInputEvent ∷ Generic InputEvent _
instance showInputEvent ∷ Show InputEvent where
  show = genericShow
