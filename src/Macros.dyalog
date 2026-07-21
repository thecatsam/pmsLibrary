Macros←{ 
  ⍝H    Macros: 
  ⍝H    Description:
  ⍝H    A function that evaluates macros of the form {{name value}} for use in APL and HTML texts.
  ⍝H 
  ⍝H    Syntax:
  ⍝H    [ opts ] ∇ string@CV[V]
  ⍝H    string: A vector of character vectors or a character vector.
  ⍝H    opts: (                  ⍝ defaults
  ⍝H         maxIter: 10          
  ⍝H         missing: 'signal' 
  ⍝H         verbose: 0 
  ⍝H         show:    'apl'
  ⍝H    )
  ⍝H    maxIter:  How many possible times that macros can resolve to other macros
  ⍝H              10 | nn
  ⍝H    missing:  What to do if a macro is NOT defined.
  ⍝H              '[signal]' | 'a[rgument]' | 'i[nput] | 'h[tml]'     (default: signal) 
  ⍝H              See specifics below.
  ⍝H    verbose:  Give out extra info
  ⍝H              0 | 1
  ⍝H    show: Do we show the macro definitions in the output?
  ⍝H              'a[pl]' | 'h[tml]' | '[no]'
  ⍝H              'apl'   - Yes, show as APL comments.
  ⍝H              'html'  - Yes, show as HTML comments.
  ⍝H              'no'    - No, don't show... 
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
    ⎕IO ⎕ML←0 1 
    ⍺←() 
  'help'≡⎕C⍺: ⎕ED 'x'⊣ x← '^\h*⍝H\h?(.*)$' ⎕S '\1' ⎕NR ⊃⎕XSI 
  9≠⎕NC '⍺': 11 ⎕SIGNAL⍨'Macros: parameters ⍺ must be a namespace or the character vector "help"'
  '[\x{00}]' '[\x{01}]'⎕R '{{' '}}'⊢ ⍺ ().{
  ⍝ Error Fns
    NFÊrr←      { 11 ⎕SIGNAL⍨ 'Macros: Value Error: Macro (dfn) "', ⍵, '" is undefined' } 
    EvalÊrr←    { 11 ⎕SIGNAL⍨ 'Macros: Error Evaluating Macro Call: ', ⍵ }
    LoopÊrr←    { 11 ⎕SIGNAL⍨ 'Macros: Apparent Infinite Loop: "', ⍵, '"' }
    ShowÊrr←    { 11 ⎕SIGNAL⍨ 'Macros: Unknown show type: ', ⍵ }
    ParmÊrr←    { 11 ⎕SIGNAL⍨ 'Macros: Unknown parameter(s) in ⍺:', ⍵ }

  ⍝ USER OPTION DEFAULTS HERE
    defaults← (                                           ⍝ Defaults...
        maxIter: 10                                       ⍝ An iteration is one call to ⎕R below... 
        missing: 'html' ⍝ 'signal'                                 ⍝ ... (which may have many macros evaluated)
        verbose: 0                                        ⍝ User may set to 1
        show:    'apl'                                    ⍝ If '', don't show the defs in the output.
    )
    0≠ ≢êrr← ⊃~/(⍺ defaults).⎕NL ¯2: ParmÊrr ∊' ',¨êrr
  ⍝ Replace defaults by user-specified values, if any.
    _← ⎕THIS ⎕NS defaults ⍺ 
  ⍝ Constant values for types                
    sigT argT inT htmlT errT noT aplT←  'signal' 'arg' 'input' 'html' '????' 'no' 'apl'  
    macT defT undefT←                   'macros' 'def' 'undef'  
  ⍝ Type lists: missL and showL 
    missL←  sigT argT  inT  htmlT errT                    ⍝ first is matched by ''
    showL←  noT  htmlT aplT errT                          ⍝ first is matched by ''
  ⍝ Other constants
    home←    ⊃⎕RSI 
    lbC rbC← ,¨⎕UCS 0 1 
    sq dq←   ''''  '"' 
    cr←      ⎕UCS 13
  ⍝ Data structure for macros: mac
    mac← ( 
      on:  1 
      k: ⍬ 
      v: ⍬ 
    )   
  ⍝ Key patterns
    patC0← '(?x)\s* \x{00} \s* ([\w∆⍙_]+): \s*  (.*?) \s? \x{01} \s* \r?'
    patC1← ∊( '(?x)' 
      ' (?<B> \x{00} ('
      '                (?> [^\x{00}\x{01}"'']+'
      '                    | (?:"[^"]*")+'
      '                    | (?:''[^'']*'')+'
      '                    | (?&B)* )'
      '                +)'
      '       \x{01} )'
    ) 
  ⍝ Other variables
    iter←    maxIter 
    missing← missL { ⍺ ⊃⍨ (¯1↓ ⍺↑⍨¨≢⍵)⍳ ⊂⍵ } ⎕C ,missing 
    show←    showL { ⍺ ⊃⍨ (¯1↓ ⍺↑⍨¨≢⍵)⍳ ⊂⍵ } ⎕C ,show  
   ⍝ Utility Functions
    ∆F←     { L← ⍺.Lengths ⋄ ⍵≥ ≢L:'' ⋄ ¯1= L[⍵]:'' ⋄ L[⍵]↑ ⍺.Offsets[⍵]↓ ⍺.Block } 
    NLB←    { ⍵↓⍨+/∧\' '= ⍵ }
  ⍝ Other Fns 
    XlateIn←  '\{{2,2}'  '\}{2,2}' ⎕R lbC  rbC 
    XlateOut← '[\x{00}]' '[\x{01}]'⎕R       '{{' '}}' 
    QShow←  { 
      ~show⊂⍛∊ showL: ShowÊrr show                                ⍝ Unknown
      show≡ noT:    ''                                       
      show≡ htmlT:  XlateOut '/* ',(⍵↓⍨- cr= ⊃⌽⍵),' */',cr    
    ⍝ show≡'apl'                                             
        in←  '\x{00}\s*␍\s*' '\{\s*␍\s*' '\s*␍\s*\}' '\s*␍\s*\x{01}' '\s*␍$' '␍\s+|\s+␍'
        out← lbC             '{'         '}'         rbC             ''      ' ␍' 
        Tidy← in ⎕R out 
        ∊  cr,⍨ Tidy '⍝ ', '␍'@(cr∘=)⊢ ¯1↓XlateOut ⍵  ⍝ ' ' (≠⊆⊢) 
    }
    HandleQuotes← '''[^'']*'''  '"([^"]*)"' '⍝.*$'⎕R {
                      ⍵.PatternNum=0: ⍵ ∆F 0 
                      ⍵.PatternNum=1: sq,sq,⍨ { ⍵/⍨ 1+ ⍵=dq} ⍵ ∆F 1
                      ⍵.PatternNum=2: ''
                  } 
  ⍝ Execute inside anonymous ns
      { 
          opts← ('UCP' 1)('Mode' 'M')('EOL' 'CR')('NEOL' 1)('DotAll' 1)
          new← patC0 patC1 ⎕R {                               ⍝ One call to ⎕R here = 1 iteration.
              f0← ⍵ ∆F 0 
              cr← ⎕UCS 13 
            0= ⍵.PatternNum: QShow f0⊣ {
              f1 f2← ⍵ ∆F¨1 2
              f1≡ macT: mac.On← 'on'⍷⍥⎕C f2
              fn← f2↑⍨ p← f2⍳ ' '
              def← f2↓⍨ p+1
              f1≡ defT:  {  
                  def← HandleQuotes def  
                  mac.k ≢⍛< p← mac.k⍳ ⊂fn: ''⊣ (p⊃mac.v)← def 
                      mac.k,← ⊂fn ⋄ mac.v,← ⊂def 
                      ''⊣ (⎕∘←)⍣verbose⊣ ↑('mac.k: ',mac.k)('mac.v: ',mac.v)
              }⍬
              f1≡ undefT: {
                  mac.k ≢⍛= p← mac.k⍳ ⊂fn: ''
                    mac.k/⍨← k← p≠ ⍳≢mac.k ⋄ mac.v/⍨← k 
                    ''
              }⍬
              NFÊrr f1
            }⍵
              fn←  str↑⍨ p←' '⍳⍨ str← NLB 1↓ ¯1↓ f0
              arg← {⍵↓⍨' '=⊃⍵}p↓str                           ⍝ Ignore 1 leading blank. Keep trailing.
              nf← ~mac.k∊⍨ ⊂fn
            nf∧ missing≡ htmlT:  '<',fn,'>',arg,'</',fn,'>'   ⍝ Not found: [3] return html: <fn>arg</fn>
            nf∧ missing≡ inT:  lbC, str, rbC                  ⍝ Not found: [2] return original {{..}}
            nf∧ missing≡ argT: arg                            ⍝ Not found: [1] return arg only
            nf: NFÊrr fn
            0:: EvalÊrr fn, ' ', arg                          ⍝ Evaluation error!
              body←  '{', '}',⍨ '⋄'@(cr∘=)⊢mac.v⊃⍨ mac.k⍳ ⊂fn
              argq←  sq, sq,⍨ arg/⍨ 1+ arg=sq 
              XlateIn ⍕home⍎ body, argq                ⍝ Evaluate the macro! 
          }⍠ opts⊢  ⍵
          quit← 0≥ iter⊢← iter-1 
        quit∧ missing≡ argT: arg 
        quit∧ missing≡ inT:  new~ lbC, rbC   
        quit:                LoopÊrr XlateOut new 
        ⍵≡ new: new 
          ∇  new 
      } XlateIn ⍵  
  } ⊆⍵
}
