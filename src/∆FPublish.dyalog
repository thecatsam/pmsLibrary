∆FPublish parms
  ; anyUpdts; copyright; docDep; force; hdr; html; libDir; libra; loader   
  ; md; mdTmp; ns; pandocBin; parmFi; pdf; pgm; pgmDep; priv; privF        
  ; privFdir; privdir; productionCode; pub; pubF; pubFdir; pubdir; quiet   
  ; readme; sideN2FN; temp; tempdir; timestamp; title; version; _          
  ; CSay; CopyFi; Delete; Diamonds; Fi; HomeDir; Hr; HtmlMacro; Macros     
  ; MacrosInSrc; Md2Html; MdPandoc2Git; NeedsUpdate; Parm; Priv; PrivF; Pub
  ; PubF; Say; Temp; Tp; UpdatePgm                                         
  ; _OptsC; _OptsM                                                         
  ; ∆F    

⍝ ∆FPublish: Update and Synchronize ∆F-related files,
⍝             resolving Html and Javascript macros into native forms.
⍝ parms:
⍝     Update*   [Noquiet* | Quiet]  [^]   update only what's necessary (q: quietly).
⍝     Force     [Noquiet* | Quiet]  [^]   force everything to update (q: quietly)
⍝     Diamonds  [Html*    | Apl]          change diamonds to (html / a: apl-format) Unicode
⍝                                         useful after adding examples to help doc.
⍝     Prompt | Help                       prompt for these responses
⍝     Exit                                Exit pgm now (useful in prompt mode)
⍝     ^                [readme.md only]   Convert sidenotes to footnotes (default: remove them).
⍝                      [other docs]       Other docs have sidenotes no matter what.
⍝     * indicates the DEFAULT option.
⍝ default parms:                           
⍝    update noquiet

  ⎕IO ⎕ML ⎕PW←0 1 200
  _OptsM←⍠('IC' 1)('Mode' 'M')('DotAll' 1)('EOL' 'LF')('NEOL' 1)
  _OptsC← ⍠('IC' 1)('Regex' 1)

⍝ Key settable parameters...
  productionCode← 1
  copyright←     '2026'
  version←       'v.0.1.1'

⍝ Constants
  timestamp←     ∊∆F'{ `⍵1 `T ⎕TS}' (productionCode⊃ '%ISO%' 'YYYY-MM-DD') 
  title←         '∆F F-string Utility for Dyalog APL (v.',version,')'

⍝ Setup Parm (parameter check) and generate quiet option.
  Parm←(⎕C parms)∘{⍵∊⍺}
  quiet←Parm 'q'

⍝ Minor utilities
⍝ CSay: Print ⍵ only if ~quiet.
  CSay←quiet∘{~⍺:_←⎕←⍵ ⋄ 1:_←⍵}
⍝ Say: If quiet=0, output with "flag" prefix.  ⍺=1 ✅, 0 🛈 , ¯1 ❗          
  Say←{⍺←0 ⋄ m←'❗🛈✅'⊃⍨1+⍺ ⋄ CSay m,' ',⍵}     
⍝ Hr: Horizontal rule 
  ⎕FX'{r}←Hr' 'r←CSay 90⍴''='''  

⍝ Full pathname to pandoc binary...
  pandocBin←'/usr/local/bin/pandoc'

⍝ Directories...
  HomeDir←  '/Users/petermsiegel/' ⎕R '~/'
  libDir←   '/Users/petermsiegel/MyDyalogLibrary/'
  tempdir←  '/Users/petermsiegel/Desktop/'             ⍝ Not currrently used!
  privFdir← libDir,'pmsLibrary/src/∆F/'
  privdir←  libDir,'pmsLibrary/src/'
  pubFdir←  libDir,'Delta.F-f.string.utility/∆F/'
  pubdir←   libDir,'Delta.F-f.string.utility/'

⍝ Our files (sans directory names)
  pgm←       '∆FUtils.dyalog'        ⍝ ∆F lib
  html←      '∆FHelp.html'           ⍝ html
  md←        '∆FHelp.md'             ⍝ markdown
  mdTmp←     'tmp_README.md'         ⍝ A temporary file!
  readme←    'README.md'             ⍝ Git README file
  hdr←       '∆FHelp_Hdr.html'       ⍝ local header file.
  loader←    '∆F.dyalog'             ⍝ ∆F bootstrap utility
  libra←     '∆FLibUtils.dyalog'     ⍝ £ library
  parmFi←    '∆FParmDefs.apla'       ⍝ 
  pdf←       '∆FHelp.pdf'            ⍝ PDF 

⍝ File specs 
  privF pubF priv pub temp← 0 1 2 3 9
  PrivF←privF,⊂    ⋄   PubF←pubF,⊂  ⋄ Priv← priv,⊂     
  Pub← pub,⊂       ⋄   Temp← temp,⊂

⍝ File pseudo-class-- generates FULL filename
  Fi←{
    typ nm←⍵ 
    typ=privF:  privFdir,nm       ⋄ typ=pubF: pubFdir,nm 
    typ=priv:   privdir,nm        ⋄ typ=pub: pubdir,nm 
    typ=temp:   tempdir,nm 
  }
⍝ Type (brief file) pseudo-class-- generates a displayable compact filename
  Tp←{
    typ nm←⍵ ⋄ typ=privF:'PRIVF/',nm   ⋄ typ=pubF: 'PUBF/',nm ⋄ typ=priv: 'PRIV/',nm 
               typ=pub:  'PUB/',nm     ⋄ typ≡temp: 'TEMP/',nm
  }

⍝ Determines 
⍝    for each file pair <p> in ⍵, 
⍝      whether (⊃p) was created after (⊃⌽p) or if one or the other does NOT exist.
  NeedsUpdate←{
    NotAfter← ≤{ a b←Fi¨⍺ ⍵
        t←⎕NEXISTS¨a b ⋄ 0∊t:0
        t←20 ⎕DT¨3 ⎕NINFO¨a b
        ⍺⍺/t
    }
    3=|≡⍵:⍺ ∇⊂⍵
    0=≢⍵:0⊣_←1 Say'Dependencies met for ',⍺⊣Hr
    bef aft←⊃⍵
    bef NotAfter aft:⍺ ∇ 1↓⍵
    _←Hr
    1⊣_←¯1 Say'Updating ',⍺,'. This dependency not met: (',')',⍨(Tp bef),' ≤ ',Tp aft
  }
⍝ Copy file in into out. If ⍺ is 0, ONLY if out is newer (even if (NeedsdUpdate ⍵) is true).
  CopyFi←{ ⍺←0 ⋄ optIn(in out)←⍺ ⍵
      optOut←optIn⊃'ReplaceIfNewer' 'Replace'
      _←(Fi out)⎕NCOPY⍠('IfExists'optOut)⊢Fi in
      ×_:_←Say'Copied ',(Tp in),' => ',(Tp out)
      1:_←¯1 Say'No need to copy ',(Tp in),' => ',(Tp out),' *** SKIPPED ***'
  }

⍝ Macros:  Process macros for std markdown and for readme.md for Github.
⍝ Macros decides to use isReadme mode if the filename includes 'readme.md' (ignore case).
  Macros←{
    io← ⍵    ⍝ Get file to read and then write

    ⍝ extern: sideN2FN
    ⍝ - See sideN2FN definition below. 
    ⍝ - sideN2FN is ignored if ~isReadme.
    isReadme←'readme.md' (1∊⍷⍥⎕C) ⊃⌽⍵
    ⍝ GitReadmeOnly: If a README.md for Github
    ⍝ This will run only if isReadme is true
    GitReadmeOnly←io {
      ~isReadme: ⍵
      ⍝ ============================================
      ⍝ Miscellany: Remove button HTML
      ⍝             set all <details> to <details open>, except leave the TOC details as is.
        in←'<button.*?</button>' '<details +id="TOC">' '<details>'         '\n(<pTbr>\s*\n)+'
        out←'⍠⍠⍠'                '&'                   '<details open>'    ''
      ⍝ <!-- gittitle ### ∆F Formatted String Literals (v.0.1.1) -->
        in,← '<GIT\h*>(.*?)</GIT\h*>'        '<NOGIT\h*>.*?</NOGIT\h*>' 
        out,←'\1'                             '' 
        Miscellany←in ⎕R out _OptsM 
        ⍝ SideN2Null: Remove sidenotes.
        SideN2Null←⍺⍺{
            _←¯1 Say'Removing sidenotes in ',Tp ⍺⍺
            in←'<∆N>.*?</∆N>'
            out←''
            in ⎕R out _OptsM ⍵
        }
        ⍝ SideN2FN: Convert sidenotes to footnotes.
        ⍝    The footnote:      [^1]
        ⍝    The footnote text: [^1]: This is the source of the information.
        SideN2FN←⍺⍺{
            _←¯1 Say'Converting sidenotes to footnotes in ',Tp ⍺⍺
            NL←⎕UCS 10
            counter←1
            fnList←NL,'## Footnotes',NL,NL
            in←'<∆N>(.*?)</∆N>'
            out←{
                cText←⍕counter
                counter+←1
                fnText←⍵.Lengths[1]↑⍵.Offsets[1]↓⍵.Block
                fnText←'^\s*(?:<br>)*\s*' '\s*(?:<br>)*\s*$'⎕R'' _OptsM fnText
                fnList,←'[^',cText,']: ',fnText,NL
                '[^',cText,'] '
            }
            fnList,⍨in ⎕R out _OptsM ⍵ 
        }
      sideN2FN:SideN2FN   Miscellany ⍵ 
               SideN2Null Miscellany ⍵ 
    }
    ⍝ ml: Common macro list, for ALL md files, INCLUDING (b) readme.md.
    ⍝     For those ONLY for Git "readme.md" files, see GitReadmeOnly above.
    ml←{ ⍝ ml: match list.
        ⍝ ∆Link are links that we won't follow, but will tell the user how to do it.
        ⍝ Why not follow-- in htmlRenderer, we can't return to HELP without bother. 
        ∆Link←   '<a id="displayText" href="javascript:linkAlert();">'
        ∆Link,←  '<span class="linkNote">'
        ∆Link0←  '</span></a>'
        ml←⍬
        ml,←⊂ '___TIMESTAMP___' timestamp 
        ml,←⊂ '___COPYRIGHT___' copyright 
        ml,←⊂ '___VERSION___'   version 
        ml,←⊂ 'v(\.\d+){3,5}'    version     ⍝ v.0.1.2
        ml,←⊂ 'VERSION\h*←\h*''.*?'''  ('VERSION← ','''',version,'''')
        ml,←⊂ '<GIT\h*>(.*?)</GIT\h*>'   ''
        ml,←⊂ '</?NOGIT\h*>'    ''
        ml,←⊂ '<∆Red>'          '<span class="red"><strong>'
        ml,←⊂   '</∆Red>'         '</strong></span>'
        ml,←⊂ '<∆Blue>'         '<span class="blue"><strong>'
        ml,←⊂   '</∆Blue>'        '</strong></span>'
        ml,←⊂ '<∆Green>'        '<span class="green"><strong>'
        ml,←⊂   '</∆Green>'       '</strong></span>'
        ml,←⊂ '<∆Gr[ea]y>'         '<span class="grey"><strong>'
        ml,←⊂   '</∆Gr[ea]y>'       '</strong></span>'
        ml,←⊂ '<∆Sum>'          '<summary class="summary">'
        ml,←⊂   '</∆Sum>'         '</summary>'
        ml,←⊂ '<∆Fade>'         '<span style="opacity:0.6;">'
        ml,←⊂   '</∆Fade>'        '</span>'
        ml,←⊂ '<∆N>'            '<span class="margin-note">'
        ml,←⊂   '</∆N>'           '</span>'
        ml,←⊂ '<∆L>'            ∆Link 
        ml,←⊂   '</∆L>'           ∆Link0
      ⍝ Scroll target: <a id="intro" class="scroll-target"></a>
        ml,←⊂ '<∆Targ ([^>]+)>' '<a id="\1" class="scroll-target"></a>'      
        ml,←⊂ '&RHAND;'         '<big>👉</big>\&nbsp;'     ⍝  a big 👉
        ml
    }0
    ⍝ Common: Common macros
    Common←ml { src snk←↓⍉↑⍺⍺ ⋄ src ⎕R snk _OptsM ⍵ }

    ⍝ Apply Common and Git Readme-specific macros based on type
    txt← Common GitReadmeOnly ⊃⎕NGET Fi io
    _←Say(⍕≢ml),' macros applied to  ',Tp io
    ⍝ Write the result out
  1:_←(Fi io)1 ⎕NPUT⍨⊂txt
  }

  MacrosInSrc←{
      io← ⍵
      txt← ⊃⎕NGET (Fi io)
      txt← 'v(\.\d+){2,5}' ⎕R  version⊣ txt
    1: _← (Fi io)1 ⎕NPUT⍨⊂txt
  }
⍝ Convert diamonds from (⍺=1) Apl to Html-friendly forms and (⍺=0) vice versa
⍝    [forward←1] Diamonds io.   
  Diamonds←{⍺←1 ⋄ forward←⍺ ⋄ io←⍵
      dmndIn dmndOut← ⎕UCS forward⌽ dmndHtml dmndApl← 9671 8900
      txt←⊃⎕NGET Fi io
      (((∊txt)∊dmndIn)/∊txt)←dmndOut
      _←Say'Converting to ',(forward⊃'Html' 'APL'),'-friendly diamond selection in "',(Tp io)
    1:_←(Fi io)1 ⎕NPUT⍨⊂txt
    1:_←io Write txt
  }
  UpdatePgm←{
      io← Fi ⍵ ⋄ q← ''''
      src←   'VERSION\h*←\h*''.*?'''      'UPDATE_TIME\h*:\h*''.*?'''
      snk←  ('VERSION← ',q,version,q)    ('UPDATE_TIME: ',q,timestamp,q) 
      txt←  src ⎕R snk ⊃⎕NGET io
    1: _← io 1 ⎕NPUT⍨ ⊂txt 
  }
  ⍝ Md2Html: Run pandoc on the md file, using pandoc-style markdown, generating Html
  ⍝ Avoid pandoc's css (except min). It messes with tables.
  ⍝ Begin every option/spec var. for Pandoc with a space, unless empty.
  Md2Html←{
    ∆← {⍺←'' ⋄ ⍺, ∊' ',¨⍵ }
    in hdr out←⍵
    ⍝ mDoc: omit default css: -M document-css=false
    mDoc←'-M document-css=false'
    mTitle← ''                                   ⍝ 'title="',title,'"' if not in doc.
      ⍝ refLoc:  Use default for --reference-location=...'
    refLoc← '' 
    numSec←'-N'                                  ⍝ number sections
    fiTyp← '-f markdown'                         ⍝ pandoc format markdown
    fiIn←  Fi in
    fiHdr← '-H ',Fi hdr 
    fiOut← '-o ',Fi out
    tableNos←  '' ⍝ '--filter pandoc-tablenos'
  ⍝ Doesn't work as expected...: ' -s --toc --toc-depth=2'
    toc← ''                     
    opts← ∆ mDoc mTitle refLoc numSec tableNos toc 
    _Fis←{i h o←⍺⍺¨⍵ ⋄ ∆ i '-H' h '-o' o}
    _←Say'pandoc $opts' ∆ fiTyp (Tp _Fis in hdr out)
    _←Say'>>>    $opts=',opts
    parms←opts ∆ fiTyp (Fi _Fis in hdr out)
    1:_←⎕SH pandocBin, parms
  }
⍝ MdPanDoc2Git: Convert pandoc-style markdown to Git format for readme.md ONLY.
  MdPandoc2Git←{ in out← ⍵ 
    _← Say 'pandoc -f markdown -t gfm ',(Tp in),' -o ',Tp out 
    cmd← pandocBin,' -f markdown -t gfm ',(Fi in),' -o ',Fi out 
    ⎕SH cmd 
  }
⍝ Delete the temp file-- won't delete if file doesn't have 'tmp' in its nm.
  Delete← { in← ⍵ ⋄ del← 1  ⍝ If del=0, leave the file for debugging...
      ok← 1∊ 'tmp'⍷⍥⎕C Fi ⍵ 
      ~ok: ⎕←'Unable to delete file ',(Tp ⍵),'. It must have TMP or tmp in its name'
      _← 1 Say⍣del⊢ 'Deleting temporary file ',Tp in 
      1:  _← ⎕NDELETE⍣del⊣ Fi ⍵ 
  }
⍝ HtmlMacro: Force generated html tables to use justification, not left alignment.
  HtmlMacro← {
    io← Fi ⍵
    txt← ⊃⎕NGET io 
    txt← '<td style="text-align: left;">' ⎕R '<td style="text-align: justify;">'⊣txt 
    io 1 ⎕NPUT⍨ ⊂txt 
  }

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝  EXECUTIVE ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝ ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝            ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝ ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

:If Parm'p'  ⍝ Prompt mode...
    'Please select Publishing Option:'
    '  Update [Quiet] [^]  Update based on dependencies. Default ''Update''.'
    '  Force  [Quiet] [^]  Force an update of all files.'
    '  Exit                Exit now'
    '==== Options ========'
    '     Quiet            Do update QUIETLY, i.e. with minimal feedback.'
    '     ^    (caret)     For README.md, keep sidenotes, converting them to footnotes.'
    '                      The default: remove sidenotes completely from README.md.'
    '     Diamond Html     Convert to Html-friendly Diamonds   (APL Diamond => Big Diamond)'
    '     Diamond Apl      Convert to Dyalog-friendly Diamonds (Big Diamond => APL Diamond)'
    'Enter:   [U | F] [Q] [^] [D [ H| A]]   or   E to exit'
    'Default:  U   (no other options)'
    Parm←(⎕C⍞↓⍨≢⍞←'> ')∘{⍵∊⍺}
:EndIf
:If Parm'e' ⋄ :Return ⋄ :EndIf

anyUpdts←0        ⍝ No udpates yet
force←Parm'f'     ⍝ If 1, force updates
⍝ sideN2FN: See Macros.
⍝     Set to 1: sidenotes are converted to footnotes in README.md;
⍝     Default:  sidenotes will be removed (ignored) in README.md.
⍝ Only used with Macros::Git... routines to handle README.md files.
sideN2FN←Parm'^'

:If Parm'd'
    Hr ⋄ (~Parm'⍺')Diamonds PrivF md
:EndIf
Hr
Say'∘ Directories:'
Say'    PRIV:  ', HomeDir Fi Priv ⍬
Say'    PRIVF: ', HomeDir Fi PrivF ⍬
Say'    PUB:   ', HomeDir Fi Pub ⍬
Say'    PUBF:  ', HomeDir Fi PubF ⍬
Say'    TEMP:  ', HomeDir Fi Temp ⍬
Hr

pgmDep← ((PrivF pgm)(PubF pgm))  ((PrivF libra)(PubF libra)) ((Priv loader)(Pub loader))((PrivF parmFi)(PubF parmFi))
:If force
:OrIf '∆F Program' NeedsUpdate pgmDep
    Hr
    anyUpdts∨←1
    _←¯1 Say'Updating ∆F utility ',Tp PubF pgm
    _←¯1 Say'Updating ∆F loader  ',Tp PubF loader
    UpdatePgm PrivF pgm 
    UpdatePgm PrivF libra 
    UpdatePgm Priv loader 
    CopyFi(Priv loader)(Pub loader)
    CopyFi(PrivF libra)(PubF libra)
    CopyFi(PrivF parmFi)(PubF parmFi)
    force CopyFi(PrivF pgm)(PubF pgm)                    ⍝ Make ∆F library public
:EndIf

docDep←  ((PrivF md)(PubF md))  ((PrivF md)(PrivF html))  ((PrivF hdr)(PrivF html))
docDep,← ((PrivF html)(PubF html)) ((PrivF md)(PubF readme)) 
:If force
:OrIf 'Documentation' NeedsUpdate docDep
    Hr
    anyUpdts∨←1
    ¯1 Say'Updating private and public documentation files'
    force CopyFi(PrivF md)(PubF md)                ⍝ Copy private md to public md. Force if force=1.
  ⍝ We use pandoc-format markdown, but need to have README.md in github-format markdown.
    Hr 
      MacrosInSrc PrivF md 
      CopyFi (PrivF md)(Temp mdTmp)
      Macros Temp mdTmp                            ⍝ Expand macros in Git    README.md
      MdPandoc2Git (Temp mdTmp)(Pub readme) 
      Delete Temp mdTmp  
    Hr 
    Macros PubF md                                ⍝ Expand macros in public markdown md
    Md2Html(PubF md)(PrivF hdr)(PrivF html)       ⍝ Generate private HTML from public markdown
    HtmlMacro PrivF html 
    CopyFi(PrivF html)(PubF html)                 ⍝ Copy private HTML to public
:EndIf

:If anyUpdts
    Hr 
      _← ¯1 Say 'Files were updated' 
    Hr
      _← 1 Say ']Load ∆F -target=⎕SE '
      ns←⎕SE.UCMD 'Load ∆F -t=⎕SE' 
      _←  1 Say'>>> library ns=',ns
      _← ¯1 Say'Please run local Github to push updated files'
    Hr 
      ⎕←'∆F⍨''help''      ⍝ Execute help?'
:EndIf
