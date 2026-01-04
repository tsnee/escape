module Data.Result (Result(..)) where

import Data.GridLoc

import Data.Entity (Entity)

data Result = Moved Entity GridLoc
