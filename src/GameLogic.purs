module GameLogic (step, view) where

import Prelude

import Components.Position (Position(..))
import Data.Array ((!!))
import Data.Draw (Draw(..))
import Data.Entity (Entity, getIndex)
import Data.InputEvent (InputEvent)
import Data.List.Lazy (foldl)
import Data.Maybe (Maybe)
import Data.Model (Model)
import Data.Queue (Queue)
import Data.String.CodeUnits as SCU
import Data.Types (Action, Frame, Result)
import Data.Unfoldable (fromMaybe)
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
resolve model results _ system = system.resolve model results

view ∷ Model → Frame
view { world } = bind world.entities $ fromMaybe <<< drawEntity
  where
  drawEntity ∷ Entity → Maybe Draw
  drawEntity e = do
    Position point ← world.positions !! (getIndex e)
    visible ← world.visibles !! (getIndex e)
    pure $ DrawText point visible.foreground $ SCU.singleton visible.glyph
