module Systems.Resize (resize) where

import Prelude

import Data.InputEvent (InputEvent(..))
import Data.List.Lazy (foldl)
import Data.Model (Model)
import Data.Queue (Queue, toArray)
import Data.Types (Action(..), Result(..))
import System (Phase, System)

resize ∷ System
resize = { plan, execute, resolve }

plan ∷ Phase (Queue InputEvent) (Array Action)
plan _ inputQ = bind (toArray inputQ) f
  where
  f ∷ InputEvent → Array Action
  f (DragResize x y) = [ ResizeCanvas x y ]
  f _ = []

execute ∷ Phase (Array Action) (Array Result)
execute _ actions = bind actions f
  where
  f ∷ Action → Array Result
  f (ResizeCanvas x y) = [ ResizedCanvas x y ]
  f _ = []

resolve ∷ Phase (Array Result) Model
resolve model results = foldl f model results
  where
  f ∷ Model → Result → Model
  f m (ResizedCanvas x y) = m { visibleWidth = x, visibleHeight = y }
  f m _ = m
