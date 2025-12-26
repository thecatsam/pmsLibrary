 {active}←duckClean class;duckPat;m;active;active2;activePat
 :Trap 0
     :If ~class∊0 1 2 ⋄ goto badClass ⋄ :EndIf
 :Else
badClass:
     'duckClean class: class must be 1 (kill processes) or 0 (show processes)'⎕SIGNAL 11
 :EndTrap

 activePat←'/Applications/Dyalog-17.1.app/Contents/MacOS/Dyalog-17.1'
 active2←⊃⌽⎕VFI∊⎕SH'ps -Ax | grep ''',activePat,''' | grep -v grep | egrep -e ''^\s*\d+\s'' -o'
 active←⍬

 :While active≢active2
     active←active2
     active2←∪active2,⊃⌽⎕VFI⍕⎕SH'pgrep -aP ',¯1↓∊(⍕¨active2),¨','
 :EndWhile


 ⎕←'My active tasks: ',active[⍋active]

 :If class=2
 :OrIf (class=1)∧1∊'yY'∊⍞↓⍨≢⍞←'Kill all other active tasks? [no] '
     :Trap 11  ⍝ Domain
         ⎕SH'kill -9 ',⍕active
         'Complete'
     :Else
         ↑⎕DMX
     :EndTrap
 :Else
     ⎕←'No action taken.'
 :EndIf
