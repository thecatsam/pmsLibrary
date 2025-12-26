 bigIntTest;A;B;S;c1;c2;cL1;cL2;code;ix;l;prep;r;sink;src;vars;⎕FR;⎕IO
 ⎕FR←1287 ⋄ ⎕IO←0

 vars←'A' 'B' 'S' 'E'
 A←?BIX 30⍴'9' ⋄ B←'¯',?BIX 29⍴'9' ⋄ S←?BIX'99999' ⋄ E←?BIX'99'
 'A:  ',A
 'B: ',B
 'S: ',S
 'E: ',E

 cL1←'A+B' 'A-B' 'B-A' 'A--B' 'B--A' 'S*E' 'S*0.5' 'A÷3' 'B÷3' 'A÷B' 'B÷A'
 cL1,←'A*0.5' 'S|A×S'

  ⋄ prep←{⍺,⍵,⍺}
 src←(⊂'\b')prep¨vars ⋄ sink←' 'prep¨⍎¨vars
 cL2←src ⎕R sink⊢cL1

 :For ix :In ⍳≢cL1
     c1 c2←⊃¨ix⌷¨cL1 cL2
     :Trap 0
         l←{(×⍵)×⌊|⍵}⍎code←c2
     :Else
         ⎕←(30↑c1),' failed: unable to execute.'
         ⎕←'  Code: ',code
         :Continue
     :EndTrap
     :Trap 0
         r←⍎BIX⍎code←0 BIC c2
     :Else
         ⎕←(30↑c1),' failed: unable to execute.'
         ⎕←'  Code: ',code
         :Continue
     :EndTrap
     :If l≡r
         ⎕←(30↑c1),' passed'
     :ElseIf l{0::0 ⋄ 0.001≥|(⍺-⍵)÷(|⍺)⌈|⍵}r
         ⎕←(30↑c1),' passed: APL and bigInt calcs are within 0.1%'
     :Else
         ⎕←(30↑c1),' failed. APL and bigInt calculations differ.'
         ∘
     :EndIf
 :EndFor
