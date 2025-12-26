 linesOut←{isFn}scan4Semi1 lines;pBareParens;pComment;pSQ
 ;LAST;LBRK;LPAR;QUOT;RBRK;RPAR;SEMI
 ;cur_tok;cur_gov;deQ;enQ;inQt;lineOut;prefix;stk
 ;⎕IO;⎕ML
 isFn←'isFn'{0=⎕NC ⍺:⍵ ⋄ ⎕OR ⍺}0
 lines←⊆lines
 ⎕IO ⎕ML←0 1
 QUOT←'''' ⋄ SEMI←';'
 LPAR RPAR LBRK RBRK←'()[]'
 stk←⎕NS ⍬

 deQ←{stk.(govern lparIx sawSemi↓⍨←-⍵)}     ⍝ deQ 1|0
 enQ←{stk.((govern lparIx)sawSemi,←⍵ 0)}    ⍝ enQ gNew lNew
 :If isFn
     prefix lines←(⊂⊃lines)(1↓lines)
 :Else
     prefix←⍬
 :EndIf
 linesOut←⍬  ⍝

 :For line :In lines
     :If '∇'=1↑line~' ' ⋄ :Continue ⋄ :EndIf   ⍝ Skip function headers...
     stk.(govern lparIx sawSemi)←,¨' ' 0 0   ⍝ stacks
     lineOut←⍬
     :For cur_tok :In line
         cur_gov←⊃⌽stk.govern
         inQt←QUOT=cur_gov
         :If inQt
             deQ QUOT=cur_tok
         :Else
             :Select cur_tok
             :Case LPAR ⋄ enQ cur_tok(≢lineOut)
             :Case LBRK ⋄ enQ cur_tok(≢lineOut)
             :Case RPAR ⋄ cur_tok←(1+⊃⌽stk.sawSemi)/RPAR ⋄ deQ 1
             :Case RBRK ⋄ deQ 1
             :Case QUOT ⋄ enQ cur_tok ¯1
             :Case SEMI
                 :Select cur_gov
                 :Case LPAR ⋄ cur_tok←')(' ⋄ lineOut[⊃⌽stk.lparIx]←⊂2/LPAR ⋄ (⊃⌽stk.sawSemi)←1
                 :Case LBRK
                 :Else ⋄ cur_tok←')(' ⋄ (⊃stk.sawSemi)←1
                 :EndSelect
             :EndSelect
         :EndIf
         lineOut,←cur_tok
     :EndFor
     :If (⊃stk.sawSemi)     ⍝ semicolon(s) seen at top level (outside parens and brackets)
         lineOut←'((',lineOut,'))'
     :EndIf
     linesOut,←⊂∊lineOut
 :EndFor

 pSQ←'(?:''[^'']*'')+'
 pComment←'⍝.*$'
 pBareParens←'\(\h*\)'
 linesOut←pSQ pComment pBareParens ⎕R'\0' '\0' '⍬'⍠('Mode' 'M')⊣linesOut
 linesOut←prefix,linesOut
