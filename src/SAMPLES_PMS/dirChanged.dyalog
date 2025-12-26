 ret←dirChanged name;sort
 sort←{l←⊃⍵ ⋄ ⊃l[⍒l]}
 :If (¯2↑name)≢'/*' ⋄ name,←'/*' ⋄ :EndIf

 :Trap 0 1000
     old←sort 3(⎕NINFO⍠1)name

     ok←1
     :While ok
         ⎕DL 5
         new←sort 3(⎕NINFO⍠1)name
         ⍝ ⎕←'new ',new
         :If new≢old
             'The file or directory has changed: ',name
             ret←1 ⋄ :Return
         :EndIf
     :EndWhile
 :Else
     :If ⎕EN≤1000
         'Error tracking file ',name
         ret←0
     :Else
         'Interrupted by user tracking file/dir ',name
         ret←¯1
     :EndIf
 :EndTrap
