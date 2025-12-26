 tokenize←{
⍝ opts tokenize fnName1a | opName1b | varName1 | ⎕CR_format2 | ⎕NR_format2 | ⎕SRC_format2
⍝    opts:
⍝      1 to 3 numbers:
⍝      which def descr
⍝       [0]   0  name class:  A number shows the object type when the type of the object is not otherwise known, e.g. options 1b, 2.
⍝       [1]   1  name ok:     Can ⍵ be a name (if a simple char vector(formats 1a,b above) above. Otherwise, only formats 2 are valid.
⍝       [2]   0  keep spaces: Includes blank space tokens in the tokens output. Otherwise, excludes them.
⍝
⍝ Returns a vector of vectors of namespaces ⍵, each containing ⍵.types ⍵.tokens ⍵.counts
⍝    types:  'ASGN' 'COM' 'SQ' 'DQ' 'NUM' 'VAR' 'IO' 'CTL' 'APL' 'BRK:'  ':BRK' 'DFN:' ':DFN' 'SEMI' 'GARD' 'NL' 'SP' 'MSC'
⍝            'OPT:' ':OPT' 'LOC'
⍝    tokens: Actual tokens (SYS, system objects) will have title case: ⎕Tcnums
⍝    counts: (COM)        spaces before the ⍝ symbol.
⍝            (SP)         total number of contiguous spaces
⍝            '([{'        line num and token number of closing brace/bracket
⍝            ';}])'       line num and token number of opening brace/bracket. (SEMI: Only if within brace/brackets)
     ⎕IO ⎕ML←0 1
     ⍺←0 1 0  ⍝ 3↑⍺,0 1 1: Passed to both anon dfns below...

     (3↑⍺,0 1 0){
         nc←⊃⍵ ⋄ text←,¨⊃⌽⍵
         keepSpaces←⍺[2]
         keepQuotes←0     ⍝ "Hidden" option

         NLvisible←⎕UCS 9252

         reOpts←('UCP' 1)('EOL' 'LF')('Mode' 'M')

⍝ Basic patterns
         ASSIGN←'←'
         TRADr←'^\h*∇\h*(?:(?=⍝)|$)'       ⍝ Trad Fun closing ∇
         TRADl←'^\h*∇'                     ⍝ Trad Fun opening ∇
         COM←'(\h*)(⍝.*?)\h*$'             ⍝ comments include leading spaces, but not following spaces.
         SQ←'(?:''[^''\n]*'')+'            ⍝ don't allow single-quoted strings to extend over mult. lines
         DQ←'(?:"[^"]*")+'
         ⋄ NM0←'¯?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE]¯?\d+)?'   ⍝ Complex
         ⋄ NVflag←1   ⍝ If 1, NUM matches 1 or more numbers; elses it matches one number.
         NUM←NM0,'(?:[jJ]',NM0,')?'
         NUM,←NVflag/'(\h+',NUM,')*'

         NAM0←'((?!\d)[\w∆⍙_⎕]+|\#{1,2})'     ⍝ lookahead (?!\d) to reject numbers since \w includes them.
         NAM1←'((?!\d)[\w∆⍙_⎕]+|\#{2,2})'
         NAM←'(?:',NAM0,'(?:\.',NAM1,')*)'
         VAR←NAM,'|⍵{1,2}|⍺{1,2}|∇{1,2}'
         IO←'[⎕⍞]'
         ⋄ CTLe←'IF|WHILE|REPEAT|SELECT|CASE|FOR|HOLD|TRAP'
         CTL←':(?i:',CTLe,'|END(?:',CTLe,')|THEN|ELSE|ELSEIF|ANDIF|ORIF|CASE|UNTIL|IN|INEACH)\b'
         APL←'[!@#\$%\^&*_+\|,./<>?⊢¨\¯<≤=≥>≠∨∧×÷⌶⍫⍒⍋⌽⍉⊖⍟⍱⍲!⌹?∊⍴~↑↓⍳○*←→⍷⍨⍸⍥⍣⍞⍬⌈⌊∇∆∘⍎⍕⍤⌷≡≡≢⊂⊃∩∪⊥⊤|⍀⌿⍪⍙⍠]'
         BRKl←'[[(]'
         BRKr←'[])]'
         BRACEl←'{'
         BRACEr←'}'
         SEMI←';'
         GUARD←':'
         NL←'\h*\R'       ⍝ Spaces at end of lines are ignored (as padding)
         SP←'\h+'         ⍝ Trailing spaces are handled (and ignored) by NL above.
         MSC←'.'

         RE∆GET←{
             ⍵≥≢⍺.Offsets:''
             ⍺.Lengths[⍵]≡⎕NULL:''
             ⍺.(Lengths[⍵]↑Offsets[⍵]↓Block)
         }
         ctlCase←{uc←1∘(819⌶) ⋄ lc←(819⌶)   ⍝ :abc → :Abc
             (uc 2↑⍵),lc 2↓⍵
         }
         unQuote←keepQuotes∘{⍺:⍵ ⋄ txt/⍨~(2⍴⊃⍵)⍷txt←1↓¯1↓⍵}
         checkSpaces←keepSpaces∘{⍺:⍵ ⋄ ⍵/⍨~'  '⍷t←⍵}

         patList←ASSIGN TRADr TRADl COM SQ DQ NUM VAR IO CTL APL BRKl BRKr BRACEl BRACEr SEMI GUARD NL SP MSC
         assign tradr tradl com sq dq num var io ctl apl brkl brkr dfnl dfnr semi grd nl sp msc←⍳≢patList

         typesStd←'ASGN' ':TFN' 'TFN:' 'COM' 'SQ' 'DQ' 'NUM' 'VAR' 'IO' 'CTL' 'APL' 'BRK:' ':BRK' 'DFN:' ':DFN'
         typesStd,←'SEMI' 'GARD' 'NL' 'SP' 'MSC'
         typesHdr←typesStd
         typesHdr[typesHdr⍳'DFN:' ':DFN' 'SEMI']←'OPT:' ':OPT' 'LOC'

         parseTokens←{⍺←0
             curTypes←⍺⊃typesStd typesHdr

             tokLines←toks←⍬ ⋄ ln tn←0 0
       ⍝ eol: "close" current vector and "open" another. Ignore right arg.
             eol←{0=≢toks:⍬ ⋄ tokLines,←⊂toks ⋄ toks∘←⍬ ⋄ ln+←1 ⋄ tn∘←0}
             stow←{ ⍝ Refer to toks above
                 ns←⎕NS''
                 ns.(tokens types counts)←3⍴⍵,⊂⍬    ⍝ If counts missing, it's set to ⍬
                 ns.pos←ln tn ⋄ tn+←1
                 toks,←ns
                 ns⊣ns.⎕DF ns.tokens
             }


             procSearch←{
                 which tok←⍵.(PatternNum Match)
                 type←which⊃curTypes
                 which=assign:stow tok type
                 which=ctl:stow(ctlCase tok)type
                 which∊sq dq:stow(unQuote tok)type
                 which=num:stow(checkSpaces tok)type
                 which=var:stow tok(type'⎕SYS'⊃⍨'⎕'=1↑{f1 f2←⍵ ⋄ ×≢f2:f2 ⋄ f1}⍵ RE∆GET¨1 2)  ⍝ Is it a system var?
                 which=nl:eol stow NLvisible type
                 which=sp:stow⍣keepSpaces⊣' 'type(≢tok)
                 which=com:stow comOnly type(≢comLeadSpace)⊣comLeadSpace comOnly←⍵ RE∆GET¨1 2
                 which<≢patList:stow tok type ⍬
                 ⎕SIGNAL/emLogic
             }
             ø←(patList ⎕S procSearch⍠reOpts)⍵
             ø←eol ⎕NULL
             tokLines
         }

         govern←{
             brakStack←⍬ ⋄ tokLines←⍵
             govSet←{l t←⊃⌽brakStack ⋄ 1:(t⊃l⊃tokLines).counts←⍵}
             _←{lnum←⍵
                 {tnum←⍵
                     item←tnum⊃lnum⊃tokLines ⋄ tok←1↑item.tokens
                     tok∊'[({':brakStack,←⊂lnum tnum⊣item.counts←¯1 ¯1        ⍝ ¯1: In case no closing )]}
                     tok∊'])}':brakStack↓⍨←¯1⊣govSet lnum tnum⊣item.counts←⊃⌽brakStack
                     (tok=';')∧×≢brakStack:item.(counts types)←(⊃⌽brakStack)('SEMI')  ⍝ Semicolon w/in a brace/bracket.
                     ⍬
                 }¨⍳≢lnum⊃tokLines
             }¨⍳≢tokLines
             tokLines
         }

      ⍝⍝ ----------
         nc∊3 4:govern(1 parseTokens⊃text),(parse Tokens 1↓text)
         govern parseTokens text
     }(3↑⍺,0 1 1){
       ⍝ ⍺ must be 3 integers. 0=default. ⍺[0] nameclass, ⍺[1]=names are ok, ⍺[1]=spaces kept
         emDomain←('tokenize: input (⍵) must be ',(⍺[1]/'fn/op type or '),'code string/matrix')911
         emText←'tokenize: input text must be in matrix or vector character format' 911
         emSource←'tokenize: unable to acquire source for object named' 911
         0::⎕SIGNAL/emSource
         ⎕IO ⎕ML←0 1
         2=⍴⍴⍵:⍺[0](↓⍵)
         2=|≡⍵:⍺[0]⍵
         1≠|≡,⍵:⎕SIGNAL/emDomain
         ~⍺[1]:⍺[0](⊆,⍵)
         ⋄ nc←⎕NC ⍵
         nc=2:nc(⎕OR ⍵)
         nc∊3 4:nc(⎕NR ⍵)
         nc=9:nc(⎕SRC⍎⍵)
         ⍺[0](⊆,⍵)
     }⍵
 }
