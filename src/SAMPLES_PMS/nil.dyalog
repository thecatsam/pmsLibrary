 nsNil←{L}(dfn nil)R
 ⍝ nil: Take a left operand {fn1} and its left (if any) and right args
 ⍝      and return a namespace with niladic function fn,
 ⍝      with those args bound. Respects the ⎕IO, ⎕ML, etc. of the
 ⍝      namespace in which fn1 is defined (e.g. the caller env).
 :If 0=⎕NC'L' ⋄ L←⊢ ⋄ :EndIf
 nsNil←⎕NS'dfn' 'L' 'R'
 nsNil.⎕DF'nil: ⍵.fn'
 {}nsNil.⎕FX('r←fn' 'r←L dfn R')
