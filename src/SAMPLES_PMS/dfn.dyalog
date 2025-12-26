 __nm__←dfn;⎕IO
 ⎕IO←0
 __nm__←{
     0::⍬ ⋄ 0=≢' '~⍨∊⍵:⍬
     0≠1↑0⍴__nm__←(⊃⌽⎕RSI).⎕FX ⍵:__nm__
     ⍺←{
         badNm←¯1 2∊⍨⎕NC{⍵↑⍨⍵⍳'←'}⊃⍵
         ⎕←'dfn: Error fixing dfn (line ',')',⍨⍕__nm__
         ~badNm:0
         ⎕←'     Function name is in use, missing, or invalid.'
         0
     }⍵
     0≠≢⍞↓⍨≢⍞←'Hit RETURN to edit source: ':⍬⊣⎕←'dfn: Aborting edit at user request'
     ∇{EDIT⊣⎕ED'EDIT'⊣EDIT←⍵}⍵
 }{
     DOT←⎕UCS 183
     0{⍝ ⍺: indent, ⍵: fn lines, minIn: indent on first line
         ⍞←(minIn⍴' '),⍨(DOT,' ')⍴⍨2×indent←⍺⊣minIn←2
         lines←⍵,⊂' '@(DOT∘=)⊣⍞
         indent←{(+/-/⍵∘.='{}')}∊'(?:''[^'']*'')+|⍝.*'⎕R''⊣lines
         0<indent:indent ∇ lines
         (⊂minIn↓⊃lines),(1↓lines)
     }⍬
 }⍬
