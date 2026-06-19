:Namespace              ⍝ Unnamed NS. Won't clutter destination ns.                 
⍝ ∆F Utility and Library Loader (Dyalog ≥20 Version!).
⍝ Does minimal loading; makes globals available to ∆FUtils, which does rest of loading.
⍝ Load gFi
⍝ - gFi: a file with global variables: '∆F/∆FGlobals.dyalog' ==> g (a local namespace)
⍝ - From g, gets name of the source for ∆F and its library,  g.SRC_FI (typically ∆FUtils.dyalog) 
⍝   as ∆FUtils  
⍝ - From g, gets name of the "library £" file libSrc
⍝ - Creates temporary namespace ⎕SE.⍙FShare to share <g> and the contents <libSrc>
⍝   establishes function ∆F in the dest ns.
⍝ - Establishes ∆FUtils
⍝ THen ⍙FUtils, in turn, 
⍝ - establishes ∆FUtils.libUtils
⍝ - loads other items needed based on the global variables passed.
⍝ --------------
⍝ To use: 
⍝     ]load ∆F [-target=⎕SE]     or     ⊢⎕SE.⎕FIX '∆F.dyalog'
⍝ ---------------------------------------------

∇ {ok}← Load gFi 
  ;dest ;g ;in; libsrc; out; src 
  ⎕IO ⎕ML← 0 1 
  dest← ⎕THIS.##
  :Trap 0
      g← 0 ⎕FIX  gFi                                    ⍝ Load globals from file into ns <g> 
      src libsrc← { ⊃⎕NGET ⍵ 1}¨ g.( SRC_FI LIB_SRC_FI ) 
      :If ~g.KEEP_SRC_CM
          in out← ( '''[^'']*''' '\h*⍝(?!\!).*' '^\h*$' )  ( '&' '' '' )
          src libsrc← { t/⍨ 0≠≢¨t← in ⎕R out⊢ ⍵ }¨ src libsrc 
      :EndIf 
      ⎕SE.∆F⍙Share← (globals: g ⋄ libsrc: libsrc)       ⍝ libsrc ⎕FIXed in ∆FUtils...
      dest.⎕FIX ⍠ 'FixWithErrors' 0⊣ src                ⍝ ⎕FIX ∆FUtils in <dest>
      ⎕DF (⍕dest),'.∆FUtils [',g.VERSION,']'            ⍝ Report ∆F info via ⎕DF
  :Else                                                     
      ⎕DF ∊⎕DMX.(                                       ⍝ Report error via ⎕DF
        '*** ERROR LOADING ∆F: ', EM, ': ', Message 
      )  
  :EndTrap 
  ok← ⎕EX '⎕SE.∆F⍙Share'                                ⍝ Remove globals ns even on failure.
∇
  Load '∆F/∆FGlobals.dyalog'
            
:EndNamespace ⍝ Unnamed
