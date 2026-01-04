module Data.InputEvent (InputEvent(..)) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Data.Key (Key)

data InputEvent
  = KeyDown Key
  | DragResize Int Int

derive instance genericInputEvent :: Generic InputEvent _
instance showInputEvent :: Show InputEvent where
  show = genericShow
