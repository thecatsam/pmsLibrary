 out←scan line
 ;LAST;LBRK;LPAR;QUOT;RBRK;RPAR;SEMI
 ;cur_ch;cur_gov;deQ;enQ;inQt;stk
 ;⎕IO;⎕ML

 ⎕IO ⎕ML←0 1
 QUOT←'''' ⋄ SEMI←';'
 LPAR RPAR LBRK RBRK←'()[]'
 stk←⎕NS ⍬
 stk.(govern lparIx sawSemi)←,¨' ' 0 0   ⍝ stacks
 out←,''

 deQ←{stk.(govern lparIx sawSemi↓⍨←-⍵)}     ⍝ deQ 1|0
 enQ←{stk.((govern lparIx)sawSemi,←⍵ 0)}    ⍝ enQ gNew lNew

 :For cur_ch :In line
     cur_gov←⊃⌽stk.govern
     inQt←QUOT=cur_gov
     :If inQt
         deQ QUOT=cur_ch
     :Else
         :Select cur_ch
         :Case LPAR ⋄ enQ cur_ch(≢out)
         :Case LBRK ⋄ enQ cur_ch(≢out)
         :Case RPAR ⋄ out,←(1+⊃⌽stk.sawSemi)/RPAR ⋄ deQ 1 ⋄ :Continue
         :Case RBRK ⋄ deQ 1
         :Case QUOT ⋄ enQ cur_ch ¯1
         :Case SEMI
             :Select cur_gov
             :Case LPAR ⋄ out,←') (' ⋄ out[⊃⌽stk.lparIx]←⊂2/LPAR ⋄ (⊃⌽stk.sawSemi)←1 ⋄ :Continue
             :Case LBRK ⍝ Not special
             :Else ⋄ out,←') (' ⋄ (⊃stk.sawSemi)←1 ⋄ :Continue
             :EndSelect
         :EndSelect
     :EndIf
     out,←cur_ch
 :EndFor

 out←∊out
 :If (⊃stk.sawSemi)     ⍝ semicolon(s) seen at top level (outside parens and brackets)
     out←'((',out,'))'
 :EndIf
