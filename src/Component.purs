module Component (Component(..), entities, lookup, mkComponent, replaceAt) where

import Data.Entity (Entity)
import Data.Foldable (class Foldable)
import Data.Map as Map
import Data.Maybe (Maybe)
import Data.Set (Set)
import Data.Tuple (Tuple)

type Component a = Map.Map Entity a

mkComponent ∷ ∀ a t. Foldable t ⇒ t (Tuple Entity a) → Component a
mkComponent = Map.fromFoldable

entities ∷ ∀ a. Component a → Set Entity
entities component = Map.keys component

lookup ∷ ∀ a. Entity → Component a → Maybe a
lookup = Map.lookup

replaceAt ∷ ∀ a. Entity → a → Component a → Component a
replaceAt = Map.insert
