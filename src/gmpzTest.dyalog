 r←TestGmpz;⎕IO;⎕ML;⎕PP;⎕FR;rep;pass;fail;total;c;a;b;x;y;z;t;rem;rc;err;old;v;v1;v2;ok;i;pp;Chk;IsPass;line
 ⎕IO ⎕ML ⎕PP ⎕FR←0 1 34 1287
 rep←⍬
⍝ Chk: monadic dfn, argument is (name expected actual), each enclosed.
⍝ Returns 'PASS: name' or 'FAIL: name — expected: ... — got: ...'
 Chk←{
⍝ Use ↓ (drop) instead of indexed pick, so this works under
⍝ ⎕IO←0 and under ⎕IO←1 alike: 1⊃⍵ would mean different
⍝ elements in the two origins.
     nm←⊃⍵
     exp←⊃1↓⍵
     act←⊃2↓⍵
     exp≡act:'  PASS: ',nm
     '**FAIL: ',nm,' — expected: ',(⍕exp),' — got: ',(⍕act)
 }
 IsPass←{'PASS'≡4↑2↓⍵}
⍝ ── 1. Construction ──────────────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz
     rep,←⊂Chk(⊂'New empty = 0')(⊂'0')(⊂(⌷c))
     c←⎕NEW gmpz ¯2
     rep,←⊂Chk(⊂'New from APL int ¯2')(⊂'¯2')(⊂(⌷c))
     c←⎕NEW gmpz'1234567 89012345678'
     rep,←⊂Chk(⊂'New from string, blanks ok')(⊂'123456789012345678')(⊂(⌷c))
     c←⎕NEW gmpz'¯42'
     rep,←⊂Chk(⊂'New from string, ¯ as minus')(⊂'¯42')(⊂(⌷c))
     c←⎕NEW gmpz('beef cafe' 16)
     rep,←⊂Chk(⊂'New from string in base 16, blanks ok')(⊂'3203386110')(⊂(⌷c))
     c←⎕NEW gmpz('ff' 16)
     rep,←⊂Chk(⊂'New (ff 16) = 255')(⊂'255')(⊂(⌷c))
     c←⎕NEW gmpz'123456789012345678901234567890'
     rep,←⊂Chk(⊂'New from 30-digit string')(⊂'123456789012345678901234567890')(⊂(⌷c))
 :Else
     rep,←⊂'**FAIL: Construction section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 2. New0 / New / Set ──────────────────────────────────────────
 :Trap 0
     c←gmpz.New0
     rep,←⊂Chk(⊂'gmpz.New0 = 0')(⊂'0')(⊂(⌷c))
     c←gmpz.New'999999999'
     rep,←⊂Chk(⊂'gmpz.New string')(⊂'999999999')(⊂(⌷c))
     c←16 gmpz.New'ff'
     rep,←⊂Chk(⊂'16 gmpz.New ff = 255')(⊂'255')(⊂(⌷c))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Set APL int, chained Inc')(⊂'6')(⊂(⌷((c.Set 5).Inc)))
     c←⎕NEW gmpz 0
     16 c.Set'beef cafe'
     rep,←⊂Chk(⊂'16 Set beef cafe')(⊂'3203386110')(⊂(⌷c))
     a←⎕NEW gmpz 77
     c←⎕NEW gmpz 0
     c.Set a
     rep,←⊂Chk(⊂'Set from another gmpz')(⊂'77')(⊂(⌷c))
     rep,←⊂Chk(⊂'Set source unchanged')(⊂'77')(⊂(⌷a))
     x←⎕NEW gmpz 5
     rep,←⊂Chk(⊂'Set to self returns self, value kept')(⊂'5')(⊂(⌷(x.Set x)))
 :Else
     rep,←⊂'**FAIL: New0 / New / Set section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 3. ⌷ / ptr / Int / VFI ───────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 123
     rep,←⊂Chk(⊂'⌷ 123')(⊂'123')(⊂(⌷c))
     rep,←⊂Chk(⊂'ptr is a live address (>0)')(⊂1)(⊂(0<c.ptr))
    rep,←⊂Chk(⊂'Int 123')(⊂123)(⊂(c.Int))          ⍝ ¯9223372036854775806
     c←⎕NEW gmpz ¯922337203685477600
    rep,←⊂Chk(⊂'Int most-negative-ish fits')(⊂¯922337203685477600)(⊂(c.Int))
     c←⎕NEW gmpz'123456789012345678901234567890'
     rep,←⊂Chk(⊂'VFI huge number = 0 0')(⊂0 0)(⊂(c.VFI))
     c←⎕NEW gmpz 42
     rep,←⊂Chk(⊂'VFI 42 = 1 42')(⊂1 42)(⊂(c.VFI))
 :Else
     rep,←⊂'**FAIL: ⌷ / ptr / Int / VFI section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 4. GetInBase / StrLen / Len ──────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 255
     rep,←⊂Chk(⊂'GetInBase 16 of 255')(⊂'ff')(⊂(c.GetInBase 16))
     rep,←⊂Chk(⊂'GetInBase 2 of 255')(⊂'11111111')(⊂(c.GetInBase 2))
     c←⎕NEW gmpz ¯5
     rep,←⊂Chk(⊂'GetInBase 2 of ¯5')(⊂'¯101')(⊂(c.GetInBase 2))
     c←⎕NEW gmpz 255
     rep,←⊂Chk(⊂'GetInBase 62 of 255')(⊂'47')(⊂(c.GetInBase 62))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'StrLen 0 = 1')(⊂1)(⊂(c.StrLen))
     rep,←⊂Chk(⊂'Len 0 = 1')(⊂1)(⊂(c.Len))
     c←⎕NEW gmpz ¯123
     rep,←⊂Chk(⊂'StrLen ¯123 = 4 (sign counts)')(⊂4)(⊂(c.StrLen))
     rep,←⊂Chk(⊂'StrLen = ≢⌷ for ¯123')(⊂(≢⌷c))(⊂(c.StrLen))
     c←⎕NEW gmpz 8
     rep,←⊂Chk(⊂'Len 8 = 4')(⊂4)(⊂(c.Len))
     c←⎕NEW gmpz ¯8
     rep,←⊂Chk(⊂'Len ¯8 = 4 (sign adds no bit)')(⊂4)(⊂(c.Len))
     c←⎕NEW gmpz 7
     rep,←⊂Chk(⊂'Len 7 = 3')(⊂3)(⊂(c.Len))
     c←⎕NEW gmpz'123456789012345678901234567890'
     rep,←⊂Chk(⊂'StrLen 30-digit = 30')(⊂30)(⊂(c.StrLen))
     rep,←⊂Chk(⊂'StrLen = ≢⌷ for 30-digit')(⊂(≢⌷c))(⊂(c.StrLen))
 :Else
     rep,←⊂'**FAIL: GetInBase / StrLen / Len section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 5. Signum / Even / Odd / Inc / Dec ───────────────────────────
 :Trap 0
     c←⎕NEW gmpz ¯5
     rep,←⊂Chk(⊂'Signum ¯5')(⊂¯1)(⊂(c.Signum))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Signum 0')(⊂0)(⊂(c.Signum))
     c←⎕NEW gmpz 5
     rep,←⊂Chk(⊂'Signum 5')(⊂1)(⊂(c.Signum))
     c←⎕NEW gmpz 10
     rep,←⊂Chk(⊂'Even 10')(⊂1)(⊂(c.Even))
     rep,←⊂Chk(⊂'Odd 10')(⊂0)(⊂(c.Odd))
     c←⎕NEW gmpz 11
     rep,←⊂Chk(⊂'Even 11')(⊂0)(⊂(c.Even))
     rep,←⊂Chk(⊂'Odd 11')(⊂1)(⊂(c.Odd))
     c←⎕NEW gmpz 5
     rep,←⊂Chk(⊂'Inc 5')(⊂'6')(⊂(⌷(c.Inc)))
     rep,←⊂Chk(⊂'Dec 6')(⊂'5')(⊂(⌷(c.Dec)))
 :Else
     rep,←⊂'**FAIL: Signum / Even / Odd / Inc / Dec section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 6. Add / Sub / Mul (incl. big numbers, in-place, left operand) ─
 :Trap 0
     c←⎕NEW gmpz 12
     rep,←⊂Chk(⊂'Add 12+30')(⊂'42')(⊂(⌷(c.Add 30)))
     c←⎕NEW gmpz 12
     rep,←⊂Chk(⊂'Add string operand')(⊂'42')(⊂(⌷(c.Add'30')))
     c←⎕NEW gmpz 12
     rep,←⊂Chk(⊂'Add gmpz operand')(⊂'42')(⊂(⌷(c.Add(⎕NEW gmpz 30))))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Left operand: 10 c.Add 32')(⊂'42')(⊂(⌷(10 c.Add 32)))
     c←⎕NEW gmpz 50
     rep,←⊂Chk(⊂'Sub 50-8')(⊂'42')(⊂(⌷(c.Sub 8)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Sub negative result')(⊂'¯42')(⊂(⌷(8 c.Sub 50)))
     c←⎕NEW gmpz 6
     rep,←⊂Chk(⊂'Mul 6x7')(⊂'42')(⊂(⌷(c.Mul 7)))
     c←⎕NEW gmpz'12345678901234567890'
     rep,←⊂Chk(⊂'Big Add')(⊂'111111111011111111100')(⊂(⌷(c.Add'98765432109876543210')))
     c←⎕NEW gmpz 123456789
     rep,←⊂Chk(⊂'Big Mul 123456789x987654321')(⊂'121932631112635269')(⊂(⌷(c.Mul 987654321)))
     c←⎕NEW gmpz 42
     a←⎕NEW gmpz 10
     c.Add a
     rep,←⊂Chk(⊂'In-place: receiver changed, operand unchanged')(⊂'10')(⊂(⌷a))
     rep,←⊂Chk(⊂'In-place: receiver is 52')(⊂'52')(⊂(⌷c))
 :Else
     rep,←⊂'**FAIL: Add / Sub / Mul section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 7. Div / DivRem — floored ────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Div ¯7÷2 floored = ¯4')(⊂'¯4')(⊂(⌷(¯7 c.Div 2)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Div 7÷¯2 floored = ¯4')(⊂'¯4')(⊂(⌷(7 c.Div ¯2)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Div 7÷2 = 3')(⊂'3')(⊂(⌷(7 c.Div 2)))
     c←⎕NEW gmpz 0
     rem←¯7 c.DivRem 2
     rep,←⊂Chk(⊂'DivRem ¯7÷2 quotient = ¯4')(⊂'¯4')(⊂(⌷c))
     rep,←⊂Chk(⊂'DivRem ¯7÷2 remainder is a gmpz = 1')(⊂'1')(⊂(⌷rem))
     c←⎕NEW gmpz 0
     rem←7 c.DivRem 2
     rep,←⊂Chk(⊂'DivRem 7÷2 quotient = 3')(⊂'3')(⊂(⌷c))
     rep,←⊂Chk(⊂'DivRem 7÷2 remainder = 1')(⊂'1')(⊂(⌷rem))
⍝ Identity check, done properly: q←¯7÷2 floored, r←¯7|2, then 2×q+r = ¯7
     c←⎕NEW gmpz 0
     rem←¯7 c.DivRem 2
     x←⎕NEW gmpz 0
     y←⎕NEW gmpz 0
     y.Set rem
     x.Set c
     x.Mul 2
     x.Add y
     rep,←⊂Chk(⊂'Div identity: 2×(¯7÷2) + (¯7|2) = ¯7')(⊂'¯7')(⊂(⌷x))
 :Else
     rep,←⊂'**FAIL: Div / DivRem section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 8. Gcd / Lcm ─────────────────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Gcd 12 18 = 6')(⊂'6')(⊂(⌷(12 c.Gcd 18)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Gcd ¯12 18 = 6')(⊂'6')(⊂(⌷(¯12 c.Gcd 18)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Gcd 0 5 = 5')(⊂'5')(⊂(⌷(0 c.Gcd 5)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Lcm 12 18 = 36')(⊂'36')(⊂(⌷(12 c.Lcm 18)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Lcm 0 5 = 0')(⊂'0')(⊂(⌷(0 c.Lcm 5)))
 :Else
     rep,←⊂'**FAIL: Gcd / Lcm section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 9. Pow / PowM / roots ────────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 2
     rep,←⊂Chk(⊂'Pow 2*10 = 1024')(⊂'1024')(⊂(⌷(c.Pow 10)))
     c←⎕NEW gmpz 2
     rep,←⊂Chk(⊂'Pow 2*64')(⊂'18446744073709551616')(⊂(⌷(c.Pow 64)))
     c←⎕NEW gmpz 2
     rep,←⊂Chk(⊂'Pow 2*0 = 1')(⊂'1')(⊂(⌷(c.Pow 0)))
     c←⎕NEW gmpz 27
     rep,←⊂Chk(⊂'Pow cube root 27 = 3')(⊂'3')(⊂(⌷(c.Pow÷3)))
     c←⎕NEW gmpz 16
     rep,←⊂Chk(⊂'Pow square root 16 = 4')(⊂'4')(⊂(⌷(c.Pow÷2)))
     c←⎕NEW gmpz ¯27
     rep,←⊂Chk(⊂'Pow cube root ¯27 = ¯3 (odd root, truncating)')(⊂'¯3')(⊂(⌷(c.Pow÷3)))
     c←⎕NEW gmpz 10
     rep,←⊂Chk(⊂'Pow cube root 10 truncates to 2')(⊂'2')(⊂(⌷(c.Pow÷3)))
     c←⎕NEW gmpz 2
     rep,←⊂Chk(⊂'PowM 2*10 mod 1000 = 24')(⊂'24')(⊂(⌷(c.PowM 10 1000)))
     c←⎕NEW gmpz 3
     rep,←⊂Chk(⊂'PowM 3*5 mod 7 = 5')(⊂'5')(⊂(⌷(c.PowM 5 7)))
 :Else
     rep,←⊂'**FAIL: Pow / PowM section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 10. Res / Invert ────────────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Res 7|¯2 = 5 (sign follows modulus)')(⊂'5')(⊂(⌷(7 c.Res ¯2)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Res 7|2 = 2')(⊂'2')(⊂(⌷(7 c.Res 2)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Res ¯7|2 = ¯5')(⊂'¯5')(⊂(⌷(¯7 c.Res 2)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Res 0|5 = 5 (APL 0|b is b)')(⊂'5')(⊂(⌷(0 c.Res 5)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Res mod 2, odd')(⊂'1')(⊂(⌷(2 c.Res 7)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Res mod 2, even')(⊂'0')(⊂(⌷(2 c.Res 8)))
     c←⎕NEW gmpz 3
     rc←c.Invert 11
     rep,←⊂Chk(⊂'Invert 3 mod 11 returns 1')(⊂1)(⊂rc)
     rep,←⊂Chk(⊂'Invert 3 mod 11 = 4')(⊂'4')(⊂(⌷c))
     c←⎕NEW gmpz 2
     rc←c.Invert 4
     rep,←⊂Chk(⊂'Invert 2 mod 4 has no inverse, returns 0')(⊂0)(⊂rc)
 :Else
     rep,←⊂'**FAIL: Res / Invert section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 11. Shift ────────────────────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Shift left 1<<3 = 6')(⊂'6')(⊂(⌷(1 c.Shift 3)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Shift left 3<<1 = 8')(⊂'8')(⊂(⌷(3 c.Shift 1)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Shift right ¯1>>7 = 3')(⊂'3')(⊂(⌷(¯1 c.Shift 7)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Shift right ¯1>>¯7 = ¯3 (truncates, not floored)')(⊂'¯3')(⊂(⌷(¯1 c.Shift ¯7)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Shift right ¯3>>¯7 = 0 (truncates)')(⊂'0')(⊂(⌷(¯3 c.Shift ¯7)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Shift 0 leaves value')(⊂'7')(⊂(⌷(0 c.Shift 7)))
 :Else
     rep,←⊂'**FAIL: Shift section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 12. TestBit / SetBit / ClrBit / Flip ─────────────────────────
 :Trap 0
     c←⎕NEW gmpz 10
     rep,←⊂Chk(⊂'TestBit 1 of 10 = 1')(⊂1)(⊂(c.TestBit 1))
     rep,←⊂Chk(⊂'TestBit 0 of 10 = 0')(⊂0)(⊂(c.TestBit 0))
     rep,←⊂Chk(⊂'TestBit 3 of 10 = 1')(⊂1)(⊂(c.TestBit 3))
     c←⎕NEW gmpz 10
     v←c.SetBit 0
     rep,←⊂Chk(⊂'SetBit 0 returns 1')(⊂1)(⊂v)
     rep,←⊂Chk(⊂'SetBit 0: 10 becomes 11')(⊂'11')(⊂(⌷c))
     c←⎕NEW gmpz 10
     v←c.SetBit 1 0
     rep,←⊂Chk(⊂'SetBit 1 0 returns 0')(⊂0)(⊂v)
     rep,←⊂Chk(⊂'SetBit 1 0: 10 becomes 8')(⊂'8')(⊂(⌷c))
     c←⎕NEW gmpz 10
     v←c.ClrBit 1
     rep,←⊂Chk(⊂'ClrBit 1 returns 0')(⊂0)(⊂v)
     rep,←⊂Chk(⊂'ClrBit 1: 10 becomes 8')(⊂'8')(⊂(⌷c))
     c←⎕NEW gmpz 10
     v←c.Flip 0
     rep,←⊂Chk(⊂'Flip 0 returns new bit 1')(⊂1)(⊂v)
     rep,←⊂Chk(⊂'Flip 0: 10 becomes 11')(⊂'11')(⊂(⌷c))
     c←⎕NEW gmpz 10
     v←c.Flip 1
     rep,←⊂Chk(⊂'Flip 1 returns new bit 0')(⊂0)(⊂v)
     rep,←⊂Chk(⊂'Flip 1: 10 becomes 8')(⊂'8')(⊂(⌷c))
 :Else
     rep,←⊂'**FAIL: TestBit / SetBit / ClrBit / Flip section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 13. Scan / Iota (⎕IO←0) ─────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 10
     rep,←⊂Chk(⊂'Iota 1 of 10 = 1 (first 1-bit, 0-origin)')(⊂1)(⊂(c.Iota 1))
     rep,←⊂Chk(⊂'Iota 0 of 10 = 0 (first 0-bit)')(⊂0)(⊂(c.Iota 0))
     rep,←⊂Chk(⊂'Scan (2 1) of 10 = 3')(⊂3)(⊂(c.Scan 2 1))
     rep,←⊂Chk(⊂'Scan (2 0) of 10 = 2')(⊂2)(⊂(c.Scan 2 0))
     rep,←⊂Chk(⊂'Scan (0 1) of 10 = 1')(⊂1)(⊂(c.Scan 0 1))
     c←⎕NEW gmpz 8
     rep,←⊂Chk(⊂'Iota 1 of 8 = 3')(⊂3)(⊂(c.Iota 1))
     rep,←⊂Chk(⊂'Iota 0 of 8 = 0')(⊂0)(⊂(c.Iota 0))
 :Else
     rep,←⊂'**FAIL: Scan / Iota section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 14. And / Or / Xor / Neg / Abs / Divisible ───────────────────
 :Trap 0
     c←⎕NEW gmpz 12
     rep,←⊂Chk(⊂'And 12∧10 = 8')(⊂'8')(⊂(⌷(c.And 10)))
     c←⎕NEW gmpz 12
     rep,←⊂Chk(⊂'Or 12∨10 = 14')(⊂'14')(⊂(⌷(c.Or 10)))
     c←⎕NEW gmpz 12
     rep,←⊂Chk(⊂'Xor 12≠10 = 6')(⊂'6')(⊂(⌷(c.Xor 10)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Neg 5 = ¯5')(⊂'¯5')(⊂(⌷(c.Neg 5)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Neg ¯5 = 5')(⊂'5')(⊂(⌷(c.Neg ¯5)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Abs ¯5 = 5')(⊂'5')(⊂(⌷(c.Abs ¯5)))
     c←⎕NEW gmpz 10
     rep,←⊂Chk(⊂'Divisible 10 by 2')(⊂1)(⊂(c.Divisible 2))
     rep,←⊂Chk(⊂'Divisible 10 by 3 = 0')(⊂0)(⊂(c.Divisible 3))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Divisible 0 by 0 = 1')(⊂1)(⊂(c.Divisible 0))
 :Else
     rep,←⊂'**FAIL: And / Or / Xor / Neg / Abs / Divisible section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 15. Bit property (⎕IO←0) ────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 10
     rep,←⊂Chk(⊂'Bit[1] of 10 = 1')(⊂1)(⊂(c.Bit[1]))
     rep,←⊂Chk(⊂'Bit[0] of 10 = 0')(⊂0)(⊂(c.Bit[0]))
     rep,←⊂Chk(⊂'Bit[0 2 3] of 10 = 0 0 1')(⊂0 0 1)(⊂(c.Bit[0 2 3]))
     c←⎕NEW gmpz 10
     c.Bit[0]←1
     rep,←⊂Chk(⊂'Bit[0]←1: 10 becomes 11')(⊂'11')(⊂(⌷c))
     c←⎕NEW gmpz 10
     c.Bit[1 3]←0 0
     rep,←⊂Chk(⊂'Bit[1 3]←0 0: 10 becomes 0')(⊂'0')(⊂(⌷c))
 :Else
     rep,←⊂'**FAIL: Bit property section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 16. Bits ─────────────────────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 10
     rep,←⊂Chk(⊂'Bits 10 = 1 0 1 0')(⊂1 0 1 0)(⊂(c.Bits))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Bits 0 = 0')(⊂0)(⊂(c.Bits))
     c←⎕NEW gmpz 255
     rep,←⊂Chk(⊂'Bits 255 = eight 1s')(⊂8⍴1)(⊂(c.Bits))
     c←⎕NEW gmpz 8
     rep,←⊂Chk(⊂'Bits 8 = 1 0 0 0, ≢Bits = Len')(⊂(c.Len))(⊂(≢c.Bits))
 :Else
     rep,←⊂'**FAIL: Bits section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 17. Fac ──────────────────────────────────────────────────────
 :Trap 0
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Fac 0 = 1')(⊂'1')(⊂(⌷(c.Fac 0)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Fac 5 = 120')(⊂'120')(⊂(⌷(c.Fac 5)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Fac 20')(⊂'2432902008176640000')(⊂(⌷(c.Fac 20)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'Fac string 5 = 120')(⊂'120')(⊂(⌷(c.Fac'5')))
 :Else
     rep,←⊂'**FAIL: Fac section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 18. Cmp / Lt / Le / Eq / Ne / Ge / Gt ────────────────────────
 :Trap 0
     c←⎕NEW gmpz 5
     rep,←⊂Chk(⊂'Cmp 5 vs 3 = 1')(⊂1)(⊂(c.Cmp 3))
     rep,←⊂Chk(⊂'Cmp 5 vs 5 = 0')(⊂0)(⊂(c.Cmp 5))
     rep,←⊂Chk(⊂'Cmp 5 vs 7 = ¯1')(⊂¯1)(⊂(c.Cmp 7))
     rep,←⊂Chk(⊂'Lt 5<7')(⊂1)(⊂(c.Lt 7))
     rep,←⊂Chk(⊂'Lt 5<5 = 0')(⊂0)(⊂(c.Lt 5))
     rep,←⊂Chk(⊂'Le 5≤5')(⊂1)(⊂(c.Le 5))
     rep,←⊂Chk(⊂'Eq 5=5')(⊂1)(⊂(c.Eq 5))
     rep,←⊂Chk(⊂'Eq 5=7 = 0')(⊂0)(⊂(c.Eq 7))
     rep,←⊂Chk(⊂'Ne 5≠7')(⊂1)(⊂(c.Ne 7))
     rep,←⊂Chk(⊂'Ge 5≥5')(⊂1)(⊂(c.Ge 5))
     rep,←⊂Chk(⊂'Gt 5>3')(⊂1)(⊂(c.Gt 3))
     c←⎕NEW gmpz'123456789012345678901234567890'
     rep,←⊂Chk(⊂'Cmp big vs string, equal')(⊂0)(⊂(c.Cmp'123456789012345678901234567890'))
     rep,←⊂Chk(⊂'Cmp big vs smaller')(⊂1)(⊂(c.Cmp'1'))
 :Else
     rep,←⊂'**FAIL: Comparison section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 19. Rand / RandB / RandSeed ──────────────────────────────────
 :Trap 0
     old←gmpz.RandSeed 42
     a←⎕NEW gmpz 0
     v1←(a.Rand 1000000).Int
     old←gmpz.RandSeed 42
     rep,←⊂Chk(⊂'RandSeed 42 again returns old seed 42')(⊂'42')(⊂old)
     b←⎕NEW gmpz 0
     v2←(b.Rand 1000000).Int
     rep,←⊂Chk(⊂'Rand deterministic: same seed, same draw')(⊂v1)(⊂v2)
     ok←1
     :For i :In ⍳20
         v←(a.Rand 10).Int
         ok←ok∧(0≤v)∧(v<10)
     :EndFor
     rep,←⊂Chk(⊂'Rand 10: 20 draws all in 0..9 (⎕IO←0)')(⊂1)(⊂ok)
     ok←1
     :For i :In ⍳20
         v←(a.RandB 8).Int
         ok←ok∧(0≤v)∧(v<256)
     :EndFor
     rep,←⊂Chk(⊂'RandB 8: 20 draws all in 0..255 (⎕IO←0)')(⊂1)(⊂ok)
     a←⎕NEW gmpz 0
     v←(a.RandB 0).Int
     rep,←⊂Chk(⊂'RandB 0 = 0')(⊂0)(⊂v)
 :Else
     rep,←⊂'**FAIL: Rand / RandB / RandSeed section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 20. ProbabPrime / NextPrime / PrevPrime / PrevPrime2 / Jacobi ─
 :Trap 0
     c←⎕NEW gmpz 97
     rep,←⊂Chk(⊂'ProbabPrime 97 = 2 (definitely prime)')(⊂2)(⊂(c.ProbabPrime 24))
     c←⎕NEW gmpz 100
     rep,←⊂Chk(⊂'ProbabPrime 100 = 0 (not prime)')(⊂0)(⊂(c.ProbabPrime 24))
     c←⎕NEW gmpz 97
     rep,←⊂Chk(⊂'ProbabPrime 0 reps = default, 97 = 2')(⊂2)(⊂(c.ProbabPrime 0))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'NextPrime 10 = 11')(⊂'11')(⊂(⌷(c.NextPrime 10)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'NextPrime 2 = 3')(⊂'3')(⊂(⌷(c.NextPrime 2)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'PrevPrime 10 = 7')(⊂'7')(⊂(⌷(c.PrevPrime 10)))
     c←⎕NEW gmpz 0
     rep,←⊂Chk(⊂'PrevPrime 3 = 2')(⊂'2')(⊂(⌷(c.PrevPrime 3)))
     c←⎕NEW gmpz 0
     pp←c.PrevPrime2 10
     rep,←⊂Chk(⊂'PrevPrime2 10 prime = 7')(⊂'7')(⊂(⌷⊃pp))
     rep,←⊂Chk(⊂'PrevPrime2 10 certainty = 2')(⊂2)(⊂(1⊃pp))
     c←⎕NEW gmpz 2
     rep,←⊂Chk(⊂'Jacobi (2/7) = 1')(⊂1)(⊂(c.Jacobi 7))
     c←⎕NEW gmpz 3
     rep,←⊂Chk(⊂'Jacobi (3/7) = ¯1')(⊂¯1)(⊂(c.Jacobi 7))
     c←⎕NEW gmpz 7
     rep,←⊂Chk(⊂'Jacobi (7/7) = 0')(⊂0)(⊂(c.Jacobi 7))
 :Else
     rep,←⊂'**FAIL: Prime / Jacobi section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 21. GI dyadic arithmetic ─────────────────────────────────────
 :Trap 0
     rep,←⊂Chk(⊂'GI 5+3')(⊂'8')(⊂(⌷(5+GI 3)))
     rep,←⊂Chk(⊂'GI 5-3')(⊂'2')(⊂(⌷(5-GI 3)))
     rep,←⊂Chk(⊂'GI 5×3')(⊂'15')(⊂(⌷(5×GI 3)))
     rep,←⊂Chk(⊂'GI ¯7÷2 floored')(⊂'¯4')(⊂(⌷(¯7÷GI 2)))
     rep,←⊂Chk(⊂'GI 2*10')(⊂'1024')(⊂(⌷(2*GI 10)))
     rep,←⊂Chk(⊂'GI 27*÷3 root')(⊂'3')(⊂(⌷(27*GI÷3)))
     rep,←⊂Chk(⊂'GI 12∨18 gcd')(⊂'6')(⊂(⌷(12∨GI 18)))
     rep,←⊂Chk(⊂'GI 12∧18 lcm')(⊂'36')(⊂(⌷(12∧GI 18)))
     rep,←⊂Chk(⊂'GI 7|¯2 residue')(⊂'5')(⊂(⌷(7|GI ¯2)))
     rep,←⊂Chk(⊂'GI 1⌽3 shift left')(⊂'6')(⊂(⌷(1⌽GI 3)))
     rep,←⊂Chk(⊂'GI ¯1⌽7 shift right')(⊂'3')(⊂(⌷(¯1⌽GI 7)))
     rep,←⊂Chk(⊂'GI 16⊥ff base')(⊂'255')(⊂(⌷(16⊥GI'ff')))
     rep,←⊂Chk(⊂'GI big: string + string')(⊂'111111111011111111100')(⊂(⌷('12345678901234567890'+GI'98765432109876543210')))
 :Else
     rep,←⊂'**FAIL: GI dyadic arithmetic section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 22. GI comparisons / DivRem / PowM / Iota / Bit ──────────────
 :Trap 0
     rep,←⊂Chk(⊂'GI 5<7')(⊂1)(⊂(5<GI 7))
     rep,←⊂Chk(⊂'GI 5≤5')(⊂1)(⊂(5≤GI 5))
     rep,←⊂Chk(⊂'GI 5=5')(⊂1)(⊂(5=GI 5))
     rep,←⊂Chk(⊂'GI 5≠7')(⊂1)(⊂(5≠GI 7))
     rep,←⊂Chk(⊂'GI 5≥5')(⊂1)(⊂(5≥GI 5))
     rep,←⊂Chk(⊂'GI 5>3')(⊂1)(⊂(5>GI 3))
     rep,←⊂Chk(⊂'GI 5>7 = 0')(⊂0)(⊂(5>GI 7))
     pp←7(÷∘|GI)2
     rep,←⊂Chk(⊂'GI ÷∘| 7÷2 quotient')(⊂'3')(⊂(⌷⊃pp))
     rep,←⊂Chk(⊂'GI ÷∘| 7÷2 remainder')(⊂'1')(⊂(⌷1⊃pp))
     rep,←⊂Chk(⊂'GI *∘| 2*10 mod 1000')(⊂'24')(⊂(⌷(2(*∘|GI)(10 1000))))
     rep,←⊂Chk(⊂'GI 10⍳1 first 1-bit')(⊂1)(⊂(10⍳GI 1))
     rep,←⊂Chk(⊂'GI 1⌷10 bit 1 of 10')(⊂1)(⊂(1⌷GI 10))
     rep,←⊂Chk(⊂'GI 0⌷10 bit 0 of 10')(⊂0)(⊂(0⌷GI 10))
 :Else
     rep,←⊂'**FAIL: GI comparisons / DivRem / PowM / Iota / Bit section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 23. GI monadic ───────────────────────────────────────────────
 :Trap 0
     rep,←⊂Chk(⊂'GI -5 negate')(⊂'¯5')(⊂(⌷(-GI 5)))
     rep,←⊂Chk(⊂'GI |¯5 abs')(⊂'5')(⊂(⌷(|GI ¯5)))
     rep,←⊂Chk(⊂'GI ×¯5 sign')(⊂¯1)(⊂(×GI ¯5))
     rep,←⊂Chk(⊂'GI ×0 sign')(⊂0)(⊂(×GI 0))
     rep,←⊂Chk(⊂'GI !5 factorial')(⊂'120')(⊂(⌷(!GI 5)))
     rep,←⊂Chk(⊂'GI <5 decrement')(⊂'4')(⊂(⌷(<GI 5)))
     rep,←⊂Chk(⊂'GI >5 increment')(⊂'6')(⊂(⌷(>GI 5)))
     rep,←⊂Chk(⊂'GI ≢12345 StrLen')(⊂5)(⊂(≢GI'12345'))
     rep,←⊂Chk(⊂'GI ⍎123 Int')(⊂123)(⊂(⍎GI'123'))
     rep,←⊂Chk(⊂'GI ⌷123 string')(⊂'123')(⊂(⌷GI 123))
    rep,←⊂Chk(⊂'GI ⊥123 fresh gmpz')(⊂'123')((⊂⌷(⊥GI'123')))
     ok←1
     :For i :In ⍳20
         v←((?GI 10).Int)
         ok←ok∧(0≤v)∧(v<10)
     :EndFor
     rep,←⊂Chk(⊂'GI ?10: 20 draws all in 0..9 (⎕IO←0)')(⊂1)(⊂ok)
 :Else
     rep,←⊂'**FAIL: GI monadic section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── 24. GI does not modify its arguments; unknown glyph ──────────
 :Trap 0
     a←⎕NEW gmpz 5
     b←⎕NEW gmpz 3
     z←a+GI b
     rep,←⊂Chk(⊂'GI result 5+3')(⊂'8')(⊂(⌷z))
     rep,←⊂Chk(⊂'GI left argument unchanged')(⊂'5')(⊂(⌷a))
     rep,←⊂Chk(⊂'GI right argument unchanged')(⊂'3')(⊂(⌷b))
     a←⎕NEW gmpz 5
     z←-GI a
     rep,←⊂Chk(⊂'GI monadic result -5')(⊂'¯5')(⊂(⌷z))
     rep,←⊂Chk(⊂'GI monadic argument unchanged')(⊂'5')(⊂(⌷a))
 :Else
     rep,←⊂'**FAIL: GI no-modify section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
 err←¯1
 :Trap 0
     z←⍴GI 5
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'GI unknown glyph ⍴ signals EN 11 (unknownÊ)')(⊂11)(⊂err)
⍝ ── 25. Error paths — each call is trapped, EN is compared ───────
⍝ Div / DivRem by zero
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 5
     c.Div 0
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Div by 0 → divZÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 5
     rem←c.DivRem 0
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'DivRem by 0 → divZÊ EN 11')(⊂11)(⊂err)
⍝ Rand with non-positive bound
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 0
     c.Rand 0
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Rand 0 → randÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 0
     c.RandB ¯1
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'RandB ¯1 → randÊ EN 11')(⊂11)(⊂err)
⍝ Set with a non-integer / invalid string
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 0
     c.Set 1.5
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Set 1.5 → badAplÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 0
     c.Set'12x'
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Set invalid string → badObjÊ EN 11')(⊂11)(⊂err)
⍝ Int overflow
 err←¯1
 :Trap 0
     c←⎕NEW gmpz'9223372036854775808'
     v←c.Int
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Int 2*63 → badIntÊ EN 11')(⊂11)(⊂err)
⍝ Pow errors
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 2
     c.Pow ¯1
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Pow negative exponent → powÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz ¯16
     c.Pow÷2
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Pow even root of negative → powÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 2
     c.PowM ¯1 100
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'PowM negative exponent → powÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 2
     c.PowM 2 0
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'PowM modulus 0 → divZÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 2
     c.PowM 2 ¯5
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'PowM negative modulus → powÊ EN 11')(⊂11)(⊂err)
⍝ Factorial errors
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 0
     c.Fac ¯1
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Fac ¯1 → facBadÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 0
    c.Fac 2*70 40⊃⍨'Windows'≡7↑⊃'.'⎕WG'APLVersion'  ⍝ Different limit for microsoft!

 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Fac 2*32 → facBadÊ EN 11')(⊂11)(⊂err)
⍝ Bit errors
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 10
     v←c.TestBit ¯1
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'TestBit ¯1 → badBitIxÊ EN 3')(⊂3)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 10
     v←c.SetBit 1 2
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'SetBit value 2 → badBitValÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz ¯5
     v←c.Bits
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Bits of negative → badObjÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 10
     v←c.Bit[¯1]
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Bit[¯1] → badBitIxÊ EN 3')(⊂3)(⊂err)
⍝ Other domain errors
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 255
     v←c.GetInBase 1
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'GetInBase 1 → badAplÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 255
     v←c.GetInBase 63
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'GetInBase 63 → badAplÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 2
     v←c.Jacobi 6
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Jacobi even modulus → badAplÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 97
     v←c.ProbabPrime ¯1
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'ProbabPrime ¯1 → primeÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     old←gmpz.RandSeed ¯1
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'RandSeed ¯1 → randSeedÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 0
     c.Invert 0
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Invert modulus 0 → divZÊ EN 11')(⊂11)(⊂err)
 err←¯1
 :Trap 0
     c←⎕NEW gmpz 0
     v←1.5 c.Shift 7
 :Else
     err←⎕DMX.EN
 :EndTrap
 rep,←⊂Chk(⊂'Shift 1.5 (non-integer shift) → shiftÊ EN 11')(⊂11)(⊂err)
⍝ ── 26. ⎕IO←1 — Bit / Iota / Scan / Rand (known-issue area) ─────
⍝    These are reported like any other check.  If they FAIL, that is
⍝    the Bit / Bits ⎕IO handling Pete already knows about and has
⍝    left as-is for now — do not treat a FAIL here as a new bug
⍝    without checking it against that decision.
 ⎕IO←1
 :Trap 0
     c←⎕NEW gmpz 10
     rep,←⊂Chk(⊂'IO=1 Bit[2] of 10 = 1')(⊂1)(⊂(c.Bit[2]))
     rep,←⊂Chk(⊂'IO=1 Bit[1] of 10 = 0')(⊂0)(⊂(c.Bit[1]))
     rep,←⊂Chk(⊂'IO=1 Iota 1 of 10 = 2')(⊂2)(⊂(c.Iota 1))
     rep,←⊂Chk(⊂'IO=1 Iota 0 of 10 = 1')(⊂1)(⊂(c.Iota 0))
     rep,←⊂Chk(⊂'IO=1 Scan (2 1) of 10 = 2')(⊂2)(⊂(c.Scan 2 1))
     ok←1
     :For i :In ⍳20
         v←(c.Rand 10).Int
         ok←ok∧(1≤v)∧(v≤10)
     :EndFor
     rep,←⊂Chk(⊂'IO=1 Rand 10: 20 draws all in 1..10')(⊂1)(⊂ok)
     ok←1
     :For i :In ⍳20
         v←(c.RandB 8).Int
         ok←ok∧(1≤v)∧(v≤256)
     :EndFor
     rep,←⊂Chk(⊂'IO=1 RandB 8: 20 draws all in 1..256')(⊂1)(⊂ok)
     ⎕IO←0
 :Else
     ⎕IO←0
     rep,←⊂'**FAIL: ⎕IO←1 section — unexpected error EN ',(⍕⎕DMX.EN),' Message: ',⎕DMX.Message
 :EndTrap
⍝ ── Summary ──────────────────────────────────────────────────────
 total←≢rep
 pass←+/IsPass¨rep
 fail←total-pass
 ⎕←'gmpz test: ',(⍕pass),' passed, ',(⍕fail),' failed, out of ',(⍕total),' checks.'
 :For line :In rep
     ⎕←line
 :EndFor
 ⎕←'gmpz test: ',(⍕pass),' passed, ',(⍕fail),' failed, out of ',(⍕total),' checks.'
 r←pass fail total
