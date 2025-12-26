 r←{a}(f beside g)w
 :Trap 0
     :If 0=⎕NC'a'
         r←f∘g w
     :Else
         r←a f∘g w
     :EndIf
 :Else
     :With ⎕DMX ⋄ EN ⎕SIGNAL⍨EM,': '{(0≠≢⍵)/⍺,⍵}Message ⋄ :EndWith
 :EndTrap
