 {sp}←sp Line data;LIB;months
 ⍝    ... Line Plot ...
 :Trap 0
     LIB←sp.L
     sp.SetMargins 4⍴20
     sp.DrawLineGraph data
 :Else
     ⎕SIGNAL/⎕DMX.(EM EN)
 :EndTrap
