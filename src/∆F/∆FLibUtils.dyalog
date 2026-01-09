⍝ ∆FLibUtils.dyalog      (UPDATE_TIME: '2026-01-09') 
:Namespace libUtils

⍝ ===================================================================================
⍝ RUN TIME ROUTINES
⍝ ===================================================================================
⍝ This namespace handles Library (£ or `L) shortcut automatic loading...
⍝ ∘ See ⍙FUtils for fn ⍙LoadLibAuto, which loads this library.
⍝ ∘ See "Executive" at bottom of file, which calls
⍝   SetLibFull and LoadParms  
⍝ ∘ Local and External variables pointing to the "user" library userLibrary.
⍝   - userLib  -  the namespace ref itself, by default ⍙FUtils.userLibrary (##.userLibrary)
⍝   - userLibNm-  the name of userLib
⍝ ===================================================================================
⍝ LibAuto: libStr← ê ∇ str 
⍝    str str starts 1 char after '£' or '`L'. 
⍝    ê: namespace with (r/w:) ê.acache; (r/o:) ê.auto; (read in LoadObj:) ê.verbose 
⍝ Returns: userLibNmP, the library name surrounded by parens, no matter what.
⍝ ∘ Used by ∆F's scan process when it sees £ or `L. 
⍝   ∘ Called from the main scan routines CF_SF and CF_Esc. 
⍝   ∘ In turn calls fn LoadObj when a library name, nm, is being referenced 
⍝     (not set) for the first time.
⍝ Task:
⍝ ∘ find the name nm in £.nm...[[∘]←] (first token in a qua.lif.ied name)
⍝   and, if valid and not seen before,
⍝   ∘ If £. is followed by a dotted name nm1.nm2[...], then nm←nm1, the first one;
⍝     That entire namespace is loaded, if found.
⍝   ∘ (via LoadObj) get source code for it from a file or workspace in our path.
⍝ ∘ Does NOT affect the string ⍵ being scanned. 
⍝ ∘ Is only used for its ⎕CY or ⎕FIX side effect via LoadObj. 
⍝ Note: A name may be in the userLibrary w/o having been loaded, e.g. if it's
⍝   in a file with multiple objects (all may be loaded). So we add ANY valid 
⍝   name to the cache, once we see it. (We don't cache invalid names).
  LibNoAuto← {userLibNmP} 
  LibAuto←{      
    ~⍺.auto:                 userLibNmP       ⍝ Not auto: return.
        w← NoLB ⍵                             ⍝     Skip blanks
    '.'≠ ⊃w:                 userLibNmP       ⍝ No initial '.':   return.
        w← NoLB⊢ w← 1↓w                       ⍝     Skip some more blanks,
        nm← w↑⍨ p← NmSpan w                   ⍝     Get the (apparent) name nm and length p.  
    ⍺.acache∊⍨ ⊂nm:          userLibNmP       ⍝ Saw it before:    return.
        ⍺.acache,← ⊂nm                        ⍝     Mark as seen in autocache global (even if invalid)
    0≠ userLib.⎕NC nm:       userLibNmP       ⍝ In libuser (>1) or invalid name (-1):  return. 
    '←'= ⊃'∘ '~⍨ p↓w:        userLibNmP       ⍝ Name to be set:   return.
        _← userLib ⍺ parms LoadObj nm         ⍝ Try to load obj definition
                             userLibNmP       ⍝ Return.                                       
  }
  NoLB← {(∨\' '≠⍵)/⍵}                         ⍝ Fast Idiom. 
  nmSym← { ⍺← ⎕D ⋄ 0=≢⍵: ⍺~'⍺⍵∇' ⋄ ¯1=⎕NC f←⊃⍵: ⍺ ∇ 1↓⍵ ⋄ (⍺,f) ∇ 1↓⍵ } ⎕AV   ⍝ Valid syms in APL user names.
  NmSpan← 0⍳⍨∊∘nmSym
 

  ⍝ ======================================================================================
  ⍝ LoadObj: Find nm in £.nm or `L.nm and try to load its definition into userLib from path.
  ⍝     (1|0)@B← userLib@ns verbose@B parms@ns ∇ nm@CVS 
  ⍝ Find <nm> in search directories (parms.path) and dfns workspace, according to parameters <parms>.
  ⍝ Called by ⍙Auto (above).
  ⍝    (1|0)← userLib verbose parms ∇ nm 
  ⍝ Returns SHY 1 (succ) or SHY 0 (fail), having established <nm> in userLib (ns) on success.
  LoadObj← { 
  ⍝ LoadObj utilities, followed by the executive...
    ⍝ SubScanFiles:    
    ⍝  ∇ files
    ⍝  extern: nm 
    ⍝ Search a list of full filenames <files> ending in simple name <nm> (before suffixes).
    ⍝ If a) it finds such a file
    ⍝    b) the ⎕FIX succeeds, and
    ⍝    c) the name ⍺ is among the names returned in the ⎕FIX, 
    ⍝ then it returns:
    ⍝    success: 1 ('file:', fi).
    ⍝ Otherwise, returns: rcNF (not found).
    ⍝ Notes:
    ⍝ ∘ The nameclass distinctions, based on suffixes, are currently NOT enforced for
    ⍝   the first three suffixes, but it's trivial to do.
    ⍝ ∘ When ⎕FIX is applied to the file found, <nm> must be among the names listed
    ⍝   as ⎕FIXed or an error (rcEN) is reported.
    ⍝ ∘ Other errors reported as rcER. 
      SubScanFiles← {   
        0= ≢⍵: rcNF ⍬ ⋄ 11 22:: rcER ⍬⊣ errSig⊢←⎕DMX 
        fi← ⊃⍵       
        ~⎕NEXISTS fi: ∇ 1↓⍵ 
        FixByType← { 
          sfx← ⊃⌽⎕NPARTS fi← ⍵  
          ⍝ When ⎕FIX is applied to ¨fi¨, ¨nm¨ must be among the names listed as ⎕FIXed.  
          '.aplf' '.aplo' '.apln'∊⍨ ⊂sfx: rcEN rcOK⊃⍨ (⊂nm)∊ 2 userLib.⎕FIX _FixOpts errFi⊢←fi 
          '.apla'≡ sfx: rcOK⊣ userLib ##.∆VSET ⊂nm (##.AN2Apl ⊃⎕NGET fi 1) 
          '.txt' ≡ sfx: rcOK⊣ userLib ##.∆VSET ⊂nm (⊃⎕NGET fi 1)                                     
          '.json'≡ sfx: rcOK⊣ userLib ##.∆VSET ⊂nm (⎕JSON _JOpts ⊃⎕NGET fi 0)  
          ⍝ All other suffixes, including .dyalog or a user-defined suffix.
          ⍝ When ⎕FIX is applied to ¨fi¨, ¨nm¨ must be among the names listed as ⎕FIXed. 
            rcEN rcOK⊃⍨ (⊂nm)∊ 2 userLib.⎕FIX _FixOpts errFi⊢← fi            
        }
        0≤ rc← FixByType fi: rc ('file:',fi) ⋄ rc ⍬ 
      } 
      _FixOpts← ⍠('FixWithErrors' 0)('Quiet' 1)    
      _JOpts← ⍠('Dialect' 'JSON5')('Compact' 0)('Null' ⎕NULL)     

    ⍝ SubScanWS:     
    ⍝ ret← path ∇ subpath
    ⍝    path:       ScanPath's current (outer) path 
    ⍝    subp:       the list of workspaces
    ⍝ extern: nm:  name to find     
    ⍝ ∘ May call ScanPath to recursively "return" to scanning the outer ¨path¨.   
    ⍝ Returns: 
    ⍝   a) (retcode ('ws:', wsname)), where retcode∊ (rcOK, rcNF, rcER), or
    ⍝   b) Returns retcode from recursive call to ScanPath  
      SubScanWS← { path subp← ⍺ ⍵
        0=≢subp: ScanPath 1↓path 
        ⍝ FixFromWS: If nm is in workspace ⊃subP, copy it. Otherwise, keep looking.
          FixFromWS← { 11:: rcNF ⍬ ⋄ rcOK ('ws:',⍵)⊣ ⍺ userLib.⎕CY ⍵ }
          ret← nm FixFromWS ⊃subp
        rcNF≠⊃ret: ret ⋄ path ∇ 1↓subp 
      }

    ⍝ ScanPath:
    ⍝ rcOK@B where@S← ∇ path@NsV 
    ⍝ extern: nm  
    ⍝ Recursively scan the path for name ⍵ in each file OR wsid 
    ⍝ spec in parms._fullPath   
    ⍝ ∘ If we see a array (with a single string), it's a workspace: 
    ⍝   call and return result from SubScanWS
    ⍝ ∘ Otherwise, 
    ⍝   call and return result from SubScanFiles
      ScanPath← {  
        0= ≢⍵: rcNF ⍬ ⋄ path← ⍵ ⋄ cur← ⊃path
        ⍝ If cur is a vector of (0 or more) char vectors, each is assumed to be a workspace id.
        ⍝ When done, having returned rcNF, recursively continue ScanPath.
        ⍝ Otherwise (rcOK or rcER), return from ScanPath.
        1< |≡cur: path SubScanWS cur                   ⍝ If VCV, => at least 1 workspace.        
          ff← ,(⊂cur)∘.,(⊂nm,'.')∘.,parms.suffix       ⍝ cur is a CV. Generate ff, list of files.  
        rcNF≠⊃ret← SubScanFiles ff: ret 
          ∇ 1↓path                       
      }

    ⍝ EndScan: Show optional action, then return.
    ⍝ rc← rc verbose dest ∇ srcFi destNs  
    ⍝ extern: nm 
    ⍝ 
    ⍝ If (~v), exit quietly, even if an error occur that we've anticpated.
    ⍝ Otherwise, simply print the errors and then continue normally.
    ⍝ This way, the user can trap errors relating to the missing objects. 
    ⍝ If you want errors to be ⎕SIGNALED, set signalOnErr← 1 at Executive
      EndScan←  { rc v libE← ⍺ 
        (~v)∧rc=rcOK: rc ⋄ (srcFi dest)← ⍵  
            Ê← { en message← ⍵ 
              libE: ⎕SIGNAL ⊂('EN' en) ('Message' message) 
              v: 0⊣ ⎕← ('∆F ',⎕EM en),': ',message 
              0
            }
        rc=rcOK: rc⊣ ⎕← '∆F: Copied "', nm, '" into £ibrary',(0≠ ≢srcFi)/ ' from ','"',srcFi,'"'
        rc=rcNF: rc⊣ Ê 11 ('Object "',nm,'" not found on search path')   
        rc=rcEN: rc⊣ Ê 11 ('Obj "',nm,'" not present in file "',srcFi,'"') 
      ⍝ rc=rcER: ⍝ a trapped APL Error i) loading or ii) converting on load ONLY, errSig←⎕DMX
            errSig.m1← 'Error loading "',nm,'" into user library '
            rc⊣ Ê errSig.(EN (m1,'(',Message,')'))
      }
      errSig← ⍬    ⍝ Re-set in SubScanFiles, used in EndScan only, where it's a namespace.
      errFi←''     ⍝ Used in EndScan only...
    ⍝ ===========================================================================
    ⍝ Executive for LoadObj 
    ⍝ ===========================================================================
      ⍝ nm: used in routines ScanPath (and descendants) and EndScan.
      userLib ê parms←⍺ ⋄ nm← ⍵                          
      ⍝ Return codes: 
      ⍝   rcOK (<nm> found and loaded), 
      ⍝   rcNF (<nm> file or w/s not found), 
      ⍝   rcER (specific APL errors, typically a failure to load), 
      ⍝   rcEN (file loaded fine, but <nm> wasn't one of the top-level objects, which we reject) 
      rcOK rcNF rcER rcEN← 1 0 ¯1 ¯2     
      rc where← ScanPath parms._fullPath 
    1: _← rc (ê.verbose ∨ parms.verbose) ##.SHOW_LIB_ERRS EndScan where userLib  
  } ⍝ End LoadObj 

⍝ ==========================================================================================================================
⍝ ==========================================================================================================================

⍝ ===================================================================================
⍝ LOAD TIME ROUTINES
⍝ ===================================================================================
⍝ LoadDefaultParms: Load-time routine
⍝   If successful, sets parameters 
⍝       ⍵.auto, ⍵.verbose, ⍵.path, ⍵.prefix, ⍵.suffix, etc.
⍝   If not,
⍝       then no more processing is done, auto←0, and no autoload searching is done (fast). 
⍝   If ⍵.path←⍬, 
⍝       no files or workspaces are checked.  No autoload searching is done (fast).
⍝   If ⍵.suffix←⍬, we will only check workspaces.
⍝ These are the default APL Array Notation settings: format ok whether Dyalog 20 or earlier.
⍝ User can override in ./.∆F, also in APLAN format. 
  LoadDefaultParms← { fi← ⍵ 
      ⎕THIS.parms← SetBaseParms ⍬
    2:: parms ⊣ 0 LoadErr 'Errors occurred loading default parameter file "',fi,'"'
    ~⎕NEXISTS fi: fi Err 'does not exist'
      ⎕THIS.parms← ##.AN2Apl ⊃⎕NGET fi 1  
      parms.verbose← (⍬ ⎕NULL∊⍨ ⊂parms.verbose)⊃ parms.verbose ##.VERBOSE 
      parms⊣ parms._readParms← 1 0 
  }
  ⍝ Set baseline parms in case we are directed NOT to read the default parms...
  SetBaseParms←{
      ⎕NS '_readParms' 'auto' 'verbose'⊣  _readParms auto verbose← (0 0) 0  (##.VERBOSE) 
  }


⍝ LoadUserParms: Loadtime routine
⍝ Loads parameter file ⍵ (if it exists) into namespace ⍺
⍝ Note default parameters for special cases (sc) below.
⍝ If load is 0, the user parameters are NOT loaded, but any default parameters already loaded are honored.
  LoadUserParms← {   
      runtime parmFi← ⍺ ⍵  
  ⍝ LoadUserParms main ...
    ~parms._readParms[0]:  _← 0 
      _← runtime ReadUserParms parmFi  
      _← ParmsSpecial parms 
      parms._fullPath← parms.prefix GenFullPath parms.path 
    ⍝ If parms._fullPath is not empty, we're done!
    0< ≢parms._fullPath: _← 1 
    ⍝ If parms._fullPath is empty, then turn auto off, since there's nothing to search..
      1 LoadErr 'The user parameter file was loaded correctly, but the search path is empty!'
  } 
  ⍝ ReadUserParms: Update parameters from parm file.
  ReadUserParms← { 
    ~⎕NEXISTS ⍵: ⍬ 
    11 2/⍨ ~⍺:: _← 1 LoadErr 'User parameter file ".∆F" has errors'
      _← 'parms' ⎕NS ##.AN2Apl ⊃⎕NGET ⍵ 1      ⍝ Merge parm file into internal defaults
      0⊣ parms._readParms[1]← 1 
  } 
  ⍝ Handle special-case values for  verbose, prefix, auto, path, suffix
  ParmsSpecial←{
    sc←  ('verbose' ##.VERBOSE) ('prefix'(,⊂''))  ('auto' 0)  
    sc,← ('path' ⍬)             ('suffix' ⍬)
  ⍝ If any parm in (⊃¨sc) has value ⎕NULL or ⍬, 
  ⍝ it is replaced by its default shown here in (⊃∘⌽¨sc)
    Val←    ⍵.⎕OR∘⊃
    IsNull← ⍬∘≡∨⎕NULL∘≡
    ⍵ ##.∆VSET sc/⍨ IsNull∘Val¨ sc
  }
    ⍝ GenFullPath:   _parms._fullPath← parms.prefix ∇ parms.path 
  GenFullPath← {
      ⍺←⍬ ⋄ 0=≢⍵: ⍺ ⋄ p← ⊂⊃⍵ 
    2<|≡p: (⍺, p) ∇ 1↓⍵                         ⍝ workspace
      (⍺, ,p∘., '/'∘.,⍺) ∇ 1↓⍵                  ⍝ file 
  } 

  ⍝ _CShow: 
  ⍝ ∘ Cond'lly show all APLAN parameters in 'parms' in alph order 
  ⍝   (⍺⍺=1) compactly, else (⍺⍺=0) multiline.
  ⍝   EXCEPT internal ones starting with '_'
  ⍝ ∘ If ⍺=1, force a display, even if parms.verbose=0.
  ⍝ ∘ Returns: a matrix of parms or (1 0⍴'')
  _CShow← { ⍺←0 
    0:: 1 0⍴⎕←'∆F Load: Error displaying runtime parameters'
    (~⍺)∧ ~⍵.verbose: _← 1 0⍴''  
    0= ≢nl← ⍵.⎕NL ¯2: _←1 0⍴'' 
    1: _← ↑⍺⍺ ##.Apl2AN ⍵.{⎕NS {⍵/⍨ '_'≠⊃¨⍵}⍵} nl
  } 

⍝ ShowPath:  Called via 'path' call in ##.Special. 
  ShowPath← { ⊃1 ##.Apl2AN parms._fullPath } 

⍝ What to do if loading defaults or user parms fails.
⍝    ⍺ LoadErr warning
⍝ Issues warning ⍵ if non-null  
⍝ Sets LibAuto to a nop and sets auto and _readParms to ¯1.
  LoadErr← { isUsrP← ⍺         ⍝ Do we have an error in user parameter loading (or in default parm load)?
      warn← '>>> ∆F LIB. WARNING: ' 
      amsg← (⊂'Library Autoload is '),¨ 'not available' 'available',¨'' ' with default parameters.'
      _← { 0=≢⍵: ⍬ ⋄ ⊢⎕← warn, ⍵ }¨ ⍵ ⎕DMX.Message (isUsrP⊃ amsg)    
      ⎕THIS.(LibAuto← LibNoAuto)                                     ⍝ No Auto function!
      0⊣ parms.(auto _readParms← 0 (0 0))  
  }

⍝ LoadParms: Load user parms
⍝   rc← ∇ opts
⍝   opts: '[-v] [-c] [-r]'
⍝     Load builtin parms? Yes
⍝     Load user parms?    Yes
⍝ We reload everything so that any user parms loaded reflect changes to the initial, built-in state.
⍝     Show parms?         If '-v' in opts or parms.verbose
⍝     Show compactly?     If '-c' in opts 
⍝     Is this runtime?    If '-r' in opts
⍝ Used at EXECUTIVE below and via 'parms' call in ##.Special.
  ∇ {rc}← LoadParms opts   
         ; isV; isC; isR; parmNs  
    isV isC isR← (1∊⍷∘opts)¨'-v' '-c' '-r'  
    rc← 1 0⍴⍬ 
    :If ##.LIB_ACTIVE≥ 1
        parmNs← LoadDefaultParms ##.LIB_PARM_FI 
        :If ##.LIB_ACTIVE= 2
        :AndIf rc← parmNs._readParms[0]     ⍝ Did we read the defaults? If so, continue...
          isR LoadUserParms '.∆F'          
        :EndIf
        rc← isV (isC _CShow) parms 
    :EndIf 
  ∇
⍝   SetLibFull: Point to (empty, but named) user library at load-time.
⍝      actual ref: ##.userLibrary, local ref (alias): userLib, local name: userLibNm.
⍝ external: 
⍝      userLib, userLibNm, Auto, parms, ShowPath, LoadParms   ⍝ loaded here...
  ∇ {libNs}← SetLibFull libNs
    ⍝ external: userLib, userLibNm, userLibNmP
    libNs.⎕DF ⎕NULL                      ⍝ In case set...
    userLibNmP← '(',')',⍨ userLibNm← ⍕userLib← libNs 
    userLib.⎕DF '£=[',userLibNm,']'
  ∇

⍝ =========================================================================
⍝ EXECUTIVE
  SetLibFull ##.userLibrary
  LoadParms  ''
:EndNamespace   ⍝ libUtils
