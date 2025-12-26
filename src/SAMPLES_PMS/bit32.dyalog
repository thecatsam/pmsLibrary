 bit32←{
     bits←32
     bo←{
         chunk←{
             nb←-bits
             ⍺←⍬ ⋄ ∆←⍺,⍨⊂nb↑⍵ ⋄ bits<≢∊⍵:∆ ∇ nb↓⍵ ⋄ ∆
         }
         ⍺←-⊃⍵
         bits<≢⍵:∇¨chunk ⍵
         2⊥⍺,⍵
     }
     bi←{
         ∊⍉⍵⊤⍨bits⍴2
     }
     '⊤'≡⍬⍴⎕CR'⍺⍺':bi ⍵
     bo ⍵
     ⍺⍺
 }
