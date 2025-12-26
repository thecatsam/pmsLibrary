:class bigNum

    ⎕IO←0
    ⍝ Find the required bigInt library at locations ⍵@VS (relative or absolute)
      _BIGINT_LIB_←{
          ⍺←⍵   ⍝ Set ⍺:dirs from full ⍵ ONLY first-time through
          0=≢⍵:{
              ⎕←'Error: Library bigNum must be loaded after library BigInt'
              ⎕←'BigInt must be in one of these namespaces ⍵ (as ⍵.BigInt):'
              ⎕←'   ',⍵
              #
          }⍺
          try←(⊃⍵),'.BigInt'
          9=⎕NC try:⍎try
          ⍺ ∇ 1↓⍵
      }

    :Field Public Data←       0(,0)         ⍝ Private in production version
    :Field Public Point←      0             ⍝ Offset of decimal point from end of number string
    :Field Public Precision←  0             ⍝ 0=maximum set by calculation
    :Field Public Shared bi← _BIGINT_LIB_ '##' '#' '#.⍙⍙.require' '⎕SE' '⎕SE.⍙⍙.require'

    ∇ new0
      :Implements Constructor
      :Access Public
      ⎕DF'0'
    ∇
    ∇ new1 num
      :Implements Constructor
      :Access Public
      :If 9=⎕NC'num'
          Data Point Precision←num.(Data Point Precision)
          ⎕DF⍕num
      :Else
          num←,⍕num
          'Invalid bigNum'⎕SIGNAL 11/⍨0∊num∊⎕D,'¯-.'
          Data←bi.imp num~'.'
          :If '.'∊num
              Point←(⌽num)⍳'.'
          :EndIf
          ⎕DF num
      :EndIf
    ∇
    ∇ new2(num precision)
      :Implements Constructor
      :Access Public
      :If 9=⎕NC'num'
          (Data Point)Precision←num.(Data Point)precision
      :Else
          'Invalid bigNum'⎕SIGNAL 11/⍨0∊num∊⎕D,'¯-.'
          Data←bi.imp num~'.'
          :If '.'∊num
              Point←(⌽num)⍳'.'
          :EndIf
          ⎕DF num
          Precision←precision
      :EndIf
    ∇

    ∇ close
      :Implements Destructor
    ∇

  ⍝ a.precision
  ⍝ {old} ← a.∇ new@I
  ⍝     prec≥0:  Set a.Precision to <new>, return old precision
  ⍝     prec<0:  Return current precision as <old>.
    ∇ {old}←precision new
      :Access Public
      old←Precision
      :If new≥0
          Precision←new
      :EndIf
    ∇

  ⍝ this.mul:    "c ← a.mul b"
  ⍝   c@bigNum ← a.∇ b@bigNum
    ∇ c←mul b;a
      :Access Public
      :If 9≠⎕NC'b'
          b←⎕NEW bigNum b
      :EndIf
      a←⎕THIS
      c←⎕NEW bigNum
      c.Data←a.Data bi.mul b.Data
      c.Point←a.Point+b.Point
      c.Precision←a.Precision+b.Precision
      c.⎕DF c.show
    ∇

    ∇ str←show;p;lz;sgn
      :Access Public
      sgn←'¯' ' ' ' '⊃⍨1+⊃Data     ⍝ ⊃Data is sign
      str←bi.exp 1(⊃⌽Data)         ⍝ |Data
      :If Point≠0
          p←-Point
          str←(p↓str),'.',(p↑str)
          :If lz←Point≥¯1+≢str
              str←'0','0'@(' '∘=)⊣str
          :EndIf
          :If 0<dif←Precision+lz-≢str ⍝ Updated str may have prefix '0.'
              str,⍨←dif⍴'0'
          :EndIf
      :Else
          :If 0<dif←Precision-≢str
              str,←'.',dif⍴'0'
          :EndIf
      :EndIf
      str,⍨←sgn
    ∇

:endClass
