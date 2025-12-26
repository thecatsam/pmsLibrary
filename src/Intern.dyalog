objOut← {userOpts} Intern obj     
  ; bN; bT; bad; badÊ; cr; ed; fnIn; hN; hT; help; lN; opts; p; padTxt     
  ; sortFldLen; sysVars; userOpts; xN; êSort                                                                                                     
  ; CatGrps; Clean; DTB; F; Format; InsertPhase1; InsertPhase2; MinBL; NoBL
  ; Scan4Nms; Sort; Tokenise                                                                                                                    
  ; _RMulti   

help← (
' Overview'
' ¯¯¯¯¯¯¯¯'
' Intern: Searches a tradfn or tradop for local names and '
' (by default) returns them by category; ignores local names '
' in the header, since its purpose is to generate them from '
' the contents of the file. Has options for:'
'    (sort: 3) sorting and grouping, the default;'
'    (sort: 2) sorting w/o folding;'
'    (sort: 1) sorting after folding;'
'    (sort: 0) not sorting (keeping in original order).'
''
' For cases where there are names that MUST be external or internal'
' use these directives (case is ignored):'
'    [⍝ ] :EXTERN nm1 nm2 ... '
'    [⍝ ] :INTERN nm1 nm2 ...  <== NOT IMPLEMENTED YET'
' :EXTERN indicates which indicates names must not be treated as internal.'
' :INTERN indicates those that must, even if they aren''t explicit'
' in the code.'
' The names (nm1...) are separated by semicolons OR spaces.'
''
' The fn Intern requires Dyalog 20 or later.'
''
' By default, all names that are not implicitly internal (e.g. header names) '
' are treated as internal UNLESS they are marked as :EXTERN.'
''
' Usage'
' ¯¯¯¯¯'
' objOut← {userOpts} Intern obj'
' obj: Either '
'     a) the name of a tradfn or tradop or '
'     b) a char matrix of vector of vectors'
' userOpts:'
'  a) if omitted, the defaults indicated below.'
'  b) a namespace with these objects:'
'    name      default   description'
'   --------------------------------------------    '
'    pw:        75     page width'
'    blanks:     0     If 1, add an extra blank line '
'                      between sections.'
'    indent:  (2 1)   - how much to'
'                        [1] indent each line of locals output, and'
'                        [2] after each semicolon separating locals.'
'                      - If only 1 number is specified, it is '
'                        used for both.'
'    sort:       3     3 or ''group'''
'                        ∘ Sort and Group:'
'                        - Sort into Alph order, w/o folding case.'
'                        - Group names into categories by initial letters:'
'                          array, Fn, _MonadOp,'
'                          _DyadOp_, ∆/⍙PseudoSys, ⎕SYS'
'                      2 or ''nofold'''
'                        ∘ Sort into Alph order, w/o folding case'
'                      1 or ''fold'''
'                        ∘ Sort into Alph order, folding case'
'                      0 or ''nosort'''
'                        ∘ Don''t sort.'
'    compact:    5     If 1-adic and dyadic ops have this '
'                      or fewer items, merge. Ditto for '
'                      pseudo-system names and true system names.'
'                      Ignored if sort is not 2.'
'    update:     0     - If 1, update the function or operator text'
'                      with the specified locals, as well as'
'                      ensuring that any :EXTERN statement is commented.'
'                      - If 0, simply return the list of resulting'
'                      locals, each preceded by a semicolon.'
'    mix:        1     If 1, result is mixed (↑) before returning.'
'  c) the word ''help'''
'     Displays help information in the editor and returns'
''
' Returns'
' ¯¯¯¯¯¯¯'
' Returns a vector of character vectors of:'
'   (update: 0) the internal declarations in APL tradfn format;'
'   (update: 1) the entire function with the declarations above.'
)

⍝ obj  - the function name
⍝ nc  - the nameclass of the function
⍝ hN  - header variable names
⍝ lN  - explicitly localised names
⍝ xN  - names marked as external via :EXTERN
⍝ dN  - final list of names to declare internal
⍝ bN  - names found in the bT
⍝ hT  - header text (vector of char vectors)
⍝ bT  - body text (ditto)   -- w/o comments or strings
⍝ sysVars - system names that can be localised

  ⎕IO ⎕ML← 0 1 
⍝ options 
  opts←(
    pw: 75
    blanks: 0
    indent: 2 1
    sort: 2 
    compact: 5
    update: 0
    mix: 1 
  )
⍝ localisable system names
  sysVars← ,(
    '⎕CT' '⎕DIV' '⎕IO' '⎕ML' '⎕PP' '⎕RL' 
    '⎕RTL' '⎕WX' '⎕USING' '⎕AVU' '⎕DCT' '⎕FR'
  )
⍝ êSort: num for sorting
  êSort← (group: 3 ⋄ nofold: 2 ⋄ fold: 1 ⋄ nosort: 0 )
  _RMulti← ⍠('UCP' 1)('Mode' 'M')('EOL' 'LF')('NEOL' 1)
  InsertPhase1←{ 
    ⎕←'Validate new statements re: local vars in header'
    src snk← ↓⍉↑(
      '''[^'']*'''         '\0' 
      '^\h*⍝.*$'           '\0'
      '^(\h*;[^⍝\n]+\n)+'    ''    ⍝ <=== NEW
      '⍝.*$'               '\0'
      '(?i):EXTERN\b'      '⍝ :EXTERN' 
      '(?i):INTERN\b'      '⍝ :INTERN'
      '(?x) (?: ^\h*;[^⍝\n]+ )+ ( (?:⍝.*)? ) $' ('\1')
    )
    first← ⊂';.*'  ⎕R '' ⊃fnIn
    rest← MinBL src ⎕R snk _RMulti 1↓fnIn  
    first, rest 
  }
  InsertPhase2←{  ⍝ ⍺: CVV, ⍵: CVV
     (⊂⊃⍺),⍵, 1↓⍺              
  }
  Tokenise←(';←() ')∘((~∊⍨)⊆⊢)                                  ⍝ Separator is any of: ';←() '
  F←{⍵≥≢⍺.Lengths:'' ⋄ ⊢⍺.(Lengths[⍵]↑Offsets[⍵]↓Block)}
  NoBL←{⍵/⍨0≠≢¨⍵~¨' '}             ⍝ Remove any blank lines
  MinBL←{ ⍵/⍨ t∨1⌽t← 0≠≢¨⍵~¨' '}   ⍝ Convert mult. blank lines to 1
  Clean←{
    src← ,(
      '''[^'']*'''                               ⍝ quoted strings
      '(?i)^((?:\h*⍝)?)\h*:extern\h+([^⍝'']*)'   ⍝ :EXTERN stmt
      '(?i)^((?:\h*⍝)?)\h*:intern\h+([^⍝'']*)'   ⍝ :INTERN stmt
      '^\h*;.$'                                  ⍝ local "headers"
      '⍝.*'                                      ⍝ comments
    )
    ⍙Clean← {
      ~⍵.PatternNum∊ 1 2: ''
      1=⍵.PatternNum:''⊣xN,← Tokenise ⍵ F 2
      2=⍵.PatternNum:''⊣lN,← Tokenise ⍵ F 2 
    }
    src ⎕R ⍙Clean ⍵
  }
  Scan4Nms← {
      bN← ⍬
    ⍝ Ignore Dyalog control words and dfns; find names (but ignore anything after first in first.second.third etc.)
      cntrlP← ':\pL\w*' 
      dfnP←   '(?x) \{ ( (?: [^{}]+ | (?R) )* ) \}' 
    ⍝ \h*: is used to grab and then skip things like name in (name: val)
      nameP←  '(?x) ( ⎕? [\pL_∆⍙] [\w∆⍙]* (\h*:)?) ( (?: \. ⎕? [\w∆⍙]+ )* )'
      cntrlI dfnI nameI← ⍳≢catsP← cntrlP dfnP nameP 
      bN⊣ catsP ⎕R{
        ⍵.PatternNum∊ cntrlI dfnI:''  
          var← ⍵ F 1 
          ':'∊var: ''                  ⍝ Skip name in (name: val)
        '⎕'≠⊃var:''⊣ bN,← ⊂var         ⍝ Not a system var.
          var←1 ⎕C var
        var⊂⍛∊ sysVars:''⊣ bN,← ⊂var   ⍝ Is a localisble system var.
          ''                           ⍝ Isn't-- don't keep.
      }_RMulti ⍵
  }
  sortFldLen← 4 
  Sort←{
    opts.sort= êSort.nosort:  ⍵ 
    opts.sort= êSort.nofold:  ⍵[⍋⍵]
    opts.sort= êSort.fold:  ⍵[⍋⎕C⍵]
    ⍝ Creates a sort-field, starting with a category A-F, and the orig. name ⍵
    ⍝ Then sorts by ∊sf,⍵
    ⍝ Categories: A array     B Fn          C _MonadOp   
    ⍝             D _DyadOp_  E ∆Pseudo-sys F ⎕Sys
      LC← 'abcdefghijklmnopqrstuvwxyzþãìðòõßàáâäåæçèéêëíîïñ∇óôöøùúûü'
      UC← 'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÇÈÊËÌÍÎÏÐÒÓÔÕÙÚÛÝÀÄÅÆÉÑÖØÜ'
      P← { ⍵,⍨ sortFldLen↑⍺}
      0=≢⍵:⍵                                          ⍝ Nothing to sort
      w←{ f←⊃⍵                                        ⍝ Sort into categories and within categories
        f='⎕':'F' P ⍵                                 ⍝ F:  True system var         
        f∊ LC:'A' P ⍵                                 ⍝ A:  aa, i.e. an array
        f∊ UC:'B' P ⍵                                 ⍝ B:  Aa, i.e. a fn   
        s←⊃1↓⍵      
        0=≢⍵~'_':'A' P ⍵                             ⍝ A: "temporary" array: _, __, sorted at end () of cat A.
        grp← 'E' 'A'⊃⍨ s= ⎕C s                        ⍝ E:  ∆Aa, ⍙Aa a pseudo-sys var 
        f∊'∆⍙': (grp,1↓⍵) P ⍵                         ⍝ A:  ∆aa, ⍙aa  - sort just after aa.  
        grp← ⊃'ACD'/⍨ (s= ⎕C s)('_'≠ ⊃⌽⍵) 1           ⍝ A:  _aa       - sort just after aa.
        f='_': (grp,1↓⍵) P ⍵                          ⍝ C: _Aa  (Monadic Op)
                                                      ⍝ D: _Aa_ (Dyadic Op)  
      11 ⎕SIGNAL⍨'Unable to categorise name: ',⍵
        '?' P ⍵⊣⎕←'Error: "'⍵,'"'                     ⍝ Uncategorised!
      }¨⍵
      w[⍋w] 
  }
  CatGrps←{   
    opts.sort≠êSort.group: ⊂⍵ 
      cat← ⊃¨⍵ 
      data← sortFldLen↓¨ ⍵
      A B C D E F Err← { data/⍨ cat=⍵ }¨ 'ABCDEF?'
      MC← opts.compact{ ⍺⍺> ⌊/≢¨⍺ ⍵: ,/⍺ ⍵ ⋄ ⊃,⍥⊂/⍺ ⍵ }
    ⍝ Merge ⍺ and ⍵ if either has fewer than ⍺⍺ items.
      (A MC B) , (C MC D) , (E MC F ) , Err           
  }
  Format← {
    Fmt1←{                                            ⍝ Format list of local vars 
        0=≢⍵: ''                                      ⍝ If no objects, return ''
        { ⍺← '' ''
              buf tmp← ⍺
            0=≢⍵: padTxt, buf, tmp, cr⍴⍨ opts.blanks 
              txt← ';',(opts.indent[1]⍴''),⊃⍵
              over← opts.pw< +/≢¨tmp txt padTxt 
            over: (buf, tmp, cr, padTxt) txt ∇ 1↓⍵
              buf (tmp, txt) ∇ 1↓⍵
        }⍵
    }
    S2CV←  '\A' ⎕R ''                       ⍝ Split into APL Char Vec
    ⍝ Remove extra trailing blank lines
    NoXBL← ((-1+opts.blanks)∘↓)⍣(opts.sort=êSort.group) 
    NoXBL S2CV Fmt1¨⍵          
  }

⍝⍝⍝ ----------------------------------------------------------
⍝⍝⍝ MAIN STARTS HERE
⍝⍝⍝ ----------------------------------------------------------
  :IF ~900⌶0                                   ⍝ Non-default...
      :If 'help'≡ ⎕C userOpts 
           ed← ↑help
           objOut← ⎕ED⍠'ReadOnly' 1⊢ 'ed'
           :Return 
      :EndIf 
      :IF 0∊ (userOpts.⎕NL ¯2)∊ opts.⎕NL ¯2
        'Intern: An unknown option was specified.' ⎕SIGNAL 11
      :EndIf 
      opts ⎕VSET userOpts ⎕VGET ¯2  
      opts.blanks← 0⌈1⌊opts.blanks 
  :EndIf 
⍝ Convert alph sort options to #s. If not found, use 3 (group)!
  opts.sort← (3 2 1 0 3)['group' 'nofold' 'fold' 'nosort' ⍳⊂opts.sort]
  opts.indent← 2⍴opts.indent 
  cr padTxt ← (⎕UCS 10) (opts.indent[0]⍴'')  

  badÊ← ∊(
    'Object must be a simple tradfn/op name, a char matrix,'
    ' or a char vector of vectors'
  )
  :If 2=|≡obj 
      fnIn← obj 
  :ElseIf 2=⍴⍴obj  
      DTB← {⍵↓⍨-⊥⍨' '=⍵}
      fnIn← DTB¨↓obj         
  :ElseIf 1 0∊⍨ ⍴⍴obj 
  :AndIf 3.1 4.1∊⍨ ⎕NC ⊂,obj 
      fnIn← ⎕NR obj 
  :Else 
      11 ⎕SIGNAL⍨badÊ 
  :EndIf 

  xN←lN←⍬
  fnIn← InsertPhase1⍣opts.update⊢fnIn
  bT←NoBL Clean ⊣fnIn 
  hT←⊃bT ⋄ p←hT⍳';'
  hN←Tokenise p↑hT
  bN← Scan4Nms bT← 1↓bT 

⍝ Remove body names declared as external
  bN~←xN
  :If 0≠≢bad← xN∩lN
      11 ⎕SIGNAL⍨{
        ∊(
          'One or more names explicitly declared'
          ' as both local and external:'
          ∊(⊂' "'),¨'"',⍨¨⍵
        )
      }bad
  :EndIf
  
  objOut← ∪(bN~hN),lN
  objOut← Format CatGrps Sort objOut
  objOut← ↑⍣opts.mix⊣ fnIn InsertPhase2⍣opts.update⊣ objOut 
