 Execute←{
 ⍝(res (code subcode))←{where} Execute string
 ⍝ Executes ⍎ <string> in environment <where>, which defaults to the calling env.
 ⍝ <string> may consist of 1 or more statements. The result returned depends
 ⍝ on whether there is an assignment leftmost in the final statment.
 ⍝ Useful in interactive environments, where you may not wish to show a result
 ⍝ unless the user expects it (a value is returned and it's NOT shy).
 ⍝
 ⍝    Final stmt result     What's returned     code/subcode    example
 ⍝    valid, nonshy         result              0    0        ⍳5
 ⍝    valid assignment      result             85    0        a[3 4 5]←⍳3, _←⎕DL 1
 ⍝    valid, shy            ⍬                  85    0        ⎕DL 1
 ⍝    valid with no value   ⍬                  85    0        {}⎕DL 1
 ⍝    invalid (error)       ⎕EM, Message       ⎕EN   ⎕ENX     ⍳1.1, _←⎕DL K  ⍝ K undefined

     ⍺←⊃⎕RSI
     ⍺(⎕NS'').{  ⍝ ⎕NS: Execute away from user namespace...
         0::⎕DMX.(((⊃DM),Message,⍨': '/⍨0≠≢Message)(EN ENX))
         res←⍬ ⋄ 85::res(85 0)

         literal←'(?:''[^'']*'')+|⍝.*'
         parens←'(?<Pair2>\((?>[^\(\)''⍝]+|',literal,'|(?&Pair2)*)+\))'
         index←'(?<Pair1>\[(?>[^\[\]''⍝]+|',literal,'|(?&Pair1)*)+\])'
         names←'[#⎕∆⍙\w\.]+ (\h+[#⎕∆⍙\w\.]+)*'
         assignP←'(?x)^ \h* (?<NM>(?|',parens,'|',names,')(?:',index,')?)\h* ← \h* (?<CD>.*)$'

       ⍝ Split ⍵ into ⋄-separated statements. <final> is last (or only) stmt.
         multi←1<≢stmts←literal'⋄'⎕R'\0' '\n'⊣⊆⍵
         preamble final←(¯1↓stmts)(⊃⌽stmts)
         preamble←multi/∊preamble,¨'⋄'

       ⍝ Do we have an assignment as the last (left-most) operation in the last stmt?
       ⍝    format:     targets ← code,
       ⍝       e.g.     t1 t2 t3←code  OR  (t1 t2 t3)←code  OR  t1[anything]←code etc
         asgn←assignP ⎕S'\<NM>\n\<CD>'⍠('UCP' 1)⊣final
         0=≢asgn:res(0 0)⊣res←⍺.{1(85⌶)⍵}⍵            ⍝ No!   Done
         targets code←(⎕UCS 10)(≠⊆⊢)⊃asgn             ⍝ Yes!  Separate targets from code...
      ⍝  Execute 'val←preamble ⋄ code', then assign: '<targets> ← <val>'
         val(85 0)⊣targets(⍺{⍺⍺⍎⍺,'←⍵'})⊣val←⍺⍎preamble,code
     },⍵

 }
