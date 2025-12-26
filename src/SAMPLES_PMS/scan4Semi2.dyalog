 scan4Semi2←{
     ⍺←0
     ⎕IO ⎕ML←0 1
     QUOT←'''' ⋄ SEMI←';'
     LPAR RPAR LBRK RBRK←'()[]'
     stk←⎕NS''
     deQ←{stk.(govern lparIx sawSemi↓⍨←-⍵)}     ⍝ deQ 1|0
     enQ←{stk.((govern lparIx)sawSemi,←⍵ 0)}    ⍝ enQ gNew lNew

     prefix lines←⍺{
         ⍺:(⊂⊃⍵)(1↓⍵)
         ⍬ ⍵
     }⊆⍵

     scanAll←{⍺←⍬
         0=≢⍵:⍺
         stk.(govern lparIx sawSemi)←,¨' ' 0 0
         (⍺,⊂∊scan⊃⍵)scanAll(1↓⍵)
     }
     scan←{
         ⍺←'' ⋄ lineOut←⍺
         cur_gov←⊃⌽stk.govern
         inQt←QUOT=cur_gov

         0=≢⍵:(⊃stk.sawSemi){⍺:'((',⍵,'))' ⋄ ⍵}⍺
         ch←⊃⍵

         more←{⍺←ch ⋄ (lineOut,⍺)scan ⍵}

         inQt:more 1↓⍵⊣deQ QUOT=ch
         case←ch∘=
         else←⊢
         case LPAR:more 1↓⍵⊣enQ ch(≢lineOut)
         case LBRK:more 1↓⍵⊣enQ ch(≢lineOut)
         case RPAR:c more 1↓⍵⊣c←(1+⊃⌽stk.sawSemi)/RPAR⊣deQ 1
         case RBRK:more 1↓⍵⊣deQ 1
         case QUOT:more 1↓⍵⊣enQ ch ¯1
         case SEMI:{
             case←cur_gov∘=
             case LPAR:') ('more(1↓⍵)⊣lineOut[⊃⌽stk.lparIx]←⊂2/LPAR⊣(⊃⌽stk.sawSemi)←1
             case LBRK:more 1↓⍵
             else') ('more 1↓⍵⊣(⊃stk.sawSemi)←1
         }⍵
         else more 1↓⍵
     }

     linesOut←scanAll lines

     ⋄ pSQ←'(?:''[^'']*'')+'
     ⋄ pComment←'⍝.*$'
     ⋄ pBareParens←'\(\h*\)'
     linesOut←pSQ pComment pBareParens ⎕R'\0' '\0' '⍬'⍠('Mode' 'M')⊣linesOut
     linesOut←prefix,linesOut

⍝  stk←⎕NS ⍬

⍝  deQ←{stk.(govern lparIx sawSemi↓⍨←-⍵)}     ⍝ deQ 1|0
⍝  enQ←{stk.((govern lparIx)sawSemi,←⍵ 0)}    ⍝ enQ gNew lNew
⍝  :If isFn
⍝      prefix lines←(⊂⊃lines)(1↓lines)
⍝  :Else
⍝      prefix←⍬
⍝  :EndIf
⍝  linesOut←⍬

⍝  :For line :In lines
⍝      :If '∇'=1↑line~' ' ⋄ :Continue ⋄ :EndIf   ⍝ Skip function headers...
⍝      stk.(govern lparIx sawSemi)←,¨' ' 0 0   ⍝ stacks
⍝      lineOut←⍬
⍝      :For ch :In line
⍝          cur_gov←⊃⌽stk.govern
⍝          inQt←QUOT=cur_gov
⍝          :If inQt
⍝              deQ QUOT=ch
⍝          :Else
⍝              :Select ch
⍝              :Case LPAR ⋄ enQ ch(≢lineOut)
⍝              :Case LBRK ⋄ enQ ch(≢lineOut)
⍝              :Case RPAR ⋄ lineOut,←(1+⊃⌽stk.sawSemi)/RPAR ⋄ deQ 1 ⋄ :Continue
⍝              :Case RBRK ⋄ deQ 1
⍝              :Case QUOT ⋄ enQ ch ¯1
⍝              :Case SEMI
⍝                  :Select cur_gov
⍝                  :Case LPAR ⋄ lineOut,←') (' ⋄ lineOut[⊃⌽stk.lparIx]←⊂2/LPAR ⋄ (⊃⌽stk.sawSemi)←1 ⋄ :Continue
⍝                  :Case LBRK ⍝ Not special
⍝                  :Else ⋄ lineOut,←') (' ⋄ (⊃stk.sawSemi)←1 ⋄ :Continue
⍝                  :EndSelect
⍝              :EndSelect
⍝          :EndIf
⍝          lineOut,←ch
⍝      :EndFor
⍝      :If (⊃stk.sawSemi)     ⍝ semicolon(s) seen at top level (outside parens and brackets)
⍝          lineOut←'((',lineOut,'))'
⍝      :EndIf
⍝      linesOut,←⊂∊lineOut
⍝  :EndFor

⍝  pSQ←'(?:''[^'']*'')+'
⍝  pComment←'⍝.*$'
⍝  pBareParens←'\(\h*\)'
⍝  linesOut←pSQ pComment pBareParens ⎕R'\0' '\0' '⍬'⍠('Mode' 'M')⊣linesOut
⍝  linesOut←prefix,linesOut
 }
