 Z←V ∆EA P ⍝ Emulate APLX ⎕ea
 Z←⍬
 :Trap 0
     :Trap 85 ⍝ ignore no result
         Z←⎕RSI[⎕IO].{0(85⌶)⍵}P
     :EndTrap
 :Else
     :Trap 0
         Z←⎕RSI[⎕IO].{0(85⌶)⍵}V
     :Else
         ⎕SIGNAL/⎕DMX.(EM EN)
     :EndTrap
 :EndTrap
