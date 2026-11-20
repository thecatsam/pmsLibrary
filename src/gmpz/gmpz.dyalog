:Class gmpz                                                   ⍝ MPZ: GMP's multiple precision integer
   
⍝ ═══════════════════════════════════════════════════════════════════════════════
⍝  gmpz — Arbitrary-precision integers for Dyalog APL, backed by GMP (libgmp)
⍝  Version 2026-11-17
⍝ ═══════════════════════════════════════════════════════════════════════════════
⍝
⍝  OVERVIEW
⍝    Each gmpz instance wraps one GMP `mpz_t`, allocated with malloc and
⍝    manipulated through ⎕NA bindings to libgmp. Values can be created from
⍝    and exported to APL integers or decimal strings of any length.
⍝    The operator GI (bottom of file) wraps the methods in primitive-style syntax.
⍝
⍝  REQUIREMENTS
⍝    Dyalog APL v20 or later, 64-bit (developed with v21); the GMP shared library
⍝    (libgmp, version 10) — GMP 6.3 or later, because PrevPrime uses mpz_prevprime
⍝    and all routines are bound at load time (an older libgmp fails with gmpLoadÊ).
⍝    LoadLib searches the usual macOS / Linux / Windows locations.
⍝    The class sets  ⎕IO ⎕ML ⎕PP ⎕FR← 0 1 34 1287  (decimal floats, so APL
⍝    integers up to 2*63 are exact; here 2*63 means 2 to the power 63).
⍝
⍝  CREDITS
⍝    Created by PMS 20261114
⍝    ∘ Original design, prototype code, code comments and primer
⍝    ∘ All class code, including system (malloc/free) memory management,
⍝      except functions built on mpz routines export and import.
⍝    ∘ Random state code
⍝    ∘ Method for adding Microsoft declarations (untested), where different from Unix
⍝  With assistance from AI (Muse, Claude, Gemini) for:
⍝    ∘ Debugging and recommendations on systematizing conversion code (str <-> mpz, etc.)
⍝    ∘ Designing functions to move bits to and from APL efficiently (using export and import)
⍝    ∘ Additions to and formatting of primer
⍝    ∘ Additions to comments as new features were added
⍝    ∘ Specifications for Microsoft declarations (where longs are 4 bytes vs 8)
⍝    ∘ Sample gmpz program (AI did C language prototype; PMS created APL version)
⍝    ∘ Searching for GMP declarations and C language sizes
⍝    ∘ Review and revision 2026-11-17 (renames, fixes, comments)
⍝
⍝  QUICK START
⍝      a← ⎕NEW gmpz '12345678901234567890'                    ⍝ from a string
⍝      b← ⎕NEW gmpz 2                                         ⍝ from an APL integer
⍝      c← ⎕NEW gmpz                                           ⍝ defaults to 0
⍝      d← gmpz.New '99999999999999999999'                     ⍝ shared factory (optional base on left)
⍝      16 gmpz.New 'ff'                                       ⍝ → 255
⍝
⍝      ⌷a                                                     ⍝ string form (default property)
⍝      c.Set 5                                                ⍝ overwrite c with 5 (c now holds 5)
⍝      e← a.Copy                                              ⍝ an independent copy (NOT  e← a, which aliases)
⍝
⍝  API SUMMARY   (c = receiver; [a] = optional left operand, default c; ⎕IO = honours the caller's ⎕IO)
⍝    Create / set    ⎕NEW gmpz [obj | (obj base)]    gmpz.New0    [base] gmpz.New obj    [base] c.Set b    c.Copy
⍝    Value out       ⌷c   c.Int64   c.IntDF   c.VFI   c.Float   c.GetInBase n   [base] gmpz.Get b   c.Signum   c.ptr
⍝    Size            c.StrLen   c.StrLenInBase n   c.BitLen
⍝    Arithmetic      [a] c.Add|Sub|Mul|Div|Gcd|Lcm b      rem← [a] c.DivRem b      m c.Res b
⍝                    c.Neg   c.Abs   c.Inc   c.Dec  (niladic, in place)      c.Fac n
⍝    Powers          [a] c.Pow n | ÷n      [a] c.PowM (e m)      rc← [a] c.Invert m
⍝    Number theory   [a] c.Bin k   c.Fib n   c.Primorial n   rem← c.SqrtRem b   st← [a] c.GcdExt b   [a] c.Divexact b
⍝                    c.IsSquare   c.IsPower   bool← [a] c.Congruent (b m)
⍝    Predicates      c.Even   c.Odd   c.Divisible b   c.ProbabPrime reps   [a] c.Jacobi b   (all visible 0/1/…)
⍝    Comparison      [a] c.Cmp|Lt|Le|Eq|Ne|Ge|Gt b
⍝    Primes          c.NextPrime n   c.PrevPrime n   c.PrevPrime2 n
⍝    Bits            h c.Shift b   h c.ShiftFloor b   [a] c.And|Or|Xor b   c.Com   c.PopCount   n← [a] c.HamDist b
⍝                    c.Bit[i]   c.Bits   c.ExportBits w   c.ImportBits v
⍝                    [a] c.TestBit n   c.SetBit n [v]   c.ClrBit n   c.Flip n  (⎕IO)   [a] c.Iota bit   [a] c.Scan (start bit)  (⎕IO)
⍝    Random          c.Rand b   c.RandB n  (⎕IO)      gmpz.RandSeed u
⍝    Operator        [a] (fn GI) b   — non-destructive, primitive-style (see the GI section)
⍝
⍝  OPERATING APPROACH
⍝    Methods such as Add, Sub, Mul, … are IN-PLACE: the object receiving the
⍝    call is overwritten with the result, and the method returns that same
⍝    object (shy). So   c.Add b   means   c← c + b ,
⍝    and                a c.Add b means   c← a + b  (c is only the destination).
⍝    Operands (a, b) may each be any of:
⍝         – a gmpz object                (used directly, never copied)
⍝         – an APL integer               (negative or non-negative)
⍝         – a character string           ('¯' is accepted as a minus sign)
⍝    Non-gmpz operands are copied into three hidden scratch objects
⍝    (statics[0], statics[1], statics[2]) so GMP can use them.
⍝    Never rely on the scratch objects' values.
⍝    Methods that take only a right argument and construct a value from it (Fac, Rand,
⍝    RandB, NextPrime, PrevPrime) do not default it to the receiver; Neg, Abs, Inc and Dec
⍝    are niladic and work on the receiver:  c.Neg  negates c;  (c.Set b).Neg  sets c← -b.
⍝    The mutating bit methods (SetBit, ClrBit, Flip) act on the receiver only.
⍝    The monadic/dyadic operator GI (bottom of file) wraps these methods so
⍝    they read like APL primitives and do NOT disturb their arguments.
⍝
⍝  SEMANTICS / CONVENTIONS
⍝      Div        Division is FLOORED (⌊)        (mpz_fdiv_q)
⍝      Res        [Residue] APL's a|b, (modulus c.Res b) is FLOORED. The sign follows
⍝                 the modulus (mpz_fdiv_r), and 0 Res b is b, as in APL.
⍝      Pow        a c.Pow n  → a^n  (n a non-negative integer)
⍝                 a c.Pow ÷n → floor of the true n-th root (truncated)
⍝      Shift      n c.Shift b : left for n>0, right (truncating toward zero) for n<0
⍝                 This is a binary shift, equiv. to  b×2*n, where * is power.
⍝                 For a decimal shift, use c.Mul and c.Div.
⍝      Fac        factorial of non-negative integer only.
⍝      Rand       uniform on ⎕IO … ⎕IO+⍵-1 (0 … ⍵-1 under ⎕IO←0).
⍝                 By default, uses APL ⎕RL for seed with RNG2 (system entropy).
⍝      Bits       Two's complement, most significant (sign) bit first. BitLen is the
⍝                 minimum two's-complement width, so BitLen 8 is 5 (0 1 0 0 0) and BitLen ¯8 is 4 (1 0 0 0).
⍝      ⎕IO        Bit, TestBit, SetBit, ClrBit, Flip, Scan, Iota, Rand and RandB honour the caller's ⎕IO.
⍝                 Everything else is origin-independent.
⍝      Shy        In-place arithmetic, SetBit, ClrBit, Flip, DivRem, RandSeed, Fac and Rand* return shy results.
⍝                 Predicates and queries (Even, Odd, Divisible, TestBit, ProbabPrime, Cmp…, Signum…) are visible.
⍝
⍝  CAVEATS
⍝    ∘ Assignment copies a reference:  b← a  makes b and a the SAME object. Use  b← a.Copy.
⍝    ∘ Instances hold RAW C pointers. They do not survive )SAVE / )LOAD, ⎕OR or ⎕TC-style
⍝      serialisation: a reloaded workspace contains dead objects. Re-create them.
⍝    ∘ GMP aborts the whole process if it runs out of memory. Fac, Pow, Shift, RandB and the like
⍝      accept arguments up to the C unsigned long maximum, so a typo (e.g. Fac 1E12) can kill the session.
⍝    ∘ Not thread-safe (shared scratch objects); see the :Hold note in the statics section.
⍝
⍝  ERRORS
⍝    Public entry points set ⎕TRAP←∆TRAP, which re-signals errors from the
⍝    caller's perspective. Internal helpers (_Dyad_, PSignum, ⍙Scan, ⍙TryDF, ⍙StrLenInBase, ⍙TwosComp,
⍝    StatPtr, ⍙SetStr, ⍙InitObj) do NOT set a trap; they rely on their caller.
⍝    See the `errors` table below for the names, codes and messages.
⍝
⍝  MEMORY
⍝    The destructor clears and frees the mpz when the object goes out of scope,
⍝    or explicitly via  ⎕EX 'a'.  DEBUG← 1 traces gmpz allocations and frees;
⍝    DEBUG← 2 also traces the random state and the ⎕NA bindings.
⍝
⍝  FILE LAYOUT  (the order of the first four items is load-bearing: see MAINTAINERS)
⍝    1.  Settings and shared fields           9.  Arithmetic (monadic, then dyadic)
⍝    2.  Class randState                     10.  Powers, roots, modular arithmetic, primes
⍝    3.  Error table                         11.  Bit logic: Shift, And/Or/Xor, single bits, Scan/Iota
⍝    4.  LoadLib and the Field "RAW"         12.  Bit and Bits properties; ExportBits / ImportBits
⍝    5.  Types (IsMpz … Case_T)              13.  Comparison
⍝    6.  Construction, Set, Copy, Free       14.  Random: Rand, RandB, RandSeed
⍝    7.  Scratch objects and _Dyad_          15.  Statics initialisation (call)
⍝    8.  Value access (⌷, Int64, IntDF,      16.  GI operator and tempGI
⍝        VFI, GetInBase, Get, sizes)
⍝
⍝  NOTES FOR MAINTAINERS
⍝  - Initialisation order. Fields and class-level statements execute in file order when the class
⍝    is fixed. (1) the settings line must precede randState, which inherits ⎕IO ⎕ML ⎕PP ⎕FR ⎕RL
⍝    when it is created and uses WINDOWS; (2) the errors must exist before LoadLib can signal them;
⍝    (3) LoadLib RAW needs mpzTable (inside LoadLib), WINDOWS, DEBUG and the errors;
⍝    (4) the type helpers must exist before InitStatics runs, because ⎕NEW gmpz calls Set → Case_T;
⍝    (5) InitStatics must run before tempGI is created and before any method uses Ptr0/Ptr1/Ptr2.
⍝    Methods themselves can be reordered freely; only the class-level statements are order-sensitive.
⍝  - Names ending in Ê are variables generated from a table in LoadErrs.
⍝  - Names starting with ⍙ are private helpers.
⍝  - Library entries in namespace RAW (Add, AddU, …) are direct (RAW) GMP calls;
⍝    the "U" variants take an unsigned C long instead of an mpz — 64-bit
⍝    on Unix, 32-bit on Windows (see the UL/IL note above mpzTable in LoadLib).
⍝  - ⎕FR←1287 is used, since it allows handling of (64-bit) pointers and
⍝    U8 and I8 (64-bit unsigned and signed integers). We occasionally take
⍝    advantage of decimal floats to work with integers larger than 64-bits (up to 34 digits).
⍝  - Numeric literals longer than 16 digits are tokenised using the ⎕FR in force when the
⍝    code is fixed. Prefer strings for big constants.
⍝ ═══════════════════════════════════════════════════════════════════════════════
   
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  1. Settings and shared fields
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⎕IO ⎕ML ⎕PP ⎕FR← 0 1 34 1287                               ⍝ Class-wide settings (see header)
   ⎕RL← ⍬ 2                                                   ⍝ Use the system entropy by default for "seeds"
 :Field Public  Shared          DEBUG← 0                      ⍝ 1: trace gmpz Alloc/Free.  2: also trace randState and ⎕NA bindings
   win← 'Windows'≡7↑⊃'.'⎕WG'APLVersion'
 :Field Public  Shared ReadOnly WINDOWS← win 
 :Field Private Shared ReadOnly ∆THIS← ⎕THIS                  ⍝ The class reference (used for ⎕NEW and class tests)
 :Field Private Shared ReadOnly ∆TRAP← 0 'E' 'DmxSig⍬'        ⍝ Standard ⎕TRAP for public methods: re-signal at caller
 :Field Public  Shared ReadOnly UL_MAX← ¯1+2* WINDOWS⊃64 32   ⍝ Max C unsigned long: 2*64-1 Unix, 2*32-1 Windows
 :Field Public  Shared ReadOnly IL_MAX← ¯1+2* WINDOWS⊃63 31   ⍝ Max C signed long: 2*63-1 Unix, 2*31-1 Windows
 :Field Private Shared          rsInstance← ⎕NULL             ⍝ Random # state var (a randState, created on first use)
 :Field Public  Shared ReadOnly RAW← ()                       ⍝ Namespace holding all bound GMP and libc routines
   
 :Field Private Instance        ⍙ptr← 0                       ⍝ address of the mpz_t; 0 = nothing live
   
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  2. Class randState — GMP random state, used by Rand, RandB and RandSeed
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  It must follow the settings line above (it inherits them) and WINDOWS (used by seeds).
   :Class randState
   ⍝ NOTE: randState is a nested class. It reads the outer class's DEBUG through ##.DEBUG
   ⍝       (DEBUG≥2 traces it) and uses the outer lib, error variables and DmxSig.
   ⍝ Call:    rs← ⎕NEW randState                              ⍝ Not directly called by user. See fns Rand, RandB.
   ⍝ When rs goes out of scope, the storage is released.
    :Field Private Instance       r⍙ptr← 0
    :Field Public  Shared         active← 0                   ⍝ Only 1 active instance is allowed!
    :Field Public  Shared         seeds← (?¯1+ 2* ##.WINDOWS⊃63 32) 0 ⍝ Order: newseed oldseed. A seed fits in a UL.
      ∇ Init0 ; ok
       :Access Public
         :Implements Constructor
         :If active ⋄ ⎕SIGNAL randActiveÊ ⋄ :EndIf
         ok← 0
         :Trap 0
            r⍙ptr← RAW.Malloc 64
            :If 0= r⍙ptr
               ⎕SIGNAL randStateÊ
            :EndIf
            {}RAW.RandInitDef r⍙ptr
            ok← 1
            {}RAW.RandSeedU r⍙ptr (⊃seeds)                    ⍝ Seed from APL random #
            :If 2≤ ##.DEBUG ⋄ ⎕← 'rand: Alloc state var [',(⍕r⍙ptr),']'  ⋄ :EndIf
         :Else
            :If 0≠ r⍙ptr
               :If ok ⋄ {}RAW.RandClear r⍙ptr ⋄ :EndIf
               {}RAW.Free r⍙ptr
               :If 2≤ ##.DEBUG ⋄ ⎕← 'rand: Free state var [',(⍕r⍙ptr),']'  ⋄ :EndIf
               r⍙ptr← 0
            :EndIf
            ##.DmxSig⍬                                        ⍝ Re-signal at the caller; do NOT set active←1
         :EndTrap
         active← 1
      ∇
      ∇ Free
         :Implements Destructor
         :If 2≤ ##.DEBUG ⋄ ⎕← 'rand: Free state var [',(⍕r⍙ptr),']'  ⋄ :EndIf
         :If 0≠ r⍙ptr
            {}RAW.RandClear r⍙ptr
            {}RAW.Free r⍙ptr
            r⍙ptr← 0
         :EndIf
         active← 0                                            ⍝ Allow a second instance after the first is freed
      ∇
      ∇ p← ptr
       :Access Public
         p← r⍙ptr
      ∇
   :EndClass
   
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  3. Error handling
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  DmxSig: re-signals the current ⎕DMX error (EN and Message) so that the error
⍝          is reported at the caller's level.  Installed via ∆TRAP above.
   DmxSig← ⎕SIGNAL { ⊂⎕DMX.('EN' EN ⋄ 'Message' Message) }
⍝  LoadErrs: turns each row of `errors` into a variable named in column 1, whose
⍝          value is a ⎕SIGNAL-ready namespace spec ('EN' code)('Message' text).
⍝          Use:  ⎕SIGNAL divZÊ   or   ⎕SIGNAL divZÊ/⍨ condition
   LoadErrs← { ⎕VSET (↑⊃¨ ⍵)({⊂('EN' ⋄  ⊃⍵)('Message'  ⋄  ⊃⌽⍵)}∘(1↓⊢)¨⍵)}
⍝             name           EN   Message
   errors← (
      'badAplÊ'       11 'Invalid APL Integer'
      'badBitIxÊ'      3 'Invalid bit index (must be >= ⎕IO)'
      'badBitValÊ'    11 'Invalid bit value (must be 0 or 1)'
      'badBitsÊ'      11 'Bits must be 1 or 0'
      'badInitÊ'      11 'Unable to create object'
      'badIntÊ'       11 'Number does not fit into the requested APL integer type'
      'badObjÊ'       11 'Can''t convert object to a Gmp integer'
      'badUIntÊ'      11 'Value must be a non-negative integer no larger than a C unsigned long'
      'baseXtraÊ'     11 'Bases are valid only with string arguments'
      'divZÊ'         11 'Division by 0'
      'facBadÊ'       11 'Arg must be non-neg integer (Windows: 32-bit, Other: 64-bit)'
      'gmpLoadÊ'      11 'Error loading Gmp library routine(s) (GMP 6.3 or later is required)'
      'noGmpÊ'        22 'GMP library not found'
      'noPrevPrimeÊ'  11 'There is no prime less than the argument (it must be greater than 2)'
      'powÊ'          11 'Invalid power: neither an integer nor the inverse of one'
      'primeÊ'        11 'ProbabPrime reps must be a non-negative integer (⍬ or 0 for the default of 24; 15-50 is usual)'
      'propSetÊ'      11 '⍵.Bits[i] is invalid. To set an individual bit, use ⍵.Bit[n]'
      'randActiveÊ'  911 'Logic error: only one randState instance may be active at a time'
      'randSeedÊ'     11 'Object cannot be converted to an unsigned integer'
      'randStateÊ'    11 'Unable to initialise random # state'
      'randÊ'         11 'Arg must be positive'
      'shiftÊ'        11 'Shift value must be an integer'
      'sqrtNegÊ'      11 'Square root of a negative number'
   )
⍝  badBitIxÊ uses EN 3 (INDEX ERROR) deliberately, because a bad bit index
⍝  is an indexing error; all other user errors use EN 11 (DOMAIN ERROR), except the logic error (911 here).
⍝  (GI defines its own local unknownÊ, EN 11, so that it works when copied out of the class.)
   LoadErrs errors
   
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  4. LoadLib: locate libgmp and libc, and bind every needed routine into a namespace
⍝
⍝    Arg/Result  where   the namespace (here RAW, a :Field Shared) that receives
⍝                        the ⎕NA-bound functions. Pass a namespace, e.g. ().
⍝    Behavior:
⍝      1. If `loadComplete` already exists in `where`, return.
⍝      2. Probe a list of likely libgmp paths until one binds `Init`.
⍝      3. Bind malloc / free / memcpy from libc (used to allocate mpz_t and to
⍝         peek at the sign field — see PSignum). All three must come from the
⍝         SAME libc: each candidate is tried in one trap, and any partial
⍝         bindings from a failed candidate are expunged first, so a later
⍝         candidate cannot be mixed with an earlier one.
⍝      4. Bind each row of mpzTable as
⍝               apl_name RAW.⎕NA '<return_type> <gmpLib>|__gmpz_<gmpz_name> <signature>'
⍝         The <return_type> is omitted if (c-language) void.
⍝         The <signature> is in APL ⎕NA format, using pointers (P) and various integers.
⍝    Errors: Signals noGmpÊ if no library (or libc) is found; gmpLoadÊ if a routine
⍝            cannot be bound (the offending entry is echoed to the session).
⍝ ───────────────────────────────────────────────────────────────────────────────
   ∇ {where}← LoadLib where
        ; clib; field; gmpLib; gmpLibs; info; errs; nm; ok; pfx
        ; gm; ret; sig; sysLib; sysLibs; trueLongs
      :If 0=≢where ⋄ where← ⎕NS '' ⋄ :EndIf                   ⍝ ⍬ (or an empty value) → fresh namespace
      → 0/⍨ where.⎕VGET ⊂'loadComplete' 0                     ⍝ Already exists and 1? Return!
      where.⎕DF 'gmpInt [gmp library]'     
      gmpLibs← (
         '/opt/homebrew/opt/gmp/lib/libgmp.dylib'             ⍝ macOS, Apple silicon (Homebrew)
         '/usr/local/opt/gmp/lib/libgmp.dylib'                ⍝ macOS, Intel (Homebrew)
         'libgmp.dylib'
         'libgmp.10.dylib'
         'libgmp.so.10'                                       ⍝ Linux, via the loader path
         '/usr/lib/x86_64-linux-gnu/libgmp.so.10'
         '/usr/lib/aarch64-linux-gnu/libgmp.so.10'
         '/usr/lib64/libgmp.so.10'
         'libgmp-10.dll'                                      ⍝ Windows
      )                                           
      ok← 0
      :For gmpLib  :In gmpLibs 
         :Trap 0
            'Init' where.⎕NA gmpLib,'|__gmpz_init P'          ⍝ Probe: does this path load?
            ok← 1 ⋄ :Leave
         :EndTrap
      :EndFor
      ⎕SIGNAL noGmpÊ/⍨ ~ok
      
      sysLibs← '/usr/lib/libc.dylib' 'libc.so.6' 'msvcrt.dll'
      :For sysLib :In sysLibs 
         where.⎕EX 'Malloc' 'Free' 'MemCpyI2'                 ⍝ Expunge any partial bindings from a failed candidate
         :Trap 0
            'Malloc'   where.⎕NA 'P ',sysLib,'|malloc U8'     ⍝ malloc(count) → pointer
            'Free'     where.⎕NA      sysLib,'|free P'
            'MemCpyI2' where.⎕NA      sysLib,'|memcpy >I4[2] P U8'  ⍝ copy N bytes out as 2 ints (used for the sign)
            :If ∧/3= ⌊where.⎕NC 'Malloc' 'Free' 'MemCpyI2'    ⍝ All three bound, all from this clib
               :Leave
            :EndIf
         :EndTrap
      :EndFor
      :If ∨/3≠ ⌊where.⎕NC 'Malloc' 'Free' 'MemCpyI2'
         ⎕SIGNAL noGmpÊ
      :EndIf
      
   ⍝ C long is 64-bits on Unix/macOS/Linux but 32-bits on Windows
   ⍝ so a C long must not be bound as a fixed I8/U8. The table
   ⍝ uses two placeholders for C longs, expanded at ]LOAD / ⎕FIX time by
   ⍝ LoadLib (see below) to the right ⎕NA type for the platform:
   ⍝   UL = unsigned long int / mp_bitcnt_t : U8 on Unix, U4 on Windows
   ⍝   IL = signed long int                 : I8 on Unix, I4 on Windows
   ⍝ Not every U8/I8 is a C long. size_t (SizeInBase's return, and the
   ⍝ malloc/memcpy counts above) is 64-bit on Win64 as well as on Unix64,
   ⍝ so it stays U8. C int stays I4 on both platforms. The bit-index
   ⍝ functions (TstBit/SetBit/ClrBit/ComBit) take mp_bitcnt_t, an
   ⍝ *unsigned* long, so they are UL, not IL.
   ⍝
   ⍝ Binding table. Each row: APL name, GMP name (after __gmpz_), return type, arg types.
   ⍝   P = pointer (to an mpz_t)     U8 / I8 = 64-bit unsigned / signed int
   ⍝   UL / IL = C unsigned / signed long (expanded at load time, see above)
   ⍝   I4 = 32-bit int               '' return = void (result left in the first mpz arg)
   ⍝ A trailing "U" in an APL name means the last operand is an unsigned machine int.
   ⍝ 'Rem' is deliberately NOT bound: it would duplicate 'FRem' (both fdiv_r).
   ⍝ There is no tdiv_r binding; use FRem for the floored remainder everywhere.
   ⍝ Every row must bind: a missing routine (e.g. prevprime before GMP 6.3) fails the whole load.
      mpzTable← (
      ⍝ APL synonym    gmpz name     return type       args
         'Abs'         'abs'            ''            'P P'
         'Add'         'add'            ''            'P P P'
         'AddU'        'add_ui'         ''            'P P UL'
         'Clear'       'clear'          ''            'P'
         'Cmp'         'cmp'            'I4'          'P P'   ⍝ <0, 0, >0
         'CmpI'        'cmp_si'         'I4'          'P IL'  ⍝ compare to a signed machine int
         'CmpAbs'      'cmpabs'         'I4'          'P P'   ⍝ compare absolute values
         'UiPow'       'ui_pow_ui'      ''            'P UL UL' ⍝ rop← base*exp (both unsigned ints)
         'Div'         'fdiv_q'         ''            'P P P' ⍝ Floored division
         'DivRemU'     'fdiv_qr_ui'     'UL'          'P P P UL'
         'DivRem'      'fdiv_qr'        ''            'P P P P'
         'Divisible'   'divisible_p'    'I4'          'P P'
         'DivU'        'fdiv_q_ui'      ''            'P P UL'
         'Export'      'export'         ''            '>U8[] >U8 I4 U8 I4 U8 P'
         'Fac'         'fac_ui'         ''            'P UL'
         'FRem'        'fdiv_r'         ''            'P P P' ⍝ Floored remainder
         'FRemU'       'fdiv_r_ui'      ''            'P P UL' ⍝ ditto
         'Gcd'         'gcd'            ''            'P P P'
         'GcdU'        'gcd_ui'         ''            'P P UL'
         'GetStr'      'get_str'        ''            '=0C[] I4 P'  ⍝ Handle null termination automatically
         'Import'      'import'         ''            'P U8 I4 U8 I4 U8 <U8[]'
         'Init'        'init'           ''            'P'     ⍝ To zero (void)
         'Int'         'get_si'         'IL'          'P'     ⍝ Raw get; valid only if IntFits (see Int64)
         'Invert'      'invert'         'I4'          'P P P' ⍝ Modular inverse: rop = a^-1 mod m (returns non-zero if exists)
         'IntFits'     'fits_slong_p'   'I4'          'P'     ⍝ mpz_fits_slong_p returns int, not I8
         'Jacobi'      'jacobi'         'I4'          'P P'   ⍝ Jacobi symbol (a/b) -> returns -1, 0, 1
         'Lcm'         'lcm'            ''            'P P P'
         'LcmU'        'lcm_ui'         ''            'P P UL'
         'Mul'         'mul'            ''            'P P P'
         'MulU'        'mul_ui'         ''            'P P UL'
         'Neg'         'neg'            ''            'P P'
         'NextPrime'   'nextprime'      ''            'P P'
         'Pow'         'pow_ui'         ''            'P P UL'
         'PowM'        'powm'           ''            'P P P P' ⍝ Modular exponentiation: rop← base^exp mod mod
         'PrevPrime'   'prevprime'      'I4'          'P P'   ⍝ GMP ≥ 6.3. Returns 2 definitely, 1 probably prime, 0 if none (op ≤ 2)
         'ProbabPrime' 'probab_prime_p' 'I4'          'P I4'  ⍝ 2 definitely, 1 probably, 0 not
         'Root'        'root'           'I4'          'P P UL' ⍝ nonzero return ⇒ exact
         'Set'         'set'            ''            'P P'
         'SetI'        'set_si'         ''            'P IL'
         'SetStr'      'set_str'        'I4'          'P <0C1[] I4'   ⍝ Handle null termination automatically
         'ShiftL'      'mul_2exp'       ''            'P P UL' ⍝ Shift left by n bits
         'ShiftR'      'tdiv_q_2exp'    ''            'P P UL' ⍝ Shift right by n bits, truncating toward zero
         'Size'        'size'           'U8'          'P'
         'SizeInBase'  'sizeinbase'     'U8'          'P I4'  ⍝ size_t: 64-bit on Win64 and Unix64 alike, so stays U8
         'Sub'         'sub'            ''            'P P P'
         'SubU'        'sub_ui'         ''            'P P UL'
      ⍝   Logical functions
         'TstBit'      'tstbit'         'I4'          'P UL'  ⍝ Look at the actual bits of an mpz (big integer)
         'SetBit'      'setbit'         ''            'P UL'
         'ClrBit'      'clrbit'         ''            'P UL'
         'Scan1'       'scan1'          'UL'          'P UL'  ⍝ UL_MAX if there is no such bit
         'Scan0'       'scan0'          'UL'          'P UL'
         'ComBit'      'combit'         ''            'P UL'  ⍝ flip one bit (one's complement of that bit)
         'And'         'and'            ''            'P P P'
         'Or'          'ior'            ''            'P P P' ⍝ inclusive or
         'Xor'         'xor'            ''            'P P P'
      ⍝   Further number theory and conversion (all exist in GMP 6.3)
         'Com'         'com'            ''            'P P'   ⍝ bitwise NOT: -x-1
         'PopCount'    'popcount'       'UL'          'P'     ⍝ number of 1 bits; UL_MAX if negative
         'HamDist'     'hamdist'        'UL'          'P P'   ⍝ differing bits; UL_MAX if signs differ
         'Bin'         'bin_ui'         ''            'P P UL' ⍝ rop← C(n,k), n any integer, k unsigned
         'Fib'         'fib_ui'         ''            'P UL'
         'Primorial'   'primorial_ui'   ''            'P UL'  ⍝ product of the primes ≤ n
         'SqrtRem'     'sqrtrem'        ''            'P P P' ⍝ root, remainder; op must be ≥ 0
         'PerfectSquare' 'perfect_square_p' 'I4'      'P'
         'PerfectPower'  'perfect_power_p'  'I4'      'P'
         'GcdExt'      'gcdext'         ''            'P P P P P' ⍝ g s t a b:  a*s + b*t = g
         'Divexact'    'divexact'       ''            'P P P' ⍝ only valid if the division is exact
         'DivexactU'   'divexact_ui'    ''            'P P UL'
         'Congruent'   'congruent_p'    'I4'          'P P P' ⍝ a ≡ b (mod m)
         'GetD'        'get_d'          'F8'          'P'     ⍝ truncated double
         'ShiftRF'     'fdiv_q_2exp'    ''            'P P UL' ⍝ shift right, FLOORED
         'URandomM'    'urandomm'       ''            'P P P' ⍝ mpz: random # < the ceiling
         'URandomB'    'urandomb'       ''            'P P UL' ⍝ Random # based on bits
      ⍝   gmp calls-- handled specially. Note prefix...
         'RandInitDef' 'gmp_randinit_default' ''      'P'     ⍝ gmp: the default— Mersenne
         'RandSeedU'   'gmp_randseed_ui' ''           'P UL'  ⍝ gmp: seed state with unsigned int
         'RandClear'   'gmp_randclear'  ''            'P'     ⍝ gmp:
      )
      
      errs← 0
      trueLongs← ('U8' 'I8')  ('U4' 'I4') ⊃⍨ WINDOWS
      :For field :In (2 3)
         (field⊃¨mpzTable)← 'UL' 'IL' ⎕R trueLongs⊣ field⊃¨mpzTable
      :EndFor
      :For (nm gm ret sig) :In mpzTable
         :Trap 6 11 102
            pfx← 'gmpz_'/⍨ 'gmp_'≢4↑gm
            info← '|__', pfx, gm, ' ', sig
            nm where.⎕NA ret,' ', gmpLib, info
            :If DEBUG≥2                                       ⍝ DEBUG
               ⎕← ' ',(18↑'''',nm,''''),' ⎕NA ''',(4↑ret),' [LIB]',info,''''
            :EndIf
         :Else
            errs+← 1
            ⎕← '*** Error loading Gmp library routine: '
            ⎕← '   ',nm,' ⎕NA ',info
            ⎕← '*** Key functionality may not be available'
         :EndTrap 
      :EndFor
      :If ×errs 
         ⎕← 75⍴'*'
         ⎕← '*** ',' ***',⍨ 67↑ (⍕errs),' GMP library routines could NOT be loaded'
         ⎕← '*** ',' ***',⍨ 1 1⊃⊃gmpLoadÊ
         ⎕← 75⍴'*'
      :EndIf 
      where.loadComplete← 1
   ∇
   LoadLib RAW   
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Types
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  IsMpz ⍵   1 if ⍵ is an object reference (assumed to be a gmpz; an invalid one fails when used), else 0
   ⍝  IsNum ⍵   1 if ⍵ is numeric. Test IsMpz first: IsNum makes a prototype, which for an object means ⎕NEW.
   ⍝  IsInt ⍵   1 if ⍵ is an APL integer SCALAR (|⍵| ≤ 2*64-1), else 0.   Vectors, strings and objects give 0.
   ⍝  IsUI  ⍵   1 if ⍵ is an APL integer scalar in 0 … UL_MAX (a C unsigned long), else 0.
   ⍝  IsStr ⍵   1 if ⍵ is a character array (and not an object), else 0.
   ⍝  Str2I ⍵   a string → APL integer scalar ('¯' or '-' for negatives). badAplÊ unless it is exactly one whole number.
   ⍝  ToInt ⍵   any of: APL integer, gmpz (via IntDF), integer string → APL integer. Others: badAplÊ.
   ⍝  Case_T ⍵  classify an operand, returning one of the type codes below. badAplÊ for anything
   ⍝            that is not an object, a string, or a whole-number numeric scalar of ≤ 34 digits.
   ⍝
   ⍝  Case_T classifies by ⎕DR (80|⎕DR): 6 = object; 0 = characters; 3 = I1/I2/I4 integers;
   ⍝  11 = boolean (a scalar boolean literal is an integer, but a computed one can be ⎕DR 11);
   ⍝  5 = F8 float; 7 = decimal float (⎕FR 1287). A numeric vector (including any boolean vector) is rejected.
   ⍝  Floats beyond a C long are rejected (they cannot hold the digits reliably): use a string or a decimal float.
   ⍝  Decimal floats up to 34 digits that exceed a C long are converted through their string form.
   ⍝
   ⍝  The tests are deliberately minimal: a malformed value that gets past them is caught later,
   ⍝  at the ⎕NA call into libgmp.
      UI64_MAX← ¯1+2*64
      I128_MAX← ¯1+10*34                                      ⍝ Largest 34-digit integer: Dyalog's decimal floats outreach GMP's long/UL
      IsMpz← 326= ⎕DR
      IsNum← 0=(⊃0⍴⊢)
      IsInt← { IsMpz ⍵: 0 ⋄ ~IsNum ⍵: 0 ⋄ 0≠ ≢⍴⍵: 0 ⋄ (⍵=⌊⍵)∧ (|⍵)≤ UI64_MAX }
      IsUI← { IsInt ⍵: (⍵≥0)∧(⍵≤UL_MAX) ⋄ 0 }                 ⍝ fits a C unsigned long
      IsStr← { IsMpz ⍵: 0 ⋄ ' '=⊃0⍴⍵ }                        ⍝ Must test IsMpz to avoid creating and destroying an mpz prototype
      Str2I← {
         ok i← ⎕VFI '¯'@('-'∘=)⊢ ⍵
        (1≠ ≢i) ∨ ~∧/ok: ⎕SIGNAL badAplÊ                      ⍝ empty, several numbers, or not a number
         i← ⍬⍴i
        (i≠⌊i) ∨ 'E'∊⍕i: ⎕SIGNAL badAplÊ                      ⍝ fractional, or too big for exact decimal float
         i
      }
      ToInt← { IsInt ⍵: ⍵ ⋄ IsMpz ⍵: ⍵.IntDF ⋄ IsStr ⍵: Str2I ⍵ ⋄ ⎕SIGNAL badAplÊ }
      mpz_T ui_T si_T str_T i128_T← ⍳5                        ⍝  Type codes
      IU_T← ⊃∘si_T ui_T                                       ⍝  IU_T 0 → si_T (negative); IU_T 1 → ui_T (non-negative)
      Case_T← {
         Case← 80|⎕DR ⍵
        Case=6: mpz_T                                         ⍝ object reference
        Case=0: str_T                                         ⍝ characters
        ~(Case∊ 3 5 7 11)∧ 0=≢⍴⍵: ⎕SIGNAL badAplÊ             ⍝ not a numeric scalar
        Case∊ 3 11: IU_T ⍵≥ 0                                 ⍝ I1/I2/I4 (or boolean scalar): integral and small
        ⍵≠⌊⍵: ⎕SIGNAL badAplÊ                                 ⍝ F8 or decimal float that is not a whole number
        IL_MAX≥ |⍵: IU_T ⍵≥ 0                                 ⍝ fits a C long
        (Case=7)∧ I128_MAX≥ |⍵: i128_T                        ⍝ decimal float, up to 34 digits: set via its string form
         ⎕SIGNAL badAplÊ                                      ⍝ F8 beyond a C long, or more than 34 digits
      }
   ⍝:EndSection Types
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Construction and Value Setting
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  Constructors:
   ⍝     ⎕NEW gmpz                 → value 0
   ⍝     ⎕NEW gmpz  obj            → value of obj (gmpz, string, or APL integer), base 10
   ⍝     ⎕NEW gmpz (obj base)      → value of obj (as above, except string obj parsed in base 2…62).
   ⍝     ⎕NEW gmpz,⊂obj base       → Same as ⎕NEW gmpz (obj base)
      ∇ Init0 ; ⎕TRAP
       :Access Public
         :Implements Constructor
         ⎕TRAP← ∆TRAP
         ⍙InitObj                                             ⍝ Set to 0
      ∇
      ∇ Init args ; obj; base; ⎕TRAP
       :Access Public
         :Implements Constructor
         ⎕TRAP← ∆TRAP
         ⍙InitObj
      ⍝  We let ⎕THIS.Set handle invalid bases and values.
         :If IsStr ⊃args                                      ⍝ (init base): a 2-element vector, second element a number
         :Andif IsNum ⊃⌽args
            obj base← args
            base Set obj
         :Else
            Set args
         :EndIf
      ∇
   ⍝  ⍙InitObj (private): allocate 16 bytes for the mpz_t and mpz_init it.
   ⍝  If anything fails after malloc, the memory is released before badInitÊ is signalled.
   ⍝  We separate the initialisation and set so that we can ensure any system memory allocated
   ⍝  is freed, no matter what error occurs.
      ∇ ⍙InitObj ; err
         err← 0
         :Trap 0                                              ⍝ Capture problems so we can free storage!
            ⍙ptr← RAW.Malloc 16                               ⍝ mpz_t is 16 bytes on 64-bit
            :If ⍙ptr=0 ⋄ ⎕SIGNAL badInitÊ                     ⍝ Allocation failed
            :Else      ⋄ {}RAW.Init ⍙ptr
            :EndIf
         :Else
            err← 1
         :EndTrap
         :If err
            :If ×⍙ptr ⋄ {}RAW.Clear ⍙ptr ⋄ :EndIf
            {}RAW.Free ⍙ptr ⋄ ⍙ptr← 0
            ⎕SIGNAL badInitÊ
         :EndIf
         :If DEBUG≥1 ⋄ ⎕← 'Alloc gmpz [',(⍕⍙ptr),']' ⋄ :EndIf
      ∇
      
   ⍝  New0:  mpz← gmpz.New0           — new object with value 0   (shared method)
      ∇ mpz← New0 ; ⎕TRAP
       :Access Public Shared
         ⎕TRAP← ∆TRAP
         mpz← ⎕NEW ⎕THIS
      ∇
   ⍝  New:   mpz← [base] gmpz.New init   — new object from init (shared method)
   ⍝         base defaults to 10 and only matters when init is a string.
      ∇ mpz← {base} New init ; ⎕TRAP
       :Access Public Shared
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ mpz← ⎕NEW ∆THIS init
         :Else ⋄ mpz← ⎕NEW ∆THIS (init base)
         :EndIf
      ∇
      
   ⍝ Set: overwrite ⎕THIS with a new value.    [base] obj.Set b
   ⍝   b may be a gmpz, an APL integer, or a string ('¯' is read as '-').
   ⍝   base (default 10) applies only to strings; GMP accepts a base ∊ 2…62.
   ⍝   Returns ⎕THIS (shy), so calls can be chained: (x.Set 5).Inc
   ⍝   Errors: badObjÊ if the string is not a valid integer in that base;
   ⍝           badAplÊ if a numeric b is not a whole-number scalar (it is not truncated);
   ⍝           baseXtraÊ if a base is given with a non-string b.
      ∇ {mpz}← {base} Set b ; bP; ⎕TRAP
       :Access Public Instance
         ⎕TRAP← ∆TRAP
         mpz← ⎕THIS
         :Select Case_T b
          :Case str_T
            :If 900⌶⍬ ⋄ base← 10 ⋄ :EndIf
            ⍙SetStr b base
          :Case mpz_T
            ⎕SIGNAL baseXtraÊ/⍨ ~900⌶⍬
            :If ⍙ptr≠ bP← b.ptr
               {}RAW.Set ⍙ptr bP
            :EndIf
          :Caselist si_T ui_T                                 ⍝ any integer that fits a C long
            ⎕SIGNAL baseXtraÊ/⍨ ~900⌶⍬
            {}RAW.SetI ⍙ptr b
          :Case i128_T                                        ⍝ Bigger than a C long: go via the (decimal) string
            ⎕SIGNAL baseXtraÊ/⍨ ~900⌶⍬
            ⍙SetStr (⍕b) 10
         :Else
            ⎕SIGNAL badAplÊ
         :EndSelect
      ∇
   ⍝ ⍙SetStr (str base): private. Parse a string into ⎕THIS. GMP rejects a bad string or base (badObjÊ).
      ∇ ⍙SetStr (str base) ; rc
         str← '-'@('¯'∘=),str
         rc← RAW.SetStr ⍙ptr str base                         ⍝ SetStr will handle invalid numeric strings.
         ⎕SIGNAL badObjÊ/⍨ rc≠0
      ∇
      
   ⍝ Copy: c← a.Copy — a new, independent gmpz with the same value.  (Plain  b← a  only aliases.)
      ∇ c← Copy ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         c← ⎕NEW ∆THIS ⎕THIS
      ∇
      
   ⍝ Destructor: runs automatically when the object is expunged or goes out of scope.
      ∇ Free
         :Implements Destructor
         :If DEBUG≥1 ⋄ ⎕← 'Free gmpz [',(⍕⍙ptr),']' ⋄ :EndIf
         :If ⍙ptr≠ 0
            {}RAW.Clear ⍙ptr ⋄ {}RAW.Free ⍙ptr
            ⍙ptr← 0
         :EndIf
      ∇
   ⍝:EndSection Construction and Value Setting
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section statics[0..2]: Global mpz's used in _Dyad_ and elsewhere
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  Three scratch mpz's shared by all instances. They hold non-gmpz operands
   ⍝  (strings, negative or large APL integers) only for the duration of a call.
   ⍝  Consequence: the scratch values are meaningless between calls.
   ⍝  Thread safety: every method that uses the scratch objects wraps that use in
   ⍝  :Hold ∆STATICS … :EndHold, so concurrent threads queue for them. Anything that
   ⍝  calls Ptr0/Ptr1/Ptr2 or Mpz0 MUST do so inside such a :Hold.
   ⍝  InitStatics is only DEFINED here; it is called near the end of the file (see MAINTAINERS).
      ∇ {ok}← InitStatics ; _
         statics← gmpz.New¨ 3⍴0                               ⍝ Declare 3 statics (or as needed)
         ∆STATICS← 'statics'                                  ⍝ Used for :HOLDing
      ⍝  Ptr0, etc: these typically take fn arguments (usually a and b) and copy any
      ⍝  values into statics[0] and return statics[0].ptr.
      ⍝ If ⍵ is an mpz, its own pointer is returned as is.
         StatPtr← {  IsMpz ⍵: ⍵.ptr ⋄ ((⍺⊃statics).Set ⍵).ptr }
         Mpz0← { IsMpz ⍵: ⍵ ⋄ (0⊃statics).Set ⍵ }             ⍝ ⍵ itself if a gmpz; else statics[0] holding ⍵ (base 10)
         _← { (⍵⊃statics).⎕DF 'Static mpz #',⍕⍵ }¨0 1 2
         Ptr0← 0∘StatPtr
         Ptr1← 1∘StatPtr
         Ptr2← 2∘StatPtr
         ok← 1
      ∇
   ⍝:EndSection statics[0..2]: Global mpz's used in _Dyad_ and elsewhere
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Support Operators
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  _Dyad_: a 2-operand operator for use with common functions
   ⍝
   ⍝    [nzFlag] (fn1 _Dyad_ fn2) (a b)
   ⍝
   ⍝      fn1     GMP routine taking (dest src1 src2) as mpz pointers, e.g. RAW.Add
   ⍝      fn2     the matching "unsigned int" routine,                 e.g. RAW.AddU
   ⍝      a, b    operands (any supported type); the destination is always ⎕THIS
   ⍝      nzFlag  1 → signal divZÊ if b is zero (division); default 0
   ⍝
   ⍝    Dispatch on the type of b:
   ⍝      APL integer ≥ 0 and ≤ UL_MAX → fn2 with b passed directly (fast path)
   ⍝      gmpz object, string, APL integer < 0 or > UL_MAX → b is made into an mpz (a gmpz is used as is;
   ⍝                                     otherwise it is copied into statics[1]), then fn1
   ⍝    `a` is always passed through (Ptr0 a): used as is if it is a gmpz, else copied into statics[0].
   ⍝    While Gmp allows for uints on the left (a) in some cases, we convert (a) to a gmpz obj
   ⍝    no matter what (this can be changed with additional coding).
   ⍝    The object a or b may be ⎕THIS itself — Gmp handles that.
   ⍝    Returns ⎕THIS.
      ∇ mpz← {nzFlag} (fn1 _Dyad_ fn2) (a b) ; aP; bP
         :If 900⌶⍬ ⋄ nzFlag← 0 ⋄ :EndIf                       ⍝ Must b be non-zero, no matter the type?
         :Hold ∆STATICS
            aP← Ptr0 a
            :If IsUI b                                        ⍝ APL unsigned integer in UL range, use fast path
               :If nzFlag ⋄ :Andif 0= b ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf
               {} fn2 ⍙ptr aP b                               ⍝ ==>  fn2  <==
            :Else                                             ⍝ b is an mpz, a string, a negative integer, or too large for UL.
               bP← Ptr1 b
               :If nzFlag ⋄ :Andif 0= PSignum bP ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf
               {} fn1 ⍙ptr aP bP                              ⍝ ==>  fn1  <==
            :EndIf
         :EndHold
         mpz← ⎕THIS
      ∇
   ⍝:EndSection Support Operators
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Value Access: ⌷, ptr, Signum, Int64, IntDF, VFI, GetInBase, Get, sizes
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  Allow user access to the string form of the mpz.
   ⍝  If a is a gmpz object in APL, then
   ⍝     ⌷a
   ⍝  is the string representation (decimal, with '¯' for negatives).
      :Property Simple Default String
       :Access Public Instance
      ⍝  Retrieve the gmpz integer as a string of any length!
         ∇ buf← get ; n; ⎕TRAP
            ⎕TRAP← ∆TRAP
            ⎕SIGNAL (⍙ptr=0)/ badObjÊ                         ⍝ Whoops! Nothing there.
            n← 2+ RAW.SizeInBase ⍙ptr 10                      ⍝ digits + possible sign + NUL
         ⍝ Create a place in APL for the null-terminated string. from GetStr
            buf← '¯'@('-'∘=)⊢ RAW.GetStr (n⍴⎕UCS 0) 10 ⍙ptr   ⍝ Import that result
         ∇
      :EndProperty
      
   ⍝ ptr: the address of the underlying mpz_t (0 if released). Mainly for internal use.
      ∇ p← ptr ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         p← ⍙ptr
      ∇
      
   ⍝  Signum: ¯1, 0 or 1. A fast (but in the weeds) way to get the sign from an mpz int.
   ⍝  It reads the `_mp_size` field of the mpz_t directly (its sign is the integer's sign)
   ⍝  rather than calling into GMP. If this makes you nervous, use the RAW.CmpI call
   ⍝  as shown in [Alt] comment in PSignum.
      ∇ si← Signum ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         si← PSignum ⍙ptr
      ∇
   ⍝ PSignum ptr: Signum when you already have a pointer to an mpz_t.
   ⍝  Copies 8 bytes from offset 0 of the mpz_t as two I4s; the second I4 is
   ⍝  _mp_size, whose sign is the integer's sign. 1⌷ is correct only under
   ⍝  ⎕IO←0, which this class sets. A null pointer signals badObjÊ.
      ∇ si← PSignum ptr ; CopyIVec
      ⍝  [Alt]  si← RAW.CmpI ptr 0   ⍝ Replaces two lines here.
         ⎕SIGNAL (ptr=0)/ badObjÊ
         CopyIVec← { RAW.MemCpyI2 (⍵⍴ 0) ⍺ (4× ⍵) }           ⍝ Get the sign of the variable at offset 0 (two 4-byte integers)
         si← ×1⌷ ptr CopyIVec 2
      ∇
      
   ⍝  int← ⍵.Int64  — ⍵ as a signed C long (64-bit on Unix; 32-bit on Windows), as an APL integer.
   ⍝                  Errors: badIntÊ if the value does not fit. (Use IntDF for up to 34 digits.)
      ∇ i64← Int64 ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         ⎕SIGNAL badIntÊ/⍨ 0= RAW.IntFits ⍙ptr
         i64← RAW.Int ⍙ptr
      ∇
   ⍝  int← ⍵.IntDF  — ⍵ as an APL integer in decimal-float form (⎕FR 1287): exact up to 34 digits (±(¯1+10*34)).
   ⍝                  Errors: badIntÊ if it has more digits than that. Uses ⎕VFI on the string form.
      ∇ i← IntDF ; r; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         r← ⍙TryDF
         ⎕SIGNAL badIntÊ/⍨ 0= ⊃r
         i← ⊃⌽r
      ∇
   ⍝ rc int← ⍵.VFI;  If ⍵ fits in an APL decimal float (up to 34 digits, as IntDF), returns (1 int),
   ⍝                 else returns (0 0).    (Like ⎕VFI, but never signals an error.)
      ∇ int2← VFI ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         int2← ⍙TryDF
      ∇
   ⍝ ⍙TryDF: private. (1 value) if ⎕THIS has ≤ 34 digits, else (0 0).
   ⍝ SizeInBase is exact or one too big, so 36 or more means at least 35 digits: skip ⎕VFI for those.
      ∇ r← ⍙TryDF ; ok; i
         r← 0 0
         :If 36> RAW.SizeInBase ⍙ptr 10
            ok i← ⎕VFI ⌷⎕THIS
            :If (∧/ok)∧ 1=≢i
               i← ⍬⍴i
               :If (|i)≤ I128_MAX ⋄ r← 1 i ⋄ :EndIf
            :EndIf
         :EndIf
      ∇
      
   ⍝  f← ⍵.Float — ⍵ as an approximate APL float (mpz_get_d: truncated toward zero, 53 bits).
   ⍝               Errors: badIntÊ if ⍵ has more than 1024 bits (it could exceed the largest double).
   ⍝               The C double is converted to a decimal float (⎕FR 1287) by its shortest decimal form, about 17 digits:
   ⍝               2*64 comes back as 18446744073709552000, not 18446744073709551616. Compare results with a tolerance.
      ∇ f← Float ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         ⎕SIGNAL badIntÊ/⍨ 1024< RAW.SizeInBase ⍙ptr 2
         f← RAW.GetD ⍙ptr
      ∇
      
   ⍝ str←  ⍺.GetInBase n  -- Retrieves ⍺ as a string in base n.
   ⍝ base∊ 2 … 62, and the result uses '¯' for negatives, like the ⌷ property.
      ∇ str← GetInBase base ; n; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         base← ToInt base
         ⎕SIGNAL badAplÊ/⍨ (base<2) ∨ (base>62)
         n← 2+ RAW.SizeInBase ⍙ptr base                       ⍝ digits + possible sign + NUL
      ⍝ Create a place in APL for the null-terminated string. from GetStr
         str← '¯'@('-'∘=)⊢ RAW.GetStr (n⍴⎕UCS 0) base ⍙ptr    ⍝ Import that result
      ∇
      
   ⍝  str← {base←10} gmpz.Get b   (shared)
   ⍝  b is a gmpz, an APL integer or a decimal string (a string is always read in base 10).
   ⍝  Returns b as a string in the given base (2…62). Like APL's ⍺⊤⍵, but giving a string.
      ∇ str← {base} Get b ; x; ⎕TRAP
       :Access Public Shared
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ base← 10 ⋄ :EndIf
         :Hold ∆STATICS
            x← Mpz0 b                                         ⍝ b itself if a gmpz; else statics[0] holding b
            str← x.GetInBase base
         :EndHold
      ∇
      
   ⍝  len← obj.StrLen : Returns the number of characters required by the object in APL,
   ⍝                   including the sign, if any.  Equivalent to ≢⌷x.
   ⍝  Example:   (bigNum.StrLen ≡ ≢⌷bigNum)                   ⍝ Returns 1 for gmpz objects.
   ⍝  Exact, without generating the string.
      ∇ len← StrLen ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         len← ⍙StrLenInBase 10
      ∇
   ⍝  len← obj.StrLenInBase base : As StrLen, but for the string in the given base (2…62):
   ⍝                   Equivalent to ≢obj.GetInBase base, including the sign.
      ∇ len← StrLenInBase base ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         base← ToInt base
         ⎕SIGNAL badAplÊ/⍨ (base<2) ∨ (base>62)
         len← ⍙StrLenInBase base
      ∇
   ⍝ ⍙StrLenInBase base: private; base already validated.
   ⍝ SizeInBase is the true digit count, or 1 too many. To decide, compare |x| with base*n-1:
   ⍝ do it in APL if x fits a C long (IntFits), else with an mpz (base*n-1 by UiPow).
      ∇ len← ⍙StrLenInBase base ; n; v; t
         n← RAW.SizeInBase ⍙ptr base
         :If RAW.IntFits ⍙ptr
            v← RAW.Int ⍙ptr
            len← (n- (n>1)∧ (|v)< base*n-1) + v<0             ⍝ n=1 is exact (guards 0)
         :Else
            t← ⎕NEW ∆THIS                                     ⍝ scratch; freed on exit
            {}RAW.UiPow t.ptr base (n-1)                      ⍝ t← base*n-1
            len← (n- 0> RAW.CmpAbs ⍙ptr t.ptr) + ¯1= PSignum ⍙ptr
         :EndIf
      ∇
      
   ⍝  len← obj.BitLen  : Returns the number of bits required to hold the object in two's complement,
   ⍝                  including the sign bit: BitLen 0 is 1, BitLen 7 is 4, BitLen 8 is 5, BitLen ¯8 is 4.
   ⍝                  It equals ≢obj.Bits. Bits are what can be accessed and set via index. See obj.Bit[ix].
      ∇ len← BitLen ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         len← LenMinBits ⍙ptr
      ∇
   ⍝ Determine minimum bit-width in twos complement.
   ⍝   len← LenMinBits ptr
      LenMinBits← {
         sgn← PSignum ⍵
        sgn= 0: 1
        sgn> 0: 1 + RAW.SizeInBase ⍵ 2                        ⍝ magnitude bits (exact in base 2) plus a 0 sign bit
         k← RAW.SizeInBase ⍵ 2
         lowBit← RAW.Scan1 ⍵ 0                                ⍝ 0-based index of the lowest '1' bit in magnitude
         k + lowBit≠ k- 1                                     ⍝ k bits if exact power of 2, else k + 1
      }
   ⍝:EndSection Value Access
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Arithmetic
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  Common calling forms for the dyadic methods in this section (mpz = the receiver):
   ⍝        mpz.Op b      mpz← mpz Op b      (left operand defaults to ⎕THIS)
   ⍝      a mpz.Op b      mpz← a Op b        (mpz is only the destination)
   ⍝  The result is shy and is always ⎕THIS, so calls can be chained.
      
   ⍝  mpz.Add b / a mpz.Add b   →→   mpz← a + b
      ∇ {mpz}← {a} Add b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         mpz← RAW.Add _Dyad_ RAW.AddU a b
      ∇
   ⍝  mpz.Sub b / a mpz.Sub b   →→   mpz← a - b
      ∇ {mpz}← {a} Sub b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         mpz← RAW.Sub _Dyad_ RAW.SubU a b
      ∇
   ⍝  mpz.Mul b / a mpz.Mul b   →→   mpz← a × b
      ∇ {mpz}← {a} Mul b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         mpz← RAW.Mul _Dyad_ RAW.MulU a b
      ∇
   ⍝  a c.Div b
   ⍝      mpz← Floor( a ÷ b )  (floored quotient)
   ⍝  a defaults to c.
   ⍝  Errors: divZÊ if b is 0.
      ∇ {mpz}← {a} Div b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         mpz← 1 RAW.Div _Dyad_ RAW.DivU a b                   ⍝ ⍺ of 1: Ensure b≠0
      ∇
   ⍝   rem← a c.DivRem b.
   ⍝      Sets c to the floored quotient a÷b, and returns the remainder rem (shy) as a NEW gmpz: rem← b|a.
   ⍝   a defaults to c.
   ⍝   DivRemU returns the remainder as a UL as well; that return value is
   ⍝   ignored — the remainder is in rem, not in statics[2].
   ⍝   Errors: divZÊ if b is 0.
      ∇ {rem}← {a} DivRem b ; aP; bP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         rem← ⎕NEW ∆THIS                                      ⍝ remainder returned as a new gmpz
         :Hold ∆STATICS
            aP← Ptr0 a
            :If IsUI b
               ⎕SIGNAL divZÊ/⍨ 0= b
               {}RAW.DivRemU ⍙ptr rem.ptr aP b                ⍝ fdiv_qr_ui: remainder also returned as UL, ignored
            :Else
               bP← Ptr1 b
               ⎕SIGNAL divZÊ/⍨ 0= PSignum bP
               {}RAW.DivRem ⍙ptr rem.ptr aP bP                ⍝ fdiv_qr: q=⍙ptr, r=remP
            :EndIf
         :EndHold
      ∇
   ⍝ modulus mpz.Res b   →→   mpz← modulus | b      (dyadic only: there is no default left operand)
   ⍝ The Res residue/modulo is in the APL order using APL's rules.
   ⍝ APL's ⍺|⍵: ⍺ is the divisor, result is floored (sign of ⍺); 0|⍵ is ⍵
   ⍝ * In APL, when the left argument (divisor) is 0, the residue/modulo function is
   ⍝   defined to return the right argument unchanged.
   ⍝ Special case: if the modulus is the (unsigned) integer 2, we use a fast bit test:
   ⍝   ⎕THIS is set to bit 0 of b (0 if b is even, 1 if b is odd).
      ∇ {mpz}← mod Res b ; modP; bP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            bP← Ptr1 b
            :If IsUI mod
               :Select mod
                :Case 0 ⋄ :If ⍙ptr≠ bP ⋄ {}RAW.Set ⍙ptr bP ⋄ :EndIf   ⍝ b← 0|b
                :Case 2 ⋄ {}⎕THIS.Set RAW.TstBit bP 0         ⍝ ⎕THIS← bit 0 of b
               :Else
                  {}RAW.FRemU ⍙ptr bP mod
               :EndSelect
            :Else
               modP← Ptr0 mod
               :If 0= PSignum modP                            ⍝ zero gmpz or string modulus
                  :If ⍙ptr≠ bP ⋄ {}RAW.Set ⍙ptr bP ⋄ :EndIf   ⍝ b← 0| b
               :Else
                  {}RAW.FRem ⍙ptr bP modP
               :EndIf
            :EndIf
         :EndHold
         mpz← ⎕THIS
      ∇
   ⍝  mpz.Neg   →→   mpz← -mpz       (niladic, in place.  To set c← -b:  (c.Set b).Neg )
      ∇ {mpz}← Neg ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         {}RAW.Neg ⍙ptr ⍙ptr
         mpz← ⎕THIS
      ∇
   ⍝  mpz.Abs   →→   mpz← |mpz       (niladic, in place.  To set c← |b:  (c.Set b).Abs )
      ∇ {mpz}← Abs ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         {}RAW.Abs ⍙ptr ⍙ptr
         mpz← ⎕THIS
      ∇
   ⍝  ⍵.Inc - Increments ⍵ by 1 (in place)
      ∇ {mpz}← Inc ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         {}RAW.AddU ⍙ptr ⍙ptr 1
         mpz← ⎕THIS
      ∇
   ⍝  ⍵.Dec - Decrements ⍵ by 1 (in place)
      ∇ {mpz}← Dec ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         {}RAW.SubU ⍙ptr ⍙ptr 1
         mpz← ⎕THIS
      ∇
   ⍝  ⍵.Even / ⍵.Odd - parity tests (via the lowest bit, which is correct for negatives too);
   ⍝  return a visible 1 or 0.
      ∇ bool← Even ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         bool← 0= RAW.TstBit ⍙ptr 0
      ∇
      ∇ bool← Odd ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         bool← 1= RAW.TstBit ⍙ptr 0
      ∇
   ⍝  mpz.Gcd b / a mpz.Gcd b   →→   mpz← a∨b   (greatest common divisor, ≥ 0)
      ∇ {mpz}← {a} Gcd b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         mpz← RAW.Gcd _Dyad_ RAW.GcdU a b
      ∇
   ⍝  mpz.Lcm b / a mpz.Lcm b   →→   mpz← a∧b   (least common multiple, ≥ 0)
      ∇ {mpz}← {a} Lcm b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         mpz← RAW.Lcm _Dyad_ RAW.LcmU a b
      ∇
   ⍝  mpz.Divexact b / a mpz.Divexact b   →→   mpz← a ÷ b, FAST but only valid when b divides a exactly
   ⍝  (the result is otherwise meaningless). Use Div for a general floored quotient.  divZÊ if b is 0.
      ∇ {mpz}← {a} Divexact b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         mpz← 1 RAW.Divexact _Dyad_ RAW.DivexactU a b
      ∇
   ⍝  bool← ⍵.Divisible b  -- Is ⍵ divisible by b (b: any kind of number)?   Returns 0 or 1.
   ⍝  Unlike standard division functions which throw exceptions or crash on zero,
   ⍝  mpz_divisible_p explicitly accepts d = 0. Following mathematical rules, only 0 is considered divisible by 0.
      ∇ bool← Divisible b ; bP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            bP← Ptr1 b
            bool← 0≠ RAW.Divisible ⍙ptr bP
         :EndHold
      ∇
   ⍝  mpz.Fac n   →→   mpz← !n.    n must be a non-negative integer fitting in a
   ⍝    C unsigned long: 0 ≤ num ≤ UL_MAX (32-bit on Windows, 64-bit elsewhere).
   ⍝    n may be an APL integer, an integer string, or a gmpz.
   ⍝  Large factorials are limited only by memory and time — see the resource note in the header.
      ∇ {mpz}← Fac num ; ok; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If IsMpz num
            num← num.Int64                                    ⍝ Issues its own error, if needed!
         :ElseIf IsStr num
            ok num← ⎕VFI num
            ⎕SIGNAL facBadÊ/⍨ (1≠≢ok) ∨ ~∧/ok
            num← ⍬⍴num
         :EndIf
         ⎕SIGNAL facBadÊ/⍨ ~IsUI num                          ⍝ also catches negatives, fractions, vectors
         {}RAW.Fac ⍙ptr num
         mpz← ⎕THIS
      ∇
   ⍝:EndSection Arithmetic
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Powers, Roots, Modular Arithmetic, Primes
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  a Pow exp: Both 10*3 (power) and 10*÷3 (root)
   ⍝    exp must be a non-negative APL integer (power) or, to within 1E¯9, the
   ⍝    reciprocal of a positive integer (n-th root, truncated).
   ⍝    Even roots of negative numbers are rejected (powÊ).
   ⍝    Left operand a defaults to ⎕THIS.
      ∇ {mpz}← {a} Pow exp ; aP; inv; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            :If IsInt exp
               ⎕SIGNAL powÊ/⍨ (exp<0) ∨ exp>UL_MAX            ⍝ Pow (pow_ui) takes a non-negative UL exponent
               {}RAW.Pow ⍙ptr aP exp                          ⍝ exp is a non-negative integer.
            :Else
            ⍝ Integral Inverse: Do root.  exp must be (nearly) ÷ an integer, e.g. ÷3,
            ⍝ and if the left operand is negative, the integer must be an odd number.
               ⎕SIGNAL powÊ/⍨ IsMpz exp                       ⍝ (test IsMpz first: IsNum would ⎕NEW a prototype)
               ⎕SIGNAL powÊ/⍨ ~IsNum exp
               ⎕SIGNAL powÊ/⍨ 1≠ ≢,exp
               ⎕SIGNAL powÊ/⍨ ~(exp>0)∧ exp<1
               inv← ⌊0.5+ ÷exp
               :If (inv≥1) ∧ (inv≤UL_MAX) ∧ (1E¯9≥ |1- exp× inv) ∧ ((¯1≠ PSignum aP) ∨ 0≠2| inv)
                  {}RAW.Root ⍙ptr aP inv
               :Else
                  ⎕SIGNAL powÊ
               :EndIf
            :EndIf
         :EndHold
         mpz← ⎕THIS
      ∇
      
   ⍝ mpz.PowM (exp mod) / a mpz.PowM (exp mod)   →→   mpz← mod | a*exp
   ⍝ exp and mod may be gmpz objects, APL integers, or strings.
   ⍝ Guards: exp must be ≥ 0 (powÊ otherwise); mod must be > 0
   ⍝ (divZÊ for mod = 0, powÊ for mod < 0).
      ∇ {mpz}← {a} PowM exp_mod ; aP; exp; expP; mod; modP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         exp mod← exp_mod                                     ⍝ Unpack exponent and modulus
         :Hold ∆STATICS
            aP← Ptr0 a                                        ⍝ Base -> statics[0] if not a gmpz
            expP← Ptr1 exp                                    ⍝ Exponent -> statics[1]
            modP← Ptr2 mod                                    ⍝ Modulus -> statics[2]
            ⎕SIGNAL powÊ/⍨ 0> PSignum expP                    ⍝ Exponent cannot be negative
            ⎕SIGNAL divZÊ/⍨ 0= PSignum modP                   ⍝ Modulus cannot be zero
            ⎕SIGNAL powÊ/⍨ 0> PSignum modP                    ⍝ Modulus cannot be negative
            {}RAW.PowM ⍙ptr aP expP modP                      ⍝ Call GMP: ⍙ptr← (aP ^ expP) % modP
         :EndHold
         mpz← ⎕THIS
      ∇
      
   ⍝ rc← {a} Invert mod   — compute modular inverse a^-1 mod mod.
   ⍝ Updates receiver with the inverse if it exists, returning 1 (success) or 0 (no inverse;
   ⍝ the receiver is then meaningless).
   ⍝ Guards: mod must be > 0 (divZÊ for mod = 0, powÊ for mod < 0).
      ∇ rc← {a} Invert mod ; aP; modP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         :Hold ∆STATICS
            aP← Ptr0 a ⋄ modP← Ptr1 mod
            ⎕SIGNAL divZÊ/⍨ 0= PSignum modP                   ⍝ Modulus cannot be zero
            ⎕SIGNAL powÊ/⍨ 0> PSignum modP                    ⍝ Modulus cannot be negative
            rc← RAW.Invert ⍙ptr aP modP                       ⍝ Returns non-zero on success, 0 if none
         :EndHold
      ∇
      
   ⍝ rc← {a} Jacobi b   — compute the Jacobi symbol (a/b), returning -1, 0, or 1.
   ⍝ b must be an odd integer (per GMP specifications); an even b signals badAplÊ.
      ∇ rc← {a} Jacobi b ; aP; bP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            bP← Ptr1 b
            ⎕SIGNAL badAplÊ/⍨ ~RAW.TstBit bP 0
            rc← RAW.Jacobi aP bP
         :EndHold
      ∇
      
   ⍝  rc← ⍵.ProbabPrime reps      (instance method: tests ⍙ptr, the receiver)
   ⍝      reps: REQUIRED right argument. Reasonable values are between 15 and 50.
   ⍝            Give ⍬ or 0 for the default (24, a "good" compromise).
   ⍝  Return 2 if n is definitely prime,
   ⍝  return 1 if n is probably prime (without being certain), or
   ⍝  return 0 if n is definitely non-prime.
   ⍝  The Gmp manual suggests values between 15 and 50 are reasonable, and
   ⍝  says that with 24 reps the chance of a composite slipping through is
   ⍝  negligible for practical purposes.
      ∇ bool← ProbabPrime cycles ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 0=≢,cycles ⋄ cycles← 24
         :Else
            cycles← ToInt cycles
            :If cycles=0 ⋄ cycles← 24 ⋄ :EndIf
         :EndIf
         ⎕SIGNAL primeÊ/⍨ (~IsUI cycles) ∨ (cycles>¯1+2*31)
         bool← RAW.ProbabPrime ⍙ptr cycles
      ∇
   ⍝  mpz.NextPrime ⍵: Sets mpz to the next (pseudo)prime greater than ⍵
      ∇ {mpz}← NextPrime b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            {}RAW.NextPrime ⍙ptr (Ptr1 b)
         :EndHold
         mpz← ⎕THIS
      ∇
   ⍝  PrevPrime:  mpz← ⍺.PrevPrime ⍵
   ⍝  Sets mpz to the (pseudo)prime previous to ⍵ (GMP ≥ 6.3, mpz_prevprime).
   ⍝  Errors: noPrevPrimeÊ if there is none (⍵ ≤ 2).  See PrevPrime2 for the certainty.
      ∇ {mpz}← PrevPrime b ; rc; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            rc← RAW.PrevPrime ⍙ptr (Ptr1 b)
         :EndHold
         ⎕SIGNAL noPrevPrimeÊ/⍨ 0= rc
         mpz← ⎕THIS
      ∇
   ⍝  PrevPrime2:  (mpz rc)← ⍺.PrevPrime2 ⍵
   ⍝  Like PrevPrime, but also returns the return code of mpz_prevprime:
   ⍝  rc is 2 (definitely prime), 1 (probably prime), or 0 (no previous prime exists; mpz is meaningless).
   ⍝  It never signals noPrevPrimeÊ.
      ∇ mpz_rc← PrevPrime2 b ; rc; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            rc← RAW.PrevPrime ⍙ptr (Ptr1 b)
         :EndHold
         mpz_rc← ⎕THIS rc
      ∇
      
   ⍝ mpz← {n} mpz.Bin k   →→   mpz← C(n,k): n choose k.   n defaults to the receiver; it may be negative
   ⍝   (GMP uses the generalised binomial). k must be a non-negative integer no larger than a C unsigned long
   ⍝   (badUIntÊ otherwise). Large results are limited only by memory and time.  APL's  k!n  is  n c.Bin k.
      ∇ {mpz}← {n} Bin k ; nP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         k← ToInt k
         ⎕SIGNAL badUIntÊ/⍨ ~IsUI k
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ nP← ⍙ptr ⋄ :Else ⋄ nP← Ptr0 n ⋄ :EndIf
            {}RAW.Bin ⍙ptr nP k
         :EndHold
         mpz← ⎕THIS
      ∇
   ⍝ mpz.Fib n  →→  mpz← the n-th Fibonacci number (Fib 0 is 0, Fib 1 is 1).  n: non-negative integer (badUIntÊ).
      ∇ {mpz}← Fib n ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         n← ToInt n
         ⎕SIGNAL badUIntÊ/⍨ ~IsUI n
         {}RAW.Fib ⍙ptr n
         mpz← ⎕THIS
      ∇
   ⍝ mpz.Primorial n  →→  mpz← the product of all primes ≤ n (Primorial 0 and 1 are 1).  n: as Fib.
      ∇ {mpz}← Primorial n ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         n← ToInt n
         ⎕SIGNAL badUIntÊ/⍨ ~IsUI n
         {}RAW.Primorial ⍙ptr n
         mpz← ⎕THIS
      ∇
   ⍝ rem← mpz.SqrtRem b  →→  mpz← ⌊√b  and the returned (shy) NEW gmpz rem← b - mpz*2.
   ⍝   Errors: sqrtNegÊ if b is negative.  (For the root alone, Pow÷2 does the same.)
      ∇ {rem}← SqrtRem b ; bP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         rem← ⎕NEW ∆THIS
         :Hold ∆STATICS
            bP← Ptr1 b
            ⎕SIGNAL sqrtNegÊ/⍨ 0> PSignum bP
            {}RAW.SqrtRem ⍙ptr rem.ptr bP
         :EndHold
      ∇
   ⍝ st← {a} mpz.GcdExt b   →→   Extended GCD: mpz← a∨b (the gcd, as Gcd gives) and the returned (shy) pair
   ⍝   st← s t of NEW gmpz's, with  (a×s)+(b×t) = mpz.   a defaults to the receiver.  (Invert is built on this.)
      ∇ {st}← {a} GcdExt b ; aP; bP; s; t; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         s← ⎕NEW ∆THIS
         t← ⎕NEW ∆THIS
         :Hold ∆STATICS
            aP← Ptr0 a ⋄ bP← Ptr1 b
            {}RAW.GcdExt ⍙ptr s.ptr t.ptr aP bP
         :EndHold
         st← s t
      ∇
   ⍝ bool← mpz.IsSquare / mpz.IsPower — is the receiver a perfect square / a perfect power (a*k, k>1)?
   ⍝   Visible 0/1.  0 and 1 are both; negatives are never squares, and are powers only if an odd power.
      ∇ bool← IsSquare ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         bool← 0≠ RAW.PerfectSquare ⍙ptr
      ∇
      ∇ bool← IsPower ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         bool← 0≠ RAW.PerfectPower ⍙ptr
      ∇
   ⍝ bool← {a} mpz.Congruent (b m)   →→   Is a ≡ b (mod m)?   a defaults to the receiver. Visible 0/1.
   ⍝   m = 0: true only if a = b.  b and m: gmpz, integer or string.
      ∇ bool← {a} Congruent b_m ; aP; b; bP; m; mP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         b m← b_m
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            bP← Ptr1 b
            mP← Ptr2 m
            bool← 0≠ RAW.Congruent aP bP mP
         :EndHold
      ∇
   ⍝:EndSection Powers, Roots, Modular Arithmetic, Primes
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Bit Logic: Shift, And/Or/Xor, TestBit/SetBit/ClrBit/Flip, Scan/Iota
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  mpz← h mpz.Shift b  →→  mpz← b × 2*h      (dyadic only)
   ⍝    h > 0  shift left  (multiply by 2*h, where * is power)
   ⍝    h < 0  shift right (divide by 2*|h|, truncating toward zero)
   ⍝    h = 0  copy b unchanged
   ⍝    h may be an APL integer, integer string or gmpz; it must be a whole number (else shiftÊ)
   ⍝    with |h| ≤ UL_MAX.
   ⍝  mpz← h mpz.ShiftFloor b: the same, except that a right shift FLOORS (toward ¯∞, like APL's ⌊b÷2*|h|):
   ⍝    ¯1 Shift ¯7 is ¯3, but ¯1 ShiftFloor ¯7 is ¯4.  They differ only for negative b.
      ∇ {mpz}← h Shift b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         mpz← 0 ⍙Shift h b
      ∇
      ∇ {mpz}← h ShiftFloor b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         mpz← 1 ⍙Shift h b
      ∇
   ⍝ ⍙Shift (h b): private, dyadic. fl∊ 0 1: 1 floors a right shift, 0 truncates it.
      ∇ mpz← fl ⍙Shift (h b) ; bP
         :If ~IsMpz h                                         ⍝ Non-integer numeric shift
         :Andif IsNum h
         :Andif h≠⌊h
            ⎕SIGNAL shiftÊ
         :EndIf
         h← ToInt h                                           ⍝ h: how much to shift (gmpz / string / APL int)
         ⎕SIGNAL shiftÊ/⍨ (|h)>UL_MAX                         ⍝ Shift amount must fit in a UL
         :Hold ∆STATICS
            bP← Ptr1 b
            :Select ×h
             :Case  1 ⋄ {}RAW.ShiftL ⍙ptr bP h                ⍝ left shift: a multiplication by 2*h
             :Case ¯1
               :If fl ⋄ {}RAW.ShiftRF ⍙ptr bP (-h)            ⍝ right shift: floored division by 2*|h|
               :Else  ⋄ {}RAW.ShiftR ⍙ptr bP (-h)             ⍝ right shift: division by 2*|h|, truncating toward zero
               :EndIf
            :Else
               :If ⍙ptr≠ bP ⋄ {}RAW.Set ⍙ptr bP ⋄ :EndIf      ⍝ Return mpz← b
            :EndSelect
         :EndHold
         mpz← ⎕THIS
      ∇
      
   ⍝ And/Or/Xor:  {mpz}← {a} mpz.And b  etc.     mpz← a ∧ b, bit by bit (two's complement semantics)
      ∇ {mpz}← {a} And b ; aP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            {}RAW.And ⍙ptr aP (Ptr1 b)
         :EndHold
         mpz← ⎕THIS
      ∇
      ∇ {mpz}← {a} Or b ; aP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            {}RAW.Or ⍙ptr aP (Ptr1 b)
         :EndHold
         mpz← ⎕THIS
      ∇
      ∇ {mpz}← {a} Xor b ; aP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            {}RAW.Xor ⍙ptr aP (Ptr1 b)
         :EndHold
         mpz← ⎕THIS
      ∇
      
   ⍝ Com:  mpz.Com   →→   mpz← ¬mpz  (bitwise NOT in two's complement, which is  ¯1-mpz).  Niladic, in place.
      ∇ {mpz}← Com ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         {}RAW.Com ⍙ptr ⍙ptr
         mpz← ⎕THIS
      ∇
   ⍝ PopCount: n← mpz.PopCount   Number of 1 bits. A negative number has infinitely many: returns UL_MAX then.
      ∇ n← PopCount ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         n← RAW.PopCount ⍙ptr
      ∇
   ⍝ HamDist: n← {a} mpz.HamDist b   Hamming distance: the number of bit positions in which a and b differ.
   ⍝   If one is negative and the other not, there are infinitely many: returns UL_MAX.
      ∇ n← {a} HamDist b ; aP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            n← RAW.HamDist aP (Ptr1 b)
         :EndHold
      ∇
      
   ⍝ Single-bit methods. Bit indexes honour the caller's ⎕IO (as does the Bit property).
   ⍝ A bad index (below ⎕IO, or above UL_MAX) signals badBitIxÊ.
   ⍝
   ⍝ TestBit:  bit← {a} mpz.TestBit ix      Retrieve a bit of an mpz at index <ix>.  Read-only, so any a is OK.
      ∇ bit← {a} TestBit ix ; aP; ∆io; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         ∆io← (⊃⎕RSI).⎕IO
         ix← ∆io-⍨ ToInt ix                                   ⍝ now 0-origin
         ⎕SIGNAL badBitIxÊ/⍨ (ix<0)∨(ix>UL_MAX)
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            bit← RAW.TstBit aP ix
         :EndHold
      ∇
   ⍝ The three methods below CHANGE a bit, so they act on the receiver only (no left argument):
   ⍝ to change a bit of another gmpz, call the method on that object.
   ⍝
   ⍝ SetBit:  val← mpz.SetBit ix [val←1]
   ⍝ Sets a bit of an mpz at index <ix> to val (default is 1).  Returns the value set to (shy).
      ∇ {val}← SetBit ix_val ; ix; ∆io; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         ∆io← (⊃⎕RSI).⎕IO
         ix val← 2↑ ix_val, 1
         ix← ∆io-⍨ ToInt ix                                   ⍝ now 0-origin
         val← ToInt val
         ⎕SIGNAL badBitIxÊ/⍨ (ix<0)∨(ix>UL_MAX)
         ⎕SIGNAL badBitValÊ/⍨ ~val∊0 1
         :If val
            {}RAW.SetBit ⍙ptr ix
         :Else
            {}RAW.ClrBit ⍙ptr ix
         :EndIf
      ∇
   ⍝ ClrBit: val← mpz.ClrBit ix
   ⍝   Clears a bit of an mpz at index <ix>.  Same as SetBit ix 0.  Returns 0 (shy).
      ∇ {bit}← ClrBit ix ; ∆io; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         ∆io← (⊃⎕RSI).⎕IO
         ix← ∆io-⍨ ToInt ix
         ⎕SIGNAL badBitIxÊ/⍨ (ix<0)∨(ix>UL_MAX)
         {}RAW.ClrBit ⍙ptr ix
         bit← 0
      ∇
   ⍝ Flip: bit← mpz.Flip ix   - Complement bit ix (using RAW.ComBit). Returns the NEW bit value (shy).
      ∇ {bit}← Flip ix ; ∆io; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         ∆io← (⊃⎕RSI).⎕IO
         ix← ∆io-⍨ ToInt ix
         ⎕SIGNAL badBitIxÊ/⍨ (ix<0)∨(ix>UL_MAX)
         {}RAW.ComBit ⍙ptr ix
         bit← RAW.TstBit ⍙ptr ix
      ∇
      
   ⍝ Scan:  pos← {a} mpz.Scan (start bit).  See mpz.Iota.
   ⍝ ∘ Index of the first bit equal to <bit> (0 or 1) at or above index <start>,
   ⍝   counted in the caller's ⎕IO.
   ⍝ ∘ If there is no such bit, returns mpz.UL_MAX (the largest unsigned long)  — NOT adjusted for ⎕IO.
   ⍝   This is only possible when looking for a 1 in a non-negative number, or a 0 in a negative one.
      ∇ p← {a} Scan (p0 bit) ; aP; ∆io; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         ∆io← (⊃⎕RSI).⎕IO
         p0← ∆io-⍨ ToInt p0
         ⎕SIGNAL badBitIxÊ/⍨ (p0<0)∨(p0>UL_MAX)
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            p← ⍙Scan aP p0 bit
         :EndHold
         :If p≠ UL_MAX ⋄ p+← ∆io ⋄ :EndIf
      ∇
   ⍝ Iota:  pos← {a} mpz.Iota bit      As Scan, searching from the first (⎕IO-th) bit. Same not-found result.
      ∇ p← {a} Iota bit ; aP; ∆io; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         ∆io← (⊃⎕RSI).⎕IO
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            p← ⍙Scan aP 0 bit
         :EndHold
         :If p≠ UL_MAX ⋄ p+← ∆io ⋄ :EndIf
      ∇
   ⍝ ⍙Scan (aP p0 bit): private. 0-origin start; returns 0-origin position (or UL_MAX).
      ∇ p← ⍙Scan (aP p0 bit)
         :Select ToInt bit
          :Case 1 ⋄ p← RAW.Scan1 aP p0
          :Case 0 ⋄ p← RAW.Scan0 aP p0
         :Else ⋄ ⎕SIGNAL badBitValÊ
         :EndSelect
      ∇
   ⍝:EndSection Bit Logic
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Bit and Bits properties
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝ Bit:   a.Bit[5], a.Bit[1 2 3]
   ⍝        a.Bit[1 2 3]← 1 0 1,  a.Bit[1 2 3]← 0
   ⍝  Invalid:  a.Bit[] or a.Bit.  Use a.Bits
   ⍝  Allow user to set and test/clear one or more bits
   ⍝      a.Bit[5],  a.Bit[5]← 1
   ⍝  Bit indexes start with low order bits:
   ⍝  -- Using positive numbers: bit ⎕IO is the lowest order bit, ⎕IO+1 the next lowest, etc.
   ⍝     Caller's ⎕IO is honored.
   ⍝  -- Using negative numbers: bit ¯1 is the highest order bit (the sign).
   ⍝     Caller's ⎕IO is ignored.
   ⍝  Bit will set or get ANY bit(s) in any order in the index space of mpz numbers.
   ⍝  Note the property Bits (below) can be used to get or set ALL bits in an object at once EFFICIENTLY.
   ⍝  a.Bits ≡ ⌽a.Bit[⍳a.BitLen]
      :Property Keyed Bit
       :Access Public Instance
         ∇ vals← get arg ; ixs; ∆io; b; ⎕TRAP
            ⎕TRAP← ∆TRAP
            ∆io← (⊃⎕RSI).⎕IO
            ixs← ⊃arg.Indexers 
            :If 0= ≢ixs                                       ⍝ No indices? Return empty
               vals← ⍬  
            :Else 
               vals← (⍴ixs)⍴ ⍙ptr BitGet¨BitIx ixs ∆io ⍙ptr 
            :EndIf 
         ∇
         
         ∇ set arg ; vals; ixs; ∆io; b; ⎕TRAP
            ⎕TRAP← ∆TRAP
            ∆io← (⊃⎕RSI).⎕IO
            ixs← ⊃arg.Indexers
            vals← arg.NewValue
            :If 0≠ ≢ixs                                        ⍝ No indices? Do nothing
              {}vals BitSet¨BitIx ixs ∆io ⍙ptr                               ⍝ If valis is a scalar, it is used for all...
            :EndIf 
         ∇
      :EndProperty

       BitIx← { ixs ∆io ⍙ptr← ⍵ 
            ((ixs>0)/ixs)-← ∆io                                ⍝ Add index origin to pos indices
            q← ∨/ b← ixs<0 
            (b/ixs)+← LenMinBits⍣q⊢ ⍙ptr                       ⍝ adjust negative indices
             ixs⊣ ⎕SIGNAL badBitIxÊ/⍨ ∨/ (ixs<0)∨ ixs>UL_MAX        ⍝ adjusted indices out of range? Bye.
      }
      BitGet← { RAW.TstBit ⍺ ⍵}
      BitSet← { 1= ⍺: RAW.SetBit ⍙ptr ⍵ ⋄ 0= ⍺: RAW.ClrBit ⍙ptr ⍵ ⋄ ⎕SIGNAL badBitValÊ }

      
   ⍝ Bits:  bool← a.Bits ,   a.Bits← bool
   ⍝   Get or set the entire object as a boolean vector in two's complement form, sign bit first
   ⍝   (a.Bits is ≢=a.BitLen long). Equivalent to a.Bit[⌽⍳a.BitLen] but much faster.
   ⍝   Setting: the leading bit is the sign (¯1 is  a.Bits← 1;  5 is  a.Bits← 0 1 0 1).
      :Property Simple Bits
       :Access Public Instance
         ∇ bitsOut← Get ; ⎕TRAP
            ⎕TRAP← ∆TRAP
            bitsOut← ExportBits 0                             ⍝ width=0: choose minimum width
         ∇
         ∇ Set args ; bitsIn; ⎕TRAP
            ⎕TRAP← ∆TRAP
            ⎕SIGNAL propSetÊ/⍨ 0≠ args.⎕NC 'Indexers'         ⍝ Trap attempts to do ⍺.Bits[i]← val
            ImportBits bitsIn← args.NewValue
         ∇
      :EndProperty
      
   ⍝ ⍙TwosComp ⍵: private. Negate a vector of unsigned 64-bit limbs (least significant first) in two's
   ⍝ complement: invert every limb, then add 1 with the carry rippling through the limbs.
   ⍝ It is its own inverse, so it both makes and undoes a two's complement form.
      ⍙TwosComp← {
         inv← UI64_MAX- ⍵                                     ⍝ Bitwise NOT of each 64-bit limb
         carryIn← 1, ¯1↓ ∧\inv= UI64_MAX                      ⍝ +1 enters at the least significant limb, passes through all-1 limbs
         (UI64_MAX+ 1)| inv+ carryIn
      }
      
   ⍝ ExportBits: bits← a.ExportBits width
   ⍝   Retrieves all of a as an APL bit vector (this is what the Bits property does).
   ⍝   bits:  MSB-first boolean vector of two's complement bits, <width> long.
   ⍝   width: desired bit-width, ≥ BitLen to hold the value (0: choose the minimum, BitLen).
   ⍝          A wider width sign-extends.
      ∇ bits← ExportBits width ; sgn; nlimbs; limbs; count; reqLimbs; wLimbs; finalLimbs; ⎕TRAP
       :Access Public Instance
         ⎕TRAP← ∆TRAP
         :If width=0 ⋄ width← LenMinBits ⍙ptr ⋄ :EndIf
         sgn← PSignum ⍙ptr
         :If sgn=0
            bits← width⍴ 0 ⋄ :Return                          ⍝ zero: nothing to export
         :EndIf
         nlimbs← RAW.Size ⍙ptr
      ⍝ Export RAW 64-bit limbs (LSW first, native endianness) via memcpy fast-path
         (limbs count)← RAW.Export nlimbs 0 ¯1 8 0 0 ⍙ptr
      ⍝ Resize limb vector to cover `width` bits (pads with 0s if wider than magnitude)
         reqLimbs← ⌈width ÷ 64
         wLimbs← reqLimbs ↑ limbs
         finalLimbs← wLimbs
         :If sgn< 0 ⋄ finalLimbs← ⍙TwosComp wLimbs ⋄ :EndIf   ⍝ ~x + 1 across 64-bit words if negative
      ⍝ Reverse to MSW-first, decode each 64-bit word to bits, flatten, and trim to `width`
         bits← (-width)↑ ,⍉(64⍴2)⊤ ⌽finalLimbs
      ∇
      
   ⍝ ImportBits:  a.ImportBits bits    Set a from an APL bit vector (this is what  a.Bits← bits  does).
   ⍝   bits: MSB-first two's complement; the leading bit is the sign. An empty vector sets 0.
   ⍝   Errors: badBitsÊ if bits contains anything but 0 and 1.
      ∇ ImportBits bits ; isNeg; width; padded; magWords; ⎕TRAP
       :Access Public Instance
         ⎕TRAP← ∆TRAP
         :If 0 = ≢bits
            {}RAW.SetI ⍙ptr 0 ⋄ :Return
         :EndIf
         :If 11≠ ⎕DR bits                                     ⍝ Skip the test if we have a bit vector.
            ⎕SIGNAL badBitsÊ/⍨ ∨/~bits∊ 0 1                   ⍝ Possible scalar 1, 0
         :EndIf
         bits← ,bits
         isNeg← ⊃bits                                         ⍝ MSB is the two's complement sign bit
         width← ≢bits
      ⍝ Sign-extend on the left to a multiple of 64 bits
         padded← ((64| -width)⍴ isNeg), bits
      ⍝ Reshape into 64-bit rows (MSW first), decode to U8 integers, reverse to LSW first
         magWords← ⌽2⊥ ⍉(64÷⍨ ≢padded) 64⍴ padded
         :If isNeg ⋄ magWords← ⍙TwosComp magWords ⋄ :EndIf    ⍝ Undo two's complement to recover the unsigned magnitude
      ⍝ Import unsigned limbs; order: ¯1 LSW first, size=8 bytes, endian=0 native
         {}RAW.Import ⍙ptr (≢magWords) ¯1 8 0 0 magWords
      ⍝ Apply negative sign if MSB was 1
         :If isNeg ⋄ {}RAW.Neg ⍙ptr ⍙ptr ⋄ :EndIf
      ∇
   ⍝:EndSection Bit and Bits properties
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Comparison Functions: Cmp, Lt, Le, Eq, Ne, Ge, Gt
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  c← {a} c.Cmp b     — three-way compare:  rc← × (a - b)  →  ¯1, 0 or 1
   ⍝  Monadic use compares c with b.  Dyadic use compares a with b.
   ⍝  If b is an APL integer fitting in a signed 64-bit integer, the faster
   ⍝  signed-int compare is used; otherwise the mpz compare is used.
   ⍝  The wrappers below return 0/1 and take the same arguments:
   ⍝     Lt (<)   Le (≤)   Eq (=)   Ge (≥)   Gt (>)  Ne (≠)
   ⍝ Note that the GMP comparisons don't guarantee the returned results are ¯1 0 1, only that the signs are correct.
   ⍝ Hence the use of signum (×).
   ⍝  Trap rule (see header): Cmp and each wrapper are public entry points,
   ⍝  so each sets ⎕TRAP←∆TRAP on entry.
      ∇ rc← {a} Cmp b ; aP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :Hold ∆STATICS
            :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
            :If IsInt b
            :Andif (b≥ ¯1-IL_MAX)
            :Andif (b≤ IL_MAX)
               rc← ×RAW.CmpI aP b
            :Else
               rc← ×RAW.Cmp aP (Ptr1 b)
            :EndIf
         :EndHold
      ∇
   ⍝  a Lt b  →  a<b
      ∇ rc← {a} Lt b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         rc← (a Cmp b) < 0
      ∇
   ⍝  a Le b  →  a≤b
      ∇ rc← {a} Le b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         rc← (a Cmp b) ≤ 0
      ∇
   ⍝  a Eq b  →  a=b
      ∇ rc← {a} Eq b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         rc← (a Cmp b) = 0
      ∇
   ⍝  a Ne b  →  a≠b
      ∇ rc← {a} Ne b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         rc← (a Cmp b) ≠ 0
      ∇
   ⍝  a Ge b  →  a≥b
      ∇ rc← {a} Ge b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         rc← (a Cmp b) ≥ 0
      ∇
   ⍝  a Gt b  →  a>b
      ∇ rc← {a} Gt b ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
         rc← (a Cmp b) > 0
      ∇
   ⍝:EndSection Comparison Functions
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Random: Rand, RandB, RandSeed
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝ Unless RandSeed is called, the random # is seeded from Dyalog APL with a random integer.
   ⍝ Each function passes a GMP randstate state variable, which is allocated on first use of Rand or RandB or RandSeed.
   ⍝ Only one random state exists for all objects: reseeding anywhere affects every later Rand and RandB.
   ⍝ See also RandSeed below.
      
   ⍝ {c}← c.Rand b           c← a random # r in range: ⎕IO ≤ r < ⎕IO+b.    Sensitive to the caller's ⎕IO.
   ⍝   b: a valid mpz, integer, or integer string.
   ⍝ An alias to c is returned (shy).
   ⍝ Very fast.  Errors: randÊ if b ≤ 0 (GMP urandomm aborts on a non-positive bound).
      ∇ {mpz}← Rand b ; bP; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If ⎕NULL≡rsInstance ⋄ rsInstance← ⎕NEW randState ⋄ :EndIf
         :Hold ∆STATICS
            bP← Ptr0 b
            ⎕SIGNAL randÊ/⍨ 0≥ PSignum bP
            {}RAW.URandomM ⍙ptr rsInstance.ptr bP
         :EndHold
         :If (⊃⎕RSI).⎕IO
            {}RAW.AddU ⍙ptr ⍙ptr 1
         :EndIf
         mpz← ⎕THIS
      ∇
      
   ⍝ {c}← c.RandB nbits      c← a random number r in range: ⎕IO ≤ r < ⎕IO+2*nbits.   Sensitive to the caller's ⎕IO.
   ⍝   nbits: number of bits of binary range (integer, integer string or gmpz).
   ⍝ An alias to c is returned (shy).
   ⍝ Errors: randÊ if nbits < 0 (GMP urandomb aborts on a negative bit count).
      ∇ {mpz}← RandB nbits ; ⎕TRAP
       :Access Public
         ⎕TRAP← ∆TRAP
         :If ⎕NULL≡rsInstance ⋄ rsInstance← ⎕NEW randState ⋄ :EndIf
         nbits← ToInt nbits
         ⎕SIGNAL randÊ/⍨ (nbits<0) ∨ (nbits>UL_MAX)
         {}RAW.URandomB ⍙ptr rsInstance.ptr nbits
         :If (⊃⎕RSI).⎕IO
            {}RAW.AddU ⍙ptr ⍙ptr 1
         :EndIf
         mpz← ⎕THIS
      ∇
      
   ⍝ gmpz.RandSeed u8, where u8 is a UL integer greater than 0.
   ⍝ To seed with a random APL integer (using system entropy), use RandSeed 0 (zero).
   ⍝ Returns the old seed in string form (shy).
   ⍝
   ⍝ At initialisation, the random seed is ?UL_MAX (with ⎕FR=1287), i.e. seeded from
   ⍝ a random APL integer, based on system entropy (⎕RL using RNG2).
   ⍝ If you want predictable sequences (out of a larger range), reset it using RandSeed.
      ∇ {old}← RandSeed u8 ; ⎕TRAP
       :Access Public Shared
         ⎕TRAP← ∆TRAP
         :If ⎕NULL≡rsInstance ⋄ rsInstance← ⎕NEW randState ⋄ :EndIf
         u8← ToInt u8
         ⎕SIGNAL randSeedÊ/⍨ ~IsUI u8
         
         :If u8= 0 ⋄ u8← 1+ ?WINDOWS⊃(¯2+2*63) (¯1+2*32) ⋄ :EndIf ⍝ 1 to UL_MAX.
         {}RAW.RandSeedU rsInstance.ptr u8                    ⍝ rsInstance.ptr is its C-language pointer
         
         old← ⍕⊃randState.seeds
         randState.seeds← 2↑ u8, randState.seeds
      ∇
   ⍝:EndSection Random
   
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  Initialise the scratch objects. This MUST come after the type helpers and Set (⎕NEW gmpz uses them),
⍝  and before tempGI below and before any method is used.
⍝ ───────────────────────────────────────────────────────────────────────────────
   InitStatics
   
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  GI — a primitive-style wrapper (operator) around the gmpz methods
⍝
⍝    res← [a] (fn GI) b
⍝
⍝    fn  A single APL primitive naming the operation.  Its glyph is obtained
⍝        with ⎕NR 'fn'.  The arguments a and b may be gmpz objects, APL
⍝        integers, or strings.  They are never modified: the work is done in a
⍝        fresh gmpz `c`, which is returned (except where noted).
⍝        For greater efficiency, you can always use the gmpz calls above.
⍝
⍝    Dyadic
⍝                Mathy
⍝                  a +GI b    a + b                 a -GI b    a - b
⍝                  a ×GI b    a × b                 a ÷GI b    floored a÷b
⍝                  a ∨GI b    gcd                   a ∧GI b   lcm
⍝                  a |GI b    a|b  as in APL        a ⌽GI b   shift b by a bits
⍝                  a !GI b    a!b: b choose a, as APL's  3!5  is 10
⍝                  a ⌈GI b    larger of a and b    a ⌊GI b    smaller of a and b
⍝                  a *GI b    a*b  (b may be ÷n for an n-th root)
⍝                  a *∘|GI b  (a ** exp) | mod, where (exp mod)←b
⍝                  a ÷∘|GI b  (a÷b) and (b|a), as a 2-element vector of NEW gmpz's
⍝                Manipulation of bits
⍝                  a ⍳GI b    a⍳i, where i∊ 0 1 (first bit of that value; UL_MAX if none)
⍝                  a ⌷GI b    b.Bit[a] (bit a of b)
⍝                Export, Import, Length in base
⍝                  a ⊤GI b    b (gmpz, integer or decimal string) as a STRING in base a  (cf. gmpz.Get)
⍝                  a ⊥GI b    a NEW gmpz from the string b read in base a                 (cf. c.Set)
⍝                  a ≢GI b    length of the string of b in base a (StrLenInBase)
⍝                Comparisons (return an APL 0/1, not an object):
⍝                  a <GI b    a ≤GI b    a =GI b
⍝                  a >GI b    a ≥GI b    a ≠GI b
⍝    Monadic
⍝                Mathy
⍝                  -GI b   negate
⍝                  |GI b   absolute value
⍝                  ?GI b   random in [0,b) for b≥0, or in [0,2*-b) for b<0 (RandB)
⍝                  !GI b   factorial. Don't make b too big, else your workspace will kaboom.
⍝                  ×GI b   sign, ¯1 0 1 (returns an APL integer, not an object)
⍝                  <GI b   b-1  (decrement)
⍝                  >GI b   b+1  (increment)
⍝                Bits
⍝                  ~GI b   bitwise NOT of b  (¯1-b)
⍝                  ⌷GI b   b as a two's complement bit vector (b.Bits). See 2⊤GI b as well.
⍝                Export (to Apl), Import (to mpz), Length in base 10
⍝                  ⍎GI b   b as an APL integer (IntDF; errors if it does not fit)
⍝                  ⎕VFI GI b   (ok int) like b.VFI: (1 int) if it fits, else (0 0)
⍝                  ⊤GI b   b exported as a decimal string (gmpz.Get)
⍝                  ⊥GI b   b imported as a mpz object
⍝                  ≢GI b   length of b as a decimal string (StrLen; an APL integer)
⍝    Result        The new gmpz (use ⌷res for its string form) unless the
⍝                  operation is a comparison or one of ×  ≢  ⍎  ⎕VFI  ⌷  ⊤ monadic and
⍝                  ⍳ ⌷ ⊤ ≢ dyadic, which return a plain value.
⍝    Errors        unknownÊ for an unsupported glyph; the underlying method's
⍝                  error (divZÊ, powÊ, …) is passed through.
⍝    Notes         ⎕ML is localised and set to 1 inside GI, and its own DmxSig and unknownÊ are defined,
⍝                    so that it still works when copied out of the class. ⎕IO is the caller's.
⍝                  Every result is a fresh object: GI computes in the shared scratch object tempGI and
⍝                    returns a copy of it, so a result never changes under a later GI call. (Not thread-safe.)
⍝                  The line after the ∇ (the ##.⎕FX …) makes a copy in ## in
⍝                    which the name `gmpz` is replaced by the class's full name,
⍝                    so `GI` can be used from any namespace.
⍝ ───────────────────────────────────────────────────────────────────────────────
   ∇ res← {a}(fn GI)b
        ; c; nm; rem
        ; ⎕ML; ⎕TRAP
        ; Atom; DmxSig; unknownÊ
      
      ⎕ML← 1
      DmxSig← ⎕SIGNAL{⊂⎕DMX.('EN' EN ⋄ 'Message' Message)}
      unknownÊ← ⊂('EN' 11 ⋄ 'Message' 'Unknown operand')
      ⎕TRAP← 0 'E' 'DmxSig⍬'
      Atom← { 1= ≢f← ∊⎕NR ⍵: ⍬⍴f ⋄ f}
      nm← Atom 'fn'                                           ⍝ the primitive glyph of the operand
      res← c← gmpz.tempGI                                     ⍝ Use this temp var.
      
      :If 900⌶⍬
      ⍝  MONADIC
         :Select nm
          :Case '-'    ⋄ (c.Set b).Neg                        ⍝ c← -b
          :Case '|'    ⋄ (c.Set b).Abs                        ⍝ c← |b
          :Case '?'                                           ⍝ If b≥0, do Rand b. If b<0, do RandB -b.
            :If b c.Ge 0
               c.Rand b
            :Else
               (c.Set b).Neg ⋄ c.RandB c
            :EndIf
          :Case '×'    ⋄ res← (c.Set b).Signum                ⍝ int← ×b
          :Case '!'    ⋄ c.Fac b                              ⍝ c← !b
          :Case '<'    ⋄ (c.Set b).Dec                        ⍝ c← b-1
          :Case '>'    ⋄ (c.Set b).Inc                        ⍝ c← b+1
          :Case '~'    ⋄ (c.Set b).Com                        ⍝ c← bitwise NOT of b (¯1-b)
          :Case '≢'    ⋄ res← (c.Set b).StrLen                ⍝ int← ≢⌷b
          :Case '⍎'    ⋄ res← (c.Set b).IntDF                 ⍝ int← b.IntDF
          :Case '⎕VFI' ⋄ res← (c.Set b).VFI                   ⍝ Like (bits ints)← ⎕VFI b.
          :Case '⌷'    ⋄ res← (c.Set b).Bits                  ⍝ bits← b.Bits, for a gmpz, string, or APL integer b
          :Case '⊤'    ⋄ res← gmpz.Get b                      ⍝ retrieve value of b as a (decimal) STRING
          :Case '⊥'    ⋄ c.Set b                              ⍝ return a copy of b. b any int/ mpz type.
         :Else ⋄ ⎕SIGNAL unknownÊ
         :EndSelect
      :Else
      ⍝   DYADIC
         :Select nm
          :Case '+'   ⋄ a c.Add b                             ⍝ c← a + b
          :Case '-'   ⋄ a c.Sub b
          :Case '×'   ⋄ a c.Mul b
          :Case '÷'   ⋄ a c.Div b                             ⍝ c← a÷b.  floored; 0 divisor → divZÊ
          :Case '*'   ⋄ a c.Pow b                             ⍝ a^n.  n may be ÷m, where m is an integer, like ⍺*0.5 in std Apl.
          :Case '∨'   ⋄ a c.Gcd b                             ⍝ mpz← a∨b
          :Case '∧'   ⋄ a c.Lcm b                             ⍝ mpz← a∧b
          :Case '|'   ⋄ a c.Res b                             ⍝ a is the modulus (APL int), b the value
          :Case '<'   ⋄ res← a c.Lt b                         ⍝ c← a< b. comparisons return boolean 0/1 directly
          :Case '≤'   ⋄ res← a c.Le b
          :Case '='   ⋄ res← a c.Eq b
          :Case '≠'   ⋄ res← a c.Ne b
          :Case '≥'   ⋄ res← a c.Ge b
          :Case '>'   ⋄ res← a c.Gt b
          :Case '⌷'   ⋄ res← (c.Set b).Bit[a]                 ⍝ bool← b.Bit [a]
          :Case '≢'   ⋄ res← (c.Set b).StrLenInBase a         ⍝ Get length of b in base a
          :Case '⌽'   ⋄ a c.Shift b                           ⍝ binary shift: a is the shift amount (APL int) L or R
          :Case '!'   ⋄ b c.Bin a                             ⍝ a!b: b choose a (APL's order: 3!5 is 10)
          :Case '⌈'                                           ⍝ larger of a and b
            :If a c.Ge b ⋄ c.Set a ⋄ :Else ⋄ c.Set b ⋄ :EndIf
          :Case '⌊'                                           ⍝ smaller of a and b
            :If a c.Le b ⋄ c.Set a ⋄ :Else ⋄ c.Set b ⋄ :EndIf
         ⍝ ⊤GI and ⊥GI: Comparable to APL counterparts
          :Case '⊤'   ⋄ res← a gmpz.Get b                     ⍝ retrieve value of b as a STRING in base a.
          :Case '⊥'   ⋄ a c.Set b                             ⍝ return copy of INT STRING b, which is in base a.
          :Case '⍳'   ⋄ res← a c.Iota b                       ⍝ a⍳b, where b∊ 0 1
         ⍝ Take b[1]| a*b[0]) efficiently.
          :Case '*∘|' ⋄ a c.PowM b                            ⍝ mpz← mod| a*exp given (exp mod)←b .
         ⍝ Returns 2 args (both NEW objects: c is shared, so copy it):
          :Case '÷∘|'
            rem← a c.DivRem b                                 ⍝ c← a÷b (floored); rem← b|a (a new gmpz)
            res← (⎕NEW gmpz c) rem                            ⍝ copy c: it is the shared tempGI
         :Else ⋄ ⎕SIGNAL unknownÊ
         :EndSelect
      :EndIf
      :If res≡c
         res← ⎕NEW gmpz c
      :EndIf
   ∇
 :Field Public Shared tempGI← ⎕NEW gmpz                       ⍝ For use in GI only
   tempGI.⎕DF 'GI tmp mpz #0'
   ##.⎕FX '\bgmpz\b' ⎕R (⍕⎕THIS)⊢⎕NR 'GI'                     ⍝ Be sure GI refers to this gmpz
   ⎕← 'Created class ',(⍕⎕THIS),', operator ',(⍕⎕THIS),'.GI'
   
:EndClass
