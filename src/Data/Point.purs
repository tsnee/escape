module Data.Point (Point(..)) where

import Prelude

data Point = Point Int Int

instance showPoint :: Show Point where
  show (Point x y) = "<" <> show x <> "," <> show y <> ">"
