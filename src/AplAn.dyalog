AplAn←{
  #.a∘← (a: ⍳3 ⋄ b: ('one two'⋄ 'three') ⋄ c: [1 2 3 ⋄ 4 5])
  #.a.fred←{⍺⍳⍵}
  #.a.mary←{
    ⍺⍳⍵
    ⍝ comment
    ⍺⍳⍵⊣'unreachable'
  }
  #.a.ns← (aa: ⍳2 ⋄ bb: ('one two' ⋄ 'three') ⋄ cc: [1 2 3 ⋄ 4 5])
  _← a.ns.⎕FX 'r←a Trad b'  'r←a⍳b'  '⍝ more'  'r←b⍳a'  '⍝ done' 

  ⍺←1 ⋄ cmp←⍺                        ⍝ cmp: compact
  NL←⎕UCS 13
  Pad←{ f←2 
    (0=⍺)∨cmp: ⍵ 
    lines← '^' ⎕R (''⍴⍨f×⍺)⊢ ⍵
    lines↓⍨0⌈¯1++/∧\' '=lines
  }
  Array←{
      an←cmp ⎕SE.Dyalog.Array.Serialise ⍵
    cmp:⊃an
      ¯1↓∊NL,⍨¨an
  }
  Namespace← { ⍺←0 ⋄ pad←⍺ 
      nms←  ⍵.⎕NL -⍳10
      vals← ⍵ pad  NsVals¨nms 
      pairs←(nms,¨':'),¨ vals
    cmp:'(',')',⍨¯1↓∊pairs,¨'⋄'
      ¯1↓∊('(',')',⍨pairs),¨NL
  }
  NsVals←{  ns pad←⍺  
    0:: pad Pad '[cannot display]'
      nc← ⍺.⎕NC ,⊂⍵ 
      Class← ⍺.{'[',('::',('Clss' 'Inst'⊃⍨ 9.4≠⍺),']'),⍨' '~⍨2↓⍕'>',¨⎕CLASS ⍎⍵ }
    nc= 9.4: pad Pad nc Class ⍵      ⍝ Class
    nc= 9.2: pad Pad nc Class ⍵      ⍝ Instance
    nc=9.1:  (pad+1) Namespace ⍺⍎⍵       ⍝ Ns 
    nc∊ 3 4: ns pad Pad ns nc FnOp ⍵ 
    nc⌊⍛=2:  pad Pad Array ⍺.⎕OR ⍵
        (pad+1) ⍺ Main ⍵  
  }
  FnOp←{ ns nc←⍺ 
      n← ns.⎕NR ⍵
      qP qR← '''[^'']*''' '\0'
      DfnPatNoC← qP '\h+}'     ⎕R qR '}'
      DfnPatC←   qP '\h*⋄\h*'  ⎕R qR '⋄'
      TradPatC←  qP '^(⋄?)\h+' ⎕R qR '\1'
      Dfn←{   ⍝ dfn
          ByType←{
            f←f↓⍨1+'←'⍳⍨f←⊃⍵
            1=≢⍵:⊂f
            2=≢⍵:f,⍥⊂1↓⍵
            f⊂⍛,(' ',¨1↓¯1↓⍵),(¯1↑⍵)
          }
          fn←ByType ⍵
        cmp: DfnPatC ¯1↓∊fn,¨'⋄'
          ¯1↓∊NL,⍨¨ DfnPatNoC ' ',¨fn 
      }
      TradFn←{
            f←⍵  
            (⊃f),⍨← '∇',NL,'  ' 
            TradPkg← {
              hdr← (0⊃⍵)  
              rest← ¯1↓∊'⋄',⍨¨ 1↓⍵ 
              '{',hdr, rest, '∇}'
            }
          cmp: TradPkg TradPatC f
            ¯1↓∊((' ',¨f),⊂'∇'),¨NL
      }
      Train← ⊢
    nc∊ 3.2 4.2:⍺ Dfn n
    nc∊ 3.3 4.3:  Train n            
    nc∊ 3.1 4.1:⍺ TradFn n
    '???'
  }
  ⍝ ⍺←0 (⊃⎕RSI)  ⋄ pad ns← ⍺  
  ⍝   type←⌊subT← ⎕NC⊂, '⍵'
  ⍝   type=2:   pad Pad Array ⍵
  ⍝   type∊3 4: pad Pad subT ns FnOp ⍵⊣ ⎕←'ns' ns 
  ⍝   type=9:   pad Pad Namespace ⍵
  ⍝     pad Pad '???'

  nc← ⎕NC '⍵'
  nc≠ 9: Array ⍵
  Namespace ⍵ 
}
