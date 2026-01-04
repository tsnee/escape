module GameLogic (step, view) where

import Prelude

import Component (entities, lookup)
import Components.Positioned (Positioned(..))
import Data.Array (singleton)
import Data.Draw (Draw(..))
import Data.Entity (Entity)
import Data.InputEvent (InputEvent)
import Data.List.Lazy (foldl)
import Data.Maybe (Maybe, maybe)
import Data.Model (Model)
import Data.Queue (Queue)
import Data.String.CodeUnits as SCU
import Data.Traversable (foldMap)
import Data.Types (Action, Frame, Result)
import System (System)
import Systems (systems)

step ∷ Queue InputEvent → Model → Model
step inputQ model =
  let
    actions = foldl (plan model inputQ) [] systems
    results = foldl (execute model actions) [] systems
  in
    foldl (resolve model results) model systems

plan ∷ Model → Queue InputEvent → Array Action → System → Array Action
plan model inputQ acc system = acc <> system.plan model inputQ

execute ∷ Model → Array Action → Array Result → System → Array Result
execute model actions acc system = acc <> system.execute model actions

resolve ∷ Model → Array Result → Model → System → Model
resolve _ results model system = system.resolve model results

view ∷ Model → Frame
view { world } = toFrame entitySet
  where
  entitySet = entities world.entities
  toFrame = foldMap $ maybe [] singleton <<< drawEntity

  drawEntity ∷ Entity → Maybe Draw
  drawEntity e = do
    Positioned point ← lookup e world.positions
    visible ← lookup e world.visibles
    pure $ DrawText point visible.foreground $ SCU.singleton visible.glyph
