:namespace ∆PREns
    ∇ res←{opts}∆PRE lines
      :If 0=⎕NC'opts'
          opts←''
      :ElseIf 0≡opts
          opts←'-noF -noC -noV -noD'   ⍝ Used internally for macros...
      :EndIf
     
     ⍝ Move execution into a private NS so we don't worry about name conflicts.
     ⍝ We'll explicitly save objects in CALLER ns or ∆MY ns (see ⎕MY macro)
      res←(⊃⊆,opts)(⎕NS'').{
          ⎕IO ⎕ML ⎕PP←0 1 34
       ⍝ isSpecialMacro ⍵: Special macros include dunder (__) vars defined here.
       ⍝ When a user DEFs these macros (read or write), ∆PRE will see them
       ⍝ as their corresponding local variables of the same name
       ⍝ See Executive (below) for meanings.
       ⍝ Note: Don't define any vars starting with '_' here or above!
          __DEBUG__←__VERBOSE__←__INCLUDE_LIMITS__←¯1
          __MAX_EXPAND__←__MAX_PROGRESSION__←¯1
          isSpecialMacro←(∊∘(' '~⍨¨↓'_'⎕NL 2))∘⊂
       ⍝ Use NL   for all newlines to be included in the ∆PRE output.
       ⍝ Use CR   in error msgs going to ⎕ (APL (mis)treats NL as a typewriter newline)
       ⍝ Use NULL internally for special code lines (NULLs are removed at end)
          NL CR NULL←⎕UCS 10 13 0
          SQ DQ SQDQ←'''' '"' '''"'
          CALLER←1⊃⎕RSI,#          ⍝ We're one level down, so take 1⊃⎕RSI...
     
      ⍝  ::EXTERN (Variables global to ∆PRE, but not above)
      ⍝ -------------------------------------------------------------------
      ⍝ OPTIONS
      ⍝ (Defaults):
      ⍝    -noD -V -noE -C -S -M -noH
      ⍝ -D | -noD   __DEBUG__, add supplemental annotations to ⎕ (stdout)
      ⍝   Default: -noD  (Also a R/W macro)
      ⍝ -V | -noV   __VERBOSE__, include directives and status in output code.
      ⍝             This always makes sense
      ⍝             (but if -C is specified, all comments are removed, even these.)
      ⍝   Default: -V    (Also a R/W macro)
      ⍝ -E | -noE   EDIT, look at annotated preprocessed intermediate file
      ⍝   Default: -noE, except as below
      ⍝            -E, if ⍵ (right argument) is ⎕NULL
      ⍝ -noC        NOCOM, remove all comment lines and blank lines
      ⍝   Default: (-C)
      ⍝ -noB        NOBLANK, remove blank lines
      ⍝   Default: (-B)
      ⍝ -F | -noF   FIX the result of execution of the file or lines passed.
      ⍝   Default: (-F)
      ⍝      -F     Fix the result and return the names returned from 2 ⎕FIX.
      ⍝      -noF   Preprocess lines in ⍵ and return the results.
      ⍝ -H          HELP, show help info, ignoring ⍵ (right arg)
      ⍝   Default: (-noH)
      ⍝ Special:
      ⍝   For 0 ∆PRE ⍵, see full documentation below.
     
          ⋄ opt←(819⌶,⍺)∘{w←'-',819⌶⍵ ⋄ 1∊w⍷⍺}
          ⋄ orEnv←{⍺←0 ⋄ ⍺=1:⍺ ⋄ var←'∆PRE_',1(819⌶)⍵ ⋄ 0=CALLER.⎕NC var:0 ⋄ 1≡CALLER.⎕OR var}
          __VERBOSE__←(~opt'noV')∧~(opt'V')orEnv'VERBOSE'  ⍝ Default 1; checking env
          __DEBUG__←(opt'D')orEnv'DEBUG'                   ⍝ Default 0; checking env
          NOCOM NOBLANK HELP←opt¨'noC' 'noB' 'HELP'        ⍝ Default 1 1 1
          EDIT←(⎕NULL≡⍵)∨opt'E'                            ⍝ Default 0; 1 if ⍵≡⎕NULL
          QUIET←__VERBOSE__⍱__DEBUG__                      ⍝ Default 1
          FIX←~opt'noF'                                    ⍝ Default 1
     
          _←{ ⍝ Option information
              ⍺←0 ⋄ ~__DEBUG__∨⍺:0 ⋄ _←'    '
              ⎕←_,'Options: "','"',⍨819⌶,⍵
              ⎕←_,'Verbose: ',__VERBOSE__ ⋄ ⎕←_,'Debug:   ',__DEBUG__
              ⎕←_,'NoCom:   ',NOCOM ⋄ ⎕←_,'NoBlanks:',NOBLANK
              ⎕←_,'Edit:    ',EDIT ⋄ ⎕←_,'Quiet:   ',QUIET
              ⎕←_,'Help:    ',HELP ⋄ ⎕←_,'Fix:  ',FIX
              0
          }⍺
       ⍝ HELP PATH
          HELP:{⎕ED'___'⊣___←↑(⊂'  '),¨3↓¨⍵/⍨(↑2↑¨⍵)∧.='   ⍝H'}2↓¨⎕NR⊃⎕XSI
      ⍝ -------------------------------------------------------------------
     
          (1↓⊆,⍺){
              preamble←⍺
           ⍝ ∆GENERAL ∆UTILITY ∆FUNCTIONS
           ⍝
           ⍝ annotate [preprocessor (output) code]
           ⍝ If __VERBOSE__,
           ⍝     write to preprocessor output:
           ⍝         (b⍴' '),⍵
           ⍝     where
           ⍝         b is # of leading blanks in string ⍺, if ⍺ is specified.
           ⍝         b is # of leading blanks in string ⍵, otherwise.
           ⍝     ⍵ is typically a preprocessor directive, potentially w/ leading blanks,
           ⍝     Where ⍵ is modified, ⍺ is the original or model directive w/ leading blanks.
           ⍝ else
           ⍝     write the token EMPTY (a NULL char with special meaning).
              annotate←{
                  ~__VERBOSE__:EMPTY
                  ⍺←⍬ ⋄ 0≠≢⍺:'⍝',⍵,⍨⍺↑⍨0⌈¯1++/∧\' '=⍺ ⋄ '⍝',(' '⍴⍨0⌈p-1),⍵↓⍨p←+/∧\' '=⍵
              }
           ⍝ print family - informing user, rather than annotating output code.
           ⍝
           ⍝ print- print ⍵ as a line ⍵' on output, converting NL to CR (so APL prints properly)
           ⍝ printQ-same as print, but using ⍞←⍵' rather than ⎕←⍵.
           ⍝ Both return: ⍵, not the translated ⍵'.
           ⍝ DO NOT USE CR in program code lines.
              print←{⍵⊣⎕←CR@(NL∘=)⊣⍵}
              printQ←{⍵⊣⍞←CR@(NL∘=)⊣⍵}
           ⍝ dPrint- same as print,  but only if __DEBUG__=1.
           ⍝ dPrintQ-same as printQ, but only if __DEBUG__=1.
           ⍝ Returns ⍵.
              dPrint←{__DEBUG__:print ⍵ ⋄ ⍵}
              dPrintQ←{__DEBUG__:printQ ⍵ ⋄ ⍵}
     
           ⍝ ∆FLD: ⎕R helper.
           ⍝  Returns the contents of ⍺ regexp field ⍵, a number or name or ''
           ⍝ val ← ns  ∆FLD [fld number | name]
           ⍝    ns- active ⎕R namespace (passed by ⎕R as ⍵)
           ⍝    fld number or name: a single field number or name.
           ⍝ Returns <val> the value of the field or ''
              ∆FLD←{
                  ns←⍺
                  ' '=1↑0⍴⍵:ns ∇ ns.Names⍳⊂⍵
                  ⍵=0:ns.Match                          ⍝ Fast way to get whole match
                  ⍵≥≢ns.Lengths:''                      ⍝ Field not defined AT ALL → ''
                  ns.Lengths[⍵]=¯1:''                   ⍝ Defined field, but not used HERE (within this submatch) → ''
                  ns.(Lengths[⍵]↑Offsets[⍵]↓Block)      ⍝ Simple match
              }
           ⍝ ∆MAP: replaces elements of string ⍵ of form ⍎name with value of name.
           ⍝       recursive (within limits <⍺>) whenever ⍵' changes:  ⍵≢⍵'←∆MAP ⍵
                    ⍝ ∆QT:  Add quotes (default ⍺: single)
           ⍝ ∆DQT: Add double quotes. See ∆QTX if you want to fix any internal double quotes.
           ⍝ ∆UNQ: Remove one level of s/d quotes from around a string, addressing internal quotes.
           ⍝       If ⍵ doesn't begin with a quote in ⍺ (default: s/d quotes), does nothing.
           ⍝ ∆QT0: Double internal quotes (default ⍺: single quotes)
           ⍝ ∆QTX: Add external quotes (default ⍺: single), first doubling internal quotes (if any).
              ∆MAP←{⍺←15 ⋄ ∆←'⍎[\w∆⍙⎕]+'⎕R{⍎1↓⍵ ∆FLD 0}⍠'UCP' 1⊣⍵ ⋄ (⍺>0)∧∆≢⍵:(⍺-1)∇ ∆ ⋄ ∆}
              ∆QT←{⍺←SQ ⋄ ⍺,⍵,⍺}
              ∆DQT←{DQ ∆QT ⍵}
              ∆UNQ←{⍺←SQDQ ⋄ ~⍺∊⍨q←1↑⍵:⍵ ⋄ s←1↓¯1↓⍵ ⋄ s/⍨~s⍷⍨2⍴q}
              ∆QT0←{⍺←SQ ⋄ ⍵/⍨1+⍵∊⍺}
              ∆QTX←{⍺←SQ ⋄ ⍺ ∆QT ⍺ ∆QT0 ⍵}
           ⍝ ∆PARENS: ⍵  →   '(⍵)'
              ∆PARENS←{'(',')',⍨⍵}
           ⍝ ∆H2D: Converts hex to decimal, silently ignoring chars not in 0-9a-fA-F, including
           ⍝      blanks or trailing X symbols. (You don't need to remove X or blanks first.)
              ∆H2D←{   ⍝ Decimal from hexadecimal
                  11::'∆PRE hex number (0..X) too large'⎕SIGNAL 11
                  16⊥16|a⍳⍵∩a←'0123456789abcdef0123456789ABCDEF'
              }
           ⍝ ∆TRUE ⍵:
           ⍝ "Python-like" sense of truth, useful in ::IFDEF and ::IF statements.
           ⍝ ⍵ (a string) is 1 (true) unless
           ⍝    a) ⍵ is a blank or null string, or
           ⍝    b) its val, v such that v←∊CALLER⍎⍵ is of length 0 or v≡(,0) or v≡⎕NULL, or
           ⍝    c) it cannot be evaluated,
           ⍝       in which case a warning is given (debug mode) before returning 0.
              ∆TRUE←{
                  0::0⊣dPrint'∆PRE Warning: Unable to evaluate truth of {',⍵,'}, returning 0'
                  0=≢⍵~' ':0 ⋄ 0=≢val←∊CALLER⍎⍵:0 ⋄ (,0)≡val:0 ⋄ (,⎕NULL)≡val:0
                  1
              }
           ⍝ GENERAL CONSTANTS. Useful in annotate etc.
           ⍝ Annotations (see annotate).
           ⍝   YES - path taken.
           ⍝   NO  - path not taken (false conditional).
           ⍝   SKIP- skipped because it is governed by a conditional that was false.
           ⍝   INFO- added information.
              YES NO SKIP INFO←' ✓' ' 😞' ' 🚫' ' 💡'
           ⍝ EMPTY: Marks (empty) ∆PRE-generated lines to be deleted before ⎕FIXing
              EMPTY←,NULL
     
           ⍝ Process double quotes based on double-quoted string suffixes "..."sfx
           ⍝ Where suffixes are [vsm]? and  [r]? with default 'v' and (cooked).
           ⍝ If suffix is (case ignored):
           ⍝  type  suffix      set of lines in double quotes ends up as...
           ⍝  VEC   v or none:  ... a vector of (string) vectors
           ⍝ SING   s:          ... a single string with newlines (⎕UCS 10)
           ⍝  MX    m:          ... a single matrix
           ⍝  RAW   r:          blanks at the start of each line are preserved.
           ⍝ COOKD  none:       blanks at the start of each line are removed.
              processDQ←{⍺←0       ⍝ If 1, create a single string. If 0, create char vectors.
                  str type←(⊃⍵)(819⌶⊃⌽⍵)
               ⍝ type: 'v' (cooked) is nothing else specified.
               ⍝       which sets raw←0, sing←0, cMx←''
                  isRaw←'r'∊type ⋄ isStr←'s'∊type ⋄ isMx←'m'∊type
                  hasMany←NL∊str
                  ⋄ toMx←{⍺:'↑',⍵ ⋄ '↑,⊆',⍵}       ⍝ Forces simple vec or scalar → matrix
                  ⋄ Q_CR_Q←''',(⎕UCS 13),'''       ⍝ APL expects a CR, not NL.
                  ⋄ ⋄ opts←('Mode' 'M')('EOL' 'LF')
                  str2←∆QT0 ∆UNQ str
     
                  isStr:∆PARENS⍣hasMany⊣∆QT{
                      isRaw:'\n'⎕R Q_CR_Q⍠opts⊢⍵
                      '\A\h+' '\n\h*'⎕R''Q_CR_Q⍠opts⊢⍵
                  }str2
                  hasMany toMx⍣isMx⊣∆QT{
                      isRaw:'\n'⎕R''' '''⍠opts⊢⍵
                      '\A\h+' '\n\h*'⎕R'' ''' '''⍠opts⊢⍵
                  }str2
     
                  '∆PRE: processDQ logic error'⎕SIGNAL 911
              }
     
           ⍝ getDataIn object:⍵
           ⍝ ⍵:
           ⍝    a vector of vectors: lines of APL code in 2∘FIX format.
           ⍝    ⎕NULL:               prompts user for lines of APL code in 2∘FIX format.
           ⍝    char vector:         name of function with lines of APL code.
           ⍝          If the name ⍵ has no file extension, then we'll try ⍵.dyapp and ⍵.dyalog.
           ⍝          ⍵ may have a prefix (test/ in test/myfi.dyapp).
           ⍝          Searches , .. .. and directories in env FSPATH and WSPATH in turn.
           ⍝
           ⍝ Returns ⍵:the object name, the full file name found, (the lines of the file)
           ⍝ If the obj ⍵ is ⎕NULL, the object is prompted from the user.
           ⍝ (See promptForData) for returned value.
              getDataIn←{∆∆←∇
                  19::'∆PRE: Invalid or missing file'⎕SIGNAL 19
                  ⍵≡⎕NULL:promptForData ⍬
                  2=|≡⍵:'__TERM__' '[function line]'(,¨⍵)     ⍝ In case last line is '∇' → (,'∇')
     
                  ⍺←{∪{(':'≠⍵)⊆⍵}'.:..',∊':',¨{⊢2 ⎕NQ'.' 'GetEnvironment'⍵}¨⍵}'FSPATH' 'WSPATH'
                  0=≢⍺:11 ⎕SIGNAL⍨'∆PRE: Unable to find or load source file ',∆DQT ⍵
                  dir dirs←(⊃⍺)⍺
     
              ⍝ If the file has an explicit extension, it determines the ONLY type.
                  pfx nm ext←⎕NPARTS ⍵
                  _←{
                      0 3 4∊⍨CALLER.⎕NC ⍵:''
                      ⎕←'∆PRE Warning. Existing incompatible object "',⍵,'" may prevent ⎕FIXing'
                  }nm
     
              ⍝ Otherwise, use types '.dyapp' [new] and '.dyalog' [std].
                  types←{×≢⍵:⊂⍵ ⋄ '.dyapp' '.dyalog'}ext
     
                  types{
                      0=≢⍺:(1↓dirs)∆∆ ⍵
                      filenm←(2×dir≡,'.')↓dir,'/',⍵,⊃⍺
                      ⎕NEXISTS filenm:⍵ filenm(⊃⎕NGET filenm 1)
                      (1↓⍺)∇ ⍵
                  }pfx,nm
              }
           ⍝ prompt User for data to preprocess. Useful for testing...
           ⍝ Creates object __TERM__, its full filename is '/dev/null', and lines as specified.
              promptForData←{
                  _←print'Enter lines. Empty line to terminate.'
                  lines←{⍺←⊂'__TERM__' ⋄ 0=≢l←⍞↓⍨≢⍞←⍵:⍺ ⋄ (⍺,⊂l)∇ ⍵}'> '
                  '__TERM__' '[user input]'lines
              }
     
         ⍝ MACRO (NAME) PROCESSING
         ⍝ put, get, getIfVis, hideEach, del, isDefined
         ⍝ Extern function (isSpecialMacro n) returns 1 if <n> is a special Macro.
         ⍝ Includes a feature for preventing recursive matching of the same names
         ⍝ in a single recursive (repeated) scan.
         ⍝ Adds to extern: mNames, mVals, mNameVis
              lc←819⌶
              put←{⍺←__DEBUG__ ⋄ verbose←⍺
                  n v←⍵      ⍝ add (name, val) to macro list
                 ⍝ case is 1 only for ⎕vars...
                  c←⍬⍴'⎕:'∊⍨1↑n
                  n~←' ' ⋄ mNames,⍨←⊂lc⍣c⊣n ⋄ mVals,⍨←⊂v ⋄ mNameVis,⍨←1
                  ~isSpecialMacro n:⍵           ⍝ Not in domain of [fast] isSpecialMacro function
                ⍝ Special macros: if looks like number (as string), convert to numeric form.
                  processSpecialM←{
                      0::⍵⊣print'∆PRE: Logic error in put'    ⍝ Error? Move on.
                      v←{0∊⊃V←⎕VFI ⍵:⍵ ⋄ ⊃⌽V}⍕v               ⍝ Numbers vs Text
                      _←⍎n,'∘←⍬⍴⍣(1=≢v)⊣v'                              ⍝ Execute in ∆PRE space, not user space.
                      ⍵⊣{⍵:print'Set special variable ',n,' ← ',(⍕v),' [EMPTY]'/⍨0=≢v ⋄ ⍬}verbose
                  }
                  n processSpecialM ⍵
              }
           ⍝ get  ⍵: retrieves value for ⍵ (or ⍵, if none)
           ⍝ getIfVis ⍵: ditto, but only if mNameVis flag is 1
           ⍝ hideEach ⊆⍵: sets mNameVis flag to (scalar) ⍺←0 for each name in ⍵, returning ⍺
              get←{n←⍵~' ' ⋄ c←⍬⍴'⎕:'∊⍨1↑n
                  p←mNames⍳⊂lc⍣c⊣n ⋄ p≥≢mNames:n ⋄ p⊃mVals
              }
              getIfVis←{n←⍵~' ' ⋄ c←⍬⍴'⎕:'∊⍨1↑n
                  p←mNames⍳⊂lc⍣c⊣n ⋄ p≥≢mNames:n ⋄ ~p⊃mNameVis:n ⋄ p⊃mVals
              }
              hideEach←{⍺←0
                  ⍺⊣⍺{n←⍵~' ' ⋄ c←⍬⍴'⎕:'∊⍨1↑n
                      p←mNames⍳⊂lc⍣c⊣n ⋄ p≥≢mNames:_←¯1 ⋄ 1:_←(p⊃mNameVis)∘←⍺
                  }¨⍵
              }
              del←{n←⍵~' ' ⋄ c←⍬⍴'⎕:'∊⍨1↑n
                  p←mNames⍳⊂lc⍣c⊣n ⋄ p≥≢mNames:n
                  mNames mVals mNameVis⊢←(⊂p≠⍳≢mNames)/¨mNames mVals mNameVis ⋄ n}
              isDefined←{n←⍵~' ' ⋄ c←⍬⍴'⎕:'∊⍨1↑n
                  p←mNames⍳⊂lc⍣c⊣n ⋄ p≥≢mNames:0 ⋄ 1}
     
         ⍝-----------------------------------------------------------------------
         ⍝ preEval (macro expansion, including special predefined expansion)
         ⍝     …                     for continuation (at end of (possbily commented) lines)
         ⍝     …                     for numerical sequences of form n1 [n2] … n3
         ⍝     25X                   for hexadecimal constants
         ⍝     25I                   for big integer constants
         ⍝     name → value          for implicit quoted (name) strings and numbers on left
         ⍝     `atom1 atom2...       for implicit quoted (name) strings and numbers on right
         ⍝
         ⍝-----------------------------------------------------------------------
              preEval←{
                  ⍺←__MAX_EXPAND__      ⍝ If 0, macros including hex, bigInt, etc. are NOT expanded!!!
              ⍝ ∆TO: Concise variant on dfns:to, allowing start [incr] to end
              ⍝     1 1.5 ∆TO 5     →   1 1.5 2 2.5 3 3.5 4 4.5 5
              ⍝ expanded to allow (homogenous) Unicode chars
              ⍝     'a' ∆TO 'f' → 'abcdef'  ⋄   'ac' ∆TO 'g'    →   'aceg'
                  ∆TO←{⎕IO←0 ⋄ 0=80|⎕DR ⍬⍴⍺:⎕UCS⊃∇/⎕UCS¨⍺ ⍵ ⋄ f s←1 ¯1×-\2↑⍺,⍺+×⍵-⍺ ⋄ ,f+s×⍳0⌈1+⌊(⍵-f)÷s+s=0}
                  ∆TOcode←{(2+≢⍵)↓⊃⎕NR ⍵}'∆TO'
              ⍝ Single-char translation input option. See ::TRANS
                  str←{0=≢translateIn:⍵ ⋄ translateOut@(translateIn∘=)⍵}⍵
                  mNameVis[]∘←1      ⍝ Make all visible until next call to preEval
                  str←⍺{
                      strIn←str←⍵
                      0≥⍺:⍵
                      nmsFnd←⍬
                      ch1←ch2←0
                ⍝ Match/preEval...
                ⍝ [1] pLongNmE: long names,
                      cUserE cSQe cCommentE cLongE←0 1 2 3
                      str←{
                          e1←'∆PRE: Value is too complex to represent statically:'
                          4::4 ⎕SIGNAL⍨e1,CR,'   ⍝     In macro code: "',⍵,'"'
                          pUserE pSQe pCommentE pLongNmE ⎕R{
                              ch1⊢←1
                              f0←⍵ ∆FLD 0 ⋄ case←⍵.PatternNum∘∊
                              case cSQe:f0
                              case cLongE:⍕getIfVis f0⊣nmsFnd,←⊂f0          ⍝ Let multilines fail
                              case cUserE:'⎕SE.UCMD ',∆QT ⍵ ∆FLD 1          ⍝ ]etc → ⎕SE.UCMD 'etc'
                              ⊢f0                                           ⍝ else: comments
                          }⍠'UCP' 1⊣⍵
                      }str
     
     
                 ⍝ [2] pShortNmE: short names (even within found long names)
                 ⍝     pSpecialIntE: Hexadecimals and bigInts
                      cSQe cCommentE cShortNmE cSpecialIntE←0 1 2 3
                      str←pSQe pCommentE pShortNmE pSpecialIntE ⎕R{
                          ch2⊢←1
                          f0←⍵ ∆FLD 0 ⋄ case←⍵.PatternNum∘∊
                          case cSpecialIntE:{
                              ⍵∊'xX':⍕∆H2D f1
                              0=≢f2:∆QT f1                ⍝ No exponent
                              ∆QT f1,('0'⍴⍨⍎f2)           ⍝ Explicit exponent-- append 0s.
                          }¯1↑f0⊣f1 f2←⍵ ∆FLD¨1 2
                          case cShortNmE:⍕getIfVis f0⊣nmsFnd,←⊂f0
                          ⊢f0                            ⍝ else: pSQe or pCommentE
                      }⍠'UCP' 1⊣str
                      changed←ch1+ch2
                      0=changed:str
                      _←nmsFnd←⍬⊣hideEach nmsFnd
                      (⍺-changed)∇ str
                  }str
            ⍝  Ellipses - constants (pDot1e) and variable (pDot2e)
            ⍝  pDot1e must precede pSQe, so that char. progressions 'a'..'z' are found before simple 'a' 'z'
            ⍝  Check only after all substitutions (above), so ellipses with macros that resolve to
            ⍝  numeric or char. constants are optimized.
            ⍝  See __MAX_PROGRESSION__ below
                  pFormatStringE←'(?ix) ∆FORMAT\h* ( (?: ''[^'']*'' )+ )'
                  cDot1E cSQe cCommentE cDot2E cAtomsE cFormatStringE←0 1 2 3 4 5
                  str←pDot1e pSQe pCommentE pDot2e pATOMSe pFormatStringE ⎕R{
                      case←⍵.PatternNum∘∊
     
                      case cSQe cCommentE:⍵ ∆FLD 0
                  ⍝  Matching       ≢graves ≢arrows
                  ⍝                  fld1    fld3
                  ⍝ `atom1 atom2       0      0
                  ⍝ (...→...)          0      0
                  ⍝ ``atom1 atom2      1      0
                  ⍝ (...→→...)         0      1
                      case cAtomsE:(1∊≢¨⍵ ∆FLD¨1 3)procAtoms ⍵ ∆FLD 2
                      case cDot2E:∆TOcode
                      case cFormatStringE:{
                          0::⍵ ∆FLD 0
                          0 ∆format ∆UNQ ⍵ ∆FLD 1  ⍝ (Remove extra quoting added above).
                      }⍵
                  ⍝ case cDot1E
                      ⋄ f1 f2←⍵ ∆FLD¨1 2 ⋄
                      ⋄ progr←∆QTX⍣(SQ=⊃f1)⊣⍎f1,' ∆TO ',f2   ⍝ Calculate constant progression
                      __MAX_PROGRESSION__<≢progr:f1,' ',∆TOcode,' ',f2
                      {0=≢⍵:'⍬' ⋄ 1=≢⍵:'(,',')',⍨⍕⍵ ⋄ ⍕⍵}progr
                                             ⍝  .. preceded or followed by non-constants
                  }⍠'UCP' 1⊣str
                  str
              }
              procAtoms←{⍺←0     ⍝ 1: double arrow →→ or double grave ``
                  nest←'⊆'/⍨~⍺
                  atoms←1↓∊{
                      '⍬'=⊃⍵:⍵
                      ⋄ isNumAtom←(⊃⍵)∊'¯.',⎕D
                      isNumAtom:' (,',⍵,')'
                      ⋄ q←∆QT ⍵
                      1=≢⍵:' (,',q,')'
                      ' ',q
                  }¨' '(≠⊆⊢)⍵
                  '(',nest,')',⍨atoms
              }
     
         ⍝ -------------------------------------------------------------------------
         ⍝ PATTERNS
         ⍝ [1] DEFINITIONS -
         ⍝ [2] PATTERN PROCESSING
         ⍝ -------------------------------------------------------------------------
     
         ⍝ -------------------------------------------------------------------------
         ⍝ [1] DEFINITIONS
         ⍝ -------------------------------------------------------------------------
              _CTR_←0 ⋄ patternList←patternName←⍬
           ⍝ PREFIX: Sets the prefix string for ∆PRE directives.
           ⍝      Default '::' or CALLER.∆PRE_PREFIX, if set.
           ⍝      Must be a char scalar or vector; treated as a regexp literal.
              PREFIX←'∆PRE_PREFIX'{0≠CALLER.⎕NC ⍺:CALLER.⎕OR ⍺ ⋄ ⍵}'::'
     
              reg←{⍺←'???' ⋄ p←'(?xi)' ⋄ patternList,←⊂∆MAP p,⍵ ⋄ patternName,←⊂⍺ ⋄ (_CTR_+←1)⊢_CTR_}
              ⋄ ppBeg←'^\h* \Q',PREFIX,'\E \h*'
              cIFDEF←'ifdef'reg'    ⍎ppBeg  IF(N?)DEF         \h+(.*)         $'
              cIF←'if'reg'          ⍎ppBeg  IF                \h+(.*)         $'
              cELSEIF←'elseif'reg'  ⍎ppBeg  EL(?:SE)?IF \b    \h+(.*)         $'
              cELSE←'else'reg'      ⍎ppBeg  ELSE         \b       .*          $'
              cEND←'end'reg'        ⍎ppBeg  END                   .*          $'
              ⋄ ppTarg←' [^ ←]+ '
              ⋄ ppSetVal←' (?:(←)\h*(.*))?'
              ⋄ ppFiSpec←'  (?: "[^"]+")+ | (?:''[^'']+'')+ | ⍎ppName '
            ⍝ Note that we allow a null \0 to be the initial char. of a name.
            ⍝ This can be used to suppress finding a name in a replacement,
            ⍝ and \0 will be removed at the end of processing.
            ⍝ This is mostly obsolete given we suppress macro definitions on recursion
            ⍝ so pats like  ::DEF fred← (⎕SE.fred) will work, rather than run away.
              ⋄ ppShortNm←'  [\0]?[\pL∆⍙_\#⎕:] [\pL∆⍙_0-9\#]* '
              ⋄ ppShortNmPfx←' (?<!\.) ⍎ppShortNm '
              ⋄ ppLongNmOnly←' ⍎ppShortNm (?: \. ⍎ppShortNm )+'      ⍝ Note: Forcing Longnames to have at least one .
              ⋄ ppName←'    ⍎ppShortNm (?: \. ⍎ppShortNm )*'         ⍝ ppName - long OR short
     
              cDEF←'def'reg'      ⍎ppBeg DEF(?:INE)?(Q)?  \h* (⍎ppTarg)    \h*    ⍎ppSetVal   $'
              cVAL←'val'reg'      ⍎ppBeg E?VAL(Q)?        \h* (⍎ppTarg)    \h*    ⍎ppSetVal   $'
            ⍝ statPat: name | name ← val | code_to_execute
              ⋄ statPat←'⍎ppBeg STATIC \h+ (\]?) \h* (?|(⍎ppName) \h* ⍎ppSetVal $ | ()() (.*)  $)'
              cSTAT←'stat'reg statPat
              cINCL←'include'reg' ⍎ppBeg INCL(?:UDE)?     \h* (⍎ppFiSpec)         .*          $'
              cIMPORT←'import'reg'⍎ppBeg IMPORT           \h* (⍎ppName)   (?:\h+ (⍎ppName))?  $'
              cCDEF←'cond'reg'    ⍎ppBeg CDEF(Q)?         \h* (⍎ppTarg)     \h*   ⍎ppSetVal   $'
              cUNDEF←'undef'reg'  ⍎ppBeg UNDEF            \h* (⍎ppName )    .*                $'
              cTRANS←'trans'reg'  ⍎ppBeg  TR(?:ANS)?       \h+  ([^ ]+) \h+ ([^ ]+)  .*       $'
              cOTHER←'apl'reg'    ^                                         .*                $'
     
           ⍝ patterns solely for the ∇preEval∇ fn
             ⍝ User cmds: ]... (See also ⎕UCMD)
              pUserE←'^\h*\]\h*(.*)$'
              ⍝ Triple-double quote strings are multiline comments (never quotes), replaced by blanks!
              ⍝      """... multiline ok """    ==> ' '
              pDQ3e←'(?sx)  "{3} .*? "{3}'
              ⍝ Double quote suffixes:   [R/r] plus [S/s] or [M/m] or [V/v]
              ⍝ R/r, Raw: don't remove leading blanks. Else, do.
              ⍝ S/s, return single string with embedded newlines.
              ⍝ V/v, return vector of strings, split at newlines.
              ⍝ M/m  returns a matrix (padded with blanks).
              pDQe←'(?ix) (    (?: " [^"]*     "  )+ )   ([VSMR]{0,2}) '
              pSQe←'(?x)  (    (?: ''[^'']*'' )+  )'          ⍝ Allows multiline sq strings- prevented elsewhere.
              pCommentE←'(?x)      ⍝ .*  $'
              ⍝ ppNum: A non-complex signed APL number (float or dec)
              ⋄ ppNum←' (?: ¯?  (?: \d+ (?: \.\d* )? | \.\d+ ) (?: [eE]¯?\d+ )?  )'~' '
              ⋄ ppDot←'(?:  … | \.{2,} )'
              ⋄ ppCh1←' ''(?: [^''] | ''{2} ) '' ' ⋄ ppCh2←' '' (?: [^''] | ''{2} ){2} '' '
              ⋄ ppDot1e←'  (?| ( ⍎ppNum (?: \h+ ⍎ppNum)*          ) \h* ⍎ppDot \h* (⍎ppNum) '
              ⋄ ppDot1e,←'   | ( ⍎ppCh1 (?: \h+ ⍎ppCh1)* | ⍎ppCh2 ) \h* ⍎ppDot \h* (⍎ppCh1) ) '
              pDot1e←∆MAP'(?x)   ⍎ppDot1e'
              pDot2e←∆MAP'(?x)   ⍎ppDot'
              ⍝ Special Integer Constants: Hex (ends in X), Big Integer (ends in I)
              ⋄ ppHex←'   ¯? (\d  [\dA-F]*)             X'
              ⍝ Big Integer: f1: bigint digits, f2: exponent... We'll allow non-negative exponents but not periods
              ⋄ ppBigInt←'¯? (\d+) (?: E (\d+) )? I'
              ⍝ pSpecialIntE: Allows both bigInt format and hex format
              ⍝ This is permissive (allows illegal options to be handled by APL),
              ⍝ but also VALID bigInts like 12.34E10 which is equiv to 123400000000
              ⍝ Exponents are invalid for hexadecimals, because the exponential range
              ⍝ is not defined/allowed.
              pSpecialIntE←∆MAP'(?xi)  (?<![\dA-F\.]) (?| ⍎ppHex | ⍎ppBigInt ) '
     
           ⍝ For MACRO purposes, names include user variables, as well as those with ⎕ or : prefixes (like ⎕WA, :IF)
              ⍝ pLongNmE Long names are of the form #.a or a.b.c
              ⍝ pShortNmE Short names are of the form a or b or c in a.b.c
              pLongNmE←∆MAP'(?x)  ⍎ppLongNmOnly'
              pShortNmE←∆MAP'(?x) ⍎ppShortNmPfx'       ⍝ Can be part of a longer name as a pfx. To allow ⎕XX→∆XX
              ⍝ Convert multiline quoted strings "..." to single lines ('...',CR,'...')
              pContE←'(?x) \h* \.{2,} \h* (   ⍝ .*)? \n \h*'
              pEOLe←'\n'
           ⍝ Treat valid input ⍬⍬ or ⍬123 as APL-normalized ⍬ ⍬ and ⍬ 123 -- makes Atom processing simpler.
              pZildeE←'\h* (?: ⍬ | \(\) ) \h*'~' '
              ⍝ For  (names → ...) and (`names)
              ⋄ ppNum←'¯?\.?\d[¯\dEJ.]*'       ⍝ Overgeneral, letting APL complain of errors
              ⋄ ppAtom←'(?: ⍎ppName | ⍎ppNum | ⍬ )'
              ⋄ ppAtoms←' ⍎ppAtom (?: \h+ ⍎ppAtom )*'
              ⋄ _←'(?xi)  (?| \`(\`?) \h* (⍎ppAtoms)'
              ⋄ _,←'        | (     )     (⍎ppAtoms) \h* →(→?)) '
              pATOMSe←∆MAP _
         ⍝ -------------------------------------------------------------------------
         ⍝ [2] PATTERN PROCESSING
         ⍝ -------------------------------------------------------------------------
              processDirectives←{
                  T F S←1 0 ¯1       ⍝ true, false, skip
                  lineNum+←1
                  f0 f1 f2 f3 f4←⍵ ∆FLD¨0 1 2 3 4
                  case←⍵.PatternNum∘∊
                  TOP←⊃⌽stack     ⍝ TOP can be T(true) F(false) or S(skip)...
     
             ⍝  Any non-directive, i.e. APL statement, comment, or blank line...
                  case cOTHER:{
                      T≠TOP:annotate f0,SKIP        ⍝ See annotate, QUIET
                      str←preEval f0
                      QUIET:str ⋄ str≡f0:str
                      '⍝',f0,YES,NL,' ',str
                  }0
     
              ⍝ ::IFDEF/IFNDEF name
                  case cIFDEF:{
                      T≠TOP:annotate f0,SKIP⊣stack,←S
                      stack,←c←~⍣(1∊'nN'∊f1)⊣isDefined f2
                      annotate f0,' ➡ ',(⍕c),(c⊃NO YES)
                  }0
     
              ⍝ ::IF cond
                  case cIF:{
                      T≠TOP:annotate f0,SKIP⊣stack,←S
                      stack,←c←∆TRUE(e←preEval f1)
                      annotate f0,' ➡ ',(⍕e),' ➡ ',(⍕c),(c⊃NO YES)
                  }0
     
             ⍝  ::ELSEIF
                  case cELSEIF:{
                      S=TOP:annotate f0,SKIP⊣stack,←S
                      T=TOP:annotate f0,NO⊣(⊃⌽stack)←F
                      (⊃⌽stack)←c←∆TRUE(e←preEval f1)
                      annotate f0,' ➡ ',(⍕e),' ➡ ',(⍕c),(c⊃NO YES)
                  }0
     
              ⍝ ::ELSE
                  case cELSE:{
                      S=TOP:annotate f0,SKIP⊣stack,←S
                      T=TOP:annotate f0,NO⊣(⊃⌽stack)←F
                      (⊃⌽stack)←T
                      annotate f0,' ➡ 1',YES
                  }0
     
              ⍝ ::END(IF(N)(DEF))
                  case cEND:{
                      stack↓⍨←¯1
                      c←S≠TOP
                      0=≢stack:annotate'   ⍝??? ',f0,NO⊣stack←,0⊣print'INVALID ::END statement at line [',lineNum,']'
                      annotate f0
                  }0
     
              ⍝ Shared code for
              ⍝   ::DEF(Q) and ::(E)VALQ
                  procDefVal←{
                      isVal←⍵
                      T≠TOP:annotate f0,(SKIP NO⊃⍨F=TOP)
                      ' '∊f2:annotate f0,'    ⍝ ',print'IGNORING INVALID MACRO NAME: "',f2,'" ',NO
                      qtFlag arrFlag←0≠≢¨f1 f3
     
                      val note←f2{
                          (~arrFlag)∧0=≢⍵:(∆QTX ⍺)''
                          0=≢⍵:'' '  [EMPTY]'
                          exp←preEval ⍵
     
                          isVal:{                   ⍝ ::EVAL | ::VAL
                              m←'WARNING: INVALID EXPRESSION DURING PREPROCESSING'
                              0::(⍵,' ∘∘INVALID∘∘')(m⊣print m,': ',⍵)
                              qtFlag:(∆QTX⍕⍎⍵)''
                              (⍕⍎⍵)''
                          }exp
     
                          qtFlag:(∆QTX exp)''       ⍝ ::DEFQ ...
                          exp''                     ⍝ ::DEF  ...
                      }f4
                      _←put f2 val
                      nm←PREFIX,(isVal⊃'DEF' 'VAL'),qtFlag/'Q'
                      f0 annotate nm,' ',f2,' ← ',f4,' ➡ ',val,note,' ',YES
                  }
     
             ⍝ ::DEF family: Definitions after macro processing.
             ⍝ ::DEF | ::DEFQ
             ⍝ ::DEF name ← val    ==>  name ← 'val'
             ⍝ ::DEF name          ==>  name ← 'name'
             ⍝ ::DEF name ← ⊢      ==>  name ← '⊢'     Make name a NOP
             ⍝ ::DEF name ←    ⍝...      ==>  name ← '   ⍝...'
             ⍝   Define name as val, unconditionally.
             ⍝ ::DEFQ ...
             ⍝   Same as ::DEF, except put the value in single-quotes.
                  case cDEF:procDefVal 0
     
             ⍝  ::VAL family: Definitions from evaluating after macro processing
             ⍝  ::EVAL | ::EVALQ
             ⍝  ::VAL  | ::VALQ   [aliases for EVAL/Q]
             ⍝  ::[E]VAL name ← val    ==>  name ← ⍎'val' etc.
             ⍝  ::[E]VAL i5   ← (⍳5)         i5 set to '(0 1 2 3 4)' (depending on ⎕IO)
             ⍝    Returns <val> executed in the caller namespace...
             ⍝  ::EVALQ: like EVAL, but returns the value in single quotes.
             ⍝    Experimental preprocessor-time evaluation
                  case cVAL:procDefVal 1
     
             ⍝ ::CDEF family: Conditional Definitions
             ⍝ ::CDEF name ← val      ==>  name ← 'val'
             ⍝ ::CDEF name            ==>  name ← 'name'
             ⍝ Set name to val only if name NOT already defined.
             ⍝ ::CDEFQ ...
             ⍝ Like ::CDEF, but returns the value in single quotes.
                  case cCDEF:{
                      T≠TOP:annotate f0,(SKIP NO⊃⍨F=TOP)
                      isDefined f2:annotate f0,NO      ⍝ If <name> defined, don't ::DEF...
                      qtFlag arrFlag←0≠≢¨f1 f3
                      val←f2{(~arrFlag)∧0=≢⍵:∆QTX ⍺ ⋄ 0=≢⍵:''
                          exp←preEval ⍵
                          qtFlag:∆QTX exp
                          exp
                      }f4
                      _←put f2 val
                      f0 annotate PREFIX,'CDEF ',f2,' ← ',f4,' ➡ ',val,(' [EMPTY] '/⍨0=≢val),' ',YES
                  }0
     
              ⍝ ::UNDEF - undefines a name set via ::DEF, ::VAL, ::STATIC, etc.
              ⍝ ::UNDEF name
              ⍝ Warns if <name> was not set!
                  case cUNDEF:{
                      T≠TOP:annotate f0,(SKIP NO⊃⍨F=TOP)
                      _←del f1⊣{isDefined ⍵:'' ⋄ print INFO,' UNDEFining an undefined name: ',⍵}f1
                      annotate f0,YES
                  }0
     
              ⍝ ::STATIC - declares persistent names, defines their values,
              ⍝            executes code @ preproc time.
              ⍝   1) declare names that exist between function calls. See ⎕MY/∆MY
              ⍝   2) create preproc-time static values,
              ⍝   3) execute code at preproc time
              ⍝      Dyalog user commands are of the form:  ]user_cmd or ]name ← user_cmd
                  case cSTAT:{
                      T≠TOP:annotate f0,(SKIP NO⊃⍨F=TOP)
                      usr nm arrow←f1 f2 f3      ⍝  f1: ]user_cmd, f2 f3: name ←
                      val←{
                  ⍝ [1a] Expand any code that is not prefixed ]...
                          0=≢usr:preEval f4     ⍝ User command?
                  ⍝ [1b] Expand ::STATIC ]user code
                  ⍝ Handle User commands by decoding any assignment ]name←val
                  ⍝ and setting up ⎕SE.UCMD wrt namespace ∆MY.
                          _←∆MY,' ⎕SE.UCMD ',∆QTX nm,arrow,f4     ⍝ ]name ← val or  ]val
                          nm∘←arrow∘←''
                          _
                      }0
                  ⍝ If the expansion to <val> changed <f4>, note in output comment
                      expMsg←''(' ➡ ',val)⊃⍨val≢f4
     
                  ⍝[2] Evaluate ::STATIC apl_code and return.
                      0=≢nm:(annotate f0,expMsg,okMsg),more⊣(okMsg more)←{
                          0::NO({
                              invalidE←'∆PRE ::STATIC WARNING: Unable to execute expression'
                              _←NL,'⍝>  '
                              _,←print invalidE,NL,'⍝>  ',⎕DMX.EM,' (',⎕DMX.Message,')',NL
                              _,←'∘static err∘'
                              _
                          }0)
                          YES''⊣∆MYR⍎val,'⋄1'
                      }0
                  ⍝ Return if apl_code, i.e. NOT a name declaration (with opt'l assignment)
     
                  ⍝[3a] Process ::STATIC name          - declaration
                  ⍝[3b] Process ::STATIC name ← value  - declaration and assignment
     
                  ⍝ isFirstDef: Erase name only if first definition and
                  ⍝             not an absolute var, i.e. prefixed with # or ⎕ (⎕SE)
                      isFirstDef←⍬⍴(isNew←~isDefined nm)∧~'#⎕'∊⍨1↑nm
     
                  ⍝ Warn if name has been redeclared (and possibly reevaluated) in this session
                      _←{⍵:''
                          _←dPrint'Note: STATIC "',nm,': has been redeclared'
                          0≠≢val:dPrint'>     Value now "',val,'"'
                          ''
                      }isNew
                    ⍝ Register <nm> as if user ⎕MY.nm; see ⎕MY/∆MY.
                    ⍝ Wherever it is used in subsequent code, it's as if calling:
                    ⍝   ::DEF nm ← ⎕MY.nm
                      _←put nm(myNm←∆MY,'.',nm)
     
                   ⍝ If the name <nm> is undefined (new), we'll clear out any old value,
                   ⍝ e.g. from prior calls to ∆PRE for the same function/object.
                   ⍝ print: assigning names with values across classes is not allowed in APL or here.
                      _←∆MYR.⎕EX⍣isFirstDef⊣nm
     
                      okMsg errMsg←{
                          0=≢arrow:YES''
                          0::NO({
                              invalidE←'∆PRE ',PREFIX,'STATIC WARNING: Unable to execute expression'
                              _←NL,'⍝>  '
                              _,←print(invalidE,NL,'⍝>  ',⎕DMX.EM,' (',⎕DMX.Message,')'),NL
                              _,←'∘static err∘'
                              _
                          }0)
                          YES''⊣∆MYR⍎nm,'←',val,'⋄1'
                      }0
                      _←annotate f0,expMsg,okMsg
                      _,errMsg
                  }0
     
              ⍝ ::INCLUDE - inserts a named file into the code here.
              ⍝ ::INCLUDE file or "file with spaces" or 'file with spaces'
              ⍝ If file has no type, .dyapp [dyalog preprocessor] or .dyalog are assumed
                  case cINCL:{
                      T≠TOP:annotate f0,(SKIP NO⊃⍨F=TOP)
                      funNm←∆UNQ f1
                      _←dPrintQ INFO,2↓(bl←+/∧\f0=' ')↓f0
                      (_ fullNm dataIn)←getDataIn funNm
                      _←dPrintQ',',msg←' file "',fullNm,'", ',(⍕≢dataIn),' lines',NL
     
                      _←fullNm{
                          includedFiles,←⊂⍺
                          ~⍵∊⍨⊂⍺:⍬
                      ⍝ See ::extern __INCLUDE_LIMITS__
                          count←+/includedFiles≡¨⊂⍺
                          warn err←(⊂INFO,PREFIX,'INCLUDE '),¨'WARNING: ' 'ERROR: '
                          count≤1↑__INCLUDE_LIMITS__:⍬
                          count≤¯1↑__INCLUDE_LIMITS__:print warn,'File "',⍺,'" included ',(⍕count),' times'
                          11 ⎕SIGNAL⍨err,'File "',⍺,'" included too many times (',(⍕count),')'
                      }includedFiles
                      includeLines∘←dataIn
                      annotate f0,' ',INFO,msg
                  }0
     
              ⍝ ::IMPORT name [extern_name]
              ⍝ Imports name (or, if extern_name specified: imports extern_name as name)
              ⍝ Reads in the value of a variable, then converts it to a value.
              ⍝ If its format is unusable (e.g. in a macro), that's up to the user.
                  case cIMPORT:{
                      f2←f2 f1⊃⍨0=≢f2
                      T≠TOP:annotate f0,(SKIP NO⊃⍨F=TOP)
                      info←' ','[',']',⍨{
                          0::'UNDEFINED. ',(∆DQT f2),' NOT FOUND',NO⊣del f1
                          'IMPORTED'⊣put f1(CALLER.⎕OR f2)
                      }⍬
                      annotate f0,info
                  }⍬
     
              ⍝ ::TRANS / ::TR - translate a single character on input.
              ⍝ ::TRANS ⍺ ⍵    Translate char ⍺ to ⍵
              ⍝ Affects only user code ('macro' scanning)
                  case cTRANS:{
                      T≠TOP:annotate f0,(SKIP NO⊃⍨F=TOP)
                      info←''
                      f1 f2←{
                          0::¯1
                          0=≢⍵:¯1 ⋄ info,←' →'/⍨0≠≢info
                          (1=≢⍵)∧⍵≡,'\':' '⊣info,←' " " U+32'             ⍝ \ch2    (ch2=' ')
                          1=≢⍵:⍵⊣info,←' U+',⍕⎕UCS ⍵                      ⍝ ch1
                          c←⍵↓⍨esc←'\'=⊃⍵
                          ⋄ escC←esc∧(~⎕D∊⍨⊃c)∧1=≢c
                          escC:c⊣info,←' U+',⍕⎕UCS c                      ⍝ \c, ~(c∊⎕D)
                          ⋄ hex←1∊'xX'∊⍵
                          c←⎕UCS u←hex{⍺:∆H2D ⍵ ⋄ ⍎⍵}c                    ⍝ \dd or dd
                          info,←hex/' U+',⍕u
                          u≥32:c⊣info,←' "',c,'"'                ⍝ digits  (from hex/dec)
                          c⊣info,←' [ctl]'                       ⍝ digits  (ctl char)
                      }¨f1 f2
                      ¯1∊f1 f2:(annotate f0),NL,'∘',(print f0,NL)⊢print'∆PRE ',PREFIX,'TRANS ERROR'
                      (translateIn translateOut)∘←f1 f2
                      annotate f0,' ⍝ ',info
                  }⍬
              }
     
           ⍝ --------------------------------------------------------------------------------
           ⍝ EXECUTIVE
           ⍝ --------------------------------------------------------------------------------
           ⍝ User-settable options
           ⍝ See HELP info above
           ⍝ See below
           ⍝ Set prepopulated macros
              mNames←mVals←mNameVis←⍬
              _←0 put'__DEBUG__'__DEBUG__            ⍝ Debug: set in options or caller env.
              _←0 put'__VERBOSE__'__VERBOSE__
              _←0 put'__MAX_EXPAND__' 10             ⍝ Allow macros to be expanded 10 times if changes occurred...
              _←0 put'__MAX_PROGRESSION__' 500       ⍝ ≤500 expands at preproc time.
              _←0 put'__INCLUDE_LIMITS__'(5 10)      ⍝ [0] warn limit [1] error limit
           ⍝ Other user-oriented macros
              _←0 put'⎕UCMD' '⎕SE.UCMD'              ⍝ ⎕UCMD 'box on -fns=on' ≡≡ ']box on -fns=on'
              _←0 put'⎕DICT' 'SimpleDict '           ⍝ d← {default←''} ⎕DICT entries
                                                    ⍝ entries: (key-val pairs | ⍬)
              _←0 put'⎕FORMAT' '∆format'             ⍝ Requires ∆format in ⎕PATH...
              _←0 put'⎕F' '∆format'                  ⍝ ⎕F → ⎕FORMAT → ∆format
              _←0 put'⎕EVAL' '⍎¨0∘∆PRE '
     
           ⍝ Read in data file...
              funNm fullNm dataIn←getDataIn(⊆⍣(~FIX))⍵
              tmpNm←'__',funNm,'__'
     
           ⍝ Set up ⎕MY("static") namespace, local to the family of objects in <funNm>
           ⍝ Then set up FIRST, which is 1 the first time ANY function in <funNm> is called.
              ∆MY←''⎕NS⍨(⍕CALLER),'.⍙⍙.',funNm,'.∆MY'
              _←{
                  0=≢list←∆MY.⎕NL-⍳10:0
                  _←print PREFIX,'STATIC variables for ',(⍕CALLER),'.',funNm,'exists'
                  1⊣print'  Variables:',∊' ',¨list
              }
              (∆MYR←⍎∆MY)._FIRST_←1
              _←∆MYR.⎕FX'F←FIRST' '(F _FIRST_)←_FIRST_ 0'
              _←∆MYR.⎕FX'{F}←RESET' '(F _FIRST_)←~_FIRST_ 0'
              _←0 put'⎕MY'∆MY                    ⍝ ⎕MY    → a private 'static' namespace
              _←0 put'⎕FIRST'(∆MY,'.FIRST')      ⍝ ⎕FIRST → ∆MY.FIRST
     
     
           ⍝ Other Initializations
              stack←,1 ⋄ lineNum←0
              includedFiles←⊂fullNm
              translateIn←translateOut←⍬                 ⍝ None
              NLINES←≢dataIn ⋄ NWIDTH←⌈10⍟NLINES
              _←dPrint'Processing input object ',(∆DQT funNm),' from file ',∆DQT fullNm
              _←dPrint'Object has ',NLINES,' lines'
              dataFinal←⍬
              includeLines←⍬
              comment←⍬
     
           ⍝ --------------------------------------------------------------------------------
           ⍝ Executive: Phase I
           ⍝ --------------------------------------------------------------------------------
           ⍝ Kludge: We remove comments from all directives up front...
           ⍝ Not ideal, but...
              pInDirectiveE←'^\h*\Q',PREFIX,'\E'
              inDirective←0
           ⍝ Process double quotes and continuation lines that may cross lines
              pNotInSetP←⎕UCS 8713
              phaseI←pInDirectiveE pDQ3e pDQe pSQe pCommentE pContE pZildeE pEOLe pNotInSetP ⎕R{
                  cInDirective cDQ3e cDQ cSQ cCm cCn cZilde cEOL cNotInSet←⍳9
                  f0 f1 f2←⍵ ∆FLD¨0 1 2 ⋄ case←⍵.PatternNum∘∊
     
              ⍝  spec←⍵.PatternNum⊃'Spec' 'Std' 'DQ' 'SQ' 'CM' 'CONT' 'EOL'
              ⍝  print (¯4↑spec),': f0="',f0,'" inDirective="',inDirective,'"'
                  case cInDirective:f0⊣inDirective⊢←1
                  case cDQ3e:' '                             ⍝ """..."""
                  case cDQ:processDQ f1 f2                   ⍝ DQ, w/ possible newlines...
                  case cSQ:{                                 ⍝ SQ  - passthru, unless newlines...
                      ~NL∊⍵:⍵
                      _←print'WARNING: Newlines in single-quoted string are invalid: treated as blanks!'
                      _←print'String: ','⤶'@(NL∘=)⍵
                      ' '@(NL∘=)⍵
                  }f0
                  case cCm:f0/⍨~inDirective                  ⍝ COM - passthru, unless in std directive
                  case cCn:' '⊣comment,←(' '/⍨0≠≢f1),f1      ⍝ Continuation
                  case cZilde:' ⍬ '                          ⍝ Normalize as APL would...
                  case cNotInSet:'{~⍺∊⍵}'
                ⍝ case 4: EOL triggers comment processing from above
                  ~case cEOL:⎕SIGNAL/'∆PRE: Logic error' 911
                  inDirective⊢←0                                ⍝ Reset  flag after each NL
                  0=≢comment:f0
                  ln←comment,' ',f1,NL ⋄ comment⊢←⍬
              ⍝ If the commment is more than (⎕PW÷2), put on newline
                  (' 'NL⊃⍨(⎕PW×0.5)<≢ln),1↓ln
              }⍠('Mode' 'M')('EOL' 'LF')('NEOL' 1)⊣preamble,dataIn
           ⍝ Process macros... one line at a time, so state is dependent only on lines before...
              phaseI←{⍺←⍬
                  0=≢⍵:⍺
                  line←⊃⍵
                  line←patternList ⎕R processDirectives⍠'UCP' 1⊣line
                  (⍺,⊂line)∇(includeLines∘←⍬)⊢includeLines,1↓⍵
              }phaseI
     
           ⍝ --------------------------------------------------------------------------------
           ⍝ Executive: PhaseII
           ⍝ --------------------------------------------------------------------------------
           ⍝ condSave ⍵:code
           ⍝    ⍺=1: Keep __name__ (on error path or if __DEBUG__=1)
           ⍝    ⍺=0: Delete __name__ unless error (not error and __DEBUG__=0)
           ⍝ Returns ⍵ with NULLs removed...
              condSave←{⍺←EDIT∨__DEBUG__
                  _←⎕EX tmpNm
                  ⍺:⍎'CALLER.',tmpNm,'←⍵~¨NULL'
                  ⍵
              }
           ⍝ ERROR PATH
              999::11 ⎕SIGNAL⍨{
                  _←1 condSave ⍵
                  _←'Preprocessor error. Generated object for input "',funNm,'" is invalid.',⎕TC[2]
                  _,'See preprocessor output: "',tmpNm,'"'
              }phaseI
              phaseII←condSave phaseI
           ⍝ Edit (for review) if EDIT=1
              _←CALLER.⎕ED⍣EDIT⊣tmpNm ⋄ _←⎕EX⍣(EDIT∧~__DEBUG__)⊣tmpNm
              phaseII←{NULL~⍨¨⍵/⍨NULL≠⊃¨⍵}{
                  ⋄ opts←('Mode' 'M')('EOL' 'LF')
               ⍝ We have embedded newlines for lines with macros expanded: see annotate
               ⍝ [a] ⎕R handles them (per EOL LF). See [b]
                  NOCOM:'^\h*(?:⍝.*)?$'⎕R NULL⍠opts⊣⍵    ⍝ Remove blank lines and comments.
                  NOBLANK:'^\h*$'⎕R NULL⍠opts⊣⍵          ⍝ Remove blank lines
               ⍝ [b] Explicitly handle embedded NLs
                  {⊃,/NL(≠⊆⊢)¨⍵}⍵
              }phaseII
              FIX:_←2 CALLER.⎕FIX phaseII
              phaseII
          }⍵
      }lines
    ∇

  ⍝H ∆PRE    20190711
  ⍝H - Preprocesses contents of codeFileName (a 2∘⎕FIX-format file) and fixes in
  ⍝H   the workspace (via 2 ⎕FIX ppData, where ppData is the processed version of the contents).
  ⍝H - Returns: (shyly) the list of objects created (possibly none).
  ⍝H
  ⍝H names ← [⍺:opts preamble1 ... preambleN] ∆PRE ⍵:(codeFileName | strings[] | ⎕NULL)
  ⍝H
  ⍝H ---------------------------------------------------------
  ⍝H   ⍺
  ⍝H OPTIONS
  ⍝H (Defaults):
  ⍝H    -noV -D -noE -C -noH
  ⍝H -V | -noV   __VERBOSE__, include directives and status in output code.
  ⍝H   Default: -V  (Also a R/W macro)
  ⍝H -D | -noD   __DEBUG__, add annotations to ⎕ (stdout)
  ⍝H   Default: -noD    (Also a R/W macro)
  ⍝H -E | -noE   EDIT, look at annotated preprocessed intermediate file
  ⍝H   Default: -noE, except as below
  ⍝H            -E, if ⍵ (right argument) is ⎕NULL
  ⍝H -noC        NOCOM, remove all comment lines and blank lines
  ⍝H   Default: (-C)
  ⍝H -noB        NOBLANK, remove blank lines
  ⍝H   Default: (-B)
  ⍝H -H          HELP, show help info, ignoring ⍵ (right arg)
  ⍝H   Default: (-noH)
  ⍝H -F | -noF   FIX, i.e. do 2 ⎕FIX on the generated code (fns and namespaces)
  ⍝H   Default: (-F)
  ⍝H   With -noF,
  ⍝H     the right argument is assumed to be 0 or more code lines, never
  ⍝H     a file specification; it is used for preprocessing a sequence of code lines
  ⍝H     for dynamic use, e.g. in ∆PRE itself...
  ⍝H     If -noF is specified, the result of the preprocessing is returned.
  ⍝H     ⍵ may be a single char vector or a vector of (char) vectors.
  ⍝H Special options:
  ⍝H   0:  Same as: -noF[ix] -noC[omments] -noV[erbose] -noD[ebug]
  ⍝H       Used internally for the ⎕EVAL macro:  (⎕EVAL string) ←==→ (⍎¨0∘∆PRE string)
  ⍝H
  ⍝H Debugging Flags
  ⍝H    If CALLER.∆PRE_DEBUG is defined (CALLER: the namespace from which ∆PRE was called),
  ⍝H           then __DEBUG__ mode is set, even if the 'D' flag is not specified.
  ⍝H           unless 'Q' (quiet) mode is set explicitly.
  ⍝H           debugmode:  (__DEBUG__∨D)∧~Q
  ⍝H    If __DEBUG__ mode is set,
  ⍝H           internal macro "variable" __DEBUG__ is defined (DEF'd) as 1, as if:
  ⍝H                 ::VAL __DEBUG__ ← (__DEBUG__∨option_D)∧~option_Q   ⍝ Pseudocode...
  ⍝H           In addition, Verbose mode is set.
  ⍝H    Otherwise,
  ⍝H           Internal flag variable __DEBUG__ is defined as 0.
  ⍝H           Verbose mode then depends on the 'V' flag (default is 1).
  ⍝H
  ⍝H    Use ::IF __DEBUG__ etc. to change preprocessor behavior based on debug status.
  ⍝H
  ⍝H
  ⍝H ---------------------------------------------------------
  ⍝H   ⍺
  ⍝H  (1↓⍺): preamble1 ... preambleN
  ⍝H ---------------------------------------------------------
  ⍝H    Zero or more lines of a preamble to be included at the start,
  ⍝H    e.g. ⍺ might include definitions to "import"
  ⍝H         'V' '::DEF PHASE1' '::DEF pi ← 3.13'
  ⍝H          ↑   ↑__preamble1   preamble2
  ⍝H          ↑__ option(s)
  ⍝H
  ⍝H ---------------------------------------------------------------------------------
  ⍝H  ⍵
  ⍝H   [1] ⍵:codeFN   The filename of the function, operator, namespace, or set of objects
  ⍝H   [2] ⍵:str[]    A vector of strings, defining one or more fns, ops or namesoaces,
  ⍝H                  in 2∘⎕FIX-format.
  ⍝H       If ⍺ has the -noFix option (or is 0), ⍵ is converted to a vect of vectors,
  ⍝H       if needed, i.e. ⍵ is passed as if ⊆⍵.
  ⍝H   [3] ⍵:⎕NULL    Prompt for lines from the user, creating pseudo-function
  ⍝H                  __PROMPT__
  ⍝H ---------------------------------------------------------------------------------
  ⍝H
  ⍝H    [1] The simple name, name.ext, or full filename
  ⍝H    of the function or cluster of objects compatible with (2 ⎕FIX ⍵),
  ⍝H    whose source will be loaded from:
  ⍝H      [a] if ⍵ has no filetype/extension,
  ⍝H             ⍵.dyapp,
  ⍝H          or (if not found in ⍵.dyapp),
  ⍝H             ⍵.dyalog
  ⍝H      [b] else
  ⍝H             ⍵ by itself.
  ⍝H    These directories are searched:
  ⍝H           .  ..  followed by dirs named in env vars FSPATH and WSPATH (: separates dirs)
  ⍝H -----------
  ⍝H + Returns +
  ⍝H -----------
  ⍝H Returns (shyly) the names of the 0 or more objects fixed via (2 ⎕FIX code).
  ⍝H
  ⍝H ---------------------------------------------------------------------------------
  ⍝H Features:
  ⍝H ---------------------------------------------------------------------------------
  ⍝H   ∘ Implicit macros
  ⍝H     ∘ HEXADECIMALS: Hex number converted to decimal
  ⍝H             0FACX /[\d][\dA-F]*[xX]/
  ⍝H     ∘ BIG INTEGERS: Big integers (of any length) /¯?\d+[iI]/ are converted to
  ⍝H             quoted numeric strings for use with Big Integer routines.
  ⍝H             04441433566767657I →  '04441433566767657'
  ⍝H       Big Integers may have non-negative exponents, but no decimals.
  ⍝H       The exponents simply add trailing zeros. E.g. 123 with 100 trailing zeros:
  ⍝H            123E100I  ==>   12300000[etc.]00000
  ⍝H     ∘ PROGRESSIONS: num1 [num2] .. num3    OR   'c' 'd' .. 'e'  [where c,d,e are chars]
  ⍝H                                            OR   'cd' .. e
  ⍝H             Progressions use either the ellipsis char (…) or 2 or more dots (..).
  ⍝H         With Numbers
  ⍝H             Creates a real-number progression from num1 to num3
  ⍝H             with delta (num2-num1), defaulting to 1 or ¯1.
  ⍝H             With constants  (10 0.5 .. 15), the progression is calculated at
  ⍝H             preprocessor time; with variables, a DFN is inserted to calculate at run time.
  ⍝H             Example:  :FOR i :in 1 1.5 .. 100  ==> :FOR i :in 1 1.5 2 2.5 [etc.] 99.5 100
  ⍝H             Example:  :FOR i :in a b   .. 100  ==> :FOR i :in a b {progressn dfn} c
  ⍝H         With Characters
  ⍝H             Creates a progression from char1 to char3 (with gaps determined by char2-char1)
  ⍝H                'a'..'h'         ==> 'abcdefgh'
  ⍝H                'a' 'c' .. 'h'   ==> 'aceg'
  ⍝H                'ac'..'h'        ==> 'aceg'
  ⍝H                'h'..'a'         ==> 'hgfedcba'
  ⍝H       Note: Progressions with constants that are too large (typically 500) are
  ⍝H             not expanded, but calculated at run time. This saves on ⎕FIX-time storage and
  ⍝H             perhaps editing awkwardness.
  ⍝H             Example:  :FOR i :in 1..10000  ==> :FOR i :in 1 {progressn dfn}10000
  ⍝H             See __MAX_PROGRESSION__ below to change this behavior.
  ⍝H     ∘ MAPS: word1 word2 ... wordN → anything
  ⍝H             where word1 is
  ⍝H                   a name (a sequence of one or morePCRE letter or _⍙∆),
  ⍝H                   an APL number, or ⍬ or ();
  ⍝H             such that numbers are left as is, but names are quoted:
  ⍝H               func (name → 'John Smith', age → 25, code 1 → (2 3⍴⍳6)) ==>
  ⍝H               func (('name')'John Smith'),('age')25,('code' 1)(2 3⍴⍳6).
  ⍝H             Each word in
  ⍝H                word w 123.4 ⍬ a_very_long_word → value
  ⍝H             is replaced as follows:
  ⍝H               word             →  'word'
  ⍝H               w                →  (,'w')
  ⍝H               123.4            →  (,123.4)
  ⍝H               ⍬ or ()          →  ⍬
  ⍝H               a_very_long_word → 'a_very_long_word'
  ⍝H             What's returned is
  ⍝H               (⊆'word' (,'w') (,123.4) ⍬ 'a_very_long_word')
  ⍝H
  ⍝H        Special MAPS:
  ⍝H               name →→ val      =>    ('name'),val
  ⍝H         Note: name1 name2 →→val is the same as name1 name2 → val
  ⍝H     ∘ ATOMS: `word1 word2 ... wordN
  ⍝H             as for MAPS, as in:
  ⍝H                `red orange  02FFFEX green ==>
  ⍝H                ('red' 'orange' 196606 'green')      ⍝ Hex number converted to decimal
  ⍝H             Each word in
  ⍝H                `word w 123.4 ⍬ a_very_long_word
  ⍝H             as in MAPS example above.
  ⍝H
  ⍝H        Special ATOMS: `` word   =>   ('word') rather than (⊆'word')
  ⍝H                 Note: `` word1 word2 is the same as ` word1 word2.
  ⍝H
  ⍝H   ∘ explicit macros for text replacement
  ⍝H       See ::DEF, ::CDEF
  ⍝H   ∘ continuation lines end with .. (either the ellipsis char. or 2 or more dots),
  ⍝H     possibly with a preceding comment. In the output file, the lines are
  ⍝H     connected with the set of comments on the continuation lines on the last line
  ⍝H     or (if large) the following (otherwise blank) line
  ⍝H       vec←  1  2  3  4   5 ...   ⍝ Line 1
  ⍝H            ¯1 ¯2 ¯3 ¯4  ¯5 ..    ⍝ Line 2
  ⍝H            60 70 80 90 100       ⍝ Last line
  ⍝H     ==>
  ⍝H       vec← 1 2 3 4 5  ¯1 ¯2 ¯3 ¯4 ¯5 60 70 80 90 100
  ⍝H       ⍝ Line 1 ⍝ Line 2 ⍝ Last line
  ⍝H
  ⍝H   Double-Quoted (Multi-line Capable) Strings
  ⍝H   ------------------------------------------
  ⍝H   ∘ Double quoted strings under options M (default) or S.
  ⍝H     These may appear on one or more lines. By default, leading blanks on
  ⍝H     continuation lines are ignored, allowing follow-on lines to easily line up
  ⍝H     under the first line. (See the DQ Raw suffix below).
  ⍝H     A string may be forced to M or S mode by an M or S suffix, ignoring options M or S.
  ⍝H     Example:
  ⍝H       str←"This is line 1.     strM←"This is line 1.      strS←"This is line 1.
  ⍝H            This is line 2.           This is line 2.            This is line 2.
  ⍝H            This is line 3."          This is line 3."M          This is line 3."S
  ⍝H   ==>
  ⍝H   option 'M':
  ⍝H       str← 'This is line 1.' 'This is line 2.' 'This is line 3.'
  ⍝H   option 'S':
  ⍝H       str← ('This is line 1.',CR,'This is line 2.',CR,'This is line 3.')
  ⍝H   Regardless of option 'M' vs 'S':
  ⍝H       strM←'This is line 1.' 'This is line 2.' 'This is line 3.'
  ⍝H       strS←('This is line 1.',CR,'This is line 2.',CR,'This is line 3.')
  ⍝H
  ⍝H   ∘ Double-Quoted Raw Suffix:
  ⍝H     Double-quoted strings followed (w/o spaces) by the R (raw) suffix will NOT have
  ⍝H     leading spaces on continuation lines removed.
  ⍝H     Options M and S (above) are both supported.
  ⍝H        "This is a
  ⍝H         raw format
  ⍝H        double string."
  ⍝H      ==>  (option 'M')
  ⍝H        'This is a' '      raw format' 'double string.'
  ⍝H
  ⍝H    Triple-double quotes.  """ ... """
  ⍝H      Triple-double quoted expressions may appear on one or more lines.
  ⍝H      They are not strings, but comments, resolving to a single comment.
  ⍝H          1 + """This is a triple-quote that
  ⍝H                 is treated as a silly comment""" 4
  ⍝H      ==>
  ⍝H          1 +  4
  ⍝H
  ⍝H    Directives
  ⍝H    ----------
  ⍝H    ::IF, ::IFDEF, ::IFNDEF
  ⍝H    ::ELSEIF
  ⍝H    ::ELSE
  ⍝H    ::ENDIF
  ⍝H    ::DEF, ::DEFQ
  ⍝H    ::CDEF, ::CDEFQ
  ⍝H    ::EVAL, ::EVALQ
  ⍝H    ::TRANS
  ⍝H    ::UNDEF
  ⍝H    ::STATIC
  ⍝H    ::INCLUDE
  ⍝H    ::IMPORT
  ⍝H
  ⍝H       (Note: currently comments are removed from preprocessor directives
  ⍝H        before processing.)
  ⍝H       ::IF      cond         If cond is an undefined name, returns false, as if ::IF 0
  ⍝H       ::IFDEF   name         If name is defined, returns true even if name has value 0
  ⍝H       ::IFNDEF  name
  ⍝H       ::ELSEIF  cond
  ⍝H       ::ELIF                 Alias for ::ELSEIF
  ⍝H       ::ELSE
  ⍝H       ::END                  ::ENDIF, ::ENDIFDEF; allows ::END followed by ANY text
  ⍝H       ::DEF     name ← [VAL] VAL may be an APL code sequence, including the null string
  ⍝H                              If parens are needed, use them.
  ⍝H                              If you want to ignore lines by prefixing with comments,
  ⍝H                              use EVAL. Comments are IGNORED on directive lines, unless quoted.
  ⍝H       ::DEF     name ←       Sets name to a nullstring, not its quoted value.
  ⍝H       ::DEF     name         Same as ::DEF name ← 'name'
  ⍝H       ::DEFINE  name ...     Alias for ::DEF ...
  ⍝H       ::DEFQ    name ...     Like ::DEF except quoted evaluated string
  ⍝H       ::CDEF    name ...     Like ::DEF, except executed only if name is undefined
  ⍝H       ::[E]VAL  name ...     Same as ::DEF, except name ← ⍎val
  ⍝H       ::[E]VALQ name ...     Same as ::EVAL, except result is quoted.
  ⍝H       ∘ Note that ::DEF creates a string of code (including comments),
  ⍝H                 and is "TRUE" if it is not-null.  EVAL executes the string to determine
  ⍝H                 its value; it is true if not 0, or an object of length 0.
  ⍝H       ∘ Note: Names of the form ⎕cc..cc and :cc..ccc have their case ignored (in all other
  ⍝H         cases, case is respected). Thus, these are the same:
  ⍝H           ::DEF ⎕FRED ← 1 2 3            ::DEF :WHY ← ?
  ⍝H           ::DEF ⎕fred ← 1 2 3            ::DEF :wHy ← ?
  ⍝H           ::DEF ⎕FrEd ← 1 2 3
  ⍝H           1 + ⎕FRED <==> 1 + ⎕fReE etc.
  ⍝H
  ⍝H       ∘ To create a macro to "null out" code lines (have them ignored),
  ⍝H         you can't use ::DEF, because (visible) comments are ignored for directives.
  ⍝H         Instead, use ::VAL, which allows you to present the comment in quotes,
  ⍝H         which ::VAL will evaluate (i.e. dequote) as an actual comment sequence.
  ⍝H                      ::VAL PHASE1 ← '⍝ IGNORE PHASE1: '
  ⍝H                      PHASE1 b←do_something_with 'PHASE1'
  ⍝H         Treated as:  ⍝ IGNORE PHASE1: b←do_something_with 'PHASE1'
  ⍝H                      ::VAL PHASE2 ← ''   ⍝ Don't ignore PHASE2.
  ⍝H                                          ⍝ Or do ::DEF PHASE2←       ⍝ null "code" assigned
  ⍝H                      PHASE2 b←do_something_with 'PHASE2'
  ⍝H         Treated as:  b←do_something_with 'PHASE2'
  ⍝H
  ⍝H
  ⍝H       ::TRANS   code1 code2  Causes <code1> to be translated to <code2> in each
  ⍝H       ::TR                   line of input as it is processed.
  ⍝H                              codeN is either a single character OR
  ⍝H                                 \\   backslash
  ⍝H                                 \    space
  ⍝H                                 \dd  digits indicating unicode decimal (or dd [*])
  ⍝H                                 \ddX digits indicating unicode hexadecimal (or ddX [*])
  ⍝H                              [*] if dd or ddX is 2 or more digits.
  ⍝H       ::UNDEF   name         Undefines name, warning if already undefined
  ⍝H
  ⍝H       ::STATIC  name         Defines a name stored in ⍵.⍙⍙.∆MY (⎕MY.name),
  ⍝H                              a namespace stored in the calling namespace,
  ⍝H                              where ⍵ is the fun/obj name, right argument to ∆PRE.
  ⍝H                              Also, defines macro:
  ⍝H                                ::DEF name ← ⍵.⍙⍙.∆MY.name
  ⍝H                              so that any reference to the (simple) name <name> will
  ⍝H                              refer to the identified STATIC <name>.
  ⍝H                              <name> is erased if this is the first time it appears in a macro.
  ⍝H       ::STATIC name←val      Like ::STATIC above, but also assigns
  ⍝H                                ⍵.⍙⍙.∆MY.name ← val
  ⍝H                              val may be a single-line dfn OR an APL expression,
  ⍝H                              as long as it can be evaluated in the calling namespace
  ⍝H                              at ∆PRE preprocessor time, with whatever side effects.
  ⍝H                              If
  ⍝H                                ::STATIC now←⎕TS
  ⍝H                              then now is set at preprocessor time. This is completely
  ⍝H                              different from
  ⍝H                                ::DEF now←⎕TS
  ⍝H                              which replaces 'now" with '⎕TS' wherever it is found in
  ⍝H                              the function code to be evaluated at RUN TIME.
  ⍝H
  ⍝H                Note: Typically a STATIC name may refer to prior STATIC names,
  ⍝H                      but not run-time names in the function, since they haven't
  ⍝H                      been defined yet.
  ⍝H                Note: While STATIC names may remain across ∆PRE calls, a name's
  ⍝H                      value is erased the first time ::STATIC is executed.
  ⍝H                      This allows a name to change classes across ∆PRE calls, but
  ⍝H                      NOT within a ∆PRE sequence. E.g. this leads to an error just as in APL.
  ⍝H                          ::STATIC i1 ← 1 2 3 {⍺←⊢ ⋄ ⎕io←1 ⋄ ⍺⍳⍵} 2
  ⍝H                          ::STATIC i1 ← {⎕io←1 ⋄ ⍺⍳⍵}
  ⍝H                      In the first case, i1 is a value, the RESULT of a call; in the second,
  ⍝H                      it is a function definition.
  ⍝H       ::STATIC code
  ⍝H            Code to execute at preprocessor time for use with ::STATIC names.
  ⍝H            To ensure a name←val or name pattern is viewed as code, do (e.g.):
  ⍝H               ::STATIC ⊢some arbitrary code
  ⍝H               ::STATIC (some arbitrary code)
  ⍝H
  ⍝H       ::INCLUDE [name[.ext] | "dir/file" | 'dir/file']
  ⍝H       ::INCL    name
  ⍝H       ::IMPORT  name1 name2  Set internal name1 from the value of name2 in the calling env.
  ⍝H       ::IMPORT  name1        The value must be used in a context that makes sense.
  ⍝H                              If name2 omitted, it is the same as name1.
  ⍝H                              big←?2 3 4⍴100
  ⍝H                              big2←'?2 3 4⍴100'
  ⍝H                              ::IMPORT big
  ⍝H                              ::IF 3=⍴⍴big   ⍝ Makes sense
  ⍝H                              ⎕←big          ⍝ Will not work!
  ⍝H                              ::IMPORT big2
  ⍝H                              ⎕←big2         ⍝ Will work
  ⍝H __DEBUG__                ⍝ See __DEBUG__ above...
  ⍝H __MAX_EXPAND__←5         ⍝ Maximum times to expand macros (if 0, expansion is turned off!)
  ⍝H                          ⍝ Set via ⎕DEF __MAX_EXPAND__ ← 100
  ⍝H __MAX_PROGRESSION__←500  ⍝ Maximum expansion of constant dot sequences:  5..100 etc.
  ⍝H                          ⍝ Otherwise, does function call (to save space or preserve line size)
  ⍝H __INCLUDE_LIMITS__←5 10  ⍝ Max times a file may be ::INCLUDEd
  ⍝H                          ⍝ First # is min before warning. Second is max before error.
  ⍝H       ----------------
  ⍝H       cond: Is 0 if value of expr is 0, '', or undefined! Else 1.
  ⍝H       ext:  For ::INCLUDE/::INCL, extensions checked first are .dyapp and .dyalog.
  ⍝H             Paths checked are '.', '..', then dirs in env vars FSPATH and WSPATH.
  ⍝H

    ##.∆PRE←∆PRE

    ∇ out←scan line
      ;LAST;LBRK;LPAR;QUOT;RBRK;RPAR;SEMI
      ;cur_ch;cur_gov;deQ;enQ;inQt;stk
      ;⎕IO;⎕ML
     
      ⎕IO ⎕ML←0 1
      QUOT←'''' ⋄ SEMI←';'
      LPAR RPAR LBRK RBRK←'()[]'
      stk←⎕NS ⍬
      stk.(govern lparIx sawSemi)←,¨' ' 0 0   ⍝ stacks
      out←,''
     
      deQ←{stk.(govern lparIx sawSemi↓⍨←-⍵)}     ⍝ deQ 1|0
      enQ←{stk.((govern lparIx)sawSemi,←⍵ 0)}    ⍝ enQ gNew lNew
     
      :For cur_ch :In line
          cur_gov←⊃⌽stk.govern
          inQt←QUOT=cur_gov
          :If inQt
              deQ QUOT=cur_ch
          :Else
              :Select cur_ch
              :Case LPAR ⋄ enQ cur_ch(≢out)
              :Case LBRK ⋄ enQ cur_ch(≢out)
              :Case RPAR ⋄ out,←(1+⊃⌽stk.sawSemi)/RPAR ⋄ deQ 1 ⋄ :Continue
              :Case RBRK ⋄ deQ 1
              :Case QUOT ⋄ enQ cur_ch ¯1
              :Case SEMI
                  :Select cur_gov
                  :Case LPAR ⋄ out,←') (' ⋄ out[⊃⌽stk.lparIx]←⊂2/LPAR ⋄ (⊃⌽stk.sawSemi)←1 ⋄ :Continue
                  :Case LBRK ⍝ Not special
                  :Else ⋄ out,←') (' ⋄ (⊃stk.sawSemi)←1 ⋄ :Continue
                  :EndSelect
              :EndSelect
          :EndIf
          out,←cur_ch
      :EndFor
     
      out←∊out
      :If (⊃stk.sawSemi)     ⍝ semicolon(s) seen at top level (outside parens and brackets)
          out←'((',out,'))'
      :EndIf
    ∇
:endnamespace
