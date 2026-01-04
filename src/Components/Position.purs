module Components.Position (Position(..)) where

import Data.GridLoc (GridLoc)

newtype Position = Position GridLoc
