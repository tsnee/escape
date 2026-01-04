module System (Phase(..), System(..)) where

import Data.InputEvent (InputEvent)
import Data.Model (Model)
import Data.Queue (Queue)
import Data.Types (Action, Result)

type Phase input output = Model → input → output

type System =
  { plan ∷ Phase (Queue InputEvent) (Array Action)
  , execute ∷ Phase (Array Action) (Array Result)
  , resolve ∷ Phase (Array Result) Model
  }
