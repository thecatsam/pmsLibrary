:Namespace                           ⍝ An unnamed ns 
⍝ ∆F Utility and Library Loader...   
⍝ [*] Dyalog ≥20 Version!
⍝ Note: This is an UNNAMED namespace, so its name won't clutter the target namespace, 
⍝ while it loads (ns) ⍙FUtils and (fn) ∆F via, e.g.,
⍝    ]load ∆F [-target=⎕SE]     or     ⊢⎕SE.⎕FIX '∆F.dyalog'
⍝ ⍙FUtils in turn loads other items...

∇ {message}← Load GLOBAL_FI  ;g; FILE 
  ⎕IO ⎕ML← 0 1 ⋄ FILE← ''
  PathAdd←  {(1∊⍷)/ ' ',¨' ',⍨¨ ⍵ ⍺: '' ⋄ 0=≢ ⍺: ⍵ ⋄ ' ', ⍵ }⍥('⎕se' ⎕R'\u&' ⍠1)∘⍕ 
  Fi← { FILE⊢← ⍵ }

  :Trap 0
    ⎕SE.⍙⍙FGlobals← g← 0 ⎕FIX Fi GLOBAL_FI         ⍝ Make globals <g> visible to <src> 
    g.DEST_NS.⎕FIX⍠ 'FixWithErrors' 1⊣ Fi g.SRC_FI 
    ⎕PATH,← ⎕PATH PathAdd g.DEST_NS
    message← ⎕DF (⍕g.DEST_NS),'.∆F [',g.VERSION,'] Standard Version'
  :Else 
    message← ⎕DF '∆F ',⎕DMX.EM,': ',⎕DMX.Message,' ','"','"',⍨FILE  
  :EndTrap 
  ⎕EX '⎕SE.⍙⍙FGlobals' 
∇

  Load '∆F/∆FGlobals.dyalog'    
            
:EndNamespace ⍝ Unnamed
