 ∆AND←{   ⍝ Sequential test.
 ⍝ Python-style TRUE
 ⍝ Most Values are True
 ⍝ Almost any value is evaluated to True if it has some sort of content.
 ⍝ Any string is True, except empty strings.
 ⍝ Any number is True, except 0.
 ⍝ Any list, tuple, set, and dictionary are True, except empty ones.
     ∆TRUE←{0=≢⍵:0 ⋄ 0∊⍴⍵:0 ⋄ (0=⍴⍴⍵)∧0=≡⍵:0≠⍵ ⋄ (,0)≢,⍵}
     op←∧
     A W←2=⌊⎕NC'⍺⍺' '⍵⍵'
     A∧W:(∆TRUE ⍺⍺)op ∆TRUE ⍵⍵
     A:(∆TRUE ⍺⍺)op ∆TRUE ⍵⍵ ⍵
     W:(∆TRUE ⍵⍵)op ∆TRUE ⍺⍺ ⍵
     ∆TRUE ⍺⍺ ⍵:∆TRUE ⍵⍵ ⍵ ⋄ 0
 }
