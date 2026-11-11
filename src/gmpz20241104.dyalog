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

⍝ Usage:
⍝    gi← ⎕NEW gmpInt [(initial_value)]
⍝  The default initial value is '0' (never undefined until the memory is released).
⍝
⍝  To release the memory allocated, execute: ⎕EX 'gi' or let the object go out of scope.
⍝
:Class gmpz                                                    ⍝ MPZ: GMP's multiple precision integer
   
   ⎕IO ⎕ML ⎕PP ⎕FR← 0 1 34 1287 
   DEBUG← 0 
   
   DmxSig←     ⎕SIGNAL { ⊂⎕DMX.('EN' EN ⋄ 'Message' Message) }
⍝  Convert errors into local variables...
   LoadErrs← { ⎕VSET (↑⊃¨ ⍵)({⊂('EN' ⋄  ⊃⍵)('Message'  ⋄  ⊃⌽⍵)}∘(1↓⊢)¨⍵)}
   errors← (
      'initLogicÊ'  911  'The library attempted to reinitialize an initialized mpz integer'
      'noGmpÊ'       22  'GMP library not found'
      'gmpLoadÊ'     11  'Error loading Gmp library routine(s)' 
      'badInitÊ'     11  'Unable to create object' 
      'badAplÊ'      11  'Invalid APL Integer'
      'badObjÊ'      11  'Can''t convert object to a Gmp integer'
      'badUIntÊ'     11  'Value not an APL non-negative integer'
      'divZÊ'        11  'Division by 0'
      'randÊ'        11  'Arg must be positive'
      'powÊ'         11  'Invalid power: neither an integer nor the inverse of one'
      'shiftÊ'       11  'Shift value must be an integer'
      'badIntÊ'      11  'Number too large to fit into a 64-bit integer (decimal float)'
      'facNegÊ'      11  'Factorial of a negative integer'
      'primeÊ'       11  'ProbabPrime requires nreps of tests in opt''l left arg, usu. 15-50'
      'unknownÊ'     11  'Unknown error'
   )
   LoadErrs errors 
   
   ∇ where← LoadLib where; sysLib; clib; info; nm; gm; ret; sig; tbl
      :If 3= where.⎕NC'Clear' ⋄ :Return ⋄ :EndIf               ⍝ clear is bound last
      where.⎕DF 'gmpInt [gmp library]'
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
         ⍝ Handle null string termination using 0C1[]
            'Init' where.⎕NA sysLib,'|__gmpz_init P'
            ok← 1 ⋄ :Leave  
         :EndTrap
      :EndFor
      ⎕SIGNAL noGmpÊ/⍨ ~ok 
      
      :For clib :In ('/usr/lib/libc.dylib' 'libc.so.6' 'msvcrt.dll')
         :Trap 0
            'Calloc'   where.⎕NA 'P ',clib,'|calloc U8 U8'
            'Free'     where.⎕NA clib,'|free P'
            'MemCpyI'  where.⎕NA clib,'|memcpy >I4[2] P U8'
            :Leave
         :EndTrap
      :EndFor
      :If ~3= where.⎕NC 'Free' ⋄  ⎕SIGNAL noGmpÊ ⋄ :EndIf
      
   ⍝ Note that long ints and unsigns are I8 and U8 on Unix and Linux.
   ⍝ These are in general forced to be I8 and U8 on Microsoft as well,
   ⍝ but weird things are known to happen.
      mpzTable← (
      ⍝      APL name    gmpz_ suffix   return type       args
         'Abs'         'abs'            ''            'P P'
         'Add'         'add'            ''            'P P P'
         'AddU'        'add_ui'         ''            'P P U8'
         'Cmp'         'cmp'            'I4'          'P P'
         'CmpI'        'cmp_si'         'I4'          'P I8'
         'Div'         'tdiv_q'         ''            'P P P'  ⍝ Truncated division
         'Divisible'   'divisible_p'    'I4'          'P P'
         'DivU'        'tdiv_q_ui'      ''            'P P U8'
         'Fac'         'fac_ui'         ''            'P U8'
         'FRem'        'fdiv_r'         ''            'P P P'  ⍝ Floored remainder
         'FRemU'       'fdiv_r_ui'      ''            'P P U8' ⍝ ditto
         'Gcd'         'gcd'            ''            'P P P'
         'GcdU'        'gcd_ui'         ''            'P P U8'
         'GetStr'      'get_str'        ''            '=0C[] I4 P' ⍝ Handle null termination automat.
         'Init'        'init'           ''            'P'      ⍝ To zero (void)
         'InitSet'     'init_set'       ''            'P P'    ⍝ From mpz (void)
         'InitSetI'    'init_set_si'    ''            'P I8'   ⍝ From signed int (void)
         'Int'         'get_si'         'I8'          'P'
         'IntFits'     'fits_slong_p'   'I8'          'P' 
         'Lcm'         'lcm'            ''            'P P P'
         'LcmU'        'lcm_ui'         ''            'P P U8'
         'Mul'         'mul'            ''            'P P P'
         'MulU'        'mul_ui'         ''            'P P U8'
         'Neg'         'neg'            ''            'P P' 
         'NextPrime'   'nextprime'      ''            'P P'
         'Pow'         'pow_ui'         ''            'P P U8'
         'PrevPrime'   'prevprime'      'I4'          'P P'    ⍝ 2 definitely, 1 probably, 0 none
         'ProbabPrime' 'probab_prime_p' 'I4'          'P I4'   ⍝ 2 definitely, 1 probably, 0 not
         'Rem'         'tdiv_r'         ''            'P P P'  ⍝ Truncated remainder
         'Root'        'root'           'I4'          'P P U8' ⍝ nonzero return ⇒ exact
         'Set'         'set'            ''            'P P'          
         'SetI'        'set_si'         ''            'P I8'
         'SetStr'      'set_str'        'I4'          'P <0C1[] I4'  ⍝ Handle null termination automat.
         'ShiftL'      'mul_2exp'       ''            'P P U8' ⍝ Shift left by n bits
         'ShiftR'      'tdiv_q_2exp'    ''            'P P U8' ⍝ Shift right by n bits
         'SizeInBase'  'sizeinbase'     'U8'          'P I4'
         'Sqrt'        'sqrt'           ''            'P P'    ⍝ Truncated root
         'Sub'         'sub'            ''            'P P P'
         'SubU'        'sub_ui'         ''            'P P U8'
         'TstBit'      'tstbit'         'I4'          'P I8'   ⍝ Look at the actual bits of an mpz (big integer)
         'Clear'       'clear'          ''            'P'      ⍝ Must stay last: LoadLib's "loaded" test
      )   
   ⍝ These traps are ignored in a ⎕FIX or ]Load, but not when LoadLib called directly
      :Trap 6 11 102                      
         :For (nm gm ret sig) :In mpzTable
            nm where.⎕NA ret,' ',sysLib, info← '|__gmpz_',gm,' ',sig
         ⍝ ⎕← ' ',(18↑'''',nm,''''),' ⎕NA ''',(4↑ret),' [LIB]',info,''''
         :EndFor
      :Else 
         ⎕← 'Error loading Gmp library routine: '
         ⎕← '   ',nm,' ⎕NA ',info 
         ⎕SIGNAL gmpLoadÊ
      :EndTrap 
   ∇
   
   ∆THIS← ⎕THIS                                                ⍝ The class "name"
   ∆TRAP← 0 'E' 'DmxSig⍬'
   :Field Shared   gNs←   LoadLib ()  
   :Field Instance ⍙ptr← 0                                     ⍝ address of the gmpz_t; 0 = nothing live
   
   ⍝:Section Object Initialization and Value Setting    
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
         base ⎕THIS.Set obj                                    ⍝ string int or APL int or mpz int, base 10
      ∇
      ∇ Init1 obj; ⎕TRAP
        :Access Public  
         :Implements Constructor
         ⎕TRAP← ∆TRAP 
         ⍙InitObj 
         10 ⎕THIS.Set obj                                      ⍝ string int or APL int or mpz int, base 10
      ∇  
      ∇  ⍙InitObj  ; err
         err← 0  
         :Trap 0                                               ⍝ Capture problems so we can free storage!
            ⍙ptr← gNs.Calloc 2 8                               ⍝ mpz_t is 16 bytes on 64-bit
            :If ⍙ptr=0                                         ⍝ calloc failed
               ⎕SIGNAL badInitÊ   
            :Else                                              ⍝ ⎕NULL means just initialize without a value (i.e. with 0)
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
      
      ∇ gi← New0 ; ⎕TRAP
        :Access Public Shared 
         ⎕TRAP← ∆TRAP 
         gi← ⎕NEW ⎕THIS   
      ∇
      ∇ gi← {base} New init ; ⎕TRAP
        :Access Public Shared 
         ⎕TRAP← ∆TRAP 
         :If 900⌶⍬ ⋄ base← 10 ⋄ :EndIf 
         gi← ⎕NEW ∆THIS (init base)
      ∇ 
      
   ⍝ Set ⎕THIS from object Obj. User can access safely.
      ∇ {mpz}← {base} Set b   ; bP; ⎕TRAP
        :Access Public Instance  
         ⎕TRAP← ∆TRAP 
         :If 900⌶⍬ ⋄ base← 10 ⋄ :EndIf 
      ⍝ obj: Can be set from gmpz obj, string, or number
         :If b≡ ⎕THIS 
            :Return                                            ⍝  Setting self to self. Just return!
         :ElseIf IsMpz b                                       ⍝ mpz 
            :If ⍙ptr≠ bP← b.ptr ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf                                  
         :ElseIf 0=1↑0⍴ b                                      ⍝ signed int 
            {}gNs.SetI ⍙ptr b 
         :Else  
            b← '-'@('¯'∘=),b   
            rc← gNs.SetStr ⍙ptr b base                         ⍝ SetStr will handle invalid numeric strings.
            ⎕SIGNAL (rc≠0)/ badObjÊ                                   
         :EndIf        
         mpz← ⎕THIS 
      ∇
      ∇ Free 
         :Implements Destructor
         :If DEBUG ⋄ ⎕← 'Free ',⎕THIS  ⋄ :EndIf 
         {}gNs.Clear ⍙ptr ⋄ {}gNs.Free ⍙ptr  
      ∇
   ⍝:EndSection Object Initialization and Value Setting    
   
   ⍝:Section Getting Object Components 
      
   ⍝  Allow user access to the string form of the mpz.
   ⍝  If a is a gmpz object in APL, then
   ⍝     ⌷a
   ⍝  is the string representation.
      :Property Simple Default Component 
      ⍝  Retrieve the gmpz integer as a string of any length!
         ∇ buf← get ; n
            ⎕SIGNAL (⍙ptr=0)/ badObjÊ                          ⍝ Whoops! Nothing there.
            n← 2+ gNs.SizeInBase ⍙ptr 10                       ⍝ digits + possible sign + NUL
         ⍝ Create a place in APL for the null-terminated string. from GetStr
            buf← gNs.GetStr (n⍴⎕UCS 0) 10 ⍙ptr                 ⍝ Import that result
         ∇ 
      :EndProperty
      ∇ p← ptr 
        :Access Public
         p← ⍙ptr 
      ∇
   ⍝ Show: shows ptr and string at <ptr> location.
      ∇ s← Show 
        :Access Public
         :If ⍙ptr=0 ⋄ ⎕SIGNAL 11 ⋄ :EndIf 
         s← 'ptr=',(⍕⍙ptr),'  val=', val 
      ∇
   ⍝:EndSection Getting Object Components 
   
   ⍝:Section Types 
      IsMpz←  { 9.2≠ ⎕NC ⊂,'⍵': 0 ⋄ ∆THIS⊂∘,⍛∊  ⎕CLASS ⍵ }
      IsUI←   { 0≠ ⊃0⍴⍵:  0 ⋄ (⍵=⌊⍵)∧ ⍵≥ 0  }
      IsInt←  { 0≠ ⊃0⍴⍵: 0 ⋄ ⍵=⌊⍵ }
      Case_T← { IsMpz ⍵: mpz_T ⋄ 0≠ ⊃0⍴⍵: str_t ⋄ ⍵≠ ⌊⍵: ⎕SIGNAL badAplÊ ⋄ si_T ui_T⊃⍨ ⍵≥ 0 }
      mpz_T ui_T si_T str_t← 3 2.5 2 0                         ⍝ si_T - a signed int that is <0 
   ⍝:EndSection Types 
   
   ⍝:Section  aStatic, bStatic: Global mpz's used in _Dyad_  and elsewhere
      aStatic← ⎕NEW ⎕THIS 
      bStatic← ⎕NEW ⎕THIS 
      
   ⍝  aPtr, bPtr-- these use the std arguments (a and b) and copy any
   ⍝  non-mpz objects (integers, strings) into aStatic and return aStatic.ptr
   ⍝  Actual mpz objects ¨a¨ are kept as is (not copied); a.ptr is returned.
      ∇ p← aPtr 
         p← (aStatic.Set⍣( ~IsMpz a)⊢ a).ptr 
      ∇ 
      ∇ p← bPtr 
         p← (bStatic.Set⍣( ~IsMpz b)⊢ b).ptr 
      ∇ 
   ⍝:EndSection  aStatic, bStatic: Global mpz's used in _Dyad_ and elsewhere
   
   ⍝:Section Support Operators 
   ⍝  _Dyad_: a 2-operand operator for use with common functions
      ∇ mpz← {nzFlag} (fn1 _Dyad_ fn2) (a b) ; bP; ⎕TRAP
      ⍝ Execute  this← a <fn> b, in the form
      ⍝      fnX this a b
      ⍝ where fnX is fn1 EXCEPT where b is an unsigned int, where fn2 is called.
      ⍝  The object a or b may be this →→ Gmp handles.
      ⍝ While Gmp allows for uints on the left (a) in some csaes, we just convert (a) to a gmpz obj
      ⍝ no matter what.
         ⎕TRAP← ∆TRAP 
         :If 900⌶⍬ ⋄ nzFlag← 0 ⋄ :EndIf                        ⍝ Must b be non-zero, no matter the type?
         :Select Case_T b 
           :Case mpz_T                                         ⍝ b is an mpz obj
            :If nzFlag∧ 0= b.Signum ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf  
            {} fn1 ⍙ptr aPtr b.ptr                             ⍝ ==>  fn1  <==
           :Case ui_T                                          ⍝ b is an unsigned APL integer
            :If nzFlag∧ 0= b ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf    
            {} fn2 ⍙ptr aPtr b                                 ⍝ ==>  fn2  <== 
         :Else                                                 ⍝ b is a str or neg int                          
            :If nzFlag ∧ 0= PSignum bP← bPtr ⋄ ⎕SIGNAL divZÊ ⋄ :EndIf  
            {} fn1 ⍙ptr aPtr bP                                ⍝ ==>  fn1  <== 
         :EndSelect    
         mpz← ⎕THIS 
      ∇ 
   ⍝:EndSection Support Operators  
   
   ⍝ :Section Methods - Signum
   ⍝  Signum Really fast (but in the weeds) way to get the sign from an mpz int.
      ∇ si← Signum   
        :Access Public 
         si← PSignum ⍙ptr  
      ∇ 
   ⍝ Signum when you already have a pointer
      ∇ si← PSignum ptr  ; CopyIVec
         CopyIVec← { gNs.MemCpyI (⍵⍴ 0) ⍺ (4× ⍵) }             ⍝ Get the sign of the variable at offset 4 (one 4-byte integer's worth)                                 
         si← ×1⌷ ptr CopyIVec 2   
      ∇ 
   ⍝:EndSection Methods - Signum  
   
   ⍝:Section Dyadic - Arithmetic 
   ⍝  ⍵:Add a b   →→   ⍵← a + b
      ∇ {mpz}← {a} Add b; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP 
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf 
         mpz← gNs.Add _Dyad_ gNs.AddU⊢ a b
      ∇ 
   ⍝  ⍵.Sub a b  →→  ⍵← a + b
      ∇ {mpz}← {a} Sub b; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP 
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf 
         mpz← gNs.Sub _Dyad_ gNs.SubU a b
      ∇ 
   ⍝  ⍵.Mul a b   →→   ⍵← a × b
      ∇ {mpz}← {a} Mul b; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP 
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf 
         mpz← gNs.Mul _Dyad_ gNs.MulU a b 
      ∇
   ⍝  ⍵.Div a b   →→  ⍵← a ÷ b
      ∇ {mpz}← {a} Div b; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP   
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf 
         mpz← 1 gNs.Div _Dyad_ gNs.DivU a b                    ⍝ ⍺ of 1: Ensure b≠0 
      ∇ 
      ∇ {mpz}← {a} Gcd b  ; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf 
         mpz←  gNs.Gcd _Dyad_ gNs.GcdU a b 
      ∇  
      ∇ {mpz}← {a} Lcm b  ; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP
         :If 900⌶⍬ ⋄ a← ⎕THIS ⋄  :EndIf 
         mpz←  gNs.Lcm _Dyad_ gNs.LcmU  a b 
      ∇   
   ⍝  a Pow exp: Both 10*3 (power) and 10*÷3 (root)
      ∇ {mpz}← {a} Pow exp; aP; inv; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP 
         :If 900⌶⍬ ⋄ aP← ⍙ptr ⋄ :Else ⋄ aP← aPtr ⋄ :EndIf 
         :If 0≠ ⊃0⍴ exp ⋄ :Orif exp< 0 
            ⎕SIGNAL powÊ  
         :ElseIf exp= ⌊exp 
            {}gNs.Pow ⍙ptr aP exp                              ⍝ exp is a non-negative integer.
         ⍝ Integral Inverse: Do root.  ⍵ must be (nearly) ÷ an integer, e.g. ÷3, not 0.4
         :ElseIf  (1E¯9≥ |1- exp× inv)∨ (¯1≠ PSignum aP)∧ 0≠2| inv← ⌊0.5+ ÷exp 
            {}gNs.Root ⍙ptr aP inv  
         :Else 
            ⎕SIGNAL powÊ
         :EndIf 
         mpz← ⎕THIS 
      ∇  
      
   ⍝ The Res residue/modulo is in the APL order using APL's rules.
   ⍝ APL's ⍺|⍵: ⍺ is the divisor, result is floored (sign of ⍺); 0|⍵ is ⍵
   ⍝ * In APL, when the left argument (divisor) is 0, the residue/modulo function is
   ⍝   defined to return the right argument unchanged.
      ∇ {mpz}← modulus Res b; a; bP; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP 
         ⎕SIGNAL shiftÊ/⍨ 0≠ ⊃0⍴ modulus
         bP← bPtr 
         :Select ×modulus 
           :Case 1 
            :If modulus= 2
               {}Set gNs.TstBit bP 0                           ⍝ Fast...
            :Else  
               {}gNs.FRemU ⍙ptr bP modulus                     ⍝ pos (unsigned) modulus passed as is
            :EndIf 
           :Case ¯1 
            {}gNs.FRem  ⍙ptr bPtr aPtr⊣ a← modulus             ⍝ neg modulus must be an mpz 
         :Else
            :If ⍙ptr≠ bP ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf          ⍝ No need to copy over oneself
         :EndSelect  
         mpz← ⎕THIS  
      ∇    
   ⍝:EndSection Dyadic - Arithmetic 
   
   ⍝:Section Dyadic - BinaryShift
   ⍝  new← ⍵.Shift i  →→ Shift's ⍵ left (⍵>0) or right (⍵<0) base 2, i.e. ⍵←  ⍺ ×2*i
      ∇ {mpz}← howMuch Shift b; bP; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP 
         ⎕SIGNAL shiftÊ/⍨ 0≠ ⊃0⍴ howMuch 
         bP← bPtr   
         :Select ×howMuch 
           :Case  1 ⋄ {}gNs.ShiftL ⍙ptr bP howMuch             ⍝ left shift: a multiplication by 2*howMuch
           :Case ¯1 ⋄ {}gNs.ShiftR ⍙ptr bP (-howMuch)          ⍝ right shift: a division by 2*howMuch
         :Else      
            :If ⍙ptr≠ bP ⋄ {}gNs.Set ⍙ptr bP ⋄ :EndIf          ⍝ Return mpz as is 
         :EndIf 
         mpz← ⎕THIS  
      ∇ 
   ⍝:EndSection Dyadic - Shift 
   
   ⍝:Section Monadic - Arithmetic
      ∇ {mpz}← Neg b; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP 
         {} gNs.Neg  ⍙ptr bPtr 
         mpz← ⎕THIS 
      ∇
      ∇ {mpz}← Abs b; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP 
         {} gNs.Abs ⍙ptr bPtr  
         mpz← ⎕THIS 
      ∇
   ⍝  bool← ⍵.Divisible b  -- Is ⍵ divisible by b, any kind of number?
   ⍝  Unlike standard division functions which throw exceptions or crash on zero,
   ⍝  mpz_divisible_p explicitly accepts d = 0. Following mathematical rules, only 0 is considered divisible by 0
      ∇ {bool}← Divisible b; bZ; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP 
         bool← gNs.Divisible ⍙ptr bPtr  
      ∇
   ⍝:EndSection Monadic - Arithmetic
   
   ⍝:Section (Pseudo-)Monadic - Factorial
      ∇ {mpz}← Fac num; ⎕TRAP
        :Access Public 
         ⎕TRAP← ∆TRAP 
         :If IsMpz num 
            num← num.Int                                       ⍝ Issues its own error, if needed!
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
   
   ⍝:Section Monadic - Comparison
   ⍝  ⍵.Cmp b    -   rc← × (⍵ - b)
      ∇ rc← {a} Cmp b   ; aP
        :Access Public 
         :If 900⌶⍬ ⋄ aP← ⍙ptr                                  ⍝ ⎕THIS.ptr
         :Else     ⋄ aP← aPtr     
         :EndIf 
         :If IsInt b 
            rc← gNs.CmpI aP b 
         :Else 
            rc← gNs.Cmp aP bPtr  
         :EndIf 
      ∇ 
      ∇ rc← {a} Lt b   ; aP
        :Access Public 
         :If 900⌶⍬ ⋄ aP← ⍙ptr                                  ⍝ ⎕THIS.ptr
         :Else     ⋄ aP← aPtr     
         :EndIf 
         rc← (a Cmp b) < 0 
      ∇ 
      ∇ rc← {a} Le b   ; aP
        :Access Public 
         :If 900⌶⍬ ⋄ aP← ⍙ptr                                  ⍝ ⎕THIS.ptr
         :Else     ⋄ aP← aPtr     
         :EndIf 
         rc← (a Cmp b) ≤ 0 
      ∇ 
      ∇ rc← {a} Eq b   ; aP
        :Access Public 
         :If 900⌶⍬ ⋄ aP← ⍙ptr                                  ⍝ ⎕THIS.ptr
         :Else     ⋄ aP← aPtr     
         :EndIf 
         rc← (a Cmp b) = 0 
      ∇ 
      ∇ rc← {a} Ge b   ; aP
        :Access Public 
         :If 900⌶⍬ ⋄ aP← ⍙ptr                                  ⍝ ⎕THIS.ptr
         :Else     ⋄ aP← aPtr     
         :EndIf 
         rc← (a Cmp b) ≥ 0 
      ∇ 
      ∇ rc← {a} Gt b   ; aP
        :Access Public 
         :If 900⌶⍬ ⋄ aP← ⍙ptr                                  ⍝ ⎕THIS.ptr
         :Else     ⋄ aP← aPtr     
         :EndIf 
         rc← (a Cmp b) > 0 
      ∇ 
   ⍝:EndSection Monadic - Comparison
   
   ⍝:Section Monadic - Rand 
   ⍝   Rand:  Rand ⍵
   ⍝   Generate a random number between 0 and ⍵-1, where ⍵ is a positive big-integer or int.
   ⍝   (Done in APL)
   ⍝ When ⎕FR ← 1287 (128-bit Decimal Floating-Point),
   ⍝ the maximum integer argument to ? roll is ( ¯1+ 2*63 ), i.e. a 64-bit signed integer.
   ⍝ We round down to to one less decimal digit:  randWid=18, randMax=10*18.
      
      randMax randWid← { w← ¯1+≢⍕¯1+2*63 ⋄ (10*w) w } 0 
      
   ⍝ Method: rejection sampling, base 10*randWid.  ⍵ is split into k chunks ("digits"), d.
   ⍝   k=1:  ?d directly, no rejection.
   ⍝   k>1:  top chunk r ← ?t+1 (0..t, t=top chunk of ⍵; t≥1 so acceptance ≥ ½).
   ⍝         lower chunks q are always drawn free over 0..randMax-1.
   ⍝         r<t:  any q is fine.     r=t:  accept iff q <(lexicographically) the lower chunks of ⍵.
   ⍝   Every x<⍵ then has probability 1÷((t+1)×randMax*k-1) per trial ⇒ exactly uniform.
   ⍝   NB: the lower chunks must NOT be drawn from their own bounds (?t₁+1 …): that breaks uniformity.
   ⍝  ⍵.Rand a
      ∇ {mpz}← Rand b   ; str; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP 
         :Select ⌊Case_T b
           :Case mpz_T ⋄ str← ⌷b  
           :Case si_T  ⋄ str← ⍕b 
           :Case str_t ⋄ str← ⍙PSI b  
         :Else ⋄ ⎕SIGNAL badObjÊ
         :EndSelect 
         ⎕SIGNAL randÊ/⍨ str⊃⍛∊ '-0'                           ⍝ Rand only handles positive integers.
         mpz← ⎕THIS.Set ⍙Rand str  
      ∇ 
   ⍝ ⍙PSI ⍵: Returns a non-negative integer string from ⍵
      ⍙PSI← {                                                     
         w↓⍨← +/∧\'0'=w← ⍵~' '
        0= ≢w: '0' ⋄ ∧/w∊ ⎕D: w ⋄ ⎕SIGNAL badObjÊ                      
      }
      ⍙Rand← { ⎕FR← 1287                                       ⍝ Needed for 34 digit arithmetic
         k← ⌈randWid÷⍨ ≢s← ,⍵
         d← 10⊥⍉ (k,randWid)⍴ (-k×randWid)↑ ⎕D⍳s               ⍝ bound as k base-10*18 "digits" (left-padded with 0s)
        k= 1: ⍕?⊃d                                             ⍝ single chunk: ? gives [0,N) directly
         t← ⊃d ⋄ e← 1↓d
         gen← {
            r← ?t+ 1 ⋄ q← ?(k- 1)⍴ randMax
           r< t: r, q                                          ⍝ top chunk below bound: lower part is free
            j← (q≠ e)⍳ 1                                       ⍝ tie on top: first differing lower chunk (≢q if none)
           j⊃ (q< e),0: r, q ⋄ ∇ ⍬                             ⍝ lower < bound: accept; ≥ (incl. equal): retry
         }
         r← { ⍵↓⍨+/∧\'0'=⍵} ∊(1↓ ⍕)¨ randMax+ gen ⍬            ⍝ zero-pad each chunk via 1+10*18 trick, strip leading 0s
         r,⍨ '0'/⍨ 0= ≢r                                       ⍝ all zeros → '0'
      }  
   ⍝:EndSection Monadic - Rand 
   
   ⍝:Section Niladic - Arithmetic 
   ⍝  ⍵.Inc - Increments ⍵ by 1
      ∇ {mpz}← Inc   ; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP 
         {}gNs.AddU ⍙ptr ⍙ptr 1
         mpz← ⎕THIS 
      ∇ 
   ⍝  ⍵.Dec - Decrements ⍵ by 1
      ∇ {mpz}← Dec     ; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP 
         {}gNs.SubU ⍙ptr ⍙ptr 1
         mpz← ⎕THIS 
      ∇ 
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
   
   ⍝:Section Niladic - Export
   ⍝  int← ⍵.Int   - Returns ⍵ in APL 64-bit integer (i.e. decimal float) form, if it fits!
      ∇ int← Int   ; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP 
         ⎕SIGNAL badIntÊ/⍨ ~gNs.IntFits ⍙ptr 
         int← gNs.Int ⍙ptr 
      ∇ 
   ⍝ rc int← ⍵.VFI;  If ⍵ fits into an APL dec float format, returns (1 int), int as above, else returns (0 0).
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
   
   ⍝:Section Prime Numbers
   ⍝  rc← [cycles← 24] ProbabPrime b
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
         :If 900⌶⍬ ⋄  cycles← 24 ⋄  :EndIf                     ⍝  usu. 15 - 50
         ⎕SIGNAL primeÊ/⍨  ~IsUI cycles 
         rc← gNs.ProbabPrime bPtr cycles    
      ∇          
   ⍝  NextPrime ⍵: Returns the next pseudoprime after ⍵
      ∇ {mpz}← NextPrime b    ; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP 
         {}gNs.NextPrime ⍙ptr bPtr  
         mpz← ⎕THIS 
      ∇   
   ⍝  PrevPrime:  mpz← ⍺.PrevPrime ⍵
   ⍝  Returns the pseudoprime previous to ⍵.
   ⍝  Note: libG.PrevPrime itself also returns rc:
   ⍝     Certain: rc=2; Likely: rc=1; None: 0.
   ⍝  See also PrevPrime2
      ∇ {mpz}← PrevPrime b  ; bZ; rc; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP 
         {}rc← gNs.PrevPrime ⍙ptr bPtr                         ⍝ rc is ignored here.
         mpz← ⎕THIS 
      ∇ 
   ⍝  PrevPrime2:  (mpz rc)← ⍺.PrevPrime2 ⍵
   ⍝  Like PrevPrime, but returns the pseudo-prime and the likelihood of primality.
      ∇ {mpz_rc}← PrevPrime2 b ; ⎕TRAP
        :Access Public  
         ⎕TRAP← ∆TRAP 
         {}rc← gNs.PrevPrime ⍙ptr bPtr  
         mpz_rc← ⎕THIS rc  
      ∇   
   ⍝:EndSection Prime Numbers
   
   ∇ res← {a}(fn GI)b
        ; c; monad; n; nm; rc
        ; CmpOp
        ; ⎕TRAP; ⎕IO; ⎕ML
      
      ⎕IO ⎕ML← 0 1    
      DmxSig← ⎕SIGNAL{⊂⎕DMX.('EN' EN ⋄ 'Message' Message)}
      unknownÊ← ⊂('EN' 11 ⋄ 'Message' 'Unknown operand')
      ⎕TRAP← 0 'E' 'DmxSig⍬'
      nm← ⍬⍴,⎕NR'fn'                                           ⍝ the primitive glyph of the operand
      c← ⎕NEW gmpz 0                                           ⍝ fresh result object; freed on exit
      
      :If 900⌶⍬ 
         :Select nm
           :Case '-' ⋄ c.Neg b
           :Case '|' ⋄ c.Abs b
           :Case '?' ⋄ c.Rand b
           :Case '×' ⋄ res← (c.Set b).Signum ⋄ :Return
           :Case '!' ⋄ c.Fac b
           :Case '<' ⋄ (c.Set b).Dec                           ⍝ Decrement
           :Case '>' ⋄ (c.Set b).Inc                           ⍝ Increment 
         :Else ⋄ ⎕SIGNAL unknownÊ
         :EndSelect
      :Else
         :Select nm
           :Case '+' ⋄ a c.Add b
           :Case '-' ⋄ a c.Sub b
           :Case '×' ⋄ a c.Mul b
           :Case '÷' ⋄ a c.Div b                               ⍝ truncating; 0 divisor → divZÊ
           :Case '*' ⋄ a c.Pow b                               ⍝ b: n or ÷n (root)
           :Case '∨' ⋄ a c.Gcd b
           :Case '∧' ⋄ a c.Lcm b
           :Case '|' ⋄ a c.Res b                               ⍝ a is the modulus (APL int), b the value
           :Case '⌽' ⋄ a c.Shift b                             ⍝ a is the shift (APL int), b the value
           :Case '<' ⋄ res← a c.Lt b ⋄ :Return  
           :Case '≤' ⋄ res← a c.Le b ⋄ :Return 
           :Case '=' ⋄ res← a c.Eq b ⋄ :Return  
           :Case '≥' ⋄ res← a c.Ge b ⋄ :Return 
           :Case '>' ⋄ res← a c.Gt b ⋄ :Return 
         :Else ⋄ ⎕SIGNAL unknownÊ
         :EndSelect
      :EndIf
      res← c                                                   ⍝ mpz object unless a special opcode like < ≤ etc.
   ∇                                  
    #.⎕FX '\bgmpz\b' ⎕R (⍕⎕THIS)⊢⎕NR 'GI'                    ⍝ Be sure GI refers to this gmpz

   ⎕DF 'Created: gmpz, GI'
:EndClass
