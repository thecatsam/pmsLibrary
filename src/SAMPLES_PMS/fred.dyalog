   ∇{reset} TEST2 args
    :IF reset..DEF ⋄ :ANDIF reset
        ⎕RESET
    :ENDIF
    :IF ⎕FIRST
       ⎕← 'et cetera'
    :ENDIF
   ⎕← 'more'
   ∇
