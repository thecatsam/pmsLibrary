 ∆ARGSTEST _args_;new;p
     ⍝   ⎕←     'one' 1 'two' 2 'five' 5   ∆ARGS 0 1⊣a
 p←'first'⎕NULL'middle'⎕NULL'last'⎕NULL'title' '(None)'

 ⍎⎕←p ∆ARGS 1 1⊢_args_
 new←p ∆ARGS 1⊢_args_

 ⎕←'Declared parameters:'(p[0 2 4])
 ⎕←'  title'title'first'first'middle'middle'last'last
 ⎕←'Extra args:         'new
 {⎕←('  ',⍵)(⍎⍵)}¨new
