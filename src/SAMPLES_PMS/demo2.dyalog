:namespace fred
   i← 10
   j←20
:endNamespace
   
  ∇ {status}←{defLib}demo pkgs;FOUND
 ;choice;context;cur;deferDefLibResolution;dir;eLibrary;full;getInfo;inFile;inMem;inNs;inWs
 ;isInFile;isInMem;isInWs;isOnDisk;items;list;name;nc;note;ns;object;onDisk;package;path;pkg
 ;PWD;resolveLib;resolveNs;resolvePath;resolvePathUpArrow;split;splitFirst;splitLast;split1
 ;topNs;tPkgs;type;unpkg;VERBOSE;ws;xtype;xtypes;∆CALR;∆DEFLIB;∆PATH;∆WSPATH;_;_defLi
 ;⎕IO;⎕ML;⎕TRAP

⍝ ⎕FX ⊃⎕NGET 'require.dyalog' 1       - Fix a simple fn from a file (∇...∇ accepted, not required)
⍝ 2 ⎕FIX '//file:require.dyalog'     - Fix a mix of fns (∇...∇ required) and  namespaces/classes

 ⎕IO ⎕ML←0 1

⍝ ⎕TRAP←0 'C' '⎕SIGNAL/⎕DMX.(EM EN)'
 VERBOSE←1
 note←VERBOSE∘{⍺=0:_←'' ⋄ 1:⎕←⍵}
 status←⍬ ⍬    ⍝ Error msgs where a pkg is not found...

 ⍝ VALID instructions:
 ⍝   {defLib} require  package1 [package2 [... packageN]]
 ⍝      package formats:
 ⍝            [ws:][dir.]name |  [ws:]
 ⍝      package search strategy (once found, copy into <defLib>.)
 ⍝            name        caller NS, ⎕PATH ns, in $WSPATH, in local workspaces (wss)
 ⍝           :name        Same as ':name', but do not check wss.
 ⍝           dir.name     same as 'name', but search for dir.name of any complexity (a.b.c.d).
 ⍝           :dir.name    Same as 'dir.name:' but do not check wss.
 ⍝           ws:name      caller ns, ⎕PATH ns, ws <ws>.
 ⍝           ws:dir.name  caller ns, ⎕PATH ns, ws <ws> for dir.name of any complexity.
 ⍝           ws:          ws <ws>, copying everything.

 ⍝
 ⍝ <defLib>:
 ⍝     Library into which to copy or check objects.
 ⍝         If omitted, defaults to #.øLIB. If specified as '', no <LIB>. prefix is applied.
 ⍝         If the caller is in the ⎕SE session namespace, then ⎕SE.øLIB.dir or ⎕SE.dir is used, rather
 ⍝         than #.øLIB.dir or #.dir.
 ⍝    To specify a subdirectory of the library #.øLIB or ⎕SE.øLIB, use
 ⍝         ⎕LIB, e.g. '⎕LIB.dfns' require 'dfns:' copies all of dfns ws into #.øLIB.dfns.
 ⍝

 ∆CALR←(⊃⎕RSI)(⊃⎕NSI)    ⍝ ∆CALR ("caller"): Where was <require> called from?

 ⍝ Default user library...
 ⍝ Convert defLib, a ns string or reference, to a ns name, unless '' (no defLib).
 ⍝ If missing, set to default: #.øLIB or ⎕SE.øLIB (if '#'≠1↑⊃⌽∆CALR)
 ⍝ In this version, if not already a namespace, leave as a string unless actually used.
 ⍝ Errors are then deferred.
 ⍝ Added:  ⎕LIB.xxx to mean (top,'.øLIB),'.xxx', top is # or ⎕SE.
 ⍝         ⎕LIB same as default...
 deferDefLibResolution←1
 defLib←{r0 n0←∆CALR
     defdef←(top←'⎕SE' '#'⊃⍨'#'=1↑n0),'.øLIB' ⍝ "default" (primary) default...
     pfx←'⎕LIB'                      ⍝ Possible special prefix to ⍵...
    ⍝ 0::⎕SIGNAL/'require DOMAIN ERROR: Default library name invalid' 11⊣⎕←'Default library?'⍵
     0=⎕NC ⍵:⍬ defdef                ⍝ Default
     9.1=nc←r0.⎕NC⊂⍵:(⍎⍎⍵)(⍕⍎⎕OR ⍵)  ⍝ ns Ref
     val←⎕OR ⍵
     0=≢val~' ':⍬ top                ⍝ no library. Just #. or ⎕SE.
     val←{                           ⍝ Is /^⎕LIB(\.|$)/ a prefix of val?
         fnd←1=⊃pfx⍷⍵ ⋄ len←≢pfx
         fnd∧len=≢⍵:defdef
         fnd∧'.'=1↑len↓⍵:defdef,len↓⍵
         ⍵
     }val
     2.1≠nc:○err○
     nc←r0.⎕NC⊂,val                  ⍝ ns Name
     9.1=nc:(⍎val)(⍕⍎n0,'.',val)     ⍝ Active ns Name, resolved now...
     0=nc:⍬(n0,'.',val)              ⍝ Potential ns Name to be resolved later...
     ○○○
 }'defLib'

 ⍝ ∆DEFLIB will return the actual reference for defLib, creating it (if needed) when first called...
 ⎕FX'def←∆DEFLIB' '→0/⍨⍬≢def←⊃defLib' 'def←(⊃defLib)←⍎(⊃⌽defLib) (⊃∆CALR).⎕NS '''''
 ⍎(~deferDefLibResolution)/'_←∆DEFLIB'

 split←{⍺←' ' ⋄ (~⍵∊⍺)⊆⍵}
 splitFirst←{⍺←' ' ⋄ (≢⍵)>p←⍵⍳⍺:(⍵↑⍨p)(⍵↓⍨p+1) ⋄ ''⍵}
 splitLast←{⍺←' ' ⋄ 0≤p←(≢⍵)-1+⍺⍳⍨⌽⍵:(⍵↑⍨p)(⍵↓⍨p+1) ⋄ ''⍵}

 ⍝ From each item in packages of the (regexp with spaces) form:
 ⍝         (\w+:)? (\w+(\.\w+)*)\.)? (\w+)
 ⍝         ws      dir               name
 ⍝ ws may be a full string ('abc.def:'), null string (':'), or ⎕NULL (omitted).
 ⍝ dir may be a full string or null string (if omitted)
 ⍝ name must be present
 pkgs←{
     ws pkg←':'splitFirst ⍵
     dir name←'.'splitLast pkg
     ws dir name
 }¨⊆pkgs

 ⍝ resolvePath: Determines actual ordered path to search, based on ∆CALR and ⎕PATH.
 ⍝   Repeated and missing namespaces are quietly omitted from <resolvePath>.
 resolveNs←(⊃∆CALR)∘{
     6::⎕NULL
     ⍕⍺⍎⍵        ⍝ Return the actual name of the relative ns. If not valid, return ⎕NULL
 }

 resolvePathUpArrow←(⊃⌽∆CALR)∘{
  ⍝ In ⎕PATH, replace ↑ with the requisite # of levels to the top...
     ~'↑'∊⍵:⍵
     dist←¯1++/⍺='.' ⋄ p←⍵⍳'↑' ⋄ w←⍵
     ∊w⊣w[p]←⊂{⍺←'##' ⋄ ⍵>dist:⍺ ⋄ (⍺,' ',∊'##',⍵⍴⊂'.##')∇ ⍵+1}0
 }

 resolvePath←(⊃⌽∆CALR)∘{
   ⍝ requires split
   ⍝ Add in current caller namespace into internal ⎕PATH...
     ⎕NULL~⍨∪(⊂⍺),resolveNs¨split⍣(1≥|≡⍵)⊣⍵
 }

 ∆PATH←resolvePath resolvePathUpArrow ⎕PATH
 ∆WSPATH←'.'{0=≢⍵:⍺ ⋄ ⍵}':'split 2 ⎕NQ'.' 'GetEnvironment' 'WSPATH'  ⍝ path1:path2:path3...


 note'caller locn:  ',(⊃⌽∆CALR)
 note'Active ⎕PATH: ',1↓,⎕FMT ∆PATH
 note'Def lib:      ',(⊃⌽defLib),'   Resolved: ',(⍬≢⊃defLib)⊃'no' 'yes'
 note'cur work dir: ',(⊃1 ⎕NPARTS'')
 note'∆WSPATH       ',1↓,⎕FMT ∆WSPATH

 inNs←{ns←⍵ ⋄ 2=⎕NC'ns':⍺ ∇⍎ns ⋄ 2 3 4 9∊⍨ns.⎕NC ⍺}
 inFile←{~⎕NEXISTS ⍵:0 ⋄ 0≠1 ⎕NINFO ⍵}

 FOUND←{ ⍝ ∇ FOUND ⍺ ⍵ msg
     pkg msg←⍵⍵
     (⊃status),←⊂pkg,⊂msg
     ⍺ ⍺⍺ 1↓⍵
 }
⍝  Is the package in the caller's namespace?
 pkgs←{⍺←⍬
     0=≢⍵:⍺
     ws dir name←pkg←⊃⍵
     ws inNs⊃∆CALR:⍺(∇ FOUND pkg'CALLER/WS')⍵
     name inNs⊃∆CALR:⍺(∇ FOUND pkg'CALLER')⍵
     (dir≡'')∨~(dir,'.',name)inNs⊃∆CALR:(⍺,⊂pkg)∇ 1↓⍵
     ∆PATH,⍨←⊂resolveNs dir
     ⍺(∇ FOUND pkg'CALLER')⍵
 }pkgs

⍝  Is the package in the ⎕PATH?
 pkgs←∪{⍺←⍬
     0=≢⍵:⍺
     ∆PATH∘←∆PATH
     ws dir name←pkg←⊃⍵
     pkgNF←{
         0=≢⍵:1
         path←⊃⍵
         ws inNs path:0
         name inNs path:0
         dir≡'':∇ 1↓⍵
         ~(dir,'.',name)inNs path:∇ 1↓⍵
         ∆PATH,⍨←⊂resolveNs path,'.',dir
         0
     }∪∆PATH
     pkgNF:(⍺,⊂pkg)∇ 1↓⍵
     (⊃status),←⊂pkg,⊂'PATH'
     ⍺ ∇ 1↓⍵
 }pkgs

⍝ Is the ws field non-blank and is the object in the workspace named?
⍝ If there is no object named, copy the entire workspace into the ∆DEFLIB.
 pkgs←{⍺←⍬
     0=≢⍵:⍺
     ws dir name←pkg←⊃⍵
     ws≡'':(⍺,⊂pkg)∇ 1↓⍵
     ok←ws{
         0::0
         0≠≢⍵:1⊣⍵ ∆DEFLIB.⎕CY ⍺
         1⊣∆DEFLIB.(⍎⍺,'←''Workspace copied on'',⎕TS'⊣⎕CY ⍺)
     }dir,('.'/⍨dir≢''),name
     ~ok:(⍺,⊂pkg)∇ 1↓⍵
     ⍺(∇ FOUND pkg'WORKSPACE')⍵
 }pkgs


⍝  types←'' '.dyalog' '.dws'
⍝  xtypes←'DIRECTORY' 'TEXT FILE' 'WORKSPACE'
⍝  :For path :In ∆WSPATH
⍝      :For choice :In context object
⍝          :If 0=≢choice ⋄ :Continue ⋄ :EndIf
⍝          :For type xtype :InEach types xtypes
⍝              full←path,('/'/⍨0≠≢path),choice,type  ⍝ If path is null, we look in current working dir.
⍝              note 'Checking on disk: <',full,'>'
⍝              :If inFile full
⍝                  status←1 xtype choice full ⋄ :Return
⍝              :EndIf
⍝          :EndFor
⍝      :EndFor
⍝  :EndFor

⍝ Update PATH. Allow no duplicates, but names should be valid.
⍝ If the default Library was used here (defined or not), add it to the start of ⎕PATH
 :If 0≢⊃defLib ⋄ ∆PATH,⍨←⊂⊃⌽defLib ⋄ :EndIf
 (⊃∆CALR).⎕PATH←,⎕FMT resolvePath ∆PATH

 :If 0≠≢pkgs
     (⊃⌽status)←pkgs,¨⊂⊂'NOT FOUND'
 :EndIf

 note'⎕PATH now:'⎕PATH
 ∇
