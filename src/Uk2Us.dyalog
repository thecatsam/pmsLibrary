r←Uk2Us in
;nm;uk;us;out
;⎕IO

⎕IO←0

nm←⎕SE.UCMD'get https://github.com/dwyl/english-words/blob/master/uk-us-dict.txt:n'
uk us←↓⍉↑' '(≠⊆⊢)¨1↓⎕C ⎕OR nm

Find←{u1 u2←⍺
    p←u1⍳⊂⍵
    p≥≢u1:0 0
    1(p⊃u2)
}

:If ⊃ok out←uk us Find in
    r←in,out,⍨' => US '
:ElseIf ⊃ok out←us uk Find in
    r←in,out,⍨' => UK '
:Else
    r←'Not found'
:EndIf

⎕EX nm
