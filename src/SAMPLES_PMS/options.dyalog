 options←{
   ⍝ Revised options:
   ⍝ ⍺:   [-f[orce]] [-lib libNs]  [-caller callerNs] [-r[eturns] [status|libNs|all]] [-d[ebug]]
   ⍝ Or if first item of ⍵ has depth >1, it will be used for ⍺, if ⍺ is omitted.
   ⍝ Format
   ⍝  [1]   '-force' '-lib=' libNs '-caller=' callerNs '-returns=[s|l|a]' '-debug'
   ⍝  [2]   libNs (a single arg of type=9)
     ⍺←⍬
     opts pkgs←⍺{⍺≢⍬:(,⊆⍺)⍵ ⋄ 2≤|≡⍵:(,⊆⊃⍵)(1↓⍵) ⋄ (,⊆⍵)⍵}⍵
     force←0 ⋄ caller←(0⊃⎕RSI) ⋄ lib←⍬ ⋄ returns←'status' ⋄ debug←0
     _←{
         (1=≢opts)∧9=⎕NC'oSc'⊣oSc←⍬⍴opts:⊢lib∘←oSc
         {
             opt←2↑⍵⊃opts
             '-f'≡opt:⊢force∘←1
             '-l'≡opt:⊢lib∘←(⍵+1)⊃opts
             '-c'≡opt:⊢caller∘←(⍵+1)⊃opts
             '-r'≡opt:⊢returns∘←⊃⌽'-r[^=]*=\h*(.)'⎕S'\1'⊣⍵⊃opts
             '-d'≡opt:⊢debug∘←1
             ⍬
         }¨⍳≢⍵
     }opts
     caller←{0::'Invalid -caller'⎕SIGNAL 11
         ns←⍵ ⋄ 9=⎕NS'ns':ns ⋄ ns←⍎ns ⋄ 9=⎕NS'ns':ns
         ∘∘
     }caller

     returns←{⍵∊'sla':⍵ ⋄ 'Invalid -returns'⎕SIGNAL 11}returns
     lib←{0::'Invalid -library'⎕SIGNAL 11
         ⍵=⍬:⍎'⍙⍙.require'caller.⎕NS''
         ns←⍵ ⋄ 9=⎕NC'ns':ns ⋄ ns←⍎ns ⋄ 9=⎕NC'ns':ns
         ○○
     }lib
     pkgs force lib caller returns debug
 }
