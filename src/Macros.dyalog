Macros←{ 
  ⍝ test← 'abc  {{Jack  {{Mary hello {{Jack 1 2 3}} sam}} 1 2 3}} done'
    ñ← (
        maxIter: 10
        err:    'sig'
        errs: ('sig' 'lit' 'arg')
        pat:     ∊( 
        '(?x)(?<B> \x{00} ((?> [^\x{00}\x{01}"'']+'
        ' | (?:"[^"]*")+ | (?:''[^'']*'')+'
        ' | (?&B)* )+) \x{01} )'
        )
        home:    ⊃⎕RSI 
        lbX:    ,⎕UCS 0
        rbX:    ,⎕UCS 1 
    )
    ⍺←ñ 
    ñ.( eSig eLit eArg← ⍳3)
    ñ.( ∆F← {L← ⍺.Lengths ⋄ ⍵≥ ≢L:'' ⋄ ¯1= L[⍵]:'' ⋄ L[⍵]↑ ⍺.Offsets[⍵]↓ ⍺.Block } )
    ñ.NLB← { ⍵↓⍨+/∧\' '= ⍵ }
    ñ.( XlateIn←  '\{{2,2}'  '\}{2,2}' ⎕R lbX  rbX )
    ñ.  XlateOut← '[\x{00}]' '[\x{01}]'⎕R '{{' '}}' 
    _← ñ ⎕NS ⍺ 
    ñ. ( iter← maxIter ) 
    ñ. ( err← 3| errs⍳ ⊂⎕C 3↑err )
    ñ.{ 
      new← pat ⎕R {
          f0←  ⍵ ∆F 0
          fn←  str↑⍨ p←' '⍳⍨ str← NLB 1↓ ¯1↓ f0
          arg← {⍵↓⍨' '=⊃⍵}p↓str                              ⍝ Ignore 1 leading blank. Keep trailing.
          qArg← q, q,⍨ arg/⍨1+arg= q←''''                    ⍝ qArg: arg in quotes
          macro←fn,'{⍺⍺ ⍵}', qArg
          nf←3≠home.⎕NC fn
        nf∧ err=eArg: arg                                    ⍝ Not found: [2] return arg only
        nf∧ err=eLit: lbX, str, rbX                         ⍝ Not found: [1] return original {{..}}
        nf: 11 ⎕SIGNAL⍨'Macro Value Error: Function "',fn,'" undefined' ⍝ Not found: [0] Error
        0:: 11 ⎕SIGNAL⍨'Macro Execution Error: ',fn,' ',qArg ⍝ Evaluation error!
          XlateIn home⍎ macro                                ⍝ Evaluate the macro! 
      }⍠('UCP' 1)⊢ XlateIn ⍵
      iter-← 1 
    (iter≤ 0)∧ err=eArg: XlateOut new~ lbX, rbX 
    (iter≤ 0)∧ err=eLit: XlateOut new  
    iter≤ 0: 11 ⎕SIGNAL⍨'Macro substitution in unresolved loop: "','"',⍨XlateOut new 
    ⍵≡ new: XlateOut new 
      ∇ new 
  } ⍵ 
}
