module Data.Draw (Draw(..)) where

import Prelude

import Data.Color (Color)
import Data.Generic.Rep (class Generic)
import Data.Point (Point)
import Data.Show.Generic (genericShow)

data Draw
  = Clear
  | DrawText Point Color String

derive instance genericDraw :: Generic Draw _
instance showDraw :: Show Draw where
  show = genericShow
