module Data.Key (Key(..), RawKey, mapKey, class Keymap) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

type RawKey = String

data Key = UpperLeft | Up | UpperRight | Right | LowerRight | Down | LowerLeft | Left | Noop

derive instance Generic Key _
instance showKey ∷ Show Key where
  show = genericShow

class Keymap where
  mapKey ∷ RawKey → Key

instance viKeymap ∷ Keymap where
  mapKey "y" = UpperLeft
  mapKey "k" = Up
  mapKey "u" = UpperRight
  mapKey "l" = Right
  mapKey "n" = LowerRight
  mapKey "j" = Down
  mapKey "b" = LowerLeft
  mapKey "h" = Left
  mapKey _ = Noop
