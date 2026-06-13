:Namespace                            
⍝ ∆F Utility and Library Loader (Dyalog ≥20 Version!)
⍝ Note: This is an UNNAMED namespace, so its name won't clutter the destination namespace, 
⍝ Run Load <fi>
⍝ - fi: a file with global variables, converting to a namespace, and then
⍝ - loads file g.SRC_FI (typically ∆FUtils.dyalog) as ⍙FUtils in dest ns, and  
⍝   establishes function ∆F in the dest ns.
⍝ THen ⍙FUtils, in turn, 
⍝ - loads other items needed based on the global variables passed.
⍝ How to load:
⍝     ]load ∆F [-target=⎕SE]     or     ⊢⎕SE.⎕FIX '∆F.dyalog'

∇ {ok}← Load gFi  
  ;g; PathAdd; FILE 
  ⎕IO ⎕ML← 0 1 
  PathAdd←  {(1∊⍷)/ ' ',¨' ',⍨¨ ⍵ ⍺: '' ⋄ 0=≢ ⍺: ⍵ ⋄ ' ', ⍵ }⍥('⎕se' ⎕R'\u&' ⍠1)∘⍕ 
  :Trap 0
    g← ⎕SE.⍙⍙FGlobals← 0 ⎕FIX FILE← gFi                      ⍝ Share globals via ⎕SE.⍙⍙FGlobals
    g.DEST_NS.⎕FIX⍠ 'FixWithErrors' 1⊣ FILE← g.SRC_FI        ⍝ Generate ⍙FUtils in destination
    ⎕PATH,← ⎕PATH PathAdd g.DEST_NS                          ⍝ Add dest NS to ⎕PATH
    ⎕DF (⍕g.DEST_NS),'.(∆F ⍙FUtils) [',g.VERSION,']'         ⍝ Report ∆F info via ⎕DF
  :Else    
    ⎕DF '∆F ',⎕DMX.EM,': ',⎕DMX.Message,' ','"','"',⍨FILE    ⍝ Report error via ⎕DF
  :EndTrap 
  ok← ⎕EX '⎕SE.⍙⍙FGlobals'                                   ⍝ Remove ⎕SE.⍙⍙FGlobals even on failure.
∇
  Load '∆F/∆FGlobals.dyalog'    
            
:EndNamespace ⍝ Unnamed
