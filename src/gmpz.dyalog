⍝ ═══════════════════════════════════════════════════════════════════════════════
⍝  gmpz — Arbitrary-precision integers for Dyalog APL, backed by GMP (libgmp)
⍝ ═══════════════════════════════════════════════════════════════════════════════
⍝
⍝  OVERVIEW
⍝    Each gmpz instance wraps one GMP `mpz_t`, allocated with malloc and
⍝    manipulated through ⎕NA bindings to libgmp. Values can be created from
⍝    and exported to APL integers or decimal strings of any length.
⍝
⍝  REQUIREMENTS
⍝    ∘ Dyalog APL v20 (64-bit) and the GMP shared library (libgmp, version 10).
⍝      LoadLib searches the usual macOS / Linux / Windows locations.
⍝    ∘ The class sets  ⎕IO ⎕ML ⎕PP ⎕FR ← 0 1 34 1287  (decimal floats, so APL
⍝      integers up to 2*63 are exact).
⍝
⍝  QUICK START
⍝      a← ⎕NEW gmpz '12345678901234567890'                    ⍝ from a string
⍝      b← ⎕NEW gmpz 2                                         ⍝ from an APL integer
⍝      c← ⎕NEW gmpz                                           ⍝ defaults to 0
⍝      d← gmpz.New '99999999999999999999'                     ⍝ shared factory (optional base on left)
⍝      16 gmpz.New 'ff'                                       ⍝ → 255
⍝
⍝      ⌷a                                                     ⍝ string form (default property)
⍝      c.Set 5                                                ⍝ overwrite c with 5 (c← 5)
⍝
⍝  OPERATING MODEL (read this first)
⍝    ∘ Methods such as Add, Sub, Mul, … are IN-PLACE: the object receiving the
⍝      call is overwritten with the result, and the method returns that same
⍝      object (shy). So   c.Add b   means   c ← c + b ,
⍝      and                a c.Add b means   c ← a + b  (c is only the destination).
⍝    ∘ Operands (a, b) may each be any of:
⍝         – a gmpz object                (used directly, never copied)
⍝         – an APL integer               (negative or non-negative)
⍝         – a character string           ('¯' is accepted as a minus sign)
⍝    ∘ Non-gmpz operands are copied into two hidden scratch objects (aStatic,
⍝      bStatic) so GMP can use them. Never rely on the scratch objects' values.
⍝    ∘ The monadic/dyadic operator GI (bottom of file) wraps these methods so
⍝      they read like APL primitives and do NOT disturb their arguments.
⍝
⍝  SEMANTICS / CONVENTIONS
⍝      Div        truncates toward zero          (mpz_tdiv_q)
⍝      Rem        [Remainder] Matches Div; sign follows the dividend (mpz_tdiv_r);
⍝                  not exposed as a method here, but bound in the library table
⍝      Res        [Residue] APL's a|b, (modulus c.Res b)  is FLOORED. The sign follows
⍝                 the modulus (mpz_fdiv_r), and 0 Res b is b, as in APL.
⍝      Pow        a c.Pow n  → a*n  (n a non-negative integer)
⍝                 a c.Pow ÷n → floor of the true n-th root (truncated)
⍝      Shift      n c.Shift b : left for n>0, right (truncating toward zero) for n<0
⍝                 This is equiv. to  b× 2*n.
⍝      Fac        factorial of non-negative integer only.
⍝      Rand       uniform on 0 … ⍵-1.
⍝                 This is calculated in APL, so it interplays with ⎕RL.
⍝
⍝  ERRORS
⍝    All public methods trap errors and re-signal them from the caller's
⍝    perspective via DmxSig (so ⎕DMX shows the user's line, not class internals).
⍝    See the `errors` table below for the names, codes and messages.
⍝
⍝  MEMORY
⍝    The destructor clears and frees the mpz when the object goes out of scope,
⍝    or explicitly via  ⎕EX 'a'.  Set DEBUG← 1 (default 0) to trace allocations and frees.
⍝
⍝  FILE LAYOUT
⍝    1. Error table              5. aStatic / bStatic scratch objects
⍝    2. LoadLib (GMP / libc)     6. _Dyad_ helper operator
⍝    3. Construction / Set       7. Arithmetic, shift, comparison, Rand, primes
⍝    4. Value access (⌷, ptr)    8. GI operator (primitive-style wrapper)
⍝
⍝  NOTES FOR MAINTAINERS
⍝    ∘ Names ending in Ê are error-signal tables loaded by LoadErrs.
⍝    ∘ Names starting with ⍙ are private helpers.
⍝    ∘ Library entries in gNs (Add, AddU, …) are raw GMP calls; the "U" variants
⍝      take an unsigned 64-bit APL integer instead of an mpz.
⍝    ∘ ⎕FR←1287 is used, since it allows handling of (64-bit) pointers and
⍝      U8 and I8 (64-bit unsigned and signed integers).
⍝
⍝ ═══════════════════════════════════════════════════════════════════════════════
:Class gmpz                                                   ⍝ MPZ: GMP's multiple precision integer
   
   ⎕IO ⎕ML ⎕PP ⎕FR← 0 1 34 1287                               ⍝ Class-wide settings (see header)
   DEBUG← 1                                                   ⍝ 1: print Alloc/Free messages and set display forms

⍝ ═══════════════════════════════════════════════════════════════════════════════
⍝ Class randState - for handling Random Numbers. See also Rand and RandSeed
⍝ ═══════════════════════════════════════════════════════════════════════════════
:Class randState
   ⍝ Call:    rs← ⎕NEW randState 
   ⍝ WHen rs goes out of scope, the storage is released
     :Field Public Instance  r⍙ptr← 0 
     :Field Shared           DEBUG← 0 
     :Field Public Shared    active←0
     :Field Public Shared    seeds← (?1E18) 0
     ∇ Init0
        :Access Public
         :Implements Constructor
         :Trap 0 
             r⍙ptr← gNs.Malloc 64 
             :IF 0= r⍙ptr 
                ⎕SIGNAL randStateÊ 
             :EndIf 
               {}gNs.RandInitDef r⍙ptr  
               {}gNs.RandSeedU   r⍙ptr (⊃seeds)          ⍝ Seed from APL random # 
              :If DEBUG ⋄ ⎕← 'Alloc randState [',(⍕r⍙ptr),']'  ⋄ :EndIf
          :Else
            :IF 0≠ r⍙ptr 
               {}gNs.RandClear r⍙ptr 
               {}gNs.Free r⍙ptr 
               :If DEBUG ⋄ ⎕← 'Free   randState [',(⍕r⍙ptr),']'  ⋄ :EndIf
            :EndIf 
            ##.DmxSig
          :EndTrap  
          active← 1 
      ∇
      ∇ Free
         :Implements Destructor
         :If DEBUG ⋄ ⎕← 'Free   randState [',(⍕r⍙ptr),']'  ⋄ :EndIf
         :IF 0≠ r⍙ptr 
            {}gNs.RandClear r⍙ptr 
            {}gNs.Free r⍙ptr                   ⍝ {}gNs.Free ⍙ptr
            ⍙ptr← 0 
         :EndIf 
      ∇
      :Property Simple Default Component
      ⍝  ⌷rs:  Retrieve the randstate variable rs's pointer!
         ∇ ptr← get ; badObjÊ
            badObjÊ← ⊂('EM' 11 ⋄ 'Message' 'Invalid random state variable')
            ⎕SIGNAL badObjÊ/⍨ r⍙ptr=0                         ⍝ Whoops! Nothing there.
            ptr← r⍙ptr 
         ∇
      :EndProperty
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
   LoadErrs← { ⎕VSET (↑⊃¨ ⍵)({⊂('EN' ⋄  ⊃⍵)('Message'  ⋄  ⊃⌽⍵)}∘(1↓⊢)¨⍵)}
⍝             name           EN   Message
   errors← (
      'initLogicÊ'  911  'The library attempted to reinitialize an initialized mpz integer'
      'noGmpÊ'       22  'GMP library not found'
      'gmpLoadÊ'     11  'Error loading Gmp library routine(s)'
      'badInitÊ'     11  'Unable to create object'
      'badAplÊ'      11  'Invalid APL Integer'
      'badObjÊ'      11  'Can''t convert object to a Gmp integer'
      'badUIntÊ'     11  'Value not an APL non-negative integer'
      'divZÊ'        11  'Division by 0'
      'randStateÊ'   11  'Unable to initialise random # state'
      'randSeedÊ'    11  'Object cannot be converted to an unsigned integer' 
      'randÊ'        11  'Arg must be positive'
      'powÊ'         11  'Invalid power: neither an integer nor the inverse of one'
      'shiftÊ'       11  'Shift value must be an integer'
      'badIntÊ'      11  'Number too large to fit into a 64-bit integer (decimal float)'
      'facNegÊ'      11  'Factorial of a negative integer'
      'primeÊ'       11  'ProbabPrime requires nreps of tests in opt''l left arg, usu. 15-50'
      'unknownÊ'     11  'Unknown error'
   )
   LoadErrs errors
   
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  LoadLib: locate libgmp and libc, and bind every needed routine into a namespace
⍝
⍝    Arg/Result  where   the namespace (here gNs, a :Field Shared) that receives
⍝                        the ⎕NA-bound functions.
⍝    Behavior:
⍝      1. If `Clear` (the last binding) already exists, return.
⍝      2. Probe a list of likely libgmp paths until one binds `Init`.
⍝      3. Bind malloc / free / memcpy from libc (used to allocate mpz_t and to
⍝         peek at the sign field — see PSignum).
⍝      4. Bind each row of mpzTable as
⍝               apl_name gNs.⎕NA '<return_type> <sysLib>|__gmpz_<gmpz_name> <signature>'
⍝         The <return_type> is omitted if (c-language) void.
⍝         The <signature> is in APL ⎕NA format, using pointers (P) and various integers.
⍝    Errors: Signals noGmpÊ if no library (or libc) is found; gmpLoadÊ if a routine
⍝            cannot be bound (the offending entry is echoed to the session).
⍝ ───────────────────────────────────────────────────────────────────────────────
   ∇ where← LoadLib where; sysLib; clib; info; errs;  nm; ok; pfx; gm; ret; sig; tbl
      :If 0≠  where.⎕NC 'loadComplete'⋄ :Return ⋄ :EndIf              ⍝ clear is bound last
      where.⎕DF 'gmpInt [gmp library]'
      :For sysLib :In (
            '/opt/homebrew/opt/gmp/lib/libgmp.dylib'          ⍝ macOS, Apple silicon (Homebrew)
            '/usr/local/opt/gmp/lib/libgmp.dylib'             ⍝ macOS, Intel (Homebrew)
            'libgmp.dylib'
            'libgmp.10.dylib'
            'libgmp.so.10'                                    ⍝ Linux, via the loader path
            '/usr/lib/x86_64-linux-gnu/libgmp.so.10'
            '/usr/lib/aarch64-linux-gnu/libgmp.so.10'
            '/usr/lib64/libgmp.so.10'
            'libgmp-10.dll'                                   ⍝ Windows
         )
         :Trap 0
         ⍝ Handle null string termination using 0C1[]
            'Init' where.⎕NA sysLib,'|__gmpz_init P'          ⍝ Probe: does this path load?
            ok← 1 ⋄ :Leave
         :EndTrap
      :EndFor
      ⎕SIGNAL noGmpÊ/⍨ ~ok
      
      :For clib :In ('/usr/lib/libc.dylib' 'libc.so.6' 'msvcrt.dll')
         :Trap 0
         ⍝   'Calloc'   where.⎕NA 'P ',clib,'|calloc U8 U8'     ⍝ calloc(count, size) → pointer
            'Malloc'   where.⎕NA 'P ',clib,'|malloc U8'       ⍝ malloc(count) → pointer
            'Free'     where.⎕NA clib,'|free P'
            'MemCpyI'  where.⎕NA clib,'|memcpy >I4[2] P U8'   ⍝ copy N bytes out as 2 ints (used for the sign)
            :Leave
         :EndTrap
      :EndFor
      :If ~3= where.⎕NC 'Free' ⋄  ⎕SIGNAL noGmpÊ ⋄ :EndIf
      
   ⍝ Note that long ints and unsigns are I8 and U8 on Unix and Linux.
   ⍝ These are in general forced to be I8 and U8 on Microsoft as well,
   ⍝ but weird things are known to happen.
   ⍝
   ⍝ Binding table. Each row: APL name, GMP name (after __gmpz_), return type, arg types.
   ⍝   P = pointer (to an mpz_t)     U8 / I8 = 64-bit unsigned / signed int
   ⍝   I4 = 32-bit int               '' return = void (result left in the first mpz arg)
   ⍝ A trailing "U" in an APL name means the last operand is an unsigned machine int.
      mpzTable← (
      ⍝      APL name    gmpz_ suffix   return type       args
         'Abs'         'abs'            ''            'P P'
         'Add'         'add'            ''            'P P P'
         'AddU'        'add_ui'         ''            'P P U8'
         'Clear'       'clear'          ''            'P'        
         'Cmp'         'cmp'            'I4'          'P P'   ⍝ <0, 0, >0
         'CmpI'        'cmp_si'         'I4'          'P I8'  ⍝ compare to a signed machine int
         'CmpAbs'      'cmpabs'         'I4'          'P P'   ⍝ compare absolute values
         'UiPow'       'ui_pow_ui'      ''            'P U8 U8' ⍝ rop ← base*exp (both unsigned ints)
         'Div'         'tdiv_q'         ''            'P P P' ⍝ Truncated division
         'Divisible'   'divisible_p'    'I4'          'P P'
         'DivU'        'tdiv_q_ui'      ''            'P P U8'
         'Fac'         'fac_ui'         ''            'P U8'
         'FRem'        'fdiv_r'         ''            'P P P' ⍝ Floored remainder
         'FRemU'       'fdiv_r_ui'      ''            'P P U8' ⍝ ditto
         'Gcd'         'gcd'            ''            'P P P'
         'GcdU'        'gcd_ui'         ''            'P P U8'
         'GetStr'      'get_str'        ''            '=0C[] I4 P'  ⍝ Handle null termination automat.
         'Init'        'init'           ''            'P'     ⍝ To zero (void)
         'InitSet'     'init_set'       ''            'P P'   ⍝ From mpz (void)
         'InitSetI'    'init_set_si'    ''            'P I8'  ⍝ From signed int (void)
         'Int'         'get_si'         'I8'          'P'
         'IntFits'     'fits_slong_p'   'I8'          'P'
         'Lcm'         'lcm'            ''            'P P P'
         'LcmU'        'lcm_ui'         ''            'P P U8'
         'Mul'         'mul'            ''            'P P P'
         'MulU'        'mul_ui'         ''            'P P U8'
         'Neg'         'neg'            ''            'P P'
         'NextPrime'   'nextprime'      ''            'P P'
         'Pow'         'pow_ui'         ''            'P P U8'
         'PrevPrime'   'prevprime'      'I4'          'P P'   ⍝ 2 definitely, 1 probably, 0 none
         'ProbabPrime' 'probab_prime_p' 'I4'          'P I4'  ⍝ 2 definitely, 1 probably, 0 not
         'Rem'         'tdiv_r'         ''            'P P P' ⍝ Truncated remainder
         'Root'        'root'           'I4'          'P P U8' ⍝ nonzero return ⇒ exact
         'Set'         'set'            ''            'P P'
         'SetI'        'set_si'         ''            'P I8'
         'SetStr'      'set_str'        'I4'          'P <0C1[] I4'   ⍝ Handle null termination automat.
         'ShiftL'      'mul_2exp'       ''            'P P U8' ⍝ Shift left by n bits
         'ShiftR'      'tdiv_q_2exp'    ''            'P P U8' ⍝ Shift right by n bits
         'SizeInBase'  'sizeinbase'     'U8'          'P I4'
         'Sqrt'        'sqrt'           ''            'P P'   ⍝ Truncated root
         'Sub'         'sub'            ''            'P P P'
         'SubU'        'sub_ui'         ''            'P P U8'
         'TstBit'      'tstbit'         'I4'          'P I8'  ⍝ Look at the actual bits of an mpz (big integer)

 ⍝   gmp calls-- handled specially
         'RandInitDef' 'gmp_randinit_default' ''      'P'     ⍝ gmp: the default-- Mersenne
         'RandSeedU'   'gmp_randseed_ui' ''           'P U8'  ⍝ gmp: seed state with unsigned int
         'RandClear'   'gmp_randclear'  ''            'P'     ⍝ gmp:
         'URandomM'    'urandomm'       ''            'P P P' ⍝ mpz: random # < the ceiling 
      )
   ⍝ These traps are ignored in a ⎕FIX or ]Load, but not when LoadLib called directly
      errs← 0 
      :Trap 6 11 102
         :For (nm gm ret sig) :In mpzTable
            pfx← 'gmpz_'/⍨ 'gmp_'≢4↑gm 
            nm where.⎕NA ret,' ',sysLib, info← '|__', pfx, gm,' ',sig
            :IF 0  ⍝ DEBUG
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
   
   ∆THIS← ⎕THIS                                               ⍝ The class "name" (used for ⎕NEW and class tests)
   ∆TRAP← 0 'E' 'DmxSig⍬'                                     ⍝ Standard ⎕TRAP for public methods: re-signal at caller
   :Field Shared   gNs←   LoadLib ()                          ⍝ Namespace holding all bound GMP and libc routines
   :Field Shared   rsInstance←  ⎕NULL 
   :Field Instance ⍙ptr← 0                                    ⍝ address of the gmpz_t; 0 = nothing live
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Object Initialization and Value Setting
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  Constructors:
   ⍝     ⎕NEW gmpz                 → value 0
   ⍝     ⎕NEW gmpz  obj            → value of obj (gmpz, string, or APL integer), base 10
   ⍝     ⎕NEW gmpz (obj base)      → string obj parsed in base 2…62
      ∇ Init0
        :Access Public
         :Implements Constructor
         ⍙InitObj
      ∇
      ∇ Init2 (obj base); ⎕TRAP
        :Access Public
         :Implements Constructor
         ⎕TRAP← ∆TRAP
         ⍙InitObj
         base ⎕THIS.Set obj                                   ⍝ string int or APL int or mpz int, base 10
      ∇
      ∇ Init1 obj; ⎕TRAP
        :Access Public
         :Implements Constructor
         ⎕TRAP← ∆TRAP
         ⍙InitObj
         10 ⎕THIS.Set obj                                     ⍝ string int or APL int or mpz int, base 10
      ∇
   ⍝  ⍙InitObj (private): allocate 16 zeroed bytes for the mpz_t and mpz_init it.
   ⍝  If anything fails after malloc, the memory is released before badInitÊ is signalled.
   ⍝  We separate the initialisation and set so that we can ensure any system memory allocated
   ⍝  is freed, no matter what error occurs.
      ∇  ⍙InitObj; err
         err← 0
         :Trap 0                                              ⍝ Capture problems so we can free storage!
            ⍙ptr← gNs.Malloc 16                               ⍝ mpz_t is 16 bytes on 64-bit
            :If ⍙ptr=0                                        ⍝ Allocation failed
               ⎕SIGNAL badInitÊ
            :Else                                             ⍝ ⎕NULL means just initialize without a value (i.e. with 0)
               {}gNs.Init ⍙ptr
            :EndIf
         :Else
            err← 1
         :EndTrap
         :If err
            :If ×⍙ptr ⋄ {}gNs.Clear ⍙ptr ⋄ :EndIf
            {}gNs.Free ⍙ptr ⋄ ⍙ptr← 0
            ⎕SIGNAL badInitÊ
         :EndIf
         :If DEBUG
            ⎕DF 'gmpz [ptr: ',']',⍨ ⍕⍙ptr
            ⎕← 'Alloc',⎕THIS
         :EndIf
      ∇
      
   ⍝  New0:  gi← gmpz.New0           — new object with value 0   (shared method)
      ∇ gi← New0 ; ⎕TRAP
        :Access Public Shared
         ⎕TRAP← ∆TRAP
         gi← ⎕NEW ⎕THIS
      ∇
   ⍝  New:   gi← [base] gmpz.New init   — new object from init (shared method)
   ⍝         base defaults to 10 and only matters when init is a string.
      ∇ gi← {base} New init ; ⎕TRAP
        :Access Public Shared
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ base← 10 ⋄ :EndIf
         gi← ⎕NEW ∆THIS (init base)
      ∇
      
   ⍝ Set: overwrite ⎕THIS with a new value.    [base] obj.Set b
   ⍝   b may be a gmpz, an APL integer, or a string ('¯' is read as '-').
   ⍝   base (default 10) applies only to strings; GMP accepts 2…62.
   ⍝   Returns ⎕THIS (shy), so calls can be chained: (x.Set 5).Inc
   ⍝   Errors: badObjÊ if the string is not a valid integer in that base.
      ∇ {mpz}← {base} Set b   ; bP; rc; ⎕TRAP
        :Access Public Instance
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ base← 10 ⋄ :EndIf
      ⍝ obj: Can be set from gmpz obj, string, or number
         :If b≡ ⎕THIS
            :Return                                           ⍝  Setting self to self. Just return!
         :ElseIf IsMpz b                                      ⍝ mpz
            :If ⍙ptr≠ bP← b.ptr ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf
         :ElseIf 0=1↑0⍴ b                                     ⍝ signed int
            {}gNs.SetI ⍙ptr b
         :Else
            b← '-'@('¯'∘=),b
            rc← gNs.SetStr ⍙ptr b base                        ⍝ SetStr will handle invalid numeric strings.
            ⎕SIGNAL (rc≠0)/ badObjÊ
         :EndIf
         mpz← ⎕THIS
      ∇
   ⍝ Destructor: runs automatically when the object is expunged or goes out of scope.
      ∇ Free
         :Implements Destructor
         :If DEBUG ⋄ ⎕← 'Free ',⎕THIS  ⋄ :EndIf
         {}gNs.Clear ⍙ptr ⋄ {}gNs.Free ⍙ptr                   ⍝ {}gNs.Free ⍙ptr
      ∇
   ⍝:EndSection Object Initialization and Value Setting
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Getting Object Components
   ⍝ ───────────────────────────────────────────────────────────────────────────────
      
   ⍝  Allow user access to the string form of the mpz.
   ⍝  If a is a gmpz object in APL, then
   ⍝     ⌷a
   ⍝  is the string representation (decimal, with '-' for negatives).
      :Property Simple Default Component
      ⍝  Retrieve the gmpz integer as a string of any length!
         ∇ buf← get ; n
            ⎕SIGNAL (⍙ptr=0)/ badObjÊ                         ⍝ Whoops! Nothing there.
            n← 2+ gNs.SizeInBase ⍙ptr 10                      ⍝ digits + possible sign + NUL
         ⍝ Create a place in APL for the null-terminated string. from GetStr
            buf← gNs.GetStr (n⍴⎕UCS 0) 10 ⍙ptr                ⍝ Import that result
         ∇
      :EndProperty
   ⍝ ptr: the address of the underlying mpz_t (0 if released). Mainly for internal use.
      ∇ p← ptr
        :Access Public
         p← ⍙ptr
      ∇
   ⍝:EndSection Getting Object Components
   
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section Types
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  IsMpz ⍵   1 if ⍵ is an instance of this class (gmpz), else 0
   ⍝  IsUI  ⍵   1 if ⍵ is an APL non-negative integer (numeric), else 0. Doesn't rule out ALL floats that are near to ⌊⍵.
   ⍝  IsInt ⍵   1 if ⍵ is an APL integer of any sign (numeric), else 0
   ⍝  Case_T ⍵  classify an operand, returning one of the codes below.
   ⍝            Signals badAplÊ for a non-integer number.
      IsMpz←  { 9.2≠ ⎕NC ⊂,'⍵': 0 ⋄ ∆THIS⊂∘,⍛∊  ⎕CLASS ⍵ }
      IsUI←   { 2≠ ⎕NC '⍵': 0 ⋄ 0≠ ⊃0⍴⍵:  0 ⋄ (⍵=⌊⍵) ∧ ⍵≥ 0 }  ⍝ Explicitly reject gmpz's by rejecting non-variables 
      IsInt←  { 2≠ ⎕NC '⍵': 0 ⋄ 0≠ ⊃0⍴⍵: 0 ⋄ ⍵=⌊⍵ }            ⍝ ... avoiding ⊃0⍴⍵, which builds/discards a prototype.
      Case_T← { 
        IsMpz ⍵: mpz_T ⋄ 0≠ ⊃0⍴⍵: str_t ⋄ ⍵≠ ⌊⍵: ⎕SIGNAL badAplÊ ⋄ si_T ui_T⊃⍨ ⍵≥ 0 
      }
   ⍝  Type codes:  mpz_T=3 (gmpz object)      ui_T=2.5 (APL integer ≥ 0)
   ⍝                si_T=2 (APL integer < 0)  str_t=0 (string)
      mpz_T ui_T si_T str_t← 3 2.5 2 0                        ⍝ si_T - a signed int that is <0
   ⍝:EndSection Types
   
⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝:Section  aStatic, bStatic: Global mpz's used in _Dyad_  and elsewhere
   ⍝ ───────────────────────────────────────────────────────────────────────────────
   ⍝  Two scratch mpz's shared by all instances. They hold non-gmpz operands
   ⍝  (strings, negative or large APL integers) only for the duration of a call.
   ⍝  Consequence: this class is not thread-safe, and the scratch values are
   ⍝  meaningless between calls.
   ⍝  Note: To make the class thread-safe,
   ⍝        remove the comment symbol preceding :HOLD and :ENDHOLD below.
      ∇ ok← InitStatics 
         statics← ⎕NEW¨ ⎕THIS ⎕THIS 
         ∆STATICS← 'statics'
         
      ⍝  (Ptr0 a) and (Ptr1 b)-- these use the std arguments (a and b) and copy any
      ⍝  non-mpz objects (integers, strings) into statics[0] and return statics[0].ptr
      ⍝  Actual mpz objects ¨a¨ are kept as is (not copied); a.ptr is returned.
         StatPtr← { IsMpz ⍵: ⍵.ptr ⋄ (statics[⍺].Set ⍵).ptr }
         Ptr0← 0∘StatPtr 
         Ptr1← 1∘StatPtr
         ok← 1
      ∇
      InitStatics 
   ⍝:EndSection  aStatic, bStatic: Global mpz's used in _Dyad_ and elsewhere
   
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
   ⍝    Dispatch on the type of b:
   ⍝      gmpz object        → fn1 with b's pointer
   ⍝      APL integer ≥ 0    → fn2 with b passed directly (fast path)
   ⍝      string / APL < 0   → b is copied into bStatic, then fn1
   ⍝    `a` is always passed through (Ptr0 a) (converted to an mpz when necessary).
   ⍝    Returns ⎕THIS.
      ∇ mpz← {nzFlag} (fn1 _Dyad_ fn2) (a b) ; bP; ⎕TRAP
      ⍝ Execute  this← a <fn> b, in the form
      ⍝      fnX this a b
      ⍝ where fnX is fn1 EXCEPT where b is an unsigned int, where fn2 is called.
      ⍝  The object a or b may be this →→ Gmp handles.
      ⍝ While Gmp allows for uints on the left (a) in some cases, we just convert (a) to a gmpz obj
      ⍝ no matter what (this can be changed with additional coding).
         ⎕TRAP← ∆TRAP
      ⍝:HOLD ∆STATICS
         :If 900⌶⍬ ⋄ nzFlag← 0 ⋄ :EndIf                       ⍝ Must b be non-zero, no matter the type?
         :Select Case_T b
           :Case mpz_T                                        ⍝ b is an mpz obj
            :If nzFlag∧ 0= b.Signum ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf
            {} fn1 ⍙ptr (Ptr0 a) b.ptr                        ⍝ ==>  fn1  <==
           :Case ui_T                                         ⍝ b is an unsigned APL integer
            :If nzFlag∧ 0= b ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf
            {} fn2 ⍙ptr (Ptr0 a) b                            ⍝ ==>  fn2  <==
         :Else                                                ⍝ b is a str or neg int
            :If nzFlag ∧ 0= PSignum bP← Ptr1 b ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf
            {} fn1 ⍙ptr (Ptr0 a) bP                           ⍝ ==>  fn1  <==
         :EndSelect
         mpz← ⎕THIS
      ⍝:EndHold 
   ∇
⍝:EndSection Support Operators

⍝ ───────────────────────────────────────────────────────────────────────────────
⍝ :Section Methods - Signum
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  Signum: ¯1, 0 or 1. A fast (but in the weeds) way to get the sign from an mpz int.
⍝  It reads the `_mp_size` field of the mpz_t directly (its sign is the integer's sign)
⍝  rather than calling into GMP. If this makes you nervous, use the gNs.Cmp call
⍝  as shown in [Alt] comment in PSignum.
   ∇ si← Signum
     :Access Public
      si← PSignum ⍙ptr           
   ∇
⍝ PSignum ptr: Signum when you already have a pointer to an mpz_t.
   ∇ si← PSignum ptr  ; CopyIVec
   ⍝  [Alt]  si← gNs.CmpI ptr 0   ⍝ Replaces two lines here.
      CopyIVec← { gNs.MemCpyI (⍵⍴ 0) ⍺ (4× ⍵) }               ⍝ Get the sign of the variable at offset 4 (one 4-byte integer's worth)
      si← ×1⌷ ptr CopyIVec 2
   ∇
⍝:EndSection Methods - Signum

⍝ ───────────────────────────────────────────────────────────────────────────────
⍝:Section Dyadic - Arithmetic
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  Common calling forms for the methods in this section (mpz = the receiver):
⍝        mpz.Op b      mpz ← mpz Op b      (left operand defaults to ⎕THIS)
⍝      a mpz.Op b      mpz ← a Op b        (mpz is only the destination)
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
⍝  mpz.Div b / a mpz.Div b   →→   mpz← ⌈ or ⌊ toward 0 of a ÷ b  (truncated quotient)
⍝  Errors: divZÊ if b is 0.
   ∇ {mpz}← {a} Div b; ⎕TRAP
     :Access Public
      ⎕TRAP← ∆TRAP
      :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf
      mpz← 1 gNs.Div _Dyad_ gNs.DivU a b                      ⍝ ⍺ of 1: Ensure b≠0
   ∇
⍝  mpz.Gcd b / a mpz.Gcd b   →→   mpz← a∨b   (greatest common divisor, ≥ 0)
   ∇ {mpz}← {a} Gcd b  ; ⎕TRAP
     :Access Public
      ⎕TRAP← ∆TRAP
      :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf
      mpz←  gNs.Gcd _Dyad_ gNs.GcdU a b
   ∇
⍝  mpz.Lcm b / a mpz.Lcm b   →→   mpz← a∧b   (least common multiple, ≥ 0)
   ∇ {mpz}← {a} Lcm b  ; ⎕TRAP
     :Access Public
      ⎕TRAP← ∆TRAP
      :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf
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
   ⍝:HOLD ∆STATICS
      :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← Ptr0 a ⋄ :EndIf
      :If 0≠ ⊃0⍴ exp ⋄ :Orif exp< 0
         ⎕SIGNAL powÊ
      :ElseIf exp= ⌊exp
         {}gNs.Pow ⍙ptr aP exp                                ⍝ exp is a non-negative integer.
      ⍝ Integral Inverse: Do root.  ⍵ must be (nearly) ÷ an integer, e.g. ÷3,
      ⍝ and if the left operand is negative, ⍵ must be an odd number.
      :ElseIf (1E¯9≥ |1- exp× inv)∧ (¯1≠ PSignum aP) ∨ 0≠2| inv← ⌊0.5+ ÷exp
         {}gNs.Root ⍙ptr aP inv
      :Else
         ⎕SIGNAL powÊ
      :EndIf
      mpz← ⎕THIS
   ⍝:EndHold 
∇

⍝ modulus mpz.Res b   →→   mpz← modulus | b
⍝ The Res residue/modulo is in the APL order using APL's rules.
⍝ APL's ⍺|⍵: ⍺ is the divisor, result is floored (sign of ⍺); 0|⍵ is ⍵
⍝ * In APL, when the left argument (divisor) is 0, the residue/modulo function is
⍝   defined to return the right argument unchanged.
⍝ Special case: if the modulus is the (unsigned) integer 2, we uses a fast bit test.
∇ {mpz}← modulus Res b; a; aP; bP; ⎕TRAP
  :Access Public
   ⎕TRAP← ∆TRAP
⍝:HOLD ∆STATICS
   bP← Ptr1 b
   :If IsUI modulus  
      :Select modulus
        :Case 0 ⋄ :If ⍙ptr≠ bP ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf   ⍝ 0|b is b
        :Case 2 ⋄ {}Set gNs.TstBit bP 0                       ⍝ fast bit test
      :Else ⋄ {}gNs.FRemU ⍙ptr bP modulus
      :EndSelect
   :Else
      a← modulus ⋄ aP← Ptr0 a
      :If 0= PSignum aP                                       ⍝ zero gmpz or string modulus
         :If ⍙ptr≠ bP ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf
      :Else
         {}gNs.FRem ⍙ptr bP aP
      :EndIf
   :EndIf
⍝:EndHold 
mpz← ⎕THIS
∇
⍝:EndSection Dyadic - Arithmetic

⍝ ───────────────────────────────────────────────────────────────────────────────
⍝:Section Dyadic - BinaryShift
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  mpz← i mpz.Shift b  →→  mpz← b × 2*i
⍝    i > 0  shift left  (multiply by 2*i)
⍝    i < 0  shift right (divide by 2*|i|, truncating toward zero)
⍝    i = 0  copy b unchanged
⍝    i must be an APL integer (else shiftÊ).
∇ {mpz}← howMuch Shift b; bP; ⎕TRAP
:Access Public
⎕TRAP← ∆TRAP
⎕SIGNAL shiftÊ/⍨ 0≠ ⊃0⍴ howMuch
bP← Ptr1 b
:Select ×howMuch
  :Case  1 ⋄ {}gNs.ShiftL ⍙ptr bP howMuch                     ⍝ left shift: a multiplication by 2*howMuch
  :Case ¯1 ⋄ {}gNs.ShiftR ⍙ptr bP (-howMuch)                  ⍝ right shift: a division by 2*howMuch
:Else
   :If ⍙ptr≠ bP ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf                  ⍝ Return mpz as is
:EndIf
mpz← ⎕THIS
∇
⍝:EndSection Dyadic - Shift

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
∇ {bool}← Divisible b; bZ; ⎕TRAP
:Access Public
⎕TRAP← ∆TRAP
bool← gNs.Divisible ⍙ptr (Ptr1 b)
∇
⍝:EndSection Monadic - Arithmetic

⍝ ───────────────────────────────────────────────────────────────────────────────
⍝:Section (Pseudo-)Monadic - Factorial
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  mpz.Fac n   →→   mpz← !n
⍝    n may be an APL integer, an integer string, or a gmpz that fits in a
⍝    64-bit integer. Large factorials are limited only by memory.
⍝    Errors: badIntÊ  (not an integer, or too big to convert)
⍝            facNegÊ  (n < 0)
∇ {mpz}← Fac num; ok; ⎕TRAP
:Access Public
⎕TRAP← ∆TRAP
:If IsMpz num
   num← num.Int                                               ⍝ Issues its own error, if needed!
:ElseIf ' '=⊃0⍴num
   ok num← ⎕VFI num
   ⎕SIGNAL badIntÊ/⍨ (~ok)∨ '.'∊ ⍕num
:EndIf
:If (~3 7∊⍨ 80|⎕DR num )
   ⎕SIGNAL badIntÊ
:ElseIf num<0
   ⎕SIGNAL facNegÊ
:EndIf
{} gNs.Fac ⍙ptr num
mpz← ⎕THIS
∇
⍝:EndSection (Pseudo-)Monadic - Factorial

⍝ ───────────────────────────────────────────────────────────────────────────────
⍝:Section Comparison Functions: Cmp, Lt, Le, Eq, Ne, Ge, Gt 
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  rc← [a] x.Cmp b     — three-way compare:  rc← × (a - b)  →  ¯1, 0 or 1
⍝  Monadic use compares ⎕THIS with b.  Dyadic use compares a with b.
⍝  If b is an APL integer, the faster signed-int compare is used.
⍝  The wrappers below return 0/1 and take the same arguments:
⍝     Lt (<)   Le (≤)   Eq (=)   Ge (≥)   Gt (>)  Ne (≠)
∇ rc← {a} Cmp b   ; aP
:Access Public
⍝:HOLD ∆STATICS
:If 900⌶⍬ ⋄ aP← ⍙ptr                                          ⍝ ⎕THIS.ptr
:Else     ⋄ aP← Ptr0 a
:EndIf
:If IsInt b
   rc← gNs.CmpI aP b
:Else
   rc← gNs.Cmp aP (Ptr1 b)
:EndIf
⍝:EndHold 
∇
⍝  a Lt b  →  a<b
∇ rc← {a} Lt b   
:Access Public
:If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
rc← (a Cmp b) < 0
∇
⍝  a Le b  →  a≤b
∇ rc← {a} Le b   
:Access Public
:If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
rc← (a Cmp b) ≤ 0
∇
⍝  a Eq b  →  a=b
∇ rc← {a} Eq b    
:Access Public
:If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
rc← (a Cmp b) = 0
∇
⍝  a Ne b  →  a≠b
∇ rc← {a} Ne b    
:Access Public
:If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
rc← (a Cmp b) ≠ 0
∇
⍝  a Ge b  →  a≥b
∇ rc← {a} Ge b    
:Access Public
:If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
rc← (a Cmp b) ≥ 0
∇
⍝  a Gt b  →  a>b
∇ rc← {a} Gt b    
:Access Public
:If 900⌶⍬ ⋄ a← ⎕THIS ⋄ :EndIf
rc← (a Cmp b) > 0
∇
⍝:EndSection Comparison Functions: Cmp, Lt, Le, Eq, Ne, Ge, Gt 

⍝ ───────────────────────────────────────────────────────────────────────────────
⍝:Section Monadic - Rand, RandSeed
⍝ ───────────────────────────────────────────────────────────────────────────────

⍝ mpz← Rand b
⍝ Takes b, a valid mpz, integer, or integer string, and returns a random number in range 0 ≤ rand < b.
⍝ Uses GMP's randstate state variable, which is allocated on first use of Rand or RandSeed.
⍝ Very fast. 
⍝ Unless RandSeed is called, the random # is seeded from Dyalog APL with a random integer.
⍝ See (RandSeed ui)
⍝⍝⍝ NOTE: This can be used as a template for implementing other random # distributions (see GMP).
⍝
∇ {mpz}← Rand b   ; str; ⎕TRAP
   :Access Public
    ⎕TRAP← ∆TRAP 
  :IF ~randState.active ⋄ rsInstance← ⎕NEW randState ⋄ :EndIf 
 
   {}gNs.URandomM ⍙ptr (⌷rsInstance) (Ptr0 b)
  ⍝  {}gNs.URandomM ⍙ptr (⌷rsInstance) (Ptr0 b)


   mpz← ⎕THIS 
∇

⍝ RandSeed ui, where u8 is a U8 integer.  Returns the old seed.
⍝ By default, the random seed is ?1E18 (with ⎕FR=1287), i.e. is seeded from a random APL integer.
⍝ If you want predictable sequences (out of a larger range), reset it using RandSeed.
∇ {old}← RandSeed u8  ; ok; ⎕TRAP
  :Access Public
  ⎕TRAP← ∆TRAP 
  :IF ~randState.active ⋄ rsInstance← ⎕NEW randState ⋄ :EndIf 
  u8← gNs.Int∘Ptr1⍣ (~IsUI u8)⊢ u8 
  ⎕SIGNAL randSeedÊ/⍨ ~IsUI u8 
  
   {}gNs.RandSeedU (⌷rsInstance) u8 

   old← ⊃randState.seeds
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
⍝  int← ⍵.Int   - Returns ⍵ in APL 64-bit integer (i.e. decimal float) form, if it fits!
⍝                 Errors: badIntÊ if the value does not fit in a signed 64-bit integer.
∇ int← Int   ; ⎕TRAP
:Access Public
⎕TRAP← ∆TRAP
⎕SIGNAL badIntÊ/⍨ ~gNs.IntFits ⍙ptr
int← gNs.Int ⍙ptr
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
⍝:EndSection Niladic - Export

⍝ ───────────────────────────────────────────────────────────────────────────────
⍝:Section Prime Numbers
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  rc← [cycles← 24] ProbabPrime b      (Shared: call as  gmpz.ProbabPrime b)
⍝      cycles: Reasonable values of reps are between 15 and 50.
⍝  Beware: GMP args are in reverse order
⍝  Return 2 if n is definitely prime,
⍝  return 1 if n is probably prime (without being certain), or
⍝  return 0 if n is definitely non-prime.
⍝  ∘  The Gmp manual suggests values between 15 and 50 are reasonable, and
⍝  says that with 24 reps the chance of a composite slipping through is
⍝  negligible for practical purposes.
∇ rc←  {cycles} ProbabPrime b   ; bZ; ⎕TRAP
:Access Public Shared
⎕TRAP← ∆TRAP
⍝:HOLD ∆STATICS
:If 900⌶⍬ ⋄  cycles← 24 ⋄  :EndIf                             ⍝  usu. 15 - 50
⎕SIGNAL primeÊ/⍨  ~IsUI cycles
rc← gNs.ProbabPrime (Ptr1 b) cycles
⍝:EndHold 
∇
⍝  mpz.NextPrime ⍵: Sets mpz to the next (pseudo)prime greater than ⍵
∇ {mpz}← NextPrime b    ; ⎕TRAP
:Access Public
⎕TRAP← ∆TRAP
⍝:HOLD ∆STATICS
{}gNs.NextPrime ⍙ptr (Ptr1 b)
⍝:EndHold 
mpz← ⎕THIS
∇
⍝  PrevPrime:  mpz← ⍺.PrevPrime ⍵
⍝  Sets mpz to the (pseudo)prime previous to ⍵.
⍝  Note: libG.PrevPrime itself also returns rc:
⍝     Certain: rc=2; Likely: rc=1; None: 0.
⍝  See also PrevPrime2
∇ {mpz}← PrevPrime b  ; bZ; rc; ⎕TRAP
:Access Public
⎕TRAP← ∆TRAP
⍝:HOLD ∆STATICS
{}rc← gNs.PrevPrime ⍙ptr (Ptr1 b)                             ⍝ rc is ignored here.
⍝:EndHold 
mpz← ⎕THIS
∇
⍝  PrevPrime2:  (mpz rc)← ⍺.PrevPrime2 ⍵
⍝  Like PrevPrime, but returns the pseudo-prime and the likelihood of primality.
∇ {mpz_rc}← PrevPrime2 b ; ⎕TRAP
:Access Public
⎕TRAP← ∆TRAP
⍝:HOLD ∆STATICS
mpz_rc← ⎕THIS (gNs.PrevPrime ⍙ptr (Ptr1 b))
⍝:EndHold 
∇
⍝:EndSection Prime Numbers

⍝ ───────────────────────────────────────────────────────────────────────────────
⍝:Section  Miscellany
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝  len← StrLen obj: Returns the number of characters required by the object in APL,
⍝                   including the sign, if any.  Equivalent to ≢⌷x.
⍝  Example:   (bigNum.StrLen ≡ ≢⌷bigNum)                      ⍝ Returns 1 for gmpz objects.
⍝     len← x.StrLen : number of characters ⌷x would have, including a leading '-'.
⍝  Exact, without generating the string.
∇ len← StrLen ; n; v; t; ⎕TRAP
:Access Public
⎕TRAP← ∆TRAP
n← gNs.SizeInBase ⍙ptr 10                                     ⍝ true digit count, or 1 too many
:If n≤ 18                                                     ⍝ always fits an I8: stay in APL
v← gNs.Int ⍙ptr
len← (n- (n>1)∧ (|v)< 10*n-1) + v<0                           ⍝ n=1 is exact (guards 0)
:Else
t← ⎕NEW ∆THIS                                                 ⍝ scratch; freed on exit
{}gNs.UiPow t.ptr 10 (n-1)                                    ⍝ t ← 10*n-1
len← (n- 0> gNs.CmpAbs ⍙ptr t.ptr) + ¯1= PSignum ⍙ptr
:EndIf
∇
⍝ ───────────────────────────────────────────────────────────────────────────────
⍝:EndSection  Miscellany 
⍝ ───────────────────────────────────────────────────────────────────────────────

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
⍝                  a ÷GI b    truncated a÷b     a ⌽GI b   shift b by a bits
⍝                  a *GI b    a*b  (b may be ÷n for an n-th root)
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
⍝
⍝    Result        The new gmpz (use ⌷res for its string form) unless the
⍝                  operation is a comparison or monadic ×, which return a plain
⍝                  integer.
⍝    Errors        unknownÊ for an unsupported glyph; the underlying method's
⍝                  error (divZÊ, powÊ, …) is passed through.
⍝    Notes         ∘ Local ⎕IO ⎕ML, DmxSig and unknownÊ are redefined inside GI
⍝                    so that it still works when copied out of the class.
⍝                  ∘ The line after the ∇ (the #.⎕FX …) makes a copy in # in
⍝                    which the name `gmpz` is replaced by the class's full name,
⍝                    so `GI` can be used from any namespace.
⍝ ───────────────────────────────────────────────────────────────────────────────
∇ res← {a}(fn GI)b
  ; c; monad; n; nm; rc
  ; ⎕TRAP; ⎕IO; ⎕ML

⎕IO ⎕ML← 0 1
DmxSig← ⎕SIGNAL{⊂⎕DMX.('EN' EN ⋄ 'Message' Message)}
unknownÊ← ⊂('EN' 11 ⋄ 'Message' 'Unknown operand')
⎕TRAP← 0 'E' 'DmxSig⍬'
nm← ⍬⍴,⎕NR'fn'                                                ⍝ the primitive glyph of the operand
res← c← ⎕NEW gmpz                                             ⍝ new result obj, freed per gmpz class

:If 900⌶⍬                                                     ⍝ ── monadic ──
:Select nm
:Case '-' ⋄ c.Neg b
:Case '|' ⋄ c.Abs b
:Case '?' ⋄ c.Rand b
:Case '×' ⋄ res← (c.Set b).Signum  
:Case '!' ⋄ c.Fac b
:Case '<' ⋄ (c.Set b).Dec                                     ⍝ Decrement
:Case '>' ⋄ (c.Set b).Inc                                     ⍝ Increment
:Case '≢' ⋄ res← (c.Set b).StrLen          
:Else ⋄ ⎕SIGNAL unknownÊ
:EndSelect
:Else                                                         ⍝ ── dyadic ──
:Select nm
:Case '+' ⋄ a c.Add b
:Case '-' ⋄ a c.Sub b
:Case '×' ⋄ a c.Mul b
:Case '÷' ⋄ a c.Div b                                         ⍝ truncating; 0 divisor → divZÊ
:Case '*' ⋄ a c.Pow b                                         ⍝ b: n or ÷n (root)
:Case '∨' ⋄ a c.Gcd b
:Case '∧' ⋄ a c.Lcm b
:Case '|' ⋄ a c.Res b                                         ⍝ a is the modulus (APL int), b the value
:Case '⌽' ⋄ a c.Shift b                                       ⍝ a is the shift (APL int), b the value
:Case '<' ⋄ res← a c.Lt b                                     ⍝ comparisons return 0/1 directly
:Case '≤' ⋄ res← a c.Le b     
:Case '=' ⋄ res← a c.Eq b  
:Case '≠' ⋄ res← a c.Ne b  
:Case '≥' ⋄ res← a c.Ge b  
:Case '>' ⋄ res← a c.Gt b  
:Else ⋄ ⎕SIGNAL unknownÊ
:EndSelect
:EndIf
∇
##.⎕FX '\bgmpz\b' ⎕R (⍕⎕THIS)⊢⎕NR 'GI'                        ⍝ Be sure GI refers to this gmpz

⎕DF 'Created class ',(⍕##),'.gmpz, operator ',(⍕##),'.GI'

:EndClass
