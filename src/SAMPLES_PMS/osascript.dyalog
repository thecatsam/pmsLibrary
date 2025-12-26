 res←{prefix}osascript lines;cmd;dq;dqesc
 ⍝  lines: specify one or more lines
 ⍝ Example:
 ⍝  osascript 'button returned of (display dialog "It''s ',(⍕¯1↓⎕TS),'" buttons{"Wrong", "Right"})'
 ⍝            'text returned of (...)'
 ⍝ Example:
 ⍝    l1←'display dialog "Is 1+1=2?" buttons {"OK","Wow"}'
 ⍝    l1,←' default answer "Seems good to me" default button "Wow"'
 ⍝    l2←'set result to text returned of result'
 ⍝  osascript l1 l2
 ⍝
 ⍝ vol←osascript 'output volume of (get volume settings)'
 ⍝ osascript 'set volume output volume 55' 'say "Brilliant"'
 ⍝ osascript 'set volume output volume ',vol


 esc←{ ⍝ Escape double quotes and ensure a vec of vec
     dq←,'"' ⋄ dqesc←'\\',dq
     dq ⎕R dqesc⊣⊆⍵
 }
 show←{'UTF-8'⎕UCS ⎕UCS∊⍵}

 :If 0=⎕NC'prefix' ⋄ prefix←'-s o' ⋄ :EndIf
 lines←esc lines
 lines←(⊂'-e "'),¨lines,¨⊂'" '

 cmd←'osascript ',prefix,' ',∊lines

 :Trap 11
     res←show ⎕SH cmd
 :Else
     res←'ERROR'
 :EndTrap
