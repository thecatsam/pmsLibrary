 r←(Af bind fA)w
 :Trap 0
   ⍝ If Af is ⎕NC 2, treat as (A∘f)w.
   ⍝ If fA is ⎕NC 2, treat as (f∘A)w, i.e. (w f A)
     r←(Af∘fA)w
 :Else
     :With ⎕DMX ⋄ EN ⎕SIGNAL⍨EM,': '{(0≠≢⍵)/⍺,⍵}Message ⋄ :EndWith
 :EndTrap
