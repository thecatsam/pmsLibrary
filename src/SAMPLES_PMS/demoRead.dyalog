 demoRead promptFlag;ff;fg;fileGen;nread;nskipped;text;wid
 ;f;filesIn;filesOut;f∆;prompt

 'Enter files to read [including wildcards, if any], separated by colons: '
 prompt←'Files: '
 :If promptFlag←0
     filesIn←⍞↓⍨≢⍞←prompt
 :Else
     prompt,filesIn←'../Downloads/*:../Google Drive/*'
 :EndIf

 filesIn←':'{⍵⊆⍨~⍵∊⍺}filesIn
 ⍝ 'Files are',1↓∊' ',¨filesIn
⍝  filesOut←⍬
⍝  :For f :In filesIn
⍝      f∆←⊃(⎕NINFO⍠1⍠'Recurse' 1)f
⍝      :If 0≠≢f∆
⍝          ⎕←'Accepting ',(≢f∆),' files "',f,'"'
⍝          filesOut,←f∆
⍝      :Else
⍝          ⎕←'File spec didn''t match anything. Ignored: ',f
⍝      :EndIf
⍝  :EndFor
 fileGen←{
     0=≢⍵:⎕NULL
     f∆←⊃(⎕NINFO⍠1⍠'Recurse' 1)⍵
     0≠≢f∆:⍺ ∇ 1↓⍵⊣⍺.yield¨f∆
     ⍺ ∇ 1↓⍵
 }
 fg←fileGen gen.erator filesIn

 ⍝⎕←'Scanning ',(≢filesOut),' files'

 (10↑'nlines'),'Filename'
 nskipped nread←0
 :Trap 1000
     :While fg.more
         ff←fg.next ⋄ ff~←⎕UCS 10 13 133
         :If (wid←⎕PW-8)<≢ff
             ff←(ff↑⍨⌊¯1+wid÷2),'…',ff↑⍨-⌈wid÷2
         :EndIf
         :Trap 0
             nlines←≢⊃⎕NGET f 1
             (7↑6 0⍕nlines),ff
             nread+←1
         :Else
             nskipped+←1
         ⍝ (7↑'??????'),ff
         :EndTrap
     :EndWhile
 :EndTrap
 'Files read:    ',nread
 'Files skipped: ',nskipped
