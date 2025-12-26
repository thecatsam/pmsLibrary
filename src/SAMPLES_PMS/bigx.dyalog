 bigx←{⎕IO ⎕ML←0 1                           ⍝ Big number arithmetic.
   ⍝ Based on dfns::nats, so much faster than dfns::big,
   ⍝ extended to allow signed integers.
     arith←{                                 ⍝ ⍺ ⍺⍺ ⍵, where ⍺⍺ ∊ +-×÷...
         fn←⍺⍺{aa←⍺⍺ ⋄ ⊃⎕CR'aa'}⍵            ⍝ char rep of operand function.
         '+'≡fn:ndn 0,+⌿⍺ mix ⍵              ⍝ sum.
         '-'≡fn:nup-⌿dck ⍺ mix ⍵             ⍝ difference.
         '×'≡fn:⍺ mul ⍵                      ⍝ product.
         '*'≡fn:⍺ exp ⍵                      ⍝ exponent.
         '÷'≡fn:⊃⍺ div ⍵                     ⍝ quotient.
         '<≤=≥>≠'∊⍨fn:⍺⍺ cmp ⍺ mix ⍵         ⍝ relational.
         '⌊'≡fn:(>cmp ⍺ mix ⍵)⊃⍺ ⍵           ⍝ min.
         '⌈'≡fn:(<cmp ⍺ mix ⍵)⊃⍺ ⍵           ⍝ max.
         '|'≡fn:⍺ res ⍵                      ⍝ residue.
         '∨'≡fn:⍺ gcd ⍵                      ⍝ greatest common divisor.
         '∧'≡fn:⍺ lcm ⍵                      ⍝ least common multiple.
         err'Can''t do: ',fn                 ⍝ :-(
     }

     mul←{                                   ⍝ product.
         dlz ndn 0,↑⍵{                       ⍝ normalised vector.
             digit take←⍺                    ⍝ next digit and shift.
             +⌿⍵ mix digit×take↑⍺⍺           ⍝ accumulated product.
         }/(⍺,¨(⍴⍵)+⌽⍳⍴⍺),⊂,0                ⍝ digit-shift pairs.
     }{                                      ⍝ guard against overflow:
         m n←,↑⍴¨⍺ ⍵                         ⍝ numbers of rx-digits in each arg.
         m>n:⍺ ∇⍨⍵                           ⍝ quicker if larger number on right.
         n<(2*53)÷rx*2:⍺ ⍺⍺ ⍵                ⍝ ⍵ won't overflow: proceed.
         s←⌊n÷2                              ⍝ digit-split for large ⍵.
         p q←⍺∘∇¨(s↑⍵)(s↓⍵)                  ⍝ sub-products (see notes).
         dlz ndn 0,+⌿(p,s↓n⍴0)mix q          ⍝ sum of sub-products.
     }

     exp←{                                   ⍝ exponent.
         =cmp ⍵ mix,0:1                      ⍝ ⍺*0 → 1
         =cmp ⍵ mix,1:⍺                      ⍝ ⍺*1 → ⍺
         hlf←{dlz ndn(⌊⍵÷2)+0,¯1↓(rx÷2)×2|⍵} ⍝ quick ⌊⍵÷2.
         evn←dlz ndn{⍵ mul ⍵}ndn ⍺ ∇ hlf ⍵   ⍝ even power
         0=2|¯1↑⍵:evn ⋄ ⍺ mul evn            ⍝ even or odd power.
     }

     div←{                                   ⍝ quotient.
         ⍵∧.=0:⍺{⍺∧.=0:1 ⋄ err'Div by 0'}⍵   ⍝ ⍺÷0
         svec←(⍴⍵)+⍳0⌈1+(⍴⍺)-⍴⍵              ⍝ shift vector.
         ↑⍵{                                 ⍝ fold along dividend.
             r p←⍵                           ⍝ result & dividend.
             q←⍺↑⍺⍺                          ⍝ shifted divisor.
             ppqq←rx⊥⍉2 2↑p mix q            ⍝ 2 most sig digits of p & q.
             r∆←p q{                         ⍝ next rx-digit of result.
                 (p q)(lo hi)←⍺ ⍵            ⍝ div and high-low test.
                 lo=hi-1:p{                  ⍝ convergence:
                     (≥cmp ⍺ mix ⍵)⊃lo hi    ⍝ low or high.
                 }dlz ndn 0,hi×q             ⍝ multiple.
                 mid←⌊0.5×lo+hi              ⍝ mid-point.
                 nxt←dlz ndn 0,q×mid         ⍝ next multiplier.
                 gt←>cmp p mix nxt           ⍝ greater than:
                 ⍺ ∇ gt⊃2,/lo mid hi         ⍝ choose upper or lower interval.
             }⌊0 1+↑÷/ppqq+(0 1)(1 0)        ⍝ lower and upper bounds of ratio.
             mpl←dlz ndn 0,q×r∆              ⍝ multiple.
             p∆←dlz nup-⌿p mix mpl           ⍝ remainder.
             (r,r∆)p∆                        ⍝ result & remainder.
         }/svec,⊂⍬ ⍺                         ⍝ fold-accumulated reslt.
     }

     gcd←{0∧.=⍵:⍺ ⋄ ⍵ ∇⊃⌽⍺ div ⍵}            ⍝ greatest common divisor.
     lcm←{⍺ mul⊃⍵ div ⍺ gcd ⍵}               ⍝ least common multiple.
     res←{⍺∧.=0:⍵ ⋄ ⊃⌽⍵ div ⍺}               ⍝ residue (0|⍵ → ⍵).

     rx←10*px←6                              ⍝ radix for arithmetic.

     dlz←{(0=⊃⍵)↓⍵}                          ⍝ drop leading zero.
     dlzs←{(∨\⍵≠0)/⍵}                        ⍝ drop leading zeros.
     zro←{(1⌈⍴⍵)↑⍵}                          ⍝ 0 for ⍬.
     ndn←{+⌿1 0⌽0 rx⊤⍵}⍣≡                    ⍝ normalise down: 3 21 → 5 1 (RH)
     nup←{⍵++⌿0 1⌽rx ¯1∘.×⍵<0}⍣≡             ⍝ normalise up:   3 ¯1 → 2 9
     mix←{↑(-(⍴⍺)⌈⍴⍵)↑¨⍺ ⍵}                  ⍝ right-aligned mix.
     num←{dlzs rep ⎕D⍳chk⍕⍵}                 ⍝ vector of rx-digits.

     chk←{∧/⍵∊⎕D:⍵ ⋄ err'Bad number: ',⍵}    ⍝ check raw no. not too big.
     dck←{(2 1+(≥cmp ⍵)⌽0 ¯1)⌿⍵}             ⍝ difference check.
     rep←{10⊥⍵{⍉⍵⍴(-×/⍵)↑⍺}(⌈(⍴⍵)÷px),px}    ⍝ radix rx rep of number.
     fmt←{⎕D[zro dlzs,⍉(px⍴10)⊤⍵]}           ⍝ vector of chars.
     cmp←{⍺⍺/,(<\≠⌿⍵)/⍵}                     ⍝ compare first different digit.
     err←⎕SIGNAL∘11                          ⍝ stop with error msg ⍵.

     ZERO←,'0'                               ⍝ canonical zero
     fmtS←{n←fmt ⍵ ⋄ n≡ZERO:n ⋄ ⍺:'¯',n ⋄ n}
     dyadic←{
         s←'¯'=⊃¨a w←⍕¨⍺ ⍵
         a w←num¨s↓¨a w
       ⍝ <:  < cmp ⍺ mix ⍵
         sO fmtS a ⍺⍺ arith w
     }

     monadic←{
         fn←⍺⍺{aa←⍺⍺ ⋄ ⊃⎕CR'aa'}⍵
         s←'¯'=⊃w←⍕⍵ ⋄ w←num s↓w
         '+'≡fn:s fmtS w
         '-'≡fn:(~s)fmtS w
         '×'≡fn:
         '|'≡fn:
         '÷'≡fn:
         err'Only monadic minus (-) is supported'
     }

     ⍺←⊢
     1≡⍺ 1:⍺⍺ monadic ⍵
     ⍺ ⍺⍺ dyadic ⍵
 }
