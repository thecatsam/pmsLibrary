:Class gmpz                                                        ⍝ MPZ: GMP's multiple precision integer
    
  :Field Public Shared DEBUG← 0                                    ⍝ 1: print Alloc/Free messages and set display forms
    ⎕IO ⎕ML ⎕PP ⎕FR← 0 1 34 1287                                   ⍝ Class-wide settings (see header)
    ⎕RL← ⍬ 2                                                       ⍝ Use the system entropy by default for "seeds"
⍝ ═══════════════════════════════════════════════════════════════════════════════
⍝  gmpz — Arbitrary-precision integers for Dyalog APL, backed by GMP (libgmp)
⍝  Version 2026-11-12
⍝ ═══════════════════════════════════════════════════════════════════════════════
⍝
⍝  OVERVIEW
⍝    Each gmpz instance wraps one GMP `mpz_t`, allocated with malloc and
⍝    manipulated through ⎕NA bindings to libgmp. Values can be created from
⍝    and exported to APL integers or decimal strings of any length.
⍝
⍝  REQUIREMENTS
⍝    Dyalog APL v20 (64-bit) and the GMP shared library (libgmp, version 10).
⍝    LoadLib searches the usual macOS / Linux / Windows locations.
⍝    The class sets  ⎕IO ⎕ML ⎕PP ⎕FR← 0 1 34 1287  (decimal floats, so APL
⍝    integers up to 2*63 are exact; here 2*63 means 2 to the power 63).
⍝
⍝  Created by PMS 20261114
⍝    ∘ Original design, prototype code, code comments and primer
⍝    ∘ All class code, including system (malloc/free) memory management
⍝    ∘ Random state code
⍝    ∘ Method for adding Microsoft declarations (untested), where different from Unix
⍝  With assistance from AI (Muse, Claude, Gemini) for:
⍝    ∘ Debugging and recommendations on systematizing conversion code (str <-> mpz, etc.)
⍝    ∘ Additions to and formatting of primer
⍝    ∘ Additions to comments as new features were added
⍝    ∘ Specifications for Microsoft declarations (where longs are 4 bytes vs 8)
⍝    ∘ Sample gmpz program (AI did C language prototype; PMS created APL version)
⍝    ∘ Searching for declarations and C language sizes
⍝
⍝  QUICK START
⍝      a← ⎕NEW gmpz '12345678901234567890'                         ⍝ from a string
⍝      b← ⎕NEW gmpz 2                                              ⍝ from an APL integer
⍝      c← ⎕NEW gmpz                                                ⍝ defaults to 0
⍝      d← gmpz.New '99999999999999999999'                          ⍝ shared factory (optional base on left)
⍝      16 gmpz.New 'ff'                                            ⍝ → 255
⍝
⍝      ⌷a                                                          ⍝ string form (default property)
⍝      c.Set 5                                                     ⍝ overwrite c with 5 (c now holds 5)
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
⍝      Rand       uniform on 0 … ⍵-1.
⍝                 By default, uses APL ⎕RL for seed with RNG2 (system entropy).
⍝
⍝  ERRORS
⍝    Public entry points set ⎕TRAP←∆TRAP, which re-signals errors from the
⍝    caller's perspective. Internal helpers (_Dyad_, PSignum, ⍙Scan, StatPtr,
⍝    ⍙CallerIO, ⍙InitObj) do NOT set a trap; they rely on their caller.
⍝    See the `errors` table below for the names, codes and messages.
⍝
⍝  MEMORY
⍝    The destructor clears and frees the mpz when the object goes out of scope,
⍝    or explicitly via  ⎕EX 'a'.  Set DEBUG← 2 (default 0) to trace allocations and frees.
⍝
⍝  FILE LAYOUT
⍝    1.  Error table
⍝    2.  LoadLib (GMP / libc)
⍝    3.  Construction / Set
⍝    4.  Value access (⌷, ptr)
⍝    5.  Types
⍝    6.  statics[0..2] scratch objects
⍝    7.  _Dyad_ helper operator
⍝    8.  Signum
⍝    9.  Dyadic arithmetic
⍝    10. Logical / bit manipulation
⍝    11. Monadic arithmetic (Neg, Abs, Divisible, Bit property)
⍝    12. Factorial
⍝    13. Comparison
⍝    14. Rand, RandSeed
⍝    15. Niladic arithmetic (Inc, Dec, Even, Odd)
⍝    16. Niladic export (Int, VFI, GetInBase, Bits)
⍝    17. Prime numbers
⍝    18. Miscellany (StrLen, Len)
⍝    19. GI operator (APL primitive-style wrapper)
⍝
⍝  NOTES FOR MAINTAINERS
⍝  - Names ending in Ê are variables generated from a table in LoadErrs.
⍝  - Names starting with ⍙ are private helpers.
⍝  - Library entries in namespace gNs (Add, AddU, …) are raw GMP calls;
⍝    the "U" variants take an unsigned C long instead of an mpz — 64-bit
⍝    on Unix, 32-bit on Windows (see the UL/IL note above mpzTable in LoadLib).
⍝  - ⎕FR←1287 is used, since it allows handling of (64-bit) pointers and
⍝    U8 and I8 (64-bit unsigned and signed integers). We occasionally take
⍝    advantage of decimal floats to work with integers larger than 64-bits.
⍝
⍝ ═══════════════════════════════════════════════════════════════════════════════
  :Field Public Shared ReadOnly WINDOWS← 'Windows'≡7↑⊃'.'⎕WG'APLVersion' 
  :Field Shared ReadOnly ∆THIS ← ⎕THIS                             ⍝ The class reference (used for ⎕NEW and class tests)
  :Field Shared ReadOnly ∆TRAP ← 0 'E' 'DmxSig⍬'                   ⍝ Standard ⎕TRAP for public methods: re-signal at caller
  :Field Shared ReadOnly UL_MAX← ¯1+2* WINDOWS⊃64 32               ⍝ Max C unsigned long: 2*64-1 Unix, 2*32-1 Windows
  :Field Shared ReadOnly IL_MAX← ¯1+2* WINDOWS⊃63 31               ⍝ Max C signed long: 2*63-1 Unix, 2*31-1 Windows
    
⍝ ═══════════════════════════════════════════════════════════════════════════════
⍝ Class randState - for handling Random Numbers. See also Rand and RandSeed
⍝ ═══════════════════════════════════════════════════════════════════════════════
    :Class randState
    ⍝ NOTE: randState is a nested class and does not inherit the outer gmpz DEBUG field, so it keeps
    ⍝       its own flag. Set gmpz.randState.DEBUG←2 to trace it.
    ⍝ Call:    rs← ⎕NEW randState                                  ⍝ Not directly called by user. See fn Rand, RandB.
    ⍝ When rs goes out of scope, the storage is released
      :Field Private Instance       r⍙ptr← 0
      :Field Public Shared          active← 0                      ⍝ Only 1 active instance is allowed!
      :Field Public Shared          seeds← (?¯1+ 2* ##.WINDOWS⊃63 32) 0  ⍝ Order: newseed oldseed. A seed fits in a UL.
        ∇ Init0
          :Access Public
            :Implements Constructor
            :If active ⋄ 911 ⎕SIGNAL 'Logic error: Only one randState instance is active at a time.' ⋄ :EndIf
            :Trap 0
                r⍙ptr← gNs.Malloc 64
                :If 0= r⍙ptr
                    ⎕SIGNAL randStateÊ
                :EndIf
                {}gNs.RandInitDef r⍙ptr
                {}gNs.RandSeedU   r⍙ptr (⊃seeds)                   ⍝ Seed from APL random #
                :If 2≤ ##.DEBUG ⋄ ⎕← 'rand: Alloc state var [',r⍙ptr⍕⍛, ']'  ⋄ :EndIf
            :Else
                :If 0≠ r⍙ptr
                    {}gNs.RandClear r⍙ptr
                    {}gNs.Free r⍙ptr
                    r⍙ptr← 0
                    :If 2≤ ##.DEBUG ⋄ ⎕← 'rand:  Free state var [', r⍙ptr⍕⍛, ']'  ⋄ :EndIf
                :EndIf
                ##.DmxSig⍬                                         ⍝ Re-signal at the caller; do NOT set active←1
            :EndTrap
            active← 1
        ∇
        ∇ Free
            :Implements Destructor
            :If 2≤ ##.DEBUG ⋄ ⎕← 'rand:  Free state var [', r⍙ptr⍕⍛, ']'  ⋄ :EndIf
            :If 0≠ r⍙ptr
                {}gNs.RandClear r⍙ptr
                {}gNs.Free r⍙ptr
                r⍙ptr← 0
            :EndIf
            active← 0                                              ⍝ Allow a second instance after the first is freed
        ∇
        ∇ p← ptr
          :Access Public
            p← r⍙ptr
        ∇
    :EndClass
    
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  Error handling
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  DmxSig: re-signals the current ⎕DMX error (EN and Message) so that the error
⍝          is reported at the caller's level.  Installed via ∆TRAP below.
    DmxSig←     ⎕SIGNAL { ⊂⎕DMX.('EN' EN ⋄ 'Message' Message) }
⍝  LoadErrs: turns each row of `errors` into a variable named in column 1, whose
⍝          value is a ⎕SIGNAL-ready namespace spec ('EN' code)('Message' text).
⍝          Use:  ⎕SIGNAL divZÊ   or   ⎕SIGNAL divZÊ/⍨ condition
⍝          NOTE: verify ⎕VSET behaviour in Dyalog v20 — see the final report.
    LoadErrs← { ⎕VSET (↑⊃¨ ⍵)({⊂('EN' ⋄  ⊃⍵)('Message'  ⋄  ⊃⌽⍵)}∘(1↓⊢)¨⍵)}
⍝             name           EN   Message
    errors← (
        'initLogicÊ'  911  'The library attempted to reinitialize an initialized mpz integer'
        'noGmpÊ'       22  'GMP library not found'
        'gmpLoadÊ'     11  'Error loading Gmp library routine(s)'
        'badBitsÊ'     11  'Bits must be 1 or 0'
        'badInitÊ'     11  'Unable to create object'
        'badBitValÊ'   11  'Invalid bit value (must be 0 or 1)'
        'badBitIxÊ'     3  'Invalid bit index (must be >= 0)'
        'badAplÊ'      11  'Invalid APL Integer'
        'baseXtraÊ'    11  'Bases are valid only with string arguments'
        'badObjÊ'      11  'Can''t convert object to a Gmp integer'
        'badUIntÊ'     11  'Value not an APL non-negative integer'
        'divZÊ'        11  'Division by 0'
        'randStateÊ'   11  'Unable to initialise random # state'
        'randSeedÊ'    11  'Object cannot be converted to an unsigned integer'
        'randÊ'        11  'Arg must be positive'
        'propSetÊ'     11  '⍵.Bits[i] is invalid. To set an individual bit, use ⍵.Bit[n]'
        'powÊ'         11  'Invalid power: neither an integer nor the inverse of one'
        'shiftÊ'       11  'Shift value must be an integer'
        'badIntÊ'      11  'Number too large to fit into a 64-bit integer (decimal float)'
        'facBadÊ'      11  'Arg must be non-neg integer (Windows: 32-bit, Other: 64-bit)'
        'primeÊ'       11  'ProbabPrime requires a number of test repetitions in the optional left argument, usually 15-50'
        'unknownÊ'     11  'Unknown error'
    )
⍝  badBitIxÊ uses EN 3 (INDEX ERROR) deliberately, because a bad bit index
⍝  is an indexing error; all other user errors use EN 11 (DOMAIN ERROR).
    LoadErrs errors
    
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  LoadLib: locate libgmp and libc, and bind every needed routine into a namespace
⍝
⍝    Arg/Result  where   the namespace (here gNs, a :Field Shared) that receives
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
⍝               apl_name gNs.⎕NA '<return_type> <sysLib>|__gmpz_<gmpz_name> <signature>'
⍝         The <return_type> is omitted if (c-language) void.
⍝         The <signature> is in APL ⎕NA format, using pointers (P) and various integers.
⍝    Errors: Signals noGmpÊ if no library (or libc) is found; gmpLoadÊ if a routine
⍝            cannot be bound (the offending entry is echoed to the session).
⍝ ───────────────────────────────────────────────────────────────────────────────
    ∇ where← LoadLib where; sysLib; clib; field; info; errs; nm; ok; pfx; gm; ret; sig; trueLongs
        :If 0=≢where ⋄ where← ⎕NS '' ⋄ :EndIf                      ⍝ ⍬ (or an empty value) → fresh namespace
        → 0/⍨ where.⎕VGET ⊂'loadComplete' 0                        ⍝ Already exists and 1? Return!
        where.⎕DF 'gmpInt [gmp library]'
        ok← 0                                                      ⍝ MUST initialise: ~ok is tested after the loop
        :For sysLib :In (
                '/opt/homebrew/opt/gmp/lib/libgmp.dylib'           ⍝ macOS, Apple silicon (Homebrew)
                '/usr/local/opt/gmp/lib/libgmp.dylib'              ⍝ macOS, Intel (Homebrew)
                'libgmp.dylib'
                'libgmp.10.dylib'
                'libgmp.so.10'                                     ⍝ Linux, via the loader path
                '/usr/lib/x86_64-linux-gnu/libgmp.so.10'
                '/usr/lib/aarch64-linux-gnu/libgmp.so.10'
                '/usr/lib64/libgmp.so.10'
                'libgmp-10.dll'                                    ⍝ Windows
            )
            :Trap 0
                'Init' where.⎕NA sysLib,'|__gmpz_init P'           ⍝ Probe: does this path load?
                ok← 1 ⋄ :Leave
            :EndTrap
        :EndFor
        ⎕SIGNAL noGmpÊ/⍨ ~ok
        
        :For clib :In ('/usr/lib/libc.dylib' 'libc.so.6' 'msvcrt.dll')
            where.⎕EX 'Malloc' 'Free' 'MemCpyI'                    ⍝ Expunge any partial bindings from a failed candidate
            :Trap 0
                'Malloc'  where.⎕NA 'P ',clib,'|malloc U8'         ⍝ malloc(count) → pointer
                'Free'    where.⎕NA clib,'|free P'
                'MemCpyI' where.⎕NA clib,'|memcpy >I4[2] P U8'     ⍝ copy N bytes out as 2 ints (used for the sign)
                :If ∧/3= ⌊where.⎕NC 'Malloc' 'Free' 'MemCpyI'      ⍝ All three bound, all from this clib
                    :Leave                                         
                :EndIf
            :EndTrap
        :EndFor
        :If ∨/3≠ ⌊where.⎕NC 'Malloc' 'Free' 'MemCpyI'
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
        mpzTable← (   
        ⍝ APL synonym    gmpz name     return type       args
            'Abs'         'abs'            ''            'P P'
            'Add'         'add'            ''            'P P P'
            'AddU'        'add_ui'         ''            'P P UL'
            'Clear'       'clear'          ''            'P'
            'Cmp'         'cmp'            'I4'          'P P'     ⍝ <0, 0, >0
            'CmpI'        'cmp_si'         'I4'          'P IL'    ⍝ compare to a signed machine int
            'CmpAbs'      'cmpabs'         'I4'          'P P'     ⍝ compare absolute values
            'UiPow'       'ui_pow_ui'      ''            'P UL UL' ⍝ rop← base*exp (both unsigned ints)
            'Div'         'fdiv_q'         ''            'P P P'   ⍝ Floored division
            'DivRemU'     'fdiv_qr_ui'     'UL'          'P P P UL'
            'DivRem'      'fdiv_qr'        ''            'P P P P'
            'Divisible'   'divisible_p'    'I4'          'P P'
            'DivU'        'fdiv_q_ui'      ''            'P P UL'
            'Export'      'export'         ''            '>U8[] >U8 I4 U8 I4 U8 P'
            'Fac'         'fac_ui'         ''            'P UL'
            'FRem'        'fdiv_r'         ''            'P P P'   ⍝ Floored remainder
            'FRemU'       'fdiv_r_ui'      ''            'P P UL'  ⍝ ditto
            'Gcd'         'gcd'            ''            'P P P'
            'GcdU'        'gcd_ui'         ''            'P P UL'
            'GetStr'      'get_str'        ''            '=0C[] I4 P' ⍝ Handle null termination automatically
            'Import'      'import'         ''            'P U8 I4 U8 I4 U8 <U8[]'
            'Init'        'init'           ''            'P'       ⍝ To zero (void)
            'InitSet'     'init_set'       ''            'P P'     ⍝ From mpz (void)
            'InitSetI'    'init_set_si'    ''            'P IL'    ⍝ From signed int (void)
            'Int'         'get_si'         'IL'          'P'
            'Invert'      'invert'         'I4'          'P P P'   ⍝ Modular inverse: rop = a^-1 mod m (returns non-zero if exists)
            'IntFits'     'fits_slong_p'   'I4'          'P'       ⍝ mpz_fits_slong_p returns int, not I8
            'Jacobi'      'jacobi'         'I4'          'P P'     ⍝ Jacobi symbol (a/b) -> returns -1, 0, 1
            'Lcm'         'lcm'            ''            'P P P'
            'LcmU'        'lcm_ui'         ''            'P P UL'
            'Mul'         'mul'            ''            'P P P'
            'MulU'        'mul_ui'         ''            'P P UL'
            'Neg'         'neg'            ''            'P P'
            'NextPrime'   'nextprime'      ''            'P P'
            'Pow'         'pow_ui'         ''            'P P UL'
            'PowM'        'powm'           ''            'P P P P' ⍝ Modular exponentiation: rop← base^exp mod mod
            'PrevPrime'   'prevprime'      'I4'          'P P'     ⍝ Returns the likelihood of primality: 2, 1, 0
            'ProbabPrime' 'probab_prime_p' 'I4'          'P I4'    ⍝ 2 definitely, 1 probably, 0 not
            'Root'        'root'           'I4'          'P P UL'  ⍝ nonzero return ⇒ exact
            'Set'         'set'            ''            'P P'
            'SetI'        'set_si'         ''            'P IL'
            'SetStr'      'set_str'        'I4'          'P <0C1[] I4' ⍝ Handle null termination automatically
            'ShiftL'      'mul_2exp'       ''            'P P UL'  ⍝ Shift left by n bits
            'ShiftR'      'tdiv_q_2exp'    ''            'P P UL'  ⍝ Shift right by n bits, truncating toward zero
            'Size'        'size'           'U8'          'P' 
            'SizeInBase'  'sizeinbase'     'U8'          'P I4'    ⍝ size_t: 64-bit on Win64 and Unix64 alike, so stays U8
            'Sqrt'        'sqrt'           ''            'P P'     ⍝ Truncated root
            'Sub'         'sub'            ''            'P P P'
            'SubU'        'sub_ui'         ''            'P P UL'
        ⍝   Logical functions
            'TstBit'      'tstbit'         'I4'          'P UL'    ⍝ Look at the actual bits of an mpz (big integer)
            'SetBit'      'setbit'         ''            'P UL'
            'ClrBit'      'clrbit'         ''            'P UL'
            'Scan1'       'scan1'          'UL'          'P UL'
            'Scan0'       'scan0'          'UL'          'P UL'
            'ComBit'      'combit'         ''            'P UL'    ⍝ one's complement-- flip every bit.
            'And'         'and'            ''            'P P P'
            'Or'          'ior'            ''            'P P P'   ⍝ inclusive or
            'Xor'         'xor'            ''            'P P P'
        ⍝   gmp calls-- handled specially
            'RandInitDef' 'gmp_randinit_default' ''      'P'       ⍝ gmp: the default— Mersenne
            'RandSeedU'   'gmp_randseed_ui' ''           'P UL'    ⍝ gmp: seed state with unsigned int
            'RandClear'   'gmp_randclear'  ''            'P'       ⍝ gmp:
            'URandomM'    'urandomm'       ''            'P P P'   ⍝ mpz: random # < the ceiling
            'URandomB'    'urandomb'       ''            'P P UL'  ⍝ Random # based on bits
        )
        
        errs← 0
        trueLongs← ('U8' 'I8')  ('U4' 'I4') ⊃⍨ WINDOWS 
        :For field :In (2 3)  
            (field⊃¨mpzTable)← 'UL' 'IL' ⎕R trueLongs⊣ field⊃¨mpzTable
        :EndFor  
        :Trap 6 11 102
            :For (nm gm ret sig) :In mpzTable
                pfx← 'gmpz_'/⍨ 'gmp_'≢4↑gm
                info← '|__', pfx, gm, ' ', sig
                nm where.⎕NA ret,' ',sysLib, info
                :If DEBUG≥2                                        ⍝ DEBUG
                    ⎕← ' ',(18↑'''',nm,''''),' ⎕NA ''',(4↑ret),' [LIB]',info,''''
                :EndIf
            :EndFor
        :Else
            errs+← 1
            ⎕← 'Error loading Gmp library routine: '
            ⎕← '   ',nm,' ⎕NA ',info
        :EndTrap
        ⎕SIGNAL gmpLoadÊ/⍨ ×errs
        where.loadComplete← 1
    ∇
    
  :Field Shared   gNs←   LoadLib ()                                ⍝ Namespace holding all bound GMP and libc routines
  :Field Shared   rsInstance←  ⎕NULL                               ⍝ Random # state var
  :Field Instance ⍙ptr← 0                                          ⍝ address of the gmpz_t; 0 = nothing live
    
⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝:Section Object Initialization and Value Setting
    ⍝  ───────────────────────────────────────────────────────────────────────────────
    ⍝  Constructors:
    ⍝     ⎕NEW gmpz                 → value 0
    ⍝     ⎕NEW gmpz  obj            → value of obj (gmpz, string, or APL integer), base 10
    ⍝     ⎕NEW gmpz (obj base)      → value of obj (as above, except string obj parsed in base 2…62).
    ⍝     ⎕NEW gmpz,⊂obj base       → Same as ⎕NEW gmpz (obj base)
        ∇ Init0; ⎕TRAP
          :Access Public
            :Implements Constructor
            ⎕TRAP← ∆TRAP
            ⍙InitObj                                               ⍝ Set to 0
        ∇
        ∇ Init args; obj; base; ⎕TRAP
          :Access Public
            :Implements Constructor
            ⎕TRAP← ∆TRAP
            ⍙InitObj
        ⍝  Int 'ca' => (Int 'ca' 10).                              ⍝ We let ⎕THIS.Set handle invalid bases
            :If IsStr ⊃args                                        ⍝ (init base): a 2-element vector, second element a number
            :Andif IsNum ⊃⌽args 
                obj base← args 
                base Set obj                               
            :Else 
                Set args 
            :EndIf
        ∇
    ⍝  ⍙InitObj (private): allocate 16 zeroed bytes for the mpz_t and mpz_init it.
    ⍝  If anything fails after malloc, the memory is released before badInitÊ is signalled.
    ⍝  We separate the initialisation and set so that we can ensure any system memory allocated
    ⍝  is freed, no matter what error occurs.
        ∇  ⍙InitObj; err
            err← 0
            :Trap 0                                                ⍝ Capture problems so we can free storage!
                ⍙ptr← gNs.Malloc 16                                ⍝ mpz_t is 16 bytes on 64-bit
                :If ⍙ptr=0 ⋄ ⎕SIGNAL badInitÊ                      ⍝ Allocation failed
                :Else      ⋄ {}gNs.Init ⍙ptr
                :EndIf
            :Else
                err← 1
            :EndTrap
            :If err
                :If ×⍙ptr ⋄ {}gNs.Clear ⍙ptr ⋄ :EndIf
                {}gNs.Free ⍙ptr ⋄ ⍙ptr← 0
                ⎕SIGNAL badInitÊ
            :EndIf
            :If DEBUG≥1 ⋄ ⎕← 'Alloc gmpz [',⍕⍙ptr,']' ⋄ :EndIf
        ∇
        
    ⍝  New0:  mpz← gmpz.New0           — new object with value 0   (shared method)
        ∇ mpz← New0 ; ⎕TRAP
          :Access Public Shared
            ⎕TRAP← ∆TRAP
            mpz← ⎕NEW ⎕THIS
        ∇
    ⍝  New:   mpz [base] gmpz.New init   — new object from init (shared method)
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
    ⍝           badAplÊ if a numeric b is not an integer (it is not truncated).
        ∇ {mpz}← {base} Set b   ; bP; rc; ⎕TRAP
          :Access Public Instance
            ⎕TRAP← ∆TRAP
            mpz← ⎕THIS ⍝⍝⍝ abc 
        ⍝ obj: Can be set from  num str, gmpz obj, or integer.
            :Select Case_T b  
              :Case str_T                      
              string:                        ⍝⍝ ←←←←←←←←←←←←←←←←←←←←←←←←┐
                :If 900⌶⍬ ⋄ base← 10 ⋄ :EndIf ⍝⍝                         ↑
                b← '-'@('¯'∘=),b              ⍝⍝                         ↑
                rc← gNs.SetStr ⍙ptr b base    ⍝⍝                         ↑     ⍝ SetStr will handle invalid numeric strings.
                ⎕SIGNAL badObjÊ/⍨ rc≠0        ⍝⍝                         ↑
              :Case mpz_T                     ⍝⍝                         ↑
                ⎕SIGNAL baseXtraÊ/⍨ ~900⌶⍬    ⍝⍝                         ↑
                :If ⍙ptr≠ bP← b.ptr           ⍝⍝                         ↑
                    {}gNs.Set ⍙ptr bP          ⍝⍝                         ↑
                :EndIf                        ⍝⍝                         ↑
              :Caselist si_T ui_T             ⍝⍝                         ↑     ⍝ any integer 
                ⎕SIGNAL baseXtraÊ/⍨ ~900⌶⍬    ⍝⍝                         ↑
                {}gNs.SetI ⍙ptr b             ⍝⍝                         ↑
              :Case i128_T                    ⍝⍝                         ↑     ⍝ Number is bigger than uint64, so convert to string int.
                ⎕SIGNAL baseXtraÊ/⍨ ~900⌶⍬    ⍝⍝                         ↑
                b← ⍕b                         ⍝⍝                         ↑
                :Goto string                  ⍝⍝ →→→→→→→→→→→→→→→→→→→→→→--┘
            :Else                                               
                ⎕SIGNAL badAplÊ 
            :EndSelect 
        ∇
    ⍝ Destructor: runs automatically when the object is expunged or goes out of scope.
        ∇ Free  
            :Implements Destructor
            :If DEBUG≥1 ⋄ ⎕← 'Free [',(⍕⎕THIS),': ', ']',⍨ ⍕⍙ptr  ⋄ :EndIf
            :If ⍙ptr≠ 0
                {}gNs.Clear ⍙ptr ⋄ {}gNs.Free ⍙ptr
                ⍙ptr← 0
            :EndIf
        ∇
    ⍝:EndSection Object Initialization and Value Setting
    
⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝:Section Getting Object Components
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
                ⎕SIGNAL (⍙ptr=0)/ badObjÊ                          ⍝ Whoops! Nothing there.
                n← 2+ gNs.SizeInBase ⍙ptr 10                       ⍝ digits + possible sign + NUL
            ⍝ Create a place in APL for the null-terminated string. from GetStr
                buf← '¯'@('-'∘=)⊢ gNs.GetStr (n⍴⎕UCS 0) 10 ⍙ptr    ⍝ Import that result
            ∇
        :EndProperty
        
    ⍝ ptr: the address of the underlying mpz_t (0 if released). Mainly for internal use.
        ∇ p← ptr; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            p← ⍙ptr
        ∇
    ⍝:EndSection Getting Object Components
    
    
⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝:Section Types
    ⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝  IsMpz ⍵   1 if ⍵ is an instance of this class (gmpz), else 0
    ⍝  IsUI  ⍵   1 if ⍵ is an APL non-negative integer ≤ UL_MAX (numeric), else 0. Doesn't rule out ALL floats that are near to ⌊⍵.
    ⍝  IsInt ⍵   1 if ⍵ is an APL integer of any sign (numeric), else 0
    ⍝  Case_T ⍵  classify an operand, returning one of the codes below.
    ⍝            Signals badAplÊ for a non-integer number.
    ⍝  IsUI and IsInt are scalar-safe: a vector argument returns 0.
        UI32_MAX← ¯1+2*32   ⋄   UI64_MAX← ¯1+2*64
        I64_MAX←  ¯1+2*63   ⋄   I128_Max← ¯1+10*34                 ⍝ A Dyalog supports bigger nteges than GMP can handle!
        
    ⍝  Here, we use a "minimal" approach to determining the kind of object, EXCEPT if an mpz might be presented,
    ⍝  then use IsMpz. If you present IsNum, etc., directly, the class will generate a prototype object, which it
    ⍝  will promptly discard (per expected class behaviour). IsMpz is still minimal, but an invalid mpz will still be caught.
    ⍝  We will trap the rest.
    ⍝
    ⍝  Use Case_T below if you are going to accept mpz's, strings, unsigneds, signed, and APL integers in Dec Floats;
    ⍝  the individual tests assume ANY type might be presented.
        IsMpz←  326= ⎕DR                                           ⍝ If you present an invalid obj, it will still be trapped.
        IsNum←  0=(⊃0⍴⊢) 
        IsInt←  { IsMpz ⍵: 0 ⋄ IsNum ⍵: (⍵=⌊⍵)∧ ⍵≤ UI64_MAX ⋄ 0  } ⍝ 64-bit                       
        IsUI←   { IsInt ⍵: (⍵≥0)∧(⍵≤UL_MAX) ⋄ 0 }                  ⍝ fits a C unsigned long
        IsStr←  { IsMpz ⍵: 0 ⋄ ' '=⊃0⍴⍵ }                          ⍝ Must terst IsMpz to avoid creating and destroying mpz prototype
        Str2I←  { 
            ok i← ⎕VFI '¯'@(=∘'-')⊢ ⍵ ⋄  ok∧ ~'E'∊ ⍕i: ⍬⍴i ⋄ ⎕SIGNAL badAplÊ 
        }  
        ToInt←  { IsInt ⍵: ⍵ ⋄ IsMpz ⍵: ⍵.IntApl ⋄ IsStr ⍵: Str2I ⍵ ⋄ ⎕SIGNAL badAplÊ }      
        mpz_T ui_T si_T str_T i128_T← ⍳5                           ⍝  Type codes 
        IU_T← ⊃∘si_T ui_T 
        Case_T← { 
            Case← 80|⎕DR ⍵
          Case=6: mpz_T                                            ⍝ mpz or error
          Case=0: str_T                                            ⍝ str
          Case=5: IU_T ⍵≥ 0⊣ ⎕SIGNAL badAplÊ/⍨ ⍵≠⌊⍵                ⍝ I1, I2, I4 
          Case=3: IU_T ⍵≥ 0                                        ⍝ U8, I8 
          (Case≠7)∨ ⍵≠ ⌊⍵: ⎕SIGNAL badAplÊ
        ⍝ Case=7 ↓↓↓                                               ⍝ 64 to 128 bit (Decimal Floats)
          IL_MAX≥ |⍵:   IU_T ⍵≥ 0  
            i128_T 
        }     
    ⍝:EndSection Types
    
⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝:Section  statics[0..2]: Global mpz's used in _Dyad_  and elsewhere
    ⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝  Three scratch mpz's shared by all instances. They hold non-gmpz operands
    ⍝  (strings, negative or large APL integers) only for the duration of a call.
    ⍝  Consequence: this class is not thread-safe, and the scratch values are
    ⍝  meaningless between calls.
    ⍝  Note: To make the class thread-safe,
    ⍝        remove the comment symbol preceding :HOLD and :ENDHOLD below.
        ∇ {ok}← InitStatics ; _
            statics← gmpz.New¨ 3⍴0                                 ⍝ Declare 3 statics (or as needed)
            ∆STATICS← 'statics'                                    ⍝ Used for :HOLDing
        ⍝  Ptr0, etc: these typically take fn arguments (usually a and b) and copy any
        ⍝  values into statics[0] and return statics[0].ptr.
        ⍝ If ⍵ is an mpz, it is returned as is.
            StatPtr← {      IsMpz ⍵: ⍵.ptr ⋄ ((⍺⊃statics).Set ⍵).ptr }
            MpzTemp← { ⍺← ⊢ ⋄ IsMpz ⍵: ⍵     ⋄ ⍺ (⍺⍺⊃statics).Set ⍵ }
            Mpz0← 0 MpzTemp 
            _← { (⍵⊃statics).⎕DF 'Static mpz #',⍕⍵ }¨0 1 2
            Ptr0← 0∘StatPtr
            Ptr1← 1∘StatPtr 
            Ptr2← 2∘StatPtr  
            ok← 1
        ∇
    ⍝ InitStatics
    ⍝:EndSection  statics[0..2]: Global mpz's used in _Dyad_  and elsewhere
⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝:Section Support Operators
    ⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝  _Dyad_: a 2-operand operator for use with common functions
    ⍝
    ⍝    [nzFlag] (fn1 _Dyad_ fn2) (a b)
    ⍝
    ⍝      fn1     GMP routine taking (dest src1 src2) as mpz pointers, e.g. gNs.Add
    ⍝      fn2     the matching "unsigned int" routine,                 e.g. gNs.AddU
    ⍝      a, b    operands (any supported type); the destination is always ⎕THIS
    ⍝      nzFlag  1 → signal divZÊ if b is zero (division); default 0
    ⍝
    ⍝    Dispatch on the type of b (via Case_T):
    ⍝      gmpz object        → fn1 with b's pointer
    ⍝      APL integer ≥ 0 and ≤ UL_MAX → fn2 with b passed directly (fast path)
    ⍝      string / APL < 0 / APL integer > UL_MAX → b is copied into statics[1], then fn1
    ⍝    `a` is always passed through (Ptr0 a) (converted to an mpz when necessary).
    ⍝    Returns ⎕THIS.
    ⍝
    ⍝ Execute  this← a <fn> b, in the form
    ⍝      fnX this a b
    ⍝ where fnX is fn1 EXCEPT where b is an unsigned int, where fn2 is called.
    ⍝ If nzFlag, ensures that b is non-zero, else errors.
    ⍝  The object a or b may be this →→ Gmp handles.
    ⍝ While Gmp allows for uints on the left (a) in some cases, we just convert (a) to a gmpz obj
    ⍝ no matter what (this can be changed with additional coding).
        ∇ mpz← {nzFlag} (fn1 _Dyad_ fn2) (a b) ; aP; bP
            :If 900⌶⍬ ⋄ nzFlag← 0 ⋄ :EndIf                         ⍝ Must b be non-zero, no matter the type?
            :Hold ∆STATICS
                aP← Ptr0 a
                :If IsUI b                                         ⍝ APL unsigned integer in UL range, use fast path
                    :If nzFlag ⋄ :Andif 0= b ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf
                    {} fn2 ⍙ptr aP b                               ⍝ ==>  fn2  <==
                :Else                                              ⍝ b is an mpz, a string, a negative integer, or too large for UL.
                    bP← Ptr1 b
                    :If nzFlag ⋄ :Andif 0= PSignum bP ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf
                    {} fn1 ⍙ptr aP bP                              ⍝ ==>  fn1  <==
                :EndIf    
            :EndHold
            mpz← ⎕THIS
        ∇
    ⍝:EndSection Support Operators
    
⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝:Section Methods - Signum
    ⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝  Signum: ¯1, 0 or 1. A fast (but in the weeds) way to get the sign from an mpz int.
    ⍝  It reads the `_mp_size` field of the mpz_t directly (its sign is the integer's sign)
    ⍝  rather than calling into GMP. If this makes you nervous, use the gNs.Cmp call
    ⍝  as shown in [Alt] comment in PSignum.
        ∇ si← Signum; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            si← PSignum ⍙ptr
        ∇
    ⍝ PSignum ptr: Signum when you already have a pointer to an mpz_t.
    ⍝  Copies 8 bytes from offset 0 of the mpz_t as two I4s; the second I4 is
    ⍝  _mp_size, whose sign is the integer's sign. 1⌷ is correct only under
    ⍝  ⎕IO←0, which this class sets. A null pointer signals badObjÊ.
        ∇ si← PSignum ptr  ; CopyIVec
        ⍝  [Alt]  si← gNs.CmpI ptr 0   ⍝ Replaces two lines here.
            ⎕SIGNAL (ptr=0)/ badObjÊ
            CopyIVec← { gNs.MemCpyI (⍵⍴ 0) ⍺ (4× ⍵) }              ⍝ Get the sign of the variable at offset 0 (two 4-byte integers)
            si← ×1⌷ ptr CopyIVec 2
        ∇
    ⍝:EndSection Methods - Signum
    
⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝:Section Dyadic - Arithmetic
    ⍝ ───────────────────────────────────────────────────────────────────────────────
    ⍝  Common calling forms for the methods in this section (mpz = the receiver):
    ⍝        mpz.Op b      mpz← mpz Op b      (left operand defaults to ⎕THIS)
    ⍝      a mpz.Op b      mpz← a Op b        (mpz is only the destination)
    ⍝  The result is shy and is always ⎕THIS, so calls can be chained.
        
    ⍝  mpz.Add b / a mpz.Add b   →→   mpz← a + b
        ∇ {mpz}← {a} Add b; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf
            mpz← gNs.Add _Dyad_ gNs.AddU a b
        ∇
    ⍝  mpz.Sub b / a mpz.Sub b   →→   mpz← a - b
        ∇ {mpz}← {a} Sub b; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf
            mpz← gNs.Sub _Dyad_ gNs.SubU a b
        ∇
    ⍝  mpz.Mul b / a mpz.Mul b   →→   mpz← a × b
        ∇ {mpz}← {a} Mul b; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf
            mpz← gNs.Mul _Dyad_ gNs.MulU a b
        ∇
    ⍝  a c.Div b
    ⍝      mpz← Floor( a ÷ b )  (floored quotient)
    ⍝  a defaults to c.
    ⍝  Errors: divZÊ if b is 0.
        ∇ {mpz}← {a} Div b; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf
            mpz← 1 gNs.Div _Dyad_ gNs.DivU a b                     ⍝ ⍺ of 1: Ensure b≠0
        ∇
    ⍝   rem← a c.DivRem b.
    ⍝      Sets rem (the remainder) and c (a÷b, floored).
    ⍝   a defaults to c.
    ⍝   DivRemU returns the remainder as a UL as well; that return value is
    ⍝   ignored — the remainder is in rem, not in statics[2].
        ∇ {rem}← {a} DivRem b; aP; bP; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
            rem← ⎕NEW ∆THIS                                        ⍝ remainder returned as a new gmpz
            :Hold ∆STATICS
                aP← Ptr0 a
                :If IsUI b 
                    ⎕SIGNAL divZÊ/⍨ 0= b
                    {}gNs.DivRemU ⍙ptr rem.ptr aP b                ⍝ fdiv_qr_ui: remainder also returned as UL, ignored
                :Else
                    bP← Ptr1 b
                    ⎕SIGNAL divZÊ/⍨ 0= PSignum bP
                    {}gNs.DivRem ⍙ptr rem.ptr aP bP                ⍝ fdiv_qr: q=⍙ptr, r=remP
                :EndIf
            :EndHold
        ∇
    ⍝  mpz.Gcd b / a mpz.Gcd b   →→   mpz← a∨b   (greatest common divisor, ≥ 0)
        ∇ {mpz}← {a} Gcd b  ; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
            mpz←  gNs.Gcd _Dyad_ gNs.GcdU a b
        ∇
    ⍝  mpz.Lcm b / a mpz.Lcm b   →→   mpz← a∧b   (least common multiple, ≥ 0)
        ∇ {mpz}← {a} Lcm b  ; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
            mpz←  gNs.Lcm _Dyad_ gNs.LcmU  a b
        ∇
    ⍝  a Pow exp: Both 10*3 (power) and 10*÷3 (root)
    ⍝    exp must be a non-negative integer (power) or, to within 1E¯9, the
    ⍝    reciprocal of a positive integer (n-th root, truncated).
    ⍝    Even roots of negative numbers are rejected (powÊ).
    ⍝    Left operand a defaults to ⎕THIS.
        ∇ {mpz}← {a} Pow exp; aP; inv; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :Hold ∆STATICS
                :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                :If IsInt exp
                    :If exp<0 ⋄ ⎕SIGNAL powÊ ⋄ :EndIf
                    :If exp>UL_MAX ⋄ ⎕SIGNAL powÊ ⋄ :EndIf         ⍝ Pow (pow_ui) takes a UL exponent
                    {}gNs.Pow ⍙ptr aP exp                          ⍝ exp is a non-negative integer.
                ⍝ Integral Inverse: Do root.  ⍵ must be (nearly) ÷ an integer, e.g. ÷3,
                ⍝ and if the left operand is negative, ⍵ must be an odd number.
                ⍝ inv is assigned BEFORE it is used in the tolerance test below.
                :ElseIf (0=⊃0⍴exp) ∧ (1=≢,exp) ∧ (exp>0) ∧ (exp<1)
                    inv← ⌊0.5+ ÷exp
                    :If (inv≥1) ∧ (inv≤UL_MAX) ∧ (1E¯9≥ |1- exp× inv) ∧ ((¯1≠ PSignum aP) ∨ 0≠2| inv)
                        {}gNs.Root ⍙ptr aP inv
                    :Else
                        ⎕SIGNAL powÊ
                    :EndIf
                :Else
                    ⎕SIGNAL powÊ
                :EndIf
            :EndHold
            mpz← ⎕THIS
        ∇
        
    ⍝ mpz.PowM (exp mod) / a mpz.PowM (exp mod)   →→   mpz← (a ** exp) | mod
    ⍝ exp and mod may be gmpz objects, APL integers, or strings.
    ⍝ Guards: exp must be ≥ 0 (powÊ otherwise); mod must be > 0
    ⍝ (divZÊ for mod = 0, powÊ for mod < 0).
        ∇ {mpz}← {a} PowM exp_mod   ; aP; exp; expP; mod; modP; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
            exp mod← exp_mod                                       ⍝ Unpack exponent and modulus
            :Hold ∆STATICS
                aP← Ptr0 a                                         ⍝ Base -> statics[0] if not a gmpz
                expP← Ptr1 exp                                     ⍝ Exponent -> statics[1]
                modP← Ptr2 mod                                     ⍝ Modulus -> statics[2]
                ⎕SIGNAL powÊ/⍨ 0> PSignum expP                     ⍝ Exponent cannot be negative
                ⎕SIGNAL divZÊ/⍨ 0= PSignum modP                    ⍝ Modulus cannot be zero
                ⎕SIGNAL powÊ/⍨ 0> PSignum modP                     ⍝ Modulus cannot be negative
                {}gNs.PowM ⍙ptr aP expP modP                       ⍝ Call GMP: ⍙ptr← (aP ^ expP) % modP
            :EndHold
            mpz← ⎕THIS
        ∇
        
    ⍝ modulus mpz.Res b   →→   mpz← modulus | b
    ⍝ The Res residue/modulo is in the APL order using APL's rules.
    ⍝ APL's ⍺|⍵: ⍺ is the divisor, result is floored (sign of ⍺); 0|⍵ is ⍵
    ⍝ * In APL, when the left argument (divisor) is 0, the residue/modulo function is
    ⍝   defined to return the right argument unchanged.
    ⍝ Special case: if the modulus is the (unsigned) integer 2, we use a fast bit test:
    ⍝   ⎕THIS is set to bit 0 of b (0 if b is even, 1 if b is odd).
        ∇ {mpz}← mod Res b; modP; bP; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :Hold ∆STATICS
                bP← Ptr1 b
                :If IsUI mod
                    :Select mod
                      :Case 0 ⋄ :If ⍙ptr≠ bP ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf ⍝ b← 0|b
                      :Case 2 ⋄ {}⎕THIS.Set gNs.TstBit bP 0        ⍝ ⎕THIS← bit 0 of b
                    :Else
                        :If mod≤UL_MAX
                            {}gNs.FRemU ⍙ptr bP mod
                        :Else
                            modP← Ptr0 mod
                            {}gNs.FRem ⍙ptr bP modP
                        :EndIf
                    :EndSelect
                :Else
                    modP← Ptr0 mod
                    :If 0= PSignum modP                            ⍝ zero gmpz or string modulus
                        :If ⍙ptr≠ bP ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf  ⍝ b← 0| b
                    :Else
                        {}gNs.FRem ⍙ptr bP modP
                    :EndIf
                :EndIf
            :EndHold
            mpz← ⎕THIS 
        ∇
        
    ⍝ rc← {a} Invert mod   — compute modular inverse a^-1 mod mod.
    ⍝ Updates receiver with the inverse if it exists, returning 1 (success) or 0 (no inverse).
    ⍝ Guards: mod must be > 0 (divZÊ for mod = 0, powÊ for mod < 0).
        ∇ rc← {a} Invert mod   ; aP; modP; ⎕TRAP
          :Access Public
            ⎕TRAP← ∆TRAP
            :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
            :Hold ∆STATICS
                aP← Ptr0 a ⋄ modP← Ptr1 mod
                ⎕SIGNAL divZÊ/⍨ 0= PSignum modP                    ⍝ Modulus cannot be zero
                ⎕SIGNAL powÊ/⍨ 0> PSignum modP                     ⍝ Modulus cannot be negative
                rc← gNs.Invert ⍙ptr aP modP                        ⍝ Returns non-zero on success, 0 if none
            :EndHold
        ∇
        
    ⍝:⍝EndSection Dyadic - Arithmetic
        
    ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝:Section Dyadic/Monadic - Logical / Bit Manipulation
        ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝  mpz← h mpz.Shift b  →→  mpz← b × 2*h
        ⍝    h > 0  shift left  (multiply by 2*h, where * is power)
        ⍝    h < 0  shift right (divide by 2*|h|, truncating toward zero)
        ⍝    h = 0  copy b unchanged
        ⍝    h must be an integer (else shiftÊ) and fit in a UL.
            
            ∇ {mpz}← h Shift b; bP; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If (0=⊃0⍴h) ∧ (h≠⌊h) ⋄ ⎕SIGNAL shiftÊ ⋄ :EndIf    ⍝ Non-integer numeric shift
                h← ToInt h                                         ⍝ h: how much to shift (gmpz / string / APL int)
                ⎕SIGNAL shiftÊ/⍨ |h>UL_MAX                         ⍝ Shift amount must fit in a UL
                :Hold ∆STATICS
                    bP← Ptr1 b
                    :Select ×h
                      :Case  1 ⋄ {}gNs.ShiftL ⍙ptr bP h            ⍝ left shift: a multiplication by 2*h
                      :Case ¯1 ⋄ {}gNs.ShiftR ⍙ptr bP (-h)         ⍝ right shift: a division by 2*|h|, truncating toward zero
                    :Else
                        :If ⍙ptr≠ bP ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf  ⍝ Return mpz← b
                    :EndSelect
                :EndHold
                mpz← ⎕THIS
            ∇
            
        ⍝ TestBit:  Retrieve a bit of an mpz at index <ix>
            ∇ {bit}← {a} TestBit ix   ; aP; ∆io; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                ∆io← (⊃⎕RSI).⎕IO 
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                    ix← ∆io-⍨ ToInt ix
                    ⎕SIGNAL badBitIxÊ/⍨ (ix<∆io)∨(ix>UL_MAX)
                    bit← gNs.TstBit aP ix
                :EndHold
            ∇
            
        ⍝ SetBit:  val← {a} SetBit ix [val←1]
        ⍝ Sets a bit of an mpz at index <ix> to  val (default is 1).
        ⍝ Returns the value set to.  Honours ⎕IO.
            ∇ {val}← {a} SetBit ix_val   ; aP; ix; ∆io; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                ∆io← (⊃⎕RSI).⎕IO
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                    ix val← 2↑ix_val, 1
                    ix← ∆io-⍨ ToInt ix
                    val← ToInt val
                    ⎕SIGNAL badBitIxÊ/⍨ (ix<∆io)∨(ix>UL_MAX)
                    ⎕SIGNAL badBitValÊ/⍨ ~val∊0 1
                    :If val
                        {}gNs.SetBit aP ix
                    :Else
                        {}gNs.ClrBit aP ix
                    :EndIf
                :EndHold
            ∇
            
        ⍝ ClrBit: val← {a} ClrBit ix
        ⍝   Clears a bit of an mpz at index <ix>
        ⍝ Same as {a} SetBit ix 0. Honours ⎕IO.
            ∇ {bit}← {a} ClrBit ix    ; aP; ∆io; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                ∆io← (⊃⎕RSI).⎕IO
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                    ix← ∆io-⍨ ToInt ix
                    ⎕SIGNAL badBitIxÊ/⍨ (ix<0)∨(ix>UL_MAX)
                    {}gNs.ClrBit aP ix
                :EndHold
                bit← 0
            ∇
            
        ⍝ Flip: bit← {a} Flip ix   - Flip index ix in a (using gNs.ComBit -- Complement the bit)
        ⍝ Here, we ALSO return the new bit value. Honours ⎕IO.
            ∇ {bit}← {a} Flip ix  ; aP; ∆io; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                ∆io← (⊃⎕RSI).⎕IO
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                    ix← ∆io-⍨ ToInt ix
                    ⎕SIGNAL badBitIxÊ/⍨ (ix<0)∨(ix>UL_MAX)
                    {}gNs.ComBit aP ix
                    bit← gNs.TstBit aP ix
                :EndHold
            ∇
            
            ∇ p← {a} Scan (p0 bit); aP; ∆io; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                ∆io← (⊃⎕RSI).⎕IO
                p0← ∆io-⍨ ToInt p0
                ⎕SIGNAL badBitIxÊ/⍨ (p0<0)∨(p0>UL_MAX)
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                    p← ⍙Scan aP p0 bit
                :EndHold
                p+← ∆io
            ∇
            
            ∇ p← {a} Iota bit; aP; ∆io; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                ∆io← (⊃⎕RSI).⎕IO
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                    p← ⍙Scan aP 0 bit
                :EndHold
                p+← ∆io
            ∇
            
            ⍝:Section Helper for Scan and Iota
            ⍝ ⍙Scan (aP p0 bit): private. 0-origin start; returns 0-origin position,
                ∇ p← ⍙Scan (aP p0 bit)
                    :Select ToInt bit
                      :Case 1 ⋄ p← gNs.Scan1 aP p0
                      :Case 0 ⋄ p← gNs.Scan0 aP p0
                    :Else ⋄ ⎕SIGNAL badBitValÊ
                    :EndSelect
                ∇
            ⍝:EndSection Helper for Scan and Iota
            
        ⍝ And: {a} And b
            ∇ {mpz}← {a} And b   ; aP; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                    {}gNs.And ⍙ptr aP (Ptr1 b)
                :EndHold
                mpz← ⎕THIS
            ∇
            
        ⍝ Or: {a} Or b
            ∇ {mpz}← {a} Or b   ; aP; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                    {}gNs.Or ⍙ptr aP (Ptr1 b)
                :EndHold
                mpz← ⎕THIS
            ∇
            
        ⍝ XOr: {a} Xor b
            ∇ {mpz}← {a} Xor b   ; aP; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                    {}gNs.Xor ⍙ptr aP (Ptr1 b)
                :EndHold
                mpz← ⎕THIS
            ∇
            
        ⍝:EndSection Dyadic - Logical / Bit Manipulation
        
    ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝:Section Monadic - Arithmetic
        ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝  mpz.Neg b   →→   mpz← -b
            ∇ {mpz}← Neg b; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                {} gNs.Neg  ⍙ptr (Ptr1 b)
                mpz← ⎕THIS
            ∇
        ⍝  mpz.Abs b   →→   mpz← |b
            ∇ {mpz}← Abs b; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                {} gNs.Abs ⍙ptr (Ptr1 b)
                mpz← ⎕THIS
            ∇
        ⍝  bool← ⍵.Divisible b  -- Is ⍵ divisible by b, any kind of number?
        ⍝  Unlike standard division functions which throw exceptions or crash on zero,
        ⍝  mpz_divisible_p explicitly accepts d = 0. Following mathematical rules, only 0 is considered divisible by 0
        ⍝  Returns a (non-mpz) boolean-like integer: nonzero if divisible.
            ∇ {bool}← Divisible b; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                bool← gNs.Divisible ⍙ptr (Ptr1 b)
            ∇
            
        ⍝:EndSection Monadic - Arithmetic
        
    ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝:Section (Pseudo-)Monadic - Factorial
        ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝  mpz.Fac n   →→   mpz← !n.    n must be a non-negative integer fitting in a
        ⍝    C unsigned long: 0 ≤ num ≤ UL_MAX (32-bit on Windows, 64-bit elsewhere).
        ⍝    n may be an APL integer, an integer string, or a gmpz.
        ⍝  Large factorials are limited only by memory and time.
            ∇ {mpz}← Fac num; ok; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If IsMpz num
                    num← num.Int                                   ⍝ Issues its own error, if needed!
                :ElseIf IsStr num 
                    ok num← ⎕VFI num
                    ⎕SIGNAL facBadÊ/⍨ ~ok
                    ⎕SIGNAL facBadÊ/⍨ ~IsUI num
                :ElseIf ~IsUI num                                      
                    ⎕SIGNAL facBadÊ
                :EndIf
                {} gNs.Fac ⍙ptr num                  
                mpz← ⎕THIS
            ∇
        ⍝:EndSection (Pseudo-)Monadic - Factorial
        
    ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝:Section Comparison Functions: Cmp, Lt, Le, Eq, Ne, Ge, >
        ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝  c← {a} c.Cmp b     — three-way compare:  rc← × (a - b)  →  ¯1, 0 or 1
        ⍝  Monadic use compares c with b.  Dyadic use compares a with b.
        ⍝  If b is an APL integer fitting in a signed 64-bit integer, the faster
        ⍝  signed-int compare is used; otherwise the mpz compare is used.
        ⍝  The wrappers below return 0/1 and take the same arguments:
        ⍝     Lt (<)   Le (≤)   Eq (=)   Ge (≥)   Gt (>)  Ne (≠)
        ⍝ Note that the GMP comparisions don't guarantee the returned results are ¯1 0 1, only that the signs are correct.
        ⍝ Hence the use of signum (×).
        ⍝  Trap rule (see header): Cmp and each wrapper are public entry points,
        ⍝  so each sets ⎕TRAP←∆TRAP on entry.
            ∇ rc← {a} Cmp b   ; aP; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :Hold ∆STATICS
                    :If 900⌶⍬ ⋄ aP← ⍙ptr
                    :Else     ⋄ aP← Ptr0 a
                    :EndIf
                    :If IsInt b 
                    :Andif (b≥-IL_MAX-1)  
                    :Andif (b≤IL_MAX)    
                        rc← ×gNs.CmpI aP b
                    :Else
                        rc← ×gNs.Cmp aP (Ptr1 b)
                    :EndIf
                :EndHold
            ∇
        ⍝  a Lt b  →  a<b
            ∇ rc← {a} Lt b; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
                rc← (a Cmp b) < 0
            ∇
        ⍝  a Le b  →  a≤b
            ∇ rc← {a} Le b; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
                rc← (a Cmp b) ≤ 0
            ∇
        ⍝  a Eq b  →  a=b
            ∇ rc← {a} Eq b; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
                rc← (a Cmp b) = 0
            ∇
        ⍝  a Ne b  →  a≠b
            ∇ rc← {a} Ne b; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
                rc← (a Cmp b) ≠ 0
            ∇
        ⍝  a Ge b  →  a≥b
            ∇ rc← {a} Ge b; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
                rc← (a Cmp b) ≥ 0
            ∇
        ⍝  a Gt b  →  a>b
            ∇ rc← {a} Gt b; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
                rc← (a Cmp b) > 0
            ∇
        ⍝:EndSection Comparison Functions: Cmp, Lt, Le, Eq, Ne, Ge, >
        
    ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝:Section Monadic - Rand, RandSeed
        ⍝ ───────────────────────────────────────────────────────────────────────────────
            
        ⍝ Rand # Functions
        ⍝ Unless RandSeed is called, the random # is seeded from Dyalog APL with a random integer.
        ⍝ Each function passes a GMP randstate state variable, which is allocated on first use of Rand or RandSeed.
        ⍝ See also RandSeed below.
            
        ⍝ {c}← c.Rand b                                            ⍝  c← a random # r in range: (⎕IO) ≤ r < (b+1+⎕IO).    Sensitive to ⎕IO.
        ⍝   b: a valid mpz, integer, or integer string.
        ⍝ An alias to c is returned.
        ⍝
        ⍝ Very fast.  Errors: randÊ if b ≤ 0 (GMP urandomm aborts on a non-positive bound).
            ∇ {mpz}← Rand b   ; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If ⎕NULL≡rsInstance ⋄ rsInstance← ⎕NEW randState ⋄ :EndIf
                ⎕SIGNAL randÊ/⍨ 0≥ PSignum (Ptr0 b)
                {}gNs.URandomM ⍙ptr rsInstance.ptr (Ptr0 b)
                :If (⊃⎕RSI).⎕IO
                    {}gNs.AddU ⍙ptr ⍙ptr 1
                :EndIf
                mpz← ⎕THIS
            ∇
            
        ⍝  {c}← c.RandB nbits.      c←  a random number r in range: ⎕IO ≤ r < (⎕IO+2*nbits).   Sensitive to ⎕IO
        ⍝    b: number of bits of binary range.
        ⍝  An alias to c is returned.
        ⍝  Errors: randÊ if nbits < 0 (GMP urandomb aborts on a negative bit count).
            ∇ {mpz}← RandB nbits   ; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If ⎕NULL≡rsInstance ⋄ rsInstance← ⎕NEW randState ⋄ :EndIf
                nbits← ToInt nbits
                ⎕SIGNAL randÊ/⍨ (nbits<0) ∨ (nbits>UL_MAX)
                {}gNs.URandomB ⍙ptr rsInstance.ptr nbits
                :If (⊃⎕RSI).⎕IO
                    {}gNs.AddU ⍙ptr ⍙ptr 1
                :EndIf
                mpz← ⎕THIS
            ∇
            
            
        ⍝ gmpz.RandSeed ui, where u8 is a UL integer greater than 0.
        ⍝ To seed with a random APL integer (using system entropy), use RandSeed 0 (zero).
        ⍝ Returns the old seed in string form.
        ⍝
        ⍝ At initialisation, the random seed is ?UL_MAX (with ⎕FR=1287), i.e. seeded from
        ⍝ a random APL integer, based on system entropy (⎕RL using RNG2).
        ⍝ If you want predictable sequences (out of a larger range), reset it using RandSeed.
            ∇ {old}← RandSeed u8  ; ⎕TRAP
              :Access Public Shared
                ⎕TRAP← ∆TRAP
                :If ⎕NULL≡rsInstance ⋄ rsInstance← ⎕NEW randState ⋄ :EndIf
                u8← ToInt u8
                ⎕SIGNAL randSeedÊ/⍨ ~IsUI u8
                
                :If u8= 0 ⋄ u8← 1+ ?WINDOWS⊃¯2+2*63 ¯1+2*32 ⋄ :EndIf ⍝ 1 to UL_MAX.
                {}gNs.RandSeedU rsInstance.ptr u8                  ⍝ rsInstance.ptr is its C-language pointer
                
                old← ⍕⊃randState.seeds
                randState.seeds← 2↑ u8, randState.seeds
            ∇
        ⍝:EndSection Monadic - Rand
        
    ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝:Section Niladic - Arithmetic
        ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝  ⍵.Inc - Increments ⍵ by 1 (in place)
            ∇ {mpz}← Inc   ; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                {}gNs.AddU ⍙ptr ⍙ptr 1
                mpz← ⎕THIS
            ∇
        ⍝  ⍵.Dec - Decrements ⍵ by 1 (in place)
            ∇ {mpz}← Dec     ; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                {}gNs.SubU ⍙ptr ⍙ptr 1
                mpz← ⎕THIS
            ∇
        ⍝  ⍵.Even / ⍵.Odd - parity tests (via the lowest bit); return 1 or 0.
            ∇ {bool}← Even   ; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                bool← 0= gNs.TstBit ⍙ptr 0
            ∇
            ∇ {bool}← Odd    ; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                bool← 1= gNs.TstBit ⍙ptr 0
            ∇
        ⍝:EndSection Niladic - Arithmetic
        
    ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝:Section Niladic - Export
        ⍝ ───────────────────────────────────────────────────────────────────────────────
        ⍝  int← ⍵.IntMpz   - Returns ⍵ in APL 64-bit integer (i.e. decimal float) form, if it fits!
        ⍝                 Errors: badIntÊ if the value does not fit in a signed 64-bit integer.
            ∇ i64← Int    ; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                ⎕SIGNAL badIntÊ/⍨ ~gNs.IntFits ⍙ptr
            ⍝ ⎕← ⌷⎕THIS
                i64← gNs.Int ⍙ptr
            ∇
        ⍝ Int← ⍵.Int  This uses APL's ⎕VFI, which-- under ⎕FR=1287-- allows larger integers up to:
        ⍝   999999999999999999999999999999999, i.e. ¯1+10*34
            ∇ i64← IntApl   ; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                ok i64← ⎕VFI ⌷⎕THIS 
                ⎕SIGNAL badIntÊ/⍨ (i64> I128_Max) ~ok 
                i64← ⍬⍴i64 
            ∇
        ⍝ rc int← ⍵.VFI;  If ⍵ fits into an APL decimal float format, returns (1 int), int as above,
        ⍝                 else returns (0 0).
        ⍝                 (Like ⎕VFI, but never signals an error.)
            ∇ int2← VFI   ; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                :If gNs.IntFits ⍙ptr
                    int2← 1 (gNs.Int ⍙ptr)
                :Else
                    int2← 0 0
                :EndIf
            ∇
            
        ⍝ str←  ⍺.GetInBase n  -- Retrieves ⍺ as a string in base n.
        ⍝ base∊ 2 … 62, and the result uses '¯' for negatives, like the ⌷ property.
            ∇ str←  GetInBase base ; n; ⎕TRAP
              :Access Public
                ⎕TRAP← ∆TRAP
                base← ToInt base
                ⎕SIGNAL badAplÊ/⍨ (base<2) ∨ (base>62)
                n← 2+ gNs.SizeInBase ⍙ptr base                     ⍝ digits + possible sign + NUL
            ⍝ Create a place in APL for the null-terminated string. from GetStr
                str← '¯'@('-'∘=)⊢ gNs.GetStr (n⍴⎕UCS 0) base ⍙ptr  ⍝ Import that result
            ∇
            
        ⍝  str← {base←10} gmpz.Get b, where b is gmpz, string, or integer.
        ⍝  Value is in the specified base.
            ∇ str←  {base} Get b  ; ⎕TRAP
              :Access Public Shared 
                ⎕TRAP← ∆TRAP
                :If 900⌶⍬ ⋄ base← 10 ⋄ :EndIf
                str← (base Mpz0 b).GetInBase base 
            ∇
            
            ⍝:Section Bit - Efficiently setting and getting a single bit (or a few) in 2s complement form   
            ⍝ Bit:   a.Bit[5], a.Bit[1 2 3]
            ⍝        a.Bit[1 2 3]← 1 0 1,  a.Bit[1 2 3]← 0
            ⍝  Invalid:  a.Bit[] or a.Bit.  Use a.Bits
            ⍝  Allow user to set and test/clear one or more bits
            ⍝      a.Bit[5],  a.Bit[5]← 1
            ⍝  Bit indexes in the user's ⎕IO
            ⍝  Bit will set or get ANY bit in the index space of GMP.
            ⍝  Note the function Bits can be used to get or set ALL bits in an object. It is efficient.
                :Property Keyed Bit
                  :Access Public Instance
                    ∇ vals← get arg; ixs; ∆io; ⎕TRAP
                        ⎕TRAP← ∆TRAP
                        ∆io← (⊃⎕RSI).⎕IO                           ⍝ See ⍙CallerIO: verify ⊃⎕RSI in Dyalog
                        ixs← ∆io-⍨ ⊃arg.Indexers
                        ⎕SIGNAL badBitIxÊ/⍨ 0=≢,ixs                ⍝ Empty indexer list is an error
                        ⎕SIGNAL  badBitIxÊ/⍨ ∨/ (ixs<0)∨(ixs>UL_MAX)
                        vals← (⍴ixs)⍴ {gNs.TstBit ⍙ptr ⍵}¨ixs
                    ∇
                    
                    ∇ set arg; vals; ixs; ∆io; i; ⎕TRAP
                        ⎕TRAP← ∆TRAP
                        ∆io← (⊃⎕RSI).⎕IO                           ⍝ See ⍙CallerIO: verify ⊃⎕RSI in Dyalog
                        ixs←  ,∆io-⍨ ⊃arg.Indexers
                        ⎕SIGNAL badBitIxÊ/⍨ 0=≢,ixs                ⍝ Empty indexer list is an error
                        ⎕SIGNAL badBitIxÊ/⍨ ∨/ (ixs<0)∨(ixs>UL_MAX) ⍝ Negative indices are an error (get checks too)
                        vals← ,(⍴ixs)⍴ arg.NewValue                ⍝ Expand single bit => bit vector
                        :For i :In ⍳≢ixs                           ⍝ ⎕IO←0 here, so ⍳ gives 0-origin indices
                            :If (i⊃vals)=1
                                {}gNs.SetBit ⍙ptr (i⊃ixs)
                            :ElseIf (i⊃vals)=0
                                {}gNs.ClrBit ⍙ptr (i⊃ixs)
                            :Else
                                ⎕SIGNAL badBitValÊ
                            :EndIf
                        :EndFor
                    ∇
                :EndProperty
            ⍝:EndSection Bit - Efficiently setting and getting a single bit (or a few) in 2s complement form
            
            ⍝:Section Bits - Efficiently setting and getting entire object as bits 
                :Property Simple Bits 
                  :Access Public Instance
                ⍝  Retrieve the gmpz integer
                    ∇  bitsOut← Get  ; n; ⎕TRAP
                        ⎕TRAP← ∆TRAP
                        bitsOut← ExportBits 
                    ∇
                    ∇  Set args ; bitsIn; ⎕TRAP
                        ⎕TRAP← ∆TRAP
                        ⎕SIGNAL propSetÊ/⍨ 0≠ args.⎕NC 'Indexers'  ⍝ Trap attempts to do ⍺.Bits[i]← val 
                        bitsIn← args.NewValue 
                        ImportBits bitsIn 
                    ∇
                :EndProperty 
                
                ⍝:S User Routines that Support Bits Property  
                ⍝ a.ExportBits:  Retrieves all of a as an APL bit vector
                ⍝  bits← a.ExportBits
                ⍝ bits:  MSB-first boolean vector of two's complement bits
                ⍝ Equiv to   a.Bit[⌽ ⍳a.Len ] but much faster!
                    ∇  bits← ExportBits 
                          ; width; sgn; k; nlimbs; limbs; count; isPow2
                          ; reqLimbs; wLimbs; maxWord; inv; c; carryIn; finalLimbs
                      :Access Public Instance  
                        width← 0                                   ⍝ width: desired bit-width (0: choose minimal size)
                        sgn← PSignum ⍙ptr
                        k← gNs.SizeInBase ⍙ptr 2
                        nlimbs← gNs.Size ⍙ptr
                    ⍝ Export raw 64-bit limbs (LSW first, native endianness) via memcpy fast-path
                        (limbs count)← gNs.Export nlimbs 0 ¯1 8 0 0 ⍙ptr
                        width←  LenMinBits ⍙ptr
                    ⍝ Resize limb vector to cover `width` bits (pads with 0s if wider than magnitude)
                        reqLimbs← ⌈width ÷ 64
                        wLimbs← reqLimbs ↑ limbs
                    ⍝ Apply two's complement (~x + 1) across 64-bit words if negative
                        :If sgn < 0
                            maxWord← (2*64) - 1
                            inv← maxWord - wLimbs                  ⍝ Bitwise NOT of each 64-bit limb
                            c← ∧\ inv = maxWord                    ⍝ Carry propagates past all contiguous all-1 limbs
                            carryIn← 1, ¯1↓c                       ⍝ +1 enters at the least significant limb
                            finalLimbs← (maxWord+1)| inv + carryIn
                        :Else
                            finalLimbs← wLimbs
                        :EndIf
                    ⍝ Reverse to MSW-first, decode each 64-bit word to bits, flatten, and trim to `width`
                        bits← (-width)↑ ,⍉(64⍴2)⊤ ⌽finalLimbs
                    ∇   
                ⍝  ImportBits bits:  Set a from an APL bit vector
                ⍝  a.Import bits
                    ∇ ImportBits bits
                          ; isNeg; width; padLen; padded; words; lswWords; MW; inv; c; carryIn; magWords
                      :Access Public Instance  
                        MW← ¯1+ 2*64
                        :If 0 = ≢bits
                            {}gNs.Import ⍙ptr 0 ¯1 8 0 0 (0⍴0) ⋄ Return 
                        :EndIf
                        :If 11≠ ⎕DR bits                           ⍝ Skip the test if we have a bit vector. 
                            ⎕SIGNAL badBitsÊ/⍨ ∨/~bits∊ 0 1        ⍝ Possible scalar 1, 0 
                        :EndIf 
                        isNeg width← (⊃,≢) bits                    ⍝ MSB is the two's complement sign bit
                    ⍝ Sign-extend on the left to a multiple of 64 bits
                        padLen← 64| -width
                        padded← (padLen⍴ isNeg), bits
                    ⍝ Reshape into 64-bit rows (MSW first), decode to U8 integers, and reverse to LSW first
                        words← 2⊥ ⍉((≢padded)÷64) 64⍴ padded
                        lswWords← ⌽words
                        :If isNeg                                  ⍝ Undo two's complement (~x + 1) to recover unsigned magnitude words
                            carryIn← 1, ¯1↓c← ∧\MW= inv← MW- lswWords
                            magWords← (MW+ 1)| inv + carryIn
                        :Else
                            magWords← lswWords
                        :EndIf
                    ⍝ Import unsigned limbs (order=¯1 LSW first, size=8 bytes, endian=0 native)
                        {}gNs.Import ⍙ptr (≢magWords) ¯1 8 0 0 magWords
                    ⍝ Apply negative sign if MSB was 1
                        :If isNeg
                            {}gNs.Neg ⍙ptr ⍙ptr 
                        :EndIf
                    ∇
                ⍝:EndS User Routines that Support Bits Property
            ⍝:EndSection Bits - managing entire object as bits 
            
        ⍝ ───────────────────────────────────────────────────────────────────────────────
            ⍝:Section Prime Numbers
            ⍝ ───────────────────────────────────────────────────────────────────────────────
            ⍝  rc← ⍵.ProbabPrime cycles      (instance method: tests ⍙ptr, the receiver)
            ⍝      cycles: Reasonable values of reps are between 15 and 50.
            ⍝              Set to 0 (or omit it) for default (24, a "good" compromise).
            ⍝  Return 2 if n is definitely prime,
            ⍝  return 1 if n is probably prime (without being certain), or
            ⍝  return 0 if n is definitely non-prime.
            ⍝  The Gmp manual suggests values between 15 and 50 are reasonable, and
            ⍝  says that with 24 reps the chance of a composite slipping through is
            ⍝  negligible for practical purposes.
                ∇ {bool}←  ProbabPrime cycles   ; ⎕TRAP
                  :Access Public
                    ⎕TRAP← ∆TRAP
                    :Hold ∆STATICS
                        :If 0=≢,cycles ⋄ cycles← 24
                        :Else
                            cycles← ToInt cycles
                            :If cycles=0 ⋄ cycles← 24 ⋄ :EndIf
                        :EndIf
                        ⎕SIGNAL primeÊ/⍨ (~IsUI cycles) ∨ (cycles>¯1+2*31)
                        bool← gNs.ProbabPrime ⍙ptr cycles
                    :EndHold
                ∇
            ⍝  mpz.NextPrime ⍵: Sets mpz to the next (pseudo)prime greater than ⍵
                ∇ {mpz}← NextPrime b    ; ⎕TRAP
                  :Access Public
                    ⎕TRAP← ∆TRAP
                    :Hold ∆STATICS
                        {}gNs.NextPrime ⍙ptr (Ptr1 b)
                    :EndHold
                    mpz← ⎕THIS
                ∇
            ⍝  PrevPrime:  mpz← ⍺.PrevPrime ⍵
            ⍝  Sets mpz to the (pseudo)prime previous to ⍵.
            ⍝  Note: gNs.PrevPrime returns void (mpz_prevprime), so it returns no
            ⍝  certainty value. See PrevPrime2 for the certainty.
                ∇ {mpz}← PrevPrime b  ; ⎕TRAP
                  :Access Public
                    ⎕TRAP← ∆TRAP
                    :Hold ∆STATICS
                        {}gNs.PrevPrime ⍙ptr (Ptr1 b)
                    :EndHold
                    mpz← ⎕THIS
                ∇
            ⍝  PrevPrime2:  (mpz rc)← ⍺.PrevPrime2 ⍵
            ⍝  Like PrevPrime, but also returns the likelihood of primality:
            ⍝  rc is 2 (definitely prime), 1 (probably prime), or 0 (not prime),
            ⍝  from ProbabPrime 24 applied to the previous prime just found.
                ∇ {mpz_rc}← PrevPrime2 b ; ⎕TRAP
                  :Access Public
                    ⎕TRAP← ∆TRAP
                    mpz_rc← ⎕THIS, gNs.PrevPrime ⍙ptr (Ptr1 b)
                ∇
                
            ⍝ rc← {a} Jacobi b   — compute the Jacobi symbol (a/b), returning -1, 0, or 1.
            ⍝ b must be an odd integer (per GMP specifications); an even b signals badAplÊ.
                ∇ rc← {a} Jacobi b   ; aP; bP; ⎕TRAP
                  :Access Public
                    ⎕TRAP← ∆TRAP
                    :Hold ∆STATICS
                        :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
                        bP← Ptr1 b
                        ⎕SIGNAL badAplÊ/⍨ ~gNs.TstBit bP 0
                        rc← gNs.Jacobi aP bP
                    :EndHold
                ∇
            ⍝:EndSection Prime Numbers
            
        ⍝ ───────────────────────────────────────────────────────────────────────────────
            ⍝:Section  Miscellany
            ⍝ ───────────────────────────────────────────────────────────────────────────────
            ⍝  len← obj.StrLen : Returns the number of characters required by the object in APL,
            ⍝                   including the sign, if any.  Equivalent to ≢⌷x.
            ⍝  Example:   (bigNum.StrLen ≡ ≢⌷bigNum)               ⍝ Returns 1 for gmpz objects.
            ⍝     len← x.StrLen : number of characters ⌷x would have, including a leading '¯'.
            ⍝  Exact, without generating the string.
                ∇ len← StrLen ; n; v; t; ⎕TRAP
                  :Access Public
                    ⎕TRAP← ∆TRAP
                    n← gNs.SizeInBase ⍙ptr 10                      ⍝ true digit count, or 1 too many
                    :If n≤ (⍴⍕IL_MAX)-1                            ⍝ always fits an IL: stay in APL
                        v← gNs.Int ⍙ptr
                        len← (n- (n>1)∧ (|v)< 10*n-1) + v<0        ⍝ n=1 is exact (guards 0)
                    :Else
                        t← ⎕NEW ∆THIS                              ⍝ scratch; freed on exit
                        {}gNs.UiPow t.ptr 10 (n-1)                 ⍝ t← 10*n-1
                        len← (n- 0> gNs.CmpAbs ⍙ptr t.ptr) + ¯1= PSignum ⍙ptr
                    :EndIf
                ∇
                
            ⍝  len← obj.Len  : Returns the number of bits required by the object in gmpz
            ⍝                  Bits are what can be accessed and set. See obj.Bit[ix].
                ∇ len← Len ; n; v; t; ⎕TRAP
                  :Access Public
                    ⎕TRAP← ∆TRAP
                    len← LenMinBits ⍙ptr 
                ∇
            ⍝ Determine minimum bit-width in twos complement.
            ⍝   len← LenMinBits ⍙ptr
                LenMinBits← {
                    sgn← PSignum ⍵ 
                  sgn= 0: 1 
                  sgn> 0: 1 + gNs.SizeInBase ⍵ 2
                    k← gNs.SizeInBase ⍵ 2
                    lowBit← gNs.Scan1 ⍵ 0                          ⍝ 0-based index of the lowest '1' bit in magnitude
                    k + lowBit≠ k- 1                               ⍝ k bits if exact power of 2, else k + 1
                } 
                
                ∇ len← LenInBase base ; n; v; t; ⎕TRAP
                  :Access Public
                    ⎕TRAP← ∆TRAP
                    n← gNs.SizeInBase ⍙ptr base                    ⍝ true digit count, or 1 too many
                    :If n≤ (⍴⍕IL_MAX)-1                            ⍝ always fits an IL: stay in APL
                        v← gNs.Int ⍙ptr
                        len← (n- (n>1)∧ (|v)< base*n-1) + v<0      ⍝ n=1 is exact (guards 0)
                    :Else
                        t← ⎕NEW ∆THIS                              ⍝ scratch; freed on exit
                        {}gNs.UiPow t.ptr base (n-1)               ⍝ t← 10*n-1
                        len← (n- 0> gNs.CmpAbs ⍙ptr t.ptr) + ¯1= PSignum ⍙ptr
                    :EndIf
                ∇
            ⍝ ───────────────────────────────────────────────────────────────────────────────
            ⍝:EndSection  Miscellany
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
        ⍝    Dyadic        a +GI b    a + b             a ∨GI b   gcd
        ⍝                  a -GI b    a - b             a ∧GI b   lcm
        ⍝                  a ×GI b    a × b             a |GI b   a|b  (a is modulus)
        ⍝                  a ÷GI b    floored a÷b       a ⌽GI b   shift b by a bits
        ⍝                  a *GI b    a*b  (b may be ÷n for an n-th root)
        ⍝                  a ⊥GI b    a c.Set b: b in base a
        ⍝                  a *∘|GI b  (a ** exp) | mod, where (exp mod)←b
        ⍝                  a ÷∘|GI b  (a÷b) and (b|a), as a 2-element vector
        ⍝                  a ⍳GI b    a⍳i, where i∊ 0 1 (first bit of that value)
        ⍝                  a ⌷GI b    b.Bit[a] (bit a of b)
        ⍝                Comparisons (return an APL 0/1, not an object):
        ⍝                  a <GI b    a ≤GI b    a =GI b
        ⍝                  a >GI b    a ≥GI b    a ≠GI b
        ⍝
        ⍝    Monadic       -GI b   negate            |GI b   absolute value
        ⍝                  ?GI b   random in [0,b)   !GI b   factorial
        ⍝                  ×GI b   sign, ¯1 0 1 (returns an APL integer, not an object)
        ⍝                  <GI b   b-1  (decrement; note the use of monadic <)
        ⍝                  >GI b   b+1  (increment)
        ⍝                  ≢GI b   length of b as a string (StrLen)
        ⍝                  ⍎GI b   b as an APL integer (Int; errors if it does not fit)
        ⍝                  ⌷GI b   b as a string (⌷ of a fresh gmpz holding b)
        ⍝                  ⊂GI b   a fresh gmpz holding b
        ⍝
        ⍝    Result        The new gmpz (use ⌷res for its string form) unless the
        ⍝                  operation is a comparison or monadic ×, which return a plain
        ⍝                  integer.
        ⍝    Errors        unknownÊ for an unsupported glyph; the underlying method's
        ⍝                  error (divZÊ, powÊ, …) is passed through.
        ⍝    Notes         Local ⎕IO ⎕ML, DmxSig and unknownÊ are redefined inside GI
        ⍝                    so that it still works when copied out of the class.
        ⍝                  The line after the ∇ (the #.⎕FX …) makes a copy in # in
        ⍝                    which the name `gmpz` is replaced by the class's full name,
        ⍝                    so `GI` can be used from any namespace.
        ⍝ ───────────────────────────────────────────────────────────────────────────────
            ∇ res← {a}(fn GI)b
                  ; c; nm
                  ; ⎕TRAP                                          ⍝ ⎕ML ⎕IO from caller
                  ; Atom; DmxSig; unknownÊ
                
                ⎕ML← 1
                DmxSig← ⎕SIGNAL{⊂⎕DMX.('EN' EN ⋄ 'Message' Message)}
                unknownÊ← ⊂('EN' 11 ⋄ 'Message' 'Unknown operand')
                ⎕TRAP← 0 'E' 'DmxSig⍬'
                Atom← { 1= ≢f← ∊⎕NR ⍵: ⍬⍴f ⋄ f}
                nm← Atom 'fn'                                      ⍝ the primitive glyph of the operand
                res← c←  gmpz.tempGI                               ⍝ Use this temp var.
                
                :If 900⌶⍬
                ⍝  MONADIC
                    :Select nm
                      :Case '-'    ⋄ c.Neg b                       ⍝ c← -b
                      :Case '|'    ⋄ c.Abs b                       ⍝ c← |b
                      :Case '?'    ⋄ c.{ ⍵ Ge 0: Rand ⍵ ⋄ RandB Neg ⍵ } b ⍝ If b>0, do Rand b. If b<0, do RandB -b.
                      :Case '×'    ⋄ res← (c.Set b).Signum         ⍝ c← ×b
                      :Case '!'    ⋄ c.Fac b                       ⍝ c← !b
                      :Case '<'    ⋄ (c.Set b).Dec                 ⍝ c← b-1
                      :Case '>'    ⋄ (c.Set b).Inc                 ⍝ c← b+1
                      :Case '≢'    ⋄ res← (c.Set b).StrLen         ⍝ int← ≢⌷b
                      :Case '⍎'    ⋄ res← (c.Set b).IntApl         ⍝ int← b.IntApl
                      :Case '⎕VFI' ⋄ res← c.VFI b                  ⍝ Like (bits ints)← ⎕VFI b. 
                      :Case '⌷'    ⋄ res← (c.Set b).Bits           ⍝ str← b.Bits, for a gmpz, string, or APL integer b
                      :Case '⊤'    ⋄ res← gmpz.Get b               ⍝ retrieve value of b as a STRING
                      :Case '⊥'    ⋄ c.Set b                       ⍝ return a copy of b. b any int/ mpz type. 
                    :Else ⋄ ⎕SIGNAL unknownÊ
                    :EndSelect
                :Else
                ⍝   DYADIC
                    :Select nm
                      :Case '+'   ⋄ a c.Add b                      ⍝ c← a + b
                      :Case '-'   ⋄ a c.Sub b
                      :Case '×'   ⋄ a c.Mul b
                      :Case '÷'   ⋄ a c.Div b                      ⍝ c← a÷b.  floored; 0 divisor → divZÊ
                      :Case '*'   ⋄ a c.Pow b                      ⍝ a^n.  n may be ÷m, where m is an integer, like ⍺*0.5 in std Apl.
                      :Case '∨'   ⋄ a c.Gcd b                      ⍝ mpz← a∨b
                      :Case '∧'   ⋄ a c.Lcm b                      ⍝ mpz← a∧b
                      :Case '|'   ⋄ a c.Res b                      ⍝ a is the modulus (APL int), b the value
                      :Case '<'   ⋄ res← a c.Lt b                  ⍝ c← a< b. comparisons return boolean 0/1 directly
                      :Case '≤'   ⋄ res← a c.Le b
                      :Case '='   ⋄ res← a c.Eq b
                      :Case '≠'   ⋄ res← a c.Ne b
                      :Case '≥'   ⋄ res← a c.Ge b
                      :Case '>'   ⋄ res← a c.Gt b
                      :Case '⌷'   ⋄ res← (c.Set b).Bit[a]          ⍝ bool← b.Bit [a]
                      :Case '≢'   ⋄ res← ≢a gmpz.Get b             ⍝ Get length of b in base a 
                      :Case '⌽'   ⋄ a c.Shift b                    ⍝ binary shift: a is the shift amount (APL int) L or R
                    ⍝ ⊤GI and ⊥GI: Comparable to APL counterparts
                      :Case '⊤'   ⋄ res← a gmpz.Get b              ⍝ retrieve value of b as a STRING in base a.
                      :Case '⊥'   ⋄ a c.Set b                      ⍝ return copy of INT STRING b, which is in base a.  
                      :Case '⍳'   ⋄ res← a c.Iota b                ⍝ a⍳b, where b∊ 0 1
                    ⍝ Take b[1]| a*b[0]) efficiently.
                      :Case '*∘|' ⋄ a c.PowM b                     ⍝ mpz← mod| a*exp given (exp mod)←b .
                    ⍝ Returns 2 args:
                      :Case '÷∘|' ⋄ res← c, a c.DivRem b           ⍝ mpz1 mpz2← (a÷b) (b|a).
                    :Else ⋄ ⎕SIGNAL unknownÊ
                    :EndSelect
                :EndIf
                :If res≡c     
                    res← ⎕NEW gmpz c
                :EndIf 
            ∇
          :Field Public Shared tempGI← ⎕NEW gmpz                   ⍝ FOr use in GI only
            tempGI.⎕DF 'GI tmp mpz #0'
            ##.⎕FX '\bgmpz\b' ⎕R (⍕⎕THIS)⊢⎕NR 'GI'                 ⍝ Be sure GI refers to this gmpz
            ⎕← 'Created class ',(⍕⎕THIS),', operator ',(⍕⎕THIS),'.GI'
            
        :EndClass
