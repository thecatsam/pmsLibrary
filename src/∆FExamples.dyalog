  r←∆FExamples
  ;all;cmpx;code;line;pline;skip;slow;timings
  ;C;Code;Dmd;E;FI;LINE;NoBL;S;Select;Show;Skip;Split;ToFn


  LINE←40⍴'🔴'
  line pline←70⍴¨'¨' '+'
  :If 'n'∊⎕C⊃⍞↓⍨≢⍞←'Include timings? [yes|no] '
      timings←0
      ⎕←'--- Skipping performance timings'
      cmpx←{
        ⎕←line
        ⎕←'>>> Skipped: cmp ',∊⎕FMT ⍵⊣⎕DL 1
        ⎕←line
        1:_←''
      }
  :Else
      pline
      ⎕←'+++ Keeping performance timings'
      pline
      timings←1
  :EndIf
   slow←'s'∊⎕C⊃⍞↓⍨≢⍞←'Execute/display Fast (F) or Slow (S)? [FAST] '
   ⎕←''

  :With ⎕NS ⍬    ⍝ Hide names to prevent exfiltration from examples executed...
    ⎕IO ⎕ML ⎕PW←0 1 120
    ∆Q←{q←'''' ⋄ q,q,⍨⍵/⍨1+⍵=q}
    S←{'⎕←',''''',',∆Q ⍵}  ⍝ Show
    C←{'⎕←','''  '',',∆Q ⍵}  ⍝ Com
    E←{'∆T ',∆Q ⍵}       ⍝ Eval

    ⍝ 2: object not defined. 6: syntax error (printing fn assignments. )
    ∆T←{1000::'' ⋄ _←⎕DL slow×1 ⋄ 2::_←'' ⋄ 6::_←''⊣⎕DL 5⊣⎕←'>>> ',⎕EM ⎕EN ⋄ ⎕←'⍎ ',⍵ ⋄ ⎕FMT⍎⍵}

    :If {0::0 ⋄ 1⊣(cat:1)}⍬                      ⍝ Dyalog20.
        ⎕←'Skipping examples marked skip' ⋄ ⎕DL 1
        skip←'\h*skip'
    :Else                                          ⍝ Not Dyalog20.
        ⎕←'Skipping examples marked dyalog20 or skip' ⋄ ⎕DL 1
        skip←'\h*(?:skip|dyalog20)'
    :EndIf

    code←'`{3}'
    all←'(.*?)'
  ⍝ We'll skip code sequences ```skip ... ```, where ... is any # of lines/chars.
    Skip←(code,skip,all,code)⎕R''⍠('EOL' 'LF')('Mode' 'M')('DotAll' 1)
    Code←∊(code,all,code)⎕S'\1 '⍠('EOL' 'LF')('Mode' 'M')('DotAll' 1)
    Dmd←'◇'⎕R'⋄'   ⍝ Apl eos
    Split←(⎕UCS 10)∘(≠⊆⊢)
    Select←{
      ('→'∊⍵)∧('⎕'∊⍵):S ⍵
      '⍝'=⊃⍵~' ':C ⍵
      1∊'←≡'∊⍵:E ⍵
      1∊'∆F'⍷⍵:E ⍵
      timings{
        1=⍺:0
        (1∊'⎕CY'⍷⍵)∧1∊'cmpx'⍷⍵:1⊣⎕DL 2⊣⎕←'>>> Suppressing: ',⍵
        0
      }⍵:C'⍝ ',⍵
      1∊'⎕CY'⍷⍵:E ⍵
      0=≢⍵:''
      ∧/⍵∊' ':''
      S ⍵
    }
    NoBL←{b←0=≢¨⍵ ⋄ (~b∧1⌽b)/⍵}
    ToFn←(⊂'∆FE ')∘,

    LINE
    ⎕←'Loading...'
    ⎕DL 1

    :If 0=⊃0⍴⎕FX ToFn NoBL Select¨#.FI←Split Dmd Code Skip⊃⎕NGET'∆F/∆FHelp.md'
        'Unable to ⎕FX ''∆FE'''
        :Return
    :EndIf

    ⎕←'Executing...'
    LINE
    ⎕WA
    ∆FE

  :If 1
        LINE
        ⎕←'+++ Performing Library Tests'
        line
        ⎕DL 2
        Show←{⎕←'>>>',⍵ ⋄ ⎕←⍎⍵ ⋄ line}
        Show'∆F''{£ → }'''
        Show'∆F''{ ↑£.apla ↓}'''
        Show'∆F''{ ↑£   .apla ↓}'''
        Show'∆F''{ ↑£   .      apla ↓}'''
        Show'0 1 ∆F''{ ⎕JSON⍠"Compact" 0⊢ £.j← £.json ↓} { `S £.j ↓}'''
        Show'∆F''(⍳10)⍳4 {(⍳10) £.fred 4 ↓}'''
        Show'∆F''{ 3 £.to 10 ↓}'''
  :EndIf
    LINE
    r←'Done!'
  :EndWith
