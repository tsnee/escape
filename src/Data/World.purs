module Data.World (World(..), WorldBuilder(..), build, empty) where

import Prelude

import Component (Component, mkComponent)
import Components.Positioned (Positioned)
import Components.Visible (Visible)
import Data.Entity (Entity(..))
import Data.List.Lazy (nil)
import Data.Queue (Queue(..))
import Data.Tuple (Tuple)
import Data.Types (PlayerControlled)

type World =
  { entities ∷ Component Unit
  , players ∷ Component PlayerControlled
  , positions ∷ Component Positioned
  , visibles ∷ Component Visible
  }

type WorldBuilder =
  { entities ∷ Queue (Tuple Entity Unit)
  , players ∷ Queue (Tuple Entity PlayerControlled)
  , positions ∷ Queue (Tuple Entity Positioned)
  , visibles ∷ Queue (Tuple Entity Visible)
  , nextEntity ∷ Entity
  }

empty ∷ WorldBuilder
empty = { entities: Queue nil, players: Queue nil, positions: Queue nil, visibles: Queue nil, nextEntity: Entity 0 }

build ∷ WorldBuilder → World
build builder = { entities, players, positions, visibles }
  where
  entities = mkComponent builder.entities
  players = mkComponent builder.players
  positions = mkComponent builder.positions
  visibles = mkComponent builder.visibles
