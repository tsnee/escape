module Data.Draw (Draw(..)) where

import Prelude

import Data.Color (Color)
import Data.Generic.Rep (class Generic)
import Data.GridLoc (GridLoc)
import Data.Show.Generic (genericShow)

data Draw
  = Clear Number Number
  | DrawText GridLoc Color String

derive instance genericDraw ∷ Generic Draw _
instance showDraw ∷ Show Draw where
  show = genericShow
