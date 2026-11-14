:Namespace gmpLib 
   ⎕IO ⎕ML ⎕PP← 0 1 34 
   NUL← ⎕UCS 0 
   
⍝ Big-integer arithmetic on strings, backed by GMP.
⍝ Direct:      '12345678901234567890' Gmp.Mul 2
⍝ Via _Call:   '12345678901234567890' ×Gmp._Call 2        (same as Gmp.Mul)
⍝ Self-test:   Gmp.Test                                    (1 if all pass)
⍝
⍝ Conventions
⍝   Div  truncates toward zero (mpz_tdiv_q); Rem is its remainder (sign of dividend, GMP arg order)
⍝   Mod  is APL's |  : ⍺ Mo]d ⍵ is floored, sign follows ⍺ (mpz_fdiv_r), and 0 Mod x is x
⍝   Root / Pow ÷n    truncate (floor of the true root)
⍝   Shift: n⌽x       left for n>0, right (truncating) for n<0
   
   :Namespace libG 
   ⍝   Will hold APL names of GMP functions
   :EndNamespace 
   
   ⍝:Section Global Error Handling
      SigÊ← ⎕SIGNAL { ⊂ ⎕DMX.('EN' EN ⋄ 'EM' EM ⋄ 'Message' Message )} 
      badStrÊ← ⊂('EN' 11 ⋄ 'Message' 'Invalid numeric string')
      uIntÊ←   ⊂('EN' 11 ⋄ 'Message' 'Expected a non-negative integer')
      divÊ←    ⊂('EN' 11 ⋄ 'Message' 'Divide by 0')
      nfÊ←     ⊂('EN' 22 ⋄ 'Message' 'Gmp library not found') 
      powÊ←    ⊂('EN' 11 ⋄ 'Message' 'Power  exponent must be a positive (or odd negative) Apl integer')
      randÊ←   ⊂('EN' 11 ⋄ 'Message' 'Random requires a positive argument')
      rootÊ←   ⊂('EN' 11 ⋄ 'Message' 'Root must be a positive (or odd negative) Apl integer')
      shiftÊ←  ⊂('EN' 11 ⋄ 'Message' 'Shift amount must be an Apl integer')
      sqrtÊ←   ⊂('EN' 11 ⋄ 'Message' 'Sqrt of a negative number')
      factÊ←   ⊂('EN' 11 ⋄ 'Message' 'Factorial of a negative integer')    ⍝ 
      primeÊ←  ⊂('EN' 11 ⋄ 'Message' 'ProbabPrime requires nreps of tests in opt''l left arg, usu. 15-50')
      notYetÊ← ⊂('EN' 11 ⋄ 'Message' 'Function not implemented') 
   ⍝:EndSection Global Error Handling
   
   ⍝:Section Global Helper Fns 
      NoLB← { ⍺← ' ' ⋄ ⍵↓⍨ +/∧\ ⍵= ⍺}                                      ⍝ Remove leading blanks (or other chars)
      IsI← { 0= ⊃0⍴⍵: ⍵=⌊⍵ ⋄ 0 }                                           ⍝ (I) Is it An APL Integer/Real convertible to a long  
      IsU← { 0= ⊃0⍴⍵: (⍵≥0)∧ ⍵=⌊⍵ ⋄  0 }                                   ⍝ (U) Is it An Apl Int ≥0    
   ⍝  Canon:  flipSign[←0]  ∇  obj@CV|N
   ⍝  Remove leading 0s, blanks, after validating proper integer format.
   ⍝  If ⍺=1, "flips the sign".
   ⍝  Typically substantially faster than passing to GMP to check
   ⍝  Returns actual APL integers or pseudo-integers as APL integers .
      Canon← {  ⍺← 0  
        IsI  ⍵:  ⍵ × ¯1* ⍺                                                 ⍝ Integer or Real->Long? As Is 
        (0≠ 80| ⎕DR ⍵)∨ 0=≢⍵: ⎕SIGNAL badStrÊ                              ⍝ Not a string
         u↓⍨← s← '-¯'∊⍨ ⊃u← NoLB ⍵                                         ⍝ Set sign (s←1) and unsigned portion u if first non-blank is ¯ or -
        s∧ ' '= ⊃u: ⎕SIGNAL badStrÊ                                        ⍝ Sign char may not be followed by blank: '- 3' (BAD)
         u← '0' NoLB u~ ' '                                                ⍝ Remove embedded blanks and leading zeroes '0' 
        0=≢u: '0'                                                          ⍝ All 0s in U? Return '0' 
        ~∧/ u∊ ⎕D: ⎕SIGNAL badStrÊ                                         ⍝ Any non numerals in u? Error!
         ('-'/⍨ s≠⍺),u                                                     ⍝ Return signed canonical int string 
      }
   ⍝  A zero: numeric 0, or a string holding at least one '0' and nothing but 0, blank, minus
      IsZ←  { IsI ⍵: ⍵=0 ⋄ (∨/⍵='0')∧ ∧/⍵∊ '0 -¯' }
      _Dyad←  { 0:: SigÊ 0 ⋄ ⍺ ⍺⍺{ zC← ⍺⍺ ⍵  ⋄ (Fmt zC)zC}  _ICM⍥⍕ ⍵}
      _Dyad_← { 
        0:: SigÊ 0 
        IsU ⍵: ⍺ ⍕⍛( ⍵⍵{ zC← ⍺⍺ ⍵  ⋄ (Fmt zC)zC }  _ICM ) ⍵ 
         ⍺ ⍺⍺{ zC← ⍺⍺ ⍵  ⋄ (Fmt zC)zC }  _ICM⍥⍕ ⍵ 
      }
      _DivRem← {0:: SigÊ 0 
        IsZ ⍵: ⎕SIGNAL divÊ 
         ⍺ ⍺⍺ { zC← ⍺⍺ ⍵  ⋄ (Fmt zC)zC } _ICM⍥⍕ ⍵
      }
   ⍝:EndSection Global Helper Fns
   
   ∇ {ok}← LoadLib; sysLib
      :If 3= libG.⎕NC'Clear' ⋄ :Return ⋄ :EndIf                            ⍝ clear is bound last
      ok← 0 
      :For sysLib :In (
            '/opt/homebrew/opt/gmp/lib/libgmp.dylib' 
            '/usr/local/opt/gmp/lib/libgmp.dylib' 
            'libgmp.dylib'
            'libgmp.10.dylib'
            'libgmp.so.10'
            '/usr/lib/x86_64-linux-gnu/libgmp.so.10'
            '/usr/lib/aarch64-linux-gnu/libgmp.so.10'
            '/usr/lib64/libgmp.so.10'
            'libgmp-10.dll'
         )
         :Trap 0
            'InitSetStr' libG.⎕NA 'I4 ',sysLib,'|__gmpz_init_set_str =I8[2] <C1[] I4'
            ok← 1 ⋄ :Leave  
         :EndTrap
      :EndFor
      ⎕SIGNAL nfÊ/⍨ ~ok 
      
   ⍝ These traps are ignored in a ⎕FIX or ]Load, but not when LoadLib called directly
      :Trap 6 11 102                      
         'Add'  libG.⎕NA sysLib,'|__gmpz_add         =I8[2] <I8[2] <I8[2]'
         'AddU' libG.⎕NA sysLib,'|__gmpz_add_ui      =I8[2] <I8[2] U8'
         'Sub'  libG.⎕NA sysLib,'|__gmpz_sub         =I8[2] <I8[2] <I8[2]'
         'SubU' libG.⎕NA sysLib,'|__gmpz_sub_ui      =I8[2] <I8[2] U8'
         'Mul'  libG.⎕NA sysLib,'|__gmpz_mul         =I8[2] <I8[2] <I8[2]'
         'MulU' libG.⎕NA sysLib,'|__gmpz_mul_ui      =I8[2] <I8[2] U8 '
         'Div'  libG.⎕NA sysLib,'|__gmpz_tdiv_q      =I8[2] <I8[2] <I8[2]' ⍝ Truncated division
         'DivU' libG.⎕NA sysLib,'|__gmpz_tdiv_q_ui   =I8[2] <I8[2] U8'     ⍝ Truncated division
         'Rem'  libG.⎕NA sysLib,'|__gmpz_tdiv_r      =I8[2] <I8[2] <I8[2]' ⍝ Truncated remainder
         'FRem' libG.⎕NA sysLib,'|__gmpz_fdiv_r      =I8[2] <I8[2] <I8[2]' ⍝ Floored remainder
         'Gcd'  libG.⎕NA sysLib,'|__gmpz_gcd         =I8[2] <I8[2] <I8[2]'
         'Lcm'  libG.⎕NA sysLib,'|__gmpz_lcm         =I8[2] <I8[2] <I8[2]'
         
         'Root' libG.⎕NA'I4 ',sysLib,'|__gmpz_root =I8[2] <I8[2] U8'       ⍝ *∘0.5. If returned non-zero, is exact 
         'Pow'  libG.⎕NA sysLib,'|__gmpz_pow_ui    =I8[2] <I8[2] U8'       ⍝ *⍵@I, ⍵>1, 0≤⍵≤1.
         'Cmp'  libG.⎕NA'I4 ',sysLib,'|__gmpz_cmp  <I8[2] <I8[2]'          ⍝ ⍺ compared to ⍵.
         
         'ShiftL'  libG.⎕NA sysLib,'|__gmpz_mul_2exp    =I8[2] <I8[2] U8'  ⍝ Shift left by n bits 
         'ShiftR'  libG.⎕NA sysLib,'|__gmpz_tdiv_q_2exp =I8[2] <I8[2] U8'  ⍝ Shift right by n bits 
         
      ⍝ Function: void mpz_nextprime (mpz_t rop, const mpz_t op)
         'NextPrime' libG.⎕NA sysLib,'|__gmpz_nextprime  =I8[2] <I8[2]' 
      ⍝ mpz_prevprime (mpz_t rop, const mpz_t op)
      ⍝ Return 1 if rop is a probably prime, and 2 if rop is definitely prime.
         'PrevPrime' libG.⎕NA 'I4 ',sysLib,'|__gmpz_prevprime =I8[2] <I8[2]' 
      ⍝ int mpz_probab_prime_p (const mpz_t n, int reps)
      ⍝ Return 1 if rop is a probably prime, and 2 if rop is definitely prime.
         'ProbabPrime' libG.⎕NA 'I4 ',sysLib,'|__gmpz_probab_prime_p  <I8[2] U8' 
         
         'Fact' libG.⎕NA sysLib,'|__gmpz_fac_ui    =I8[2] U8'              ⍝ !⍵
         'Sqrt' libG.⎕NA sysLib,'|__gmpz_sqrt      =I8[2] <I8[2]'          ⍝ *∘0.5. Truncated root
         
         'SizeInBase' libG.⎕NA'U8 ',sysLib,'|__gmpz_sizeinbase <I8[2] I4' 
         'GetStr' libG.⎕NA'P ',sysLib,'|__gmpz_get_str =C1[] I4 <I8[2]'
         'Clear' libG.⎕NA sysLib,'|__gmpz_clear <I8[2]'
      :Else 
         'Error loading Gmp library routine(s)' ⎕SIGNAL 11 
      :EndTrap 
   ∇
   LoadLib 
   
   ∇ ok← LoadUserFns
      ⍝:Section Dyadic Functions 
         Add← libG.Add  _Dyad_ libG.AddU                                   ⍝ Optimises if ⍵ is Apl Integer >0
         Sub← libG.Sub  _Dyad_ libG.SubU                                   ⍝ ditto 
         Mul← libG.Mul  _Dyad_ libG.MulU                                   ⍝ ditto 
         Div← libG.Div  _Dyad_ libG.DivU                                   ⍝ ditto  
         Gcd← libG.Gcd  _Dyad 
         Lcm← libG.Lcm  _Dyad 
         Rem← libG.Rem  _DivRem              
      ⍝ APL's ⍺|⍵: ⍺ is the divisor, result is floored (sign of ⍺); 0|⍵ is ⍵
         Mod← { 
           0:: SigÊ 0 
           IsZ ⍺: ⍵ Add 0 
            ⍵ (libG.FRem _DivRem) ⍺ 
         }
      ⍝  Pow:  Either  10*3 (power) or 10*÷3 (root)
         Pow← {     
           0:: SigÊ 0 
           0≠ ⊃0⍴ ⍵: ⎕SIGNAL powÊ ⋄ ⍵< 0:  ⎕SIGNAL powÊ
           ⍵= ⌊⍵: ⍺ ⍕⍛({ zC← libG.Pow ⍵ ⋄ (Fmt zC)zC }  _ICM) ⍵
         ⍝ Integral Inverse: Do root
           inv≠ ⌊inv← ÷⍵ : ⎕SIGNAL powÊ
           (¯1= Sig ⍺)∧ 0=2| inv : ⎕SIGNAL powÊ
            ⍺ ⍕⍛({ rc zC← libG.Root ⍵ ⋄ (Fmt zC)zC }  _ICM) inv  
         }
         Shift← {     
           0:: SigÊ 0 
           ~IsI ⍵: ⎕SIGNAL shiftÊ 
           ⍵≠⌊⍵: ⎕SIGNAL shiftÊ
           ⍵>0: ⍺ ⍕⍛( { zC← libG.ShiftL ⍵ ⋄ (Fmt zC)zC }  _ICM) ⍵
           ⍵<0: ⍺ ⍕⍛( { zC← libG.ShiftR ⍵ ⋄ (Fmt zC)zC }  _ICM) -⍵
         ⍝  Conservative return would be ⍺ in canonical form:   Canon ⍺
            ⍺                                                              ⍝ zero shift. Return as is  
         }
         Rotate← Shift⍨
         Root← {                                                           ⍝ Root(10 N) => 10*÷N 
           0:: SigÊ 0 
           ~IsI ⍵: ⎕SIGNAL rootÊ 
           (⍵<1)∨ ⍵≠ ⌊⍵: ⎕SIGNAL rootÊ                                     ⍝ n=0 would divide by zero in GMP
           (¯1= Sig ⍺)∧ 0=2|⍵: ⎕SIGNAL rootÊ                               ⍝ even root of negative aborts GMP
            ⍺ ⍕⍛({ rc zC← libG.Root ⍵ ⋄ (Fmt zC)zC }  _ICM) ⍵
         }
      ⍝ rc← [cycles] ProbabPrime bigint
      ⍝      cycles: Reasonable values of reps are between 15 and 50.
      ⍝ Beware: GMP args are in reverse order
      ⍝ Return 2 if n is definitely prime,
      ⍝ return 1 if n is probably prime (without being certain), or
      ⍝ return 0 if n is definitely non-prime.
         ProbabPrime← { 
            ⍺← 15                                                          ⍝  usu. 15 - 50
           0:: SigÊ 0     
           ~IsI ⍺: ⎕SIGNAL primeÊ
            ⍵ ⍕⍛{ zC← libG.ProbabPrime 1↓⍵ ⋄ zC (0⊃⍵)} _ICM ⍺
         }
         Cmp← { 
           0:: SigÊ 0 
            ⍺ { zC← ×libG.Cmp 1↓ ⍵  ⋄ zC (0⊃⍵)   }  _ICM⍥⍕ ⍵
         }
         _Cmp← { (⍺ Cmp ⍵)⍺⍺ 0 }                                           ⍝  ⍺ =_Cmp ⍵, etc.
         Eq← =_Cmp 
         Lt← <_Cmp
         Le← ≤_Cmp 
         Gt← >_Cmp
         Ge← ≥_Cmp 
         Max← { 0:: SigÊ 0 ⋄ (⍺ Ge ⍵)⊃ (⍵ Add 0)(⍺ Add 0) }
         Min← { 0:: SigÊ 0 ⋄ (⍺ Le ⍵)⊃ (⍵ Add 0)(⍺ Add 0) }
         
      ⍝:EndSection Dyadic Functions     
      
      ⍝:Section Monadic Functions 
         NegA← { ⍕1 Canon ⍵ }                                              ⍝ -⍵ 
         
         Abs←  { '-'≠ ⊃s← ⍕Canon ⍵: s ⋄ 1↓s }                              ⍝ |⍵ 
         
      ⍝   Rand:  Rand ⍵
      ⍝   Generate a random number between 0 and ⍵-1, where ⍵ is a positive big-integer or int.
      ⍝   (Done in APL)
      ⍝ When ⎕FR ← 1287 (128-bit Decimal Floating-Point),
      ⍝ the maximum integer argument to ? roll is ( ¯1+ 2*63 ), i.e. a 64-bit signed integer.
      ⍝ We round down to to one less decimal digit.
         randMax randWid← { 
            ⎕FR← 1287  ⋄ w← ¯1+≢⍕¯1+2*63   ⋄  (⊃⌽⎕VFI '1',w⍴'0') w 
         } 0                                   
         Rand← { ⎕FR← 1287                                                 ⍝ Needed for ⎕VFI returning 34 digits
           0:: SigÊ ⍬
            s← Canon ⍕⍵
           '-0'∊⍨ ⊃s: ⎕SIGNAL randÊ                                        ⍝ Only positive integers
            n← ≢s ⋄ k← ⌈n÷ rw← randWid
            w← (n- rw× k- 1), (k- 1)⍴ rw
            d← ⊃⌽⎕VFI ∊' ',¨ ( (⍳n)∊ 0,¯1↓+\w )⊂ s                         ⍝ bound, one integer per chunk
           k= 1: ⍕?⊃d                                                      ⍝ single chunk: ? gives [0,N) directly, no rejection
            b← 10*w
            try← {                                                         ⍝ ⍵: chunk index; chunks, or ⍬ on reject
              ⍵= k: ⍬                                                      ⍝ all chunks equal the bound → value = bound → reject
               r← ?⍵⊃ b ⋄ t← ⍵⊃ d
              r< t: r, ?b↓⍨ ⍵+ 1                                           ⍝ already below: remaining chunks are free
              r> t: ⍬                                                      ⍝ above: reject
               q← ∇⍵+1 ⋄ 0= ≢q: ⍬ ⋄ r, q                                   ⍝ tie: decide on the next chunk
            }
            gen← {q← try 0 ⋄ 0= ≢q: ∇⍬ ⋄ q}                                ⍝ retry until a full set of chunks is accepted
            r← '0' NoLB ∊(1↓ ⍕)¨ b+ gen ⍬
           0= ≢r: '0' ⋄ r
         }
         
      ⍝  Sig:
      ⍝  Using Cmp is much slower:
      ⍝        Sig← { 0:: SigÊ 0 ⋄ ⍵ Cmp '0'}
         Sig← { f← ⊃s← ⍕Canon ⍵ ⋄ '0'= f: 0 ⋄ '-'= f: ¯1 ⋄ 1 }             ⍝  Signum ×⍵  
         
         Sqrt← { 
           0:: SigÊ 0 
           ¯1= Sig ⍵: ⎕SIGNAL sqrtÊ                                        ⍝ GMP aborts on negatives
            ({ zC← libG.Sqrt ⍵ ⋄ (Fmt zC)zC } _ICM) ⍕⍵ 
         }
         
         Fact← { 
           0:: SigÊ 0 
           ~IsI ⍵: ⎕SIGNAL factÊ
           (⍵<0)∨ ⍵≠⌊⍵: ⎕SIGNAL factÊ
            ({ zC← libG.Fact ⍵ ⋄ (Fmt zC)zC } _ICM) ⍵ 
         }
         
      ⍝  NextPrime ⍵: Returns the next pseudoprime after ⍵
         NextPrime← {
           0:: SigÊ 0 
            ({ zC← libG.NextPrime ⍵ ⋄ (Fmt zC)zC } _ICM) ⍕⍵ 
         }
         
      ⍝  PrevPrime:  rc prev← PrevPrime ⍵:
      ⍝  Returns the pseudoprime previous to ⍵. Certain: rc=2; Likely: rc=1; None: 0.
         PrevPrime← {
           0:: SigÊ 0 
            ({ rc zC← libG.PrevPrime ⍵ ⋄ (rc,⍥⊂ Fmt zC)zC } _ICM) ⍕⍵ 
         }
         
         Inc← 1 Add⍨⊢
         Dec← 1 Sub⍨⊢ 
      ⍝:EndSection Monadic Functions 
      
      ok← 1 
   ∇ 
   LoadUserFns
   
   ∇ t2← LoadOpTables 
      dyadTbl← ⍉↑(
         '+' (⎕OR 'Add') 
         '-' (⎕OR 'Sub') 
         '×' (⎕OR 'Mul')
         '÷' (⎕OR 'Div')
         '*' (⎕OR 'Pow')
         '|' (⎕OR 'Mod')
         '⌽' (⎕OR 'Rotate')
         '∨' (⎕OR 'Gcd')
         '∧' (⎕OR 'Lcm')
         '⌈' (⎕OR 'Max')
         '⌊' (⎕OR 'Min')
         
         '=' (⎕OR 'Eq')
         '<' (⎕OR 'Lt')
         '≤' (⎕OR 'Le')
         '>' (⎕OR 'Gt')
         '≥' (⎕OR 'Ge')
      )  
      monadTbl← ⍉↑(
         '-' (⎕OR 'NegA') 
         '×' (⎕OR 'Sig')
         '|' (⎕OR 'Abs')
         '!' (⎕OR 'Fact')
         '>' (⎕OR 'Inc')
         '<' (⎕OR 'Dec')
         '?' (⎕OR 'Rand')
      )  
      t2← dyadTbl monadTbl
   ∇ 
   opTables← LoadOpTables 
   
   Parse← { 
      s← '-'@('¯'∘=)⊢ ,⍵                                                   ⍝ APL high minus → ASCII
      libG.InitSetStr (2⍴0) (s, NUL) 10                                    ⍝ explicitly NUL-terminated
   }
   
   Fmt← { 
      n← 2+ libG.SizeInBase ⍵ 10                                           ⍝ digits + possible sign + NUL
      buf← n⍴ NUL 
      (ptr buf)← libG.GetStr buf 10 ⍵
      buf↑⍨ buf⍳ NUL                                                       ⍝ keep text before the first NUL
   } 
   
   _FnNm← { 
      f← ⍺⍺ ⋄ 3= ⎕NC 'f': ⍬⍴⎕NR 'f' ⋄ ⊂⎕C f 
   }  
   
   _Call← { 
      monad← 0= ⎕NC '⍺' ⋄ ⍺← ⊢ 
     0:: SigÊ 0 
      tbl← monad⊃ opTables 
      src← tbl[0;]⍳ nm← ⍺⍺ _FnNm ⍬  
     src= ≢tbl[0;]:  ⎕SIGNAL notYetÊ                                 
      Fn← src⊃ tbl[1;] 
      ⍺ (Fn{⍺← ⊢ ⋄ ⍺ ⍺⍺ ⍵}) ⍵ 
   }
   ##.GI← ⎕THIS._Call 
   
⍝  Internal call mechanism
⍝    Op is called as  (c zC)← Op zC zA zB.  Monadic calls set zA to the function ,⍥⊂, so that
⍝    "zC zA zB" evaluates to the 2-vector (zC zB), which is what mpz_sqrt / mpz_fac_ui take.
⍝    Every mpz that has been initialised is in q, so every exit path (including errors) clears it.
   ∇ c← {a} (Op _ICM) b
        ; êmsg; ên; q; rcA; rcB; zA; zB; zC; _
      :Trap 0
         q← ⍬ 
         :If ~900⌶⍬                                                        ⍝ Dyadic Call
            (rcA zA)← Parse a ⋄ q,← ⊂zA                                    ⍝ initialised even if rcA≠0
         :Else                                                             ⍝ Monadic Call 
            rcA← 0 ⋄ zA← ,⍥⊂                                               ⍝ Ignore zA
         :EndIf 
         :If 0≠ ⊃0⍴ b                                                      ⍝ Is b a string?
            (rcB zB)← Parse b ⋄ q,← ⊂zB                                    ⍝ b must be a big int 
         :Else 
            zB← ⍬⍴ b ⋄ rcB← 0                                              ⍝ b is an unsigned long 
            :If (zB≠⌊zB)∨ zB<0 ⋄ ⎕SIGNAL uIntÊ ⋄ :EndIf
         :EndIf
         :If ∨/rcA rcB≠ 0 
            ⎕SIGNAL badStrÊ
         :EndIf
         (_ zC)← Parse'0'                                                  ⍝ Initialise zC 
         q,← ⊂zC                                                           ⍝ cleared even if Op fails 
         (c zC)← Op zC zA zB                                               ⍝ Now set (c zC) per Op.                                            
         (⊃q)← zC                                                          ⍝ Op may have reallocated zC
         ên← 0                    
      :Else 
         ên êmsg← ⎕DMX.( EN Message )
      :EndTrap
      {}libG.Clear∘⊂¨ q                                                    ⍝ Release all Gmp objects 
      :If ên≠0 ⋄ ⎕SIGNAL⊂('EN' ên)('Message' êmsg) ⋄ :EndIf
   ∇
   
⍝  Self-test: returns 'All tests passed!' if everything passed; prints each failure
   ∇ r← Test; cases; errs; t; e; got
      r← 'All tests passed!'
      cases← (
         ('2 Add 3'                                         '5')
         ('''99999999999999999999'' Add 1'                  '100000000000000000000')
         ('7 Sub 10'                                        '-3')
         ('''12345678901234567890'' Mul 10'                 '123456789012345678900')
         ('''100'' Div 7'                                   '14')
         ('''-7'' Rem 3'                                    '-1')
         ('3 Mod ¯7'                                        '2')
         ('0 Mod 5'                                         '5')
         ('12 Gcd 18'                                       '6')
         ('4 Lcm 6'                                         '12')
         ('2 Pow 100'                                       '1267650600228229401496703205376')
         ('''1000'' Root 3'                                 '10')
         ('''1000'' Pow ÷3'                                 '10')
         ('1 Shift 70'                                      '1180591620717411303424')
         ('''1180591620717411303424'' Shift ¯68'            '4')
         ('5 Shift 0'                                       '5')
         ('Sqrt 99'                                         '9')
         ('Fact 20'                                         '2432902008176640000')
         ('NegA ''0'''                                      '0')
         ('NegA ''5'''                                      '-5')
         ('Abs ''-5'''                                      '5')
         ('Sig ''0'''                                      0)
         ('Sig ''-5'''                                     ¯1)
         ('Sig 7'                                          1)
         ('3 Lt 5'                                          1)
         ('''10'' Cmp 9'                                    1)
         ('5 Eq 5'                                          1)
         ('1 Max 2'                                         '2')
         ('1 Min 2'                                         '1')
         ('2 +_Call 3'                                      '5')
         ('-_Call ''5'''                                    '-5')
      )
      :For (t e) :In cases
         ⎕← 'Case: ',t 
         got← ⍎t
         :If ~(,e)≡,got
            ⎕← 'FAIL: ',t,'   expected ',(⍕e),'   got ',⍕got 
            r← 0
         :EndIf
      :EndFor
      
      errs← '5 Div 0' '5 Div ''0''' 'Sqrt ¯4' 'Fact ¯1' '''abc'' Add 1' '''-8'' Root 2' '5 Root 0' '1.5 Shift 2' 
      :For t :In errs
         :Trap 11
            got← ⍎t
            ⎕← 'FAIL (no error): ',t
            r← 0
         :EndTrap
      :EndFor
   ∇
   
  :Class Int
   :Field Private ptr ← 0                                                  ⍝ address of the mpz_t; 0 = nothing live
      
      ∇ Int args; str; base; rc
      : Access Public
      : Implements Constructor
      ⍝ args: string (base 10), or (string base)
         :If (2=≢args) ∧ (2=≡args) ⋄ str base ← args ⋄ :Else ⋄ str ← args ⋄ base ← 10 ⋄ :EndIf
         ptr ← c_malloc 16                                                    ⍝ mpz_t is 16 bytes on 64-bit
         :If ptr=0 ⋄ ⎕SIGNAL 11 ⋄ :EndIf                                      ⍝ malloc failed
         rc ← gmp_init_set_str ptr (⊂str) base
         :If rc≠0
            gmp_clear ptr ⋄ c_free ptr ⋄ ptr ← 0
            ⎕SIGNAL 11                                                        ⍝ DOMAIN ERROR: invalid number string
         :EndIf
      ∇
      
      ∇ Free
      : Implements Destructor
         :If ptr≠0
            gmp_clear ptr ⋄ c_free ptr ⋄ ptr ← 0
         :EndIf
      ∇
      
      ∇ s ← Str; base; n; buf; p; bytes
      : Access Public
         :If ptr=0 ⋄ ⎕SIGNAL 11 ⋄ :EndIf
         base ← 10
         n ← gmp_sizeinbase ptr base
         buf ← n+2                                                            ⍝ digits + sign + null
         p ← gmp_get_str 0 base ptr                                           ⍝ GMP allocates the string
         bytes ← strncpy buf p buf
         c_free p                                                             ⍝ valid with GMP's default (malloc) allocator
         s ← 'UTF-8' ⎕UCS bytes
      ∇
:EndClass

:EndNamespace
