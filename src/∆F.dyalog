:Namespace  ⍝ Unnamed
⍝ ∆F Utility and Library Loader...
⍝ Note: This is an UNNAMED namespace, so its name won't clutter the target namespace, 
⍝ while it loads (ns) ⍙FUtils and (fn) ∆F via, e.g.,
⍝    ]load ∆F [-target=⎕SE]     or     +⎕SE.⎕FIX '∆F.dyalog'
  ⎕IO ⎕ML ⎕PW← 0 1 120 

  SRC_FI←         '∆F/∆FUtils.dyalog'
  DEST_NS←         ⎕THIS.##
  ADD_∆F_TO_PATH← 1                                    ⍝ If 1, adds ∆F to ⎕PATH.
  VERSION← 'v.0.1.1'

  ∇ {rc}← ⍙Load (srcFi destNs codeVersion add∆F2Path) 
    ; le; rc; dNm
    ; ReportQ; Err22; ErrAll; ErrApl; PathAdd; ∆SE 

    dNm← ⍕destNs 
    ⎕SIGNAL 0                                         ⍝ Clear ⎕DMX 
    ⎕DF dNm {                                         ⍝ ⎕DF val is returned by ⎕FIX or ]LOAD
      ⍺,'.∆F (library: ''',⍺,'.⍙FUtils'' ⋄ version: ''', ⍵,''')'
    } codeVersion
    rc← 0 

    ⋄ le← '❌❌❌ Load Error: '
    Err22←     srcFi∘{ 1: ⎕←le, 'File "',⍺,'" does not exist!'}
    ErrAll←    dNm∘{1: ⎕← le, 'Unable to create fn="',⍺,'.∆F" and/or ns="',⍺,'.⍙FUtils"'}
    ErrApl←    { 1: ⎕←'✅✅✅ APL ', ⍵.EM,': ',d1↑⍨ ' '⍳⍨ d1← 1⊃ ⍵.DM }  ⍝ ⍵: ⎕DMX 
    ∆SE←       '(?i)⎕se' ⎕R '⎕SE'                        ⍝ ⎕se => ⎕SE (lc => uc)
    PathAdd←   {s←' ' ⋄ (1∊⍷)/ s,¨s,⍨¨⍵ ⍺: '' ⋄ 0=≢ ⍺: ⍵ ⋄ s, ⍵ }⍥∆SE
    ReportQ←   {⍺: ⎕←'✅✅✅ Created namespace "',⍵,'.⍙FUtils"' ⋄ 1: _←0 }

    :Trap 0 
      :If ~⎕NEXISTS srcFi
          Err22⍬ ⋄ ErrAll⍬ ⋄ :Return   
      :EndIf 
      destNs.⎕FIX⍠ 'FixWithErrors' 0⊢ 'file://',srcFi                        
      :If 9 3∨.≠ destNs.⎕NC↑ '⍙FUtils' '∆F'           ⍝ Sanity check.  
          ErrAll⍬ ⋄ :Return   
      :EndIf 
      (destNs.⍙FUtils.VERBOSE_LOADTIME) ReportQ ⍕destNs 
      :If add∆F2Path
          ⎕PATH,← ⎕PATH PathAdd ⍕destNs 
      :EndIf 
      rc← 1  
    :Else
      ErrApl ⎕DMX ⋄ ErrAll⍬ ⋄ :Return 
    :EndTrap 
  ∇

  ⍙Load SRC_FI DEST_NS VERSION ADD_∆F_TO_PATH
:EndNamespace ⍝ Unnamed

