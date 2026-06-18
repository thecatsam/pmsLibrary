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
  ;dest ;f ;g ;in; out; src; libsrc; share; ss  
  ⎕IO ⎕ML← 0 1 
  share← ⎕SE.∆F⍙Share← ( globals: ⍬ ⋄ libsrc: ⍬) 
  :Trap 0
      g← 0 ⎕FIX f← gFi                                  ⍝ Load globals from file into ns <g> 
      ss← g.(SRC_FI LIB_SRC_FI) 
      :If g.KEEP_SRC_CM
          src libsrc← {⊃⎕NGET ⍵ 1} ss 
      :Else 
          in out← ( '''[^'']*''' '\h*⍝(?!\!).*' '^\h*$' )  ( '&' '' '' )
          r← in ⎕R out¨  ss 
          src libsrc← { t/⍨ 0≠≢¨t← ⊃⎕NGET ⍵ 1 }¨r
      :EndIf 
      share.( globals libsrc )← g libsrc                ⍝ libsrc ⎕FIXed in ∆FUtils...
      dest← ⎕THIS.##
      dest.⎕FIX ⍠ 'FixWithErrors' 0⊣ src                ⍝ ⎕FIX ∆FUtils in <dest>
      ⎕DF (⍕dest),'.∆FUtils [',g.VERSION,']'            ⍝ Report ∆F info via ⎕DF
  :Else                                                     
      ⎕DF ⎕DMX.( '*** ERROR LOADING ∆F: ', EM, ': ', Message ) ⍝ Report error via ⎕DF
  :EndTrap 
  ok← ⎕EX '⎕SE.∆F⍙Share'                                ⍝ Remove globals ns even on failure.
∇
  Load '∆F/∆FGlobals.dyalog'
            
:EndNamespace ⍝ Unnamed
