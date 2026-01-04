module Data.Color (Channel, Color(..), black, blue, green, mkChannel, mkColor, red, toCss, white) where

import Prelude

import Data.Maybe (Maybe(..))

newtype Channel = Channel Int

instance showChannel ∷ Show Channel where
  show (Channel i) = show i

mkChannel ∷ Int → Maybe Channel
mkChannel x
  | x < 0 = Nothing
  | x > 255 = Nothing
  | otherwise = Just $ Channel x

unsafeMkChannel ∷ Int → Channel
unsafeMkChannel x = Channel x

type Color = { r ∷ Channel, g ∷ Channel, b ∷ Channel }

toCss ∷ Color → String
toCss { r, g, b } = "rgb(" <> show r <> "," <> show g <> "," <> show b <> ")"

mkColor ∷ Int → Int → Int → Maybe Color
mkColor rc gc bc = do
  r ← mkChannel rc
  g ← mkChannel gc
  b ← mkChannel bc
  pure { r, g, b }

unsafeMkColor ∷ Int → Int → Int → Color
unsafeMkColor rc gc bc = { r: unsafeMkChannel rc, g: unsafeMkChannel gc, b: unsafeMkChannel bc }

black ∷ Color
black = unsafeMkColor 0 0 0

blue ∷ Color
blue = unsafeMkColor 0 0 255

green ∷ Color
green = unsafeMkColor 0 255 0

red ∷ Color
red = unsafeMkColor 255 0 0

white ∷ Color
white = unsafeMkColor 255 255 255
