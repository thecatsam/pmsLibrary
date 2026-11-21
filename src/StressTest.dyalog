 r←StressTest;mk;toStr;vals;s;a;b;bits;orig;flipped;expected
⎕IO←0
⍝ Adjust these two helpers if your constructor / string method uses different names:
mk←{⎕NEW gmpz(,⍕⍵)}
toStr←⌷    ⍝ Normalizes '¯' -> '-' if ⍕ returns APL high-minus
vals←'0' '1' '-1' '2' '-2' '3' '-3' '4' '-4' '5' '-5'
vals,←'2147483647' '2147483648' '-2147483648' '-2147483649'          ⍝ 2^31 boundary
vals,←'4294967295' '4294967296' '-4294967296' '-4294967297'          ⍝ 2^32 limb boundary
vals,←'18446744073709551615' '18446744073709551616'                  ⍝ 2^64 - 1, 2^64
vals,←'-18446744073709551616' '-18446744073709551617'                ⍝ -2^64, -2^64 - 1
vals,←'1152921504606846977' '-1152921504606846977'                   ⍝ ±(2^60 + 1): >53-bit precision
vals,←'99999999999999999999999999999' '100000000000000000000000000000' ⍝ 10^29 - 1, 10^29
vals,←⊂'-100000000000000000000000000000'                              ⍝ -10^29
:For s :In vals
a←mk s
⍝ 1. BitLen & Bits length invariant
bits←a.Bits
:If (≢bits)≠a.BitLen
r←'FAIL BitLen mismatch on: ',s ⋄ :Return
:EndIf
⍝ 2. Leading bit of Bits must match sign
:If (⊃bits)≠('-'=⊃s)
r←'FAIL Sign bit mismatch on: ',s ⋄ :Return
:EndIf
⍝ 3. Bit[⌽⍳BitLen] must equal Bits
:If bits≢a.Bit[⌽⍳a.BitLen]
r←'FAIL Bit vs Bits mismatch on: ',s ⋄ :Return
:EndIf
⍝ 4. Negative index invariant: a.Bit[¯1] must equal sign bit
:If (a.Bit[¯1])≠(⊃bits)
r←'FAIL Negative index a.Bit[¯1] on: ',s ⋄ :Return
:EndIf
⍝ 5. Round-trip ImportBits(ExportBits)
b←mk'0'
b.Bits←bits
:If (toStr a)≢(toStr b)
r←'FAIL Bits round-trip on: ',s,' got ',(toStr b) ⋄ :Return
:EndIf
⍝ 6. Sign-extended ExportBits (width = BitLen + 70, crossing 2+ limbs)
b.Bits←a.ExportBits(a.BitLen+70)
:If (toStr a)≢(toStr b)
r←'FAIL Sign-extended ExportBits on: ',s ⋄ :Return
:EndIf
⍝ 7. Sign-bit flip via a.Bit[last]←~a.Bit[last] MUST equal flipping MSB of a.Bits
orig←a.Bits
flipped←(~⊃orig),1↓orig
expected←mk'0'
expected.Bits←flipped
a.Bit[a.BitLen-1]←~⊃orig
:If (toStr a)≢(toStr expected)
r←'FAIL SetSignBit on: ',s,' expected ',(toStr expected),' got ',(toStr a) ⋄ :Return
:EndIf
⍝ 8. String length invariant (exercises ⍙StrLenInBase 10)
a←mk s
:If (≢toStr a)≠(≢s)
r←'FAIL StrLen on: ',s,' got ',(⍕≢toStr a),' vs ',(⍕≢s) ⋄ :Return
:EndIf
:EndFor
r←'ALL ',(⍕≢vals),' STRESS TESTS PASSED'
