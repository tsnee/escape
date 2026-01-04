module Data.Queue (Queue, enqueue, make, toArray, toList) where

import Prelude

import Data.Array (fromFoldable)
import Data.List.Lazy (List, nil, reverse, (:))

data Queue a = Queue (List a)

instance showQueue :: Show a => Show (Queue a) where
  show (Queue xs) = show xs

make :: forall a. Queue a
make = Queue nil

enqueue :: forall a. Queue a -> a -> Queue a
enqueue (Queue xs) x = Queue $ x : xs

toArray :: Queue ~> Array
toArray (Queue xs) = (fromFoldable <<< reverse) xs

toList :: Queue ~> List
toList (Queue xs) = reverse xs
