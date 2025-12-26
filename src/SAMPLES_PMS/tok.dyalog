 tok←{
   ⍝ Tokenize a vector of vectors representing an APL fn or
   ⍝ 2∘FIX-appropriate object
   ⍝ Extensions: Handles multiline strings with '...' or "..."
   ⍝ [0] tok vec [vec...]
   ⍝     Returns 3 objects: tokens, types, and attributes (q.v.)
   ⍝  1  tok vec [vec...]
   ⍝     Returns a vector of namespaces, one for each token in ⍵ with
   ⍝     ns.tok, ns.typ, ns.attr containing their
   ⍝         tokens, types, and attributes.
   ⍝     ns.⎕DF is set as the token string for each token found.
   ⍝
   ⍝     ⎕←ns←1 tok '( a ; (d; f)); g) '
   ⍝ (     a     ;     (  d  ;     f  )  )  ;     g  )
   ⍝     ∊ns.tok
   ⍝ ( a ; (d; f)); g)
   ⍝     ns.typ
   ⍝ PAR.BEG SP NAME SP PUNCT SP PAR.BEG NAME PUNCT SP ...
   ⍝ NAME PAR.END PAR.END PUNCT SP NAME PAR.END SP
     ⎕IO←0 ⋄ ⍺←0
     EOL fauxEOL aplEOL←⎕UCS 10 63743 13  ⍝ fauxEOL: temporary mapping
     options←('UCP' 1)('IC' 1)('Mode' 'M')('EOL' 'LF')
     ∆F←{ ⍝ regexpNS ∆F field: get value of a regexp (⎕R) field ⍵
         ns←⍺
         ' '=1↑0⍴⍵:ns ∇ ns.Names⍳⊂,⍵
         ⍵=0:ns.Match ⋄ ⍵≥≢ns.Lengths:'' ⋄ ns.Lengths[⍵]=¯1:''
         ns.(Lengths[⍵]↑Offsets[⍵]↓Block)
     }
     ∆C←{ ⍝ Evaluate and canonicalize pattern "args"
         ' '~⍨'⍎(\pL\w*)'⎕R{
             nm←⍵ ∆F 1
             0::11 ⎕SIGNAL⍨'Eval: name missing: ',nm
             ⍎nm
         }⊣⍵
     }
     ∆EOL←{ ⍝ Handle EOLs in strings "..." or '...'
         ⍺←0
         ⍺:aplEOL@(fauxEOL∘=)⍵
         fauxEOL@(EOL∘=)⍵
     }
     sqP←'(?: '' [^'']* '' )+'
     dqP←'(?: "  [^"]*  " )+'
     spP←'\h+'
     eolP←'\R'
     comP←'⍝.*$'
     namP←'⍎nam1 (?: \. ⍎nam1 )*'⊣nam1←'(?: ⎕? [\pL∆⍙] | [#⍵⍺]{1,2}) [\w∆⍙]*'
     ioP←'[⎕⍞]'
     numP←'¯?(?: ⍎num1 | \.⍎num1)'⊣num1←'\d[\d\.JE¯]*'
     ctlOrColonP←':\w+'
     parP←'[()]'
     brkP←'[\[\]]'
     dfn1P←'{'
     dfn2P←'}'
     del2P←'∇∇'
     delP←'∇(?=\h*([^⍝\n]))?'
     punctP←'[;:]'
     aplP←'[+\-×÷⌊⌈|*⍟<≤=≥>≠∨∧⍱⍲!?~○⌷/⌿\⍀∊⍴↑↓⍳⊂⊃∩∪⊣⊢⊥⊤,⍒⍋⍉⌽⊖⌹⍕⍎⍪≡≢⍷⊆⍸/\\⌿⍀\.¨∘⍨&⍣@⌶⌸⌺⍠⍤]'
     aplAmbig←'/\⌿⍀' ⋄ aplOp←'.¨∘⍨&⍣@⌶⌸⌺⍠⍤'
     etcP←'.'
     pat←∆C¨sqP dqP spP eolP comP namP ioP numP ctlOrColonP parP brkP dfn1P dfn2P del2P delP punctP aplP etcP
     sqE dqE spE eolE comE namE ioE numE ctlOrColonE parE brkE dfnLE dfnRE del2E delE punctE aplE etcE←⍳≢pat

     ⍝ tokens: NAME NAME.ARG NAME.FNOP NAME.SYS SQ DQ SP EOL COM IO NUM
     ⍝         PAR.BEG PAR.END DFN.BEG DFN.END PUNCT FNOP CTL
     ⍝         TFN.BEG TFN.END
     ⍝ attributes
     ⍝     [0] count  [1] dfnLVL  [2] bracketLVL
     ⍝     [3] governing brace: '{' '(' '[' or none (' ')

     types←attributes←⍬
     dfnLVL←brackLVL←0 ⋄ governor←' '
     typeNames←'APL.FN'  'APL.FNOP'  'APL.OP'  'BRK.BEG'  'BRK.END'  'COM'  'DFN.BEG'  'DFN.END'  'DQ'  'EOL'  
     typeNames,←'FN.BEG'  'FN.END'  'IO'  'NAME'  'NAME.FN'  'NAME.OP'  'NUM'  'PAR.BEG'  'PAR.END'  
     typeNames,←'PUNCT'  'SP'  'SQ'  'UNKNOWN' '[ERROR]'
     typeNums←1.1 1.2 1.3 2.1 2.2 3 4.1 4.2 5 6 7.1 7.2 8 9.1 9.2 9.3 10 11.1 11.2 12 13 14 0 ¯1 
     ⍝ ⎕←typeNames,[-0.2]typeNums
     
     setTA←{ ⍝ Set types and attributes
         ⍺←1 ⋄ count←⍺
         types,←⊂⍵
         attributes,←⊂count,dfnLVL brackLVL,⊃⌽governor
         ⍬
     }
     procName←{ ⍝ Process variable names
         f0←⍵ ⋄ isOp←('⍺⍺' '⍵⍵'∊⍨⊂¯2↑f0)∨'#'=¯1↑f0
         isOp:f0,EOL⊣setTA'NAME.OP'
         f0,EOL⊣setTA'NAME'
     }
     procDfns←{ ⍝ Process braces {}
         ⍺∊⍵:⊣dfnLVL+←1⊣governor,←⍺
         ⊣dfnLVL-←1⊣governor↓⍨←¯1
     }
     procBracket←{ ⍝ Process brackets [] and parens ()
         ⍺∊⍵:⊣brackLVL+←1⊣governor,←⍺
         ⊣brackLVL-←1⊣governor↓⍨←¯1
     }
     tokenize←{ ⍝ Tokenize 1 or more input lines...
         f0←⍵ ∆F 0
         case←⍵.PatternNum∘∊

         case aplE:{
             ⍵∊aplAmbig:⍵,EOL⊣setTA'APL.FNOP'
             ⍵∊aplOp:⍵,EOL⊣setTA'APL.OP'
             ⍵,EOL⊣setTA'APL.FN'
         }f0
         case etcE:f0,EOL⊣setTA'UNKNOWN'
         case sqE:(∆EOL f0),EOL⊣setTA'SQ'
         case dqE:(∆EOL f0),EOL⊣setTA'DQ'
         case spE:' ',EOL⊣(≢f0)setTA'SP'
         case eolE:fauxEOL,EOL⊣setTA'EOL'
         case comE:f0,EOL⊣setTA'COM'
         case namE:procName f0
         case ioE:f0,EOL⊣setTA'IO'
         case numE:f0,EOL⊣setTA'NUM'
         case ctlOrColonE:{
             ×dfnLVL:':',EOL,(procName 1↓⍵)⊣setTA'PUNCT'
             ⍵,EOL⊣setTA'CTL'
         }f0
         case parE:'PAR.BEG' 'PAR.END'{
             ⍵,EOL⊣setTA(')'=f0)⊃⍺⊣'('procBracket f0
         }f0
         case brkE:'BRK.BEG' 'BRK.END'{
             ⍵,EOL⊣setTA(']'=⍵)⊃⍺⊣'['procBracket ⍵
         }f0
         case dfnLE:{
             ⍵,EOL⊣setTA'DFN.BEG'⊣'{'procDfns ⍵
         }f0
         case dfnRE:{
             ⍵,EOL⊣setTA'DFN.END'⊣'{'procDfns ⍵
         }f0
         case delE:⍵{ ⍝ ∇, ∇∇
           ⍝ dfnLVL>0? In a dfn ∇, ∇∇ are special fn/op names
             ×dfnLVL:⍵,EOL⊣setTA'NAME.FN'
           ⍝ fnBeg: 1 if any text after ∇ (ignoring comments and blanks)
             fnBeg←×≢' '~⍨⍺ ∆F 1
             fnBeg:⍵,EOL⊣setTA'FN.BEG'            ⍝ yes
             ⍵,EOL⊣setTA'FN.END'                  ⍝ no
         }f0
         case del2E:f0,EOL⊣setTA'NAME.OP'
         case punctE:f0,EOL⊣setTA'PUNCT'
         f0,EOL⊣setTA'[ERROR]'
     }
  
     tokens←1 ∆EOL¨pat ⎕R tokenize⍠options⊣⊆⍵

     ntypes←typeNums[types⍳⍨¯1↓typeNames]

     specs←tokens (types,[-.1] ntypes) attributes
     
     ~⍺:specs
     {
         n←⎕NS''
         n.tok←∊⊃0⊃⍵ ⋄ n.typ←1⊃⍵ ⋄ n.attr←2⊃⍵
         _←n.⎕DF n.tok
         n
     }¨↓⍉↑specs

 }
