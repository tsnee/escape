module Data.GridLoc (GridLoc(..)) where

import Prelude

data GridLoc = GridLoc Int Int

instance showGridLoc :: Show GridLoc where
  show (GridLoc x y) = "<" <> show x <> "," <> show y <> ">"
