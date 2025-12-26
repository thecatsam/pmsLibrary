 r←{a}(f atop g)w
 :Trap 0
     :If 0=⎕NC'a'
         r←f g w
     :Else
         r←f a g w
     :EndIf
 :Else
     :With ⎕DMX ⋄ EN ⎕SIGNAL⍨EM,': '{(0≠≢⍵)/⍺,⍵}Message ⋄ :EndWith
 :EndTrap
