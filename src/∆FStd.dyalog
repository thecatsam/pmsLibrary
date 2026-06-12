:Namespace                           ⍝ An unnamed ns 
⍝ See ∆F.dyalog. This one assumes all the defaults and has no error checking.

⍝ ∆F Utility and Library Loader...   
⍝ [*] Dyalog ≥20 Version!
⍝ Note: This is an UNNAMED namespace, so its name won't clutter the target namespace, 
⍝ while it loads (ns) ⍙FUtils and (fn) ∆F via, e.g.,
⍝    ]load ∆F [-target=⎕SE]     or     ⊢⎕SE.⎕FIX '∆F.dyalog'
⍝ ⍙FUtils in turn loads other items...

∇ {created}← Load GLOBAL_FI 
  PathAdd←  {(1∊⍷)/ ' ',¨' ',⍨¨ ⍵ ⍺: '' ⋄ 0=≢ ⍺: ⍵ ⋄ ' ', ⍵ }⍥('⎕se' ⎕R'\u&' ⍠1)∘⍕ 

  ⎕IO ⎕ML← 0 1
  g← 0 ⎕FIX GLOBAL_FI 
  ⎕SE.⍙⍙FGlobals← g                                  ⍝ Make globals <g> visible to <src> 
    :Trap 0
        g.DEST_NS.⎕FIX⍠ 'FixWithErrors' 1⊣ g.SRC_FI  
    :Else
        ⎕← '∆FStd: Unable to load source file ',g.SRC_FI  
    :EndTrap 
  ⎕EX '⎕SE.⍙⍙FGlobals' 
  ⎕PATH,← ⎕PATH PathAdd g.DEST_NS
  created← ⎕DF (⍕g.DEST_NS),'.∆F [',g.VERSION,'] Standard Version'
∇

  Load '∆F/∆FGlobals.dyalog'    
            
:EndNamespace ⍝ Unnamed
