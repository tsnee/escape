module Components.Visible (Visible(..)) where

import Data.Color (Color)

type Visible = { glyph ∷ Char, foreground ∷ Color, background ∷ Color }
