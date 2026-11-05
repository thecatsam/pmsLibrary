:Namespace gmpLib 
   ⎕IO ⎕ML ⎕PP ⎕FR← 0 1 34 1287 
   NUL← ⎕UCS 0 
   
⍝ Big-integer arithmetic on strings, backed by GMP.
⍝ Direct:      '12345678901234567890' Gmp.Mul 2
⍝ Via _Call:   '12345678901234567890' ×Gmp._Call 2        (same as Gmp.Mul)
⍝ Self-test:   Gmp.Test                                    (1 if all pass)
⍝
⍝ Conventions
⍝   Div  truncates toward zero (mpz_tdiv_q); Rem is its remainder (sign of dividend, GMP arg order)
⍝   Residue  is APL's |  : ⍺ Residue ⍵ is floored, sign follows ⍺ (mpz_fdiv_r), and 0 Residue x is x
⍝   Root / Pow ÷n    truncate (floor of the true root)
⍝   Shift: n⌽x       left for n>0, right (truncating) for n<0
   
   :Namespace libG 
   ⍝   Will hold APL names of GMP functions
   :EndNamespace 
   
   ⍝:Section Global Error Handling
      SigÊ← ⎕SIGNAL { ⊂ ⎕DMX.('EN' EN ⋄ 'EM' EM ⋄ 'Message' Message )} 
      Err←  { ⊂('EN' ⍺)('Message' ⍵) }                               ⍝ en Err msg  → ⎕SIGNAL-able spec
      badStrÊ← 11 Err 'Invalid numeric string'
      uIntÊ←   11 Err 'Expected a non-negative integer'
      divÊ←    11 Err 'Divide by 0'
      nfÊ←     22 Err 'Gmp library not found'
      powÊ←    11 Err 'Power exponent must be a non-negative Apl integer or ÷ a positive one (odd, if base is negative)'
      randÊ←   11 Err 'Random requires a positive argument'
      rootÊ←   11 Err 'Root must be a positive (or odd negative) Apl integer'
      shiftÊ←  11 Err 'Shift amount must be an Apl integer'
      sqrtÊ←   11 Err 'Sqrt of a negative number'
      factÊ←   11 Err 'Factorial of a negative integer'
      primeÊ←  11 Err 'ProbabPrime requires nreps of tests in opt''l left arg, usu. 15-50'
      notYetÊ← 11 Err 'Function not implemented'
   ⍝:EndSection Global Error Handling
   
   ⍝:Section Global Helper Fns 
      NoLB← { ⍺← ' ' ⋄ ⍵↓⍨ +/∧\ ⍵= ⍺}                              ⍝ Remove leading blanks (or other chars)
      IsI← { 0= ⊃0⍴⍵: ⍵=⌊⍵ ⋄ 0 }                                   ⍝ (I) Is it An APL Integer/Real convertible to a long  
      IsU← { 0= ⊃0⍴⍵: (⍵≥0)∧(⍵=⌊⍵)∧ ⍵<2*64 ⋄ 0 }                   ⍝ (U) Is it An Apl Int in 0..2*64-1 (fits a U8) 
   ⍝  A zero: numeric 0, or a string holding at least one '0' and nothing but 0, blank, minus
      IsZ←  { IsI ⍵: ⍵=0 ⋄ ('0'∊⍵)∧ 0=≢⍵~'0 ¯-' } 
      
   ⍝  _G:  Guard operator.  Any error in ⍺⍺ is re-signalled via SigÊ (clean stack, same EN/Message).
   ⍝  Replaces a "0:: SigÊ 0" line in each function:   Fn← { ... } _G
      _G←  { ⍺← ⊢ ⋄ 0:: SigÊ 0 ⋄ ⍺ ⍺⍺ ⍵ }
      
   ⍝  Canon:  flipSign[←0]  ∇  obj@CV|N
   ⍝  Remove leading 0s, blanks, after validating proper integer format.
   ⍝  If ⍺=1, "flips the sign".
   ⍝  Typically substantially faster than passing to GMP to check
   ⍝  Leaves APL integers or APL pseudo-integers as is (but changing sign if ⍺=1)
      Canon← {  ⍺← 0  
        IsI  ⍵:  ⍵ × ¯1* ⍺                                         ⍝ Integer or Real->Long? As Is 
        (0≠ 80| ⎕DR ⍵)∨ 0=≢⍵: ⎕SIGNAL badStrÊ                      ⍝ Not a string
         u↓⍨← s← '-¯'∊⍨ ⊃u← NoLB ⍵                                 ⍝ Set sign (s←1) and unsigned portion u if first non-blank is ¯ or -
        s∧ ' '= ⊃u: ⎕SIGNAL badStrÊ                                ⍝ Sign char may not be followed by blank: '- 3' (BAD)
         u← '0' NoLB u~ ' '                                        ⍝ Remove embedded blanks and leading zeroes '0' 
        0=≢u: '0'                                                  ⍝ All 0s in U? Return '0' 
        ~∧/ u∊ ⎕D: ⎕SIGNAL badStrÊ                                 ⍝ Any non numerals in u? Error!
         ('-'/⍨ s≠⍺),u                                             ⍝ Return signed canonical int string 
      }
      
   ⍝  Error trapping is done once, by _G, where the user-facing function is defined.
      _CoreICM← { ⍺←⊢ ⋄ ⍺ ⍺⍺ { FmtG ⊃⍵ ⊣ ⍺⍺ ⍵ } _ICM ⍵ }
      _Dyad←  { ⍺ ⍺⍺ _CoreICM⍥⍕ ⍵ }
      _Dyad_← { 
        IsU ⍵: ⍺ ⍕⍛( ⍵⍵  _CoreICM ) ⍵ 
         ⍺ ⍺⍺  _CoreICM⍥⍕ ⍵ 
      }
      _DyadNZ_← {                                                   ⍝ Like Dyad_, but checks for zeroes first.
         IsZ ⍵: ⎕SIGNAL divÊ 
        IsU ⍵: ⍺ ⍕⍛( ⍵⍵  _CoreICM ) ⍵ 
         ⍺ ⍺⍺ _CoreICM⍥⍕ ⍵ 
      } 
      _MonadNZ← {
         IsZ ⍵: ⎕SIGNAL divÊ 
         ⍺ ⍺⍺ _CoreICM⍥⍕ ⍵
      }
   ⍝:EndSection Global Helper Fns
   
   ∇ {ok}← LoadLib; sysLib; clib; nm; gm; ret; sig; tbl
      :If 3= libG.⎕NC'Clear' ⋄ :Return ⋄ :EndIf                    ⍝ clear is bound last
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
            'InitSetStr' libG.⎕NA 'I4 ',sysLib,'|__gmpz_init_set_str P <C1[] I4'
            ok← 1 ⋄ :Leave  
         :EndTrap
      :EndFor
      ⎕SIGNAL nfÊ/⍨ ~ok 
      
      :For clib :In ('/usr/lib/libc.dylib' 'libc.so.6' 'msvcrt.dll')
         :Trap 0
            'Malloc' libG.⎕NA 'P ',clib,'|malloc U8'
            'Free'   libG.⎕NA clib,'|free P'
            :Leave
         :EndTrap
      :EndFor
      :If ~3=libG.⎕NC'Free' ⋄ 'C library not found' ⎕SIGNAL 11 ⋄ :EndIf
      
   ⍝ APL name    gmpz_ suffix         return type   args
      tbl← (
         'Add'         'add'            ''            'P P P'
         'AddU'        'add_ui'         ''            'P P U8'
         'Sub'         'sub'            ''            'P P P'
         'SubU'        'sub_ui'         ''            'P P U8'
         'Mul'         'mul'            ''            'P P P'
         'MulU'        'mul_ui'         ''            'P P U8'
         'Div'         'tdiv_q'         ''            'P P P'          ⍝ Truncated division
         'DivU'        'tdiv_q_ui'      ''            'P P U8'
         'Rem'         'tdiv_r'         ''            'P P P'          ⍝ Truncated remainder
         'FRem'        'fdiv_r'         ''            'P P P'          ⍝ Floored remainder
         'Gcd'         'gcd'            ''            'P P P'
         'Lcm'         'lcm'            ''            'P P P'
         'Root'        'root'           'I4 '         'P P U8'         ⍝ nonzero return ⇒ exact
         'Pow'         'pow_ui'         ''            'P P U8'
         'Cmp'         'cmp'            'I4 '         'P P'
         'ShiftL'      'mul_2exp'       ''            'P P U8'         ⍝ Shift left by n bits
         'ShiftR'      'tdiv_q_2exp'    ''            'P P U8'         ⍝ Shift right by n bits
         'NextPrime'   'nextprime'      ''            'P P'
         'PrevPrime'   'prevprime'      'I4 '         'P P'            ⍝ 2 definitely, 1 probably, 0 none
         'ProbabPrime' 'probab_prime_p' 'I4 '         'P U8'           ⍝ 2 definitely, 1 probably, 0 not
         'Fact'        'fac_ui'         ''            'P U8'
         'Sqrt'        'sqrt'           ''            'P P'            ⍝ Truncated root
         'SizeInBase'  'sizeinbase'     'U8 '         'P I4'
         'GetStr'      'get_str'        'P '          '=C1[] I4 P'
         'Clear'       'clear'          ''            'P'              ⍝ Must stay last: LoadLib's "loaded" test
      )
   ⍝ These traps are ignored in a ⎕FIX or ]Load, but not when LoadLib called directly
      :Trap 6 11 102                      
         :For (nm gm ret sig) :In tbl
            nm libG.⎕NA ret,sysLib,'|__gmpz_',gm,' ',sig
         :EndFor
      :Else 
         'Error loading Gmp library routine(s)' ⎕SIGNAL 11 
      :EndTrap 
   ∇
   LoadLib 
   
   ∇ ok← LoadUserFns
      ⍝:Section Dyadic Functions 
         Add← (libG.Add  _Dyad_  libG.AddU)  _G                    ⍝ Optimises if ⍵ is Apl Integer >0
         Sub← (libG.Sub  _Dyad_  libG.SubU)  _G                    ⍝ ditto 
         Mul← (libG.Mul  _Dyad_  libG.MulU)  _G                    ⍝ ditto 
         Div← (libG.Div  _DyadNZ_ libG.DivU) _G                    ⍝ ditto  
         Gcd← (libG.Gcd  _Dyad) _G
         Lcm← (libG.Lcm  _Dyad) _G
         Rem← (libG.Rem  _MonadNZ) _G              
      ⍝ APL's ⍺|⍵: ⍺ is the divisor, result is floored (sign of ⍺); 0|⍵ is ⍵
      ⍝ * In APL, when the left argument (divisor) is 0, the residue function is 
      ⍝   defined to return the right argument unchanged.
         Residue← { 
           IsZ ⍺: Canon ⍕⍵                                         ⍝ (string result, like everything else)
            ⍵ libG.FRem _CoreICM⍥⍕ ⍺
         } _G
         Mod← Residue 
      ⍝  Pow:  Either  10*3 (power) or 10*÷3 (root)
         Pow← {     
           0≠ ⊃0⍴ ⍵: ⎕SIGNAL powÊ ⋄ ⍵< 0:  ⎕SIGNAL powÊ
           ⍵= ⌊⍵:  ⍺ ⍕⍛(libG.Pow _CoreICM) ⍵
         ⍝ Integral Inverse: Do root.  ⍵ must be (nearly) ÷ an integer, e.g. ÷3, not 0.4
           inv← ⌊0.5+ ÷⍵
           (1E¯9< |⍵× inv- 1)∨ (¯1= Sig ⍺)∧ 0=2| inv: ⎕SIGNAL powÊ
            ⍺ ⍕⍛(libG.Root _CoreICM) inv  
         } _G
         Shift← {       ⍝ See Rotate
           ~IsI ⍵: ⎕SIGNAL shiftÊ                                  ⍝ IsI also rejects non-integers
           ⍵>0: ⍺ ⍕⍛( libG.ShiftL _CoreICM) ⍵
           ⍵<0: ⍺ ⍕⍛( libG.ShiftR _CoreICM) -⍵
            Canon ⍕⍺                                               ⍝ zero shift.  
         } _G
         Rotate← Shift⍨
         Root← {  ⍺← 2      ⍝ Sqrt                                 ⍝ Root(10 N) => 10*÷N 
           ~IsU ⍺: ⎕SIGNAL rootÊ 
            ⍺<1: ⎕SIGNAL rootÊ                                     ⍝ n=0 would divide by zero in GMP
           (¯1= Sig ⍵)∧ 0=2|⍺: ⎕SIGNAL rootÊ                       ⍝ even root of negative aborts GMP
            ⍵ ⍕⍛(libG.Root _CoreICM) ⍺
         } _G
      ⍝ rc← [cycles] ProbabPrime bigint
      ⍝      cycles: Reasonable values of reps are between 15 and 50.
      ⍝ Beware: GMP args are in reverse order
      ⍝ Return 2 if n is definitely prime,
      ⍝ return 1 if n is probably prime (without being certain), or
      ⍝ return 0 if n is definitely non-prime.
         ProbabPrime← { 
            ⍺← 15                                                  ⍝  usu. 15 - 50
           ~IsU ⍺: ⎕SIGNAL primeÊ
            ⍵ ⍕⍛({ libG.ProbabPrime 1↓⍵ } _ICM) ⍺                  ⍝ parenthesised: _ICM must bind to the {…} only
         } _G
         Cmp← { ⍺ { ×libG.Cmp 1↓ ⍵ } _ICM⍥⍕ ⍵ } _G
         _Cmp← { (⍺ Cmp ⍵)⍺⍺ 0 }                                   ⍝  ⍺ =_Cmp ⍵, etc.
         Eq← =_Cmp 
         Lt← <_Cmp
         Le← ≤_Cmp 
         Gt← >_Cmp
         Ge← ≥_Cmp 
         Max← { ⍺ Ge ⍵: ⍺ ⋄ ⍵ }⍥⍕                                  ⍝ Errors come from Cmp (guarded)
         Min← { ⍺ Le ⍵: ⍺ ⋄ ⍵ }⍥⍕
         
      ⍝:EndSection Dyadic Functions     
      
      ⍝:Section Monadic Functions 
         Neg← { ⍕1 Canon ⍵ }                                       ⍝ -⍵ 
         
         Abs←  { '-'≠ ⊃s← Canon ⍕⍵: s ⋄ 1↓s }                      ⍝ |⍵ 
         
      ⍝   Rand:  Rand ⍵
      ⍝   Generate a random number between 0 and ⍵-1, where ⍵ is a positive big-integer or int.
      ⍝   (Done in APL)
      ⍝ When ⎕FR ← 1287 (128-bit Decimal Floating-Point),
      ⍝ the maximum integer argument to ? roll is ( ¯1+ 2*63 ), i.e. a 64-bit signed integer.
      ⍝ We round down to to one less decimal digit:  randWid=18, randMax=10*18.
         randMax randWid← { ⎕FR← 1287 ⋄ w← ¯1+≢⍕¯1+2*63 ⋄ (10*w) w } 0 
         
      ⍝ Method: rejection sampling, base 10*randWid.  ⍵ is split into k chunks ("digits"), d.
      ⍝   k=1:  ?d directly, no rejection.
      ⍝   k>1:  top chunk r ← ?t+1 (0..t, t=top chunk of ⍵; t≥1 so acceptance ≥ ½).
      ⍝         lower chunks q are always drawn free over 0..randMax-1.
      ⍝         r<t:  any q is fine.     r=t:  accept iff q <(lexicographically) the lower chunks of ⍵.
      ⍝   Every x<⍵ then has probability 1÷((t+1)×randMax*k-1) per trial ⇒ exactly uniform.
      ⍝   NB: the lower chunks must NOT be drawn from their own bounds (?t₁+1 …): that breaks uniformity.
         Rand← { ⎕FR← 1287                                         ⍝ Needed for 34 digit arithmetic
            s← Canon ⍕⍵
           '-0'∊⍨ ⊃s: ⎕SIGNAL randÊ                                ⍝ Only positive integers
            k← ⌈randWid÷⍨ ≢s
            d← 10⊥⍉ (k,randWid)⍴ (-k×randWid)↑ ⎕D⍳s                ⍝ bound as k base-10*18 "digits" (left-padded with 0s)
           k= 1: ⍕?⊃d                                              ⍝ single chunk: ? gives [0,N) directly
            t← ⊃d ⋄ e← 1↓d
            gen← {
               r← ?t+ 1 ⋄ q← ?(k- 1)⍴ randMax
              r< t: r, q                                           ⍝ top chunk below bound: lower part is free
               j← (q≠ e)⍳ 1                                        ⍝ tie on top: first differing lower chunk (≢q if none)
              j⊃ (q< e),0: r, q ⋄ ∇ ⍬                              ⍝ lower < bound: accept; ≥ (incl. equal): retry
            }
            r← '0' NoLB ∊(1↓ ⍕)¨ randMax+ gen ⍬                    ⍝ zero-pad each chunk via 1+10*18 trick, strip leading 0s
            r,⍨ '0'/⍨ 0= ≢r                                        ⍝ all zeros → '0'
         } _G
         
      ⍝  Sig:
      ⍝  Using Cmp is much slower:
      ⍝        Sig← { 0:: SigÊ 0 ⋄ ⍵ Cmp '0'}
         Sig← { 0=⊃0⍴⍵: ×⍵ ⋄ 0 ¯1 1['0-'⍳ ⊃Canon ⍵] }             ⍝  Signum ×⍵ 
         
         Sqrt← { Root ⍵ }
         
         Fact← { 
           ~IsU ⍵: ⎕SIGNAL factÊ
           libG.Fact _CoreICM ⍵ 
         } _G
         
      ⍝  NextPrime ⍵: Returns the next pseudoprime after ⍵
         NextPrime← { libG.NextPrime _CoreICM ⍕⍵ } _G
         
      ⍝  PrevPrime:  rc prev← PrevPrime ⍵:
      ⍝  Returns the pseudoprime previous to ⍵. 
      ⍝  Note: libG.PrevPrime itself also returns rc:
      ⍝     Certain: rc=2; Likely: rc=1; None: 0.
         PrevPrime← { libG.PrevPrime _CoreICM ⍕⍵ } _G
         
         Inc← 1 Add⍨⊢
         Dec← 1 Sub⍨⊢ 
      ⍝:EndSection Monadic Functions 
      
      ok← 1 
   ∇ 
   LoadUserFns
   
   ∇ t2← LoadOpTables; dOps; dFns; mOps; mFns
      dOps← '+-×÷*|⌽∨∧⌈⌊=<≤>≥'
      dFns← 'Add' 'Sub' 'Mul' 'Div' 'Pow' 'Residue' 'Rotate' 'Gcd' 'Lcm' 'Max' 'Min' 'Eq' 'Lt' 'Le' 'Gt' 'Ge'
   ⍝        ⌽ does a binary shift (+ left or - right), i.e. mul/div by 2*⍺
      mOps← '-+×|!><?'
      mFns← 'Neg' 'Canon' 'Sig' 'Abs' 'Fact' 'Inc' 'Dec' 'Rand'
   ⍝        + returns ⍵ in canonical form; × signum; | absolute val; ! factorial (⍵@I)
   ⍝        > increment; < decrement; ? random number (⍵@I>0)
      t2← (↑dOps (⎕OR¨ dFns)) (↑mOps (⎕OR¨ mFns))
   ∇ 
   opTables← LoadOpTables 
   
   Parse← { 
      s← '-'@('¯'∘=)⊢ ,⍵                                           ⍝ APL high minus → ASCII
      ptr← libG.Malloc 16                                          ⍝ mpz_t is 16 bytes on 64-bit
     ptr=0: ⎕SIGNAL 11                                             ⍝ malloc failed
      rc ← libG.InitSetStr ptr (s, NUL) 10                         ⍝ explicitly NUL-terminated
      rc ptr
   }
   
   FmtG← { 
      n← 2+ libG.SizeInBase ⍵ 10                                   ⍝ digits + possible sign + NUL
      buf← n⍴ NUL 
      (ptr buf)← libG.GetStr buf 10 ⍵
      buf↑⍨ buf⍳ NUL                                               ⍝ keep text before the first NUL
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
⍝    zC is a malloc'd pointer, stable across calls (GMP updates _mp_d in place),
⍝    so no write-back is needed. Every mpz that has been initialised is in q,
⍝    so every exit path (including errors) clears and frees it.
   ∇ rc← {a} (Op _ICM) b
        ; êmsg; ên; q; rcA; rcB; zA; zB; zC; _
      :Trap 0
         q← ⍬ 
         :If ~900⌶⍬                                                ⍝ Dyadic Call
            (rcA zA)← Parse a ⋄ q,← zA                             ⍝ initialised even if rcA≠0
         :Else                                                     ⍝ Monadic Call 
            rcA← 0 ⋄ zA← ,⍥⊂                                       ⍝ Ignore zA
         :EndIf 
         :If 0≠ ⊃0⍴ b                                              ⍝ Is b a string?
            (rcB zB)← Parse b ⋄ q,← zB                             ⍝ b must be a big int 
         :Else 
            zB← ⍬⍴ b ⋄ rcB← 0                                      ⍝ b is an unsigned long 
            :If (zB≠⌊zB)∨ (zB<0)∨ zB≥2*64 ⋄ ⎕SIGNAL uIntÊ ⋄ :EndIf
         :EndIf
         :If ∨/0≠ rcA rcB 
            ⎕SIGNAL badStrÊ
         :EndIf
         (_ zC)← Parse'0'                                          ⍝ Initialise zC 
         q,← zC                                                    ⍝ cleared even if Op fails 
         rc← Op zC zA zB                                           ⍝ Now set (c zC) per Op.                                            
         ên← 0                    
      :Else 
         ên êmsg← ⎕DMX.( EN Message )
      :EndTrap
      {}libG.Clear¨ q ⋄ {}libG.Free¨ q                             ⍝ Release all Gmp objects 
      :If ên≠0 ⋄ ⎕SIGNAL⊂('EN' ên)('Message' êmsg) ⋄ :EndIf
   ∇
   
⍝  Self-test: returns 1 if everything passed (else 0); prints each failure only
   ∇ {r}← Test; cases; errs; t; e; got; bad; big; tie; ab
      big← '1',30⍴'0'                                              ⍝ 10*30: two chunks, lower chunk all zero
      tie← '1',(17⍴'0'),'5'                                        ⍝ 10*18+5: two chunks, tie path accepts only 0-4
      ab←  '01' ⋄ bad← 0
      cases← (
         ('2 Add 3'                                         '5')
         ('''99999999999999999999'' Add 1'                  '100000000000000000000')
         ('7 Sub 10'                                        '-3')
         ('''12345678901234567890'' Mul 10'                 '123456789012345678900')
         ('''100'' Div 7'                                   '14')
         ('''-7'' Rem 3'                                    '-1')
         ('3 Residue ¯7'                                    '2')
         ('0 Residue 5'                                     '5')
         ('12 Gcd 18'                                       '6')
         ('4 Lcm 6'                                         '12')
         ('2 Pow 100'                                       '1267650600228229401496703205376')
         ('3 Root ''1000'''                                 '10')
         ('''1000'' Pow ÷3'                                 '10')
         ('1 Shift 70'                                      '1180591620717411303424')
         ('''1180591620717411303424'' Shift ¯68'            '4')
         ('5 Shift 0'                                       '5')
         ('Sqrt 99'                                         '9')
         ('Fact 20'                                         '2432902008176640000')
         ('Neg ''0'''                                       '0')
         ('Neg ''5'''                                       '-5')
         ('Abs ''-5'''                                      '5')
         ('Sig ''0'''                                       0)
         ('Sig ''-5'''                                      ¯1)
         ('Sig 7'                                           1)
         ('3 Lt 5'                                          1)
         ('''10'' Cmp 9'                                    1)
         ('5 Eq 5'                                          1)
         ('1 Max 2'                                         '2')
         ('1 Min 2'                                         '1')
         ('2 +_Call 3'                                      '5')
         ('-_Call ''5'''                                    '-5')
         ('''-8'' Pow ÷3'                                   '-2')
         ('1E30 Add 1'                                      '1000000000000000000000000000001')   ⍝ big numeric → string path
         ('7 ProbabPrime 97'                                2)
         ('Rand 1'                                          '0')
         ('∧/(∊Rand¨300⍴2)∊ab'                              1)
         ('∧/(⊂big)Gt¨Rand¨200⍴⊂big'                        1)                                    ⍝ multi-chunk, tie always rejected
         ('∧/(⊂tie)Gt¨Rand¨500⍴⊂tie'                        1)                                    ⍝ multi-chunk, tie sometimes accepted
      )
      :For (t e) :In cases
         :Trap 0 
            got← ⍎t
            :If e ≢⍥, got
               ⎕← 'FAIL: ',t,'   expected ',(⍕e),'   got ',⍕got
               bad+← 1
            :EndIf
         :Else 
            ⎕← 'ERROR: ',t,'    ',⎕DMX.EM,' ',⎕DMX.Message 
            bad+← 1
         :EndTrap
      :EndFor
      
      errs← '5 Div 0' '5 Div ''0''' 'Sqrt ¯4' 'Fact ¯1' '''abc'' Add 1' '2 Root ''-8''' '0 Root 5' '1.5 Shift 2' 'Rand 0' 'Rand ¯5' '10 Pow 0.4'
      :For t :In errs
         :Trap 0
            got← ⍎t
            ⎕← 'FAIL (no error): ',t
            bad+← 1
         :Else
            :If 11≠ ⎕DMX.EN 
               ⎕← 'FAIL (EN ',(⍕⎕DMX.EN),' not 11): ',t
               bad+← 1
            :EndIf
         :EndTrap
      :EndFor
      
      r← 0= bad
      :If r ⋄ ⎕← 'All tests passed!' ⋄ :Else ⋄ ⎕← (⍕bad),' test(s) FAILED' ⋄ :EndIf
   ∇
   
   :Class obj 
      :Field Private ⍙ptr ← 0                                      ⍝ address of the mpz_t; 0 = nothing live
      :Field Private libG← ##.libG 
      :Field Private up← ## 
      
      ∇ Alloc0
         :Access Public
         :Implements Constructor
         Init '0'
      ∇ 
      ∇ Alloc1 str
         :Access Public  
         :Implements Constructor
         Init str                                                  ⍝ string, base 10
      ∇
      
      ∇ Init str; rc
         str← '-'@('¯'∘=)⊢ ,str
         ⍙ptr← libG.Malloc 16                                      ⍝ mpz_t is 16 bytes on 64-bit
         :If ⍙ptr=0 ⋄ ⎕SIGNAL 11 ⋄ :EndIf                          ⍝ malloc failed
         rc← libG.InitSetStr ⍙ptr (str, up.NUL) 10
         :If rc≠0
            Release 
            ⎕SIGNAL up.badStrÊ                                     ⍝ invalid number string
         :EndIf
      ∇
      
      ∇ Release
         :If ⍙ptr≠0 
            {}libG.Clear ⍙ptr ⋄ {}libG.Free ⍙ptr ⋄ ⍙ptr← 0
         :EndIf
      ∇
      
      ∇ FreeObj
         :Implements Destructor
         Release
      ∇
      
      ∇ p← ptr
         :Access Public
         :If ⍙ptr=0 ⋄ ⎕SIGNAL 11 ⋄ :EndIf
         p← ⍙ptr
      ∇
      
      ∇ s← show
         :Access Public
         s← 'ptr=',(⍕⍙ptr),'  val=',val
      ∇
      ∇ s← val
         :Access Public
         :If ⍙ptr=0 ⋄ ⎕SIGNAL 11 ⋄ :EndIf
         s← up.FmtG ⍙ptr
      ∇
   :EndClass
   
:EndNamespace
