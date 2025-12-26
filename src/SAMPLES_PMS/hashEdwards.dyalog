 h←{tradfn}hashEdwards str;s;int32;tradfn
 ⍝ Prof Edwards, San Diego State
 ⍝ https://www.youtube.com/watch?v=jtMwp0FqEcg&t=51s
 int32←(¯1+2*31)∘|
 g←31
 tradfn←0{0=⎕NC ⍵:⍺ ⋄ tradfn}'tradfn'
 :If tradfn
     h←⎕UCS⊃str
     :For s :In 1↓str
         h←int32(h×g)+⎕UCS s
     :EndFor
 :Else
     (⊃str)←⎕UCS⊃str
     h←{int32(⍵×g)+⎕UCS ⍺}/⌽str
 :EndIf
