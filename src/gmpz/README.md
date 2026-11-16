# **gmpz**  Dyalog Apl class and helper function **GI**
*Backed by GMP mpz calls (libgmp)  •  Nov 2026 Edition*

For Dyalog APL v20 or later and GMP 6.3 or later. [Tested on Mac/OS, but designed for Mac/OS and Windows]

# **Setup**

```
]load gmpz/gmpz 
⎕FR ⎕PP← 1287 34        ⍝  Optional. Convenient for entering large (64-bit) integer constants.
``` 

* Dyalog APL v20 (64-bit) and the GMP shared library (libgmp).  
* GMP 6.3 or later is required — PrevPrime uses mpz\_prevprime, which does not exist in earlier GMP versions, and the class binds its routines on load.  
* Inside the class, ⎕IO ⎕ML ⎕PP ⎕FR are 0 1 34 1287\. You may wish to set ⎕FR←1287 when using **gmpz** if you wish to enter 64-bit integers directly.

# **1\.  Creating and reading values**

```
   a← ⎕NEW gmpz                         ⍝ 0 
   a← ⎕NEW gmpz ¯2                      ⍝ from an APL integer 
   a← ⎕NEW gmpz '1234567 89012345678'   ⍝ from a string ('¯' => '-'). Blanks ok! 
   a← ⎕NEW gmpz ('bee cafe' 16)         ⍝ from a string in base 16 (base ∊ 2…62) 
   a← gmpz.New0                         ⍝ Alternative: new object, value 0 
   a← gmpz.New '999999999'              ⍝ Alternative: new object from a value 
   b← 16 gmpz.New 'ff'                  ⍝ ... works with a base on the left 
   16 b.Set 'bee cafe'                  ⍝ Set b to a new string value (in base 16) 
   b.Set a                              ⍝ copy another gmpz 
   ⌷b                                   ⍝ value of b in string form`
```

| Call | Result |
| :----------------------------------------- | :---- |
| `str← ⌷a` | *a* in base 10 as a string (any length). |
| <code>a.Set&nbsp;value base&nbsp;a.Set&nbsp;value</code> | Overwrite **a** with value (base applies to strings only, default 10). Returns **a** itself (shy), so calls can be chained. |
| `int← a.Int` | a as an APL integer (signed 64-bit). Error (badIntÊ) if it doesn't fit. |
| `ok int← a.VFI` | 1 n if it fits in 64 bits, else 0 0\. Never errors. |
| `int← a.StrLen` | Number of characters in ⌷a, including the leading ¯. Same as ≢⌷a, without building the string. |
| `int← a.Len` | Exact number of bits in (\|a) — e.g. 8 and ¯8 are both Len 4, and 0 is Len 1\. Signs do not affect it. |
| `str← a.GetInBase n` | **a** as a string in base n (2 ≤ n ≤ 62). |
| `int← a.Signum` | ¯1, 0 or 1\. |
| `bool← a.Even / a.Odd` | 1 or 0 (result is shy — see §10 Gotchas). |
| `bool← a.Bit[i1 i2 …]` | Read bits. Honours ⎕IO. See §5. |
| `bits← a.Bits` | **a** as a boolean vector, most-significant bit first. Read-only. Non-negative values only — signals badObjÊ for a negative. |
| `int← a.ptr` | Address of the underlying GMP object. Be careful\! |

**Memory:** A gmpz object and its GMP storage are allocated for you. 
They are freed automatically, when the object goes out of scope; when ⎕EX is executed on the object, 
when the workspace is cleared, or when the session ends. 
The random-number state is created the first time you call Rand, RandB or RandSeed. 

Set **DEBUG←1** in the class source to trace allocations and frees.

# **2\.  The operating model**

Most methods are in place. The receiver is overwritten and returned (shy).

```
   c.Add b             ⍝ c ← c + b 
   a c.Add b           ⍝ c ← a + b   (c is only the destination) 
   ⌷(c.Set 5).Inc      ⍝ results are shy and return the receiver, so calls chain: c is now 6
```

Operands (a, b) may each be:

* a gmpz object (used directly, never copied);  
* an APL integer (positive or negative, within ±2\*63 — use a string for anything bigger);  
* an integer string ('¯' is accepted as a minus sign).

An operand may repeat another operand or the receiver: `c c.Mul c` is safe.

Non-gmpz operands are copied into three hidden scratch gmpz objects, so don't rely on their values between calls. Methods use :Hold around the shared scratch objects, so access to those is serialised; do not rely on the scratch values between calls.

A non-integer APL number signals badAplÊ.

Methods that take *only* a right argument — Neg, Abs, Fac, NextPrime, PrevPrime, Rand, and so on — do not default it to the receiver. To negate c in place, use c.Neg c.

# 

# **3\.  Arithmetic methods (in place)**

\[a\]: if a is omitted, it defaults to the receiver c.

| Method | Meaning | Notes |
| :----------------------------------------------------------------------------------------------- | :----------- | :---------- |
| `[a] c.Add b`<img width="1000" height="1">| `c ← a + b` |  |
| `[a] c.Sub b` | `c ← a − b` |  |
| `[a] c.Mul b` | `c ← a × b` |  |
| `[a] c.Div b` | `c ← ⌊a ÷ b` | Floored (rounds toward ¯∞), like APL's `⌊a÷b.` Signals divZÊ if b is 0\. |
| `rem← [a] c.DivRem m` | `c ← ⌊a÷m, returns rem← m\|a` | Same floored quotient as Div. The remainder is returned as a new **gmpz** object (shy), not as an APL integer. The divisor may be a **gmpz**, an APL integer or a string — it does not have to fit in 64 bits (the fast unsigned path is used only when it is a non-negative APL integer ≤ 2\*64-1). |
| `m c.Res b` | `c ← m\|b` | APL residue, floored (sign follows m). 0\|b is b. Dyadic only. |
| `[a] c.Gcd b` | `c ← a∨b` | ≥ 0\. Greatest common divisor. |
| `[a] c.Lcm b` | `c ← a∧b` | ≥ 0\. Least common multiple. |
| `[a] c.Pow n` | `c ← a\*n` | n must be a non-negative APL integer, and the exponent must fit in a 64-bit unsigned integer (powÊ otherwise). |
| `[a] c.Pow ÷n` | `n-th root of a, truncated toward 0` | Same as ⌊a\*÷n for a≥0\. n a positive integer. If a\<0, n must be odd. |
| `[a] c.PowM (e m)` | `c ← m|a*e` | Modular exponentiation. `m=0` → divZÊ. e and m may be gmpz, integer or string. A negative exponent or a negative modulus signals powÊ (modulus 0 signals divZÊ). |
| `rc← [a] c.Invert m` | `c ← a⁻¹ mod m` | Returns 1 if the inverse exists, 0 if not (then c is meaningless). |
| `i c.Shift b` | `c ← b × 2*i` | Binary shift. i\>0 left, i\<0 right (truncating toward zero, like b÷2\*\|i rounded toward 0). Dyadic only. |
| `c.Neg b` | `c ← −b` | Right argument required. |
| `c.Abs b` | `c ← \|b` | Right argument required. |
| `c.Fac n` | `c ← !n` | n ≥ 0; n may be an integer, string or mpz. n must be ≤ 2\*32-1 (facBadÊ otherwise). Large results are limited only by memory. |
| `c.Inc` | `c ← c+1` | Niladic. |
| `c.Dec` | `c ← c−1` | Niladic. |
| `bool← c.Divisible b` | `1 if b divides c` | b=0: true only if c is 0\. |

```
    c← ⎕NEW gmpz 
    2 c.Pow 200                    ⍝ c ← 2*200 
    c.Mul 3                        ⍝ c ← c × 3 
    1000 c.Res c                   ⍝ c ← 1000|c 
    ¯7 c.Shift c                   ⍝ c ← c ÷ 2*7, truncated toward 0. (Shift bits right) 
    c.Pow ÷2                       ⍝ c ← √c (truncated toward 0) 
    c.Fac 100                      ⍝ c ← !100 r← ⎕NEW gmpz 
    7 r.PowM 128 13                ⍝ r ← 13|7*128
```

**Floored division:** Div, DivRem and Res are floored (round toward ¯∞), matching APL's ⌊ and ⍺\|⍵, so a \= (m×⌊a÷m) \+ m\|a for any signs. This differs from C, where integer division (/) truncates toward zero. Right Shift truncates toward zero, so that identity holds for Div/Res but not for right Shift. The n-th root, Pow ÷n, also truncates toward zero, which only matters for negative a with odd n.

# **4\.  Comparison**

There are no \< or \> methods — use the named forms below or use <code>\<GI</code>, <code>\>GI</code>, etc. If a is omitted, it defaults to the receiver x. If b is an APL integer, a faster signed-integer comparison is used.

| Method | APL equivalent | Returns |
| :---- | :---- | :---- |
| `[a] c.Cmp b` | `×a−b` | `¯1, 0 or 1` |
| `[a] c.Lt b` | `a < b` | `0 or 1` |
| `[a] c.Le b` | `a ≤ b` | `0 or 1` |
| `[a] c.Eq b` | `a = b` | `0 or 1` |
| `[a] c.Ne b` | `a ≠ b` | `0 or 1` |
| `[a] c.Ge b` | `a ≥ b` | `0 or 1` |
| `[a] c.Gt b` | `a > b` | `0 or 1` |

``` 
    c.Gt 100                       ⍝ is c > 100 ?  
1                                  ⍝ Output is simple integer ¯1 0 or 1 
   '1234567890123456' c.Eq y       ⍝ string vs gmpz 
0                                  ⍝ Output is simple boolean 0 or 1 
```  

# **5\.  Retrieving and manipulating bits**

a.Bit\[ix\] reads or writes individual bits in place. The least significant bit is at index 0 if ⎕IO=0, and at index 1 if ⎕IO=1.

```
a← ⎕NEW gmpz 15             ⍝ 1111₂ 
a.Bit[0 1 2]← 0             ⍝ a is now 8 (1000₂) 
a.Bit[3]                    ⍝ → 1 
a.Bit[0 1 2]← 1 0 1         ⍝ set several bits at once → a is 13 (1101₂) 
a.Bit[0 2 3]                ⍝ read several bits → 1 1 1 
a.Bit[2]← 0                 ⍝ clear bit 2 → a is 9 (1001₂) 
a.Len                       ⍝ bit length of **a** (4) 
a.Bits                      ⍝ 1 0 0 1   (most-significant bit first)
```

| Form | Meaning |
| :---- | :---- |
| a.Bit\[n\] | Read bit n (0 or 1). |
| a.Bit\[n\]← 1\|0 | Set or clear bit n. |
| a.Bit\[n1 n2 n3\] | Read several bits. |
| a.Bit\[n1 n2 n3\]← 1 0 1 | Set or clear several bits (one value per index, or one value for all). |
| a.Bits | All bits as a boolean vector, most-significant first (the reverse of a.Bit\[⍳a.Len\]). Read-only. |

Values assigned to bits must be 0 or 1 (badBitValÊ). Negative indices give badBitIxÊ. Setting a bit beyond the current length to 1 is valid; the object grows automatically. Clearing high-order bits shrinks it.

Negative numbers follow GMP's infinite two's-complement semantics (bits of ¯31, from bit 0: 1 0 0 0 0 1 1 1 …).

## 

## **Whole-number bitwise operations (in place)**

| Method | Meaning |
| :---- | :---- |
| \[a\] c.And b | c ← a ∧ b, bit by bit |
| \[a\] c.Or b | c ← a ∨ b, bit by bit |
| \[a\] c.Xor b | c ← a ≠ b, bit by bit |

## **Bit methods (alternatives to the Bit property)**

These act on a (default: the receiver c). With a left argument that is a gmpz, a is the object changed, not c. For TestBit, SetBit, ClrBit and Flip, bit indices are always 0-origin regardless of ⎕IO, and results are shy. Iota and Scan are the exceptions: they honour ⎕IO and are not shy.

| Method | Meaning |
| :---- | :---- |
| `bool←[a] c.TestBit n` | Returns bit n. |
| <code>val←&nbsp;[a]&nbsp;c.SetBit&nbsp;n&nbsp;[val]</code> | Sets bit n to val (default 1): c.SetBit 5 or c.SetBit 5 0\. |
| `bit← [a] c.ClrBit n` | Clears bit n (sets it to 0). |
| `bit← [a] c.Flip n` | Complements bit n, and returns its new value. |
| `pos← [a] c.Iota bit` | Index of the lowest bit equal to bit (0 or 1), counted in your ⎕IO. Result is not shy. |
| <code>pos←&nbsp;[a]&nbsp;c.Scan&nbsp;(start&nbsp;bit)</code> | Like Iota, but begins the search at index start (in your ⎕IO). A start below ⎕IO gives badBitIxÊ. Result is not shy. |

Iota and Scan are ⎕IO-sensitive, returning the largest possible U8 value when the specified bit (1 or 0\) is not found. 

# **6\.  Random numbers**

Uses GMP's Mersenne Twister; its state is created on first use of a Random number function and seeded from system entropy by default (it can be changed via RandSeed). Rand and RandB are ⎕IO-sensitive — in ⎕IO←1 Rand returns 1…b and RandB returns 1…2\*n (in ⎕IO←0, 0…b-1 and 0…2\*n-1).

```
   c← ⎕NEW gmpz '123456789012345678901234567890' 
   r← ⎕NEW gmpz r.RandSeed 42                  ⍝ seed (like gmp_randseed_ui) 
   r.Rand c                                    ⍝ r ← uniform in 0 ≤ r < c 
   ⌷r r.RandB 256                              ⍝ r ← uniform in 0 ≤ r ≤ 2*256−1
```

| Method | Meaning |
| :---- | :---- |
| `r.Rand b` | r ← uniform in \[0, b); b may be gmpz, integer or string; must be positive. |
| `r.RandB n` | r ← uniform in \[0, 2\*n). |
| <code>r.RandSeed&nbsp;u</code> | Seeds with unsigned 64-bit u; returns the old seed (shy) as a string. RandSeed 0 (null) reseeds from system entropy. |

Only one random state exists for all objects; reseeding anywhere affects every later Rand and RandB.

# 

# **7\.  Primes and number theory**

```
⍝  rc: 2 definitely prime, 1 probably prime, 0 not prime   
   rc← c.ProbabPrime ⍬        ⍝ ⍬ or 0: default of 24 Miller-Rabin reps 
   rc← c.ProbabPrime 15       ⍝ 15 reps (15–50 is reasonable)                            
   c.NextPrime n              ⍝ c ← next prime > n 
   c.PrevPrime n              ⍝ c ← greatest prime < n 
   (c rc)← c.PrevPrime2 n     ⍝ Like PrevPrime, but also returns rc: 2 yes, 1 likely, 0 none   
   rc← [a] c.Jacobi b         ⍝ Jacobi symbol (a/b): ¯1, 0 or 1. b must be odd (badAplÊ if even). 
   rc← [a] c.Invert m         ⍝ modular inverse (see §3)
```

PrevPrime relies on GMP's mpz\_prevprime (GMP 6.3+), which sets c to the greatest prime strictly less than n and itself returns 2, 1 or 0\. PrevPrime2 returns (mpz rc) where rc is ProbabPrime 24 applied to the previous prime just found; plain PrevPrime discards the GMP return code.

c is the number being tested for ProbabPrime, Jacobi (when a is omitted) and Divisible.

# **8\.  The GI operator: primitive-style, non-destructive**

GI wraps the methods so they read like APL primitives. Arguments are never modified; a new gmpz is returned (comparisons, monadic × and ≢ return plain integers). GI is also defined in the namespace that holds gmpz, so it can be used from anywhere.

```
    x← 2 *GI 100                   ⍝ 2*100 
    y← x +GI 1                     ⍝ x + 1 
    z← 10 |GI y                    ⍝ 10|y   (left is the modulus) 
    ⌷ !GI 30                       ⍝ factorial, shown as a string 
    7 <GI x                        ⍝ comparison → 0/1
```

| Dyadic | Meaning | Monadic | Meaning |
| :---- | :---- | :---- | :---- |
| `a +GI b` | a+b | `−GI b` | negate |
| `a −GI b` | a−b | `|GI b` | absolute value |
| `a ×GI b` | a×b | `?GI b` | random in \[0, b) |
| `a ÷GI b` | ⌊a÷b (floored) | `!GI b` | factorial |
| <code>a&nbsp;÷∘\|GI&nbsp;b</code> | DivRem (see note below) | `×GI b` | signum (plain integer) |
| `a *GI b` | a\*b (b may be ÷n) | `<GI b` | b−1 |
| `a ∨GI b` | gcd | `>GI b` | b+1 |
| `a ∧GI b` | lcm | `≢GI b` | string length (b.StrLen, plain integer) |
| `a \|GI b` | a\|b (a is the modulus) |   |   |
| `a ⌽GI b` | shift b by a bits |  |  |
| <code>a&nbsp;\*∘\|GI&nbsp;(e&nbsp;m)</code> | m\|a\*e (PowM) |  |  |
| `a ⍳GI i` | position of the lowest bit of a equal to i (0 or 1); largest U8 value if none (plain integer) |  |  |
| <code>a&nbsp;\<GI&nbsp;b</code> … | also ≤ \= ≥ \> ≠, returning 0 or 1 |  |  |
| `a ⊤GI b` | retrieve a string representation of **b** in base **a** | ⊤GI b | string version of b  |
| `a ⊥GI b`  | return a new (private) copy of **b** in base **a** | ⊥GI b | a private copy of b  |

Note: <code>(mpz mpz)← a ÷∘\|GI b</code> calls DivRem, returning <code>((a÷m), (m\|a))</code>, floored, both mpz's.

Use the gmpz methods directly when you want to avoid allocating a new object per operation. An unsupported glyph gives unknownÊ.

# **9\.  Errors**

Errors in public methods are trapped and re-signalled from your line, so ⎕DMX points at your code.

| Name | EN | Meaning |
| :---- | :---- | :---- |
| noGmpÊ | 22 | GMP library not found |
| gmpLoadÊ | 11 | A GMP routine failed to bind (library too old?) |
| badInitÊ | 11 | Unable to create object |
| badAplÊ | 11 | Invalid (non-integer) APL number |
| badObjÊ | 11 | Can't convert to a gmpz (e.g. bad string, released object) |
| badIntÊ | 11 | Too large for a 64-bit integer, or not an integer |
| badUIntÊ | 11 | Value not an APL non-negative integer |
| badBitValÊ | 11 | Bit value must be 0 or 1 |
| badBitIxÊ | 3 | Invalid (negative) bit index |
| divZÊ | 11 | Division by 0 |
| powÊ | 11 | Invalid power / root |
| shiftÊ | 11 | Shift value must be an integer |
| facBadÊ | 11 | Factorial of a negative integer, a non-integer, or a value over 2\*32-1 |
| primeÊ | 11 | Bad reps argument for ProbabPrime |
| randSeedÊ | 11 | Seed can't be converted to an unsigned integer |
| randÊ | 11 | Arg must be positive (Rand bound ≤ 0, or RandB bits \< 0\) |
| randStateÊ | 11 | Unable to initialise random \# state |
| unknownÊ | 11 | Unsupported glyph in GI |
| initLogicÊ | 911 | Internal logic error: only one randState instance is allowed. |

# **10\.  Quick reference and gotchas**

1. **In a c.Op b,** c is the destination and is overwritten and a is the left operand; in c.Op b the receiver is both the left operand and the destination.  
2. Res (\|) and Shift (⌽) require a left argument; most others default it to the receiver. Neg, Abs, Fac, NextPrime, PrevPrime, Rand and RandB take only a right argument.  
3. **Shy results:** Even, Odd, Divisible, DivRem, TestBit, SetBit, ClrBit, Flip, ProbabPrime, Rand, RandSeed and the in-place arithmetic methods print nothing in the session. Assign the result, or use ⎕←x.Even.  
4. **Pow exponent** must be a plain APL non-negative integer or ÷n (for roots). Negative exponents are invalid.  
5. **DivRem divisors** may be any supported operand type and must be non-zero (divZÊ if 0).  
6. Use ⌷a to see the final (string) value. It is more efficient to keep working with gmpz objects, so that no unnecessary conversions to and from gmpz are needed.  
7. Strings may use the high minus (¯) on input; it is converted to −.  
8. The base (2 through 62\) only matters when importing numeric strings; it is ignored for other operand types.  
9. a.Int only succeeds when the value fits a signed 64-bit integer; use VFI to test safely. Set ⎕FR←1287 in your session if you manipulate 64-bit integers.  

# 

# **Appendix: Encrypt a Hexadecimal Message**

Implement a simplified[^1] **RSA key generation, encryption, and decryption** workflow. This demonstrates the core lifecycle of GMP integers: initialization, random prime generation, modular arithmetic, modular inverse, and memory cleanup.

## **Example**
```
∇ ret←  GmpzExample msgIn 
⍝ Descr: Simplified 1024-bit RSA public-key encryption and decryption of Unicode string 
⍝        using the GNU Multiple Precision Arithmetic Library (GMP) via a wrapper (gmpz). 
⍝  To run: 
⍝    GmpzExample msg 
⍝  msgIn: An APL string 
⍝  Success if it returns (ret@CV) a happy message 
⍝  Note:  CV means character vector, mpz means GMP multiple precision integer  
⍝  0. Declare helper fn    ; HS   ⍝  1. Declare all mpz variables    
   ; p; q; n; phi; e; d; msg; cipher; decrypted 
⍝  1a. Helper fn ⍝  [⍺←1] HS str@CV: Apl Unicode (CV) [⍺=1 =>] ⇔ [<= ⍺=0] hexadecimal CV     
   HS←{          
      ⎕IO←0 ⋄ ⍺←1 ⋄ hd←⎕D,'abcdef' ⋄ U8← 'UTF-8'∘⎕UCS        
      ⍺=1:,hd[⍉16 16⊤U8 ⍵] ⋄ U8 16⊥hd⍳⍉t⍴⍨2,⍨2÷⍨≢t← ⎕C ⍵     
   }  
⍝  2. Initialize all variables (required before any operation)    
   p q n phi e d msg cipher decrypted← gmpz.New¨ 9⍴0   
⍝  Initialize random number generator with entropy ⍝  (automatically done when RandB is first called) 
⍝  ... 
⍝  3. Generate two distinct 512-bit probable primes (p and q)     
⍝  p...    
   p.(NextPrime RandB 512) 
⍝  q...    
   :Repeat         ⍝ Ensure p ≠ q       
      q.(NextPrime RandB 512)    
   :Until q.Ne p   
⍝  4. Compute the  modulus n: n ← p × q (1024-bit)    
   p n.Mul q  
⍝  5. Compute Euler's totient: phi← (p - 1) × (q - 1)    
   p.Dec phi.Mul q.Dec          ⍝ p is now p-1, q is now q-1   
⍝  6. Set public exponent e = 65537 and compute private exponent (d← e*-1 mod phi)    
    e.Set 65537                  ⍝ 1+2*16    
    :IF 0= e d.Invert phi     ⍝ Are e and phi coprime?        
       ret← 'Error: e and phi are not coprime.'       
       :return    
   :EndIf 
⍝  7. Encode the input Unicode msgIn into the mpz ¨msg¨ via hex helper fn ¨HS¨    
   16 msg.Set HS msgIn  
⍝     Ensure message isn't too big (Len, # of bits) for the demo. 
⍝     In real life, we'd process large messages a section at a time ;-(    
   :IF msg.Len ≥ n.Len        
       ⎕← 'Message is too large' ⋄ :Return     
   :EndIf  
⍝  8. Encrypt: cipher = (msg * e) mod n    
   msg cipher.PowM e n 
⍝  9. Decrypt: decrypted = (cipher * d) mod n    
   cipher decrypted.PowM  d n 
⍝ 10. Print results     
   ⎕← 'Input message:      ', msg     
   ⎕← 'Public Modulus (n): ', ⌷n    
   ⎕← 'Encrypted Cipher:   ', ⌷cipher    
   ⎕← 'Decrypted Message:  ', 0 HS decrypted.GetInBase 16   
⍝ 11. Verify correctness    
   :IF 0= msg.Cmp decrypted        
       ret← 'Success: Decrypted message matches original'    
   :Else        
       ret← 'Failure: Decrypted message does not match original'    
   :EndIf 
⍝ 11. Free all allocated memory  
⍝     gmpz does it all for you!  
⍝  . . . 
∇
``` 

### OUTPUT [^2] 
```
      GmpzExample  '🙂 This is a cat 🙂'                  
Input message:      🙂 This is a cat 🙂    
Public Modulus (n): 17423688898927617259201626411325686…   
Encrypted Cipher:   88307460760761788632490902262327645…   
Decrypted Message:  🙂 This is a cat 🙂                    
Unicode out! Success: Decrypted message matches original
``` 

[^1]:  RSA encryption is still useful today, provided you use 2048- or, preferably, 4096-bit encryption. 
[^2]:  The output is abridged on right (`…)` for pedagogical purposes.