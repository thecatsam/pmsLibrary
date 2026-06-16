:Namespace             ⍝ Unnamed NS. Won't clutter destination ns.                 
⍝ ∆F Utility and Library Loader (Dyalog ≥20 Version!).
⍝ Does minimal loading; makes globals available to ∆FUtils, which does rest of loading.
⍝ Run Load globalFi globalTempNs
⍝ - fi: a file with global variables, converting to a namespace, and then
⍝ - loads file g.SRC_FI (typically ∆FUtils.dyalog) as ⍙FUtils in dest ns, and  
⍝   establishes function ∆F in the dest ns.
⍝ THen ⍙FUtils, in turn, 
⍝ - loads other items needed based on the global variables passed.
⍝     ]load ∆F [-target=⎕SE]     or     ⊢⎕SE.⎕FIX '∆F.dyalog'
⍝ ---------------------------------------------

∇ {ok}← Load gFi 
  ;dest ;g; src; FILE  
  ⎕IO ⎕ML← 0 1 
  :Trap 0
    g← 0 ⎕FIX FILE← gFi                                ⍝ Load globals from file into ns <g>
    ⎕SE.∆F⍙Glob← g                                     ⍝ Share globals with  ∆FUtils
    src← g.KEEP_SRC_CM{                                ⍝ Opt'lly Delete comments/blank lines
      ⍺: ⍵                                  
      in out← ( '''[^'']*''' '\h*⍝(?!\!).*' '^\h*$' ) ( '&' '' '' )           
      t/⍨ 0≠≢¨t←  in ⎕R out ⊃⎕NGET ⍵ 1                 ⍝ (Keep ⍝! comments)
    } FILE←g.SRC_FI 
    dest← ⎕THIS.##
    dest.⎕FIX⍠ 'FixWithErrors' 0⊣ src             ⍝ Generate ∆FUtils in destination
    ⎕DF (⍕dest),'.∆FUtils [',g.VERSION,']'   ⍝ Report ∆F info via ⎕DF
  :Else                                                     
    ⎕DF {                                              ⍝ Report error via ⎕DF
      '*** ERROR LOADING ∆F: ',⎕DMX.(EM,': ',Message),' "',⍵, '"'
    } FILE       
  :EndTrap 
  ok← ⎕EX '⎕SE.∆F⍙Glob'                                ⍝ Remove globals ns even on failure.
∇
  Load '∆F/∆FGlobals.dyalog'
            
:EndNamespace ⍝ Unnamed
