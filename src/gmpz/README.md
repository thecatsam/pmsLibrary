## ***gmpz***: A Dyalog APL class with an APL-style helper operator *GI*

* Backed by GMP mpz calls (libgmp)  •  Nov 2026 Edition (2026-11-17)
* For Dyalog APL v20 or later (developed with v21) and GMP 6.3 or later. 
* [Tested on macOS; designed for macOS, Linux, and Windows]


## **0\. Setup**

```
]load gmpz/gmpz
⎕FR ⎕PP← 1287 34        ⍝  Optional. (See notes below).
```

* Dyalog APL v20 or later (64-bit) and the GMP shared library (libgmp).
* GMP 6.3 or later is required — PrevPrime uses mpz\_prevprime, which does not exist in earlier GMP versions, and the class binds all its routines on load (an older library fails with gmpLoadÊ).
* Inside the class, `⎕IO ⎕ML ⎕PP ⎕FR` are `0 1 34 1287`. 
* Set `⎕FR←1287` in your own session if you want to type 64-bit integers directly. Numeric literals of more than 16 digits are read using the ⎕FR in force when the code is fixed or entered, so for big constants in saved code, use strings.

## **1\.  Creating and reading values**

```
   a← ⎕NEW gmpz                         ⍝ 0
   a← ⎕NEW gmpz ¯2                      ⍝ from an APL integer
   a← ⎕NEW gmpz '1234567 89012345678'   ⍝ from a string ('¯' => '-'). Blanks ok!
   a← ⎕NEW gmpz ('bee cafe' 16)         ⍝ from a string in base 16 (base ∊ 2…62)
   a← ⎕NEW gmpz ('10101110' 2)          ⍝ from a string in base 2 (see also Bits).
   a← gmpz.New0                         ⍝ Alternative: new object, value 0
   a← gmpz.New '999999999'              ⍝ Alternative: new object from a value
   b← 16 gmpz.New 'ff'                  ⍝ ... works with a base on the left
   16 b.Set 'bee cafe'                  ⍝ Set b to a new string value (in base 16)
   b.Set a                              ⍝ copy the value of another gmpz into b
   b.Bits← 1 0 1 0 1 1 1 0 ...          ⍝ copy APL bits efficiently into a (2s complement)
   c← a.Copy                            ⍝ a new, independent gmpz with a's value
   ⌷b                                   ⍝ value of b in string form
```

**Assignment aliases.** `b← a` makes `b` and `a` the *same* object, so `b.Inc` changes `a` too. Use `b← a.Copy` for an independent copy.

| Call | Result |
| :----------------------------------------- | :---- |
| <code>str←&nbsp;⌷a</code> | `a` in base 10 as a string (any length). |
| <code>a.Set&nbsp; value</code><br><code>base &nbsp;a.Set &nbsp;value</code> | Overwrite `a` with `value` (`base` is valid only with strings, default `10`). Returns `a` itself (shy), so calls can be chained: `(a.Set value).Signum` |
| <code>c←&nbsp;a.Copy</code> | A new gmpz with the same value. |
| <code>int←&nbsp;a.Int64</code> | `a`, a C-language *long* (Unix: 64-bits; Windows: 32-bits), as an APL integer. Error `badIntÊ`, if it doesn't fit. |
| <code>int←&nbsp;a.IntDF</code> | `a` as an APL integer in decimal-float form: exact up to 34 digits (±`¯1+10*34`). Error (`badIntÊ`) if it has more digits. |
| <code>ok&nbsp;int←&nbsp;a.VFI</code> | `1 n` if a fits in 34 digits (as IntDF), else `0 0`. Never errors. |
| <code>str←&nbsp;a.GetInBase&nbsp;n</code> | `a` as a string in base `n` (2 ≤ `n` ≤ 62). |
| <code>str←&nbsp;[base]&nbsp;gmpz.Get&nbsp;b</code> | `b` (a gmpz, an APL integer or a *decimal* string) as a string in the base (default 10). |
| <code>int←&nbsp;a.StrLen</code> | Number of characters in `⌷a`, including the leading *minus* `¯`. Same as `≢⌷a`, without building the string. |
| <code>int←&nbsp;a.StrLenInBase&nbsp;n</code> | Same as `≢a.GetInBase n`, for 2 ≤ n ≤ 62. |
| <code>int←&nbsp;a.BitLen</code> | Minimum number of bits to hold `a` in two's complement, *including the sign bit*: 0 is 1, 7 is 4, 8 is 5, ¯8 is 4, ¯1 is 1. Equals `≢a.Bits`. |
| <code>int←&nbsp;a.Signum</code> | ¯1, 0 or 1. |
| <code>f←&nbsp;a.Float</code> | `a` as an approximate APL float: `2*64` is `18446744073709552000.` Signals `badIntÊ` if `a` has more than 1024 bits. |
| <code>bool←&nbsp;a.Even</code>, <code>a.Odd</code> | 1 or 0 (explicitly returned). |
| <code>bool←&nbsp;a.Bit[i1&nbsp;i2…]</code> | Read bits at specified indices from low- to high-order bits.  See §5 for details. |
| <code>a.Bit[i1&nbsp;i2…]←&nbsp;bool</code> | Writes bits at specified indices from low- to high-order bits.  See §5 for details.  |
| <code>bool←&nbsp;a.Bits</code> | `a`'s value efficiently returned as a boolean vector in two's complement, sign bit first. `a.Bits`  is equivalent to `⌽a.Bit[⍳a.Bitlen]`, but substantially faster. |
|  <code>a.Bits←&nbsp;bool</code> | `a`'s value efficiently set (replaced) from a boolean vector (leading bit is the sign). |
| <code>int←&nbsp;a.ptr</code> | Address of the underlying GMP object. Use with care to avoid ___destabilizing___ APL. |

**Int64 or IntDF?** Int64 is the machine integer (fast, 64-bit). IntDF is "as big as an APL decimal float can hold exactly" (34 digits) and needs `⎕FR←1287` in your session to display or compute with such values exactly. Use `VFI` to test safely.

**Memory:** A gmpz object and its GMP storage are allocated for you. They are freed automatically when the object goes out of scope, when `⎕EX` is executed on the object, when the workspace is cleared, or when the session ends. The random-number state is created the first time you call Rand, RandB or RandSeed.

**Tracing.** Set `DEBUG←1` in the class source to trace allocations and frees; `DEBUG←2` also traces the random state and the library bindings.

**Not saved with the workspace.** Objects hold raw C pointers: they should ***not*** be used after a `)SAVE`, `)LOAD`, or `⎕OR`: you ***must*** create them in each session to safely continue.

**Resources.** GMP stops the whole process if it runs out of memory. Methods such as Fac, Pow, Shift and RandB accept arguments up to `¯1+2*64`, so a mistyped argument (say `c.Fac 1E12`) will end your session *with prejudice*. Check sizes first.

## **2\.  The operating model**

Most methods are in place. The receiver is overwritten and returned (shy).

```
   c.Add b             ⍝ c ← c + b
   a c.Add b           ⍝ c ← a + b     Here, c is only the destination)
   ⌷(c.Set 5).Inc      ⍝ c => 5 => 6.  '6' is returned!
```

Operands (a, b) may each be:

* a gmpz object (used directly, never copied);
* an APL integer (positive or negative, a whole-number scalar of up to 34 digits when `⎕FR←1287`; beyond a C long, it is converted through its decimal string — return a string directly for anything bigger);
* an APL minus sign '¯' is accepted as a minus sign on input and returned on string output. 

An operand may repeat another operand or the receiver: `c c.Mul c` is safe.

Non-gmpz operands are copied into three hidden scratch gmpz objects, so don't rely on their values between calls. All class-level shared state—the scratch objects, `RandState`, and the `GI` operator—is thread-safe (`:Hold` serializes access to the scratch objects and random state, while `GI` allocates a fresh result per call without shared state). Only concurrent mutations on the *same* `gmpz` instance require caller-side synchronization.

A non-integer APL number signals `badAplÊ`, as does a numeric vector (including a boolean vector). A single scalar 0 or 1 is just an integer.

**Which methods take what.**

* Dyadic arithmetic (Add, Sub, Mul, Div, DivRem, Gcd, Lcm, Pow, PowM, Invert, And, Or, Xor, Cmp…, Jacobi): `[a] c.Op b`; the left operand defaults to the receiver.
* Left argument required: Res and Shift.
* **Niladic, in place:** Neg, Abs, Com, Inc, Dec. To set `c` to `−b`, write: `(c.Set b).Neg`; to set `c` to `|b`, write: `(c.Set b).Abs`.
* **Right argument only** (a value is built from it, so it does not default to the receiver): Fac, NextPrime, PrevPrime, Rand, RandB, ProbabPrime. To use the receiver, pass it: `c.NextPrime c`.
* **Mutating bit methods** (SetBit, ClrBit, Flip) act on the receiver only. To change a bit of another gmpz, call the method on that object.

## **3\.  Arithmetic methods (in place)**

\[a\]: if a is omitted, it defaults to the receiver c.

| Method | Meaning | Notes |
| :----------------------------------------------------------------------------------------------- | :----------- | :---------- |
| <code>[a]&nbsp;c.Add&nbsp; b</code> | `c ← a + b` |  |
| <code>[a]&nbsp;c.Sub&nbsp; b</code> | `c ← a − b` |  |
| <code>[a]&nbsp;c.Mul&nbsp; b</code> | `c ← a × b` |  |
| <code>[a]&nbsp;c.Div&nbsp; b</code> | `c ← ⌊a ÷ b` | Floored (rounds toward ¯∞), like APL's `⌊a÷b`. Signals divZÊ if b is 0\. |
| <code>rem←&nbsp;[a]&nbsp;c.DivRem&nbsp;m</code> | `c ← ⌊a÷m, returns rem← m\|a` | Same floored quotient as Div. The remainder is returned as a new **gmpz** object (shy), not as an APL integer. The divisor may be a **gmpz**, an APL integer or a string — it does not have to fit in 64 bits (the fast unsigned path is used only when it is a non-negative APL integer ≤ `¯1+2*64`. divZÊ if `m` is 0. |
| <code>m&nbsp;c.Res&nbsp;b</code> | `c ← m\|b` | APL residue, floored (sign follows `m`). 0\|b is `b`. Dyadic only. |
| <code>[a]&nbsp;c.Gcd&nbsp; b</code> | `c ← a∨b` | ≥ 0\. Greatest common divisor. |
| <code>[a]&nbsp;c.Lcm&nbsp; b</code> | `c ← a∧b` | ≥ 0\. Least common multiple. |
| <code>[a]&nbsp;c.Divexact &nbsp;b</code> | `c ← a ÷ b` | Fast division that is only valid when `b` divides a exactly (otherwise the result is meaningless). divZÊ if b is 0\. |
| <code>[a]&nbsp;c.Pow &nbsp;n</code> | `c ← a*n` | `n` must be a non-negative APL integer (not a string or gmpz), and must fit in a C unsigned long (powÊ otherwise). |
| <code>[a]&nbsp;c.Pow&nbsp; ÷n</code> | `n-th root of a, truncated toward 0` | Same as `⌊a*÷n` for `a≥0`\. n a positive integer. If a\<0, n must be odd. |
| <code>[a]&nbsp;c.PowM&nbsp; e&nbsp; m</code> | `c ← m\|a*e` | Modular exponentiation. `e` and `m` may be gmpz, integer or string. A negative exponent or a negative modulus signals powÊ (modulus 0 signals divZÊ). |
| <code>rc←&nbsp;[a]&nbsp;c.Invert&nbsp; m</code> | `c ← a⁻¹ mod m` | Returns 1 if the inverse exists, 0 if not (then c is meaningless). m>0 (divZÊ for 0, powÊ for negative). |
| <code>i&nbsp;c.Shift&nbsp;b</code> | `c ← b × 2*i` | Binary shift. `i\>0` left, `i\<0` right (truncating toward zero). Dyadic only. i may be an integer, an integer string or a gmpz; non-integers signal shiftÊ. |
| <code>i&nbsp;c.ShiftFloor&nbsp;b</code> | `c ← ⌊b ÷ 2*-i` | As Shift, but a right shift *floors* (toward ¯∞): `¯1 c.ShiftFloor ¯7` is ¯4, where Shift gives ¯3. Same for non-negative b. |
| <code>c.Neg</code> | `c ← −c` | Niladic. For `c← −b`: `(c.Set b).Neg`. |
| <code>c.Abs</code> | `c ← \|c` | Niladic. For `c← \|b`: `(c.Set b).Abs`. |
| <code>c.Fac&nbsp;n</code> | `c ← !n` | `n` ≥ 0; `n` may be an integer, string or gmpz. `n` must be ≤ `¯1+2*64` (Windows: `¯1+2*32`), else `facBadÊ`. Large results are limited only by memory. |
| <code>c.Inc</code> | `c ← c+1` | Niladic. |
| <code>c.Dec</code> | `c ← c−1` | Niladic. |
| <code>bool←&nbsp;c.Divisible&nbsp;b</code> | `1 if b divides c, else 0` | b=0: true only if `c` is 0\. Visible 0/1 result. |

```
    c← ⎕NEW gmpz
    2 c.Pow 200                    ⍝ c ← 2*200
    c.Mul 3                        ⍝ c ← c × 3
    1000 c.Res c                   ⍝ c ← 1000|c
    ¯7 c.Shift c                   ⍝ c ← c ÷ 2*7, i.e. shift bits right.
    c.Pow ÷2                       ⍝ c ← √c (truncated toward 0)
    c.Fac 100                      ⍝ c ← !100
    r← ⎕NEW gmpz
    7 r.PowM 128 13                ⍝ r ← 13|7*128
    c.Neg                          ⍝ c ← -c
```

**Floored division:** Div, DivRem and Res are floored (round toward ¯∞), matching APL's ⌊ and ⍺\|⍵, so a \= (m×⌊a÷m) \+ m\|a for any signs. This differs from C, where integer division (/) truncates toward zero. Right Shift truncates toward zero, so that identity holds for Div/Res but not for right Shift. The n-th root, Pow ÷n, also truncates toward zero, which only matters for negative a with odd n.

## **4\.  Comparison**

There are no \< or \> methods — use the named forms below or use `<GI`, `>GI`, etc. If a is omitted, it defaults to the receiver. If b is an APL integer in the signed 64-bit range, a faster signed-integer comparison is used.

| Method | APL equivalent | Returns |
| :---- | :---- | :---- |
| <code><code>[a] &nbsp;c.Cmp &nbsp;b</code></code> | `×a−b` | `¯1, 0 or 1` |
| <code><code>[a]&nbsp;c.Lt&nbsp; b</code></code> | `a < b` | `0 or 1` |
| <code>[a]&nbsp;c.Le&nbsp; b</code> | `a ≤ b` | `0 or 1` |
| <code>[a]&nbsp;c.Eq&nbsp; b</code> | `a = b` | `0 or 1` |
| <code>[a]&nbsp;c.Ne&nbsp; b</code> | `a ≠ b` | `0 or 1` |
| <code>[a]&nbsp;c.Ge &nbsp;b</code> | `a ≥ b` | `0 or 1` |
| <code>[a]&nbsp;c.Gt &nbsp;b</code> | `a > b` | `0 or 1` |

```
   c.Gt 100                       ⍝ is c > 100 ?
1
   '1234567890123456' c.Eq y      ⍝ string vs gmpz
0
```

## **5\.  Retrieving and manipulating bits**

a.Bit\[ix\] reads or writes individual bits in place. The least significant bit is at index 0 if ⎕IO=0, and at index 1 if ⎕IO=1.

```
a← ⎕NEW gmpz 15             ⍝ 1111₂
a.Bit[0 1 2]← 0             ⍝ a is now 8 (1000₂)
a.Bit[3]                    ⍝ → 1
a.Bit[0 1 2]← 1 0 1         ⍝ set several bits at once → a is 13 (1101₂)
a.Bit[0 2 3]                ⍝ read several bits → 1 1 1
a.Bit[2]← 0                 ⍝ clear bit 2 → a is 9 (1001₂)
a.BitLen                    ⍝ 5: bits in two's complement, including the sign bit
a.Bits                      ⍝ 0 1 0 0 1   (sign bit first, then most-significant first)
```

| Form | Meaning |
| :---- | :---- |
| `a.Bit[n]` | Read bit (boolean value) at index `n`.  |
| `a.Bit[n]← b` | Set  bit at index `n` to `b`, a boolean (1 or 0). |
| `a.Bit[n1 n2 n3]` | Read  bits at indices `n1 n2 n3`. Indices may be positive or negative. Honours `⎕IO` for positive indices, which select bits from low to high. Negative indices select from the high-order bits. Index ¯1 is the first HOB, i.e. the sign. |
| <code>a.Bit[n1&nbsp;n2&nbsp;n3]←&nbsp;1&nbsp;0&nbsp;1</code><br><code>a.Bit[n1&nbsp;n2&nbsp;n3]←&nbsp;1</code> | Set one or more bits (one value per index, or one value for all). Honours `⎕IO` for positive indices, which select bits from low to high. Negative indices select from the high-order bits. Index ¯1 is the first HOB, i.e. the sign. |
| `a.Bits` | **All** bits as a boolean vector in two's complement, sign bit first (the reverse of a.Bit\[⍳a.BitLen\]). |
| `a.Bits← 1 0 1` | Replace **all** the bits of object `a`; the leading bit is the sign. `a.Bits←1` sets `a` to `¯1`; an empty vector sets it to `0`). |
| `a.ExportBits w` | As `a.Bits` but exactly `w` bits wide (sign-extended), `w ≥ a.BitLen`. `0` means the minimum. |
| <code>a.ImportBits&nbsp;bits</code> | Same as `a.Bits← bits`. |

Values assigned to bits must be 0 or 1 (badBitValÊ). Setting a bit beyond the current length to 1 is valid; the object grows automatically. Clearing high-order bits shrinks it.

Note: Although GMP stores mpz_t values internally in sign-magnitude form, all bitwise operations and shifts emulate infinite-width two's complement arithmetic. Non-negative integers are treated as having an infinite prefix of 0 bits and negative integers an infinite prefix of 1 bits, while left and right bit shifts correspond to exact multiplication and truncating division by `2*b`.

### **Whole-number bitwise operations**

| Method | Meaning |
| :---- | :---- |
| `[a] c.And b` | c ← a ∧ b, bit by bit |
| `[a] c.Or b` | c ← a ∨ b, bit by bit |
| `[a] c.Xor b` | c ← a ≠ b, bit by bit |
| `c.Com` | c ← bitwise NOT of c (that is, ¯1−c). Niladic, in place. |
| <code>n←&nbsp;c.PopCount</code> | Number of 1 bits. A negative number has infinitely many, so the result is `gmpz.UL_MAX` (Unix: `¯1+2*64`; Windows: `¯1+2*32`). |
| <code>n←&nbsp;[a]&nbsp;c.HamDist&nbsp;b</code> | Hamming distance: the number of bit positions where a and b differ (`gmpz.UL_MAX` if exactly one is negative). |

### **Bit methods (alternatives to the Bit property)**

All of these honour the caller's ⎕IO for their bit positions. A position below ⎕IO signals badBitIxÊ.

| Method | Meaning |
| :---- | :---- |
| <code>bool←&nbsp;[a]&nbsp;c.TestBit&nbsp;n</code> | Returns bit n. A visible result; `a` may be any operand (read-only). |
| <code>val←&nbsp;c.SetBit&nbsp;n&nbsp;[val]</code> | Sets bit n to val (default 1): `c.SetBit 5` or `c.SetBit 5 0`. Receiver only; shy. |
| <code>bit←&nbsp;c.ClrBit&nbsp;n</code> | Clears bit n (sets it to 0). Receiver only; shy. |
| <code>bit←&nbsp;c.Flip&nbsp;n</code> | Complements bit n, and returns its new value. Receiver only; shy. |
| <code>pos←&nbsp;[a]&nbsp;c.Iota&nbsp;bit</code> | Index of the lowest bit equal to bit (0 or 1), counted in your ⎕IO. Visible result. |
| <code>pos←&nbsp;[a]&nbsp;c.Scan&nbsp;(start&nbsp;bit)</code> | Like Iota, but begins the search at index start (in your ⎕IO). Visible result. |

Iota and Scan return `gmpz.UL_MAX` (`¯1+2*64` on *Unix* systems, `¯1+2*32` on *Windows*), *not* adjusted for ⎕IO, when there is no such bit.

## **6\.  Random numbers**

Uses GMP's Mersenne Twister; its state is created on first use of a random number function and seeded from system entropy by default (it can be changed via RandSeed). Rand and RandB are ⎕IO-sensitive — in ⎕IO←1 Rand returns 1…b and RandB returns `1`…`2*n` (in ⎕IO←0, `0`…`b-1` and `0`…`2*n`).

```
   c← ⎕NEW gmpz '123456789012345678901234567890'
   gmpz.RandSeed 42                            ⍝ seed (like gmp_randseed_ui)
   r← ⎕NEW gmpz
   r.Rand c                                    ⍝ r ← uniform in 0 ≤ r < c
   ⌷r.RandB 256                                ⍝ r ← uniform in 0 ≤ r ≤ 2*256−1
```

| Method | Meaning |
| :---- | :---- |
| <code>r.Rand&nbsp;b</code> | r ← uniform in \[0, b); b may be gmpz, integer or string; must be positive (randÊ). |
| <code>r.RandB&nbsp;n</code> | r ← uniform in \[`0`, `2*n`); n ≥ 0. |
| <code>gmpz.RandSeed&nbsp;u</code> | Seeds with an unsigned 64-bit u; returns the old seed (shy) as a string. RandSeed 0 reseeds from system entropy. |

Only one random state exists for all objects; reseeding anywhere affects every later Rand and RandB.

## **7\.  Primes and number theory**

```
⍝  rc: 2 definitely prime, 1 probably prime, 0 not prime
   rc← c.ProbabPrime ⍬        ⍝ ⍬ or 0: default of 24 Miller-Rabin reps (the argument itself is required)
   rc← c.ProbabPrime 15       ⍝ 15 reps (15–50 is reasonable)
   c.NextPrime n              ⍝ c ← next prime > n
   c.PrevPrime n              ⍝ c ← greatest prime < n  (noPrevPrimeÊ if n ≤ 2)
   (c rc)← c.PrevPrime2 n     ⍝ Like PrevPrime, but also returns rc: 2 definitely, 1 probably, 0 none (no error)
   rc← [a] c.Jacobi b         ⍝ Jacobi symbol (a/b): ¯1, 0 or 1. b must be odd (badAplÊ if even).
   rc← [a] c.Invert m         ⍝ modular inverse (see §3)
```

PrevPrime relies on GMP's mpz\_prevprime (GMP 6.3+), which sets c to the greatest prime strictly less than n and itself returns 2, 1 or 0\. PrevPrime2 returns (mpz rc) where rc is that GMP return code; plain PrevPrime signals noPrevPrimeÊ when the code is 0.

c is the number being tested for ProbabPrime, Jacobi (when a is omitted) and Divisible.

### **Further number theory**

| Method | Meaning |
| :---- | :---- |
| <code>[n]&nbsp;c.Bin&nbsp;k</code> | `c ← n choose k` (n defaults to c; n may be negative — the generalised binomial). k a non-negative integer (badUIntÊ otherwise). APL's `k!n` is `n c.Bin k`. |
| <code>c.Fib&nbsp;n</code> | `c ←` the n-th Fibonacci number (`Fib 0` is 0, `Fib 1` is 1). |
| <code>c.Primorial&nbsp;n</code> | `c ←` the product of all primes ≤ n. |
| <code>rem←&nbsp;c.SqrtRem&nbsp;b</code> | `c ← ⌊√b`, and the (shy) new gmpz `rem ← b − c*2`. sqrtNegÊ if b is negative. |
| <code>st←&nbsp;[a]&nbsp;c.GcdExt&nbsp;b</code> | Extended gcd: `c ← a∨b`, and the (shy) pair `st← s t` of new gmpz's with `(a×s)+(b×t) = c`. |
| <code>bool←&nbsp;c.IsSquare</code> | Is c a perfect square? (0 is; negatives are not.) |
| <code>bool←&nbsp;c.IsPower</code> | Is c a perfect power `x*k`, k>1? (0 and 1 are; a negative only if an odd power.) |
| <code>bool←&nbsp;[a]&nbsp;c.Congruent&nbsp;(b&nbsp;m)</code> | Is a ≡ b (mod m)? With m=0, true only if a=b. |

```
   c← ⎕NEW gmpz
   240 c.GcdExt 46                ⍝ c is 2;  returns s t with 240×s + 46×t = 2
   ⌷52 c.Bin 5                    ⍝ 2598960
   ⌷c.Fib 100                     ⍝ 354224848179261915075
```

## **8\.  The GI operator: primitive-style, non-destructive**

GI wraps the methods so they read like APL primitives. Arguments are never modified; a new gmpz is returned (comparisons, and several monadic and dyadic forms marked below, return plain values). GI is also defined in the namespace that holds gmpz, so it can be used from anywhere. Every result is a fresh object with no shared scratch state, so `GI` calls are thread-safe and a result never changes under a later `GI` call.

```
    x← 2 *GI 100                   ⍝ 2*100
    y← x +GI 1                     ⍝ x + 1
    z← 10 |GI y                    ⍝ 10|y   (left is the modulus)
    ⌷ !GI 30                       ⍝ factorial, shown as a string 
    ⊤GI 30                         ⍝ plain string of '30'
    7 <GI x                        ⍝ comparison → 0/1
```

| Dyadic | Meaning | Monadic | Meaning |
| :---- | :---- | :---- | :---- |
| <code>a&nbsp;+GI&nbsp;b</code> | a+b | `-GI b` | negate |
| <code>a&nbsp;-GI&nbsp;b</code> | a−b | `\|GI b` | absolute value |
| <code>a&nbsp;×GI&nbsp;b</code> | a×b | `?GI b` | random in \[`0`, `b`) if `b≥0`; in \[0, `2*\|b`) (RandB) if b\<0 |
| <code>a&nbsp;÷GI&nbsp;b</code> | ⌊a÷b (floored) | `!GI b` | factorial |
| <code>a ÷∘\|GI b</code> | DivRem: a 2-vector of new gmpz's, see note | `×GI b` | signum (plain integer) |
| <code>a&nbsp;*GI&nbsp;b</code> | a\*b (b may be ÷n) | `<GI b` | b−1 |
| <code>a&nbsp;∨GI&nbsp;b</code> | gcd | `>GI b` | b+1 |
| <code>a&nbsp;∧GI&nbsp;b</code> | lcm | `≢GI b` | string length (b.StrLen, plain integer) |
| <code>a \|GI b</code> | a\|b (a is the modulus) | `⍎GI b` | b as an APL integer (IntDF; error if it does not fit) |
| <code>a&nbsp;⌽GI&nbsp;b</code> | shift b by a bits | <code>⎕VFI&nbsp;GI&nbsp;b</code> | `ok int` as b.VFI, never errors |
| <code>a&nbsp;*∘\|GI&nbsp;(e&nbsp;m)</code> | `m\|a*e` (PowM) | `⌷GI b` | b as a two's complement bit vector (b.Bits) |
| <code>a&nbsp;⍳GI&nbsp;i</code> | position of the lowest bit of a equal to i (0 or 1); 2\*64−1 if none (plain integer) | `⊤GI b` | b as a decimal string |
| <code>a&nbsp;⌷GI&nbsp;b</code> | bit `a` of `b` (`b.Bit\[a\]`; plain 0/1) | `⊥GI b` | a new gmpz holding a copy of b |
| <code>a&nbsp;!GI&nbsp;b</code> | a!b as in APL: b choose a (`3!GI 5` is 10) | `~GI b` | bitwise NOT of b (¯1−b) |
| <code>a&nbsp;⌈GI&nbsp;b</code> | the larger of `a` and `b` | | |
| <code>a&nbsp;⌊GI&nbsp;b</code> | the smaller of `a` and `b` | | |
| <code>a&nbsp;<GI&nbsp;b</code> | Similarly: ≤ \= ≥ \> ≠, returning 0 or 1 |  |  |
| <code>a&nbsp;⊤GI&nbsp;b</code> | `b` (gmpz, integer or decimal string) as a *string* in base `a` | | |
| <code>a&nbsp;⊥GI&nbsp;b</code> | a new gmpz from the string `b` read in base `a` | | |
| <code>a&nbsp;≢GI&nbsp;b</code> | length of the string of `b` in base `a` (plain integer) | | |

Note: `(mpz mpz)← a ÷∘|GI b` calls DivRem, returning `((a÷b), (b|a))`, floored, both new gmpz's.

Use the gmpz methods directly when you want to avoid allocating a new object per operation. An unsupported glyph gives unknownÊ.

## **9\.  Errors**

Errors in public methods are trapped and re-signalled from your line, so ⎕DMX points at your code.

| Name | EN | Meaning |
| :---- | :---- | :---- |
| noGmpÊ | 22 | GMP library not found |
| gmpLoadÊ | 11 | A GMP routine failed to bind (library older than 6.3?) |
| badInitÊ | 11 | Unable to create object |
| badAplÊ | 11 | Invalid APL value (not a whole-number scalar, or too many digits), or a base outside 2…62 |
| badObjÊ | 11 | Can't convert to a gmpz (e.g. bad string, released object) |
| badIntÊ | 11 | Doesn't fit the requested APL integer type (Int64: C long; IntDF: 34 digits) |
| badBitsÊ | 11 | Bits← vector contains something other than 0 and 1 |
| badBitValÊ | 11 | Bit value must be 0 or 1 |
| badBitIxÊ | 3 | Invalid bit index (below ⎕IO, or too large) |
| baseXtraÊ | 11 | A base was given with a value that is not a string |
| divZÊ | 11 | Division by 0 |
| powÊ | 11 | Invalid power / root / modulus |
| shiftÊ | 11 | Shift value must be an integer |
| facBadÊ | 11 | Factorial of a negative integer, a non-integer, or a value over 2\*64-1 (Windows: 2\*32-1) |
| primeÊ | 11 | Bad reps argument for ProbabPrime |
| noPrevPrimeÊ | 11 | PrevPrime of a number ≤ 2 |
| propSetÊ | 11 | Tried to assign to a.Bits\[i\]; use a.Bit\[i\] |
| badUIntÊ | 11 | Value must be a non-negative integer no larger than a C unsigned long (Bin, Fib, Primorial) |
| sqrtNegÊ | 11 | SqrtRem of a negative number |
| randSeedÊ | 11 | Seed can't be converted to an unsigned integer |
| randÊ | 11 | Arg must be positive (Rand bound ≤ 0, or RandB bits \< 0\) |
| randStateÊ | 11 | Unable to initialise random # state |
| randActiveÊ | 911 | Internal logic error: only one randState instance is allowed. |
| unknownÊ | 11 | Unsupported glyph in GI |

## **10\.  Quick reference and gotchas**

1. In `a c.Op b`, `c` is the destination and is overwritten and `a` is the left operand; in `c.Op b` the receiver is both the left operand and the destination.
2. Res (`|`) and Shift (`⌽`) require a left argument; most other dyadic methods default it to the receiver. Neg, Abs, Com, Inc and Dec are niladic. Fac, NextPrime, PrevPrime, Rand, RandB and ProbabPrime take only a right argument.
3. Shy results: the in-place arithmetic methods, DivRem, Fac, SetBit, ClrBit, Flip, Rand, RandB and RandSeed print nothing in the session. Assign the result, or use `⌷` to see a value. Predicates and queries (Even, Odd, Divisible, TestBit, Iota, Scan, ProbabPrime, Cmp and friends, Signum, Jacobi, Invert) are visible.
4. Pow's exponent must be a plain APL non-negative integer `n` or `÷n` (for roots, as in APL). Negative exponents are invalid.
5. DivRem divisors may be any supported operand type and must be non-zero (`divZÊ` if **0**).
6. Use `⌷a` to see the final (string) value. It is more efficient to keep working with gmpz objects, so that no unnecessary conversions to and from strings are needed.
7. Strings may use the high minus `¯` on input; it is converted to `-` by gmpz utilities.
8. The base (2 through 62) can be specified when importing numeric strings; it is invalid for other operand types.
9. `a.Int64` only succeeds when the value fits a C long (signed 64-bit); `a.IntDF` allows up to 34 digits. Use **VFI** to test safely. Set `⎕FR←1287` in your session if you manipulate integers beyond 2\*53.
10. Copy, don't assign: `b←a` aliases; `b←a.Copy` copies.
11. `⎕IO`: only the bit-position methods (Bit, TestBit, SetBit, ClrBit, Flip, Iota, Scan) and Rand/RandB depend on ⎕IO.
12. Objects are lost on `)SAVE`/`)LOAD`; huge arguments can exhaust memory and stop the session (see §1).
13. **Thread safety:** Class-level scratch buffers, `Rand`/`RandB`/`RandSeed`, and `GI` expressions are thread-safe across Dyalog threads (`&`). If two threads mutate the *same* `gmpz` instance concurrently, guard access to that instance with `:Hold` (or give each thread its own `.Copy`).

## **11\.  Multi-Core Execution with Dyalog Isolates**

Dyalog APL threads (`&`) multiplex cooperatively on a single OS interpreter thread and block on `⎕NA` calls. To run CPU-intensive `gmpz` routines (such as `NextPrime`, `ProbabPrime`, `PowM`, or large `Fac`) in true parallel across multiple CPU cores, use Dyalog's built-in **`isolate`** workspace (`ws/isolate`), which runs each worker in a separate OS process.

### Setup & Serialization Rules

* **Load `gmpz` inside each isolate using `2 isos.⎕FIX`:** Passing left argument `2` tells `⎕FIX` to return the character name `'#.gmpz'` rather than a class reference (isolates forbid returning class or function references across process boundaries).
* **Never pass `gmpz` instances across isolate boundaries:** Each isolate has its own OS address space and `libgmp` instance, so raw C pointers (`⍙ptr`) cannot cross IPC boundaries. Serialize values as **Base-62 strings** (`x.GetInBase 62` / `62 p.Set str`) for moderate integers, or **two's-complement bit vectors** (`x.Bits` / `p.Bits← bits`) for very large integers.
* **Reuse a persistent worker pool:** Create `N` isolates once, fix `gmpz` and your worker functions into them, and close the pool with `_← isos.Close` when finished.

```apl
   'isolate' ⎕CY 'isolate'

   ⍝ 1. Spin up 4 worker processes and load gmpz + worker function into each
   isos← isolate.New¨ 4⍴⊂''
   {}2 isos.⎕FIX ⊂'gmpz/gmpz.dyalog'

   ∇ resStr← seedStr PrimeWorker offset; p; i
     p← gmpz.New0
     62 p.Set ∊seedStr
     p.Add offset
     :For i :In ⍳40
        p.NextPrime p
     :EndFor
     resStr← p.GetInBase 62
   ∇
   {}isos.⎕FX ⊂⎕NR 'PrimeWorker'

   ⍝ 2. Dispatch across all 4 OS cores (returns futures immediately)
   seedStr← (1536 (gmpz.New 0).Shift 2).GetInBase 62
   futures← (4⍴⊂seedStr) isos.PrimeWorker 100000× ⍳4
   primes← (62∘gmpz.New)¨ ⍕¨futures       ⍝ Realize futures and rebuild local gmpz objects

   _← isos.Close
```

### When to Use Isolates vs. Threads (`&`)

* **Use Dyalog Threads (`&`)** for fast, fine-grained arithmetic (`Add`, `Mul`, `RandB`, `GI` expressions) or when workers share mutable `gmpz` instances via `:Hold`.
* **Use Isolates (`isolate.New`)** when individual GMP operations take **> 5–10 ms** of CPU time so true multi-core execution easily outweighs IPC serialization overhead.
On a Mac with 4 "performance" cores (and 6 "efficiency" cores), large GMP operations saw a speedup of 3.4 fold with 4 isolates.  Speedups improved only a small amount with 5 or even 10 isolates. For smaller uneven tasks, a larger number of isolates might achieve greater speedups: benchmark and see!

## **Appendix: Encrypt a Message Using Simplified RSA Key**

Implement a simplified[^1] **RSA key generation, encryption, and decryption** workflow.
This demonstrates the core lifecycle of GMP integers:
* initialization,
* random prime generation,
* modular arithmetic,
* modular inverse, and 
* memory cleanup.

### Load and run the example code.

```
]load gmpz/Example.aplf
GmpzExample
```

#### Running GmpzExample [2]

```
    GmpzExample  '🙂 This is a cat 🙂'             ⍝ A random Unicode string
Public Modulus (n):
    7c09b76d3dabfc23419a94a9db4452e891747b45e86a0ef162c3712ce1a53c31
    ...
Encrypted Cipher:
    646d47879ff5b113e3ec0172062eaeaec75ac21d5630fa815c6f8e91b49569f1
    ...
Decrypted Message:
    🙂 This is a cat 🙂
Success: Decrypted message matches original

```

[1]:  RSA encryption is still useful today, provided you use 2048- or, preferably, 4096-bit encryption.<p>
[2]:  The output is abridged (...) for pedagogical purposes.
