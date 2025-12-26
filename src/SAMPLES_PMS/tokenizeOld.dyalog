 __tokLines__←{__nc0__}tokenizeOld __code__;INCLUDE_SPACES;NAME_OK;item;line;stack;tnum;tok;⎕IO
⍝ Returns a vector of vectors of namespaces ⍵, each containing ⍵.types ⍵.tokens ⍵.counts
⍝    types:  'ASGN' 'COM' 'SQ' 'DQ' 'NUM' 'VAR' 'IO' 'CTL' 'APL' 'BRK' 'DFN:' ':DFN' 'SEMI' 'GARD' 'NL' 'SP' 'MSC'
⍝            'OPT:' ':OPT' 'LOC'
⍝    tokens: Actual tokens (SYS, system objects) will have title case: ⎕Tcnums
⍝    counts: (COM)        spaces before the ⍝ symbol.
⍝            (SP)         total number of contiguous spaces
⍝            '([{'        line num and token number of closing brace/bracket
⍝            ';}])'       line num and token number of opening brace/bracket. (SEMI: Only if within brace/brackets)
 ⎕IO←0
 __nc0__←0{0=⎕NC ⍵:⍺ ⋄ ⎕OR ⍵}'__nc0__'
  ⍝ Options
 NAME_OK←1                        ⍝ If 1 and options is a single vector, see if it's the name of a function or op or char vec of vectors.
 INCLUDE_SPACES←0                 ⍝ Include SP (space) tokens

 __tokLines__←{
     nc←⊃⍵ ⋄ text←,¨⊃⌽⍵

     ⎕IO ⎕ML←0 1

     NLvisible←⎕UCS 9252

     reOpts←('UCP' 1)('EOL' 'LF')('Mode' 'M')

⍝ Basic patterns
     ASSIGN←'←'
     COM←'(\h*)(⍝.*?)\h*$'             ⍝ comments include leading spaces, but not following spaces.
     SQ←'(?:''[^'']*'')+'
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
     BRK←'[\[\]()]'
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

     patList←ASSIGN COM SQ DQ NUM VAR IO CTL APL BRK BRACEl BRACEr SEMI GUARD NL SP MSC
     assign com sq dq num var io ctl apl brk dfnl dfnr semi grd nl sp msc←⍳≢patList

     typesStd←'ASGN' 'COM' 'SQ' 'DQ' 'NUM' 'VAR' 'IO' 'CTL' 'APL' 'BRK' 'DFN:' ':DFN' 'SEMI' 'GARD' 'NL' 'SP' 'MSC'
     typesHdr←typesStd
     typesHdr[typesHdr⍳'DFN:' ':DFN' 'SEMI']←'OPT:' ':OPT' 'LOC'

     tokenize2←{⍺←0
         curTypes←⍺⊃typesStd typesHdr

         tokLines←toks←⍬
       ⍝ eol: "close" current vector and "open" another. Ignore right arg.
         eol←{0=≢toks:⍬ ⋄ tokLines,←⊂toks ⋄ toks∘←⍬}
         stow←{
             ns←⎕NS''
             ns.(tokens types counts)←3⍴⍵,⊂⍬    ⍝ If counts missing, it's set to ⍬
             toks,←ns
             ns⊣ns.⎕DF ns.tokens
         }
         deq←{txt/⍨~(2⍴⊃⍵)⍷txt←1↓¯1↓⍵}

         procSearch←{
             which tok←⍵.(PatternNum Match)
             type←which⊃curTypes
             which=assign:stow tok type
             which=ctl:stow(ctlCase tok)type
             which=sq:stow(deq tok)type
             which=dq:stow(deq tok)type
             which=var:stow tok(type'⎕SYS'⊃⍨'⎕'=1↑{f1 f2←⍵ ⋄ ×≢f2:f2 ⋄ f1}⍵ RE∆GET¨1 2)  ⍝ Is it a system var?
             which=nl:eol stow NLvisible type
             which=sp:stow⍣INCLUDE_SPACES⊣' 'type(≢tok)
             which=com:stow comOnly type(≢comLeadSpace)⊣comLeadSpace comOnly←⍵ RE∆GET¨1 2
             which<≢patList:stow tok type ⍬
             ⎕SIGNAL/emLogic
         }
         ø←(patList ⎕S procSearch⍠reOpts)⍵
         ø←eol ⎕NULL
         tokLines
     }

     governance←{
         stack←⍬ ⋄ tokLines←⍵
         govSet←{l t←⊃⌽stack ⋄ 1:(t⊃l⊃tokLines).counts←⍵}
         _←{lnum←⍵
             {tnum←⍵
                 item←tnum⊃lnum⊃tokLines ⋄ tok←1↑item.tokens
                 tok∊'[({':stack,←⊂lnum tnum⊣item.counts←¯1 ¯1    ⍝ In case no closing!
                 tok∊'])}':stack↓⍨←¯1⊣govSet lnum tnum⊣item.counts←⊃⌽stack
                 (tok=';')∧×≢stack:item.(counts types)←(⊃⌽stack)('SEMI')  ⍝ Semicolon w/in a brace/bracket.
                 ⍬
             }¨⍳≢lnum⊃tokLines
         }¨⍳≢tokLines
         tokLines
     }

  ⍝⍝ ----------
     nc∊3 4:governance(1 tokenize2⊃text),(tokenize2 1↓text)
     governance tokenize2 text
 }__nc0__{
     ⍺←0  ⍝ If user specified assumed nameclass for text input, use it...
     emDomain←('tokenize: input (⍵) must be ',(NAME_OK/'fn/op type or '),'code string/matrix')911
     emText←'tokenize: input text must be in matrix or vector character format' 911
     emSource←'tokenize: unable to acquire source for object named' 911
     0::⎕SIGNAL/emSource
     ⎕IO ⎕ML←0 1
     2=⍴⍴⍵:⍺(↓⍵)
     2=|≡⍵:⍺ ⍵
     1≠|≡,⍵:⎕SIGNAL/emDomain
     ~NAME_OK:⍺(⊆,⍵)
     ⋄ nc←⎕NC ⍵
     nc=2:nc(⎕OR ⍵)
     nc∊3 4:nc(⎕NR ⍵)
     nc=9:nc(⎕SRC⍎⍵)
     ⍺(⊆,⍵)
 }__code__
