 ∆OR←{   ⍝ Sequential test.
     op←∨
     A W←2=⌊⎕NC'⍺⍺' '⍵⍵'
     ∆TRUE←{0=≢⍵:0 ⋄ 0∊⍴⍵:0 ⋄ (0=⍴⍴⍵)∧0=≡⍵:0≠⍵ ⋄ (,0)≢,⍵}
     A∧W:(∆TRUE ⍺⍺)op ∆TRUE ⍵⍵
     A:(∆TRUE ⍺⍺)op ∆TRUE ⍵⍵ ⍵
     W:(∆TRUE ⍵⍵)op ∆TRUE ⍺⍺ ⍵
     ∆TRUE ⍺⍺ ⍵:1 ⋄ ∆TRUE ⍵⍵ ⍵
 }
