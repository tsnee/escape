module Data.Queue (Queue(..), enqueue, emptyQueue, toArray, toList) where

import Prelude

import Data.Array (fromFoldable)
import Data.Foldable (class Foldable)
import Data.List.Lazy (List, nil, reverse, (:))

newtype Queue a = Queue (List a)

derive newtype instance foldableQueue ∷ Foldable Queue
derive newtype instance showQueue ∷ Show a ⇒ Show (Queue a)

emptyQueue ∷ ∀ a. Queue a
emptyQueue = Queue nil

enqueue ∷ ∀ a. Queue a → a → Queue a
enqueue (Queue xs) x = Queue $ x : xs

toArray ∷ Queue ~> Array
toArray (Queue xs) = (fromFoldable <<< reverse) xs

toList ∷ Queue ~> List
toList (Queue xs) = reverse xs
