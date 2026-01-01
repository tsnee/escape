module Data.Key (Key(..), RawKey, mapKey, class Keymap) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

type RawKey = String

data Key = Up | Down | Left | Right | Noop

derive instance Generic Key _
instance showKey :: Show Key where
  show = genericShow

class Keymap where
  mapKey :: RawKey -> Key

instance viKeymap :: Keymap where
  mapKey "k" = Up
  mapKey "j" = Down
  mapKey "h" = Left
  mapKey "l" = Right
  mapKey _ = Noop
