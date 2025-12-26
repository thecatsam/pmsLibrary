 f←∆IN;counter;k;fName;line;lines;more

 lines←⍬ ⋄ counter←0
 :While 1
     k←≢⍞←'[',(⍕counter←counter+1),'] '
     :If 0≠≢line←k↓⍞
         lines,←⊂line
     :Else
         :Leave
     :EndIf
 :EndWhile

 fName←(f←'__temp__'),'.dyalog'
 :If ×≢lines
     1 ⎕NDELETE fName
     lines←(⊂'∇temp'),lines,(⊂,'∇')
     (⊂lines)⎕NPUT fName
     ⎕←↑⊃⎕NGET fName 1
 :Else
     :If ⎕NEXISTS fName
         ⎕←↑⊃⎕NGET fName 1
     :Else
         fName←⍬
     :EndIf
 :EndIf
