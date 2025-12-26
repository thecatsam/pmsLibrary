 sorted←namesort;i;in;list;nl
 'enter input'
 in←''
 :While 0≠≢i←⍞ ⋄ in,←';',i ⋄ :End
 ⎕←'-------- output --------'
 list←';'(≠⊆⊢)in~' '
 sorted←list[⍋list]
 sorted←∊';',¨sorted

 nl←⎕UCS 13

 sorted←{p←80
     ⍺←''
     p≥≢⍵:1↓⍺,nl,⍵
     t←1+(⌽p↑⍵)⍳';'
     (⍺,nl,(p-t)↑⍵)∇(1⌈p-t)↓⍵
 }sorted
