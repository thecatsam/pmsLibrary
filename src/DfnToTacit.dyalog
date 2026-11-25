D2T← {
      ⍙domainÊ← ⊂( 'EN' 11 ⋄ 'Message' 'Argument must be a char vector or scalar')
      ⎕IO← 0 ⋄ ⎕ML← 1 ⋄ ⍺← 1 
    1<|≡⍵: ⎕SIGNAL ⍙domainÊ
    ' '≠⊃0⍴⍵: ⎕SIGNAL ⍙domainÊ
      ⍙par ⍙sim← 2↑⍺,⍛,0 
      ⍙orig← ⍵
      ⍙letters1← ⎕A, ⎕C ⎕A 
      ⍙letters2← '⎕_∆⍙ÁÂÃÇÈÊËÌÍÎÏÐÒÓÔÕÙÚÛÝþãìðòõÀÄÅÆÉÑÖØÜßàáâäåæçèéêëíîïñóôöøùúûü'
      ⍙nameStart← ⍙letters1, ⍙letters2
      ⍙nameChars← ⍙nameStart,⎕D
      ⍙numChars← ⎕D,'.JjEe¯'
      ⍙fnChars← '+-×÷⌈⌊*⍟|!○?~∧∨⍲⍱<≤=≥>≠≡≢∊⍳⍴,⍪⍉⌽⊖⍋⍒⊣⊢↑↓⊂⊃∩∪⊥⊤⍎⍕⍸⍷⌷⊆'
      ⍙opChars← '/⌿\⍀¨⍨∘⌸⍤⍥⍛⍜⌺.'
      ⍙monOps← '/⌿\⍀¨⍨⌸⌺'
   ⍝  Names starting with ⍙... are treated as private...
      ⍙IsPrivate← '⍙'=⊃
   ⍝ Classifying system names...
      ⍙SysNames← { 
            v← ⎕C ⊃,/(
                  '⎕A' '⎕D' '⎕CT' '⎕FR' '⎕IO' '⎕ML' '⎕PP' '⎕PW' '⎕RL' '⎕NULL' '⎕DMX' '⎕DM' '⎕TS' 
                  '⎕WA' '⎕EN' '⎕EM' '⎕LC' '⎕TRAP' '⎕LX' '⎕WSID' '⎕THIS' '⎕SE' '⎕TC'
            )
            f← ⎕C ⊃,/(
                  '⎕NC' '⎕CR' '⎕FX' '⎕DR' '⎕VFI' '⎕UCS' '⎕FMT' '⎕NL' '⎕EX' '⎕C' '⎕NS' '⎕SIGNAL' '⎕JSON' '⎕CSV' 
                  '⎕XML' '⎕VFS' '⎕SS' '⎕DL' '⎕NA' '⎕NQ' '⎕WG' '⎕WC' '⎕DQ' '⎕CMD' '⎕ENV' '⎕RSI' '⎕SI' '⎕LOCK' '⎕STOP' 
                  '⎕TRACE' '⎕OFF' '⎕LOAD' '⎕SAVE' '⎕COPY' '⎕CS' '⎕DT' '⎕OR' '⎕MAP' '⎕PROFILE'
            )
            o← ⎕C ('⎕R' '⎕S')
            table← ↓⍉↑⊃,/v f o (⊂⍛,¨)¨ 0 1 2  ⋄ size← ≢0⊃ table 
            table size                                                                   
      }
      ⍙t ⍙s← ⍙SysNames ⍬ 
      ⍙SysNC← ⍙t{⍵⍵= p← (0⊃⍺⍺)⍳ ⊂⎕C ⍵: ¯1 ⋄ 1 p⊃⍺⍺}⍙s   
      ⍙Trim← {0=≢⍵: ⍵ ⋄ ⍵/⍨(∨\' '≠⍵)∧⌽∨\' '≠⌽⍵}
      ⍙JoinSp← {0=≢⍵: '' ⋄ 1↓∊' ',¨⍵}
      ⍙JoinNo← {0=≢⍵: '' ⋄ ∊⍵}
      ⍙Heur← {⍙c← ⊃⍵ ⋄ ⍙c∊⎕A : 1 ⋄ ⍙c∊⎕C ⎕A : 0 ⋄ ¯1}
      ⍙NameKind← {
          '⎕'=⊃⍵: ⍙SysNC ⍵
          0= ⍙nc← ⊃⎕NC ⍵: ⍙Heur ⍵
            1 0 0 ¯1⊃⍨3 2 9⍳⍙nc
      }
      ⍙StrEnd← {
            ⍙s ⍙i← ⍵
          ⍙i≥≢⍙s: ¯1
            ⍙p← ⍙s,' '
          (''''=⍙s[⍙i])∧''''=⍙p[⍙i+1]: ∇ ⍙s(⍙i+2)
          ''''=⍙s[⍙i]: ⍙i
            ∇ ⍙s(⍙i+1)
      }
      ⍙TokNum← {
            ⍙n← +/∧\⍵∊⍙numChars
            ⍙t← ⍙n↑⍵
          ~∨/⍙t∊⎕D: (0 ⍬)
            ⍙ok ⍙tk← ⍙TokR ⍙n↓⍵
          ~⍙ok: (0 ⍬)
            1 ,⊂(⊂'V',⍙t),⍙tk
      }
      ⍙TokStr← {
            ⍙e← ⍙StrEnd ⍵ 1
          ⍙e<0: (0 ⍬)
            ⍙t← (⍙e+1)↑⍵
            ⍙ok ⍙tk← ⍙TokR(⍙e+1)↓⍵
          ~⍙ok: (0 ⍬)
            1 ,⊂(⊂'V',⍙t),⍙tk
      }
      ⍙TokName← { 
            ⍙n← +/∧\⍵∊⍙nameChars
            ⍙t← ⍙n↑⍵
          ⍙IsPrivate ⍙t: (0 ⍬)
            ⍙r← ⍙n↓⍵
            ⍙p← ⍙r,'  '
          ('.'=⍙p[0])∧(⍙p[1])∊⍙nameStart: (0 ⍬)
            ⍙ok ⍙tk← ⍙TokR ⍙r
          ~⍙ok: (0 ⍬)
            1 ,⊂(⊂'N',⍙t),⍙tk
      }
      ⍙Tok1← {⍙ok ⍙tk← ⍙TokR 1↓⍵ ⋄ ~⍙ok: (0 ⍬) ⋄ 1 ,⊂(⊂⍺,⊃⍵),⍙tk}
      ⍙TokOD← {⍙ok ⍙tk← ⍙TokR 2↓⍵ ⋄ ~⍙ok: (0 ⍬) ⋄ 1 ,⊂(⊂'O∘.'),⍙tk}
      ⍙TokR← {
          0=≢⍵: (1 ⍬)
          ' '=⊃⍵: ∇1↓⍵
            ⍙c← ⊃⍵
            ⍙d← (⍵,' ')[1]
          ''''=⍙c: ⍙TokStr ⍵
          ⍙c∊⎕D: ⍙TokNum ⍵
          (⍙c='¯')∧⍙d∊⎕D,'.': ⍙TokNum ⍵
          (⍙c='.')∧⍙d∊⎕D: ⍙TokNum ⍵
          ⍙c∊⍙nameStart: ⍙TokName ⍵
          ⍙c∊'()': ⍙c ⍙Tok1 ⍵
          (⍙c='∘')∧⍙d='.': ⍙TokOD ⍵
          ⍙c∊⍙fnChars: 'F'⍙Tok1 ⍵
          ⍙c∊⍙opChars: 'O'⍙Tok1 ⍵
          ⍙c='⍬': 'V'⍙Tok1 ⍵
          (⍙c='⍺')∧⍙d≠'⍺': 'V'⍙Tok1 ⍵
          (⍙c='⍵')∧⍙d≠'⍵': 'V'⍙Tok1 ⍵
            (0 ⍬)
      }
      ⍙Tok← {⍙ok ⍙tk← ⍙TokR ⍵ ⋄ ~⍙ok: (0 ⍬) ⋄ 1 ,⊂⍙tk}
      ⍙Depths← {0=≢⍵: ⍬ ⋄ ⍙dl← ((⊃¨⍵)='(')-((⊃¨⍵)=')') ⋄ 0,¯1↓+\⍙dl}
      ⍙HasVar← {∨/⍵∊'V⍺' 'V⍵'}
      ⍙Texts← {1↓¨⍵}
      ⍙Match← {
            ⍙tk ⍙dp ⍙i← ⍵
            ⍙js← (⍙i+1)↓⍳≢⍙tk
            ⍙cd← ⍙js/⍨((⊃¨⍙tk[⍙js])=')')∧⍙dp[⍙js]=1+⍙dp[⍙i]
          0=≢⍙cd: ¯1
            ⊃⍙cd
      }
      ⍙MatchOpen← {
            ⍙tk ⍙dp ⍙k← ⍵
            ⍙js← ⍙k↑⍳≢⍙tk
            ⍙cd← ⍙js/⍨((⊃¨⍙tk[⍙js])='(')∧⍙dp[⍙js]=¯1+⍙dp[⍙k]
          0=≢⍙cd: ¯1
            ⊃⌽⍙cd
      }
      ⍙ParenIsFn← {
            ⍙tk ⍙dp ⍙i ⍙j← ⍵
            ⍙in← (⍙i+1)+⍳(¯1+⍙j-⍙i)
            ⍙tp← ⍙in/⍨⍙dp[⍙in]=1+⍙dp[⍙i]
          0=≢⍙tp: ¯1
            ⍙k← ⊃⌽⍙tp
            ⍙kd← ⊃⍙k⊃⍙tk
          ⍙kd∊'VN': 0
          ⍙kd∊'FO': 1
          ⍙kd=')': ∇ ⍙tk ⍙dp(⍙MatchOpen ⍙tk ⍙dp ⍙k)⍙k
            ¯1
      }
      ⍙StripParens← {
            ⍙e← ⍙Trim ⍵
          0=≢⍙e: ⍙e
            ⍙ok ⍙tk← ⍙Tok ⍙e
          ~⍙ok: ⍙e
          2>≢⍙tk: ⍙e
          (⊃⍙tk)≢'((': ⍙e
          (⊃⌽⍙tk)≢'))': ⍙e
            ⍙dp← ⍙Depths ⍙tk
            ⍙m← ⍙Match ⍙tk ⍙dp 0
          ⍙m≠¯1+≢⍙tk: ⍙e
            ∇ ⍙JoinSp ⍙Texts 1↓¯1↓⍙tk
      }
      ⍙ParseOps← {
            ⍙tk ⍙dp ⍙i ⍙f← ⍵
          ⍙i≥≢⍙tk: (⍙i ⍙f)
          ⍙dp[⍙i]≠0: (⍙i ⍙f)
            ⍙kd← ⊃⍙i⊃⍙tk
            ⍙tx← 1↓⍙i⊃⍙tk
          ⍙kd≠'O': (⍙i ⍙f)
          (1=≢⍙tx)∧(⊃⍙tx)∊⍙monOps: ∇ ⍙tk ⍙dp(⍙i+1)(⍙f,⍙tx)
          (⍙tx≡,'⍣')∨⍙tx≡,'⍠': (¯1 '')
          ~((⍙tx≡'∘.')∨(1=≢⍙tx)∧(⊃⍙tx)∊'∘.⍤⍥⍛⍜'): (⍙i ⍙f)
            ⍙Dyad ⍙tk ⍙dp ⍙i ⍙f ⍙tx
      }
      ⍙Dyad← {
            ⍙tk ⍙dp ⍙i ⍙f ⍙op← ⍵
            ⍙j← ⍙i+1
          ⍙j≥≢⍙tk: (¯1 '')
          ⍙dp[⍙j]≠0: (¯1 '')
            ⍙rk← ⊃⍙j⊃⍙tk
          ⍙rk='F': ⍙DyadFn ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j
          ⍙rk='N': ⍙DyadName ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j
          ⍙rk='V': ⍙DyadVal ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j
          ⍙rk='(': ⍙DyadPar ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j
            (¯1 '')
      }
      ⍙DyadFn← {
            ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j← ⍵
            ⍙ok ⍙e ⍙s← ⍙ParseFn ⍙tk ⍙dp ⍙j
          ~⍙ok: (¯1 '')
            ⍙ParseOps ⍙tk ⍙dp ⍙e(⍙f,⍙op,⍙s)
      }
      ⍙DyadName← {
            ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j← ⍵
            ⍙k← ⍙NameKind 1↓⍙j⊃⍙tk
          ⍙k=1: ⍙DyadFn ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j
          ⍙k≠0: (¯1 '')
          ~((⍙op≡,'∘')∨⍙op≡,'⍤'): (¯1 '')
            ⍙ParseOps ⍙tk ⍙dp(⍙j+1)(⍙f,⍙op,1↓⍙j⊃⍙tk)
      }
      ⍙DyadVal← {
            ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j← ⍵
            ⍙t← 1↓⍙j⊃⍙tk
          (⍙t≡,'⍺')∨⍙t≡,'⍵': (¯1 '')
          ~((⍙op≡,'∘')∨⍙op≡,'⍤'): (¯1 '')
            ⍙ParseOps ⍙tk ⍙dp(⍙j+1)(⍙f,⍙op,⍙t)
      }
      ⍙DyadPar← {
            ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j← ⍵
            ⍙m← ⍙Match ⍙tk ⍙dp ⍙j
          ⍙m<0: (¯1 '')
            ⍙pf← ⍙ParenIsFn ⍙tk ⍙dp ⍙j ⍙m
          ⍙pf=1: ⍙DyadFn ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j
          ⍙pf≠0: (¯1 '')
          ~((⍙op≡,'∘')∨⍙op≡,'⍤'): (¯1 '')
          ⍙HasVar ⍙tk[⍙j+⍳(1+⍙m-⍙j)]: (¯1 '')
            ⍙pt← ⍙JoinSp ⍙Texts ⍙tk[⍙j+⍳(1+⍙m-⍙j)]
            ⍙ParseOps ⍙tk ⍙dp(⍙m+1)(⍙f,⍙op,⍙pt)
      }
      ⍙BindLeft← {
            ⍙tk ⍙dp ⍙i ⍙lt← ⍵
          ⍙i≥≢⍙tk: (0 ⍙i '')
          ⍙dp[⍙i]≠0: (0 ⍙i '')
          (⍙i⊃⍙tk)≢'O∘': (0 ⍙i '')
            ⍙ok ⍙e ⍙s← ⍙ParseFn ⍙tk ⍙dp(⍙i+1)
          ~⍙ok: (0 ⍙i '')
            ⍙e2 ⍙f2← ⍙ParseOps ⍙tk ⍙dp ⍙e(⍙lt,'∘',⍙s)
          ⍙e2<0: (0 ⍙i '')
            (1 ⍙e2 ⍙f2)
      }
      ⍙PrimFn← {
            ⍙tk ⍙dp ⍙i ⍙tx← ⍵
            ⍙e ⍙s← ⍙ParseOps ⍙tk ⍙dp(⍙i+1)⍙tx
          ⍙e<0: (0 ⍙i '')
            (1 ⍙e ⍙s)
      }
      ⍙PrimVal← {
            ⍙tk ⍙dp ⍙i ⍙tx← ⍵
          (⍙tx≡,'⍺')∨⍙tx≡,'⍵': (0 ⍙i '')
            ⍙BindLeft ⍙tk ⍙dp(⍙i+1)⍙tx
      }
      ⍙PrimName← {
            ⍙tk ⍙dp ⍙i ⍙tx← ⍵
            ⍙k← ⍙NameKind ⍙tx
          ⍙k=1: ⍙PrimFn ⍙tk ⍙dp ⍙i ⍙tx
          ⍙k≠0: (0 ⍙i '')
            ⍙BindLeft ⍙tk ⍙dp(⍙i+1)⍙tx
      }
      ⍙PrimParFn← {
            ⍙tk ⍙dp ⍙i ⍙m← ⍵
            ⍙pt← ⍙JoinSp ⍙Texts ⍙tk[⍙i+⍳(1+⍙m-⍙i)]
            ⍙e ⍙s← ⍙ParseOps ⍙tk ⍙dp(⍙m+1)⍙pt
          ⍙e<0: (0 ⍙i '')
            (1 ⍙e ⍙s)
      }
      ⍙PrimPar← {
            ⍙tk ⍙dp ⍙i← ⍵
            ⍙m← ⍙Match ⍙tk ⍙dp ⍙i
          ⍙m<0: (0 ⍙i '')
            ⍙pf← ⍙ParenIsFn ⍙tk ⍙dp ⍙i ⍙m
          ⍙pf=1: ⍙PrimParFn ⍙tk ⍙dp ⍙i ⍙m
          ⍙pf≠0: (0 ⍙i '')
          ⍙HasVar ⍙tk[⍙i+⍳(1+⍙m-⍙i)]: (0 ⍙i '')
            ⍙BindLeft ⍙tk ⍙dp(⍙m+1)(⍙JoinSp ⍙Texts ⍙tk[⍙i+⍳(1+⍙m-⍙i)])
      }
      ⍙PrimOp← {
            ⍙tk ⍙dp ⍙i ⍙tx← ⍵
          (1≠≢⍙tx)∨~(⊃⍙tx)∊'/⌿\⍀': (0 ⍙i '')
            ⍙e ⍙s← ⍙ParseOps ⍙tk ⍙dp(⍙i+1)('⊢⍤',⍙tx)
          ⍙e<0: (0 ⍙i '')
            (1 ⍙e ⍙s)
      }
      ⍙ParseFn← {
            ⍙tk ⍙dp ⍙i← ⍵
          ⍙i≥≢⍙tk: (0 ⍙i '')
          ⍙dp[⍙i]≠0: (0 ⍙i '')
            ⍙kd← ⊃⍙i⊃⍙tk
            ⍙tx← 1↓⍙i⊃⍙tk
          ⍙kd='F': ⍙PrimFn ⍙tk ⍙dp ⍙i ⍙tx
          ⍙kd='N': ⍙PrimName ⍙tk ⍙dp ⍙i ⍙tx
          ⍙kd='V': ⍙PrimVal ⍙tk ⍙dp ⍙i ⍙tx
          ⍙kd='(': ⍙PrimPar ⍙tk ⍙dp ⍙i
          ⍙kd='O': ⍙PrimOp ⍙tk ⍙dp ⍙i ⍙tx
            (0 ⍙i '')
      }
      ⍙FindPrin← {
            ⍙tk ⍙dp ⍙i← ⍵
          ⍙i≥≢⍙tk: (0 ⍙i ⍙i '')
          ⍙dp[⍙i]≠0: ∇ ⍙tk ⍙dp(⍙i+1)
            ⍙ok ⍙e ⍙s← ⍙ParseFn ⍙tk ⍙dp ⍙i
          ⍙ok: (1 ⍙i ⍙e ⍙s)
            ∇ ⍙tk ⍙dp(⍙i+1)
      }
      ⍙Commute← {∨/⍵∊⍙opChars,'() ' : '(',⍵,')⍨' ⋄ ⍵,'⍨'}
      ⍙ParenConst← {
            ⍙ok ⍙tk← ⍙Tok ⍵
          ~⍙ok: '(',⍵,')'
            ⍙dp← ⍙Depths ⍙tk
            ⍙top← ⍙tk/⍨⍙dp=0
          ∨/(⊃¨⍙top)∊'FO': '(',⍵,')'
            ⍵
      }
      ⍙IsMonOm← {
            ⍙e← ⍙StripParens ⍵
            ⍙ok ⍙tk← ⍙Tok ⍙e
          ~⍙ok: (0 '')
            ⍙dp← ⍙Depths ⍙tk
          (0≠+/(((⊃¨⍙tk)='(')-((⊃¨⍙tk)=')')))∨∨/⍙dp<0: (0 '')
            ⍙fd ⍙s ⍙n ⍙f← ⍙FindPrin ⍙tk ⍙dp 0
          ~⍙fd: (0 '')
          ⍙s≠0: (0 '')
          (⍙StripParens ⍙JoinSp ⍙Texts ⍙n↓⍙tk)≢,'⍵': (0 '')
            (1 ⍙f)
      }
      ⍙StrandPar← {
            ⍙tk ⍙dp ⍙i ⍙ac← ⍵
            ⍙m← ⍙Match ⍙tk ⍙dp ⍙i
          ⍙m<0: ⍬
            ⍙Strand ⍙tk ⍙dp(⍙m+1)(⍙ac,(⊂⍙JoinSp ⍙Texts ⍙tk[⍙i+⍳(1+⍙m-⍙i)]))
      }
      ⍙Strand← {
            ⍙tk ⍙dp ⍙i ⍙ac← ⍵
          ⍙i≥≢⍙tk: ⍙ac
          ⍙dp[⍙i]≠0: ⍬
            ⍙kd← ⊃⍙i⊃⍙tk
          ⍙kd∊'VN': ∇ ⍙tk ⍙dp(⍙i+1)(⍙ac,(⊂1↓⍙i⊃⍙tk))
          ⍙kd='(': ⍙StrandPar ⍙tk ⍙dp ⍙i ⍙ac
            ⍬
      }
      ⍙TacNoPrin← {
            ⍙e ⍙tk ⍙dp← ⍵
            ⍙it← ⍙Strand ⍙tk ⍙dp 0 ⍬
          (0=≢⍙it)∨2>≢⍙it: ⍬
            ⍙pt← {'(⊂',⍵,')'}¨⍙it
            ⍙Tac '(', (1↓∊',',¨⍙pt), ')'
      }
      ⍙TacAfY← {
            ⍙l ⍙f ⍙r← ⍵
            ⍙t← ⍙Tac ⍙r
          ⍙t≡⍬: ⍬
            '(', (⍙ParenConst ⍙l), ⍙f, ⍙t, ')'
      }
      ⍙TacXfA← {
            ⍙l ⍙f ⍙r← ⍵
            ⍙t← ⍙Tac ⍙l
          ⍙t≡⍬: ⍬
            '(', (⍙ParenConst ⍙r), (⍙Commute ⍙f), ⍙t, ')'
      }
      ⍙TacBoth← {
            ⍙l ⍙f ⍙r← ⍵
          ((⍙StripParens ⍙l)≡,'⍺')∧(⍙StripParens ⍙r)≡,'⍵': ⍙f
            ⍙lm ⍙g← ⍙IsMonOm ⍙l
            ⍙rm ⍙h← ⍙IsMonOm ⍙r
          ⍙lm∧⍙rm: '((',⍙g,⍙f,⍙h,')⊢)'
          ⍙lm∧(⍙StripParens ⍙r)≡,'⍵': '((',⍙g,⍙f,'⊢',')⊢)'
          ⍙rm∧(⍙StripParens ⍙l)≡,'⍵': '((','⊢',⍙f,⍙h,')⊢)'
            ⍙lt← ⍙Tac ⍙l
          ⍙lt≡⍬: ⍬
            ⍙rt← ⍙Tac ⍙r
          ⍙rt≡⍬: ⍬
            '(',⍙lt,⍙f,⍙rt,')'
      }
      ⍙TacDyad← {
            ⍙l ⍙f ⍙r ⍙hl ⍙hr← ⍵
          ⍙hl∧⍙hr: ⍙TacBoth ⍙l ⍙f ⍙r
          (~⍙hl)∧⍙hr: ⍙TacAfY ⍙l ⍙f ⍙r
          ⍙hl∧~⍙hr: ⍙TacXfA ⍙l ⍙f ⍙r
            ⍬
      }
      ⍙IsArr← {
            ⍙tk ⍙dp← ⍵
            ⍙top← (⍳≢⍙tk)/⍨⍙dp=0
          0=≢⍙top: 0
            ⍙k← ⊃⌽⍙top
            ⍙kd← ⊃⍙k⊃⍙tk
          ⍙kd∊'VN': 1
          ⍙kd∊'FO': 0
          ⍙kd≠')': 0
            ⍙o← ⍙MatchOpen ⍙tk ⍙dp ⍙k
          ⍙o<0: 0
            0=⍙ParenIsFn ⍙tk ⍙dp ⍙o ⍙k
      }
            ⍙IsVal← {⍙ns← ⍵/⍨(⊃¨⍵)='N' ⋄ 0=≢⍙ns: 1 ⋄ ∧/0=⍙NameKind¨1↓¨⍙ns}
      ⍙TacConst← {
            ⍙e ⍙tk ⍙dp← ⍵
          ~⍙IsArr ⍙tk ⍙dp: ⍬
          ~⍙sim: '((',⍙e,')⊣⊣)'
          ~⍙IsVal ⍙tk: '((',⍙e,')⊣⊣)'
            '((',⍙e,')⍨)'
      }
      ⍙TacMon← {⍙f ⍙r← ⍵ ⋄ ⍙t← ⍙Tac ⍙r ⋄ ⍙t≡⍬: ⍬ ⋄ '(',⍙f,⍙t,')'}
      ⍙Tac← {
            ⍙e← ⍙StripParens ⍙Trim ⍵
          0=≢⍙e: ⍬
          ⍙e≡,'⍺': '⊣'
          ⍙e≡,'⍵': '⊢'
            ⍙ok ⍙tk← ⍙Tok ⍙e
          ~⍙ok: ⍬
            ⍙dp← ⍙Depths ⍙tk
          (0≠+/(((⊃¨⍙tk)='(')-((⊃¨⍙tk)=')')))∨∨/⍙dp<0: ⍬
          ~∨/(⊃¨⍙tk)∊'VN()': ⍬
          ~⍙HasVar ⍙tk: ⍙TacConst ⍙e ⍙tk ⍙dp
            ⍙fd ⍙s ⍙n ⍙f← ⍙FindPrin ⍙tk ⍙dp 0
          ~⍙fd: ⍙TacNoPrin ⍙e ⍙tk ⍙dp
            ⍙fok ⍙ftk← ⍙Tok ⍙f
          ~⍙fok: ⍬
          ⍙HasVar ⍙ftk: ⍬
          ⍙s=0: ⍙TacMon ⍙f(⍙JoinSp ⍙Texts ⍙n↓⍙tk)
            ⍙l← ⍙JoinSp ⍙Texts ⍙s↑⍙tk
            ⍙r← ⍙JoinSp ⍙Texts ⍙n↓⍙tk
            ⍙TacDyad ⍙l ⍙f ⍙r(⍙HasVar ⍙s↑⍙tk)(⍙HasVar ⍙n↓⍙tk)
      }
      ⍙s← ⍙Trim ⍙orig
    2>≢⍙s: ⎕NULL
    ('{'≠⊃⍙s)∨'}'≠⊃⌽⍙s: ⎕NULL
      ⍙body← ⍙Trim 1↓¯1↓⍙s
    0=≢⍙body: ⎕NULL
      ⍙ok ⍙tk← ⍙Tok ⍙body
    ~⍙ok: ⎕NULL
      ⍙dp← ⍙Depths ⍙tk
    (0≠+/(((⊃¨⍙tk)='(')-((⊃¨⍙tk)=')')))∨∨/⍙dp<0: ⎕NULL
      ⍙res← ⍙Tac ⍙body
    ⍙res≡⍬: ⎕NULL
    ⍙par=1: ⍙res ⋄ t↓ ⍙res↓⍨ -t← '('= ⊃⍙res 
      
   ⍝ DfnToTacit — one-line dfn string → tacit string, else ⎕NULL.
   ⍝ Dyalog v21, pure dfn style.
   ⍝
   ⍝ What it does:
   ⍝   • Converts a one-line dfn (e.g. '{⍺+⍵}') to its tacit form ('+').
   ⍝   • Returns ⎕NULL when the dfn cannot be converted.
   ⍝
   ⍝ Rules (Scholes, dfns.dyalog.com/n_tacit.htm):
   ⍝   • {X f Y}  {f Y}  {A f Y}  {X f A}  {⍺}  {⍵}  {A}, plus the strand rule.
   ⍝   • Optimisations: (⊣ f ⊢)→f, (⊢ f ⊣)→f⍨, (g ⍵) f (h ⍵)→(g f h)⊢
   ⍝     and one-sided variants.
   ⍝
   ⍝ Returns ⎕NULL on:
   ⍝   • ← ⋄ ; ⍝ : ∇ ⍺⍺ ⍵⍵, nested {}, [], ⍣, ⍠, dotted names,
   ⍝     ⍙-initial names, ⍺/⍵ in an operator operand, or any parse failure.
   ⍝
   ⍝ Names:
   ⍝   • Resolved via ⎕NC in the calling namespace; unknown names use the
   ⍝     case heuristic (uppercase→function, lowercase→value).
   ⍝   • ⎕-initial names use ⍙SysNC (built by ⍙SysNames inside D2T), since
   ⍝     ⎕NC returns ¯1 for all system names. ⍙SysNC: 0=value, 1=function,
   ⍝     2=operator, ¯1=unknown.
   ⍝   • Tacit freezes free names at definition time (Scholes).
   ⍝   • Locals use the ⍙ prefix, and the tokenizer rejects ⍙-initial names,
   ⍝     so a user name can never collide with a local when ⎕NC resolves it.
   ⍝     (The prefix alone does not hide locals from ⎕NC.)
   ⍝   • Naming: ⍙-functions use a capital 2nd letter (⍙Tok, ⍙TacConst);
   ⍝     ⍙-variables use a lowercase 2nd letter (⍙tk, ⍙orig). Operators
   ⍝     are not given ⍙ names.
   ⍝
   ⍝ Options (⍺ is a 2-vector [paren simplify]):
   ⍝   • ⍺[0]=1 keeps parens; ⍺[1]=1 enables ⊣⊣→⍨ simplification in ⍙TacConst
   ⍝     when ⍙IsVal proves every name in the body is a value.
   ⍝   • A scalar ⍺ still works (simplify defaults to 0).
   ⍝   • (X)⊣⊣≡(X)⍨ only when X is a value — for functions they differ monadically.
   ⍝
   ⍝ Revision history:
   ⍝   • 2026-11-17: string test via prototype; tokenizer returns 1 ,⊂(…),⍙tk.
   ⍝   • 2026-11-22: ⍙Tok passes ⍙TokR's plain strings through (no ⊃¨ — it takes
   ⍝     first chars only); readers use pick (⍙i⊃⍙tk), not bracket indexing,
   ⍝     since ⍙tk[⍙i] returns the token ENCLOSED and broke the ⍙kd='F' guard.
   ⍝     (Pete's fix.)
   ⍝   • 2026-11-22 (2): single-char ≡/≢ compare against ,'x' — 1↓/⍙JoinSp give
   ⍝     1-element vectors but 'x' is a scalar, so ≡ never matched and
   ⍝     ⍙Tac/⍙TacBoth/⍙PrimVal never recognised ⍺/⍵ (Diag4).
   ⍝   • 2026-11-22 (3): unconvertible inputs return ⎕NULL instead of the
   ⍝     original, so failure is distinguishable (Pete).
   ⍝   • 2026-11-22 (4): fixed the ⍳a-b-c precedence trap — APL evaluates right
   ⍝     to left, so ⍳⍙j-⍙i-1 was ⍳(⍙j-⍙i+1), making ⍙ParenIsFn recurse on
   ⍝     itself (the left-paren hang, Diag7). Parentheses alone do NOT fix it;
   ⍝     the counts are reordered so the subtraction binds first:
   ⍝     ⍳(¯1+⍙j-⍙i), ⍳(1+⍙m-⍙i), ⍳(1+⍙m-⍙j). The paren-group sites had the
   ⍝     mirror bug, dropping two tokens.
   ⍝   • 2026-11-22 (5): bare dyadic operators /⌿\⍀ as principals convert to the
   ⍝     functional form (⊢⍤op) via ⍙PrimOp, so {(⍵>0)/⍵} gives
   ⍝     ((0>⍨⊢)(⊢⍤/)⊢) instead of ⎕NULL (Pete). Monadic operator suffixes
   ⍝     (as in -/⍵) are still handled by ⍙ParseOps.
   ⍝   • 2026-11-22 (6): ⍙NameKind consults ⍙SysNC for ⎕-initial names; ⍙SysNames
   ⍝     is called inside D2T, so no setup step is needed.
   ⍝   • 2026-11-22 (7): ⍺ is now a 2-vector [paren simplify] (see Options above).
   ⍝   • 2026-11-23: long dfns split into multiline form; ⍙-names renamed
   ⍝     (functions capital 2nd letter, variables lowercase 2nd letter).
}
