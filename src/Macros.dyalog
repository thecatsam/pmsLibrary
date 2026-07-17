Macros←{ 
  ⍝H    Macros: 
  ⍝H    Description:
  ⍝H    A function that evaluates macros of the form {{name value}} for use in APL and HTML texts.
  ⍝H 
  ⍝H    Syntax:
  ⍝H    [ opts ] ∇ string@CV[V]
  ⍝H    string: A vector of character vectors or a character vector.
  ⍝H    opts: ( 
  ⍝H         maxIter: 10 
  ⍝          missing: 'signal' 
  ⍝          verbose: 0 
  ⍝          show:    'apl'
  ⍝     )
  ⍝H    maxIter:  How many possible times that macros can resolve to other macros
  ⍝H              10 | nn
  ⍝H    missing:  What to do if a macro is NOT defined.
  ⍝H              '[signal]' | 'a[rgument]' | 'i[nput] | 'h[tml]'     (default: signal) 
  ⍝H              See specifics below.
  ⍝H    verbose:  Give out extra info
  ⍝H              0 | 1
  ⍝H    show: Do we show the macro definitions in the output?
  ⍝               'apl'   - Yes, show as APL comments.
  ⍝               'html'  - Yes, show as HTML comments.
  ⍝               '' | ⍬  - No.  
  ⍝H    Macro setting formats:
  ⍝H       {(macros: on | off})    If on (default), macros are replaced from here forward.
  ⍝H                               If off, macros are not replaced.
  ⍝H       ({def: name value})     Defines macro "name" as having as a dfn definition "value"
  ⍝H                               (sans dfn braces).
  ⍝H       ({undef: name)}         Deletes the definition of macro "name" from here forward.
  ⍝H    Macro usage format
  ⍝H       {{fn}}        Calls  fn ''
  ⍝H       {{fn arg}}    Calls  fn 'arg'  (internal quotes doubled)
  ⍝H                     Respects both single and double quotes in the arg.
  ⍝H                     ¨arg¨ begins one space after fn and ends at the closing }}.
  ⍝H    If the fn isn't found, missing determines:
  ⍝H        sig:   signal an error via ⎕SIGNAL         
  ⍝H        arg:   return just the argument arg:        arg
  ⍝H        input: return the input string verbatim:    {{fn arg}}
  ⍝H        html:  returns:                             <fn>arg</fn>
  ⍝H    ---------------------
  ⍝H    Note: For help info, type  Macros⍨'help'
  ⍝H    Note: missing and show arguments may be in either case and may be abbreviated.
  ⍝H 
    ⍺←()
  'help'≡⎕C⍺: ⎕ED 'x'⊣ x← '^\h*⍝H\h?(.*)$' ⎕S '\1' ⎕NR ⊃⎕XSI 
  9≠⎕NC '⍺': 11 ⎕SIGNAL⍨'Macros: options neither a namespace nor the string "help"'
  ⍝ USER OPTION DEFAULTS HERE
    ñøø← (                 ⍝ Defaults...
        maxIter: 10        ⍝ An iteration is one call to ⎕R below... 
        missing: 'signal'  ⍝ ... (which may have many macros evaluated)
        verbose:  0        ⍝ User may set to 1
        show:     'apl'    ⍝ If '' or ⍬, don't show the defs in the output.
    )
  ⍝ Merge in user parms (overriding user, if needed) and constants...
    ñøø._← ñøø ⎕NS ⍺  (                                   
        mEnum: ('signal' 'argument' 'input' 'html' )   ⍝ first is default
        sEnum: ('' 'apl' 'html')                       ⍝ first is default
        patC0: '(?x)\s* \x{00} \s* ([\w∆⍙_]+): \s+ (.*?) \s? \x{01} \s* \r?'
        patC1: ∊('(?x)' 
        ' (?<B> \x{00} ((?> [^\x{00}\x{01}"'']+'
        ' | (?:"[^"]*")+ | (?:''[^'']*'')+'
        ' | (?&B)* )+) \x{01} )'
        )
        homeC:   ⊃⎕RSI 
        lbC: ,⎕UCS 0 ⋄ rbC: ,⎕UCS 1 
        sigE: 0 ⋄ argE: 1 ⋄ inputE: 2 ⋄ htmlE: 3
        mOn:  1 ⋄ mKeys: ⍬ ⋄ mVals: ⍬
        cr:   ⎕UCS 13
    )
  ⍝ Functions
    ñøø. ∆F←     ñøø.{ L← ⍺.Lengths ⋄ ⍵≥ ≢L:'' ⋄ ¯1= L[⍵]:'' ⋄ L[⍵]↑ ⍺.Offsets[⍵]↓ ⍺.Block } 
    ñøø. NLB←    { ⍵↓⍨+/∧\' '= ⍵ }
    ñøø. QShow←  { 
      sIx=2:    XlateOut '/* ',(⍵↓⍨- cr= ⊃⌽⍵),' */',cr 
      sIx≠1:    ShowÊ show 
    ⍝ sIx=0: ... 
        in←  '\x{00}\s*␍\s*' '\{\s*␍\s*' '\s*␍\s*\}' '\s*␍\s*\x{01}' '\s*␍$' '␍\s+|\s+␍'
        out← lbC             '{'         '}'         rbC             ''      ' ␍' 
        Tidy← in ⎕R out 
        ∊  cr,⍨ Tidy '⍝ ', '␍'@(cr∘=)⊢ ¯1↓XlateOut ⍵  ⍝ ' ' (≠⊆⊢) 
    }
    ñøø. XlateIn←  '\{{2,2}'  '\}{2,2}' ⎕R ñøø.( lbC  rbC )
    ñøø. XlateOut← '[\x{00}]' '[\x{01}]'⎕R     '{{' '}}' 
  ⍝ Error Fns
    ñøø. NFÊ←      { 11 ⎕SIGNAL⍨ 'Macros: Value Error: Function "', ⍵, '" undefined'} 
    ñøø. EvalÊ←    { 11 ⎕SIGNAL⍨ 'Macros: Error Evaluating Macro Call: ', ⍵}
    ñøø. LoopÊ←    { 11 ⎕SIGNAL⍨ 'Macros: Apparent Infinite Loop: "', ⍵, '"' }
    ñøø. ShowÊ←    { 11 ⎕SIGNAL⍨ 'Macros: Unknown show type: ', ⍵ }
  ⍝ 
    ñøø. ( iter← maxIter ) 
    ñøø. ( mIx←  mEnum { (⍺↑⍨¨≢⍵)⍳ ⊂⍵ } ⎕C ,missing )
    ñøø. ( sIx←  sEnum { (⍺↑⍨¨≢⍵)⍳ ⊂⍵ } ⎕C ,show  )
  ⍝ Execute
    ñøø.{ 
      opts← ('UCP' 1)('Mode' 'M')('EOL' 'CR')('NEOL' 1)('DotAll' 1)
      new← patC0 patC1 ⎕R {                                ⍝ One call to ⎕R here = 1 iteration.
          f0← ⍵ ∆F 0 
          cr← ⎕UCS 13 
        0= ⍵.PatternNum: QShow f0⊣ {
           f1 f2← ⍵ ∆F¨1 2
           f1≡'macros': mOn← 'on'⍷⍥⎕C f2
           fn← f2↑⍨ p← f2⍳' ' ⋄ def← f2↓⍨ p+1
           f1≡'def':  {  
              def← { ~'⍝'∊ ⍵: ⍵ ⋄ '''[^'']*''' '⍝.*$'⎕R '&' ''⊣ ⍵ } def 
              mKeys ≢⍛< p← mKeys⍳ ⊂fn: ''⊣ (p⊃mVals)← def 
                  mKeys,← ⊂fn ⋄ mVals,← ⊂def 
                  ''⊣ (⎕∘←)⍣verbose⊣ ↑('mKeys: ',mKeys)('mVals: ',mVals)
           }⍬
           f1≡'undef': {
              mKeys ≢⍛= p← mKeys⍳ ⊂fn: ''
                mKeys/⍨← k← p≠ ⍳≢mKeys ⋄ mVals/⍨← k 
                ''
           }⍬
           NFÊ f1
        }⍵
          fn←  str↑⍨ p←' '⍳⍨ str← NLB 1↓ ¯1↓ f0
          arg← {⍵↓⍨' '=⊃⍵}p↓str                              ⍝ Ignore 1 leading blank. Keep trailing.
          quoted← q, q,⍨ arg/⍨1+arg= q←''''                  ⍝ quoted: arg in quotes
          nf← ~mKeys∊⍨ ⊂fn
        nf∧ mIx=htmlE:  '<',fn,'>',arg,'</',fn,'>'       ⍝ Not found: [3] return html: <fn>arg</fn>
        nf∧ mIx=inputE: lbC, str, rbC                    ⍝ Not found: [2] return original {{..}}
        nf∧ mIx=argE: arg                                ⍝ Not found: [1] return arg only
        nf: NFÊ fn
        0:: EvalÊ fn, ' ', quoted                 ⍝ Evaluation error!
          val← '⋄'@(cr∘=)⊢mVals⊃⍨ mKeys⍳ ⊂fn
          XlateIn ⍕homeC⍎ '{',val,'}', quoted                 ⍝ Evaluate the macro! 
      }⍠ opts⊢  ⍵
      quit← 0≥ iter← iter-1 
    quit∧ mIx=argE:   arg 
    quit∧ mIx=inputE: new~ lbC, rbC   
    quit:             LoopÊ XlateOut new 
    ⍵≡ new: XlateOut new 
      ∇  new 
  } ñøø.XlateIn ⊆⍵ 
}
