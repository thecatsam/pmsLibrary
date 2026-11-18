DfnToTacit←{
 ⍝ DfnToTacit — one-line dfn string → tacit string, else original.
⍝ Dyalog v21, pure dfn style. Revised 2026-11-17: ⍙isStr prototype test,
⍝ tokenizer returns 1 ,⊂(…),⍙tk, ⍙tokR raw + ⍙tok disclose wrapper.
⍝ Rules: Scholes, dfns.dyalog.com/n_tacit.htm — {X f Y} {f Y} {A f Y}
⍝ {X f A} {⍺} {⍵} {A}, plus strand rule. Optimisations: (⊣ f ⊢)→f,
⍝ (⊢ f ⊣)→f⍨, (g ⍵) f (h ⍵)→(g f h)⊢ and one-sided variants.
⍝ Returns original on: ← ⋄ ; ⍝ : ∇ ⍺⍺ ⍵⍵ nested {} [] ⍣ ⍠ dotted
⍝ names, ⍙-initial names, ⍺/⍵ in an operator operand, or any parse failure.
⍝ Names use ⎕NC in the calling ns; unknown uppercase→function,
⍝ lowercase→value. Tacit freezes free names at definition time (Scholes).
⍝ Locals use ⍙ prefix so ⎕NC cannot see them as user names.
   ⍝ DfnToTacit — one-line dfn string → tacit string, else original.
⍝ Dyalog v21, pure dfn style. Revised 2026-11-17: ⍙isStr prototype test,
⍝ tokenizer returns 1 ,⊂(…),⍙tk, ⍙tokR raw + ⍙tok disclose wrapper.
⍝ Rules: Scholes, dfns.dyalog.com/n_tacit.htm — {X f Y} {f Y} {A f Y}
⍝ {X f A} {⍺} {⍵} {A}, plus strand rule. Optimisations: (⊣ f ⊢)→f,
⍝ (⊢ f ⊣)→f⍨, (g ⍵) f (h ⍵)→(g f h)⊢ and one-sided variants.
⍝ Returns original on: ← ⋄ ; ⍝ : ∇ ⍺⍺ ⍵⍵ nested {} [] ⍣ ⍠ dotted
⍝ names, ⍙-initial names, ⍺/⍵ in an operator operand, or any parse failure.
⍝ Names use ⎕NC in the calling ns; unknown uppercase→function,
⍝ lowercase→value. Tacit freezes free names at definition time (Scholes).
⍝ Locals use ⍙ prefix, and the tokenizer rejects ⍙-initial names, so a
⍝ user name can never collide with a local when ⎕NC resolves it. (The
⍝ prefix alone does not hide locals from ⎕NC.)

    ().{
    ⎕IO←0 ⋄ ⎕ML←1
    ⍙orig←⍵
    ⍙letters←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    ⍙digits←'0123456789'
    ⍙nameStart←⍙letters,'_∆⍙⎕Ê'
    ⍙nameChars←⍙nameStart,⍙digits
    ⍙numChars←'0123456789.JjEe¯'
    ⍙fnChars←'+-×÷⌈⌊*⍟|!○?~∧∨⍲⍱<≤=≥>≠≡≢∊⍳⍴,⍪⍉⌽⊖⍋⍒⊣⊢↑↓⊂⊃∩∪⊥⊤⍎⍕⍸⍷⌷⊆'
    ⍙opChars←'/⌿\⍀¨⍨∘⌸⍤⍥⍛⍜⌺.'
    ⍙monOps←'/⌿\⍀¨⍨⌸⌺'
    ⍙trim←{0=≢⍵:⍵ ⋄ ⍵/⍨(∨\' '≠⍵)∧⌽∨\' '≠⌽⍵}
    ⍙joinSp←{0=≢⍵:'' ⋄ 1↓∊' ',¨⍵}
    ⍙joinNo←{0=≢⍵:'' ⋄ ∊⍵}
    ⍙heur←{⍙c←⊃⍵ ⋄ ⍙c∊'ABCDEFGHIJKLMNOPQRSTUVWXYZ':1 ⋄ ⍙c∊'abcdefghijklmnopqrstuvwxyz':0 ⋄ ¯1}
    ⍙nameKind←{⍙nc←⊃##.⎕NC ⍵ ⋄ 3=⍙nc:1 ⋄ 2=⍙nc:0 ⋄ 9=⍙nc:0 ⋄ 0=⍙nc:⍙heur ⍵ ⋄ ¯1}
    ⍙strEnd←{⍙s ⍙i←⍵ ⋄ ⍙i≥≢⍙s:¯1 ⋄ ⍙p←⍙s,' ' ⋄ (''''=⍙s[⍙i])∧''''=⍙p[⍙i+1]:∇ ⍙s(⍙i+2) ⋄ ''''=⍙s[⍙i]:⍙i ⋄ ∇ ⍙s(⍙i+1)}
    ⍙tokNum←{⍙n←+/∧\⍵∊⍙numChars ⋄ ⍙t←⍙n↑⍵ ⋄ ~∨/⍙t∊⍙digits:(0 ⍬) ⋄ ⍙ok ⍙tk←⍙tokR ⍙n↓⍵ ⋄ ~⍙ok:(0 ⍬) ⋄ 1,⊂(⊂'V',⍙t),⍙tk}
    ⍙tokStr←{⍙e←⍙strEnd ⍵ 1 ⋄ ⍙e<0:(0 ⍬) ⋄ ⍙t←(⍙e+1)↑⍵ ⋄ ⍙ok ⍙tk←⍙tokR(⍙e+1)↓⍵ ⋄ ~⍙ok:(0 ⍬) ⋄ 1,⊂(⊂'V',⍙t),⍙tk}
    ⍙tokName←{⍙n←+/∧\⍵∊⍙nameChars ⋄ ⍙t←⍙n↑⍵ ⋄ '⍙'=⊃⍙t:(0 ⍬) ⋄ ⍙r←⍙n↓⍵ ⋄ ⍙p←⍙r,'  ' ⋄ ('.'=⍙p[0])∧(⍙p[1])∊⍙nameStart:(0 ⍬) ⋄ ⍙ok ⍙tk←⍙tokR ⍙r ⋄ ~⍙ok:(0 ⍬) ⋄ 1,⊂(⊂'N',⍙t),⍙tk}
    ⍙tok1←{⍙ok ⍙tk←⍙tokR 1↓⍵ ⋄ ~⍙ok:(0 ⍬) ⋄ 1,⊂(⊂⍺,⊃⍵),⍙tk}
    ⍙tokOD←{⍙ok ⍙tk←⍙tokR 2↓⍵ ⋄ ~⍙ok:(0 ⍬) ⋄ 1,⊂(⊂'O∘.'),⍙tk}
    ⍙tokR←{0=≢⍵:(1 ⍬) ⋄ ' '=⊃⍵:∇ 1↓⍵ ⋄ ⍙c←⊃⍵ ⋄ ⍙d←(⍵,' ')[1] ⋄ ''''=⍙c:⍙tokStr ⍵ ⋄ ⍙c∊⍙digits:⍙tokNum ⍵ ⋄ (⍙c='¯')∧⍙d∊⍙digits,'.':⍙tokNum ⍵ ⋄ (⍙c='.')∧⍙d∊⍙digits:⍙tokNum ⍵ ⋄ ⍙c∊⍙nameStart:⍙tokName ⍵ ⋄ ⍙c∊'()':⍙c ⍙tok1 ⍵ ⋄ (⍙c='∘')∧⍙d='.':⍙tokOD ⍵ ⋄ ⍙c∊⍙fnChars:'F'⍙tok1 ⍵ ⋄ ⍙c∊⍙opChars:'O'⍙tok1 ⍵ ⋄ ⍙c='⍬':'V'⍙tok1 ⍵ ⋄ (⍙c='⍺')∧⍙d≠'⍺':'V'⍙tok1 ⍵ ⋄ (⍙c='⍵')∧⍙d≠'⍵':'V'⍙tok1 ⍵ ⋄ (0 ⍬)}
    ⍙tok←{⍙ok ⍙tk←⍙tokR ⍵ ⋄ ~⍙ok:(0 ⍬) ⋄ 1,⊂⊃¨⍙tk}
    ⍙depths←{0=≢⍵:⍬ ⋄ ⍙dl←((⊃¨⍵)='(')-((⊃¨⍵)=')') ⋄ 0,¯1↓+\⍙dl}
    ⍙hasVar←{∨/⍵∊'V⍺' 'V⍵'}
    ⍙texts←{1↓¨⍵}
    ⍙match←{⍙tk ⍙dp ⍙i←⍵ ⋄ ⍙js←(⍙i+1)↓⍳≢⍙tk ⋄ ⍙cd←⍙js/⍨((⊃¨⍙tk[⍙js])=')')∧⍙dp[⍙js]=1+⍙dp[⍙i] ⋄ 0=≢⍙cd:¯1 ⋄ ⊃⍙cd}
    ⍙matchOpen←{⍙tk ⍙dp ⍙k←⍵ ⋄ ⍙js←⍙k↑⍳≢⍙tk ⋄ ⍙cd←⍙js/⍨((⊃¨⍙tk[⍙js])='(')∧⍙dp[⍙js]=¯1+⍙dp[⍙k] ⋄ 0=≢⍙cd:¯1 ⋄ ⊃⌽⍙cd}
    ⍙parenIsFn←{⍙tk ⍙dp ⍙i ⍙j←⍵ ⋄ ⍙in←(⍙i+1)+⍳⍙j-⍙i-1 ⋄ ⍙tp←⍙in/⍨⍙dp[⍙in]=1+⍙dp[⍙i] ⋄ 0=≢⍙tp:¯1 ⋄ ⍙k←⊃⌽⍙tp ⋄ ⍙kd←⊃⍙tk[⍙k] ⋄ ⍙kd∊'VN':0 ⋄ ⍙kd∊'FO':1 ⋄ ⍙kd=')':∇ ⍙tk ⍙dp(⍙matchOpen ⍙tk ⍙dp ⍙k)⍙k ⋄ ¯1}
    ⍙stripParens←{⍙e←⍙trim ⍵ ⋄ 0=≢⍙e:⍙e ⋄ ⍙ok ⍙tk←⍙tok ⍙e ⋄ ~⍙ok:⍙e ⋄ 2>≢⍙tk:⍙e ⋄ (⊃⍙tk)≢'((':⍙e ⋄ (⊃⌽⍙tk)≢'))':⍙e ⋄ ⍙dp←⍙depths ⍙tk ⋄ ⍙m←⍙match ⍙tk ⍙dp 0 ⋄ ⍙m≠¯1+≢⍙tk:⍙e ⋄ ∇ ⍙joinSp ⍙texts 1↓¯1↓⍙tk}
    ⍙parseOps←{⍙tk ⍙dp ⍙i ⍙f←⍵ ⋄ ⍙i≥≢⍙tk:(⍙i ⍙f) ⋄ ⍙dp[⍙i]≠0:(⍙i ⍙f) ⋄ ⍙kd←⊃⍙tk[⍙i] ⋄ ⍙tx←1↓⍙tk[⍙i] ⋄ ⍙kd≠'O':(⍙i ⍙f) ⋄ (1=≢⍙tx)∧(⊃⍙tx)∊⍙monOps:∇ ⍙tk ⍙dp(⍙i+1)(⍙f,⍙tx) ⋄ (⍙tx≡'⍣')∨⍙tx≡'⍠':(¯1 '') ⋄ ~((⍙tx≡'∘.')∨(1=≢⍙tx)∧(⊃⍙tx)∊'∘.⍤⍥⍛⍜'):(⍙i ⍙f) ⋄ ⍙dyad ⍙tk ⍙dp ⍙i ⍙f ⍙tx}
    ⍙dyad←{⍙tk ⍙dp ⍙i ⍙f ⍙op←⍵ ⋄ ⍙j←⍙i+1 ⋄ ⍙j≥≢⍙tk:(¯1 '') ⋄ ⍙dp[⍙j]≠0:(¯1 '') ⋄ ⍙rk←⊃⍙tk[⍙j] ⋄ ⍙rk='F':⍙dyadFn ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j ⋄ ⍙rk='N':⍙dyadName ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j ⋄ ⍙rk='V':⍙dyadVal ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j ⋄ ⍙rk='(':⍙dyadPar ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j ⋄ (¯1 '')}
    ⍙dyadFn←{⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j←⍵ ⋄ ⍙ok ⍙e ⍙s←⍙parseFn ⍙tk ⍙dp ⍙j ⋄ ~⍙ok:(¯1 '') ⋄ ⍙parseOps ⍙tk ⍙dp ⍙e(⍙f,⍙op,⍙s)}
    ⍙dyadName←{⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j←⍵ ⋄ ⍙k←⍙nameKind 1↓⍙tk[⍙j] ⋄ ⍙k=1:⍙dyadFn ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j ⋄ ⍙k≠0:(¯1 '') ⋄ ~((⍙op≡'∘')∨⍙op≡'⍤'):(¯1 '') ⋄ ⍙parseOps ⍙tk ⍙dp(⍙j+1)(⍙f,⍙op,1↓⍙tk[⍙j])}
    ⍙dyadVal←{⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j←⍵ ⋄ ⍙t←1↓⍙tk[⍙j] ⋄ (⍙t≡'⍺')∨⍙t≡'⍵':(¯1 '') ⋄ ~((⍙op≡'∘')∨⍙op≡'⍤'):(¯1 '') ⋄ ⍙parseOps ⍙tk ⍙dp(⍙j+1)(⍙f,⍙op,⍙t)}
    ⍙dyadPar←{⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j←⍵ ⋄ ⍙m←⍙match ⍙tk ⍙dp ⍙j ⋄ ⍙m<0:(¯1 '') ⋄ ⍙pf←⍙parenIsFn ⍙tk ⍙dp ⍙j ⍙m ⋄ ⍙pf=1:⍙dyadFn ⍙tk ⍙dp ⍙i ⍙f ⍙op ⍙j ⋄ ⍙pf≠0:(¯1 '') ⋄ ~((⍙op≡'∘')∨⍙op≡'⍤'):(¯1 '') ⋄ ⍙hasVar ⍙tk[⍙j+⍳⍙m-⍙j+1]:(¯1 '') ⋄ ⍙pt←⍙joinSp ⍙texts ⍙tk[⍙j+⍳⍙m-⍙j+1] ⋄ ⍙parseOps ⍙tk ⍙dp(⍙m+1)(⍙f,⍙op,⍙pt)}
    ⍙bindLeft←{⍙tk ⍙dp ⍙i ⍙lt←⍵ ⋄ ⍙i≥≢⍙tk:(0 ⍙i'') ⋄ ⍙dp[⍙i]≠0:(0 ⍙i'') ⋄ (⍙tk[⍙i])≢'O∘':(0 ⍙i'') ⋄ ⍙ok ⍙e ⍙s←⍙parseFn ⍙tk ⍙dp(⍙i+1) ⋄ ~⍙ok:(0 ⍙i'') ⋄ ⍙e2 ⍙f2←⍙parseOps ⍙tk ⍙dp ⍙e(⍙lt,'∘',⍙s) ⋄ ⍙e2<0:(0 ⍙i'') ⋄ (1 ⍙e2 ⍙f2)}
    ⍙primFn←{⍙tk ⍙dp ⍙i ⍙tx←⍵ ⋄ ⍙e ⍙s←⍙parseOps ⍙tk ⍙dp(⍙i+1)⍙tx ⋄ ⍙e<0:(0 ⍙i'') ⋄ (1 ⍙e ⍙s)}
    ⍙primVal←{⍙tk ⍙dp ⍙i ⍙tx←⍵ ⋄ (⍙tx≡'⍺')∨⍙tx≡'⍵':(0 ⍙i'') ⋄ ⍙bindLeft ⍙tk ⍙dp(⍙i+1)⍙tx}
    ⍙primName←{⍙tk ⍙dp ⍙i ⍙tx←⍵ ⋄ ⍙k←⍙nameKind ⍙tx ⋄ ⍙k=1:⍙primFn ⍙tk ⍙dp ⍙i ⍙tx ⋄ ⍙k≠0:(0 ⍙i'') ⋄ ⍙bindLeft ⍙tk ⍙dp(⍙i+1)⍙tx}
    ⍙primParFn←{⍙tk ⍙dp ⍙i ⍙m←⍵ ⋄ ⍙pt←⍙joinSp ⍙texts ⍙tk[⍙i+⍳⍙m-⍙i+1] ⋄ ⍙e ⍙s←⍙parseOps ⍙tk ⍙dp(⍙m+1)⍙pt ⋄ ⍙e<0:(0 ⍙i'') ⋄ (1 ⍙e ⍙s)}
    ⍙primPar←{⍙tk ⍙dp ⍙i←⍵ ⋄ ⍙m←⍙match ⍙tk ⍙dp ⍙i ⋄ ⍙m<0:(0 ⍙i'') ⋄ ⍙pf←⍙parenIsFn ⍙tk ⍙dp ⍙i ⍙m ⋄ ⍙pf=1:⍙primParFn ⍙tk ⍙dp ⍙i ⍙m ⋄ ⍙pf≠0:(0 ⍙i'') ⋄ ⍙hasVar ⍙tk[⍙i+⍳⍙m-⍙i+1]:(0 ⍙i'') ⋄ ⍙bindLeft ⍙tk ⍙dp(⍙m+1)(⍙joinSp ⍙texts ⍙tk[⍙i+⍳⍙m-⍙i+1])}
    ⍙parseFn←{⍙tk ⍙dp ⍙i←⍵ ⋄ ⍙i≥≢⍙tk:(0 ⍙i'') ⋄ ⍙dp[⍙i]≠0:(0 ⍙i'') ⋄ ⍙kd←⊃⍙tk[⍙i] ⋄ ⍙tx←1↓⍙tk[⍙i] ⋄ ⍙kd='F':⍙primFn ⍙tk ⍙dp ⍙i ⍙tx ⋄ ⍙kd='N':⍙primName ⍙tk ⍙dp ⍙i ⍙tx ⋄ ⍙kd='V':⍙primVal ⍙tk ⍙dp ⍙i ⍙tx ⋄ ⍙kd='(':⍙primPar ⍙tk ⍙dp ⍙i ⋄ (0 ⍙i'')}
    ⍙findPrin←{⍙tk ⍙dp ⍙i←⍵ ⋄ ⍙i≥≢⍙tk:(0 ⍙i ⍙i'') ⋄ ⍙dp[⍙i]≠0:∇ ⍙tk ⍙dp(⍙i+1) ⋄ ⍙ok ⍙e ⍙s←⍙parseFn ⍙tk ⍙dp ⍙i ⋄ ⍙ok:(1 ⍙i ⍙e ⍙s) ⋄ ∇ ⍙tk ⍙dp(⍙i+1)}
    ⍙commute←{∨/⍵∊⍙opChars,'() ':'(',⍵,')⍨' ⋄ ⍵,'⍨'}
    ⍙parenConst←{⍙ok ⍙tk←⍙tok ⍵ ⋄ ~⍙ok:'(',⍵,')' ⋄ ⍙dp←⍙depths ⍙tk ⋄ ⍙top←⍙tk/⍨⍙dp=0 ⋄ ∨/(⊃¨⍙top)∊'FO':'(',⍵,')' ⋄ ⍵}
    ⍙isMonOm←{⍙e←⍙stripParens ⍵ ⋄ ⍙ok ⍙tk←⍙tok ⍙e ⋄ ~⍙ok:(0 '') ⋄ ⍙dp←⍙depths ⍙tk ⋄ (0≠+/(((⊃¨⍙tk)='(')-((⊃¨⍙tk)=')')))∨∨/⍙dp<0:(0 '') ⋄ ⍙fd ⍙s ⍙n ⍙f←⍙findPrin ⍙tk ⍙dp 0 ⋄ ~⍙fd:(0 '') ⋄ ⍙s≠0:(0 '') ⋄ (⍙stripParens ⍙joinSp ⍙texts ⍙n↓⍙tk)≢'⍵':(0 '') ⋄ (1 ⍙f)}
    ⍙strandPar←{⍙tk ⍙dp ⍙i ⍙ac←⍵ ⋄ ⍙m←⍙match ⍙tk ⍙dp ⍙i ⋄ ⍙m<0:⍬ ⋄ ⍙strand ⍙tk ⍙dp(⍙m+1)(⍙ac,(⊂⍙joinSp ⍙texts ⍙tk[⍙i+⍳⍙m-⍙i+1]))}
    ⍙strand←{⍙tk ⍙dp ⍙i ⍙ac←⍵ ⋄ ⍙i≥≢⍙tk:⍙ac ⋄ ⍙dp[⍙i]≠0:⍬ ⋄ ⍙kd←⊃⍙tk[⍙i] ⋄ ⍙kd∊'VN':∇ ⍙tk ⍙dp(⍙i+1)(⍙ac,(⊂1↓⍙tk[⍙i])) ⋄ ⍙kd='(':⍙strandPar ⍙tk ⍙dp ⍙i ⍙ac ⋄ ⍬}
    ⍙tacNoPrin←{⍙e ⍙tk ⍙dp←⍵ ⋄ ⍙it←⍙strand ⍙tk ⍙dp 0 ⍬ ⋄ (0=≢⍙it)∨2>≢⍙it:⍬ ⋄ ⍙pt←{'(⊂',⍵,')'}¨⍙it ⋄ ⍙tac'(',(1↓∊',',¨⍙pt),')'}
    ⍙tacAfY←{⍙l ⍙f ⍙r←⍵ ⋄ ⍙t←⍙tac ⍙r ⋄ ⍙t≡⍬:⍬ ⋄ '(',(⍙parenConst ⍙l),⍙f,⍙t,')'}
    ⍙tacXfA←{⍙l ⍙f ⍙r←⍵ ⋄ ⍙t←⍙tac ⍙l ⋄ ⍙t≡⍬:⍬ ⋄ '(',(⍙parenConst ⍙r),(⍙commute ⍙f),⍙t,')'}
    ⍙tacBoth←{⍙l ⍙f ⍙r←⍵ ⋄ ((⍙stripParens ⍙l)≡'⍺')∧(⍙stripParens ⍙r)≡'⍵':⍙f ⋄ ⍙lm ⍙g←⍙isMonOm ⍙l ⋄ ⍙rm ⍙h←⍙isMonOm ⍙r ⋄ ⍙lm∧⍙rm:'((',⍙g,⍙f,⍙h,')⊢)' ⋄ ⍙lm∧(⍙stripParens ⍙r)≡'⍵':'((',⍙g,⍙f,'⊢',')⊢)' ⋄ ⍙rm∧(⍙stripParens ⍙l)≡'⍵':'((','⊢',⍙f,⍙h,')⊢)' ⋄ ⍙lt←⍙tac ⍙l ⋄ ⍙lt≡⍬:⍬ ⋄ ⍙rt←⍙tac ⍙r ⋄ ⍙rt≡⍬:⍬ ⋄ '(',⍙lt,⍙f,⍙rt,')'}
    ⍙tacDyad←{⍙l ⍙f ⍙r ⍙hl ⍙hr←⍵ ⋄ ⍙hl∧⍙hr:⍙tacBoth ⍙l ⍙f ⍙r ⋄ (~⍙hl)∧⍙hr:⍙tacAfY ⍙l ⍙f ⍙r ⋄ ⍙hl∧~⍙hr:⍙tacXfA ⍙l ⍙f ⍙r ⋄ ⍬}
    ⍙isArr←{⍙tk ⍙dp←⍵ ⋄ ⍙top←(⍳≢⍙tk)/⍨⍙dp=0 ⋄ 0=≢⍙top:0 ⋄ ⍙k←⊃⌽⍙top ⋄ ⍙kd←⊃⍙tk[⍙k] ⋄ ⍙kd∊'VN':1 ⋄ ⍙kd∊'FO':0 ⋄ ⍙kd≠')':0 ⋄ ⍙o←⍙matchOpen ⍙tk ⍙dp ⍙k ⋄ ⍙o<0:0 ⋄ 0=⍙parenIsFn ⍙tk ⍙dp ⍙o ⍙k}
    ⍙tacConst←{⍙e ⍙tk ⍙dp←⍵ ⋄ ~⍙isArr ⍙tk ⍙dp:⍬ ⋄ '((',⍙e,')⊣⊣)'}
    ⍙tacMon←{⍙f ⍙r←⍵ ⋄ ⍙t←⍙tac ⍙r ⋄ ⍙t≡⍬:⍬ ⋄ '(',⍙f,⍙t,')'}
    ⍙tac←{⍙e←⍙stripParens ⍙trim ⍵ ⋄ 0=≢⍙e:⍬ ⋄ ⍙e≡'⍺':'⊣' ⋄ ⍙e≡'⍵':'⊢' ⋄ ⍙ok ⍙tk←⍙tok ⍙e ⋄ ~⍙ok:⍬ ⋄ ⍙dp←⍙depths ⍙tk ⋄ (0≠+/(((⊃¨⍙tk)='(')-((⊃¨⍙tk)=')')))∨∨/⍙dp<0:⍬ ⋄ ~∨/(⊃¨⍙tk)∊'VN()':⍬ ⋄ ~⍙hasVar ⍙tk:⍙tacConst ⍙e ⍙tk ⍙dp ⋄ ⍙fd ⍙s ⍙n ⍙f←⍙findPrin ⍙tk ⍙dp 0 ⋄ ~⍙fd:⍙tacNoPrin ⍙e ⍙tk ⍙dp ⋄ ⍙fok ⍙ftk←⍙tok ⍙f ⋄ ~⍙fok:⍬ ⋄ ⍙hasVar ⍙ftk:⍬ ⋄ ⍙s=0:⍙tacMon ⍙f(⍙joinSp ⍙texts ⍙n↓⍙tk) ⋄ ⍙l←⍙joinSp ⍙texts ⍙s↑⍙tk ⋄ ⍙r←⍙joinSp ⍙texts ⍙n↓⍙tk ⋄ ⍙tacDyad ⍙l ⍙f ⍙r(⍙hasVar ⍙s↑⍙tk)(⍙hasVar ⍙n↓⍙tk)}
    ⍙isStr←((≢⍴⍙orig)≤1)∧(' '=⊃0⍴⍙orig)
    ~⍙isStr:⍙orig
    ⍙s←⍙trim ⍙orig
    2>≢⍙s:⍙orig
    ('{'≠⊃⍙s)∨'}'≠⊃⌽⍙s:⍙orig
    ⍙body←⍙trim 1↓¯1↓⍙s
    0=≢⍙body:⍙orig
    ⍙ok ⍙tk←⍙tok ⍙body
    ~⍙ok:⍙orig
    ⍙dp←⍙depths ⍙tk
    (0≠+/(((⊃¨⍙tk)='(')-((⊃¨⍙tk)=')')))∨∨/⍙dp<0:⍙orig
    ⍙res←⍙tac ⍙body
    ⍙res≡⍬:⍙orig
    ⍙res
}⍵

}
