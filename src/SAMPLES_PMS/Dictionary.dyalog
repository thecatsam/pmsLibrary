 {ans}←dict word;ans;state;raw;CTL;DEF;trim
 CTL DEF←0 1
 trim←{⍵↓⍨-+/∧\⌽' '=⍵}
 raw←⎕SH'curl dict://dict.org/d:',word~' '
 state←CTL
 ans←⍬
 :For line :In raw
     :Select state
     :Case CTL
         :If '151 '≡4↑line
             state←DEF
             ans,←⊂4↓line
         :EndIf
     :Case DEF
         :If '.'=1↑line
             state←CTL
         :ElseIf 0≠≢line~' '
             ans,←⊂line
         :EndIf
     :EndSelect
 :EndFor
 ans←∊ans
 ⎕ED'ans'
