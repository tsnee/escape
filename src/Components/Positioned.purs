module Components.Positioned (Positioned(..)) where

import Prelude

import Data.GridLoc (GridLoc)

newtype Positioned = Positioned GridLoc

derive newtype instance showPositioned ∷ Show Positioned
