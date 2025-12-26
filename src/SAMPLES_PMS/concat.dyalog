:namespace concat
 ⍝ Perform a few tests on concatenating
 ⍝         a,←b   a←a,b   a,⍨←b  a←a,⍨b
    ∇ (count each exemplar)←reset(count each);exemplar
      count⌈←1
      :If each=1 ⋄ exemplar←'!'
      :ElseIf each=2 ⋄ exemplar←'⍴'
      :Else ⋄ each←4 ⋄ exemplar←⎕UCS 65767      ⍝ '𐃧'
      :EndIf
      STR←count⍴exemplar,' count=',(⍕count),', each char=',(⍕each),' '
      APP1←APP2←PRE1←PRE2←CUT1←CUT2←PRECUT1←STR
    ∇
    reset 100 1
    ∇ count←append1 count
      APP1,←count⍴STR
    ∇

    ∇ count←append2 count
      APP2←APP2,count⍴STR
    ∇

    ∇ count←prepend1 count
      PRE1,⍨←count⍴STR
    ∇

    ∇ count←prepend2 count
      PRE2←PRE2,⍨count⍴STR
    ∇
    ∇ count←cut1 count
      CUT1↓⍨←-count
    ∇
    ∇ count←cut2 count
      CUT2←CUT2↓⍨-count
    ∇
    ∇ count←precut1 count
      PRECUT1↓⍨←count
    ∇

    ∇ test(initial extent each);calr;cmds;pfx;sfx;_
      calr←⊃⎕RSI
      :If 0=calr.⎕NC'cmpx'
          'cmpx'calr.⎕CY'dfns'
      :EndIf
      {}initial each _←reset initial each
       ⋄ pfx←⊂(⍕⎕THIS),'.'
       ⋄ cmds←8↑¨'append1' 'append2' 'prepend1' 'prepend2' 'cut1' 'cut2' 'precut1'
       ⋄ sfx←⊂' ',⍕extent
      ⎕←'Concatenation test'
      ⎕←'Initial size of string: ',(8 0⍕initial),' chars'
      ⎕←'Extent each cycle:      ',(8 0⍕extent),' chars',(extent=0)/' (nothing catenated)'
      ⎕←'Character size:         ',(8 0⍕each),' bytes'
      calr.cmpx pfx,¨cmds,¨sfx
    ∇


:endNamespace
