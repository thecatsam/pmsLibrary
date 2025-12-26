 lcmp←{
   ⍝ bool ← ⍺  ⍺⍺ lcmp ⍵
   ⍝ Performs a lexical comparison:
   ⍝ ⍺ <lcmp ⍵ checks if ⍺ is lexically less than ⍵
   ⍝ ⍺⍺ may be <, ≤, =, ≥ > ≠
     ⍺⍺/</∘⍋¨1 0⌽¨⊂⍺ ⍵
 }
