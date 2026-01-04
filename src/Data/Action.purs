module Data.Action (Action(..)) where

import Data.Entity (Entity)
import Data.GridLoc (GridLoc)

data Action = Move Entity GridLoc
