:Namespace gmpzTest

⎕PATH← '##'
⍝ Load gmpz at top level, if not there.
∇ ok←LoadGmpz
   ok← 0 
  :If 0= #.⎕NC 'gmpz'
      {}#.⎕FIX 'gmpz/gmpz.dyalog'
      ok← 1 
  :EndIf
   gmpz←#.gmpz
∇
LoadGmpz

CR← ⎕UCS 13
CRt← CR, (4⍴' ')
⎕← 'To run both',CRt,'∘ test methods, and ',CRt,'∘ performance tests,',CR,'execute:',CRt,(⍕⎕THIS),'.Run'
⎕DF '[*GmpzTest*]'

∇ Run   
  LoadGmpz BANNER 'Loaded gmpz/gmpz'

  BANNER 'Running TestMethods 1'
  TestMethods 1

  BANNER 'Running TestMethods 100 -- to exercise any memory leaks'
  TestMethods 100

   BANNER 'Running PerformanceTests'
   PerformanceTests

   BANNER 'Done'
∇ 

∇ {dontSkip} BANNER headline; pw 
:IF 900⌶⍬ ⋄ dontSkip← 1 ⋄ :EndIf 
:IF ~dontSkip ⋄ :RETURN ⋄ :EndIf 
pw← 80-4
⎕← ('+ '),(pw⍴'-'),' +'
lh← 0⌈ 0.5× pw- ≢headline
⎕← '+ ',(''⍴⍨⌊lh),headline,(''⍴⍨ ⌈lh),' +'
⎕← ('+ '),(pw⍴'-'),' +'
⎕←''
∇ 

∇ PerformanceTests 
  BANNER 'Testing for correctness and race conditions'
  ⎕← RaceConditions (100 200)

  BANNER 'Testing for Efficiency and Lock Contention'
  ⎕← Contention
∇


∇ r← TestMethods count
⍝  To use:
⍝      TestMethods 1  -- Verifies that all operations work properly...
⍝      TestMethods 25 -- Exercises all operations by running through them 25 times.
⍝      TestMethods nn -- Choose a number nn (10, 25, ...) to exercise operations even more.
⍝
  ; ⎕IO; ⎕ML; ⎕PP; ⎕FR
  ; curCount; Say
  ; rep; pass; fail; total; line; bases; vals; base; val; big
  ; c; a; b; x; y; z; t; rem; rc; err; old; v; v1; v2; ok; i; pp
  ; Chk; IsPass
⎕IO ⎕ML ⎕PP ⎕FR← 0 1 34 1287

:If count≤1
   Say← {1: ⎕← ⍵}
:Else
   Say← {}
:EndIf

total← pass← 0

:If 0=⎕NC'gmpz'
   ⎕← 'Load gmpz library before testing...'
   :Return
:EndIf

rep← ⍬
⍝ Chk: monadic dfn, argument is (name expected actual), each enclosed.
⍝ Returns '  PASS: name' or '**FAIL: name — expected: ... — got: ...'
Chk← {
   nm exp act← ⍵
  exp≡act: '  PASS: ',nm
   '**FAIL: ',nm,' — expected: ',(⍕exp),' — got: ',(⍕act)
}
IsPass← {'PASS'≡4↑2↓⍵}
⍝ Big constants are written as strings, so the result does not depend on the ⎕FR in force when this
⍝ function was fixed (long numeric literals are tokenised at fix time).
big← '123456789012345678901234567890'

⍝ If count=1 or 0, this goes through once quietly.
⍝ If >1, it goes through as many times as specified and if no errors occur, great!

:For curCount :In ⍳1⌈count
   
⍝ ── 1. Construction ──────────────────────────────────────────────
   :Trap 0
      rep← ⍬
      c← ⎕NEW gmpz
      rep,← ⊂Chk(⊂'New empty = 0')(⊂'0')(⊂(⌷c))
      c← ⎕NEW gmpz ¯2
      rep,← ⊂Chk(⊂'New from APL int ¯2')(⊂'¯2')(⊂(⌷c))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'New from APL int 0')(⊂'0')(⊂(⌷c))
      c← ⎕NEW gmpz 1
      rep,← ⊂Chk(⊂'New from APL int 1 (scalar boolean is an integer)')(⊂'1')(⊂(⌷c))
      c← ⎕NEW gmpz'1234567 89012345678'
      rep,← ⊂Chk(⊂'New from string, blanks ok')(⊂'123456789012345678')(⊂(⌷c))
      c← ⎕NEW gmpz'¯42'
      rep,← ⊂Chk(⊂'New from string, ¯ as minus')(⊂'¯42')(⊂(⌷c))
      c← ⎕NEW gmpz('beef cafe' 16)
      rep,← ⊂Chk(⊂'New from string in base 16, blanks ok')(⊂'3203386110')(⊂(⌷c))
      c← ⎕NEW gmpz('ff' 16)
      rep,← ⊂Chk(⊂'New (ff 16) = 255')(⊂'255')(⊂(⌷c))
      c← ⎕NEW gmpz big
      rep,← ⊂Chk(⊂'New from 30-digit string')(⊂big)(⊂(⌷c))
      c← ⎕NEW gmpz(2*70)
      rep,← ⊂Chk(⊂'New from decimal float 2*70 (beyond 64 bits)')(⊂'1180591620717411303424')(⊂(⌷c))
      c← ⎕NEW gmpz(-2*70)
      rep,← ⊂Chk(⊂'New from decimal float ¯2*70')(⊂'¯1180591620717411303424')(⊂(⌷c))
      c← ⎕NEW gmpz'18446744073709551615'
      rep,← ⊂Chk(⊂'New from string 2*64-1')(⊂'18446744073709551615')(⊂(⌷c))
   :Else
      rep,← ⊂'**FAIL: Construction section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 2. New0 / New / Set / Copy ───────────────────────────────────
   :Trap 0
      c← gmpz.New0
      rep,← ⊂Chk(⊂'gmpz.New0 = 0')(⊂'0')(⊂(⌷c))
      c← gmpz.New'999999999'
      rep,← ⊂Chk(⊂'gmpz.New string')(⊂'999999999')(⊂(⌷c))
      c← 16 gmpz.New'ff'
      rep,← ⊂Chk(⊂'16 gmpz.New ff = 255')(⊂'255')(⊂(⌷c))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Set APL int, chained Inc')(⊂'6')(⊂(⌷((c.Set 5).Inc)))
      c← ⎕NEW gmpz 7
      c.Set 0
      rep,← ⊂Chk(⊂'Set 0')(⊂'0')(⊂(⌷c))
      c.Set 1
      rep,← ⊂Chk(⊂'Set 1')(⊂'1')(⊂(⌷c))
      c← ⎕NEW gmpz 0
      16 c.Set'beef cafe'
      rep,← ⊂Chk(⊂'16 Set beef cafe')(⊂'3203386110')(⊂(⌷c))
      a← ⎕NEW gmpz 77
      c← ⎕NEW gmpz 0
      c.Set a
      rep,← ⊂Chk(⊂'Set from another gmpz')(⊂'77')(⊂(⌷c))
      rep,← ⊂Chk(⊂'Set source unchanged')(⊂'77')(⊂(⌷a))
      x← ⎕NEW gmpz 5
      rep,← ⊂Chk(⊂'Set to self returns self, value kept')(⊂'5')(⊂(⌷(x.Set x)))
      a← ⎕NEW gmpz 5
      b← a.Copy
      b.Inc
      rep,← ⊂Chk(⊂'Copy is independent: copy changed')(⊂'6')(⊂(⌷b))
      rep,← ⊂Chk(⊂'Copy is independent: original unchanged')(⊂'5')(⊂(⌷a))
      b← a
      b.Inc
      rep,← ⊂Chk(⊂'Assignment aliases: original changed through b')(⊂'6')(⊂(⌷a))
   :Else
      rep,← ⊂'**FAIL: New0 / New / Set / Copy section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 3. ⌷ / ptr / Int64 / IntDF / VFI ─────────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 123
      rep,← ⊂Chk(⊂'⌷ 123')(⊂'123')(⊂(⌷c))
      rep,← ⊂Chk(⊂'ptr is a live address (>0)')(⊂1)(⊂(0<c.ptr))
      rep,← ⊂Chk(⊂'Int64 123')(⊂123)(⊂(c.Int64))
      c← ⎕NEW gmpz'¯922337203685477600'
      rep,← ⊂Chk(⊂'Int64 most-negative-ish fits')(⊂'¯922337203685477600')(⊂⍕c.Int64)
      c← ⎕NEW gmpz'9223372036854775807'
      rep,← ⊂Chk(⊂'Int64 2*63-1 fits')(⊂'9223372036854775807')(⊂⍕c.Int64)
      c← ⎕NEW gmpz'¯9223372036854775808'
      rep,← ⊂Chk(⊂'Int64 ¯2*63 fits')(⊂'¯9223372036854775808')(⊂⍕c.Int64)
      c← ⎕NEW gmpz 123
      rep,← ⊂Chk(⊂'IntDF 123')(⊂123)(⊂(c.IntDF))
      c← ⎕NEW gmpz big
      rep,← ⊂Chk(⊂'IntDF 30-digit number')(⊂big)(⊂⍕c.IntDF)
      c← ⎕NEW gmpz('¯',big)
      rep,← ⊂Chk(⊂'IntDF negative 30-digit number')(⊂'¯',big)(⊂⍕c.IntDF)
      c← ⎕NEW gmpz'9223372036854775808'
      rep,← ⊂Chk(⊂'IntDF 2*63 (beyond Int64, within 34 digits)')(⊂'9223372036854775808')(⊂⍕c.IntDF)
      c← ⎕NEW gmpz big
      rep,← ⊂Chk(⊂'VFI 30-digit number = 1 (fits a decimal float)')(⊂1)(⊂⊃c.VFI)
      c← ⎕NEW gmpz(40⍴'9')
      rep,← ⊂Chk(⊂'VFI 40-digit number = 0 0')(⊂0 0)(⊂(c.VFI))
      c← ⎕NEW gmpz(34⍴'9')
      rep,← ⊂Chk(⊂'VFI 34 nines fits')(⊂1)(⊂⊃c.VFI)
      c← ⎕NEW gmpz(35⍴'9')
      rep,← ⊂Chk(⊂'VFI 35 nines = 0 0')(⊂0 0)(⊂(c.VFI))
      c← ⎕NEW gmpz 42
      rep,← ⊂Chk(⊂'VFI 42 = 1 42')(⊂1 42)(⊂(c.VFI))
      c← ⎕NEW gmpz ¯42
      rep,← ⊂Chk(⊂'VFI ¯42 = 1 ¯42')(⊂1 ¯42)(⊂(c.VFI))
   :Else
      rep,← ⊂'**FAIL: ⌷ / ptr / Int64 / IntDF / VFI section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 4. GetInBase / Get / StrLen / StrLenInBase / BitLen ──────────
   :Trap 0
      c← ⎕NEW gmpz 255
      rep,← ⊂Chk(⊂'GetInBase 16 of 255')(⊂'ff')(⊂(c.GetInBase 16))
      rep,← ⊂Chk(⊂'GetInBase 2 of 255')(⊂'11111111')(⊂(c.GetInBase 2))
      c← ⎕NEW gmpz ¯5
      rep,← ⊂Chk(⊂'GetInBase 2 of ¯5')(⊂'¯101')(⊂(c.GetInBase 2))
      c← ⎕NEW gmpz 255
      rep,← ⊂Chk(⊂'GetInBase 62 of 255')(⊂'47')(⊂(c.GetInBase 62))
      rep,← ⊂Chk(⊂'gmpz.Get 255 (integer, default base 10)')(⊂'255')(⊂(gmpz.Get 255))
      rep,← ⊂Chk(⊂'16 gmpz.Get 255 (integer, base 16)')(⊂'ff')(⊂(16 gmpz.Get 255))
      rep,← ⊂Chk(⊂'16 gmpz.Get decimal string')(⊂'ff')(⊂(16 gmpz.Get'255'))
      rep,← ⊂Chk(⊂'2 gmpz.Get gmpz')(⊂'11111111')(⊂(2 gmpz.Get c))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'StrLen 0 = 1')(⊂1)(⊂(c.StrLen))
      rep,← ⊂Chk(⊂'BitLen 0 = 1')(⊂1)(⊂(c.BitLen))
      c← ⎕NEW gmpz ¯123
      rep,← ⊂Chk(⊂'StrLen ¯123 = 4 (sign counts)')(⊂4)(⊂(c.StrLen))
      rep,← ⊂Chk(⊂'StrLen = ≢⌷ for ¯123')(⊂(≢⌷c))(⊂(c.StrLen))
      c← ⎕NEW gmpz 8
      rep,← ⊂Chk(⊂'BitLen 8 = 5 (0 1 0 0 0: sign bit included)')(⊂5)(⊂(c.BitLen))
      c← ⎕NEW gmpz ¯8
      rep,← ⊂Chk(⊂'BitLen ¯8 = 4 (1 0 0 0)')(⊂4)(⊂(c.BitLen))
      c← ⎕NEW gmpz 7
      rep,← ⊂Chk(⊂'BitLen 7 = 4 (0 1 1 1)')(⊂4)(⊂(c.BitLen))
      c← ⎕NEW gmpz ¯1
      rep,← ⊂Chk(⊂'BitLen ¯1 = 1')(⊂1)(⊂(c.BitLen))
      c← ⎕NEW gmpz ¯5
      rep,← ⊂Chk(⊂'BitLen ¯5 = 4 (1 0 1 1)')(⊂4)(⊂(c.BitLen))
      c← ⎕NEW gmpz big
      rep,← ⊂Chk(⊂'StrLen 30-digit = 30')(⊂30)(⊂(c.StrLen))
      rep,← ⊂Chk(⊂'StrLen = ≢⌷ for 30-digit')(⊂(≢⌷c))(⊂(c.StrLen))
   ⍝ StrLenInBase must equal ≢GetInBase, in every base and across the C-long boundary
      vals← '0' '1' '¯1' '35' '1000000000000000000' '¯9223372036854775808' '9223372036854775807' '18446744073709551616'
      vals,← ⊂big
      vals,← ⊂'¯',big
      ok← 1
      :For base :In 2 3 7 10 12 16 36 62
         :For val :In vals
            c← ⎕NEW gmpz val
            ok← ok∧(c.StrLenInBase base)≡(≢c.GetInBase base)
         :EndFor
      :EndFor
      rep,← ⊂Chk(⊂'StrLenInBase = ≢GetInBase, bases 2…62, values across the long boundary')(⊂1)(⊂ok)
      c← ⎕NEW gmpz'1000000000000000000'
      rep,← ⊂Chk(⊂'StrLenInBase 12 of 10*18 = 17 (was wrong for bases ≥ 12)')(⊂17)(⊂(c.StrLenInBase 12))
   ⍝ BitLen must equal ≢Bits
      vals← '0' '1' '¯1' '7' '8' '¯8' '255' '256' '¯256' '¯257' '9223372036854775807' '¯9223372036854775808' '18446744073709551616' '¯18446744073709551616'big
      vals,← ⊂'¯',big
      ok← 1
      :For val :In vals
         c← ⎕NEW gmpz val
         ok← ok∧(c.BitLen)≡(≢c.Bits)
      :EndFor
      rep,← ⊂Chk(⊂'BitLen = ≢Bits across signs, 64-bit boundaries and big values')(⊂1)(⊂ok)
   :Else
      rep,← ⊂'**FAIL: GetInBase / Get / StrLen / StrLenInBase / BitLen section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 5. Signum / Even / Odd / Inc / Dec ───────────────────────────
   :Trap 0
      c← ⎕NEW gmpz ¯5
      rep,← ⊂Chk(⊂'Signum ¯5')(⊂¯1)(⊂(c.Signum))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Signum 0')(⊂0)(⊂(c.Signum))
      c← ⎕NEW gmpz 5
      rep,← ⊂Chk(⊂'Signum 5')(⊂1)(⊂(c.Signum))
      c← ⎕NEW gmpz 10
      rep,← ⊂Chk(⊂'Even 10')(⊂1)(⊂(c.Even))
      rep,← ⊂Chk(⊂'Odd 10')(⊂0)(⊂(c.Odd))
      c← ⎕NEW gmpz 11
      rep,← ⊂Chk(⊂'Even 11')(⊂0)(⊂(c.Even))
      rep,← ⊂Chk(⊂'Odd 11')(⊂1)(⊂(c.Odd))
      c← ⎕NEW gmpz 5
      rep,← ⊂Chk(⊂'Inc 5')(⊂'6')(⊂(⌷(c.Inc)))
      rep,← ⊂Chk(⊂'Dec 6')(⊂'5')(⊂(⌷(c.Dec)))
   :Else
      rep,← ⊂'**FAIL: Signum / Even / Odd / Inc / Dec section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 6. Add / Sub / Mul (incl. big numbers, in-place, left operand) ─
   :Trap 0
      c← ⎕NEW gmpz 12
      rep,← ⊂Chk(⊂'Add 12+30')(⊂'42')(⊂(⌷(c.Add 30)))
      c← ⎕NEW gmpz 12
      rep,← ⊂Chk(⊂'Add string operand')(⊂'42')(⊂(⌷(c.Add'30')))
      c← ⎕NEW gmpz 12
      rep,← ⊂Chk(⊂'Add gmpz operand')(⊂'42')(⊂(⌷(c.Add(⎕NEW gmpz 30))))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Left operand: 10 c.Add 32')(⊂'42')(⊂(⌷(10 c.Add 32)))
      c← ⎕NEW gmpz 50
      rep,← ⊂Chk(⊂'Sub 50-8')(⊂'42')(⊂(⌷(c.Sub 8)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Sub negative result')(⊂'¯42')(⊂(⌷(8 c.Sub 50)))
      c← ⎕NEW gmpz 6
      rep,← ⊂Chk(⊂'Mul 6x7')(⊂'42')(⊂(⌷(c.Mul 7)))
      c← ⎕NEW gmpz'12345678901234567890'
      rep,← ⊂Chk(⊂'Big Add')(⊂'111111111011111111100')(⊂(⌷(c.Add'98765432109876543210')))
      c← ⎕NEW gmpz 123456789
      rep,← ⊂Chk(⊂'Big Mul 123456789x987654321')(⊂'121932631112635269')(⊂(⌷(c.Mul 987654321)))
      c← ⎕NEW gmpz 42
      a← ⎕NEW gmpz 10
      c.Add a
      rep,← ⊂Chk(⊂'In-place: receiver changed, operand unchanged')(⊂'10')(⊂(⌷a))
      rep,← ⊂Chk(⊂'In-place: receiver is 52')(⊂'52')(⊂(⌷c))
      c← ⎕NEW gmpz 21
      rep,← ⊂Chk(⊂'Receiver as both operands: c c.Mul c')(⊂'441')(⊂(⌷(c c.Mul c)))
      c← ⎕NEW gmpz 5
      rep,← ⊂Chk(⊂'Add decimal float operand 2*70')(⊂'1180591620717411303429')(⊂(⌷(c.Add(2*70))))
   :Else
      rep,← ⊂'**FAIL: Add / Sub / Mul section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 7. Div / DivRem — floored ────────────────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Div ¯7÷2 floored = ¯4')(⊂'¯4')(⊂(⌷(¯7 c.Div 2)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Div 7÷¯2 floored = ¯4')(⊂'¯4')(⊂(⌷(7 c.Div ¯2)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Div 7÷2 = 3')(⊂'3')(⊂(⌷(7 c.Div 2)))
      c← ⎕NEW gmpz 0
      rem← ¯7 c.DivRem 2
      rep,← ⊂Chk(⊂'DivRem ¯7÷2 quotient = ¯4')(⊂'¯4')(⊂(⌷c))
      rep,← ⊂Chk(⊂'DivRem ¯7÷2 remainder is a gmpz = 1')(⊂'1')(⊂(⌷rem))
      c← ⎕NEW gmpz 0
      rem← 7 c.DivRem 2
      rep,← ⊂Chk(⊂'DivRem 7÷2 quotient = 3')(⊂'3')(⊂(⌷c))
      rep,← ⊂Chk(⊂'DivRem 7÷2 remainder = 1')(⊂'1')(⊂(⌷rem))
   ⍝ Identity check, done properly: q←¯7÷2 floored, r←¯7|2, then 2×q+r = ¯7
      c← ⎕NEW gmpz 0
      rem← ¯7 c.DivRem 2
      x← ⎕NEW gmpz 0
      y← ⎕NEW gmpz 0
      y.Set rem
      x.Set c
      x.Mul 2
      x.Add y
      rep,← ⊂Chk(⊂'Div identity: 2×(¯7÷2) + (¯7|2) = ¯7')(⊂'¯7')(⊂(⌷x))
      c← ⎕NEW gmpz 0
      rem← big c.DivRem'¯7'
      rep,← ⊂Chk(⊂'DivRem with a negative string divisor: remainder is 0 or ≤ 0')(⊂1)(⊂(rem.Le 0))
   :Else
      rep,← ⊂'**FAIL: Div / DivRem section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 8. Gcd / Lcm ─────────────────────────────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Gcd 12 18 = 6')(⊂'6')(⊂(⌷(12 c.Gcd 18)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Gcd ¯12 18 = 6')(⊂'6')(⊂(⌷(¯12 c.Gcd 18)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Gcd 0 5 = 5')(⊂'5')(⊂(⌷(0 c.Gcd 5)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Lcm 12 18 = 36')(⊂'36')(⊂(⌷(12 c.Lcm 18)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Lcm 0 5 = 0')(⊂'0')(⊂(⌷(0 c.Lcm 5)))
   :Else
      rep,← ⊂'**FAIL: Gcd / Lcm section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 9. Pow / PowM / roots ────────────────────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 2
      rep,← ⊂Chk(⊂'Pow 2*10 = 1024')(⊂'1024')(⊂(⌷(c.Pow 10)))
      c← ⎕NEW gmpz 2
      rep,← ⊂Chk(⊂'Pow 2*64')(⊂'18446744073709551616')(⊂(⌷(c.Pow 64)))
      c← ⎕NEW gmpz 2
      rep,← ⊂Chk(⊂'Pow 2*0 = 1')(⊂'1')(⊂(⌷(c.Pow 0)))
      c← ⎕NEW gmpz 27
      rep,← ⊂Chk(⊂'Pow cube root 27 = 3')(⊂'3')(⊂(⌷(c.Pow÷3)))
      c← ⎕NEW gmpz 16
      rep,← ⊂Chk(⊂'Pow square root 16 = 4')(⊂'4')(⊂(⌷(c.Pow÷2)))
      c← ⎕NEW gmpz ¯27
      rep,← ⊂Chk(⊂'Pow cube root ¯27 = ¯3 (odd root, truncating)')(⊂'¯3')(⊂(⌷(c.Pow÷3)))
      c← ⎕NEW gmpz 10
      rep,← ⊂Chk(⊂'Pow cube root 10 truncates to 2')(⊂'2')(⊂(⌷(c.Pow÷3)))
      c← ⎕NEW gmpz 2
      rep,← ⊂Chk(⊂'PowM 2*10 mod 1000 = 24')(⊂'24')(⊂(⌷(c.PowM 10 1000)))
      c← ⎕NEW gmpz 3
      rep,← ⊂Chk(⊂'PowM 3*5 mod 7 = 5')(⊂'5')(⊂(⌷(c.PowM 5 7)))
   :Else
      rep,← ⊂'**FAIL: Pow / PowM section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 10. Res / Invert ────────────────────────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Res 7|¯2 = 5 (sign follows modulus)')(⊂'5')(⊂(⌷(7 c.Res ¯2)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Res 7|2 = 2')(⊂'2')(⊂(⌷(7 c.Res 2)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Res ¯7|2 = ¯5')(⊂'¯5')(⊂(⌷(¯7 c.Res 2)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Res 0|5 = 5 (APL 0|b is b)')(⊂'5')(⊂(⌷(0 c.Res 5)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Res mod 2, odd')(⊂'1')(⊂(⌷(2 c.Res 7)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Res mod 2, even')(⊂'0')(⊂(⌷(2 c.Res 8)))
      c← ⎕NEW gmpz 3
      rc← c.Invert 11
      rep,← ⊂Chk(⊂'Invert 3 mod 11 returns 1')(⊂1)(⊂rc)
      rep,← ⊂Chk(⊂'Invert 3 mod 11 = 4')(⊂'4')(⊂(⌷c))
      c← ⎕NEW gmpz 2
      rc← c.Invert 4
      rep,← ⊂Chk(⊂'Invert 2 mod 4 has no inverse, returns 0')(⊂0)(⊂rc)
   :Else
      rep,← ⊂'**FAIL: Res / Invert section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 11. Shift (incl. ToInt / Str2I: the shift may be a string or gmpz) ─
   :Trap 0
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift left 1<<3 = 6')(⊂'6')(⊂(⌷(1 c.Shift 3)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift left 3<<1 = 8')(⊂'8')(⊂(⌷(3 c.Shift 1)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift right ¯1>>7 = 3')(⊂'3')(⊂(⌷(¯1 c.Shift 7)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift right ¯1>>¯7 = ¯3 (truncates, not floored)')(⊂'¯3')(⊂(⌷(¯1 c.Shift ¯7)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift right ¯3>>¯7 = 0 (truncates)')(⊂'0')(⊂(⌷(¯3 c.Shift ¯7)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift 0 leaves value')(⊂'7')(⊂(⌷(0 c.Shift 7)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift amount as a string')(⊂'12')(⊂(⌷('2'c.Shift 3)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift amount as a negative string')(⊂'3')(⊂(⌷('¯1'c.Shift 7)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift amount as a gmpz')(⊂'12')(⊂(⌷((⎕NEW gmpz 2)c.Shift 3)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Shift left past 64 bits: 70<<1 = 2*70')(⊂'1180591620717411303424')(⊂(⌷(70 c.Shift 1)))
   :Else
      rep,← ⊂'**FAIL: Shift section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 12. TestBit / SetBit / ClrBit / Flip (⎕IO←0) ─────────────────
   :Trap 0
      c← ⎕NEW gmpz 10
      rep,← ⊂Chk(⊂'TestBit 1 of 10 = 1')(⊂1)(⊂(c.TestBit 1))
      rep,← ⊂Chk(⊂'TestBit 0 of 10 = 0')(⊂0)(⊂(c.TestBit 0))
      rep,← ⊂Chk(⊂'TestBit 3 of 10 = 1')(⊂1)(⊂(c.TestBit 3))
      rep,← ⊂Chk(⊂'TestBit with a left operand: 5 c.TestBit 0')(⊂1)(⊂(5 c.TestBit 0))
      c← ⎕NEW gmpz 10
      v← c.SetBit 0
      rep,← ⊂Chk(⊂'SetBit 0 returns 1')(⊂1)(⊂v)
      rep,← ⊂Chk(⊂'SetBit 0: 10 becomes 11')(⊂'11')(⊂(⌷c))
      c← ⎕NEW gmpz 10
      v← c.SetBit 1 0
      rep,← ⊂Chk(⊂'SetBit 1 0 returns 0')(⊂0)(⊂v)
      rep,← ⊂Chk(⊂'SetBit 1 0: 10 becomes 8')(⊂'8')(⊂(⌷c))
      c← ⎕NEW gmpz 10
      v← c.ClrBit 1
      rep,← ⊂Chk(⊂'ClrBit 1 returns 0')(⊂0)(⊂v)
      rep,← ⊂Chk(⊂'ClrBit 1: 10 becomes 8')(⊂'8')(⊂(⌷c))
      c← ⎕NEW gmpz 10
      v← c.Flip 0
      rep,← ⊂Chk(⊂'Flip 0 returns new bit 1')(⊂1)(⊂v)
      rep,← ⊂Chk(⊂'Flip 0: 10 becomes 11')(⊂'11')(⊂(⌷c))
      c← ⎕NEW gmpz 10
      v← c.Flip 1
      rep,← ⊂Chk(⊂'Flip 1 returns new bit 0')(⊂0)(⊂v)
      rep,← ⊂Chk(⊂'Flip 1: 10 becomes 8')(⊂'8')(⊂(⌷c))
      c← ⎕NEW gmpz 0
      c.SetBit 100
      rep,← ⊂Chk(⊂'SetBit 100 grows the object to 2*100')(⊂'1267650600228229401496703205376')(⊂(⌷c))
   :Else
      rep,← ⊂'**FAIL: TestBit / SetBit / ClrBit / Flip section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 13. Scan / Iota (⎕IO←0) ─────────────────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 10
      rep,← ⊂Chk(⊂'Iota 1 of 10 = 1 (first 1-bit, 0-origin)')(⊂1)(⊂(c.Iota 1))
      rep,← ⊂Chk(⊂'Iota 0 of 10 = 0 (first 0-bit)')(⊂0)(⊂(c.Iota 0))
      rep,← ⊂Chk(⊂'Scan (2 1) of 10 = 3')(⊂3)(⊂(c.Scan 2 1))
      rep,← ⊂Chk(⊂'Scan (2 0) of 10 = 2')(⊂2)(⊂(c.Scan 2 0))
      rep,← ⊂Chk(⊂'Scan (0 1) of 10 = 1')(⊂1)(⊂(c.Scan 0 1))
      c← ⎕NEW gmpz 8
      rep,← ⊂Chk(⊂'Iota 1 of 8 = 3')(⊂3)(⊂(c.Iota 1))
      rep,← ⊂Chk(⊂'Iota 0 of 8 = 0')(⊂0)(⊂(c.Iota 0))
      c← ⎕NEW gmpz 10
      v← c.Scan 4 1
      rep,← ⊂Chk(⊂'Scan past the top 1-bit: not found = UL_MAX, not ⎕IO-adjusted')(⊂¯1+2*gmpz.WINDOWS⊃64 32)(⊂v)
   :Else
      rep,← ⊂'**FAIL: Scan / Iota section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 14. And / Or / Xor / Neg / Abs / Divisible ───────────────────
   :Trap 0
      c← ⎕NEW gmpz 12
      rep,← ⊂Chk(⊂'And 12∧10 = 8')(⊂'8')(⊂(⌷(c.And 10)))
      c← ⎕NEW gmpz 12
      rep,← ⊂Chk(⊂'Or 12∨10 = 14')(⊂'14')(⊂(⌷(c.Or 10)))
      c← ⎕NEW gmpz 12
      rep,← ⊂Chk(⊂'Xor 12≠10 = 6')(⊂'6')(⊂(⌷(c.Xor 10)))
      c← ⎕NEW gmpz 5
      rep,← ⊂Chk(⊂'Neg (niladic) 5 = ¯5')(⊂'¯5')(⊂(⌷c.Neg))
      c← ⎕NEW gmpz ¯5
      rep,← ⊂Chk(⊂'Neg (niladic) ¯5 = 5')(⊂'5')(⊂(⌷c.Neg))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'(c.Set b).Neg sets c← -b')(⊂'¯5')(⊂(⌷(c.Set 5).Neg))
      c← ⎕NEW gmpz ¯5
      rep,← ⊂Chk(⊂'Abs (niladic) ¯5 = 5')(⊂'5')(⊂(⌷c.Abs))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'(c.Set b).Abs sets c← |b')(⊂'5')(⊂(⌷(c.Set'¯5').Abs))
      c← ⎕NEW gmpz 10
      rep,← ⊂Chk(⊂'Divisible 10 by 2 = 1')(⊂1)(⊂(c.Divisible 2))
      rep,← ⊂Chk(⊂'Divisible 10 by 3 = 0')(⊂0)(⊂(c.Divisible 3))
      rep,← ⊂Chk(⊂'Divisible 10 by a string = 1 (a 0/1 result, not a raw nonzero)')(⊂1)(⊂(c.Divisible'5'))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Divisible 0 by 0 = 1')(⊂1)(⊂(c.Divisible 0))
   :Else
      rep,← ⊂'**FAIL: And / Or / Xor / Neg / Abs / Divisible section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 15. Bit property (⎕IO←0) ────────────────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 10
      rep,← ⊂Chk(⊂'Bit[1] of 10 = 1')(⊂1)(⊂(c.Bit[1]))
      rep,← ⊂Chk(⊂'Bit[0] of 10 = 0')(⊂0)(⊂(c.Bit[0]))
      rep,← ⊂Chk(⊂'Bit[0 2 3] of 10 = 0 0 1')(⊂0 0 1)(⊂(c.Bit[0 2 3]))
      c← ⎕NEW gmpz 10
      c.Bit[0]← 1
      rep,← ⊂Chk(⊂'Bit[0]←1: 10 becomes 11')(⊂'11')(⊂(⌷c))
      c← ⎕NEW gmpz 10
      c.Bit[1 3]← 0 0
      rep,← ⊂Chk(⊂'Bit[1 3]←0 0: 10 becomes 0')(⊂'0')(⊂(⌷c))
   :Else
      rep,← ⊂'**FAIL: Bit property section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 16. Bits (get and set) ──────────────────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 10
      rep,← ⊂Chk(⊂'Bits 10 = 0 1 0 1 0')(⊂0 1 0 1 0)(⊂(c.Bits))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Bits 0 = 0')(⊂,0)(⊂(c.Bits))
      c← ⎕NEW gmpz 255
      rep,← ⊂Chk(⊂'Bits 255 = 0 then eight 1s')(⊂0,8⍴1)(⊂(c.Bits))
      c← ⎕NEW gmpz 8
      rep,← ⊂Chk(⊂'≢Bits = BitLen (8)')(⊂(c.BitLen))(⊂(≢c.Bits))
      c← ⎕NEW gmpz ¯5
      rep,← ⊂Chk(⊂'Bits ¯5 = 1 0 1 1 (two''s complement, no error)')(⊂1 0 1 1)(⊂(c.Bits))
      c← ⎕NEW gmpz ¯1
      rep,← ⊂Chk(⊂'Bits ¯1 = 1')(⊂,1)(⊂(c.Bits))
      c← ⎕NEW gmpz 0
      c.Bits← 0 1 0 1
      rep,← ⊂Chk(⊂'Bits← 0 1 0 1 sets 5')(⊂'5')(⊂(⌷c))
      c.Bits← 1 0 1 1
      rep,← ⊂Chk(⊂'Bits← 1 0 1 1 sets ¯5')(⊂'¯5')(⊂(⌷c))
      c.Bits← ,1
      rep,← ⊂Chk(⊂'Bits← ,1 sets ¯1')(⊂'¯1')(⊂(⌷c))
      c.Bits← ⍬
      rep,← ⊂Chk(⊂'Bits← ⍬ (empty, used to be a VALUE ERROR) sets 0')(⊂'0')(⊂(⌷c))
   ⍝ round trip across the 64-bit limb boundaries
      vals← '1' '¯1' '9223372036854775807' '9223372036854775808' '¯9223372036854775808' '¯9223372036854775809' '18446744073709551615' '18446744073709551616' '¯18446744073709551616'big
      vals,← ⊂'¯',big
      ok← 1
      :For val :In vals
         a← ⎕NEW gmpz val
         b← ⎕NEW gmpz 0
         b.Bits← a.Bits
         ok← ok∧(a.Cmp b)≡0
      :EndFor
      rep,← ⊂Chk(⊂'Bits round trip (a.Bits → b.Bits←) across 64-bit limb boundaries and signs')(⊂1)(⊂ok)
      c← ⎕NEW gmpz 5
      rep,← ⊂Chk(⊂'ExportBits 8 sign-extends: 5 = 0 0 0 0 0 1 0 1')(⊂0 0 0 0 0 1 0 1)(⊂(c.ExportBits 8))
      c← ⎕NEW gmpz ¯5
      rep,← ⊂Chk(⊂'ExportBits 8 sign-extends: ¯5 = 1 1 1 1 1 0 1 1')(⊂1 1 1 1 1 0 1 1)(⊂(c.ExportBits 8))
   :Else
      rep,← ⊂'**FAIL: Bits section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 17. Fac ──────────────────────────────────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Fac 0 = 1')(⊂'1')(⊂(⌷(c.Fac 0)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Fac 5 = 120')(⊂'120')(⊂(⌷(c.Fac 5)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Fac 20')(⊂'2432902008176640000')(⊂(⌷(c.Fac 20)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Fac string 5 = 120')(⊂'120')(⊂(⌷(c.Fac'5')))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Fac gmpz 5 = 120')(⊂'120')(⊂(⌷(c.Fac(⎕NEW gmpz 5))))
   :Else
      rep,← ⊂'**FAIL: Fac section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 18. Cmp / Lt / Le / Eq / Ne / Ge / Gt ────────────────────────
   :Trap 0
      c← ⎕NEW gmpz 5
      rep,← ⊂Chk(⊂'Cmp 5 vs 3 = 1')(⊂1)(⊂(c.Cmp 3))
      rep,← ⊂Chk(⊂'Cmp 5 vs 5 = 0')(⊂0)(⊂(c.Cmp 5))
      rep,← ⊂Chk(⊂'Cmp 5 vs 7 = ¯1')(⊂¯1)(⊂(c.Cmp 7))
      rep,← ⊂Chk(⊂'Lt 5<7')(⊂1)(⊂(c.Lt 7))
      rep,← ⊂Chk(⊂'Lt 5<5 = 0')(⊂0)(⊂(c.Lt 5))
      rep,← ⊂Chk(⊂'Le 5≤5')(⊂1)(⊂(c.Le 5))
      rep,← ⊂Chk(⊂'Eq 5=5')(⊂1)(⊂(c.Eq 5))
      rep,← ⊂Chk(⊂'Eq 5=7 = 0')(⊂0)(⊂(c.Eq 7))
      rep,← ⊂Chk(⊂'Ne 5≠7')(⊂1)(⊂(c.Ne 7))
      rep,← ⊂Chk(⊂'Ge 5≥5')(⊂1)(⊂(c.Ge 5))
      rep,← ⊂Chk(⊂'Gt 5>3')(⊂1)(⊂(c.Gt 3))
      c← ⎕NEW gmpz big
      rep,← ⊂Chk(⊂'Cmp big vs string, equal')(⊂0)(⊂(c.Cmp big))
      rep,← ⊂Chk(⊂'Cmp big vs smaller')(⊂1)(⊂(c.Cmp'1'))
      c← ⎕NEW gmpz'¯9223372036854775808'
      rep,← ⊂Chk(⊂'Cmp ¯2*63 vs ¯2*63 (the signed-int fast path boundary) = 0')(⊂0)(⊂(c.Cmp'¯9223372036854775808'))
      rep,← ⊂Chk(⊂'Cmp ¯2*63 vs ¯9223372036854775809 = 1')(⊂1)(⊂(c.Cmp'¯9223372036854775809'))
   :Else
      rep,← ⊂'**FAIL: Comparison section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 19. Rand / RandB / RandSeed ──────────────────────────────────
   :Trap 0
      old← gmpz.RandSeed 42
      a← ⎕NEW gmpz 0
      v1← (a.Rand 1000000).Int64
      old← gmpz.RandSeed 42
      rep,← ⊂Chk(⊂'RandSeed 42 again returns old seed 42')(⊂'42')(⊂old)
      b← ⎕NEW gmpz 0
      v2← (b.Rand 1000000).Int64
      rep,← ⊂Chk(⊂'Rand deterministic: same seed, same draw')(⊂v1)(⊂v2)
      ok← 1
      :For i :In ⍳20
         v← (a.Rand 10).Int64
         ok← ok∧(0≤v)∧(v<10)
      :EndFor
      rep,← ⊂Chk(⊂'Rand 10: 20 draws all in 0..9 (⎕IO←0)')(⊂1)(⊂ok)
      ok← 1
      :For i :In ⍳20
         v← (a.RandB 8).Int64
         ok← ok∧(0≤v)∧(v<256)
      :EndFor
      rep,← ⊂Chk(⊂'RandB 8: 20 draws all in 0..255 (⎕IO←0)')(⊂1)(⊂ok)
      a← ⎕NEW gmpz 0
      v← (a.RandB 0).Int64
      rep,← ⊂Chk(⊂'RandB 0 = 0')(⊂0)(⊂v)
      a.Rand big
      rep,← ⊂Chk(⊂'Rand with a 30-digit string bound: result < bound')(⊂¯1)(⊂(a.Cmp big))
   :Else
      rep,← ⊂'**FAIL: Rand / RandB / RandSeed section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 20. ProbabPrime / NextPrime / PrevPrime / PrevPrime2 / Jacobi ─
   :Trap 0
      c← ⎕NEW gmpz 97
      rep,← ⊂Chk(⊂'ProbabPrime 97 = 2 (definitely prime)')(⊂2)(⊂(c.ProbabPrime 24))
      c← ⎕NEW gmpz 100
      rep,← ⊂Chk(⊂'ProbabPrime 100 = 0 (not prime)')(⊂0)(⊂(c.ProbabPrime 24))
      c← ⎕NEW gmpz 97
      rep,← ⊂Chk(⊂'ProbabPrime 0 reps = default, 97 = 2')(⊂2)(⊂(c.ProbabPrime 0))
      rep,← ⊂Chk(⊂'ProbabPrime ⍬ reps = default, 97 = 2')(⊂2)(⊂(c.ProbabPrime ⍬))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'NextPrime 10 = 11')(⊂'11')(⊂(⌷(c.NextPrime 10)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'NextPrime 2 = 3')(⊂'3')(⊂(⌷(c.NextPrime 2)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'PrevPrime 10 = 7')(⊂'7')(⊂(⌷(c.PrevPrime 10)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'PrevPrime 3 = 2')(⊂'2')(⊂(⌷(c.PrevPrime 3)))
      c← ⎕NEW gmpz 0
      pp← c.PrevPrime2 10
      rep,← ⊂Chk(⊂'PrevPrime2 10 prime = 7')(⊂'7')(⊂(⌷⊃pp))
      rep,← ⊂Chk(⊂'PrevPrime2 10 certainty = 2')(⊂2)(⊂(1⊃pp))
      c← ⎕NEW gmpz 0
      pp← c.PrevPrime2 2
      rep,← ⊂Chk(⊂'PrevPrime2 2: no previous prime, rc = 0 (no error)')(⊂0)(⊂(1⊃pp))
      c← ⎕NEW gmpz 2
      rep,← ⊂Chk(⊂'Jacobi (2/7) = 1')(⊂1)(⊂(c.Jacobi 7))
      c← ⎕NEW gmpz 3
      rep,← ⊂Chk(⊂'Jacobi (3/7) = ¯1')(⊂¯1)(⊂(c.Jacobi 7))
      c← ⎕NEW gmpz 7
      rep,← ⊂Chk(⊂'Jacobi (7/7) = 0')(⊂0)(⊂(c.Jacobi 7))
   :Else
      rep,← ⊂'**FAIL: Prime / Jacobi section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 21. GI dyadic arithmetic ─────────────────────────────────────
   :Trap 0
      rep,← ⊂Chk(⊂'GI 5+3')(⊂'8')(⊂(⌷(5+GI 3)))
      rep,← ⊂Chk(⊂'GI 5-3')(⊂'2')(⊂(⌷(5-GI 3)))
      rep,← ⊂Chk(⊂'GI 5×3')(⊂'15')(⊂(⌷(5×GI 3)))
      rep,← ⊂Chk(⊂'GI ¯7÷2 floored')(⊂'¯4')(⊂(⌷(¯7÷GI 2)))
      rep,← ⊂Chk(⊂'GI 2*10')(⊂'1024')(⊂(⌷(2*GI 10)))
      rep,← ⊂Chk(⊂'GI 27*÷3 root')(⊂'3')(⊂(⌷(27*GI÷3)))
      rep,← ⊂Chk(⊂'GI 12∨18 gcd')(⊂'6')(⊂(⌷(12∨GI 18)))
      rep,← ⊂Chk(⊂'GI 12∧18 lcm')(⊂'36')(⊂(⌷(12∧GI 18)))
      rep,← ⊂Chk(⊂'GI 7|¯2 residue')(⊂'5')(⊂(⌷(7|GI ¯2)))
      rep,← ⊂Chk(⊂'GI 1⌽3 shift left')(⊂'6')(⊂(⌷(1⌽GI 3)))
      rep,← ⊂Chk(⊂'GI ¯1⌽7 shift right')(⊂'3')(⊂(⌷(¯1⌽GI 7)))
      rep,← ⊂Chk(⊂'GI 16⊥ff base')(⊂'255')(⊂(⌷(16⊥GI'ff')))
      rep,← ⊂Chk(⊂'GI big: string + string')(⊂'111111111011111111100')(⊂(⌷('12345678901234567890'+GI'98765432109876543210')))
   :Else
      rep,← ⊂'**FAIL: GI dyadic arithmetic section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 22. GI comparisons / DivRem / PowM / Iota / Bit / ⊤ / ≢ ──────
   :Trap 0
      rep,← ⊂Chk(⊂'GI 5<7')(⊂1)(⊂(5<GI 7))
      rep,← ⊂Chk(⊂'GI 5≤5')(⊂1)(⊂(5≤GI 5))
      rep,← ⊂Chk(⊂'GI 5=5')(⊂1)(⊂(5=GI 5))
      rep,← ⊂Chk(⊂'GI 5≠7')(⊂1)(⊂(5≠GI 7))
      rep,← ⊂Chk(⊂'GI 5≥5')(⊂1)(⊂(5≥GI 5))
      rep,← ⊂Chk(⊂'GI 5>3')(⊂1)(⊂(5>GI 3))
      rep,← ⊂Chk(⊂'GI 5>7 = 0')(⊂0)(⊂(5>GI 7))
      pp← 7(÷∘|GI)2
      rep,← ⊂Chk(⊂'GI ÷∘| 7÷2 quotient')(⊂'3')(⊂(⌷⊃pp))
      rep,← ⊂Chk(⊂'GI ÷∘| 7÷2 remainder')(⊂'1')(⊂(⌷1⊃pp))
      z← 100+GI 1
      rep,← ⊂Chk(⊂'GI ÷∘| quotient survives a later GI call')(⊂'3')(⊂(⌷⊃pp))
      rep,← ⊂Chk(⊂'GI *∘| 2*10 mod 1000')(⊂'24')(⊂(⌷(2(*∘|GI)(10 1000))))
      rep,← ⊂Chk(⊂'GI 10⍳1 first 1-bit')(⊂1)(⊂(10⍳GI 1))
      rep,← ⊂Chk(⊂'GI 1⌷10 bit 1 of 10')(⊂1)(⊂(1⌷GI 10))
      rep,← ⊂Chk(⊂'GI 0⌷10 bit 0 of 10')(⊂0)(⊂(0⌷GI 10))
      rep,← ⊂Chk(⊂'GI 16⊤255 base-16 string')(⊂'ff')(⊂(16⊤GI 255))
      rep,← ⊂Chk(⊂'GI 16≢255 length in base 16')(⊂2)(⊂(16≢GI 255))
   :Else
      rep,← ⊂'**FAIL: GI comparisons / DivRem / PowM / Iota / Bit section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 23. GI monadic ───────────────────────────────────────────────
   :Trap 0
      rep,← ⊂Chk(⊂'GI -5 negate')(⊂'¯5')(⊂(⌷(-GI 5)))
      rep,← ⊂Chk(⊂'GI |¯5 abs')(⊂'5')(⊂(⌷(|GI ¯5)))
      rep,← ⊂Chk(⊂'GI ×¯5 sign')(⊂¯1)(⊂(×GI ¯5))
      rep,← ⊂Chk(⊂'GI ×0 sign')(⊂0)(⊂(×GI 0))
      rep,← ⊂Chk(⊂'GI !5 factorial')(⊂'120')(⊂(⌷(!GI 5)))
      rep,← ⊂Chk(⊂'GI <5 decrement')(⊂'4')(⊂(⌷(<GI 5)))
      rep,← ⊂Chk(⊂'GI >5 increment')(⊂'6')(⊂(⌷(>GI 5)))
      rep,← ⊂Chk(⊂'GI ≢12345 StrLen')(⊂5)(⊂(≢GI'12345'))
      rep,← ⊂Chk(⊂'GI ⍎123 IntDF')(⊂123)(⊂(⍎GI'123'))
      rep,← ⊂Chk(⊂'GI ⌷123 bit vector')(⊂0 1 1 1 1 0 1 1)(⊂(⌷GI 123))
      rep,← ⊂Chk(⊂'GI ⊤123 decimal string')(⊂'123')(⊂(⊤GI 123))
      rep,← ⊂Chk(⊂'GI ⊥123 fresh gmpz')(⊂'123')(⊂⌷(⊥GI'123'))
      rep,← ⊂Chk(⊂'GI ⎕VFI 42 = 1 42')(⊂1 42)(⊂((⎕VFI GI)'42'))
      ok← 1
      :For i :In ⍳20
         v← (?GI 10).Int64
         ok← ok∧(0≤v)∧(v<10)
      :EndFor
      rep,← ⊂Chk(⊂'GI ?10: 20 draws all in 0..9 (⎕IO←0)')(⊂1)(⊂ok)
      ok← 1
      :For i :In ⍳20
         v← (?GI ¯8).Int64
         ok← ok∧(0≤v)∧(v<256)
      :EndFor
      rep,← ⊂Chk(⊂'GI ?¯8 (RandB 8): 20 draws all in 0..255')(⊂1)(⊂ok)
   :Else
      rep,← ⊂'**FAIL: GI monadic section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 24. GI does not modify its arguments; unknown glyph ──────────
   :Trap 0
      a← ⎕NEW gmpz 5
      b← ⎕NEW gmpz 3
      z← a+GI b
      rep,← ⊂Chk(⊂'GI result 5+3')(⊂'8')(⊂(⌷z))
      rep,← ⊂Chk(⊂'GI left argument unchanged')(⊂'5')(⊂(⌷a))
      rep,← ⊂Chk(⊂'GI right argument unchanged')(⊂'3')(⊂(⌷b))
      a← ⎕NEW gmpz 5
      z← -GI a
      rep,← ⊂Chk(⊂'GI monadic result -5')(⊂'¯5')(⊂(⌷z))
      rep,← ⊂Chk(⊂'GI monadic argument unchanged')(⊂'5')(⊂(⌷a))
      x← 1+GI 1
      y← 2+GI 2
      rep,← ⊂Chk(⊂'GI results are independent objects (not the shared temp)')(⊂'2 4')(⊂(⌷x),' ',⌷y)
   :Else
      rep,← ⊂'**FAIL: GI no-modify section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
   err← ¯1
   :Trap 0
      z← ⍴GI 5
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'GI unknown glyph ⍴ signals EN 11 (unknownÊ)')(⊂11)(⊂err)
⍝ ── 25. Error paths — each call is trapped, EN is compared ───────
⍝ Div / DivRem by zero
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 5
      c.Div 0
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Div by 0 → divZÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 5
      rem← c.DivRem 0
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'DivRem by 0 → divZÊ EN 11')(⊂11)(⊂err)
⍝ Rand with non-positive bound
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Rand 0
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Rand 0 → randÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.RandB ¯1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'RandB ¯1 → randÊ EN 11')(⊂11)(⊂err)
⍝ Set with a non-integer / invalid value
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Set 1.5
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Set 1.5 → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Set 1 2 3
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Set numeric vector → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Set 1 0 1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Set boolean vector → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Set'12x'
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Set invalid string → badObjÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      16 c.Set 255
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Set with a base but a numeric value → baseXtraÊ EN 11')(⊂11)(⊂err)
⍝ ToInt / Str2I (reached through Shift): bad strings
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      v← '1.5'c.Shift 3
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Shift string ''1.5'' → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      v← '1 2'c.Shift 3
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Shift string ''1 2'' (two numbers) → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      v← ''c.Shift 3
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Shift empty string → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      v← 'abc'c.Shift 3
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Shift string ''abc'' → badAplÊ EN 11')(⊂11)(⊂err)
⍝ Int overflow
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz'9223372036854775808'
      v← c.Int64
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Int64 2*63 → badIntÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz(40⍴'9')
      v← c.IntDF
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'IntDF 40 digits → badIntÊ EN 11')(⊂11)(⊂err)
⍝ Pow errors
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 2
      c.Pow ¯1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Pow negative exponent → powÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz ¯16
      c.Pow÷2
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Pow even root of negative → powÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 2
      c.Pow 0.4
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Pow 0.4 (not the inverse of an integer) → powÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 2
      c.Pow'3'
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Pow string exponent → powÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 2
      c.PowM ¯1 100
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'PowM negative exponent → powÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 2
      c.PowM 2 0
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'PowM modulus 0 → divZÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 2
      c.PowM 2 ¯5
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'PowM negative modulus → powÊ EN 11')(⊂11)(⊂err)
⍝ Factorial errors
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Fac ¯1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Fac ¯1 → facBadÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Fac(⎕NEW gmpz ¯1)
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Fac gmpz ¯1 → facBadÊ EN 11 (a gmpz argument is range-checked too)')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Fac 2*(gmpz.WINDOWS⊃70 40)
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Fac beyond the C unsigned long maximum → facBadÊ EN 11')(⊂11)(⊂err)
⍝ Bit errors
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 10
      v← c.TestBit ¯1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'TestBit ¯1 → badBitIxÊ EN 3')(⊂3)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 10
      v← c.SetBit 1 2
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'SetBit value 2 → badBitValÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 10
      v← c.SetBit ¯1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'SetBit ¯1 → badBitIxÊ EN 3')(⊂3)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 10
      v← 5 c.SetBit 1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'SetBit with a left argument → SYNTAX ERROR EN 2 (mutators act on the receiver only)')(⊂2)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 10
      v← c.Bit[¯1]
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Bit[¯1] → badBitIxÊ EN 3')(⊂0)(⊂v)                                       ⍝ Bit[¯1] is valid!
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Bits← 1 0 2
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Bits← containing 2 → badBitsÊ EN 11')(⊂11)(⊂err)
⍝ Other domain errors
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 255
      v← c.GetInBase 1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'GetInBase 1 → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 255
      v← c.GetInBase 63
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'GetInBase 63 → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 255
      v← c.StrLenInBase 1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'StrLenInBase 1 → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 2
      v← c.Jacobi 6
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Jacobi even modulus → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 97
      v← c.ProbabPrime ¯1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'ProbabPrime ¯1 → primeÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.PrevPrime 2
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'PrevPrime 2 → noPrevPrimeÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      old← gmpz.RandSeed ¯1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'RandSeed ¯1 → randSeedÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Invert 0
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Invert modulus 0 → divZÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      v← 1.5 c.Shift 7
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Shift 1.5 (non-integer shift) → shiftÊ EN 11')(⊂11)(⊂err)
⍝ ── 27. Com / PopCount / HamDist / Float / ShiftFloor ───────────
   :Trap 0
      c← ⎕NEW gmpz 5
      rep,← ⊂Chk(⊂'Com 5 = ¯6')(⊂'¯6')(⊂(⌷c.Com))
      c← ⎕NEW gmpz ¯1
      rep,← ⊂Chk(⊂'Com ¯1 = 0')(⊂'0')(⊂(⌷c.Com))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Com 0 = ¯1')(⊂'¯1')(⊂(⌷c.Com))
      c← ⎕NEW gmpz 255
      rep,← ⊂Chk(⊂'PopCount 255 = 8')(⊂8)(⊂(c.PopCount))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'PopCount 0 = 0')(⊂0)(⊂(c.PopCount))
      c← ⎕NEW gmpz'18446744073709551615'
      rep,← ⊂Chk(⊂'PopCount 2*64-1 = 64')(⊂64)(⊂(c.PopCount))
      c← ⎕NEW gmpz ¯1
      rep,← ⊂Chk(⊂'PopCount of a negative = UL_MAX (infinitely many 1 bits)')(⊂¯1+2*gmpz.WINDOWS⊃64 32)(⊂(c.PopCount))
      c← ⎕NEW gmpz 255
      rep,← ⊂Chk(⊂'HamDist 255 15 = 4')(⊂4)(⊂(c.HamDist 15))
      rep,← ⊂Chk(⊂'HamDist with left operand: 10 vs 12 = 2')(⊂2)(⊂(10 c.HamDist 12))
      c← ⎕NEW gmpz 123
      rep,← ⊂Chk(⊂'Float 123')(⊂123)(⊂(c.Float))
      c← ⎕NEW gmpz'18446744073709551616'
      rep,← ⊂Chk(⊂'Float 2*64 (a double: compare with a tolerance, not exactly)')(⊂1)(⊂1E¯15>|1-(c.Float)÷2*64)
      c← ⎕NEW gmpz ¯5
      rep,← ⊂Chk(⊂'Float ¯5')(⊂¯5)(⊂(c.Float))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'ShiftFloor ¯1>>7 = 3')(⊂'3')(⊂(⌷(¯1 c.ShiftFloor 7)))
      rep,← ⊂Chk(⊂'ShiftFloor ¯1>>¯7 = ¯4 (floored; Shift gives ¯3)')(⊂'¯4')(⊂(⌷(¯1 c.ShiftFloor ¯7)))
      rep,← ⊂Chk(⊂'ShiftFloor ¯7>>¯3 = ¯1 (floored; Shift gives 0)')(⊂'¯1')(⊂(⌷(¯7 c.ShiftFloor ¯3)))
      rep,← ⊂Chk(⊂'ShiftFloor left 3<<1 = 8')(⊂'8')(⊂(⌷(3 c.ShiftFloor 1)))
      rep,← ⊂Chk(⊂'ShiftFloor 0 leaves value')(⊂'5')(⊂(⌷(0 c.ShiftFloor 5)))
   :Else
      rep,← ⊂'**FAIL: Com / PopCount / HamDist / Float / ShiftFloor section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── 28. Bin / Fib / Primorial / SqrtRem / IsSquare / IsPower / GcdExt / Divexact / Congruent ─
   :Trap 0
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Bin 10 choose 3 = 120')(⊂'120')(⊂(⌷(10 c.Bin 3)))
      rep,← ⊂Chk(⊂'Bin n choose 0 = 1')(⊂'1')(⊂(⌷(10 c.Bin 0)))
      rep,← ⊂Chk(⊂'Bin ¯3 choose 2 = 6 (generalised binomial)')(⊂'6')(⊂(⌷(¯3 c.Bin 2)))
      rep,← ⊂Chk(⊂'Bin 100 choose 50 (string n)')(⊂'100891344545564193334812497256')(⊂(⌷('100'c.Bin 50)))
      c← ⎕NEW gmpz 52
      rep,← ⊂Chk(⊂'Bin default n: 52 choose 5')(⊂'2598960')(⊂(⌷(c.Bin 5)))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Fib 10 = 55')(⊂'55')(⊂(⌷c.Fib 10))
      rep,← ⊂Chk(⊂'Fib 0 = 0')(⊂'0')(⊂(⌷c.Fib 0))
      rep,← ⊂Chk(⊂'Fib 100')(⊂'354224848179261915075')(⊂(⌷c.Fib 100))
      rep,← ⊂Chk(⊂'Primorial 10 = 210')(⊂'210')(⊂(⌷c.Primorial 10))
      rep,← ⊂Chk(⊂'Primorial 0 = 1')(⊂'1')(⊂(⌷c.Primorial 0))
      rep,← ⊂Chk(⊂'Primorial 30 = 6469693230')(⊂'6469693230')(⊂(⌷c.Primorial 30))
      c← ⎕NEW gmpz 0
      rem← c.SqrtRem 17
      rep,← ⊂Chk(⊂'SqrtRem 17: root = 4')(⊂'4')(⊂(⌷c))
      rep,← ⊂Chk(⊂'SqrtRem 17: remainder = 1 (a gmpz)')(⊂'1')(⊂(⌷rem))
      rem← c.SqrtRem'1000000000000000000000000000000'
      rep,← ⊂Chk(⊂'SqrtRem 10*30: root = 10*15')(⊂'1000000000000000')(⊂(⌷c))
      rep,← ⊂Chk(⊂'SqrtRem 10*30: remainder = 0')(⊂'0')(⊂(⌷rem))
      c← ⎕NEW gmpz 16
      rep,← ⊂Chk(⊂'IsSquare 16 = 1')(⊂1)(⊂(c.IsSquare))
      c← ⎕NEW gmpz 15
      rep,← ⊂Chk(⊂'IsSquare 15 = 0')(⊂0)(⊂(c.IsSquare))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'IsSquare 0 = 1')(⊂1)(⊂(c.IsSquare))
      c← ⎕NEW gmpz ¯4
      rep,← ⊂Chk(⊂'IsSquare ¯4 = 0')(⊂0)(⊂(c.IsSquare))
      c← ⎕NEW gmpz 27
      rep,← ⊂Chk(⊂'IsPower 27 = 1')(⊂1)(⊂(c.IsPower))
      c← ⎕NEW gmpz 28
      rep,← ⊂Chk(⊂'IsPower 28 = 0')(⊂0)(⊂(c.IsPower))
      c← ⎕NEW gmpz 0
      st← 240 c.GcdExt 46
      rep,← ⊂Chk(⊂'GcdExt 240 46: gcd = 2')(⊂'2')(⊂(⌷c))
      x← ⎕NEW gmpz 240
      x.Mul⊃st
      y← ⎕NEW gmpz 46
      y.Mul⊃⌽st
      x.Add y
      rep,← ⊂Chk(⊂'GcdExt: 240×s + 46×t = gcd')(⊂'2')(⊂(⌷x))
      c← ⎕NEW gmpz 0
      rep,← ⊂Chk(⊂'Divexact 100÷4 = 25')(⊂'25')(⊂(⌷(100 c.Divexact 4)))
      rep,← ⊂Chk(⊂'Divexact big string ÷ 1000')(⊂'1000000000000000000')(⊂(⌷('1000000000000000000000'c.Divexact 1000)))
      c← ⎕NEW gmpz 17
      rep,← ⊂Chk(⊂'Congruent 17 ≡ 5 (mod 12)')(⊂1)(⊂(c.Congruent 5 12))
      rep,← ⊂Chk(⊂'Congruent 17 ≡ 6 (mod 12) = 0')(⊂0)(⊂(c.Congruent 6 12))
      rep,← ⊂Chk(⊂'Congruent mod 0: 17 ≡ 17')(⊂1)(⊂(c.Congruent 17 0))
      rep,← ⊂Chk(⊂'Congruent mod 0: 17 ≡ 18 = 0')(⊂0)(⊂(c.Congruent 18 0))
      rep,← ⊂Chk(⊂'Congruent ¯7 ≡ 5 (mod 12)')(⊂1)(⊂((⎕NEW gmpz ¯7).Congruent 5 12))
      rep,← ⊂Chk(⊂'GI 3!5 = 10 (APL order: 5 choose 3)')(⊂'10')(⊂(⌷(3!GI 5)))
      rep,← ⊂Chk(⊂'GI ~5 = ¯6')(⊂'¯6')(⊂(⌷(~GI 5)))
      rep,← ⊂Chk(⊂'GI 3⌈9 = 9')(⊂'9')(⊂(⌷(3⌈GI 9)))
      rep,← ⊂Chk(⊂'GI 3⌊9 = 3')(⊂'3')(⊂(⌷(3⌊GI 9)))
      rep,← ⊂Chk(⊂'GI big max (strings)')(⊂'100000000000000000000')(⊂(⌷('100000000000000000000'⌈GI'99999999999999999999')))
   :Else
      rep,← ⊂'**FAIL: Bin / Fib / Primorial / … / Congruent section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 5
      c.Bin ¯1
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Bin k negative → badUIntÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 5
      c.Fib 1.5
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Fib 1.5 → badAplÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Primorial ¯2
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Primorial ¯2 → badUIntÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      rem← c.SqrtRem ¯4
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'SqrtRem negative → sqrtNegÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 0
      c.Divexact 0
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Divexact by 0 → divZÊ EN 11')(⊂11)(⊂err)
   err← ¯1
   :Trap 0
      c← ⎕NEW gmpz 1
      v← 1100 c.Shift c
      v← c.Float
   :Else
      err← ⎕DMX.EN
   :EndTrap
   rep,← ⊂Chk(⊂'Float of a >1024-bit number → badIntÊ EN 11')(⊂11)(⊂err)
⍝ ── 26. ⎕IO←1 — Bit / TestBit / SetBit / ClrBit / Flip / Iota / Scan / Rand ─
⍝    The bit-index methods and Rand/RandB honour the caller's ⎕IO. These checks run under ⎕IO←1.
⍝    A FAIL here means the caller's ⎕IO is not being picked up (see the ∆io← (⊃⎕RSI).⎕IO lines
⍝    in gmpz), not necessarily a wrong result in the origin-0 code.
   ⎕IO← 1
   :Trap 0
      c← ⎕NEW gmpz 10
      rep,← ⊂Chk(⊂'IO=1 Bit[2] of 10 = 1')(⊂1)(⊂(c.Bit[2]))
      rep,← ⊂Chk(⊂'IO=1 Bit[1] of 10 = 0')(⊂0)(⊂(c.Bit[1]))
      rep,← ⊂Chk(⊂'IO=1 TestBit 2 of 10 = 1')(⊂1)(⊂(c.TestBit 2))
      rep,← ⊂Chk(⊂'IO=1 TestBit 1 of 10 = 0 (the first bit used to be rejected)')(⊂0)(⊂(c.TestBit 1))
      c← ⎕NEW gmpz 10
      v← c.SetBit 1
      rep,← ⊂Chk(⊂'IO=1 SetBit 1: 10 becomes 11')(⊂'11')(⊂(⌷c))
      c← ⎕NEW gmpz 10
      v← c.ClrBit 2
      rep,← ⊂Chk(⊂'IO=1 ClrBit 2: 10 becomes 8')(⊂'8')(⊂(⌷c))
      c← ⎕NEW gmpz 10
      v← c.Flip 1
      rep,← ⊂Chk(⊂'IO=1 Flip 1: 10 becomes 11')(⊂'11')(⊂(⌷c))
      c← ⎕NEW gmpz 10
      rep,← ⊂Chk(⊂'IO=1 Iota 1 of 10 = 2')(⊂2)(⊂(c.Iota 1))
      rep,← ⊂Chk(⊂'IO=1 Iota 0 of 10 = 1')(⊂1)(⊂(c.Iota 0))
      rep,← ⊂Chk(⊂'IO=1 Scan (2 1) of 10 = 2')(⊂2)(⊂(c.Scan 2 1))
      ok← 1
      :For i :In ⍳20
         v← (c.Rand 10).Int64
         ok← ok∧(1≤v)∧(v≤10)
      :EndFor
      rep,← ⊂Chk(⊂'IO=1 Rand 10: 20 draws all in 1..10')(⊂1)(⊂ok)
      ok← 1
      :For i :In ⍳20
         v← (c.RandB 8).Int64
         ok← ok∧(1≤v)∧(v≤256)
      :EndFor
      rep,← ⊂Chk(⊂'IO=1 RandB 8: 20 draws all in 1..256')(⊂1)(⊂ok)
      err← ¯1
      :Trap 0
         v← c.TestBit 0
      :Else
         err← ⎕DMX.EN
      :EndTrap
      rep,← ⊂Chk(⊂'IO=1 TestBit 0 → badBitIxÊ EN 3')(⊂3)(⊂err)
      ⎕IO← 0
   :Else
      ⎕IO← 0
      rep,← ⊂'**FAIL: ⎕IO←1 section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
   :EndTrap
⍝ ── Summary ──────────────────────────────────────────────────────
   total+← ≢rep
   pass+← +/IsPass¨rep
:EndFor

fail← total-pass
:For line :In rep
   Say line
:EndFor
Say'gmpz test: ',(⍕pass),' passed, ',(⍕fail),' failed, out of ',(⍕total),' checks.'
r← pass fail total
∇


⍝ =========================================================================
⍝ 1. CORRECTNESS & RACE-CONDITION SUITE
⍝ =========================================================================

∇ r←RaceConditions(nThreads nIters);serial;workers;ok;results;okShared;okDeadlock;okGI
  ⎕←'1A. Scratch-buffer race test:' nThreads 'threads x' nIters 'iterations...'
  ⍝ Serial baseline: deterministic chain forcing string & integer scratch conversion
  serial←Worker nIters
  ⍝ Spawn concurrent threads all competing for the class-level :Hold
  workers←Worker&¨nThreads⍴nIters
  results←⎕TSYNC workers
  ok←∧/results≡¨⊂serial

  ⎕←'1B. Shared-instance mutation & limb-realloc test: 50 threads x' nIters 'iterations...'
  okShared←TestSharedInstance 50 nIters

  ⎕←' 1C. Multi-operand AB-BA deadlock safety test: 2 threads x 2000 iterations...'
  okDeadlock←TestDeadlockSafety 2000

  ⎕←'1D. Lock-free GI operator concurrency test: 50 threads x' nIters 'iterations...'
  okGI←TestGIThreads 50 nIters

  :If ok∧okShared∧okDeadlock∧okGI
      r←'All correctness & race-condition checks passed!'
  :Else
      r←'FAILED — Scratch:',ok,' SharedInstance:',okShared,' Deadlock:',okDeadlock,' GI:',okGI
  :EndIf
∇

∇ ok←TestGIThreads(nThreads nIters);serial;workers;results;GI
  GI←#.GI
  serial←GIWorker nIters
  workers←GIWorker&¨nThreads⍴nIters
  results←⎕TSYNC workers
  ok←∧/results≡¨⊂serial
∇

∇ res←GIWorker nIters;GI;x;y;q;r;i
  GI←#.GI
  x←gmpz.New '123456789012345678901'
  y←gmpz.New 7
  :For i :In ⍳nIters
      x←(x +GI '100000000000000000000') -GI (-GI y)
      (q r)←x ÷∘|GI (i+3)
      x←(q ⌈GI y) +GI (r ×GI (i+2))
  :EndFor
  res←(⌷x) (≢GI x) (16 ⊤GI x)
∇

∇ res←Worker nIters;acc;i
  acc←gmpz.New 1
  ⍝ Force scratch buffer 1, 2, and 3 usage via APL ints and numeric strings
  :For i :In ⍳nIters
      acc.Add i
      '100000000000000000000' acc.Add acc
      acc.Sub '99999999999999999999'
      (i+3) acc.Mul acc
      acc.Div (i+2)
  :EndFor
  res←⌷acc
∇

∇ ok←TestSharedInstance(nThreads nIters);serial;shared;workers;i
  ⍝ Serial baseline: exact sum of nThreads * nIters increments + 31-digit additions
  serial←gmpz.New 0
  :For i :In ⍳nThreads×nIters
      serial.Inc
      serial.Add '1000000000000000000000000000000'
  :EndFor

  ⍝ Concurrent workers all mutating the exact same gmpz instance
  shared←gmpz.New 0
  workers←shared∘SharedAdder&¨nThreads⍴nIters
  ⎕TSYNC workers

  ok←(⌷shared)≡⌷serial
∇

∇ {r}←shared SharedAdder iters;i
  :For i :In ⍳iters
      shared.Inc
      shared.Add '1000000000000000000000000000000'
  :EndFor
  r←1
∇

∇ ok←TestDeadlockSafety nIters;x;y;w1;w2
  x←gmpz.New '123456789012345678901234567890'
  y←gmpz.New '987654321098765432109876543210'

  ⍝ Thread 1 locks (y, x) while Thread 2 locks (x, y) in opposition
  w1←(x y)∘DeadlockWorkerA&nIters
  w2←(x y)∘DeadlockWorkerB&nIters
  ⎕TSYNC w1 w2
  ok←1
∇

∇ {r}←xy DeadlockWorkerA iters;x;y;i
  (x y)←xy
  :For i :In ⍳iters
      x y.Add x
      y x.Sub y
  :EndFor
  r←1
∇

∇ {r}←xy DeadlockWorkerB iters;x;y;i
  (x y)←xy
  :For i :In ⍳iters
      y x.Add y
      x y.Sub x
  :EndFor
  r←1
∇

⍝ =========================================================================
⍝ 2. EFFICIENCY & LOCK-CONTENTION BENCHMARKS
⍝ =========================================================================

∇ res←Contention
  ⍝ Convenience entry point running all contention & scaling suites
  ⎕←'--- A. Scratch Lock Contention (Pure gmpz vs. String/Int) ---'
  ⎕←BenchScratchContention (1 2 4 8) 20000
  ⎕←'--- B. Instance Lock Contention (Hot Shared vs. Sharded) ---'
  ⎕←BenchInstanceContention (1 2 4 8) 20000
  ⎕←'--- C. Heavy GMP Blocking (NextPrime vs. Scratch Ops) ---'
  ⎕←BenchLongHoldBlocking 4 5000
  ⎕←'--- D. Global RandState Contention ---'
  ⎕←BenchRandContention (1 2 4 8) 20000
  ⎕←'--- E1. Multi-Core Isolate Scaling (4 Threads vs. 4 OS Isolates) ---'
  ⎕←BenchIsolateScaling 4 40
  ⎕←'--- E2. Multi-Core Isolate Scaling (6 Threads vs. 6 OS Isolates) ---'
  ⎕←BenchIsolateScaling 6 40
  res←'Benchmarks complete.'
∇

⍝ --- Benchmark A: Shared Scratch Buffer Lock Contention ---
∇ res←BenchScratchContention(threadCounts totalOps);n;opsPerThread;tGmpz;tScratch
  res←1 4⍴'Threads' 'Pure_gmpz_ms' 'Scratch_Hold_ms' 'Slowdown_Ratio'
  :For n :In threadCounts
      opsPerThread←⌊totalOps÷n
      tGmpz←TimeScratchThreads n opsPerThread 0
      tScratch←TimeScratchThreads n opsPerThread 1
      res⍪←n tGmpz tScratch (0.01×⌊0.5+100×tScratch÷1⌈tGmpz)
  :EndFor
∇

∇ ms←TimeScratchThreads(nThreads iters useScratch);t0;workers
  t0←NowMs
  workers←useScratch∘ScratchWorker&¨nThreads⍴iters
  ⎕TSYNC workers
  ms←(NowMs)-t0
∇

∇ {r}←useScratch ScratchWorker iters;acc;k1;k2;i
  acc←gmpz.New 1
  :If useScratch
      :For i :In ⍳iters
          '1000000000000000000000000000000' acc.Add acc
          acc.Sub '999999999999999999999999999999'
      :EndFor
  :Else
      k1←gmpz.New '1000000000000000000000000000000'
      k2←gmpz.New '999999999999999999999999999999'
      :For i :In ⍳iters
          k1 acc.Add acc
          acc.Sub k2
      :EndFor
  :EndIf
  r←1
∇

⍝ --- Benchmark B: Hot Shared Instance vs. Sharded Instances ---
∇ res←BenchInstanceContention(threadCounts totalOps);n;iters;tHot;tSharded;shared;t0;workers
  res←1 4⍴'Threads' 'Hot_Shared_ms' 'Sharded_ms' 'Contention_Ratio'
  :For n :In threadCounts
      iters←⌊totalOps÷n

      shared←gmpz.New 1
      t0←NowMs
      workers←shared∘HotWorker&¨n⍴iters
      ⎕TSYNC workers
      tHot←(NowMs)-t0

      t0←NowMs
      workers←ShardedWorker&¨n⍴iters
      ⎕TSYNC workers
      tSharded←(NowMs)-t0

      res⍪←n tHot tSharded (0.01×⌊0.5+100×tHot÷1⌈tSharded)
  :EndFor
∇

∇ {r}←shared HotWorker iters;step;i
  step←gmpz.New '123456789012345678901234567890'
  :For i :In ⍳iters
      shared.Add step
  :EndFor
  r←1
∇

∇ {r}←ShardedWorker iters;local;step;i
  local←gmpz.New 1
  step←gmpz.New '123456789012345678901234567890'
  :For i :In ⍳iters
      local.Add step
  :EndFor
  r←1
∇

⍝ --- Benchmark C: Long-Running C Calls Holding Locks ---
∇ res←BenchLongHoldBlocking(nBgThreads nFgIters);big;bgWorkers;t0;fgMs;baseMs
  t0←NowMs
  {}FgScratchTask nFgIters
  baseMs←(NowMs)-t0

  big←gmpz.New 2
  1536 big.Shift big
  bgWorkers←big∘BgHeavyTask&¨nBgThreads⍴40

  t0←NowMs
  {}FgScratchTask nFgIters
  fgMs←(NowMs)-t0

  ⎕TSYNC bgWorkers
  res←'Baseline_FG_ms' 'Under_Heavy_Load_ms' 'Ratio'⍪baseMs fgMs (0.01×⌊0.5+100×fgMs÷1⌈baseMs)
∇

∇ {r}←FgScratchTask iters;x;i
  x←gmpz.New 0
  :For i :In ⍳iters
      x.Add '98765432109876543210987654321'
  :EndFor
  r←1
∇

∇ {r}←big BgHeavyTask iters;p;i
  p←big.Copy
  :For i :In ⍳iters
      p.NextPrime p
  :EndFor
  r←1
∇

⍝ --- Benchmark D: Shared gmp_randstate_t Lock Contention ---
∇ res←BenchRandContention(threadCounts totalCalls);n;iters;t0;workers;ms
  res←1 3⍴'Threads' 'Elapsed_ms' 'Calls_Per_Sec'
  :For n :In threadCounts
      iters←⌊totalCalls÷n
      t0←NowMs
      workers←RandWorker&¨n⍴iters
      ⎕TSYNC workers
      ms←1⌈(NowMs)-t0
      res⍪←n ms (⌊1000×(n×iters)÷ms)
  :EndFor
∇

∇ {r}←RandWorker iters;z;i
  z←gmpz.New 0
  :For i :In ⍳iters
      z.RandB 256
  :EndFor
  r←1
∇

⍝ --- Benchmark E: Multi-Core Isolate Scaling (Threads vs. OS Isolates) ---
∇ res←BenchIsolateScaling(nWorkers nIters);isoNS;isos;seed;seedStr;offsets;t0;tWorkers;tRes;tMs;futures;iRes;iMs;match
  ⍝ Load Dyalog's built-in isolate workspace into a local sub-namespace
  isoNS←⎕NS ''
  'isolate' isoNS.⎕CY 'isolate'

  ⍝ Build 1536-bit seed and distinct offsets per worker
  seed←gmpz.New 2
  1536 seed.Shift seed
  seedStr←seed.GetInBase 62
  offsets←100000×⍳nWorkers

  ⍝ 1. Single-process APL green threads (&)
  t0←NowMs
  tWorkers←(⊂seedStr)∘IsoPrimeWorker&¨nIters,¨offsets
  tRes←⎕TSYNC tWorkers
  tMs←1⌈(NowMs)-t0

  ⍝ 2. Multi-process OS isolates (true multi-core execution)
  isos←isoNS.isolate.New¨nWorkers⍴⊂''
  {}2 isos.⎕FIX ⊂'gmpz/gmpz.dyalog'
  ⍝ {}isos.⎕FX ⊂⎕NR 'LoadIsoGmpz'
  ⍝ {}⍕¨isos.LoadIsoGmpz
  {}isos.⎕FX ⊂⎕NR 'IsoPrimeWorker'

  t0←NowMs
  futures←(nWorkers⍴⊂seedStr) isos.IsoPrimeWorker nIters,¨offsets
   iRes←⍕¨futures
  iMs←1⌈(NowMs)-t0

  _← isos.Close
  match←tRes≡iRes

  res←1 4⍴'Threads_ms' 'Isolates_ms' 'Speedup' 'Exact_Match'
  res⍪←tMs iMs (0.01×⌊0.5+100×tMs÷iMs) match
∇

∇ resStr←seedStr IsoPrimeWorker iters_offset;nIters;offset;p;i
  (nIters offset)←iters_offset
  p←gmpz.New0
  62 p.Set ∊seedStr
  p.Add offset
  :For i :In ⍳nIters
      p.NextPrime p
  :EndFor
  resStr←p.GetInBase 62
∇

∇ ok←LoadIsoGmpz
  {}2 #.⎕FIX 'gmpz/gmpz.dyalog'
  ok←1
∇

∇ ms←NowMs;ts;⎕FR
  ⎕FR←1287
  ⍝ High-resolution wall-clock timestamp in milliseconds from ⎕TS
  ts←⎕TS
  ms←(24 60 60 1000⊥4↑3↓ts)+86400000×1 ⎕DT ⊂3↑ts
∇

:EndNamespace
