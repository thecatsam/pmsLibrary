:Namespace                            
⍝ ∆F Utility and Library Loader (Dyalog ≥20 Version!)
⍝ Note: This is an UNNAMED namespace, so its name won't clutter the destination namespace, 
⍝ Run Load globalFi globalTempNs
⍝ - fi: a file with global variables, converting to a namespace, and then
⍝ - loads file g.SRC_FI (typically ∆FUtils.dyalog) as ⍙FUtils in dest ns, and  
⍝   establishes function ∆F in the dest ns.
⍝ THen ⍙FUtils, in turn, 
⍝ - loads other items needed based on the global variables passed.
⍝     ]load ∆F [-target=⎕SE]     or     ⊢⎕SE.⎕FIX '∆F.dyalog'

∇ {ok}← Load gFi 
  ;g; FILE  
  ⎕IO ⎕ML← 0 1 
  
  :Trap 0
    g← ⎕SE.∆FGlobals⍙Temp← 0 ⎕FIX FILE← gFi                  ⍝ Share globals via ⎕SE.⍙⍙FGlobals
    g.DEST_NS.⎕FIX⍠ 'FixWithErrors' 1⊣ FILE← g.SRC_FI        ⍝ Generate ⍙FUtils in destination
    ⎕DF (⍕g.DEST_NS),'.(∆F ∆FUtils) [',g.VERSION,']'         ⍝ Report ∆F info via ⎕DF
  :Else                                                      ⍝ Report error via ⎕DF
    ⎕DF '*** ERROR LOADING ∆F: ',⎕DMX.(EM,': ',Message),' "','"',⍨FILE       
  :EndTrap 
  ok← ⎕EX '⎕SE.∆FGlobals⍙Temp'                               ⍝ Remove ⎕SE.⍙⍙FGlobals even on failure.
∇
  Load '∆F/∆FGlobals.dyalog'
            
:EndNamespace ⍝ Unnamed
