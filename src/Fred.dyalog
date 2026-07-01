:Namespace FString
⍝ === VARIABLES ===

ADD_∆F_TO_PATH←1

APL_VERSION←20

ESCAPE_CHAR←'`'

FUTURES←(⎕ucs 9061 8839 8230)

_←⍬
_,←'ADD_∆F_TO_PATH' 'APL_VERSION' 'ESCAPE_CHAR' 'FUTURES' 'HELP_HTML_FI' 'INLINE_DEF' 'KEEP_SRC_CM'
_,←'LIB_ACTIVE' 'LIB_PARM_FI' 'LIB_SRC_FI' 'LIB_USER_FI' 'OPTS_DEFns' 'OPTS_DEFval' 'OPTS_KW'
_,←'QUOTES_SUPPLEMENTAL' 'QUOTE_STYLES' (15⍴'SIGNAL_LIB_ERR') 'SRC_FI' 'TRAP_ERRORS' 'VERBOSE_LOADTIME'
_,←'VERBOSE_RUNTIME' 'VERSION'
GLOBALS←_

HELP_HTML_FI←'∆F/Help.html'

INLINE_DEF←0

KEEP_SRC_CM←0

LIB_ACTIVE←2

LIB_PARM_FI←'∆F/ParmDefs.apla'

LIB_SRC_FI←'∆F/LibUtils.dyalog'

LIB_USER_FI←'.∆F'

OPTS_DEFval←5⍴0 0 0 1

OPTS_KW←5 7⍴'dfn    verbosebox    auto   inline '

QUOTES_SUPPLEMENTAL←(⎕ucs 171 187) (⎕ucs 12300 12301) (⎕ucs 187 171)

SIGNAL_LIB_ERRS←0

SRC_FI←'∆F/FString.dyalog'

TRAP_ERRORS←1

VERBOSE_LOADTIME←0

VERBOSE_RUNTIME←0

VERSION←'v.0.4.2'

cd←'⍥'

cdNm←,'Ö'

_←⍬
_,←'"`{}$',(⎕ucs 9081),'→↓%£''',(⎕ucs 171 12300 187 9061 8839 8230)
cfBrkList←_

da←'↓'

dia2←(⎕ucs 8900 9671)

dol←'$'

dq←'"'

el←(⎕ucs 8230)

elNm←,'Ë'

esc←'`'

esc_lb_rb←'`{}'

_←⍬
_,←'<!DOCTYPE html>',(⎕ucs 10),'<html xmlns="http://www.w3.org/1999/xhtml" lang="" xml:lang="">',(⎕ucs 10),'<head>',(⎕ucs 10),'  <meta charset="utf-8" />',(⎕ucs 10)
_,←'  <meta name="generator" content="pandoc" />',(⎕ucs 10),'  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes" />',(⎕ucs 10)
_,←'  <title>∆F Formatted String Literals (v.0.4.2)</title>',(⎕ucs 10),'  <style>',(⎕ucs 10),'    /* Default styles provided by pandoc.',(⎕ucs 10)
_,←'    ** See https://pandoc.org/MANUAL.html#variables-for-html for config info.',(⎕ucs 10),'    */',(⎕ucs 10),'    code{white-space: pre-wrap;}',(⎕ucs 10)
_,←'    span.smallcaps{font-variant: small-caps;}',(⎕ucs 10),'    div.columns{display: flex; gap: min(4vw, 1.5em);}',(⎕ucs 10),'    div.column{flex: auto; overflow-x: auto;}',(⎕ucs 10)
_,←'    div.hanging-indent{margin-left: 1.5em; text-indent: -1.5em;}',(⎕ucs 10),'    /* The extra [class] is a hack that increases specificity enough to',(⎕ucs 10)
_,←'       override a similar rule in reveal.js */',(⎕ucs 10),'    ul.task-list[class]{list-style: none;}',(⎕ucs 10),'    ul.task-list li input[type="checkbox"] {',(⎕ucs 10),'      font-size: inherit;'
_,←(⎕ucs 10),'      width: 0.8em;',(⎕ucs 10),'      margin: 0 0.8em 0.2em -1.6em;',(⎕ucs 10),'      vertical-align: middle;',(⎕ucs 10),'    }',(⎕ucs 10)
_,←'    .display.math{display: block; text-align: center; margin: 0.5rem auto;}',(⎕ucs 10),'  </style>',(⎕ucs 10),'  <!-- ',(⎕ucs 10),'   ∆F Help function Header  -- PMS Style and Javascript '
_,←(⎕ucs 10),'  -->',(⎕ucs 10 10),'  <style>',(⎕ucs 10),'    /* ======================================================== */',(⎕ucs 10),'    /* Special styles for PMS attributes */',(⎕ucs 10 10)
_,←'    /* A fancy text box class */',(⎕ucs 10),'    .marquee {',(⎕ucs 10),'      width: 100%;',(⎕ucs 10),'      /* ..% of the viewport width */',(⎕ucs 10),'      font-size: 105%;',(⎕ucs 10)
_,←'      text-align: center;',(⎕ucs 10),'      line-height: 1.2;',(⎕ucs 10),'      color: white;',(⎕ucs 10),'      background-color: #062f7c;',(⎕ucs 10),'      border: 1px solid white;',(⎕ucs 10)
_,←'      box-shadow: 0 0 0 2px #062f7c;',(⎕ucs 10),'      border-width: 3px;',(⎕ucs 10),'      padding: 0px 15px;',(⎕ucs 10),'      box-sizing: border-box;',(⎕ucs 10)
_,←'      /* Includes padding and border within the defined width/height */',(⎕ucs 10),'    }',(⎕ucs 10 10),'    typewriter {',(⎕ucs 10)
_,←'      font-family: "American Typewriter", "Courier New", monospace;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* <details><pSummary>  */',(⎕ucs 10),'    details>summary {',(⎕ucs 10)
_,←'      list-style-type: ''',(⎕ucs 9654 65039 39 59 10),'    }',(⎕ucs 10 10),'    details summary::marker {',(⎕ucs 10),'      color: darkgreen;',(⎕ucs 10),'      opacity: 1;',(⎕ucs 10),'    }'
_,←(⎕ucs 10 10),'    details[open]>summary {',(⎕ucs 10),'      color: darkgreen;',(⎕ucs 10),'      opacity: 0.3;',(⎕ucs 10),'      list-style-type: ''',(⎕ucs 128317 39 59 10),'    }',(⎕ucs 10 10)
_,←'    .summary {',(⎕ucs 10),'      margin: 0px;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* For red things! */',(⎕ucs 10),'    .red {',(⎕ucs 10),'      color: red;',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    /* For red things! */',(⎕ucs 10),'    .green {',(⎕ucs 10),'      color: green;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    .grey {',(⎕ucs 10),'      color: grey;',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    .blue {',(⎕ucs 10),'      color: rgb(7, 40, 208);',(⎕ucs 10),'    }',(⎕ucs 10 10),'    .blink {',(⎕ucs 10),'      color: black;',(⎕ucs 10),'      animation: blinker 3s ease-in-out 20;'
_,←(⎕ucs 10),'    }',(⎕ucs 10 10),'    @keyframes blinker {',(⎕ucs 10),'      50% {',(⎕ucs 10),'        opacity: 50%;',(⎕ucs 10),'        color: red;',(⎕ucs 10),'      }',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    /* for <pNote> margin notes (side notes  */',(⎕ucs 10),'    .margin-note {',(⎕ucs 10),'      font-family: ''Times New Roman'', Tahoma, sans-serif;',(⎕ucs 10),'      float: right;',(⎕ucs 10)
_,←'      /* Aligns the note to the right */',(⎕ucs 10),'      width: 220px;',(⎕ucs 10),'      /*  The negative margin-right value should be at least equal to the width of the note */',(⎕ucs 10)
_,←'      margin-right: -300px;',(⎕ucs 10),'      /* Shifts the note out of the main content flow */',(⎕ucs 10),'      font-size: 0.70em;',(⎕ucs 10),'      /* Adjust font size for readability */'
_,←(⎕ucs 10),'      line-height: 1.2;',(⎕ucs 10),'      /* Adjust line height for readability */',(⎕ucs 10),'      margin-bottom: 10px;',(⎕ucs 10),'      text-align: justify;',(⎕ucs 10)
_,←'      clear: right;',(⎕ucs 10),'      /* Ensures the note doesn''t overlap with other floated elements */',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    /* For the line separating main text from the margin notes */',(⎕ucs 10),'    .right-margin-bar {',(⎕ucs 10),'      border-right: 2px solid rgb(244, 230, 227);',(⎕ucs 10)
_,←'      /* Adjust color and thickness as needed */',(⎕ucs 10),'      padding-right: 55px;',(⎕ucs 10),'      /* Space between the bar and content */',(⎕ucs 10),'      margin-right: 55px;',(⎕ucs 10)
_,←'      /* Optional: Space from the right edge of the page */',(⎕ucs 10),'      height: auto;',(⎕ucs 10),'      /* Or set a fixed height, *e.g.*, 200px */',(⎕ucs 10)
_,←'      /* overflow: hidden; Do not use w/ margin notes. */',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* Suppress margin notes if screen is narrow (1000 px or less) */',(⎕ucs 10)
_,←'    @media screen and (max-width: 1000px) {',(⎕ucs 10),'      body {',(⎕ucs 10),'        width: 100%;',(⎕ucs 10),'      }',(⎕ucs 10 10),'      .margin-note {',(⎕ucs 10),'        width: 0px;'
_,←(⎕ucs 10),'        margin-right: 0px;',(⎕ucs 10),'        visibility: hidden;',(⎕ucs 10),'      }',(⎕ucs 10 10),'      .right-margin-bar {',(⎕ucs 10),'        overflow: hidden;',(⎕ucs 10),'      }'
_,←(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* In your main CSS file or a dedicated print.css */',(⎕ucs 10),'    @media not screen {',(⎕ucs 10),'      .page-break {',(⎕ucs 10)
_,←'        /* Place in: <div class="page-break-after">...</div> */',(⎕ucs 10),'        break-after: page;',(⎕ucs 10),'      }',(⎕ucs 10 10),'      th {',(⎕ucs 10),'        color: black !important;'
_,←(⎕ucs 10),'        background-color: white !important;',(⎕ucs 10),'      }',(⎕ucs 10 10),'      details[open]>summary {',(⎕ucs 10),'        display: none !important;',(⎕ucs 10),'      }'
_,←(⎕ucs 10 10),'      .marquee {',(⎕ucs 10),'        color: black !important;',(⎕ucs 10),'        background-color: white !important;',(⎕ucs 10),'      }',(⎕ucs 10 10),'      .button-container {'
_,←(⎕ucs 10),'        display: none !important;',(⎕ucs 10),'      }',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* For links you don''t want followed outside the Help html*-- a msg appears instead.',(⎕ucs 10)
_,←'       See <pLink>...</pLink>                         * bc you can''t get back!',(⎕ucs 10),'    */',(⎕ucs 10),'    .linkNote {',(⎕ucs 10),'      font-size: 20px;',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    .multi-column-text {',(⎕ucs 10),'      margin-left: 0px;',(⎕ucs 10),'      margin-right: 0px;',(⎕ucs 10),'      column-count: 2;',(⎕ucs 10),'      /* Divides the content into two columns */'
_,←(⎕ucs 10),'      column-gap: 25px;',(⎕ucs 10),'      /* Adds space between the columns */',(⎕ucs 10),'      /* column-rule:  1px solid #ccc;  */',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    /* ======================================================== */',(⎕ucs 10),'    /* Regular markdown styles follow */',(⎕ucs 10 10),'    /* The main body style */',(⎕ucs 10),'    body {'
_,←(⎕ucs 10),'      background-color: #fffef4;',(⎕ucs 10),'      /* Off-white */',(⎕ucs 10),'      font-family: Georgia, serif;',(⎕ucs 10),'      font-size: 15pt;',(⎕ucs 10)
_,←'      text-align: justify;',(⎕ucs 10),'      padding: 1% 4%;',(⎕ucs 10),'      margin-left: 25px;',(⎕ucs 10),'      margin-right: 175px;',(⎕ucs 10),'      margin-bottom: 0.5in;',(⎕ucs 10)
_,←'      max-width: 1200px;',(⎕ucs 10),'      /* Sets a maximum width */',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* For document title, passed via pandoc */',(⎕ucs 10),'    .title {',(⎕ucs 10)
_,←'      text-align: center;',(⎕ucs 10),'      margin: 5px 10px;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* Inline code */',(⎕ucs 10),'    code {',(⎕ucs 10),'      font-size: 88%;',(⎕ucs 10)
_,←'      background-color: #ddfafaff;',(⎕ucs 10),'      padding: 2px 4px;',(⎕ucs 10),'      border-radius: 3px;',(⎕ucs 10),'      font-family: "APL386 Unicode", APL386, "APL385 Unicode", APL385,'
_,←(⎕ucs 10),'        "Courier New", Courier, Lucida Console", " Consolas", monospace;',(⎕ucs 10 10),'    }',(⎕ucs 10 10),'    /* Code blocks */',(⎕ucs 10),'    pre {',(⎕ucs 10)
_,←'      background-color: #ddfafaff;',(⎕ucs 10),'      color: #0a0a0aff;',(⎕ucs 10),'      font-size: 13pt;',(⎕ucs 10),'      line-height: 110%;',(⎕ucs 10),'      padding: 15px;',(⎕ucs 10)
_,←'      border-radius: 5px;',(⎕ucs 10),'      overflow-x: auto;',(⎕ucs 10),'      font-family: "APL386 Unicode", APL386, "APL385 Unicode", APL385,',(⎕ucs 10)
_,←'        "Courier New", Courier, "Lucida Console", "Consolas", monospace;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* Tables */',(⎕ucs 10),'    table {',(⎕ucs 10),'      background-color: #ffffffff;'
_,←(⎕ucs 10),'      line-height: 1.2;',(⎕ucs 10),'      font-size: 90%;',(⎕ucs 10),'      /* 100%; */',(⎕ucs 10),'      border: 2px solid #210074ff;',(⎕ucs 10),'      vertical-align: top;',(⎕ucs 10)
_,←'      font-family: "APL386 Unicode", APL386, "APL385 Unicode", APL385,',(⎕ucs 10),'        "Courier New", Courier, "Lucida Console", "Consolas", monospace;',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    th {',(⎕ucs 10),'      /* Table header */',(⎕ucs 10),'      font-family: Georgia, "Courier New", Courier, "Lucida Console", "Consolas", monospace;',(⎕ucs 10),'      font-weight: 900;',(⎕ucs 10)
_,←'      line-height: 1.1;',(⎕ucs 10),'      padding: 7px 7px;',(⎕ucs 10),'      vertical-align: top;',(⎕ucs 10),'      background-color: #25027eff;',(⎕ucs 10),'      color: #ffffffff;',(⎕ucs 10)
_,←'      border: 1px solid black;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    td {',(⎕ucs 10),'      /* Table data */',(⎕ucs 10)
_,←'      font-family: Georgia, "Courier New", Courier, "Lucida Console", "Consolas", monospace;',(⎕ucs 10),'      font-weight: 200;',(⎕ucs 10),'      padding: 5px 7px;',(⎕ucs 10)
_,←'      text-align: justify;',(⎕ucs 10),'      vertical-align: top;',(⎕ucs 10),'      border: 1px solid black;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    tr:nth-child(odd) {',(⎕ucs 10)
_,←'      background-color: #ebebebff;',(⎕ucs 10),'      /* Light grey for odd rows */',(⎕ucs 10),'    }',(⎕ucs 10 10),'    tr:nth-child(even) {',(⎕ucs 10),'      background-color: #ffffffff;'
_,←(⎕ucs 10),'      /* White for even rows */',(⎕ucs 10),'    }',(⎕ucs 10 10),'    blockquote {',(⎕ucs 10),'      font-size: 110%;',(⎕ucs 10),'      background-color: #f4f5f5ff;',(⎕ucs 10),'    }'
_,←(⎕ucs 10 10),'    ul,',(⎕ucs 10),'    li {',(⎕ucs 10),'      font-size: 100%;',(⎕ucs 10),'      line-height: 130%;',(⎕ucs 10),'      /* Was 120%; */',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    /* # headers: Make h1 headers (#...) the same size as h2 (##...) */',(⎕ucs 10),'    h1 {',(⎕ucs 10),'      font-size: 1.5em;',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    /* scroll-target: Allow a target inside the scope of a <details>',(⎕ucs 10),'       that forces open the details, but scrolling to just above (1.3in above)',(⎕ucs 10),'    */',(⎕ucs 10)
_,←'    .scroll-target {',(⎕ucs 10),'      scroll-margin-top: 1.3in;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* Optional: Add smooth scrolling to the whole page */',(⎕ucs 10),'    html {',(⎕ucs 10)
_,←'      scroll-behavior: smooth;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* links-- make them less obtrusive */',(⎕ucs 10),'    a:link {',(⎕ucs 10),'      /* link not visited */',(⎕ucs 10)
_,←'      color: black;',(⎕ucs 10),'      font-size: 100%;',(⎕ucs 10),'      text-decoration: underline darkred dotted;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    a:visited {',(⎕ucs 10)
_,←'      /* visited link */',(⎕ucs 10),'      color: black;',(⎕ucs 10),'      text-decoration: underline darkred dashed;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    a:hover {',(⎕ucs 10),'      color: red;'
_,←(⎕ucs 10),'      font-weight: 750;',(⎕ucs 10),'      text-decoration: underline red solid;',(⎕ucs 10),'      transition: color 0.5s, font-size 1s;',(⎕ucs 10)
_,←'      /* font-size 2.0s ease; /* Smooth transition */',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* For the fixed navigation footer we set up */',(⎕ucs 10),'    .doc-footer {',(⎕ucs 10)
_,←'      position: fixed;',(⎕ucs 10),'      font-size: 90%;',(⎕ucs 10),'      left: 0;',(⎕ucs 10),'      bottom: 0;',(⎕ucs 10),'      width: 100%;',(⎕ucs 10),'      background-color: #e7e7e7ff;'
_,←(⎕ucs 10),'      color: black;',(⎕ucs 10),'      text-align: center;',(⎕ucs 10),'      padding: 0 0 0 0;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    .button-container {',(⎕ucs 10),'      display: flex;'
_,←(⎕ucs 10),'      flex-wrap: wrap;',(⎕ucs 10),'      /* Allows items to wrap to the next line */',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* Fixed size white on green button in navig footer */',(⎕ucs 10)
_,←'    .happy-button {',(⎕ucs 10),'      font-size: 90%;',(⎕ucs 10),'      color: white;',(⎕ucs 10),'      background-color: rgb(43, 122, 61);',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    /* Fixed size white on red button in navig footer */',(⎕ucs 10),'    .warn-button {',(⎕ucs 10),'      /* width: 150px; */',(⎕ucs 10),'      font-size: 90%;',(⎕ucs 10),'      color: white;'
_,←(⎕ucs 10),'      background-color: red;',(⎕ucs 10),'    }',(⎕ucs 10 10),'    /* Fixed size white on blue button in navig footer */',(⎕ucs 10),'    .normal-button {',(⎕ucs 10)
_,←'      /* width: 175px; */',(⎕ucs 10),'      font-size: 90%;',(⎕ucs 10),'      color: white;',(⎕ucs 10),'      background-color: rgb(104, 98, 187);',(⎕ucs 10),'    }',(⎕ucs 10 10)
_,←'    /* For updating user on page resizing, etc. See JS code */',(⎕ucs 10),'    .pAlertMsg {',(⎕ucs 10),'      display: none;',(⎕ucs 10),'      position: fixed;',(⎕ucs 10)
_,←'      text-align: center;',(⎕ucs 10),'      top: 40%;',(⎕ucs 10),'      left: 50%;',(⎕ucs 10),'      transform: translate(-50%, -50%);',(⎕ucs 10),'      color: black;',(⎕ucs 10)
_,←'      background-color: #cecac4;',(⎕ucs 10),'      padding: 5px;',(⎕ucs 10),'      border: 10px double black;',(⎕ucs 10),'      white-space: pre-wrap;',(⎕ucs 10),'      /* honor \n */',(⎕ucs 10)
_,←'    }',(⎕ucs 10),'  </style>',(⎕ucs 10 10),'  <script>',(⎕ucs 10),'    //  Handle Expand/Collapse button at bottom of Help page ',(⎕ucs 10)
_,←'    document.addEventListener(''DOMContentLoaded'', () => {',(⎕ucs 10),'      const toggleButton = document.getElementById(''toggleDetails'');',(⎕ucs 10)
_,←'      toggleButton.addEventListener(''click'', () => {',(⎕ucs 10),'        // Select all <details> elements that do NOT have the pPeek id (id="pPeek").',(⎕ucs 10)
_,←'        const detailsToToggle = document.querySelectorAll(''details:not(#pPeek)'');',(⎕ucs 10),'        // Check if the button should expand or collapse - based on button text.',(⎕ucs 10)
_,←'        const expandNow = toggleButton.textContent.includes(''Expand'');',(⎕ucs 10 10),'        detailsToToggle.forEach(detail => {',(⎕ucs 10),'          if (expandNow) {',(⎕ucs 10)
_,←'            detail.setAttribute(''open'', '''');  // Expand: add ''open'' attr.',(⎕ucs 10),'          } else {',(⎕ucs 10)
_,←'            detail.removeAttribute(''open'');   // Collapse: remove ''open'' attr.',(⎕ucs 10),'          }',(⎕ucs 10),'        });',(⎕ucs 10),'        if (expandNow) {',(⎕ucs 10)
_,←'          toggleButton.textContent = ''Collapse All'';',(⎕ucs 10),'        } else {',(⎕ucs 10),'          toggleButton.textContent = ''Expand All'';',(⎕ucs 10),'        }',(⎕ucs 10),'      });'
_,←(⎕ucs 10),'    });',(⎕ucs 10 10 10),'    // Close the Help window',(⎕ucs 10),'    // - for the Close Window button at bottom of Help page',(⎕ucs 10),'    function closeWindowNow() {',(⎕ucs 10)
_,←'      showAlert("Closing Window...", 1000, 1);',(⎕ucs 10),'      setTimeout(window.close, 1000);',(⎕ucs 10),'    }',(⎕ucs 10 10),'    function sleep(howLong) {',(⎕ucs 10)
_,←'      return new Promise(resolve => setTimeout(resolve, howLong));',(⎕ucs 10),'    }',(⎕ucs 10 10),'    function myPrint() {',(⎕ucs 10)
_,←'      const toggleButton = document.getElementById(''toggleDetails'');',(⎕ucs 10),'      const detailsToToggle = document.querySelectorAll(''details'');',(⎕ucs 10)
_,←'      const notOpen = toggleButton.textContent.includes(''Expand'');',(⎕ucs 10),'      const myPrintPause = 2000;',(⎕ucs 10 10)
_,←'      // Open all details (some may have been already), including pPeek details.',(⎕ucs 10),'      detailsToToggle.forEach(detail => {',(⎕ucs 10),'        detail.setAttribute(''open'', '''');'
_,←(⎕ucs 10),'      });',(⎕ucs 10),'      showAlert("To print, set Scaling to ~62%", myPrintPause - 250, 0);',(⎕ucs 10),'      sleep(myPrintPause).then(() => {',(⎕ucs 10)
_,←'        window.print();    // Pause until window is printed or cancelled.',(⎕ucs 10),'        // if notOpen, simply close all details (some may have been open).',(⎕ucs 10),'        if (notOpen) {'
_,←(⎕ucs 10),'          detailsToToggle.forEach(detail => {',(⎕ucs 10),'            detail.removeAttribute(''open'');',(⎕ucs 10),'          })',(⎕ucs 10),'        };',(⎕ucs 10),'      });',(⎕ucs 10)
_,←'    }',(⎕ucs 10 10),'    // Informational Alert ',(⎕ucs 10),'    // showAlert( text, howLong in ms to show, urgent)',(⎕ucs 10),'    // urgent: 1= show ',(⎕ucs 9888 65039),'; 0= show '
_,←(⎕ucs 8505 65039 32 32 10),'    function showAlert(displayMe, howLong, urgent) {',(⎕ucs 10),'      var alertBox = document.getElementById("pAlertMsg");',(⎕ucs 10)
_,←'      var alertPfx = document.getElementById("pAlertPfx");',(⎕ucs 10),'      var alertTxt = document.getElementById("pAlertText");',(⎕ucs 10)
_,←'      alertBox.style.display = "block"; // Show the alert',(⎕ucs 10),'      if (urgent == 1) {',(⎕ucs 10),'        alertPfx.textContent = "',(⎕ucs 9888 65039),' ";',(⎕ucs 10),'      } else {'
_,←(⎕ucs 10),'        alertPfx.textContent = "',(⎕ucs 8505 65039),' ";',(⎕ucs 10),'      }',(⎕ucs 10),'      alertTxt.textContent = displayMe;',(⎕ucs 10),'      sleep(howLong).then(() => {',(⎕ucs 10)
_,←'        alertBox.style.display = "none";  // Hide me',(⎕ucs 10),'      });',(⎕ucs 10),'    }',(⎕ucs 10),'    function linkAlert() {',(⎕ucs 10)
_,←'      showAlert("Use regular browser to explore link. Select link text and ctrl-click (right-click) to copy.", 2000, 1);',(⎕ucs 10),'    }',(⎕ucs 10 10),'    // Listener for narrow/wide text'
_,←(⎕ucs 10),'    // (triggered when text crosses width boundary specified) ',(⎕ucs 10),'    const mediaQuery = window.matchMedia("screen and (max-width: 1000px)");',(⎕ucs 10)
_,←'    mediaQuery.addEventListener(''change'', (event) => {',(⎕ucs 10),'      if (event.matches) {',(⎕ucs 10),'        showAlert("Omitting Margin Notes...", 2000, 1);',(⎕ucs 10),'      } else {'
_,←(⎕ucs 10),'        showAlert("Showing Margin Notes...", 2000, 0);',(⎕ucs 10),'      }',(⎕ucs 10),'    });',(⎕ucs 10 10),'    // Listener for copy: Cmd-C, Meta-C; quit: Cmd-Q, Meta-Q',(⎕ucs 10)
_,←'    document.addEventListener(''keydown'', (event) => {',(⎕ucs 10),'      // Check for a specific key combination, e.g., Ctrl + C (event.ctrlKey || ',(⎕ucs 10)
_,←'      if (event.ctrlKey || event.metaKey) {',(⎕ucs 10),'        if (event.key === ''c'') { // We can''t seem to copy onto clipboard directly',(⎕ucs 10)
_,←'          showAlert("To copy, ctrl-click (right-click) and select the copy option.", 1500, 1);',(⎕ucs 10),'        } else if (event.key === ''q'') {',(⎕ucs 10),'          closeWindowNow();'
_,←(⎕ucs 10),'        }',(⎕ucs 10),'      }',(⎕ucs 10),'    });',(⎕ucs 10 10),'    // (C) 2025 Sam the Cat Foundation ',(⎕ucs 10),'  </script>',(⎕ucs 10),'</head>',(⎕ucs 10),'<body>',(⎕ucs 10)
_,←'<header id="title-block-header">',(⎕ucs 10),'<h1 class="title">∆F Formatted String Literals (v.0.4.2)</h1>',(⎕ucs 10),'</header>',(⎕ucs 10),'<nav id="TOC" role="doc-toc">',(⎕ucs 10 10),'</nav>'
_,←(⎕ucs 10),'<h2 class="unnumbered" id="introduction">0 Introduction</h2>',(⎕ucs 10),'<div class="right-margin-bar">',(⎕ucs 10),'<p><span class="margin-note">Short for ',(⎕ucs 8220),'<strong>format'
_,←(⎕ucs 173),'ted string',(⎕ucs 10),'lit',(⎕ucs 173 101 114 173),'als</strong>, <em>f',(⎕ucs 8209),'strings</em> were introduced in Python in 2016.',(⎕ucs 10),'<strong>∆F</strong> <em>f',(⎕ucs 8209)
_,←'strings</em> and Python',(⎕ucs 8217),'s are',(⎕ucs 10),'<strong>not</strong> compatible.</span></p>',(⎕ucs 10),'<p><a id="intro" class="scroll-target"></a></p>',(⎕ucs 10),'<div class="marquee">'
_,←(⎕ucs 10),'<center>',(⎕ucs 10),'<strong><em>∆F</em></strong> is a function for <em>Dyalog</em>',(⎕ucs 10),'<em>APL</em> that interprets <em>f',(⎕ucs 8209),'strings</em>, a concise, yet powerful'
_,←(⎕ucs 10),'way to display multiline <em>APL</em> text, arbitrary <em>APL</em>',(⎕ucs 10),'expressions, and multi',(⎕ucs 173),'dimensional objects using extensions to',(⎕ucs 10)
_,←'<em>dfns</em> and other familiar tools.',(⎕ucs 10),'</center>',(⎕ucs 10),'</div>',(⎕ucs 10),'<h3 class="unnumbered" id="major-headings">Major Headings</h3>',(⎕ucs 10),'<details id="TOC" open>'
_,←(⎕ucs 10),'<!-- option: open  Set id="TOC" here only. -->',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'<span style="opacity:0.6;">Show/Hide</span> <em>Major Headings</em>',(⎕ucs 10)
_,←'</summary>',(⎕ucs 10),'<span class="margin-note"><br><br><br> <strong>Quick Start:</strong> If',(⎕ucs 10),'you want the minimum before diving in. </span>',(⎕ucs 10)
_,←'<div class="multi-column-text" style="font-size:80%;">',(⎕ucs 10),'<p><big >1. <a href="#inside-preparing"         >Preparing to Run',(⎕ucs 10),'<strong>∆F</strong></a> <br  >2.',(⎕ucs 10)
_,←'<a href="#inside-overview"          >Overview</a> <br  >3.',(⎕ucs 10),'<a href="#inside-quick-start"       ><span class="blink"><strong>Quick',(⎕ucs 10),'Start</strong></span></a> <br  >4.'
_,←(⎕ucs 10),'<a href="#inside-examples"          ><strong>∆F</strong> Examples: A',(⎕ucs 10),'Primer</a><br />',(⎕ucs 10),'<br  >5. <a href="#inside-reference"         ><strong>∆F</strong>',(⎕ucs 10)
_,←'Reference</a> <br  >6.',(⎕ucs 10),'<a href="#inside-appendices"        >Appendices</a> <br  >7.',(⎕ucs 10),'<a href="#inside-index"             >Index of Topics</a> </big></p>',(⎕ucs 10),'</div>'
_,←(⎕ucs 10),'<hr />',(⎕ucs 10),'</details>',(⎕ucs 10),'<!-- <div class="page-break"></div>  -->',(⎕ucs 10),'<h1 data-number="1" id="preparing-to-run-f"><span',(⎕ucs 10)
_,←'class="header-section-number">1</span> Preparing to Run',(⎕ucs 10),'<strong>∆F</strong></h1>',(⎕ucs 10),'<details>',(⎕ucs 10),'<!-- option: open -->',(⎕ucs 10),'<summary class="summary">'
_,←(⎕ucs 10 8194),'<span style="opacity:0.6;">Show/Hide</span> <em>Preparing to Run',(⎕ucs 10),'<bold>∆F</bold></em>',(⎕ucs 10),'</summary>',(⎕ucs 10)
_,←'<p><a id="inside-preparing" class="scroll-target"></a></p>',(⎕ucs 10),'<h2 data-number="1.1" id="f-installation"><span',(⎕ucs 10),'class="header-section-number">1.1</span> <strong>∆F</strong>'
_,←(⎕ucs 10),'Installation</h2>',(⎕ucs 10),'<ol type="1">',(⎕ucs 10),'<li>Via your browser, go to Github URL',(⎕ucs 10),'<mark><a id="displayText" href="javascript:linkAlert();"><span',(⎕ucs 10)
_,←'class="linkNote">https://github.com/thecatsam/f-string-apl.git</span></a></mark>.</li>',(⎕ucs 10),'<li>Make a note of <span class="margin-note">Dyalog user command',(⎕ucs 10)
_,←'<code>]cd</code> will show you your current working',(⎕ucs 10),'directory.</span>your current (or desired) working directory.</li>',(⎕ucs 10)
_,←'<li><span class="margin-note"><strong>Download:</strong> E.g. via the',(⎕ucs 10),'Github <strong>Code</strong> button, use download ZIP to place in the',(⎕ucs 10)
_,←'desired directory .</span>Download and copy the file',(⎕ucs 10),'<strong>∆F.dyalog</strong> and directory <strong>∆F</strong> (which',(⎕ucs 10)
_,←'contains several files) into the current working directory, ensuring',(⎕ucs 10),'they are peers, <em>i.e.</em> at the same directory level.</li>',(⎕ucs 10),'</ol>',(⎕ucs 10),'<p><big>'
_,←(⎕ucs 128073),'</big>',(⎕ucs 160),'Now, <strong>∆F</strong> is available to load and use.',(⎕ucs 10),'Continue in the <a href="#loading-and-running-f">next section</a>.</p>',(⎕ucs 10)
_,←'<h2 data-number="1.2" id="loading-and-running-f"><span',(⎕ucs 10),'class="header-section-number">1.2</span> Loading and Running',(⎕ucs 10),'<strong>∆F</strong></h2>',(⎕ucs 10),'<ol type="1">'
_,←(⎕ucs 10),'<li>Confirm that your current directory remains as before.</li>',(⎕ucs 10),'<li>From your Dyalog session<span',(⎕ucs 10),'class="margin-note"><em>Or,</em>',(⎕ucs 8195)
_,←'<code>⎕SE.⎕FIX''∆F.Dyalog''</code><br><strong><em>⎕SE:</em></strong>',(⎕ucs 10),'Or any <em>target</em> namespace you desire.</span>, enter:',(⎕ucs 10),'<br>',(⎕ucs 8195)
_,←'<code>]load ∆F -target=⎕SE</code><br> Now, the target directory',(⎕ucs 10),'(<code>⎕SE</code>) will contain the namespace <code>FString</code>,',(⎕ucs 10)
_,←'containing <code>∆F</code> and supporting services and objects.</li>',(⎕ucs 10),'<li>By default, the target namespace (<code><em>⎕SE.FString</em></code>)',(⎕ucs 10)
_,←'will be prepended to the <strong><em>beginning</em></strong> of',(⎕ucs 10),'<code>⎕PATH</code>.</li>',(⎕ucs 10),'<li><strong>∆F</strong> may be called as is, i.e.',(⎕ucs 160)
_,←'as <code>∆F</code>, or',(⎕ucs 10),'fully specified as <code>⎕SE.FString.∆F</code>.</li>',(⎕ucs 10),'<li>You may always choose to create an alias to <strong>∆F</strong> in',(⎕ucs 10)
_,←'your chosen namespace (say, <code>mydir</code>), e.g.',(⎕ucs 160),'via',(⎕ucs 10),'<code>mydir.∆F← ⎕SE.FString.∆F</code>.</li>',(⎕ucs 10),'<li>By default, the <strong><em>help</em></strong> file,'
_,←(⎕ucs 10),'<strong>∆F/∆FHelp.html</strong> is available at <code>]load</code> time.',(⎕ucs 10),'If so, it will be copied into <strong>FString</strong>. If not',(⎕ucs 10)
_,←'available, a message will note the absence of <em>help</em>',(⎕ucs 10),'information.</li>',(⎕ucs 10),'</ol>',(⎕ucs 10),'<p><big>',(⎕ucs 128073),'</big>',(⎕ucs 160)
_,←'<small>You may now call <code>∆F</code> with the',(⎕ucs 10),'desired <a href="#f-call-syntax-overview">arguments</a> and <a',(⎕ucs 10),'href="#f-option-details">options</a>.</small><br>',(⎕ucs 10)
_,←'<big>',(⎕ucs 128073),'</big>',(⎕ucs 160),'<small><strong>∆F</strong> is <code>⎕IO</code>- and',(⎕ucs 10),'<code>⎕ML</code>-independent.<br></small>',(⎕ucs 10),'<big>',(⎕ucs 128073),'</big>'
_,←(⎕ucs 160),'<small><strong>∆F</strong>',(⎕ucs 8217 115 32 8220),'help',(⎕ucs 8221),' system uses Dyalog',(⎕ucs 8217 115 10),'<strong><em>HtmlRenderer</em></strong> service to display its',(⎕ucs 10)
_,←'documentation or, if unavailable, the <strong><em>Ride</em></strong>',(⎕ucs 10),'development environment. A less robust version of this help information',(⎕ucs 10)
_,←'is also available in the file <em>readme.md</em> on Github.</small></p>',(⎕ucs 10),'<h2 data-number="1.3" id="displaying-f-help-in-apl"><span',(⎕ucs 10)
_,←'class="header-section-number">1.3</span> Displaying ∆F',(⎕ucs 10),'<strong>Help</strong> in <em>APL</em></h2>',(⎕ucs 10),'<p><span class="margin-note">If <code>∆F⍨''help''</code> seems exotic,'
_,←(⎕ucs 10),'try: <code>''help'' ∆F ⍬</code>.</span></p>',(⎕ucs 10),'<p><big>',(⎕ucs 128073),'</big>',(⎕ucs 160),'To display this <strong>HELP</strong> information,',(⎕ucs 10)
_,←'type: <code>∆F⍨ ''help''</code>.</p>',(⎕ucs 10),'<hr />',(⎕ucs 10),'</details>',(⎕ucs 10),'<div class="page-break">',(⎕ucs 10 10),'</div>',(⎕ucs 10),'<h1 data-number="2" id="overview"><span'
_,←(⎕ucs 10),'class="header-section-number">2</span> Overview</h1>',(⎕ucs 10),'<details open>',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194)
_,←'<span style="opacity:0.6;">Show/Hide</span> <em>Overview</em>',(⎕ucs 10),'</summary>',(⎕ucs 10),'<p><a id="inside-overview" class="scroll-target"></a></p>',(⎕ucs 10)
_,←'<p><span class="margin-note">The current version of <strong>∆F</strong>',(⎕ucs 10),'requires Dyalog version 20.</span> Inspired by <a',(⎕ucs 10),'href="#appendix-ii-python-fstrings">Python f'
_,←(⎕ucs 8209),'strings</a>,',(⎕ucs 10),'<strong>∆F</strong> includes a variety of capabilities to make it easy',(⎕ucs 10),'to evaluate, format, annotate, and display related multi',(⎕ucs 173)
_,←'dimensional',(⎕ucs 10),'information. A <strong>∆F</strong> <em>f-string</em> is (typically) a',(⎕ucs 10),'character vector, which may reference objects in the environment,',(⎕ucs 10)
_,←'additional function arguments, or both.</p>',(⎕ucs 10),'<p><span class="margin-note">For <em>f-string</em> formats, see <a',(⎕ucs 10),'href="#f-call-syntax-overview"><strong>∆F</strong> Call Syn'
_,←(⎕ucs 173),'tax',(⎕ucs 10),'Over',(⎕ucs 173),'view</a>.</span> <strong>∆F</strong> <em>f',(⎕ucs 8209),'strings</em> include:</p>',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li>The abstraction of 2-dimensional character',(⎕ucs 10),'<strong><em>fields</em></strong>, generated one-by-one from the user',(⎕ucs 8217 115 10)
_,←'specifications and data, then aligned and catenated into a single',(⎕ucs 10),'overall character matrix result;</li>',(⎕ucs 10),'</ul>',(⎕ucs 10),'<p><span class="margin-note"><code>`',(⎕ucs 9671)
_,←'</code>: back',(⎕ucs 173),'tick + state',(⎕ucs 173),'ment',(⎕ucs 10),'sep',(⎕ucs 173 97 114 173),'ator (<code>⎕UCS 96 8900</code>). </span></p>',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li><p><strong>Text</strong> fields, each allowing <a',(⎕ucs 10),'href="#text-fields-and-space-fields">multiline Unicode text</a>, with',(⎕ucs 10),'the sequence <code>`',(⎕ucs 9671)
_,←'</code> generating a <strong>new',(⎕ucs 10),'line</strong>;</p></li>',(⎕ucs 10),'<li><p><strong>Code</strong> fields, allowing users to evaluate and',(⎕ucs 10)
_,←'display <em>APL</em> arrays of any dimensionality, depth, and type in',(⎕ucs 10),'the user environment, arrays passed as <strong>∆F</strong> arguments, as',(⎕ucs 10)
_,←'well as arbitrary <em>APL</em> expressions based on full multi-statement',(⎕ucs 10),'dfn logic. Each <strong>Code</strong> field must return a value, simple',(⎕ucs 10)
_,←'or otherwise, which will be catenated with other fields and returned',(⎕ucs 10),'from <strong>∆F</strong>;</p>',(⎕ucs 10),'<p><strong>Code</strong> fields also provide a number of concise,'
_,←(⎕ucs 10),'convenient extensions, such as:</p>',(⎕ucs 10),'<ul>',(⎕ucs 10),'<li><p><strong>Quoted strings</strong> <span class="margin-note">Quoted',(⎕ucs 10)
_,←'strings, like <strong>Text</strong> fields, allow easy entry of newlines',(⎕ucs 10),'via the sequence <code>`',(⎕ucs 9671),'</code>.</span> in <strong>Code</strong>',(⎕ucs 10)
_,←'fields, with several quote styles:</p>',(⎕ucs 10),'<ul>',(⎕ucs 10),'<li><strong>double-quotes</strong><br> <code>∆F ''{"like this"}''</code>',(⎕ucs 10),'or <code>∆F ''{"on`',(⎕ucs 9671)
_,←'""three""`',(⎕ucs 9671),'lines"}''</code></li>',(⎕ucs 10),'<li><strong>double angle quotation marks</strong>,<span',(⎕ucs 10),'class="margin-note"><big><strong>',(⎕ucs 171),'</strong></big> and'
_,←(⎕ucs 10),'<big><strong>',(⎕ucs 187),'</strong></big>: Also known as',(⎕ucs 10),'<em>guillemets</em>.</span><br>',(⎕ucs 10),'<code>∆F ''{',(⎕ucs 171)
_,←'with internal quotes like "this" or ''''this''''',(⎕ucs 187),'}''</code>,<br>',(⎕ucs 10),'<em>not to mention:</em></li>',(⎕ucs 10),'<li><em>APL</em>',(⎕ucs 8217),'s tried-and-true embedded'
_,←(⎕ucs 10),'<strong>single-quotes</strong>,<br>',(⎕ucs 10),'<code>∆F ''{''''shown ''''''''right'''''''' here''''}''</code></li>',(⎕ucs 10),'</ul></li>',(⎕ucs 10)
_,←'<li><p>Simple shortcuts<span class="margin-note">Details on all the <a',(⎕ucs 10),'href="#code-field-shortcuts">shortcuts</a> are provided later in this',(⎕ucs 10),'document.</span> for</p>'
_,←(⎕ucs 10),'<ul>',(⎕ucs 10),'<li><strong>format</strong>ting numeric arrays, <strong>$</strong>',(⎕ucs 10),'(short for',(⎕ucs 10),'<strong>⎕FMT</strong>):<br><code>∆F ''{"F7.5" $ ?0 0}''</code></li>'
_,←(⎕ucs 10),'<li>putting a <strong>box</strong> around a specific expression,',(⎕ucs 10),'<strong>`B</strong>:<br><code>∆F ''{`B ⍳2 2}''</code></li>',(⎕ucs 10)
_,←'<li>placing the output of one expression <strong>above</strong> another,',(⎕ucs 10),'<strong>%</strong>:<br><code>∆F ''{"Pi"% ○1}''</code></li>',(⎕ucs 10)
_,←'<li>formatting <strong>date</strong> and <strong>time</strong>',(⎕ucs 10),'expressions from <em>APL</em> timestamps (<strong>⎕TS</strong>) using',(⎕ucs 10)
_,←'<strong>`T</strong><span class="margin-note"><code>`T</code>',(⎕ucs 10),'combines',(⎕ucs 160),'<strong>1200⌶</strong> and',(⎕ucs 10)
_,←'<strong>⎕DT</strong></span>:<br><code>∆F ''{"hh:mm:ss" `T ⎕TS}''</code></li>',(⎕ucs 10),'<li>calling <span class="margin-note"><strong>£</strong> stands for',(⎕ucs 10)
_,←'<em>library</em>.</span>arbitrary functions on the fly from the',(⎕ucs 10),'<strong>dfns</strong> workspace or a user',(⎕ucs 10)
_,←'file:<br><code>∆F ''{41=£.pco 12}'' ⍝ Is 41 the 12th prime?</code></li>',(⎕ucs 10),'<li><em>and more</em>;</li>',(⎕ucs 10),'</ul></li>',(⎕ucs 10)
_,←'<li><p>Simple mechanisms for concisely formatting and displaying data',(⎕ucs 10),'from</p>',(⎕ucs 10),'<ul>',(⎕ucs 10),'<li>user arrays of any shape and',(⎕ucs 10)
_,←'dimensionality:<br><code>tempC← 10 110 40 ',(⎕ucs 9671),' ∆F ''{tempC}''</code>',(⎕ucs 10),'<br></li>',(⎕ucs 10),'<li>arbitrary <span class="margin-note"><br>£ quietly finds',(⎕ucs 10)
_,←'<code>dec</code> and <code>hex</code> in the <strong>dfns</strong>',(⎕ucs 10),'workspace.</span><em>dfn</em>-style',(⎕ucs 10),'code:<br><code>∆F ''{ 223423 ≡⊃£.dec £.hex 223423: "Checks out" '
_,←(⎕ucs 9671),' "Bad"}''</code>',(⎕ucs 10),'<br></li>',(⎕ucs 10),'<li>arguments to <strong>∆F</strong> that follow the format',(⎕ucs 10),'string:<br><code>∆F ''{32+`⍵1×9÷5}'' (10 110 40)</code><span'
_,←(⎕ucs 10),'class="margin-note"><code>`⍵1</code>: shortcut for',(⎕ucs 10),'<code>(⍵⊃⍨1+⎕IO)</code></span></li>',(⎕ucs 10),'<li><em>and more</em>;</li>',(⎕ucs 10),'</ul></li>',(⎕ucs 10),'</ul></li>'
_,←(⎕ucs 10),'<li><p><strong>Space</strong> fields, providing a simple mechanism both',(⎕ucs 10),'for separating adjacent <strong>Text</strong> fields and inserting',(⎕ucs 10)
_,←'(rectangular) blocks of any number of spaces between any two fields,',(⎕ucs 10),'where needed;</p>',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li>one space: <code>{ }</code>; five spaces: <code>{     }</code>; or',(⎕ucs 10),'even, zero spaces: <code>{}</code>;</li>',(⎕ucs 10),'<li>1000 spaces? Use a <strong>Code</strong> field instead:'
_,←(⎕ucs 10),'<code>{1000⍴""}</code>.</li>',(⎕ucs 10),'</ul></li>',(⎕ucs 10),'<li><p>Use of <span class="margin-note">These options are',(⎕ucs 10),'equi',(⎕ucs 173)
_,←'valent:<br>∘ <code>0 1 1</code> <br>∘',(⎕ucs 10),'<code>(verbose: 1 ',(⎕ucs 9671),' box: 1)</code></span> <em>either</em> <a',(⎕ucs 10)
_,←'href="#f-option-details"><strong>positional</strong></a> or <a',(⎕ucs 10),'href="#f-option-details"><strong>keyword</strong></a> (namespace-based)',(⎕ucs 10)
_,←'options, based on <em>APL</em> Array Notation (in',(⎕ucs 173),'tro',(⎕ucs 173),'duced in Dyalog',(⎕ucs 10),'20);</p></li>',(⎕ucs 10)
_,←'<li><p>Multiline (matrix) output built up field-by-field, left-to-right,',(⎕ucs 10),'from values and expressions in the calling environment or arguments to',(⎕ucs 10),'<strong>∆F</strong>;</p>'
_,←(⎕ucs 10),'<ul>',(⎕ucs 10),'<li>After all fields are generated, they are aligned vertically, then',(⎕ucs 10),'concatenated to form a single character matrix: <strong><em>the return',(⎕ucs 10)
_,←'value from</em></strong> <strong>∆F</strong>. <span',(⎕ucs 10),'class="margin-note"><br>As a prototype, <strong>∆F</strong> is',(⎕ucs 10)
_,←'relatively slow, using an <em>APL</em> recursive scan to analyze the',(⎕ucs 10),'<strong>f',(⎕ucs 8209),'string</strong>. For a way to speed up frequently used',(⎕ucs 10),'<em>f',(⎕ucs 8209)
_,←'strings</em>, see the <a',(⎕ucs 10),'href="#f-option-details"><strong><em>dfn</em></strong>',(⎕ucs 10),'option</a>.</span></li>',(⎕ucs 10),'</ul></li>',(⎕ucs 10),'</ul>',(⎕ucs 10)
_,←'<p><strong>∆F</strong> is designed for ease of use, <em>ad hoc</em>',(⎕ucs 10),'debugging, fine-grained formatting and informal user interaction, built',(⎕ucs 10)
_,←'using Dyalog functions and operators.</p>',(⎕ucs 10),'<details>',(⎕ucs 10),'<!-- option: open -->',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'Recap: <em>The Three Field Types</em>'
_,←(⎕ucs 10),'</summary>',(⎕ucs 10),'<p><a id="table-field-types" class="scroll-target"></a></p>',(⎕ucs 10),'<table>',(⎕ucs 10),'<caption>2a. <strong>The Three Field Types</strong></caption>',(⎕ucs 10)
_,←'<colgroup>',(⎕ucs 10),'<col style="width: 16%" />',(⎕ucs 10),'<col style="width: 17%" />',(⎕ucs 10),'<col style="width: 31%" />',(⎕ucs 10),'<col style="width: 34%" />',(⎕ucs 10),'</colgroup>'
_,←(⎕ucs 10),'<thead>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<th style="text-align: center;">Field Type</th>',(⎕ucs 10),'<th style="text-align: center;">Syntax</th>',(⎕ucs 10)
_,←'<th style="text-align: center;">Examples</th>',(⎕ucs 10),'<th style="text-align: center;">Displaying</th>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</thead>',(⎕ucs 10),'<tbody>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;"><em>Text</em> F.</td>',(⎕ucs 10),'<td style="text-align: center;"><em>Unicode text</em></td>',(⎕ucs 10),'<td style="text-align: center;"><code>Cats`',(⎕ucs 9671)
_,←'and`',(⎕ucs 9671),'dogs!</code></td>',(⎕ucs 10),'<td style="text-align: center;">2-D Text</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;"><em>Code</em> F.</td>'
_,←(⎕ucs 10),'<td style="text-align: center;"><code>{</code><em>dfn code',(⎕ucs 10),'plus</em><code>}</code>',(⎕ucs 10),'<code>{</code><em>shortcuts</em><code>}</code></td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><code>{"1`',(⎕ucs 9671),'one"} {"2`',(⎕ucs 9671),'two"}`</code>',(⎕ucs 10),'<code>{"F5.1" $ (32+9×÷∘5)degC}</code></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Arbitrary <em>APL</em> Express',(⎕ucs 173),'ions via',(⎕ucs 10),'dfns, including <strong>Quoted Strings</strong></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;"><em>Space</em> F. <br>(<em>Null',(⎕ucs 10),'Space</em> F.)</td>',(⎕ucs 10),'<td style="text-align: center;"><code>{</code><big>',(⎕ucs 9248 32 9248 10 9248)
_,←'</big><code>}</code> <br> <code>{}</code></td>',(⎕ucs 10),'<td style="text-align: center;"><code>{  }</code> <br>',(⎕ucs 10),'<code>{}</code></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Spacing <br> (Field Separation)</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</tbody>',(⎕ucs 10),'</table>',(⎕ucs 10),'<br>',(⎕ucs 10),'</details>',(⎕ucs 10),'</details>'
_,←(⎕ucs 10),'<div class="page-break">',(⎕ucs 10 10),'</div>',(⎕ucs 10),'<h1 data-number="3" id="quick-start"><span',(⎕ucs 10),'class="header-section-number">3</span> Quick Start</h1>',(⎕ucs 10)
_,←'<details>',(⎕ucs 10),'<!-- option: open -->',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'<span style="opacity:0.6;">Show/Hide</span> <em>Quick Start</em>',(⎕ucs 10),'</summary>',(⎕ucs 10)
_,←'<p><a id="inside-quick-start" class="scroll-target"></a></p>',(⎕ucs 10),'<h3 class="unnumbered"',(⎕ucs 10),'id="heres-a-quick-start-for-the-tldr-too-long-didnt-readcrowd."><span',(⎕ucs 10)
_,←'class="blue"><strong>Here',(⎕ucs 8217),'s a quick start for the',(⎕ucs 10),'<small><strong>TL;DR</strong></small> <span class="margin-note">too long',(⎕ucs 10),'didn',(⎕ucs 8217)
_,←'t read</span>crowd. </strong></span></h3>',(⎕ucs 10),'<p><strong>3.1: Embed variables</strong></p>',(⎕ucs 10),'<pre><code>   n← ⍪1+⍳3 ',(⎕ucs 9671),' nPi← ⍪○n  ',(⎕ucs 10)
_,←'   ∆F &#39;For n={ n }, n×Pi={ nPi }&#39;  ',(⎕ucs 10),'For n=1, n×Pi=3.141592653589793',(⎕ucs 10),'      2       6.283185307179586',(⎕ucs 10),'      3       9.42477796076938 </code></pre>'
_,←(⎕ucs 10),'<p><strong>3.2: Embed expressions</strong></p>',(⎕ucs 10),'<pre><code>   ∆F &#39;For n={ ⍪1+⍳3 }, n×Pi={ ⍪○1+⍳3 }&#39;  ',(⎕ucs 10),'For n=1, n×Pi=3.141592653589793',(⎕ucs 10)
_,←'      2       6.283185307179586',(⎕ucs 10),'      3       9.42477796076938 </code></pre>',(⎕ucs 10),'<p><strong>3.3: Build multiline text fields and code fields</strong></p>',(⎕ucs 10)
_,←'<pre><code>⍝      &lt;----  text field  ----&gt;   &lt;- text field -&gt;    &lt;- code field str -&gt;',(⎕ucs 10),'   ∆F &#39;Cats`',(⎕ucs 9671),'Elephants`',(⎕ucs 9671),'Monkeys{ }like`'
_,←(⎕ucs 9671),'enjoy`',(⎕ucs 9671),'eat{ }{&quot;toys.`',(⎕ucs 9671),'tv.`',(⎕ucs 9671),'fruit.&quot;}&#39;',(⎕ucs 10),'Cats      like  toys. ',(⎕ucs 10),'Elephants enjoy tv.   ',(⎕ucs 10)
_,←'Monkeys   eat   fruit.</code></pre>',(⎕ucs 10),'<p><strong>3.4: Apply the Format shortcut $</strong></p>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;For n={ ⍪1 2 3 }, n×Pi={ &quot;F7.5&quot;$ ○1 2 3 }&#39;  ',(⎕ucs 10),'For n=1, n×Pi=3.14159',(⎕ucs 10),'      2       6.28319',(⎕ucs 10),'      3       9.42478</code></pre>'
_,←(⎕ucs 10),'<p><strong>3.5: Add Omega shortcut expressions</strong></p>',(⎕ucs 10),'<pre><code>⍝  `⍵1 ==&gt; (⍵⊃⍨ 1+⎕IO), i.e. ⎕IO-independently',(⎕ucs 10)
_,←'   ∆F &#39;For n={ ⍪`⍵2 }, n×Pi={ `⍵1 $ ○`⍵2 }&#39; &#39;F7.5&#39; (1 2 3)',(⎕ucs 10),'For n=1, n×Pi=3.14159',(⎕ucs 10),'      2       6.28319',(⎕ucs 10),'      3       9.42478</code></pre>'
_,←(⎕ucs 10),'<p><strong>3.6: Add the Box shortcut</strong></p>',(⎕ucs 10),'<pre><code>   ∆F &#39;For n={ `B ⍪`⍵1 }, n×Pi={ `B &quot;F7.5&quot;$ ○`⍵1 }&#39; (1 2 3)',(⎕ucs 10),'For n='
_,←(⎕ucs 9484 9472 9488),', n×Pi=',(⎕ucs 9484,(7/9472),9488 10),'      ',(⎕ucs 9474 49 9474),'       ',(⎕ucs 9474),'3.14159',(⎕ucs 9474 10),'      ',(⎕ucs 9474 50 9474),'       ',(⎕ucs 9474),'6.28319'
_,←(⎕ucs 9474 10),'      ',(⎕ucs 9474 51 9474),'       ',(⎕ucs 9474),'9.42478',(⎕ucs 9474 10),'      ',(⎕ucs 9492 9472 9496),'       ',(⎕ucs 9492,(7/9472),9496),'</code></pre>',(⎕ucs 10)
_,←'<p><strong>3.7: Use Self-Documenting Code Fields and the Box',(⎕ucs 10),'option</strong></p>',(⎕ucs 10),'<pre class="dyalog20"><code>   names←  ⍪&#39;Ted&#39; &#39;Mary&#39; &#39;Sam&#39;'
_,←(⎕ucs 10),'   scores← ⍪(70 66 44) (82 88 92) (90 77 83)',(⎕ucs 10),'   Ave← +/÷≢',(⎕ucs 10),'   (box: 1) ∆F &#39;{names↓}{scores↓}{1⍕Ave¨scores↓}&#39;'
_,←(⎕ucs 10 9484,(6/9472),9516,(10/9472),9516,(13/9472),9488 10 9474),'names↓',(⎕ucs 9474),' scores↓  ',(⎕ucs 9474),'1⍕Ave¨scores↓',(⎕ucs 9474 10 9474),' Ted  ',(⎕ucs 9474),' 70 66 44 ',(⎕ucs 9474)
_,←'     60.0    ',(⎕ucs 9474 10 9474),' Mary ',(⎕ucs 9474),' 82 88 92 ',(⎕ucs 9474),'     87.3    ',(⎕ucs 9474 10 9474),' Sam  ',(⎕ucs 9474),' 90 77 83 ',(⎕ucs 9474),'     83.3    '
_,←(⎕ucs 9474 10 9492,(6/9472),9524,(10/9472),9524,(13/9472),9496),'</code></pre>',(⎕ucs 10),'<div class="page-break">',(⎕ucs 10 10),'</div>',(⎕ucs 10)
_,←'<p><strong>3.8: Serialise an object in Array Notation</strong></p>',(⎕ucs 10),'<pre><code>   anim←(cat: 1 ',(⎕ucs 9671),' dog: 2 ',(⎕ucs 9671),' mouse: 3)',(⎕ucs 10)
_,←'   ∆F &#39;{`⍵1 `S anim ↓} { `⍵2 `S anim↓}&#39; 1 0    ',(⎕ucs 10),'  `⍵1 `S anim ↓        `⍵2 `S anim↓ ',(⎕ucs 10),'(cat:1',(⎕ucs 9671),'dog:2',(⎕ucs 9671),'mouse:3',(⎕ucs 9671),')  (        '
_,←(⎕ucs 10),'                         cat:1   ',(⎕ucs 10),'                         dog:2   ',(⎕ucs 10),'                         mouse:3 ',(⎕ucs 10),'                       )          </code></pre>'
_,←(⎕ucs 10),'<p><strong>3.9: Grab utility automagically from</strong>',(⎕ucs 10),'<strong><em>dfns</em></strong> <strong>workspace (or from a',(⎕ucs 10),'file)</strong></p>',(⎕ucs 10)
_,←'<pre><code>   ∆F&#39;{ £.hex 57005 48879 51966}&#39;   ⍝ Get hex fn to convert dec to hexadecimal!',(⎕ucs 10)
_,←' dead  beef  cafe                   ⍝ Yes, those are ordinary hexadecimal numbers!</code></pre>',(⎕ucs 10),'<h3 class="unnumbered"',(⎕ucs 10)
_,←'id="thats-80-of-what-you-need.-read-on-for-more"><span',(⎕ucs 10),'class="blue"><strong>That',(⎕ucs 8217),'s 80% of what you need. Read on for',(⎕ucs 10),'more',(⎕ucs 8230),'</strong></span></h3>'
_,←(⎕ucs 10),'</details>',(⎕ucs 10),'<div class="page-break">',(⎕ucs 10 10),'</div>',(⎕ucs 10),'<h1 data-number="4" id="f-examples-a-primer"><span',(⎕ucs 10)
_,←'class="header-section-number">4</span> ∆F Examples: A Primer</h1>',(⎕ucs 10),'<details>',(⎕ucs 10),'<!-- option: open -->',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194)
_,←'<span style="opacity:0.6;">Show/Hide</span> <em>Examples: A Primer</em>',(⎕ucs 10),'</summary>',(⎕ucs 10),'<p><a id="inside-examples" class="scroll-target"></a></p>',(⎕ucs 10)
_,←'<p>Before providing information on <strong>∆F</strong> syntax and other',(⎕ucs 10),'details, <em>let',(⎕ucs 8217),'s start with some examples</em>',(⎕ucs 8230),'</p>',(⎕ucs 10),'<p>First, let'
_,←(⎕ucs 8217),'s set some context for the examples. (You can set these',(⎕ucs 10),'however you want.)</p>',(⎕ucs 10),'<p><span class="margin-note">All examples in this document assume',(⎕ucs 10)
_,←'<code>⎕IO←0 ',(⎕ucs 9671),' ⎕ML←1</code>.</span></p>',(⎕ucs 10),'<pre><code>   ⎕IO ⎕ML← 0 1</code></pre>',(⎕ucs 10),'<h2 data-number="4.1" id="code-fields"><span',(⎕ucs 10)
_,←'class="header-section-number">4.1</span> Code Fields</h2>',(⎕ucs 10),'<p>Here are <strong>Code</strong> fields with simple variables.</p>',(⎕ucs 10)
_,←'<p><span class="margin-note">So far, this is like everybody else',(⎕ucs 8217 115 10),'<em>f',(⎕ucs 8209),'strings</em>. </span></p>',(⎕ucs 10),'<pre><code>   name← &#39;Fred&#39; ',(⎕ucs 9671)
_,←' age← 43',(⎕ucs 10),'   ∆F &#39;The patient&#39;&#39;s name is {name}. {name} is {age} years old.&#39;',(⎕ucs 10),'The patient&#39;s name is Fred. Fred is 43 years old.</code></pre>',(⎕ucs 10)
_,←'<p><strong>Code</strong> fields can contain arbitrary expressions. With',(⎕ucs 10),'default options, <strong>∆F</strong> always returns a single character',(⎕ucs 10)
_,←'matrix. Here <strong>∆F</strong> returns a matrix with 2 rows and 32',(⎕ucs 10),'columns.</p>',(⎕ucs 10),'<p><span class="margin-note"> Now we',(⎕ucs 8217),'re taking advantage of',(⎕ucs 10)
_,←'<em>APL</em>',(⎕ucs 8217),'s array-oriented style. </span></p>',(⎕ucs 10),'<pre><code>   tempC← ⍪35 85',(⎕ucs 10),'   ⍴⎕← ∆F &#39;The temperature is {tempC}{2 2⍴&quot;',(⎕ucs 176)
_,←'C&quot;} or {32+tempC×9÷5}{2 2⍴&quot;',(⎕ucs 176),'F&quot;}&#39;',(⎕ucs 10),'The temperature is 35',(⎕ucs 176),'C or  95',(⎕ucs 176 70 46 10),'                   85',(⎕ucs 176),'C    185'
_,←(⎕ucs 176 70 10),'2 32</code></pre>',(⎕ucs 10),'<p>Here, we assign the <em>f',(⎕ucs 8209),'string</em> to an <em>APL</em> variable,',(⎕ucs 10),'then call <strong>∆F</strong> twice!</p>',(⎕ucs 10)
_,←'<p><span class="margin-note">Setting <code>⎕RL</code> ensures our random',(⎕ucs 10),'numbers aren',(⎕ucs 8217),'t random! </span></p>',(⎕ucs 10),'<pre><code>   ⎕RL← 2342342',(⎕ucs 10)
_,←'   n← ≢names← &#39;Mary&#39; &#39;Jack&#39; &#39;Tony&#39;',(⎕ucs 10),'   prize← 1000',(⎕ucs 10),'   f← &#39;Customer {names⊃⍨ ?n} wins £{?prize}!&#39;',(⎕ucs 10),'   ∆F f',(⎕ucs 10)
_,←'Customer Jack wins £80!',(⎕ucs 10),'   ∆F f',(⎕ucs 10),'Customer Jack wins £230!</code></pre>',(⎕ucs 10),'<p>Isn',(⎕ucs 8217),'t Jack lucky, winning twice in a row!</p>',(⎕ucs 10)
_,←'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'View a fancier example',(⎕ucs 8230 10),'</summary>',(⎕ucs 10)
_,←'<p><span class="margin-note"><br><a href="#winner2">See a different',(⎕ucs 10),'method using the <strong>Wrap</strong> shortcut</a>. </span></p>',(⎕ucs 10),'<div id="winner1">',(⎕ucs 10)
_,←'<pre><code> ⍝ Be sure everyone wins something.',(⎕ucs 10),'   n← ≢names← &#39;Mary&#39; &#39;Jack&#39; &#39;Tony&#39;',(⎕ucs 10),'   prize← 1000',(⎕ucs 10)
_,←'   ∆F &#39;{ ↑names }{ ⍪n⍴ ⊂&quot;wins&quot; }{ &quot;£&quot;, ⍕⍪?n⍴ prize}&#39;',(⎕ucs 10),'Mary wins £711',(⎕ucs 10),'Jack wins £298',(⎕ucs 10),'Tony wins £242</code></pre>',(⎕ucs 10),'</div>'
_,←(⎕ucs 10),'</details>',(⎕ucs 10),'<h2 data-number="4.2" id="text-fields-and-space-fields"><span',(⎕ucs 10),'class="header-section-number">4.2</span> Text Fields and Space',(⎕ucs 10),'Fields</h2>'
_,←(⎕ucs 10),'<p>Below, we have some multi',(⎕ucs 173),'line <strong>Text</strong> fields separated',(⎕ucs 10),'by non-null <strong>Space</strong> fields.</p>',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li>The backtick is our ',(⎕ucs 8220),'escape',(⎕ucs 8221),' character.</li>',(⎕ucs 10),'<li>The sequence `',(⎕ucs 9671),' generates a new line in the current',(⎕ucs 10)
_,←'<strong>Text</strong> field.</li>',(⎕ucs 10),'<li>Each <strong>Space</strong> field <code>{ }</code> in this example',(⎕ucs 10),'contains one space within its braces. It produces a matrix a'
_,←(⎕ucs 10),'<em>single</em> space wide with as many rows as required to catenate it',(⎕ucs 10),'with adjacent fields.</li>',(⎕ucs 10),'</ul>',(⎕ucs 10)
_,←'<p>A <strong>Space</strong> field is useful here because each multi',(⎕ucs 173),'line',(⎕ucs 10),'field is built in its own rectangular space.</p>',(⎕ucs 10),'<pre><code>   ∆F &#39;This`'
_,←(⎕ucs 9671),'is`',(⎕ucs 9671),'an`',(⎕ucs 9671),'example{ }Of`',(⎕ucs 9671),'multiline{ }Text`',(⎕ucs 9671),'Fields&#39;',(⎕ucs 10),'This    Of         Text',(⎕ucs 10),'is      multiline  Fields'
_,←(⎕ucs 10 97 110 10),'example</code></pre>',(⎕ucs 10),'<div class="page-break">',(⎕ucs 10 10),'</div>',(⎕ucs 10),'<h2 data-number="4.3" id="null-space-fields"><span',(⎕ucs 10)
_,←'class="header-section-number">4.3</span> Null Space Fields</h2>',(⎕ucs 10),'<p>Two adjacent <strong>Text</strong> fields can be separated by a null',(⎕ucs 10)
_,←'<strong>Space</strong> field <code>{}</code>, for example when at least',(⎕ucs 10),'one field contains multiline input that you want formatted separately',(⎕ucs 10)
_,←'from others, keeping each field in its own rectangular space:</p>',(⎕ucs 10),'<pre><code>⍝  Extra space here ↓',(⎕ucs 10),'   ∆F &#39;Cat`',(⎕ucs 9671),'Elephant `',(⎕ucs 9671),'Mouse{}Felix`'
_,←(⎕ucs 9671),'Dumbo`',(⎕ucs 9671),'Mickey&#39;',(⎕ucs 10),'Cat      Felix',(⎕ucs 10),'Elephant Dumbo',(⎕ucs 10),'Mouse    Mickey</code></pre>',(⎕ucs 10)
_,←'<p>In the above example, we added an extra space after the longest',(⎕ucs 10),'animal name, <em>Elephant</em>, so it wouldn',(⎕ucs 8217),'t run into the next word,',(⎕ucs 10),'<em>Dumbo</em>.</p>'
_,←(⎕ucs 10),'<p><strong>But wait! There',(⎕ucs 8217),'s an easier way!</strong></p>',(⎕ucs 10),'<p>Here, you surely want the lefthand field to be guaranteed to have a',(⎕ucs 10)
_,←'space after <em>each</em> word without fiddling; a',(⎕ucs 10),'<strong>Space</strong> field with at least one space will solve the',(⎕ucs 10),'problem:</p>',(⎕ucs 10)
_,←'<pre><code>⍝                          ↓↓↓',(⎕ucs 10),'   ∆F &#39;Cat`',(⎕ucs 9671),'Elephant`',(⎕ucs 9671),'Mouse{ }Felix`',(⎕ucs 9671),'Dumbo`',(⎕ucs 9671),'Mickey&#39;',(⎕ucs 10),'Cat      Felix'
_,←(⎕ucs 10),'Elephant Dumbo',(⎕ucs 10),'Mouse    Mickey</code></pre>',(⎕ucs 10),'<h2 data-number="4.4" id="code-fields-continued"><span',(⎕ucs 10)
_,←'class="header-section-number">4.4</span> Code Fields (Continued)</h2>',(⎕ucs 10),'<p><span class="margin-note">We could have used a <strong>Space</strong>',(⎕ucs 10),'field <code>{',(⎕ucs 160)
_,←'}</code> here as well.</span> And this is the same example',(⎕ucs 10),'with <em>identical</em> output, but built using two',(⎕ucs 10)
_,←'<strong>Code</strong> fields separated by a <strong>Text</strong> field',(⎕ucs 10),'with a single space.</p>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;{↑&quot;Cat&quot; &quot;Elephant&quot; &quot;Mouse&quot;} {↑&quot;Felix&quot; &quot;Dumbo&quot; &quot;Mickey&quot;}&#39;',(⎕ucs 10),'Cat      Felix',(⎕ucs 10),'Elephant Dumbo'
_,←(⎕ucs 10),'Mouse    Mickey</code></pre>',(⎕ucs 10),'<p>Here',(⎕ucs 8217),'s a similar example with double quote-delimited strings in',(⎕ucs 10)
_,←'<strong>Code</strong> fields with the newline sequence,',(⎕ucs 10),'<code>`',(⎕ucs 9671),'</code>:</p>',(⎕ucs 10),'<pre><code>   ∆F &#39;{&quot;This`',(⎕ucs 9671),'is`',(⎕ucs 9671),'an`'
_,←(⎕ucs 9671),'example&quot;} {&quot;Of`',(⎕ucs 9671),'Multiline&quot;} {&quot;Strings`',(⎕ucs 9671),'in`',(⎕ucs 9671),'Code`',(⎕ucs 9671),'Fields&quot;}&#39;',(⎕ucs 10),'This    Of         Strings'
_,←(⎕ucs 10),'is      Multiline  in',(⎕ucs 10),'an                 Code',(⎕ucs 10),'example            Fields</code></pre>',(⎕ucs 10),'<p>Here is some multiline data we',(⎕ucs 8217)
_,←'ll add to our <strong>Code</strong>',(⎕ucs 10),'fields.</p>',(⎕ucs 10),'<p><span class="margin-note"><br><br><br><br><br>Again, we use',(⎕ucs 10)
_,←'<em>APL</em> <em>mix</em> <code>↑</code> to generate multiline objects',(⎕ucs 10),'(matrices).</span></p>',(⎕ucs 10),'<pre><code>   fNm←  &#39;John&#39; &#39;Mary&#39; &#39;Ted&#39;',(⎕ucs 10)
_,←'   lNm←  &#39;Smith&#39; &#39;Jones&#39; &#39;Templeton&#39;',(⎕ucs 10),'   addr← &#39;24 Mulberry Ln&#39; &#39;22 Smith St&#39; &#39;12 High St&#39;',(⎕ucs 10 10)
_,←'   ∆F &#39;{↑fNm} {↑lNm} {↑addr}&#39;',(⎕ucs 10),'John Smith     24 Mulberry Ln',(⎕ucs 10),'Mary Jones     22 Smith St',(⎕ucs 10),'Ted  Templeton 12 High St</code></pre>',(⎕ucs 10)
_,←'<p><span class="margin-note">We formally discuss the <code>⎕FMT</code>',(⎕ucs 10),'short',(⎕ucs 173),'cut <code>$</code> <a href="#the-format-shortcut">below</a>.</span>',(⎕ucs 10)
_,←'<span class="margin-note"><br><br>In this example, we could have used',(⎕ucs 10),'<code>0⍕⍪</code> and <code>1⍕⍪</code> here, of course. But we wanted to',(⎕ucs 10),'remind you what Dyalog'
_,←(⎕ucs 8217),'s <code>⎕FMT</code> can do! </span></p>',(⎕ucs 10),'<p>Here',(⎕ucs 8217),'s a slightly more interesting code expression, using',(⎕ucs 10)
_,←'<code>$</code> (a shortcut for <code>⎕FMT</code>) to round Centigrade',(⎕ucs 10),'numbers to the nearest whole degree and Fahrenheit numbers to the',(⎕ucs 10),'nearest tenth of a degree.</p>'
_,←(⎕ucs 10),'<pre><code>   cv← 11.3 29.55 59.99',(⎕ucs 10),'   ∆F &#39;The temperature is {&quot;I2&quot; $ cv}',(⎕ucs 176),'C or {&quot;F5.1&quot;$ 32+9×cv÷5}',(⎕ucs 176),'F&#39;',(⎕ucs 10)
_,←'The temperature is 11',(⎕ucs 176),'C or  52.3',(⎕ucs 176 70 10),'                   30       85.2',(⎕ucs 10),'                   60      140.0</code></pre>',(⎕ucs 10)
_,←'<h2 data-number="4.5" id="the-box-shortcut"><span',(⎕ucs 10),'class="header-section-number">4.5</span> The Box Shortcut</h2>',(⎕ucs 10)
_,←'<p><strong>∆F</strong> shortcuts are concise <em>names</em> for useful',(⎕ucs 10),'<em>f-string</em> utilities used inside <strong>Code</strong> fields.',(⎕ucs 10),'Let',(⎕ucs 8217)
_,←'s introduce shortcuts through <code>`B</code>, the',(⎕ucs 10),'<strong>Box</strong> shortcut. Here we use <code>`B</code> to place',(⎕ucs 10)
_,←'boxes around key objects in <strong>Code</strong> fields, building on',(⎕ucs 10),'the previous example.</p>',(⎕ucs 10),'<pre><code>   cv← 11.3 29.55 59.99',(⎕ucs 10),'   ∆F &#39;`',(⎕ucs 9671)
_,←'The temperature is {`B &quot;I2&quot; $ cv}`',(⎕ucs 9671 176),'C or {`B &quot;F5.1&quot; $ 32+9×cv÷5}`',(⎕ucs 9671 176),'F&#39;',(⎕ucs 10),'                   ',(⎕ucs 9484 9472 9472 9488),'      '
_,←(⎕ucs 9484,(5/9472),9488 10),'The temperature is ',(⎕ucs 9474 49 49 9474 176),'C or ',(⎕ucs 9474),' 52.3',(⎕ucs 9474 176 70 10),'                   ',(⎕ucs 9474 51 48 9474),'      ',(⎕ucs 9474)
_,←' 85.2',(⎕ucs 9474 10),'                   ',(⎕ucs 9474 54 48 9474),'      ',(⎕ucs 9474),'140.0',(⎕ucs 9474 10),'                   ',(⎕ucs 9492 9472 9472 9496),'      ',(⎕ucs 9492,(5/9472),9496)
_,←'</code></pre>',(⎕ucs 10),'<p>For full information on all of the current shortcuts, see <a',(⎕ucs 10),'href="#code-field-shortcuts"><strong>Section 5.5</strong></a> in the <a',(⎕ucs 10)
_,←'href="#f-reference"><strong>∆F</strong> <em>Reference</em></a> below.',(⎕ucs 10),'For an abridged preview, look no further.</p>',(⎕ucs 10),'<details>',(⎕ucs 10),'<!-- option: open -->',(⎕ucs 10)
_,←'<summary class="summary">',(⎕ucs 10 8194),'A Preview of <em>Code Field Shortcuts</em>',(⎕ucs 10),'</summary>',(⎕ucs 10),'<p><strong>Code</strong> field <strong><em>Shortcuts</em></strong>'
_,←(⎕ucs 10),'include:</p>',(⎕ucs 10),'<p><a id="inside-brief-shortcuts" class="scroll-target"></a></p>',(⎕ucs 10),'<table>',(⎕ucs 10),'<caption>3a. <strong>Brief Summary of Code Field',(⎕ucs 10)
_,←'Shortcuts</strong></caption>',(⎕ucs 10),'<colgroup>',(⎕ucs 10),'<col style="width: 5%" />',(⎕ucs 10),'<col style="width: 19%" />',(⎕ucs 10),'<col style="width: 20%" />',(⎕ucs 10)
_,←'<col style="width: 54%" />',(⎕ucs 10),'</colgroup>',(⎕ucs 10),'<thead>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<th style="text-align: left;">Shortcut</th>',(⎕ucs 10)
_,←'<th style="text-align: center;">Name</th>',(⎕ucs 10),'<th style="text-align: center;">Syntax</th>',(⎕ucs 10),'<th style="text-align: left;">Default Meaning</th>',(⎕ucs 10),'</tr>',(⎕ucs 10)
_,←'</thead>',(⎕ucs 10),'<tbody>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`B</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Box</td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><code>`B ⍵</code></td>',(⎕ucs 10),'<td style="text-align: justify;">Place <code>⍵</code> in a box.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><strong>`C</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Commas</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`C ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Add commas to large numbers',(⎕ucs 10),'<code>⍵</code>.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><strong>`D</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Date-Time</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`D ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Synonym for <strong>`T</strong>.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`F</strong>,',(⎕ucs 10)
_,←'<strong>$</strong></td>',(⎕ucs 10),'<td style="text-align: center;">⎕FMT</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺] $ ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><code>⍺ ⎕FMT ⍵</code>.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`J</strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Justify</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`J ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Justify <em>rows of</em> <code>⍵</code>',(⎕ucs 10),'according to <code>⍺</code>.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><strong>`L</strong>,',(⎕ucs 10),'<strong>£</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Session Library</td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><code>£, £.arr, £.dfn</code></td>',(⎕ucs 10),'<td style="text-align: justify;">Use arrays, dfns, and dops in a private,',(⎕ucs 10)
_,←'session library, automatically loading from files or workspaces.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`Q</strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Quote</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`Q ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Place character objects in <code>⍵</code>',(⎕ucs 10),'in APL quotes, row by row.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><strong>`S</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Serialise</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`S ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Serialise an <em>APL</em> array',(⎕ucs 10),'<code>⍵</code>, i.e.',(⎕ucs 160),'display it in <em>APL</em> Array Notation.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>'
_,←(⎕ucs 10),'<td style="text-align: justify;"><strong>`T</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Date-Time</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`T ⍵</code></td>'
_,←(⎕ucs 10),'<td style="text-align: justify;">Displays ⎕TS-style timestamps',(⎕ucs 10),'<code>⍵</code> according to Dyalog date-time template',(⎕ucs 10),'<code>⍺</code>.</td>',(⎕ucs 10),'</tr>'
_,←(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`W</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Wrap</td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><code>[⍺]`W ⍵</code></td>',(⎕ucs 10),'<td style="text-align: justify;">Wraps the <em>rows of</em> simple arrays',(⎕ucs 10)
_,←'in <code>⍵</code> in left and right decorators <code>⍺</code>.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`⍵',(⎕ucs 119889 119889),'</strong>,'
_,←(⎕ucs 10),'<strong>',(⎕ucs 9081 119889 119889),'</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Omega',(⎕ucs 10),'Shortcut<br>(<small>EXPLICIT</small>)</td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><code>`⍵',(⎕ucs 119889 119889),'</code></td>',(⎕ucs 10),'<td style="text-align: justify;">Select <strong>∆F</strong> argument',(⎕ucs 10),'<code>'
_,←(⎕ucs 119889 119889),'</code>, i.e.',(⎕ucs 160),'<code>(⍵⊃⍨ ',(⎕ucs 119889 119889),'+⎕IO)</code>, given ',(⎕ucs 119889 119889),' an',(⎕ucs 10)
_,←'<code>⎕IO</code>-independent integer <em>offset</em>.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`⍵</strong>,',(⎕ucs 10),'<strong>',(⎕ucs 9081)
_,←'</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Omega',(⎕ucs 10),'Shortcut<br>(<small>IMPLICIT</small>)</td>',(⎕ucs 10),'<td style="text-align: center;"><code>`⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Selects the <strong><em>next</em></strong>',(⎕ucs 10),'argument to <strong>∆F</strong>, scanning left to right.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><strong>→</strong><br><strong>↓</strong>',(⎕ucs 10),'<em>or</em> <strong>%</strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Self-documenting <strong>Code</strong>',(⎕ucs 10),'Fields <small>(SDCFs)</small></td>',(⎕ucs 10),'<td',(⎕ucs 10),'style="text-align: center;"><code>{',(⎕ucs 8230)
_,←'→}</code><br><code>{',(⎕ucs 8230),'↓}</code></td>',(⎕ucs 10),'<td style="text-align: justify;">Displays code field source to left',(⎕ucs 10),'of/above its value.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10)
_,←'</tbody>',(⎕ucs 10),'</table>',(⎕ucs 10),'</details>',(⎕ucs 10),'<h2 data-number="4.6" id="box-mode"><span',(⎕ucs 10),'class="header-section-number">4.6</span> Box Mode</h2>',(⎕ucs 10)
_,←'<p>But what if you want to place a box around every',(⎕ucs 10),'<strong>Code</strong>, <strong>Text</strong>,',(⎕ucs 10),'<strong><em>and</em></strong> <strong>Space</strong> field? We just use'
_,←(⎕ucs 10),'the <strong>box</strong> mode option!</p>',(⎕ucs 10),'<p>While we can',(⎕ucs 8217),'t place boxes inside text (or space) fields using',(⎕ucs 10)
_,←'<code>`B</code>, we can place a box around',(⎕ucs 10),'<strong><em>each</em></strong> field (<em>regardless</em> of type) by',(⎕ucs 10),'setting <strong>∆F</strong>',(⎕ucs 8217),'s <a',(⎕ucs 10)
_,←'href="#f-option-details"><strong>box</strong> mode</a> option, <span',(⎕ucs 10),'class="margin-note"><strong>box mode:</strong> <code>0 0 1</code>',(⎕ucs 10)
_,←'<em>or</em> <code>(box: 1)</code></span>to <code>1</code>:</p>',(⎕ucs 10),'<pre><code>   cv← 11.3 29.55 59.99',(⎕ucs 10),'⍝   ↓¯¯¯ box mode,  or:  0 0 1',(⎕ucs 10),'   (box: 1) ∆F &#39;`'
_,←(⎕ucs 9671),'The temperature is {&quot;I2&quot; $ cv}`',(⎕ucs 9671 176),'C or {&quot;F5.1&quot; $ 32+9×cv÷5}`',(⎕ucs 9671 176),'F&#39;'
_,←(⎕ucs 10 9484,(19/9472),9516 9472 9472 9516,(6/9472),9516,(5/9472),9516 9472 9472 9488 10 9474),'                   ',(⎕ucs 9474 49 49 9474),'      ',(⎕ucs 9474),' 52.3'
_,←(⎕ucs 9474 32 32 9474 10 9474),'The temperature is ',(⎕ucs 9474 51 48 9474 176),'C or ',(⎕ucs 9474),' 85.2',(⎕ucs 9474 176 70 9474 10 9474),'                   ',(⎕ucs 9474 54 48 9474),'      '
_,←(⎕ucs 9474),'140.0',(⎕ucs 9474 32 32 9474 10 9492,(19/9472),9524 9472 9472 9524,(6/9472),9524,(5/9472),9524 9472 9472 9496),'</code></pre>',(⎕ucs 10)
_,←'<p>We said you could place a box around every field, but there',(⎕ucs 8217),'s an',(⎕ucs 10),'exception. Null <strong>Space</strong> fields <code>{}</code>,',(⎕ucs 10)
_,←'<em>i.e.</em> 0-width <strong>Space</strong> fields, are discarded once',(⎕ucs 10),'they',(⎕ucs 8217),'ve done their work of ensuring adjacent fields (typically,',(⎕ucs 10)
_,←'<strong>Text</strong> fields) are displayed in their own rectangular',(⎕ucs 10),'space.</p>',(⎕ucs 10),'<p>Try evaluating this expression on your own:</p>',(⎕ucs 10)
_,←'<pre><code>    (box: 1) ∆F &#39;abc{}def{}{}ghi{&quot;&quot;}jkl{ }mno&#39;   </code></pre>',(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'Peek at answer'
_,←(⎕ucs 10),'</summary>',(⎕ucs 10),'<pre><code>   (box: 1) ∆F &#39;abc{}def{}{}ghi{&quot;&quot;}jkl{ }mno&#39;'
_,←(⎕ucs 10 9484,(3/9472),9516,(3/9472),9516,(3/9472),9516 9516,(3/9472),9516 9472 9516,(3/9472),9488 10 9474),'abc',(⎕ucs 9474),'def',(⎕ucs 9474),'ghi',(⎕ucs 9474 9474),'jkl',(⎕ucs 9474 32 9474),'mno'
_,←(⎕ucs 9474 10 9492,(3/9472),9524,(3/9472),9524,(3/9472),9524 9524,(3/9472),9524 9472 9524,(3/9472),9496),'</code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10)
_,←'<p>In contrast, <strong>Code</strong> fields that return null',(⎕ucs 10),'values',(⎕ucs 8212),'like <code>{""}</code> above',(⎕ucs 8212),' <em>will</em> be displayed!</p>',(⎕ucs 10)
_,←'<h2 data-number="4.7" id="omega-shortcuts-explicit"><span',(⎕ucs 10),'class="header-section-number">4.7</span> Omega Shortcuts (Explicit)</h2>',(⎕ucs 10)
_,←'<p><span class="margin-note"><code>`⍵1</code>: Or its equivalent,',(⎕ucs 10),'<code>',(⎕ucs 9081),'1</code>.<br><strong>',(⎕ucs 9081),'</strong> is ⍵-underscore.</span>',(⎕ucs 10 8195 8195)
_,←'<strong>Referencing <strong>∆F</strong> arguments after the',(⎕ucs 10),'<em>f',(⎕ucs 8209),'string</em>: <strong>Omega</strong> shortcut expressions (like',(⎕ucs 10)
_,←'<code>`⍵1</code>).</strong></p>',(⎕ucs 10),'<p><span class="margin-note">And <code>(⍵⊃⍨ 1+⎕IO)</code> is, of course,',(⎕ucs 10),'equivalent to <code>((1+⎕IO)⊃⍵)</code>.</span> The expression'
_,←(⎕ucs 10),'<code>`⍵1</code> is equivalent to <code>(⍵⊃⍨ 1+⎕IO)</code>, selecting',(⎕ucs 10),'the first argument after the <em>f',(⎕ucs 8209),'string</em>. Similarly,',(⎕ucs 10)
_,←'<code>`⍵99</code> would select <code>(⍵⊃⍨99+⎕IO)</code>.</p>',(⎕ucs 10),'<p>We will use <code>`⍵1</code> here, both with shortcuts and an',(⎕ucs 10)
_,←'externally defined function <code>C2F</code>, that converts Centigrade',(⎕ucs 10),'to Fahrenheit. A bit further <a',(⎕ucs 10),'href="#omega-shortcuts-implicit">below</a>, we discuss bare',(⎕ucs 10)
_,←'<code>`⍵</code> (<em>i.e.</em> without an appended non-negative',(⎕ucs 10),'integer).</p>',(⎕ucs 10),'<pre><code>   C2F← 32+9×÷∘5',(⎕ucs 10),'   ∆F &#39;The temperature is {&quot;I2&quot; $ `⍵1}'
_,←(⎕ucs 176),'C or {&quot;F5.1&quot; $ C2F `⍵1}',(⎕ucs 176),'F&#39; (11 15 20)',(⎕ucs 10),'The temperature is 11',(⎕ucs 176),'C or 51.8',(⎕ucs 176 70 10),'                   15      59.0',(⎕ucs 10)
_,←'                   20      68.0</code></pre>',(⎕ucs 10),'<h2 data-number="4.8" id="referencing-the-fstring-itself"><span',(⎕ucs 10),'class="header-section-number">4.8</span> Referencing the f'
_,←(⎕ucs 8209),'string',(⎕ucs 10),'Itself</h2>',(⎕ucs 10),'<p><span class="margin-note"> <code>`⍵0</code> refers to the',(⎕ucs 10),'<em>f',(⎕ucs 8209)
_,←'string</em>, independent of the the number of elements in the',(⎕ucs 10),'right argument to <strong>∆F</strong> (<em>effectively</em>,',(⎕ucs 10)
_,←'<code>⊆⍵</code>). </span> The expression <code>`⍵0</code> always refers',(⎕ucs 10),'to the <em>f',(⎕ucs 8209),'string</em> itself. Try this:</p>',(⎕ucs 10),'<pre><code>   bL bR← &#39;'
_,←(⎕ucs 171 187),'&#39;                     ⍝ ⎕UCS 171 187',(⎕ucs 10),'   ∆F &#39;Our string {bL, `⍵0, bR} has {≢`⍵0} characters.&#39;</code></pre>',(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10)
_,←'<summary class="summary">',(⎕ucs 10 8194),'Peek at answer',(⎕ucs 10),'</summary>',(⎕ucs 10),'<pre><code>   bL bR← &#39;',(⎕ucs 171 187),'&#39;                     ⍝ ⎕UCS 171 187',(⎕ucs 10)
_,←'   ∆F &#39;Our string {bL, `⍵0, bR} has {≢`⍵0} characters.&#39;',(⎕ucs 10),'Our string ',(⎕ucs 171),'Our string {bL, `⍵0, bR} has {≢`⍵0} characters',(⎕ucs 187),' has 47 characters.</code></pre>'
_,←(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'Let',(⎕ucs 8217),'s check our work',(⎕ucs 8230 10),'</summary>',(⎕ucs 10)
_,←'<pre><code>   ≢&#39;Our string {bL, `⍵0, bR} has {≢`⍵0} characters.&#39;',(⎕ucs 10),'47</code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10),'</details>',(⎕ucs 10)
_,←'<h2 data-number="4.9" id="the-format-shortcut"><span',(⎕ucs 10),'class="header-section-number">4.9</span> The Format Shortcut</h2>',(⎕ucs 10)
_,←'<p><span class="margin-note">The <strong>Format</strong> shortcut',(⎕ucs 10),'<code>$</code>, or <code>`F</code> (short for <code>⎕FMT</code>), can',(⎕ucs 10)
_,←'also be used monadically, but let <strong>∆F</strong> handle that for',(⎕ucs 10),'you in most cases. </span></p>',(⎕ucs 10),'<blockquote>',(⎕ucs 10),'<p>Let',(⎕ucs 8217)
_,←'s add commas to some very large numbers using the',(⎕ucs 10),'<strong>⎕FMT</strong> shortcut <code>$</code>.</p>',(⎕ucs 10),'</blockquote>',(⎕ucs 10),'<p>We can use Dyalog',(⎕ucs 8217)
_,←'s built-in formatting specifier ',(⎕ucs 8220 67 8221),' with shortcut',(⎕ucs 10),'<code>$</code> to add appropriate commas to the temperatures!</p>',(⎕ucs 10),'<p><span',(⎕ucs 10)
_,←'class="margin-note"><br><br><code>C2F← 32+9×÷∘5</code></span></p>',(⎕ucs 10),'<pre><code>⍝  The temperature of the sun at its core in degrees C.',(⎕ucs 10)
_,←'   sun_core← 15E6                   ⍝ 15000000 is a bit hard to parse!',(⎕ucs 10),'   ∆F &#39;The sun&#39;&#39;s core is at {&quot;CI10&quot; $ sun_core}',(⎕ucs 176)
_,←'C or {&quot;CI10&quot; $ C2F sun_core}',(⎕ucs 176),'F&#39;',(⎕ucs 10),'The sun&#39;s core is at 15,000,000',(⎕ucs 176),'C or 27,000,032',(⎕ucs 176),'F</code></pre>',(⎕ucs 10)
_,←'<h2 data-number="4.10" id="the-shortcut-for-numeric-commas"><span',(⎕ucs 10),'class="header-section-number">4.10</span> The Shortcut for Numeric',(⎕ucs 10),'Commas</h2>',(⎕ucs 10)
_,←'<p><span class="margin-note">Typically, each number or numeric string',(⎕ucs 10),'presented to <code>`C</code> will represent an integer, but if a real',(⎕ucs 10)
_,←'number is presented, only the integer part will have commas added.',(⎕ucs 10),'</span> The shortcut for <em>Numeric</em> <strong>Commas</strong>',(⎕ucs 10)
_,←'<code>`C</code> adds commas every 3 digits (from the right) to one or',(⎕ucs 10),'more numbers or numeric strings. It has an advantage over the',(⎕ucs 10),'<code>$</code> (Dyalog',(⎕ucs 8217)
_,←'s <code>⎕FMT</code>) specifier: it doesn',(⎕ucs 8217 116 10),'require you to guesstimate field widths.</p>',(⎕ucs 10),'<p>Let',(⎕ucs 8217)
_,←'s use the <code>`C</code> shortcut to add the commas to the',(⎕ucs 10),'temperatures!</p>',(⎕ucs 10),'<p><span class="margin-note"><br>Cool! OK, not literally. </span></p>',(⎕ucs 10)
_,←'<pre><code>   sun_core← 15E6               ⍝ 15000000 is a bit hard to parse!',(⎕ucs 10),'   ∆F &#39;The sun&#39;&#39;s core is at {`C sun_core}',(⎕ucs 176),'C or {`C C2F sun_core}',(⎕ucs 176)
_,←'F.&#39;',(⎕ucs 10),'The sun&#39;s core is at 15,000,000',(⎕ucs 176),'C or 27,000,032',(⎕ucs 176),'F.</code></pre>',(⎕ucs 10),'<p>And for a bit of a twist, let',(⎕ucs 8217)
_,←'s display either degrees Centigrade or',(⎕ucs 10),'Fahrenheit under user control (<code>1</code> =&gt; F, <code>0</code>',(⎕ucs 10),'=&gt; C). Here, we establish the <em>f',(⎕ucs 8209)
_,←'string</em> <code>sunFC</code>',(⎕ucs 10),'first, then pass it to <strong>∆F</strong> with an additional right',(⎕ucs 10),'argument.</p>',(⎕ucs 10)
_,←'<pre><code>   sunFC← &#39;The sun&#39;&#39;s core is at {`C C2F⍣`⍵1⊢ sun_core}',(⎕ucs 176),'{ `⍵1⊃ &quot;CF&quot;}.&#39;',(⎕ucs 10),'   ∆F sunFC 1',(⎕ucs 10),'The sun&#39;s core is at 27,000,032'
_,←(⎕ucs 176 70 46 10),'   ∆F sunFC 0',(⎕ucs 10),'The sun&#39;s core is at 15,000,000',(⎕ucs 176),'C.</code></pre>',(⎕ucs 10),'<p>Now, let',(⎕ucs 8217)
_,←'s move on to Self-documenting <strong>Code</strong>',(⎕ucs 10),'fields.</p>',(⎕ucs 10),'<h2 data-number="4.11" id="self-documenting-code-fields-sdcfs"><span',(⎕ucs 10)
_,←'class="header-section-number">4.11</span> Self-documenting',(⎕ucs 10),'<strong>Code</strong> fields (SDCFs)</h2>',(⎕ucs 10),'<p><span class="margin-note">Our SDCFs are based on Python',(⎕ucs 8217)
_,←'s single type',(⎕ucs 10),'of self-documenting expressions in <em>f',(⎕ucs 8209),'strings</em>, but work somewhat',(⎕ucs 10),'differently. SDCFs are used <strong><em>only</em></strong> in',(⎕ucs 10)
_,←'<strong>Code</strong> fields <em>(duh).</em> </span></p>',(⎕ucs 10),'<blockquote>',(⎕ucs 10),'<p>Self-documenting Code fields (SDCFs) are a useful debugging tool.</p>',(⎕ucs 10),'</blockquote>'
_,←(⎕ucs 10),'<p>What',(⎕ucs 8217),'s an SDCF? An SDCF allows whatever source code is in a',(⎕ucs 10),'<strong>Code</strong> field to be automatically displayed literally',(⎕ucs 10)
_,←'along with the result of evaluating that code.</p>',(⎕ucs 10),'<p>The source code for a <strong>Code</strong> field can automatically',(⎕ucs 10),'be shown in <strong>∆F</strong>',(⎕ucs 8217)
_,←'s output',(⎕ucs 8212),'</p>',(⎕ucs 10),'<ul>',(⎕ucs 10),'<li>to the <em>left</em> of the result of evaluating that code; or,</li>',(⎕ucs 10)
_,←'<li>centered <em>above</em> the result of evaluating that code.</li>',(⎕ucs 10),'</ul>',(⎕ucs 10),'<p>All you need do is enter</p>',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li>a right arrow <big><code>→</code></big> for a',(⎕ucs 10),'<strong>horizontal</strong> SDCF, or</li>',(⎕ucs 10),'<li>a down arrow <big><code>↓</code></big> (or',(⎕ucs 10)
_,←'<big><code>%</code></big>)<span class="margin-note"><code>%</code> is',(⎕ucs 10),'the same glyph as for the <strong>Above</strong> shortcut,',(⎕ucs 10)
_,←'<code>%</code> or <code>`A</code>, discussed in <a',(⎕ucs 10),'href="#the-above-shortcut">the next section</a>.</span> for a',(⎕ucs 10),'<strong>vertical</strong> SDCF,</li>',(⎕ucs 10),'</ul>'
_,←(⎕ucs 10),'<p>as the <strong><em>last non-space</em></strong> character in the',(⎕ucs 10),'<strong>Code</strong> field, before the <em>final</em> right brace.</p>',(⎕ucs 10),'<p>Here',(⎕ucs 8217)
_,←'s an example of a horizontal SDCF, <em>i.e.</em> using',(⎕ucs 10),'<code>→</code>:</p>',(⎕ucs 10),'<pre><code>   name←&#39;John Smith&#39; ',(⎕ucs 9671),' age← 34',(⎕ucs 10)
_,←'   ∆F &#39;Current employee: {name→}, {age→}.&#39;',(⎕ucs 10),'Current employee: name→John Smith, age→34.</code></pre>',(⎕ucs 10),'<p>As a useful formatting feature, whatever spaces are just'
_,←(⎕ucs 10),'<strong><em>before</em></strong> or <strong><em>after</em></strong> the',(⎕ucs 10),'symbol <strong>→</strong> or <strong>↓</strong> are preserved',(⎕ucs 10)
_,←'<strong><em>verbatim</em></strong> in the output.</p>',(⎕ucs 10),'<p>Here',(⎕ucs 8217),'s an example with such spaces: see how the spaces adjacent to',(⎕ucs 10)
_,←'the symbol <code>→</code> are mirrored in the output!</p>',(⎕ucs 10),'<pre><code>   name←&#39;John Smith&#39; ',(⎕ucs 9671),' age← 34',(⎕ucs 10)
_,←'   ∆F &#39;Current employee: {name → }, {age→ }.&#39;',(⎕ucs 10),'Current employee: name → John Smith, age→ 34.</code></pre>',(⎕ucs 10),'<p>Now, let',(⎕ucs 8217)
_,←'s look at an example of a vertical SDCF, <em>i.e.</em> using',(⎕ucs 10),'<code>↓</code>:</p>',(⎕ucs 10),'<pre><code>   name←&#39;John Smith&#39; ',(⎕ucs 9671),' age← 34',(⎕ucs 10)
_,←'   ∆F &#39;Current employee: {name↓} {age↓}.&#39;',(⎕ucs 10),'Current employee:  name↓     age↓.',(⎕ucs 10),'                  John Smith  34</code></pre>',(⎕ucs 10)
_,←'<p>To make it easier to see, here',(⎕ucs 8217),'s the same result, but with a box',(⎕ucs 10),'around each field',(⎕ucs 8212),'using the <strong>Box</strong> <a',(⎕ucs 10)
_,←'href="#f-option-details">option</a>, <em>namespace</em> style.</p>',(⎕ucs 10),'<pre class="dyalog20"><code>⍝  Box all fields',(⎕ucs 10),'   (box: 1) ∆F &#39;Current employee: {name↓} {age↓}.&#39;'
_,←(⎕ucs 10 9484,(18/9472),9516,(10/9472),9516 9472 9516,(4/9472),9516 9472 9488 10 9474),'Current employee: ',(⎕ucs 9474),' name↓    ',(⎕ucs 9474 32 9474),'age↓',(⎕ucs 9474 46 9474 10 9474)
_,←'                  ',(⎕ucs 9474),'John Smith',(⎕ucs 9474 32 9474),' 34 ',(⎕ucs 9474 32 9474 10 9492,(18/9472),9524,(10/9472),9524 9472 9524,(4/9472),9524 9472 9496),'</code></pre>',(⎕ucs 10)
_,←'<div class="page-break">',(⎕ucs 10 10),'</div>',(⎕ucs 10),'<h2 data-number="4.12" id="the-above-shortcut"><span',(⎕ucs 10),'class="header-section-number">4.12</span> The Above Shortcut</h2>'
_,←(⎕ucs 10),'<blockquote>',(⎕ucs 10),'<p>A cut above the rest',(⎕ucs 8230),'</p>',(⎕ucs 10),'</blockquote>',(⎕ucs 10),'<p><span class="margin-note"><code>%</code> can be used monadically. In'
_,←(⎕ucs 10),'that case, a left argument of <code>''''</code> (an empty string) is',(⎕ucs 10),'assumed. </span> Here',(⎕ucs 8217),'s a useful feature. Let',(⎕ucs 8217),'s use the shortcut',(⎕ucs 10)
_,←'<code>%</code> to display one expression centered above another; it',(⎕ucs 8217 115 10),'called <strong>Above</strong> and can <em>also</em> be expressed as',(⎕ucs 10),'<code>`A</code>.</p>'
_,←(⎕ucs 10),'<p><span class="margin-note">Remember, <code>`⍵1</code> designates the',(⎕ucs 10),'<strong><em>first</em></strong> argument after the <em>f',(⎕ucs 8209),'string</em>',(⎕ucs 10)
_,←'itself, and <code>`⍵2</code> the <strong><em>second</em></strong>.',(⎕ucs 10),'</span></p>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;{&quot;Employee&quot; % ⍪`⍵1} {&quot;Age&quot; % ⍪`⍵2}&#39; (&#39;John Smith&#39; &#39;Mary Jones&#39;)(29 23)',(⎕ucs 10),'Employee    Age',(⎕ucs 10),'John Smith  29'
_,←(⎕ucs 10),'Mary Jones  23</code></pre>',(⎕ucs 10),'<h2 data-number="4.13" id="text-justification-shortcut"><span',(⎕ucs 10),'class="header-section-number">4.13</span> Text Justification',(⎕ucs 10)
_,←'Shortcut</h2>',(⎕ucs 10),'<p><span class="margin-note"><code>`J</code> is a variant of',(⎕ucs 10),'<code>just</code>, found in the <em>dfns</em> library.</span> The Text',(⎕ucs 10)
_,←'<strong>Justification</strong> shortcut <code>`J</code> treats its right',(⎕ucs 10),'argument as a character array, justifying each line to the left',(⎕ucs 10)
_,←'(<code>⍺∊"L" ¯1</code>, the default), to the right',(⎕ucs 10),'(<code>⍺∊"R" 1</code>), or centered (<code>⍺∊"C" 0</code>). <span',(⎕ucs 10)
_,←'class="margin-note"><strong>maximum <code>⎕PP</code>:</strong> the',(⎕ucs 10),'maximum <code>⎕PP</code> is <code>17</code> for 64-bit floats, and',(⎕ucs 10)
_,←'<code>34</code> for 128-bit floats. </span> If its right argument',(⎕ucs 10),'contains floating point numbers, they will be displayed with the maximum',(⎕ucs 10)
_,←'print precision <code>⎕PP</code> available.</p>',(⎕ucs 10),'<pre><code>   a← ↑&#39;elephants&#39; &#39;cats&#39; &#39;rhinoceroses&#39;',(⎕ucs 10)
_,←'   ∆F &#39;{&quot;L&quot; `J a}  {&quot;C&quot; `J a}  {&quot;R&quot; `J a}&#39;',(⎕ucs 10),'elephants      elephants       elephants',(⎕ucs 10),'cats              cats              cats',(⎕ucs 10)
_,←'rhinoceroses  rhinoceroses  rhinoceroses</code></pre>',(⎕ucs 10),'<p>And what do you think this <em>f-string</em> displays?</p>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;{¯1 `J `⍵1} {0 `J `⍵1} { 1`J `⍵1  }&#39; (⍪10*2×⍳4)</code></pre>',(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'Peek at answer'
_,←(⎕ucs 10),'</summary>',(⎕ucs 10),'<pre><code>   ∆F &#39;{¯1 `J `⍵1} {0 `J `⍵1} { 1`J `⍵1  }&#39; (⍪10*2×⍳4)',(⎕ucs 10),'1          1          1',(⎕ucs 10),'100       100       100',(⎕ucs 10)
_,←'10000    10000    10000',(⎕ucs 10),'1000000 1000000 1000000</code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10),'<h2 data-number="4.14" id="omega-shortcuts-implicit"><span',(⎕ucs 10)
_,←'class="header-section-number">4.14</span> Omega Shortcuts',(⎕ucs 10),'(Implicit)</h2>',(⎕ucs 10),'<blockquote>',(⎕ucs 10),'<p>The <em>next</em> best thing: the use of <code>`⍵</code> in',(⎕ucs 10)
_,←'<strong>Code</strong> field expressions',(⎕ucs 8230),'</p>',(⎕ucs 10),'</blockquote>',(⎕ucs 10),'<p>We said we',(⎕ucs 8217),'d present the use of <strong>Omega</strong> shortcuts with',(⎕ucs 10)
_,←'implicit <span class="margin-note"><code>`⍵</code>: Or its equivalent,',(⎕ucs 10),'<code>',(⎕ucs 9081),'</code>.<br><strong>',(⎕ucs 9081),'</strong> is ⍵-underscore.</span> indices',(⎕ucs 10)
_,←'<code>`⍵</code> in <strong>Code</strong> fields. The expression',(⎕ucs 10),'<code>`⍵</code> selects the <em>next</em> element of the right argument',(⎕ucs 10)
_,←'<code>⍵</code> to <strong>∆F</strong>, defaulting to <code>`⍵1</code>',(⎕ucs 10),'when first encountered, <em>i.e.</em> if there are',(⎕ucs 10)
_,←'<strong><em>no</em></strong> <code>`⍵</code> elements (<em>explicit</em>',(⎕ucs 10),'or <em>implicit</em>) to the <strong><em>left</em></strong> in the',(⎕ucs 10),'entire <em>f',(⎕ucs 8209)
_,←'string</em>. If there is any such expression (<em>e.g.</em>',(⎕ucs 10),'<code>`⍵5</code>), then <code>`⍵</code> points to the element after that',(⎕ucs 10)
_,←'one (<em>e.g.</em> <code>`⍵6</code>). If the item to the left is',(⎕ucs 10),'<code>`⍵</code>, then we simply increment the index by <code>1</code>',(⎕ucs 10),'from that one.</p>',(⎕ucs 10)
_,←'<p><strong>Let',(⎕ucs 8217),'s try an example.</strong> Here, we display arbitrary',(⎕ucs 10),'2-dimensional expressions, one above the other. <code>`⍵</code> refers',(⎕ucs 10)
_,←'to the <strong><em>next</em></strong> argument in sequence, left to',(⎕ucs 10),'right, starting with <code>`⍵1</code>, the first, <em>i.e.</em>',(⎕ucs 10)
_,←'<code>(⍵⊃⍨ 1+⎕IO)</code>. So, from left to right <code>`⍵</code> is',(⎕ucs 10),'<code>`⍵1</code>, <code>`⍵2</code>, and <code>`⍵3</code>.</p>',(⎕ucs 10)
_,←'<p><span class="margin-note"><em>Easy peasy.</em></span></p>',(⎕ucs 10),'<pre><code>   ∆F &#39;{(⍳2⍴`⍵) % (⍳2⍴`⍵) % (⍳2⍴`⍵)}&#39; 1 2 3',(⎕ucs 10),'    0 0',(⎕ucs 10),'  0 0 0 1',(⎕ucs 10)
_,←'  1 0 1 1',(⎕ucs 10),'0 0 0 1 0 2',(⎕ucs 10),'1 0 1 1 1 2',(⎕ucs 10),'2 0 2 1 2 2</code></pre>',(⎕ucs 10),'<p>Here',(⎕ucs 8217),'s a useful example, where the formatting option for each text'
_,←(⎕ucs 10),'justification <code>`J</code> is determined by an argument to',(⎕ucs 10),'<strong>∆F</strong>:</p>',(⎕ucs 10),'<pre><code>   a← ↑&#39;elephants&#39; &#39;cats&#39; &#39;rhinoceroses&#39;'
_,←(⎕ucs 10),'   ∆F &#39;{`⍵ `J a}  {`⍵ `J a}  {`⍵ `J a}&#39; ¯1 0 1',(⎕ucs 10),'elephants      elephants       elephants',(⎕ucs 10),'cats              cats              cats',(⎕ucs 10)
_,←'rhinoceroses  rhinoceroses  rhinoceroses</code></pre>',(⎕ucs 10),'<h2 data-number="4.15" id="shortcuts-with-apl-expressions"><span',(⎕ucs 10)
_,←'class="header-section-number">4.15</span> Shortcuts With <em>APL</em>',(⎕ucs 10),'Expressions</h2>',(⎕ucs 10),'<p>Shortcuts often make sense with <em>APL</em> expressions, not just',(⎕ucs 10)
_,←'entire <strong>Code</strong> fields. They can be manipulated like',(⎕ucs 10),'ordinary <em>APL</em> functions; since they are just that',(⎕ucs 8212),' ordinary',(⎕ucs 10),'<em>APL</em> functions'
_,←(⎕ucs 8212),' under the covers. Here, we display one boxed',(⎕ucs 10),'value above the other.</p>',(⎕ucs 10),'<pre><code>   ∆F &#39;{(`B ⍳`⍵1) % `B ⍳`⍵2}&#39; (2 2)(3 3)'
_,←(⎕ucs 10 32 32 9484,(3/9472),9516,(3/9472),9488 10 32 32 9474),'0 0',(⎕ucs 9474),'0 1',(⎕ucs 9474 10 32 32 9500,(3/9472),9532,(3/9472),9508 10 32 32 9474),'1 0',(⎕ucs 9474),'1 1'
_,←(⎕ucs 9474 10 32 32 9492,(3/9472),9524,(3/9472),9496 10 9484,(3/9472),9516,(3/9472),9516,(3/9472),9488 10 9474),'0 0',(⎕ucs 9474),'0 1',(⎕ucs 9474),'0 2'
_,←(⎕ucs 9474 10 9500,(3/9472),9532,(3/9472),9532,(3/9472),9508 10 9474),'1 0',(⎕ucs 9474),'1 1',(⎕ucs 9474),'1 2',(⎕ucs 9474 10 9500,(3/9472),9532,(3/9472),9532,(3/9472),9508 10 9474),'2 0'
_,←(⎕ucs 9474),'2 1',(⎕ucs 9474),'2 2',(⎕ucs 9474 10 9492,(3/9472),9524,(3/9472),9524,(3/9472),9496),'</code></pre>',(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">'
_,←(⎕ucs 10 8194),'Peek: Shortcuts are just Functions',(⎕ucs 10),'</summary>',(⎕ucs 10),'<p>While not for the faint of heart, the expression above can be recast',(⎕ucs 10)
_,←'as this concise <span class="margin-note"><strong>concise:</strong>',(⎕ucs 10),'somewhat hard to read. </span>alternative:</p>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;{%/ `B∘⍳¨ `⍵1 `⍵2}&#39; (2 2)(3 3)</code></pre>',(⎕ucs 10),'</details',(⎕ucs 10 10 62 10),'<p>There are loads of other examples to discover.</p>',(⎕ucs 10)
_,←'<h2 data-number="4.16" id="a-shortcut-for-dates-and-times-part-i"><span',(⎕ucs 10),'class="header-section-number">4.16</span> A Shortcut for Dates and Times',(⎕ucs 10),'(Part I)</h2>',(⎕ucs 10)
_,←'<p><span class="margin-note">The syntax for the Date-Time specifications',(⎕ucs 10),'in the left argument to <code>`T</code> can be found in the Dyalog',(⎕ucs 10),'doc',(⎕ucs 173),'ument'
_,←(⎕ucs 173),'ation under <strong>1200⌶</strong>. See <a',(⎕ucs 10),'href="#code-field-shortcuts">below</a>, for more info. </span>',(⎕ucs 10)
_,←'<strong>∆F</strong> supports a simple <strong>Date-Time</strong>',(⎕ucs 10),'shortcut <code>`T</code> built from <strong>1200⌶</strong> and',(⎕ucs 10)
_,←'<strong>⎕DT</strong>. It takes one or more Dyalog',(⎕ucs 10),'<code>⎕TS</code>-format timestamps as the right argument and a date-time',(⎕ucs 10)
_,←'specification as the <span class="margin-note">The default left arg',(⎕ucs 173),'ument',(⎕ucs 10),'is <code>⍺← ''%ISO%''</code>, <em>i.e.</em> an ISO date-time.</span>',(⎕ucs 10)
_,←'(optional) left argument. Trailing elements of a timestamp may be',(⎕ucs 10),'omitted (they will each be treated as <code>0</code> in the',(⎕ucs 10),'specification string).</p>',(⎕ucs 10),'<p>Let'
_,←(⎕ucs 8217),'s look at the use of the <code>`T</code> shortcut to show the',(⎕ucs 10),'current time (now).</p>',(⎕ucs 10),'<p><span class="margin-note">The time displayed in practice will be the'
_,←(⎕ucs 10),'<em>true</em> current time.</span></p>',(⎕ucs 10),'<pre><code>   ∆F &#39;It is now {&quot;t:mm pp&quot; `T ⎕TS}.&#39;',(⎕ucs 10),'It is now 8:08 am.</code></pre>',(⎕ucs 10),'<p>Here'
_,←(⎕ucs 8217),'s a fancier example<span class="margin-note">The power is in the',(⎕ucs 10),'capabilities of <code>1200⌶</code> and <code>⎕DT</code>.</span>. (We',(⎕ucs 8217 118 101 10)
_,←'added the <em>truncated</em> timestamp <code>2025 01 01</code> right',(⎕ucs 10),'into the <em>f',(⎕ucs 8209),'string</em>.)</p>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;{ &quot;D MMM YYYY &#39;&#39;was a&#39;&#39; Dddd.&quot;`T 2025 01 01}&#39;',(⎕ucs 10),'1 JAN 2025 was a Wednesday.</code></pre>',(⎕ucs 10)
_,←'<h2 data-number="4.17" id="a-shortcut-for-dates-and-times-part-ii"><span',(⎕ucs 10),'class="header-section-number">4.17</span> A Shortcut for Dates and Times',(⎕ucs 10),'(Part II)</h2>',(⎕ucs 10)
_,←'<p>If it bothers you to use <code>`T</code> for a date-only expression,',(⎕ucs 10),'you can use <code>`D</code>, which means exactly the same thing.</p>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;{ &quot;D MMM YYYY &#39;&#39;was a&#39;&#39; Dddd.&quot; `D 2025 01 02}&#39;',(⎕ucs 10),'2 JAN 2025 was a Thursday.</code></pre>',(⎕ucs 10),'<p>Here, we',(⎕ucs 8217)
_,←'ll pass the time stamp via a single <strong>Omega</strong>',(⎕ucs 10),'expression <code>`⍵1</code>, whose argument <span',(⎕ucs 10)
_,←'class="margin-note"><code>(2025 1 21)</code></span> is passed in',(⎕ucs 10),'parentheses.</p>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;{ &quot;D Mmm YYYY &#39;&#39;was a&#39;&#39; Dddd.&quot; `T `⍵1}&#39; (2025 1 21)',(⎕ucs 10),'21 Jan 2025 was a Tuesday.</code></pre>',(⎕ucs 10)
_,←'<p>We could also pass the time stamp via a sequence of',(⎕ucs 10),'<strong>Omega</strong> expressions: <code>`⍵ `⍵ `⍵</code>. This is',(⎕ucs 10)
_,←'equivalent to the <em>slightly</em> verbose expression:',(⎕ucs 10),'<code>`⍵1 `⍵2 `⍵3</code>.</p>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;{ &quot;D Mmm YYYY &#39;&#39;was a&#39;&#39; Dddd.&quot; `T `⍵ `⍵ `⍵}&#39; 2025 1 21',(⎕ucs 10),'21 Jan 2025 was a Tuesday.</code></pre>',(⎕ucs 10)
_,←'<p>And what do you think this does?</p>',(⎕ucs 10),'<pre><code>   ∆F &#39;{ &quot;D Mmm YYYY &#39;&#39;was a&#39;&#39; Dddd.&quot; `T `⍵1}&#39; (⍪(2025 1 21)(2024 1 21))</code></pre>',(⎕ucs 10)
_,←'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'Peek: It',(⎕ucs 8217),'s <code>`T</code> time for multiple timestamps!',(⎕ucs 10),'</summary>',(⎕ucs 10)
_,←'<pre><code>   ∆F &#39;{ `B &quot;D Mmm YYYY &#39;&#39;was a&#39;&#39; Dddd.&quot; `T `⍵1}&#39; (⍪(2025 1 21)(2024 1 21))',(⎕ucs 10 9484,(26/9472),9488 10 9474),'21 Jan 2025 was a Tuesday.'
_,←(⎕ucs 9474 10 9500,(26/9472),9508 10 9474),'21 Jan 2024 was a Sunday. ',(⎕ucs 9474 10 9492,(26/9472),9496),' </code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10)
_,←'<h2 data-number="4.18" id="the-quote-shortcut"><span',(⎕ucs 10),'class="header-section-number">4.18</span> The Quote Shortcut</h2>',(⎕ucs 10),'<blockquote>',(⎕ucs 10)
_,←'<p>Placing quotes around string elements of an array.</p>',(⎕ucs 10),'</blockquote>',(⎕ucs 10),'<p><span class="margin-note">If a multi',(⎕ucs 173),'dimensional character array is',(⎕ucs 10)
_,←'found, its <em>rows</em> are quoted; if a character vector, it is quoted',(⎕ucs 10),'<em>in toto</em>; else, each character <em>scalar</em> is quoted in',(⎕ucs 10)
_,←'isolation. </span> The <strong>Quote</strong> shortcut <code>`Q</code>',(⎕ucs 10),'recursively scans its right argument, matching rows of character arrays,',(⎕ucs 10)
_,←'character vectors, and character scalars, doubling internal single',(⎕ucs 10),'quotes and placing single quotes around the items found.</p>',(⎕ucs 10)
_,←'<p>Non-character data is returned as is. This is useful, for example,',(⎕ucs 10),'when you wish to clearly distinguish character from numeric data.</p>',(⎕ucs 10),'<p>Let',(⎕ucs 8217)
_,←'s look at a couple of simple examples:</p>',(⎕ucs 10),'<p>First, let',(⎕ucs 8217),'s use the <code>`Q</code> shortcut to place quotes around',(⎕ucs 10)
_,←'the simple character arrays in its right argument, <code>⍵</code>. This',(⎕ucs 10),'is useful when you want to distinguish between character output that',(⎕ucs 10)
_,←'might include numbers and <em>actual</em> numeric output.</p>',(⎕ucs 10),'<pre><code>   ∆F &#39;{`Q 1 2 &quot;three&quot; 4 5 (⍪1 &quot;2&quot;) (⍪&quot;cats&quot; &quot;dogs&quot;)}&#39;'
_,←(⎕ucs 10),'1 2  &#39;three&#39;  4 5     1    &#39;cats&#39;',(⎕ucs 10),'                    &#39;2&#39;    &#39;dogs&#39;</code></pre>',(⎕ucs 10),'<p>And here',(⎕ucs 8217)
_,←'s an example with a simple, mixed vector (<em>i.e.</em> a',(⎕ucs 10),'mix of character and numeric scalars only). We',(⎕ucs 8217),'ll call the object',(⎕ucs 10),'<code>iv</code>, but we won'
_,←(⎕ucs 8217),'t disclose its definition yet.</p>',(⎕ucs 10),'<p>Let',(⎕ucs 8217),'s display <code>iv</code> without using the',(⎕ucs 10),'<strong>Quote</strong> shortcut.</p>',(⎕ucs 10)
_,←'<pre class="skip"><code>   iv← ...',(⎕ucs 10),'   ∆F &#39;{iv}&#39;',(⎕ucs 10),'1 2 3 4 5</code></pre>',(⎕ucs 10),'<p>Are you <strong><em>sure</em></strong> which elements of',(⎕ucs 10)
_,←'<code>iv</code> are numeric and which character scalars?</p>',(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194)
_,←'Peek to see the example with <code>iv</code> defined.',(⎕ucs 10),'</summary>',(⎕ucs 10),'<pre><code>   iv← 1 2 &#39;3&#39; 4 &#39;5&#39;',(⎕ucs 10),'   ∆F &#39;{iv}&#39;',(⎕ucs 10)
_,←'1 2 3 4 5</code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10),'<p>Now, we',(⎕ucs 8217),'ll show the variable <code>iv</code> using the',(⎕ucs 10),'<strong>Quote</strong> <code>`Q</code> shortcut.</p>'
_,←(⎕ucs 10),'<pre><code>   iv← 1 2 &#39;3&#39; 4 &#39;5&#39;',(⎕ucs 10),'   ∆F &#39;{`Q iv}&#39;</code></pre>',(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194)
_,←'Take a peek at the <bold>∆F</bold> output.',(⎕ucs 10),'</summary>',(⎕ucs 10),'<pre><code>1 2 &#39;3&#39; 4 &#39;5&#39;</code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10)
_,←'<p>Voilà, quotes appear around the character digits, but not the actual',(⎕ucs 10),'APL numbers!</p>',(⎕ucs 10),'<h2 data-number="4.19" id="the-serialise-shortcut"><span',(⎕ucs 10)
_,←'class="header-section-number">4.19</span> The Serialise Shortcut</h2>',(⎕ucs 10),'<p>The Serialise shortcut, <code>`S</code>, displays objects formatted',(⎕ucs 10)
_,←'in <em>APL</em> Array Notation. These include arrays <span',(⎕ucs 10),'class="margin-note">NB. See Dyalog documentation for what is in the',(⎕ucs 10)
_,←'domain of Array Notation.</span>of any depth and shape that contain only',(⎕ucs 10),'data arrays (nameclass: <code>2</code>) and namespaces (nameclass:',(⎕ucs 10)
_,←'<code>9</code>). The shortcut allows both a',(⎕ucs 10),'<strong><em>tabular</em></strong> (multiline) form (default or',(⎕ucs 10),'<code>0 `S</code>) and a <strong><em>compact</em></strong> format'
_,←(⎕ucs 10),'(<code>1 `S</code>). If an object cannot be displayed in Array Notation,',(⎕ucs 10),'it is typically displayed unformatted, <em>i.e.</em> as is.</p>',(⎕ucs 10),'<p>Here',(⎕ucs 8217)
_,←'s a brief example showing a scalar, vector, matrix, and vector',(⎕ucs 10),'of (character) vectors:</p>',(⎕ucs 10),'<pre class="dyalog20"><code>   ∆F &#39;{ `S (scal: 3 ',(⎕ucs 9671),' vec: ⍳3 '
_,←(⎕ucs 9671),' mx: 3 3⍴⎕A ',(⎕ucs 9671),' vv: &quot;cats&quot; &quot;dogs&quot; )}&#39;',(⎕ucs 10 40 10),'  mx:[',(⎕ucs 10),'   &#39;ABC&#39;',(⎕ucs 10),'   &#39;DEF&#39;',(⎕ucs 10)
_,←'   &#39;GHI&#39;',(⎕ucs 10),'  ]',(⎕ucs 10),'  scal:3',(⎕ucs 10),'  vec:0 1 2',(⎕ucs 10),'  vv:(',(⎕ucs 10),'   &#39;cats&#39;',(⎕ucs 10),'   &#39;dogs&#39;',(⎕ucs 10),'  )',(⎕ucs 10 41 10)
_,←'   ∆F &#39;{ 1 `S (scal: 3 ',(⎕ucs 9671),' vec: ⍳3 ',(⎕ucs 9671),' mx: 3 3⍴⎕A ',(⎕ucs 9671),' vv: &quot;cats&quot; &quot;dogs&quot; )}&#39;',(⎕ucs 10),'(mx:[',(⎕ucs 9671),'&#39;ABC&#39;'
_,←(⎕ucs 9671),'&#39;DEF&#39;',(⎕ucs 9671),'&#39;GHI&#39;',(⎕ucs 9671 93 9671),'scal:3',(⎕ucs 9671),'vec:0 1 2',(⎕ucs 9671),'vv:(&#39;cats&#39;',(⎕ucs 9671),'&#39;dogs&#39;',(⎕ucs 9671 41 9671)
_,←')</code></pre>',(⎕ucs 10),'<p>Here',(⎕ucs 8217),'s another example, highlighting the similarity between',(⎕ucs 10),'<em>JSON5</em> format and <em>APL</em> Array Notation. In each case, the'
_,←(⎕ucs 10),'object displayed is an <em>APL</em> namespace:</p>',(⎕ucs 10),'<pre><code>   j←&#39;{fred:[1,2,3],jack:9,name:{a:1,b:2}}&#39;',(⎕ucs 10)
_,←'   JSON← ⎕JSON⍠(&#39;Dialect&#39; &#39;JSON5&#39;)',(⎕ucs 10 10),'   ∆F &#39;JSON:`',(⎕ucs 9671),'APL:  {j % 1`S JSON j} &#39;',(⎕ucs 10),'JSON:  {fred:[1,2,3],jack:9,name:{a:1,b:2}}',(⎕ucs 10)
_,←'APL:   (fred:1 2 3',(⎕ucs 9671),'jack:9',(⎕ucs 9671),'name:(a:1',(⎕ucs 9671),'b:2',(⎕ucs 9671 41 9671),')</code></pre>',(⎕ucs 10),'<h2 data-number="4.20" id="the-wrap-shortcut"><span',(⎕ucs 10)
_,←'class="header-section-number">4.20</span> The Wrap Shortcut</h2>',(⎕ucs 10),'<div>',(⎕ucs 10),'<blockquote>',(⎕ucs 10),'<p>Wrapping results in left and right decorators',(⎕ucs 8230),'</p>'
_,←(⎕ucs 10),'</blockquote>',(⎕ucs 10),'<p><span class="margin-note">For more, see <a',(⎕ucs 10),'href="#wrap-shortcut-details">Wrap Shortcut: Details</a> <em>below</em>.',(⎕ucs 10)
_,←'</span> The shortcut <strong>Wrap</strong> <code>`W</code> is used when',(⎕ucs 10),'you want to place a <strong><em>decorator</em></strong> string',(⎕ucs 10)
_,←'immediately to the left or right of <strong><em>each</em></strong> row',(⎕ucs 10),'of simple objects in the right argument, <code>⍵</code>. It differs from',(⎕ucs 10)
_,←'the <strong>Quote</strong> shortcut <code>`Q</code>, which puts quotes',(⎕ucs 10),'<strong><em>only</em></strong> around the character arrays in',(⎕ucs 10),'<code>⍵</code>.</p>',(⎕ucs 10),'<ul>'
_,←(⎕ucs 10),'<li>The decorators are in <code>⍺</code>, the left argument to',(⎕ucs 10),'<strong>Wrap</strong>: the left decorator, <code>0⊃2⍴⍺</code>, and the',(⎕ucs 10)
_,←'right decorator, <code>1⊃2⍴⍺</code>, with <code>⍺</code> defaulting to a',(⎕ucs 10),'single quote.</li>',(⎕ucs 10),'<li>If you need to omit one or the other decorator, simply make it a',(⎕ucs 10)
_,←'null string <code>""</code> or a <em>zilde</em>',(⎕ucs 160),'<code>⍬</code>.</li>',(⎕ucs 10),'</ul>',(⎕ucs 10),'<p><strong>Here are two simple examples.</strong></p>',(⎕ucs 10)
_,←'<p>In the first, we place <code>"',(⎕ucs 176),'C"</code> after <strong>[a]</strong>',(⎕ucs 10),'each row of a table <code>⍪`⍵2</code>, or <strong>[b]</strong> after',(⎕ucs 10)
_,←'each simple vector in <code>,¨`⍵2</code>. We indicate that is no',(⎕ucs 10),'<em>left</em> decorator here using <code>""</code> or <code>⍬</code>, as',(⎕ucs 10),'here.</p>',(⎕ucs 10)
_,←'<pre><code>⍝         ... [a] ...       .... [b] ....',(⎕ucs 10),'    ∆F &#39;{ `⍵1 `W ⍪`⍵2 } ...{ `⍵1 `W ,¨`⍵2 }&#39; (⍬ &#39;',(⎕ucs 176),'C&#39;)(18 22 33)',(⎕ucs 10 49 56 176),'C ... 18'
_,←(⎕ucs 176),'C 22',(⎕ucs 176),'C 33',(⎕ucs 176 67 10 50 50 176 67 10 51 51 176),'C</code></pre>',(⎕ucs 10),'<p>In this next example, we place brackets around the lines of each',(⎕ucs 10)
_,←'simple array in a complex array.</p>',(⎕ucs 10),'<pre><code>   ∆F &#39;{&quot;[]&quot; `W (&quot;cats&quot;)(⍳2 2 1)(2 2⍴⍳4)(3 3⍴⎕A) }&#39;',(⎕ucs 10),' [cats]   [0 0 0]   [0 1]  [ABC]',(⎕ucs 10)
_,←'          [0 1 0]   [2 3]  [DEF]',(⎕ucs 10),'                           [GHI]',(⎕ucs 10),'          [1 0 0]',(⎕ucs 10),'          [1 1 0]</code></pre>',(⎕ucs 10),'<div id="winner2">',(⎕ucs 10)
_,←'<p>Now, let',(⎕ucs 8217),'s try recasting an <em>earlier</em> example',(⎕ucs 8212),'reshown here',(⎕ucs 8212),' to',(⎕ucs 10),'use <strong>Wrap</strong> <code>`W</code>:</p>',(⎕ucs 10)
_,←'<h4 data-number="4.20.0.1" id="the-earlier-example"><span',(⎕ucs 10),'class="header-section-number">4.20.0.1</span> <a href="#winner1">The',(⎕ucs 10),'earlier example</a>',(⎕ucs 8230),'</h4>'
_,←(⎕ucs 10),'<pre><code>   n← ≢names← &#39;Mary&#39; &#39;Jack&#39; &#39;Tony&#39;',(⎕ucs 10),'   prize← 1000',(⎕ucs 10)
_,←'   ∆F &#39;{ ↑names }{ ⍪n⍴ ⊂&quot;wins&quot; }{ &quot;£&quot;, ⍕⍪?n⍴ prize }&#39;</code></pre>',(⎕ucs 10),'</div>',(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">'
_,←(⎕ucs 10 8194),'Peek to see the solution with <strong>Wrap</strong>',(⎕ucs 8230 10),'</summary>',(⎕ucs 10),'<p><span class="margin-note"><br><br>The string <code>"wins "</code> is',(⎕ucs 10)
_,←'the left prefix to <strong>Wrap</strong>, and <code>""</code> the',(⎕ucs 10),'right.</span></p>',(⎕ucs 10),'<pre><code>   n← ≢names← &#39;Mary&#39; &#39;Jack&#39; &#39;Tony&#39;',(⎕ucs 10)
_,←'   prize← 1000',(⎕ucs 10),'   ∆F &#39;{ ↑names } { &quot;wins &quot; &quot;&quot; `W &quot;£&quot;, ⍕⍪?n⍴ prize }&#39;',(⎕ucs 10),'Mary wins £201',(⎕ucs 10),'Jack wins £ 73',(⎕ucs 10)
_,←'Tony wins £349</code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10),'</div>',(⎕ucs 10),'<h2 data-number="4.21" id="the-session-library-shortcut"><span',(⎕ucs 10)
_,←'class="header-section-number">4.21</span> The Session Library',(⎕ucs 10),'Shortcut</h2>',(⎕ucs 10),'<div>',(⎕ucs 10),'<p>The shortcut (Session) <strong>Library</strong> <code>£</code>',(⎕ucs 10)
_,←'denotes <span class="margin-note"><strong>£ alias:</strong>',(⎕ucs 10),'<code>`L</code>. £ is from the first letter of the Latin <em>l',(⎕ucs 299),'bra</em>,',(⎕ucs 10 8220),'pound',(⎕ucs 8221)
_,←', very apt for a',(⎕ucs 10),'<em>libra</em>-ry.<br><br><strong>FString</strong>: <em>See <a',(⎕ucs 10),'href="#f-installation"><strong>∆F</strong> Installation</a>, above.</em>',(⎕ucs 10)
_,←'</span> a ',(⎕ucs 8220),'private',(⎕ucs 8221),' <em>user</em> namespace in <strong>FString</strong>,',(⎕ucs 10),'where the user may place and manipulate useful objects for the duration',(⎕ucs 10)
_,←'of the <strong><em>current</em></strong> <em>APL</em> session. For',(⎕ucs 10),'example, the user may wish to: <span class="margin-note"><em>For',(⎕ucs 10)
_,←'details, see <a href="#code-field-shortcuts">Code Field Short',(⎕ucs 173),'cuts</a>',(⎕ucs 10),'below.</em></span></p>',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li>have regularly used functions or operators automatically available',(⎕ucs 10),'when needed, <em>or</em></li>',(⎕ucs 10),'<li>create objects that might be referred to, monitored, or modified'
_,←(⎕ucs 10),'during the session.</li>',(⎕ucs 10),'</ul>',(⎕ucs 10),'<h3 data-number="4.21.1" id="explicitly-copied-library-objects"><span',(⎕ucs 10)
_,←'class="header-section-number">4.21.1</span> Explicitly Copied Library',(⎕ucs 10),'Objects</h3>',(⎕ucs 10),'<p>In this example, the user wants to generate all primes between 1 and',(⎕ucs 10)
_,←'100 using two routines, <code>sieve</code> and <code>to</code>, that',(⎕ucs 10),'reside in the <strong><em>dfns</em></strong> workspace. To accommodate',(⎕ucs 10)
_,←'this, we could anticipate all the items we might need and copy them well',(⎕ucs 10),'in advance.</p>',(⎕ucs 10),'<blockquote>',(⎕ucs 10),'<p>But there',(⎕ucs 8217),'s a better way!</p>',(⎕ucs 10)
_,←'</blockquote>',(⎕ucs 10),'<p>Here we copy both routines from <strong><em>dfns</em></strong> in',(⎕ucs 10),'real time, only when they are needed.</p>',(⎕ucs 10)
_,←'<p><span class="margin-note"><code>⎕CY</code> returns <code>0⍴⊂''''</code>',(⎕ucs 10),'on success, <em>i.e.</em> an <em>invisible</em>, 0-width',(⎕ucs 10),'<strong>Code</strong> field! </span></p>'
_,←(⎕ucs 10),'<pre><code>    ∆F &#39;{&quot;sieve&quot; &quot;to&quot; £.⎕CY &quot;dfns&quot;}{£.sieve 2 £.to 100}&#39;',(⎕ucs 10)
_,←'2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97</code></pre>',(⎕ucs 10),'<p>On subsequent calls, <code>sieve</code> and <code>to</code> are',(⎕ucs 10)
_,←'already available, as we can see here:</p>',(⎕ucs 10),'<pre><code>    ∆F &#39;{ £.⎕NL ¯3 }&#39;',(⎕ucs 10),' sieve  to</code></pre>',(⎕ucs 10)
_,←'<h3 data-number="4.21.2" id="automatically-copied-library-objects"><span',(⎕ucs 10),'class="header-section-number">4.21.2</span> Automatically Copied Library',(⎕ucs 10),'Objects</h3>',(⎕ucs 10)
_,←'<blockquote>',(⎕ucs 10),'<p>But, <strong>∆F</strong> can handle this all for you!</p>',(⎕ucs 10),'</blockquote>',(⎕ucs 10),'<p>If <span class="margin-note">Here, we only show examples of objects'
_,←(⎕ucs 10),'from the <strong><em>dfns</em></strong> workspace. <em>See <a',(⎕ucs 10),'href="#code-field-shortcuts">Code Field Shortcuts</a> below.</em>',(⎕ucs 10)
_,←'</span> the user references a simple name of the form',(⎕ucs 10),'<code>£.name</code> that has not (yet) been defined in the library, an',(⎕ucs 10)
_,←'attempt is made to copy that name into the library either from a text',(⎕ucs 10),'file in a user directory or from the <strong><em>dfns</em></strong>',(⎕ucs 10)
_,←'workspace; if the name appears on the left-side of a',(⎕ucs 10),'<strong>simple</strong> assigment <code>←</code>, it is',(⎕ucs 10)
_,←'<strong>not</strong> copied in (since the user is defining it).</p>',(⎕ucs 10),'<p><big>',(⎕ucs 128073),'</big>',(⎕ucs 160),' If <strong>∆F</strong> is unable to find the item',(⎕ucs 10)
_,←'during its search, a standard <em>APL</em> error will be signaled when',(⎕ucs 10),'the <strong>Code</strong> field is evaluated.</p>',(⎕ucs 10)
_,←'<p>In this next example, we use the function <code>pco</code> from the',(⎕ucs 10),'<code>dfns</code> workspace. If this is the <em>first</em> use, it is',(⎕ucs 10)
_,←'quietly copied in (unless the <strong>verbose</strong> option is',(⎕ucs 10),'specified).</p>',(⎕ucs 10),'<pre><code>    ∆F &#39;{ ⍸ 1 £.pco ⍳100 }&#39;',(⎕ucs 10)
_,←'2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97</code></pre>',(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194)
_,←'Peek: Using the <em><strong>verbose</strong></em> option',(⎕ucs 10),'</summary>',(⎕ucs 10),'<p><big>',(⎕ucs 128073),'</big>',(⎕ucs 160),'To understand <em>when</em> an object is automatically'
_,←(⎕ucs 10),'copied into a £ibrary, and to see <em>where</em> it',(⎕ucs 8217),'s copied from, use',(⎕ucs 10),'<strong>∆F</strong>',(⎕ucs 8217),'s <strong><em>verbose</em></strong> option:</p>'
_,←(⎕ucs 10),'<p><span class="margin-note"><br>First use of <code>£.pco</code> this',(⎕ucs 10),'<em>session.</em> Since subsequent uses will use the <code>£.pco</code>',(⎕ucs 10)
_,←'already copied into the library, they are',(⎕ucs 10),'<strong><em>quiet</em></strong>.</span></p>',(⎕ucs 10)
_,←'<pre><code>   (verbose: 1) ∆F &#39;{ ⍸ 1 £.pco ⍳100 }&#39;    ⍝ (verbose: 1) &lt;==&gt; 0 1 </code></pre>',(⎕ucs 10)
_,←'<pre class="skip"><code>∆F: Copied &quot;pco&quot; into £=[⎕SE.FString.library] from &quot;ws:dfns&quot;',(⎕ucs 10),'{ ⎕SE.FString.M ⌽⍬({⍸ 1 (⎕SE.FString.library).pco ⍳100}⍵)}⍵',(⎕ucs 10)
_,←'2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97</code></pre>',(⎕ucs 10),'<p><big>',(⎕ucs 128073),'</big>',(⎕ucs 160),'With the default <em>verbose</em> setting,',(⎕ucs 10)
_,←'<code>(verbose: 0)</code>, the autoload process works the same way, but',(⎕ucs 10),'quietly!</p>',(⎕ucs 10),'</details>',(⎕ucs 10),'<h3 data-number="4.21.3" id="session-library-variables"><span'
_,←(⎕ucs 10),'class="header-section-number">4.21.3</span> Session Library',(⎕ucs 10),'Variables</h3>',(⎕ucs 10),'<blockquote>',(⎕ucs 10)
_,←'<p>But we can use the Session Library shortcut for arrays as well.</p>',(⎕ucs 10),'</blockquote>',(⎕ucs 10),'<p><span class="margin-note"><big>',(⎕ucs 128073),'</big>',(⎕ucs 160)
_,←'If <code>£.ctr</code> already',(⎕ucs 10),'exists, it must be in the same class as its new value, consistent with',(⎕ucs 10),'<em>APL</em> rules.</span></p>',(⎕ucs 10)
_,←'<p>Here is an example where we define a local session variable',(⎕ucs 10),'<code>ctr</code>, a counter of the number of times a particular',(⎕ucs 10)
_,←'statement is executed. Since we define the counter,',(⎕ucs 10),'<code>£.ctr←0</code>, <strong>∆F</strong> makes',(⎕ucs 10),'<strong><em>no</em></strong> attempt to copy it from the',(⎕ucs 10)
_,←'<code>dfns</code> workspace or a file.</p>',(⎕ucs 10),'<pre><code>   ∆F &#39;{ ⍬⊣£.ctr←0 }&#39;         ⍝ Initialise £.ctr.',(⎕ucs 10)
_,←'   t← &#39;We&#39;&#39;ve been called {£.ctr← £.ctr+1} times.&#39;',(⎕ucs 10),'⍝  ...',(⎕ucs 10),'   ∆F t',(⎕ucs 10),'We&#39;ve been called 1 times.',(⎕ucs 10),'   ∆F t',(⎕ucs 10)
_,←'We&#39;ve been called 2 times.</code></pre>',(⎕ucs 10),'<p>This may be sensible when ∆F is called from a variety of namespaces',(⎕ucs 10),'and/or if the user doesn',(⎕ucs 8217)
_,←'t wish to clutter the active namespace.</p>',(⎕ucs 10),'<p>In this example, we simply use <code>£</code> as a private namespace',(⎕ucs 10)
_,←'for the the <span class="margin-note">Remember: <strong>∆F</strong>',(⎕ucs 10),'evaluates fields left-to-right.</span> template variable',(⎕ucs 10)
_,←'<code>£.dt</code> used during the <strong>∆F</strong> <span',(⎕ucs 10),'class="margin-note"><br><br><br>NB. <code>£.dt</code> hangs around after',(⎕ucs 10),'execution!</span> call:</p>',(⎕ucs 10)
_,←'<pre><code>   d1← ⍪(2025 1 21)(2024 1 21)   ',(⎕ucs 9671),'   d2← (2100 1 1)',(⎕ucs 10),'   ∆F &#39;{(£.dt← &quot;D Mmm YYYY &#39;&#39;was a&#39;&#39; Dddd.&quot;) `T `⍵1 }{£.dt`T `⍵2}&#39; d1 d2'
_,←(⎕ucs 10),' 21 Jan 2025 was a Tuesday. 1 Jan 2100 was a Friday.',(⎕ucs 10),' 21 Jan 2024 was a Sunday.</code></pre>',(⎕ucs 10),'</div>',(⎕ucs 10),'<h2 data-number="4.22"',(⎕ucs 10)
_,←'id="precomputed-fstrings-with-the-dfn-option"><span',(⎕ucs 10),'class="header-section-number">4.22</span> Precomputed f',(⎕ucs 8209),'strings with the',(⎕ucs 10)
_,←'<strong><em>dfn</em></strong> Option</h2>',(⎕ucs 10),'<p>In this section, we talk about generating standalone <em>dfns</em>',(⎕ucs 10)
_,←'via the <strong>∆F</strong> <em>dfn</em> option; these present some',(⎕ucs 10),'advantages over repeated <strong>∆F</strong> calls.</p>',(⎕ucs 10)
_,←'<p>As shown in Table 3a (below), with <em>(i)</em> the default',(⎕ucs 10),'<em>dfn</em> option set to <code>0</code>, the value returned from a',(⎕ucs 10)
_,←'successful call to <strong>∆F</strong> is always a character matrix.',(⎕ucs 10),'However, <em>(ii)</em> <span class="margin-note">Under identical',(⎕ucs 10),'conditions, of course.</span> if <a'
_,←(⎕ucs 10),'href="#f-option-details"><em>dfn</em></a> is set to <code>1</code>, then',(⎕ucs 10),'<strong>∆F</strong> returns a <strong>dfn</strong> that',(⎕ucs 8212),' when called',(⎕ucs 10),'later'
_,←(⎕ucs 8212),' will return the identical character expression.</p>',(⎕ucs 10),'<table style="width:69%;">',(⎕ucs 10),'<caption>3a. <strong>Using the <em>dfn Option</em></strong>',(⎕ucs 10)
_,←'<br></caption>',(⎕ucs 10),'<colgroup>',(⎕ucs 10),'<col style="width: 12%" />',(⎕ucs 10),'<col style="width: 27%" />',(⎕ucs 10),'<col style="width: 29%" />',(⎕ucs 10),'</colgroup>',(⎕ucs 10)
_,←'<thead>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<th style="text-align: left;">Mode</th>',(⎕ucs 10),'<th style="text-align: center;">Positional Parameter</th>',(⎕ucs 10)
_,←'<th style="text-align: center;">Keyword Parameter</th>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</thead>',(⎕ucs 10),'<tbody>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><em>(i)</em> <strong><em> default',(⎕ucs 10),'</em></strong></td>',(⎕ucs 10),'<td style="text-align: center;"><code>0 ∆F ''mycode''</code></td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><code>(dfn: 0)  ∆F ''mycode''</code></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><em>(ii)</em> <strong><em> dfn',(⎕ucs 10)
_,←'</em></strong></td>',(⎕ucs 10),'<td style="text-align: center;"><code>1 ∆F ''mycode''</code></td>',(⎕ucs 10),'<td style="text-align: center;"><code>(dfn: 1)  ∆F ''mycode''</code></td>',(⎕ucs 10)
_,←'</tr>',(⎕ucs 10),'</tbody>',(⎕ucs 10),'</table>',(⎕ucs 10),'<p><span class="margin-note"><br><strong>standalone:</strong>',(⎕ucs 10),'<em>i.e.</em> via the <em>inline</em> option. See <a',(⎕ucs 10)
_,←'href="#f-option-details">option details</a> (be',(⎕ucs 173),'low) re',(⎕ucs 173),'gard',(⎕ucs 173),'ing the',(⎕ucs 10),'<em>inline</em> option and ex',(⎕ucs 173)
_,←'ceptions.</span> The <em>dfn</em> option is',(⎕ucs 10),'most useful when you are making repeated use of an <em>f',(⎕ucs 8209),'string</em>,',(⎕ucs 10),'since the overhead for analyzing the <em>f'
_,←(⎕ucs 8209),'string</em> contents',(⎕ucs 10),'<strong><em>once</em></strong> will be amortized over',(⎕ucs 10),'<strong><em>all</em></strong> the subsequent calls. An',(⎕ucs 10)
_,←'<strong>∆F</strong>-derived <em>dfn</em> can also be made standalone,',(⎕ucs 10),'<em>i.e.</em> independent of the runtime library,',(⎕ucs 10),'<strong>FString</strong>.</p>',(⎕ucs 10),'<p>Let'
_,←(⎕ucs 8217),'s explore an example where getting the best performance for a',(⎕ucs 10),'heavily used <strong>∆F</strong> string is important.</p>',(⎕ucs 10),'<p>First, let',(⎕ucs 8217)
_,←'s grab <code>cmpx</code> and set the variable',(⎕ucs 10),'<code>cv</code>, so we can compare the performance',(⎕ucs 8230),'</p>',(⎕ucs 10),'<pre><code>   &#39;cmpx&#39; ⎕CY &#39;dfns&#39;'
_,←(⎕ucs 10),'   cv← 11 30 60</code></pre>',(⎕ucs 10),'<p>Now, let',(⎕ucs 8217),'s proceed. Here',(⎕ucs 8217),'s our <strong>∆F</strong> String',(⎕ucs 10),'<code>t</code>:</p>',(⎕ucs 10)
_,←'<pre><code>   t←&#39;The temperature is {&quot;I2&quot; $ cv}',(⎕ucs 176),'C or {&quot;F5.1&quot; $ 32+9×cv÷5}',(⎕ucs 176),'F&#39;</code></pre>',(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10)
_,←'<summary class="summary">',(⎕ucs 10 8194),'Evaluate <code>∆F t</code>',(⎕ucs 10),'</summary>',(⎕ucs 10),'<pre><code>   ∆F t',(⎕ucs 10),'The temperature is 11',(⎕ucs 176),'C or  51.8'
_,←(⎕ucs 176 70 10),'                   30       86.0',(⎕ucs 10),'                   60      140.0</code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10),'<p>Let',(⎕ucs 8217)
_,←'s precompute a dfn <code>T</code>, given the string',(⎕ucs 10),'<code>t</code>.',(⎕ucs 8194),'<code>T</code> has everything needed to generate the',(⎕ucs 10)
_,←'output (given the same definition of the vector <code>cv</code>, when',(⎕ucs 10),'<code>T</code> is evaluated).</p>',(⎕ucs 10),'<pre><code>   T← 1 ∆F t       ⍝ Or (dfn: 1) ∆F ...</code></pre>'
_,←(⎕ucs 10),'<details id="pPeek">',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'Evaluate <code>T ⍬</code>',(⎕ucs 10),'</summary>',(⎕ucs 10),'<pre><code>   T ⍬',(⎕ucs 10)
_,←'The temperature is 11',(⎕ucs 176),'C or  51.8',(⎕ucs 176 70 10),'                   30       86.0',(⎕ucs 10),'                   60      140.0</code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10)
_,←'<p>Now, let',(⎕ucs 8217),'s compare the performance of the two formats. <span',(⎕ucs 10),'class="margin-note"><br><br><br>Both <code>t</code> and <code>T</code>',(⎕ucs 10)
_,←'will reference <code>cv</code>.</span></p>',(⎕ucs 10),'<pre><code>   cmpx &#39;∆F t&#39; &#39;T ⍬&#39;',(⎕ucs 10),'  ∆F t → 1.5E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕',(⎕ucs 10)
_,←'  T ⍬  → 1.1E¯5 | -93% ⎕⎕⎕</code></pre>',(⎕ucs 10),'<p>The precomputed version is <mark>much</mark> faster.</p>',(⎕ucs 10),'<p>Before we get to syntax and other information, we want to show you'
_,←(⎕ucs 10),'that <span class="margin-note">The <em>dfn</em> returned includes the',(⎕ucs 10),'original <em>f',(⎕ucs 8209),'string</em> text used to generate it, available as',(⎕ucs 10)
_,←'<code>`⍵0</code>.</span> the <em>dfn</em> returned when the <em>dfn</em>',(⎕ucs 10),'option is set to <code>1</code> can retrieve one or more arguments',(⎕ucs 10)
_,←'passed on the right side of <strong>∆F</strong>, using the very same',(⎕ucs 10),'omega shortcut expressions (like <code>`⍵1</code>) we',(⎕ucs 8217),'ve discussed',(⎕ucs 10),'above.</p>',(⎕ucs 10)
_,←'<p>Let',(⎕ucs 8217),'s share the Centigrade values <code>cv</code> from our current',(⎕ucs 10),'example, not as a <em>variable</em>, but as the <em>first argument</em>',(⎕ucs 10)
_,←'to <strong>∆F</strong>. We',(⎕ucs 8217),'ll access the value as <code>`⍵1</code>.</p>',(⎕ucs 10),'<pre><code>   cv←11 30 60',(⎕ucs 10),'   t←&#39;The temperature is {&quot;I2&quot; $ `⍵1}'
_,←(⎕ucs 176),'C or {&quot;F5.1&quot; $ 32+9×`⍵1÷5}',(⎕ucs 176),'F&#39;',(⎕ucs 10),'   T← 1 ∆F t       ⍝ Or  (dfn: 1)',(⎕ucs 10 10),'   ∆F t cv',(⎕ucs 10),'The temperature is 11',(⎕ucs 176)
_,←'C or  51.8',(⎕ucs 176 70 10),'                   30       86.0',(⎕ucs 10),'                   60      140.0',(⎕ucs 10 10),'   T ⊂cv',(⎕ucs 10),'The temperature is 11',(⎕ucs 176),'C or  51.8'
_,←(⎕ucs 176 70 10),'                   30       86.0',(⎕ucs 10),'                   60      140.0',(⎕ucs 10 10),'   cmpx &#39;∆F t cv&#39; &#39;T ⊂cv&#39;',(⎕ucs 10)
_,←'  ∆F t cv → 1.8E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕',(⎕ucs 10),'  T ⊂cv   → 1.1E¯5 | -95% ⎕⎕⎕</code></pre>',(⎕ucs 10)
_,←'<p>The precomputed version again shows a <mark>substantial</mark>',(⎕ucs 10),'speedup over the default version.</p>',(⎕ucs 10),'<h2 data-number="4.23" id="multiline-f-strings-in-dyalog-20"><span'
_,←(⎕ucs 10),'class="header-section-number">4.23</span> Multiline <em>F-strings</em>',(⎕ucs 10),'in Dyalog 20</h2>',(⎕ucs 10),'<p>Sometimes it',(⎕ucs 8217),'s <span class="margin-note">Excuse the ob'
_,←(⎕ucs 173),'fusc',(⎕ucs 173),'atory',(⎕ucs 10),'sesqui',(⎕ucs 173),'pedal',(⎕ucs 173),'ianism!</span>programmatically pro',(⎕ucs 173),'pitious or pedagog',(⎕ucs 173),'ically',(⎕ucs 10),'per'
_,←(⎕ucs 173),'spicacious to construct, or display, an <em>f-string</em> across',(⎕ucs 10),'multiple lines in the <strong>∆F</strong> call. You can do this using',(⎕ucs 10)
_,←'<em>APL</em> Array Notation, for example, dividing the <em>f-string</em>',(⎕ucs 10),'across multiple (parenthesized) character vectors, each on a separate',(⎕ucs 10)
_,←'line.<span class="margin-note"><br><br><br><br><br><br>Note that APL',(⎕ucs 10),'handles the comments in multi-line strings!</span></p>',(⎕ucs 10)
_,←'<pre><code>   lastNm firstNm MI← &#39;Smith&#39; &#39;Mary&#39; &#39;J&#39;',(⎕ucs 10),'   street city state← &#39;5108 Grover St.&#39; &#39;Omaha&#39; &#39;Nebraska&#39;',(⎕ucs 10 10)
_,←'   ∆F (                              ⍝ Copious explanatory comments!',(⎕ucs 10),'     &#39;Name: &#39;',(⎕ucs 10),'     &#39;{lastNm}, &#39;                    ⍝ The last name',(⎕ucs 10)
_,←'     &#39;{firstNm} {MI}. &#39;              ⍝ The first name and middle initial',(⎕ucs 10),'     &#39;Address is: &#39;',(⎕ucs 10),'     &#39;{street} in {city}, {state}.&#39;  ⍝ US address.'
_,←(⎕ucs 10),'  ) ⍬                                ⍝ ⍬ is a dummy argument',(⎕ucs 10),'Name: Smith, Mary J. Address is: 5108 Grover St. in Omaha, Nebraska.</code></pre>',(⎕ucs 10)
_,←'<p>In any case, <strong>∆F</strong> treats a multiline <em>f-string</em>',(⎕ucs 10),'as its single-line (<code>∊</code>) equivalent. The above',(⎕ucs 10)
_,←'<strong>∆F</strong> call produces the very same output as this one:</p>',(⎕ucs 10),'<pre><code>   ∆F &#39;Name: {lastNm}, {firstNm} {MI}. Address is: {street} in {city}, {state}.&#39;</code></pre>'
_,←(⎕ucs 10),'<p><big>',(⎕ucs 128073),'</big>',(⎕ucs 160),'To ensure multiple adjacent character vectors are',(⎕ucs 10),'interpreted as part of the <em>f-string</em> when there are no following'
_,←(⎕ucs 10),'arguments, consider:</p>',(⎕ucs 10),'<ul>',(⎕ucs 10),'<li>enclosing the vectors, as in <code>∆F ⊂(...)</code>, or</li>',(⎕ucs 10)
_,←'<li>placing any dummy argument (<em>e.g.</em> <code>⍬</code>) after the',(⎕ucs 10),'multiline <em>f-string</em>, as in the example above.</li>',(⎕ucs 10),'</ul>',(⎕ucs 10),'<hr />',(⎕ucs 10)
_,←'<p>Below, we summarize key information you',(⎕ucs 8217),'ve already gleaned from the',(⎕ucs 10),'examples.</p>',(⎕ucs 10),'</details>',(⎕ucs 10),'<div class="page-break">',(⎕ucs 10 10),'</div>'
_,←(⎕ucs 10),'<h1 data-number="5" id="f-reference"><span',(⎕ucs 10),'class="header-section-number">5</span> ∆F Reference</h1>',(⎕ucs 10),'<details>',(⎕ucs 10),'<!-- option: open -->',(⎕ucs 10)
_,←'<summary class="summary">',(⎕ucs 10 8194),'<span style="opacity:0.6;">Show/Hide</span> <em>Syntax Info</em>',(⎕ucs 10),'</summary>',(⎕ucs 10)
_,←'<p><a id="inside-reference" class="scroll-target"></a></p>',(⎕ucs 10),'<h2 data-number="5.1" id="f-call-syntax-overview"><span',(⎕ucs 10)
_,←'class="header-section-number">5.1</span> ∆F Call Syntax Overview</h2>',(⎕ucs 10),'<p><span class="margin-note"><br><br><br><br><br><br><br><br>See the',(⎕ucs 10)
_,←'example of <a href="#multiline-f-strings-in-dyalog-20">multiline',(⎕ucs 10),'<em>f-strings</em> in Dy',(⎕ucs 173 97 173),'log 20</a>.</span> <span',(⎕ucs 10)
_,←'class="margin-note"><br><br><br><br><br><strong><em>Options</em></strong>',(⎕ucs 10),'may be either <em>positional</em> or',(⎕ucs 8212),' starting in Dyalog v. 20',(⎕ucs 8212 10)
_,←'<em>keyword</em>-based. We show the posi',(⎕ucs 173),'tion',(⎕ucs 173),'al forms through',(⎕ucs 173),'out the',(⎕ucs 10 101 120 173),'amples, but doc',(⎕ucs 173),'ument the key',(⎕ucs 173)
_,←'words as well below.</span></p>',(⎕ucs 10),'<p><a id="table-call-syntax" class="scroll-target"></a></p>',(⎕ucs 10),'<table>',(⎕ucs 10)
_,←'<caption>5a. <strong>∆F Call Syntax Overview</strong></caption>',(⎕ucs 10),'<colgroup>',(⎕ucs 10),'<col style="width: 26%" />',(⎕ucs 10),'<col style="width: 73%" />',(⎕ucs 10),'</colgroup>'
_,←(⎕ucs 10),'<thead>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<th style="text-align: left;">Call Syntax</th>',(⎕ucs 10),'<th style="text-align: left;">Description</th>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</thead>'
_,←(⎕ucs 10),'<tbody>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td',(⎕ucs 10),'style="text-align: left;"><strong>∆F</strong>',(⎕ucs 8194),'<strong><em>f',(⎕ucs 8209),'string</em></strong></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Display an <em>f',(⎕ucs 8209),'string</em>; use the',(⎕ucs 10),'<em>default</em> options. The string may reference objects in the',(⎕ucs 10)
_,←'environment or in the string itself. Returns a character matrix.',(⎕ucs 10),'<br><strong><span class="red"><strong>Single or </strong></span><a',(⎕ucs 10)
_,←'href="#multiline-f-strings-in-dyalog-20"><span',(⎕ucs 10),'class="red"><strong>multi',(⎕ucs 173),'line f-string:</strong></span></a></strong> An',(⎕ucs 10)
_,←'<strong><em>f-string</em></strong> must be a character vector of any',(⎕ucs 10),'length or a <a href="#multiline-f-strings-in-dyalog-20">vector of',(⎕ucs 10)
_,←'character vectors</a>. If the latter, it will be converted (via',(⎕ucs 10),'<em>enlist,</em> <code>∊</code>) to one, longer character vector,',(⎕ucs 10)
_,←'without any added spaces, newlines, etc.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td',(⎕ucs 10),'style="text-align: left;"><strong>∆F</strong>',(⎕ucs 8194),'<strong><em>f',(⎕ucs 8209)
_,←'string</em></strong>',(⎕ucs 8194),'<strong><em>args</em></strong></td>',(⎕ucs 10),'<td style="text-align: justify;">Display an <em>f',(⎕ucs 8209),'string</em> (see above);',(⎕ucs 10)
_,←'use the <em>default</em> options. Arguments presented <em>may</em> be',(⎕ucs 10),'referred to in the f',(⎕ucs 8209),'string. Returns a character matrix.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>'
_,←(⎕ucs 10),'<td',(⎕ucs 10),'style="text-align: left;"><strong><em>options</em></strong>',(⎕ucs 8194),'<strong>∆F</strong>',(⎕ucs 8194),'<strong><em>f',(⎕ucs 8209),'string</em></strong>',(⎕ucs 8194)
_,←'[<strong><em>args</em></strong>]</td>',(⎕ucs 10),'<td style="text-align: justify;">Display an <em>f',(⎕ucs 8209),'string</em> (see above);',(⎕ucs 10)
_,←'control the result with <em>options</em> specified (see below).<br><span',(⎕ucs 10),'class="red"><strong>If <strong><em>dfn</em></strong> (see below) is',(⎕ucs 10)
_,←'<strong><em>0</em></strong> or omitted,</strong></span> returns a',(⎕ucs 10),'character matrix.<br><span class="red"><strong>If',(⎕ucs 10),'<strong><em>dfn</em></strong> is',(⎕ucs 10)
_,←'<strong><em>1</em></strong>,</strong></span> returns a dfn that will',(⎕ucs 10),'display such a matrix (given an identical system state).</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td'
_,←(⎕ucs 10),'style="text-align: left;">',(⎕ucs 8216),'help',(⎕ucs 8217 8194),'<strong>∆F</strong>',(⎕ucs 8194 8216 8201 8217 8194),'<em>or</em>',(⎕ucs 8194),'<strong>∆F</strong>⍨',(⎕ucs 8216),'help'
_,←(⎕ucs 8217),'</td>',(⎕ucs 10),'<td style="text-align: justify;">Display help info and examples for',(⎕ucs 10),'<strong>∆F</strong>. The <em>f',(⎕ucs 8209),'string</em> is not examined.',(⎕ucs 10)
_,←'<big>',(⎕ucs 128073),'</big>',(⎕ucs 160),'See below for details and related examples.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong><em>Return'
_,←(⎕ucs 10),'value</em></strong></td>',(⎕ucs 10),'<td style="text-align: justify;">See below.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</tbody>',(⎕ucs 10),'</table>',(⎕ucs 10)
_,←'<h2 data-number="5.2" id="f-option-details"><span',(⎕ucs 10),'class="header-section-number">5.2</span> ∆F Option Details</h2>',(⎕ucs 10)
_,←'<p><a id="inside-option-details" class="scroll-target"></a></p>',(⎕ucs 10),'<table>',(⎕ucs 10),'<caption>5b. <strong>∆F Option Details</strong></caption>',(⎕ucs 10),'<colgroup>',(⎕ucs 10)
_,←'<col style="width: 1%" />',(⎕ucs 10),'<col style="width: 6%" />',(⎕ucs 10),'<col style="width: 11%" />',(⎕ucs 10),'<col style="width: 80%" />',(⎕ucs 10),'</colgroup>',(⎕ucs 10),'<thead>',(⎕ucs 10)
_,←'<tr>',(⎕ucs 10),'<th style="text-align: center;"><br>Mode</th>',(⎕ucs 10),'<th',(⎕ucs 10),'style="text-align: center;">Positional<br>Option<br><small>[<em>index</em>]</small></th>',(⎕ucs 10)
_,←'<th style="text-align: center;">Keyword<br>Option<br><small>(<em>kw:',(⎕ucs 10),'def</em>)</th>',(⎕ucs 10),'<th style="text-align: left;"><br>Description</th>',(⎕ucs 10),'</tr>',(⎕ucs 10)
_,←'</thead>',(⎕ucs 10),'<tbody>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;"><strong>dfn</strong></td>',(⎕ucs 10),'<td style="text-align: center;"><strong><em>[0]</em></strong></td>'
_,←(⎕ucs 10),'<td style="text-align: center;"><strong><em>dfn:',(⎕ucs 160),'0</em></strong></td>',(⎕ucs 10),'<td style="text-align: justify;"><span class="red"><strong>If',(⎕ucs 10),'<strong><em>dfn:'
_,←(⎕ucs 160),'1</em></strong>,</strong></span> <strong>∆F</strong>',(⎕ucs 10),'returns a dfn, which (upon execution) produces the same output as the',(⎕ucs 10)
_,←'default mode.<br><span class="red"><strong>If',(⎕ucs 10),'<strong><em>dfn:',(⎕ucs 160),'0</em></strong> (default),</strong></span>',(⎕ucs 10),'<strong>∆F</strong> returns a char. matrix.</td>'
_,←(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;"><strong>verbose</strong></td>',(⎕ucs 10),'<td style="text-align: center;"><strong><em>[1]</em></strong></td>',(⎕ucs 10)
_,←'<td',(⎕ucs 10),'style="text-align: center;"><strong><em>verbose:',(⎕ucs 160),'0</em></strong></td>',(⎕ucs 10),'<td style="text-align: justify;"><span class="red"><strong>If',(⎕ucs 10)
_,←'<strong><em>verbose:',(⎕ucs 160),'1</em></strong>,</strong></span> Renders newline',(⎕ucs 10),'characters from <code>`',(⎕ucs 9671),'</code> as the visible <code>',(⎕ucs 9252),'</code> character.'
_,←(⎕ucs 10),'Displays the source code that the <em>f',(⎕ucs 8209),'string</em>',(⎕ucs 10),'<strong><em>actually</em></strong> generates; <span',(⎕ucs 10),'class="red"><strong>if',(⎕ucs 160)
_,←'<strong><em>dfn</em></strong> is also',(⎕ucs 10),'<strong><em>1</em></strong>,</strong></span> this will include the',(⎕ucs 10),'embedded <em>f',(⎕ucs 8209)
_,←'string</em> source (accessed as <code>`⍵0</code>). After',(⎕ucs 10),'the source code is displayed, it will be executed or converted to a',(⎕ucs 10)
_,←'<em>dfn</em> and returned (see the <strong><em>dfn</em></strong> option',(⎕ucs 10),'above).<br><span class="red"><strong>If',(⎕ucs 10),'<strong><em>verbose:',(⎕ucs 160)
_,←'0</em></strong> (default),</strong></span> newline',(⎕ucs 10),'characters from <code>`',(⎕ucs 9671),'</code> are rendered normally as carriage',(⎕ucs 10)
_,←'returns, <code>⎕UCS 13</code>; the <strong><em>dfn</em></strong> source',(⎕ucs 10),'code is not displayed.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong>box</strong></td>',(⎕ucs 10),'<td style="text-align: center;"><strong><em>[2]</em></strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong><em>box:',(⎕ucs 160),'0</em></strong></td>',(⎕ucs 10),'<td style="text-align: justify;"><span class="red"><strong>If',(⎕ucs 10),'<strong><em>box:',(⎕ucs 160)
_,←'1</em></strong>,</strong></span> each field (except a',(⎕ucs 10),'null <strong>Text</strong> field) is boxed separately.<br><span',(⎕ucs 10),'class="red"><strong>If <strong><em>box:',(⎕ucs 160)
_,←'0</em></strong>',(⎕ucs 10),'(default),</strong></span> nothing is boxed automatically. Any',(⎕ucs 10),'<strong>Code</strong> field expression may be explicitly boxed using the',(⎕ucs 10)
_,←'<strong>Box</strong> shortcut,',(⎕ucs 10),'<code>`B</code>.<br><big>',(⎕ucs 128073),'</big>',(⎕ucs 160),'<strong><em>Box</em></strong> mode can',(⎕ucs 10)
_,←'be used with settings <strong><code>dfn: 1</code></strong> <em>and</em>',(⎕ucs 10),'<strong><code>dfn: 0</code>.</strong></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong>auto</strong></td>',(⎕ucs 10),'<td style="text-align: center;"><strong><em>[3]</em></strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong><em>auto:',(⎕ucs 160),'1</em></strong></td>',(⎕ucs 10),'<td style="text-align: justify;"><span class="red"><strong>If',(⎕ucs 10),'<strong><em>auto:'
_,←(⎕ucs 160),'0</em></strong>,</strong></span> user must manually',(⎕ucs 10),'load/create any Session Library objects for use with the £ or',(⎕ucs 10)
_,←'<code>`L</code> shortcuts.<br><span class="red"><strong>If',(⎕ucs 10),'<strong><em>auto:',(⎕ucs 160),'1</em></strong> (default),</strong></span> honors the',(⎕ucs 10)
_,←'default and user-defined settings for',(⎕ucs 10),'<code>auto</code>.<br><big>',(⎕ucs 128073),'</big>',(⎕ucs 160),'Depends on (i) user parameter file',(⎕ucs 10)
_,←'<strong>./.∆F</strong> and (ii) the namespace <strong>FString</strong>',(⎕ucs 10),'created during the <code>]load</code> process.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong>inline</strong></td>',(⎕ucs 10),'<td style="text-align: center;"><strong><em>[4]</em></strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong><em>inline:',(⎕ucs 160),'0</em></strong></td>',(⎕ucs 10),'<td style="text-align: justify;"><span class="red"><strong>If',(⎕ucs 10),'<strong><em>inline:'
_,←(⎕ucs 160),'1</em></strong>,</strong></span> the code for each',(⎕ucs 10),'internal support function used is included in the result. <span',(⎕ucs 10)
_,←'class="red"><strong>If <strong><em>dfn</em></strong> is also',(⎕ucs 10),'1,</strong></span> <strong><em>no</em></strong> reference to namespace',(⎕ucs 10)
_,←'<strong>FString</strong> will be made during the execution of the',(⎕ucs 10),'generated <em>dfn</em>. (<strong><em>Exception:</em></strong> see',(⎕ucs 10)
_,←'<em>Session Library Shortcuts</em> below.)<br><span',(⎕ucs 10),'class="red"><strong>If <strong><em>inline:',(⎕ucs 160),'0</em></strong>',(⎕ucs 10)
_,←'(default),</strong></span> whenever <strong>∆F</strong> or a',(⎕ucs 10),'<em>dfn</em> generated by it is executed, it makes calls to library',(⎕ucs 10)
_,←'routines in the namespace <strong>FString</strong>, created during the',(⎕ucs 10),'<code>]load</code> process for',(⎕ucs 10),'<strong>∆F</strong>.<br><big>',(⎕ucs 128073),'</big>',(⎕ucs 160)
_,←'This option is experimental and',(⎕ucs 10),'may simply disappear one day.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;"><strong>special</strong></td>'
_,←(⎕ucs 10),'<td style="text-align: center;"><strong><em>',(⎕ucs 8216),'help',(⎕ucs 8217),'</em></strong></td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 8212),'</td>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><span class="red"><strong>If',(⎕ucs 10),'<strong><em>',(⎕ucs 8216),'help',(⎕ucs 8217),'</em></strong> is specified,</strong></span> this',(⎕ucs 10),'amazing doc'
_,←(⎕ucs 173),'ument',(⎕ucs 173),'ation is displayed.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;"><strong>special</strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong><em>',(⎕ucs 8216),'parms',(⎕ucs 8217),'</em></strong></td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 8212),'</td>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><span class="red"><strong>If',(⎕ucs 10),'<strong><em>',(⎕ucs 8216),'parms',(⎕ucs 8217),'</em></strong> is specified,</strong></span> updates',(⎕ucs 10)
_,←'and displays Session Library (<code>£</code> or <code>`L</code>)',(⎕ucs 10 112 97 173),'ram',(⎕ucs 173),'eters.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</tbody>',(⎕ucs 10),'</table>',(⎕ucs 10),'<ul>'
_,←(⎕ucs 10),'<li><strong>Default options:</strong> If the left argument',(⎕ucs 10),'<code>⍺</code> is omitted, the options default as shown here.</li>',(⎕ucs 10),'</ul>',(⎕ucs 10)
_,←'<p><a id="table-default-options" class="scroll-target"></a></p>',(⎕ucs 10),'<table style="width:92%;">',(⎕ucs 10),'<caption>5c. <strong>∆F Default Options</strong></caption>',(⎕ucs 10),'<colgroup>'
_,←(⎕ucs 10),'<col style="width: 26%" />',(⎕ucs 10),'<col style="width: 65%" />',(⎕ucs 10),'</colgroup>',(⎕ucs 10),'<thead>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<th style="text-align: center;">Option Style</th>',(⎕ucs 10),'<th style="text-align: center;">Defaults</th>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</thead>',(⎕ucs 10),'<tbody>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong>Positional</strong></td>',(⎕ucs 10),'<td style="text-align: center;"><code>0 0 0 1 0</code></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong>Keyword</strong></td>',(⎕ucs 10),'<td',(⎕ucs 10),'style="text-align: center;"><code>(dfn: 0 ',(⎕ucs 9671),' verbose: 0 ',(⎕ucs 9671),' box: 0 ',(⎕ucs 9671)
_,←' auto: 1 ',(⎕ucs 9671),' inline: 0)</code></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</tbody>',(⎕ucs 10),'</table>',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li><strong>Positional-style options:</strong> If <strong>∆F</strong>',(⎕ucs 8217 115 10),'left argument <code>⍺</code> is a simple integer vector (or a scalar),',(⎕ucs 10)
_,←'omitted (trailing) elements are replaced by the corresponding elements',(⎕ucs 10),'of the default, <code>0 0 0 1 0</code>.<br><big>',(⎕ucs 128073),'</big>',(⎕ucs 160),'Extra elements',(⎕ucs 10)
_,←'will trigger a <strong><em>DOMAIN ERROR.</em></strong></li>',(⎕ucs 10),'<li><strong>Keyword-style options:</strong> If the left argument is a',(⎕ucs 10)
_,←'<span class="margin-note">Dyalog 20 and later. See docu',(⎕ucs 173),'ment',(⎕ucs 173),'ation on',(⎕ucs 10),'<em>APL</em> Ar',(⎕ucs 173),'ray Not',(⎕ucs 173)
_,←'ation.</span>namespace, it is assumed to contain',(⎕ucs 10),'option names (in any order) with their non-default',(⎕ucs 10),'values,<br>',(⎕ucs 8195 8195),'e.g.',(⎕ucs 160),'<code>(verbose: 1 '
_,←(⎕ucs 9671),' auto: 0)</code>;<br />',(⎕ucs 10),'Keyword options are new for Dyalog 20. They are sometimes clearer and',(⎕ucs 10),'more convenient than positional keywords.</li>',(⎕ucs 10)
_,←'<li><strong>Help option:</strong> If the left argument <code>⍺</code>',(⎕ucs 10),'starts with <code>''help''</code> (case ignored), this help information is',(⎕ucs 10)
_,←'displayed. In this case, the right argument to <strong>∆F</strong> is',(⎕ucs 10),'ignored.</li>',(⎕ucs 10),'<li><strong>Parms option:</strong> If the left argument <code>⍺</code>',(⎕ucs 10)
_,←'matches <code>''parms''</code> (case ignored), the Session Library',(⎕ucs 10),'parameters are (re-)loaded and displayed. In this case, the right',(⎕ucs 10)
_,←'argument to <strong>∆F</strong> is ignored.</li>',(⎕ucs 10),'<li>Otherwise, an error is signaled.</li>',(⎕ucs 10),'</ul>',(⎕ucs 10),'<h2 data-number="5.3" id="f-return-value"><span',(⎕ucs 10)
_,←'class="header-section-number">5.3</span> ∆F Return Value</h2>',(⎕ucs 10),'<ul>',(⎕ucs 10),'<li>Unless the <strong><em>dfn</em></strong> option is selected,',(⎕ucs 10)
_,←'<strong>∆F</strong> always returns a character matrix of at least one',(⎕ucs 10),'row and zero columns, <code>1 0⍴0</code>, on success. If the ',(⎕ucs 8216),'help',(⎕ucs 8217 10)
_,←'option is specified, <strong>∆F</strong> displays this information,',(⎕ucs 10),'returning <code>1 0⍴0</code>. If the ',(⎕ucs 8216),'parms',(⎕ucs 8217),' option is specified,',(⎕ucs 10)
_,←'<strong>∆F</strong> shows the Session Library parameters as a character',(⎕ucs 10),'matrix.</li>',(⎕ucs 10),'<li>If the <strong><em>dfn</em></strong> option is selected,',(⎕ucs 10)
_,←'<strong>∆F</strong> always returns a standard Dyalog dfn on',(⎕ucs 10),'success.</li>',(⎕ucs 10),'<li>On failure of any sort, an informative <em>APL</em> error is',(⎕ucs 10),'signaled.</li>'
_,←(⎕ucs 10),'</ul>',(⎕ucs 10),'<h2 data-number="5.4" id="f-fstring-building-blocks"><span',(⎕ucs 10),'class="header-section-number">5.4</span> ∆F F',(⎕ucs 8209),'string Building',(⎕ucs 10)
_,←'Blocks</h2>',(⎕ucs 10),'<p>The first element in the right arg to ∆F is a character vector, an',(⎕ucs 10),'<em>f',(⎕ucs 8209),'string</em>, which contains one or more <strong>Text</strong>'
_,←(⎕ucs 10),'fields, <strong>Code</strong> fields, and <strong>Space</strong> fields',(⎕ucs 10),'in any combination.</p>',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li><strong>Text</strong> fields consist of simple text, which may',(⎕ucs 10),'include any Unicode characters desired, including newlines.',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li>Newlines (actually, carriage returns, <code>⎕UCS 13</code>) are',(⎕ucs 10),'normally entered via the sequence <code>`',(⎕ucs 9671),'</code>.</li>',(⎕ucs 10)
_,←'<li>Additionally, literal curly braces can be added via <code>`{</code>',(⎕ucs 10),'and <code>`}</code>, so they are distinct from the simple curly braces',(⎕ucs 10)
_,←'used to begin and end <strong>Code</strong> fields and',(⎕ucs 10),'<strong>Space</strong> fields.</li>',(⎕ucs 10),'<li>Finally, to enter a single backtick <code>`</code> just before the',(⎕ucs 10)
_,←'special symbols <code>{</code>, <code>}</code>, <code>',(⎕ucs 9671),'</code>, or',(⎕ucs 10),'<code>`</code>, enter <strong><em>two</em></strong> backticks',(⎕ucs 10)
_,←'<code>``</code>; if preceding any ordinary symbol, a',(⎕ucs 10),'<strong><em>single</em></strong> backtick will suffice.</li>',(⎕ucs 10),'<li>If <strong>∆F</strong> is called with an empty string,'
_,←(⎕ucs 10),'<code>∆F ''''</code>, it is interpreted as containing a single 0-length',(⎕ucs 10),'<strong>Text</strong> field, returning a matrix of shape',(⎕ucs 10),'<code>1 0</code>.</li>',(⎕ucs 10)
_,←'</ul></li>',(⎕ucs 10),'<li><strong>Code</strong> fields are run-time evaluated expressions',(⎕ucs 10),'enclosed within simple, unescaped curly braces <code>{',(⎕ucs 160),'}</code>,',(⎕ucs 10)
_,←'<em>i.e.</em> those not preceded by a backtick (see the previous',(⎕ucs 10),'paragraph).',(⎕ucs 10),'<ul>',(⎕ucs 10),'<li><strong>Code</strong> fields are, under the covers, Dyalog',(⎕ucs 10)
_,←'<em>dfns</em> with some extras.</li>',(⎕ucs 10),'<li>For escape sequences, see <strong>Escape Sequences</strong>',(⎕ucs 10),'below.</li>',(⎕ucs 10),'</ul></li>',(⎕ucs 10)
_,←'<li><strong>Space</strong> fields appear to be a special,',(⎕ucs 10),'<em>degenerate</em>, form of <strong>Code</strong> fields, consisting of',(⎕ucs 10)
_,←'a single pair of simple (unescaped) curly braces <code>{}</code> with',(⎕ucs 10),'zero or more spaces in between.',(⎕ucs 10),'<ul>',(⎕ucs 10)
_,←'<li>A <strong>Space</strong> field with zero spaces is a',(⎕ucs 10),'<strong><em>null</em></strong> <strong>Space</strong> field; while it',(⎕ucs 10)
_,←'may separate any other fields, its typical use is to separate two',(⎕ucs 10),'adjacent <strong>Text</strong> fields.</li>',(⎕ucs 10)
_,←'<li>Between fields, <strong>∆F</strong> adds no automatic spaces; that',(⎕ucs 10),'spacing is under user control.</li>',(⎕ucs 10),'</ul></li>',(⎕ucs 10),'</ul>',(⎕ucs 10)
_,←'<h2 data-number="5.5" id="code-field-shortcuts"><span',(⎕ucs 10),'class="header-section-number">5.5</span> Code Field Shortcuts</h2>',(⎕ucs 10)
_,←'<p><strong>∆F</strong> <strong>Code</strong> fields may contain various',(⎕ucs 10),'shortcuts, intended to be concise and expressive tools for common tasks.',(⎕ucs 10)
_,←'<strong>Shortcuts</strong> are valid in <strong>Code</strong> fields',(⎕ucs 10),'only <em>outside</em> <strong>Quoted strings</strong>.</p>',(⎕ucs 10),'<p><strong>Shortcuts</strong> include:</p>'
_,←(⎕ucs 10),'<p><a id="table-shortcuts" class="scroll-target"></a></p>',(⎕ucs 10),'<table>',(⎕ucs 10),'<caption>5d. <strong>Code Field Shortcuts</strong></caption>',(⎕ucs 10),'<colgroup>',(⎕ucs 10)
_,←'<col style="width: 12%" />',(⎕ucs 10),'<col style="width: 18%" />',(⎕ucs 10),'<col style="width: 11%" />',(⎕ucs 10),'<col style="width: 57%" />',(⎕ucs 10),'</colgroup>',(⎕ucs 10),'<thead>'
_,←(⎕ucs 10),'<tr>',(⎕ucs 10),'<th style="text-align: left;">Shortcut</th>',(⎕ucs 10),'<th style="text-align: center;">Name</th>',(⎕ucs 10),'<th style="text-align: center;">Syntax</th>',(⎕ucs 10)
_,←'<th style="text-align: left;">Meaning</th>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</thead>',(⎕ucs 10),'<tbody>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`A</strong>,',(⎕ucs 10)
_,←'<strong>%</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Above</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺] % ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Centers array <code>⍺</code> above array',(⎕ucs 10),'<code>⍵</code>.<br>If omitted, <code>⍺←''''</code>, <em>i.e.</em> a blank',(⎕ucs 10),'line.</td>',(⎕ucs 10)
_,←'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`B</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Box</td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><code>`B ⍵</code></td>',(⎕ucs 10),'<td style="text-align: justify;">Places <code>⍵</code> in a box.',(⎕ucs 10),'<code>⍵</code> is any array. <big>',(⎕ucs 128073)
_,←'</big>In contrast with Dyalog',(⎕ucs 10),'<code>]box</code> mode, even simple scalars and vectors are boxed',(⎕ucs 10),'here.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><strong>`C</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Commas</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`C ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">By default, adds commas after every 3rd',(⎕ucs 10),'digit (from the right) of the <em>integer</em> part of each number in',(⎕ucs 10)
_,←'<code>⍵</code> (leaving the fractional part as is). <code>⍵</code> is',(⎕ucs 10),'zero or more num strings and/or numbers. The options <code>⍺</code>',(⎕ucs 10)
_,←'consists of up to two scalars, one number <code>n</code> (if not 3) for',(⎕ucs 10),'every n digits from right to left, and one character (even ',(⎕ucs 8220 96 9671 8221),') to',(⎕ucs 10)
_,←'insert (if not a comma). <br><small>Examples: ',(⎕ucs 8220 53 95 8221),' or ',(⎕ucs 8220 95 53 8221),' adds an',(⎕ucs 10),'underscore every 5 digits from the right. ',(⎕ucs 8220 51 96 9671 8221)
_,←' puts each set of 3',(⎕ucs 10),'digits on its own line. ',(⎕ucs 8220 95 8221),' places underscores between every 3 digits',(⎕ucs 10)
_,←'from the right.<br>Note: Tolerates chars mixed in with digits, but only',(⎕ucs 10),'formats numbers to the left of an optional decimal point.</small></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>'
_,←(⎕ucs 10),'<td style="text-align: justify;"><strong>`D</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Date-Time</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`D ⍵</code></td>'
_,←(⎕ucs 10),'<td style="text-align: justify;">Synonym for <strong>`T</strong>.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`F</strong>,',(⎕ucs 10)
_,←'<strong>$</strong></td>',(⎕ucs 10),'<td style="text-align: center;">⎕FMT</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺] $ ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Short for <code>[⍺] ⎕FMT ⍵</code>. (See',(⎕ucs 10),'<em>APL</em> doc',(⎕ucs 173),'ument',(⎕ucs 173),'ation).</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><strong>`J</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Justify</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`J ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Justify each row of object <code>⍵</code>',(⎕ucs 10),'as text:<br>',(⎕ucs 8195 8195),'<em>left</em>: ⍺=',(⎕ucs 8220 76 8221),'; <em>center</em>: ⍺='
_,←(⎕ucs 8220 67 8221 59 10),'<em>right</em> ⍺=',(⎕ucs 8220 82 8221),'.<br>You may use',(⎕ucs 10),'<code>¯1</code>|<code>0</code>|<code>1</code> in place of',(⎕ucs 10)
_,←'<code>"L"</code>|<code>"C"</code>|<code>"R"</code>. If omitted,',(⎕ucs 10),'<code>⍺←''L''</code>. <small><em>Displays numbers with the maximum',(⎕ucs 10),'precision available.</em></small></td>'
_,←(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`L</strong>,',(⎕ucs 10),'<strong>£</strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Session Library</td>',(⎕ucs 10),'<td style="text-align: center;"><code>£.nm</code><br><code>£.nm<span',(⎕ucs 10)
_,←'class="grey"><strong>.nm2</strong></span></code></td>',(⎕ucs 10),'<td style="text-align: justify;"><code>£</code> denotes a private library',(⎕ucs 10)
_,←'(namespace) local to the <strong>∆F</strong> runtime environ',(⎕ucs 173),'ment into',(⎕ucs 10),'which functions or objects (including name',(⎕ucs 173),'spaces) may be placed',(⎕ucs 10),'(e.g.'
_,←(⎕ucs 160),'via <code>⎕CY</code>) for the duration of the <em>APL</em>',(⎕ucs 10),'session.<br><strong>Autoload:</strong> Outside of simple assignments,',(⎕ucs 10)
_,←'<strong>∆F</strong> will attempt to copy an undefined object named',(⎕ucs 10),'<code>nm</code> in the expression <code>£.nm</code>, <code>£.nm<span',(⎕ucs 10)
_,←'class="grey"><strong>.nm2</strong></span></code>, <em>etc.</em>, from,',(⎕ucs 10),'<em>in order:</em><br>',(⎕ucs 8195),'<small><small><span',(⎕ucs 10)
_,←'class="blue"><strong>DIRECTORY:</strong></span></small></small>',(⎕ucs 8201),'<strong>./MyDyalogLib/</strong>',(⎕ucs 10 160),'&gt;',(⎕ucs 160)
_,←' <small><small><span class="blue"><strong><em>APL</em>',(⎕ucs 10),'WS:</strong></span></small></small>',(⎕ucs 8201),'<strong>dfns</strong>',(⎕ucs 10 160),'&gt;',(⎕ucs 160),'<small><small><span'
_,←(⎕ucs 10),'class="blue"><strong>DIRECTORY:</strong></span></small></small>',(⎕ucs 8201),'<strong>./</strong><br><small>Other',(⎕ucs 10)
_,←'<code>£</code> expressions like <code>£.(hex dec)</code> are valid, but',(⎕ucs 10),'no autoload takes place.<br><em>For filetypes and customisation, see <a',(⎕ucs 10)
_,←'href="#session-library-shortcut-details">Session Library Shortcut:',(⎕ucs 10),'Details</a> below.</em></small></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><strong>`Q</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Quote</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`Q ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Recursively scans <code>⍵</code>, putting',(⎕ucs 10),'char. vectors, scalars, and rows of higher-dimensional strings in APL',(⎕ucs 10)
_,←'quotes, leaving other elements as is. If omitted,',(⎕ucs 10),'<code>⍺←''''''''</code>.</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`S</strong></td>'
_,←(⎕ucs 10),'<td style="text-align: center;">Serialise</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`S ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Serialise an <em>APL</em> array (via',(⎕ucs 10),'⎕SE.Dyalog.Array.Serialise), i.e.',(⎕ucs 160),'show in <em>APL</em> Array Notation',(⎕ucs 10)
_,←'(APLAN), either (<code>⍺=0</code>, the default) in <em>tabular</em>',(⎕ucs 10),'(multiline) form or (<code>⍺=1</code>) compactly with statement',(⎕ucs 10),'separators <code>',(⎕ucs 9671)
_,←'</code> in place of newlines. If omitted,',(⎕ucs 10),'<code>⍺←0</code>. <small><em>See details below.</em></small></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: justify;"><strong>`T</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Date-Time</td>',(⎕ucs 10),'<td style="text-align: center;"><code>[⍺]`T ⍵</code></td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">Displays timestamp(s) <code>⍵</code>',(⎕ucs 10),'according to date-time template <code>⍺</code>. <code>⍵</code> is one or',(⎕ucs 10)
_,←'more APL timestamps <code>⎕TS</code>. <code>⍺</code> is a date-time',(⎕ucs 10),'template in <code>1200⌶</code> format. If omitted,',(⎕ucs 10),'<code>⍺← ''%ISO%''</code>.</td>',(⎕ucs 10),'</tr>'
_,←(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`W</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Wrap</td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><code>[⍺]`W ⍵</code></td>',(⎕ucs 10),'<td style="text-align: justify;">Wraps the rows of simple arrays in ⍵ in',(⎕ucs 10)
_,←'decorators <code>0⊃2⍴⍺</code> (on the left) and <code>1⊃2⍴⍺</code> (on',(⎕ucs 10),'the right). If omitted, <code>⍺←''''''''</code>. <small><em>See details',(⎕ucs 10),'below.</em></small></td>'
_,←(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`⍵',(⎕ucs 119889 119889),'</strong>,',(⎕ucs 10),'<strong>',(⎕ucs 9081 119889 119889),'</strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Omega',(⎕ucs 10),'Shortcut<br>(<small>EXPLICIT</small>)</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 8212),'</td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">A shortcut of the form <code>`⍵',(⎕ucs 119889 119889),'</code>',(⎕ucs 10),'(or <code>',(⎕ucs 9081 119889 119889),'</code>), to access the <code>'
_,←(⎕ucs 119889 119889),'</code><strong>th</strong>',(⎕ucs 10),'element of <code>⍵</code>, <em>i.e.</em> <code>(⍵⊃⍨ ',(⎕ucs 119889 119889),'+⎕IO)</code>.',(⎕ucs 10)
_,←'<small><em>See details below.</em></small></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>`⍵</strong>,',(⎕ucs 10),'<strong>',(⎕ucs 9081)
_,←'</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Omega',(⎕ucs 10),'Shortcut<br>(<small>IMPLICIT</small>)</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 8212),'</td>',(⎕ucs 10)
_,←'<td style="text-align: justify;">A shortcut of the form <code>`⍵</code> (or',(⎕ucs 10),'<code>',(⎕ucs 9081),'</code>), to access the <strong><em>next</em></strong> element of',(⎕ucs 10)
_,←'<code>⍵</code>. <small><em>See details below.</em> <small></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: justify;"><strong>→</strong><br><strong>↓</strong>',(⎕ucs 10)
_,←'<em>or</em> <strong>%</strong></td>',(⎕ucs 10),'<td style="text-align: center;">Self-documenting <strong>Code</strong>',(⎕ucs 10),'Fields <small>(SDCFs)</small></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">',(⎕ucs 8212),'</td>',(⎕ucs 10),'<td style="text-align: justify;"><code>→</code> at end of',(⎕ucs 10)
_,←'<strong>Code</strong> field signals that the source code for the field',(⎕ucs 10),'appears <em>to the left of</em> its value. Surrounding blanks are',(⎕ucs 10)
_,←'significant.<br><code>↓</code> (<em>or,</em> <code>%</code>) at end of',(⎕ucs 10),'<strong>Code</strong> field signals that the source code for the field',(⎕ucs 10)
_,←'appears <em>above</em> its value. Surrounding blanks are',(⎕ucs 10),'significant.<br><small><em>See <a',(⎕ucs 10),'href="#self-documenting-code-fields-sdcfs">SDCFs</a> in',(⎕ucs 10)
_,←'<strong>Examples</strong> for details.</em></small></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</tbody>',(⎕ucs 10),'</table>',(⎕ucs 10),'<p><br></p>',(⎕ucs 10),'<h2 data-number="5.6"',(⎕ucs 10)
_,←'id="escape-sequences-text-fields-quoted-strings"><span',(⎕ucs 10),'class="header-section-number">5.6</span> Escape Sequences: Text Fields',(⎕ucs 10),'&amp; Quoted Strings</h2>',(⎕ucs 10)
_,←'<p><span class="margin-note">See <a',(⎕ucs 10),'href="#quoted-strings-in-code-fields">Quoted Strings in Code Fields</a>',(⎕ucs 10)
_,←'below on displaying quote characters like <code>"</code> in a string.',(⎕ucs 10),'</span> <strong>∆F</strong> <strong>Text</strong> fields and',(⎕ucs 10)
_,←'<strong>Quoted strings</strong> in <strong>Code</strong> fields may',(⎕ucs 10),'include a small number of escape sequences, beginning with the backtick',(⎕ucs 10)
_,←'<code>`</code>. Some sequences are valid in <strong>Text</strong> fields',(⎕ucs 10),'<em>only</em>, but not in Quoted strings:</p>',(⎕ucs 10)
_,←'<p><span class="margin-note"><br><br><br><br><br><strong>Quoted',(⎕ucs 10),'Strings</strong> appear <strong><em>only</em></strong> in',(⎕ucs 10),'<strong>Code</strong> fields. </span></p>'
_,←(⎕ucs 10),'<p><a id="table-escapes" class="scroll-target"></a></p>',(⎕ucs 10),'<table style="width:100%;">',(⎕ucs 10),'<caption>5e. <strong>Escape Sequences</strong></caption>',(⎕ucs 10)
_,←'<colgroup>',(⎕ucs 10),'<col style="width: 15%" />',(⎕ucs 10),'<col style="width: 17%" />',(⎕ucs 10),'<col style="width: 20%" />',(⎕ucs 10),'<col style="width: 46%" />',(⎕ucs 10),'</colgroup>'
_,←(⎕ucs 10),'<thead>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<th style="text-align: center;">Escape Sequence</th>',(⎕ucs 10),'<th style="text-align: center;">What It <br>Inserts</th>',(⎕ucs 10)
_,←'<th style="text-align: center;"><br> Description</th>',(⎕ucs 10),'<th style="text-align: center;"><br> Where</th>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</thead>',(⎕ucs 10),'<tbody>',(⎕ucs 10),'<tr>'
_,←(⎕ucs 10),'<td style="text-align: center;"><strong>`',(⎕ucs 9671),'</strong></td>',(⎕ucs 10),'<td style="text-align: center;"><em>new line</em></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">⎕UCS 13</td>',(⎕ucs 10),'<td style="text-align: center;">Text fields and Quoted Strings</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;"><strong>``</strong></td>',(⎕ucs 10),'<td style="text-align: center;">`</td>',(⎕ucs 10),'<td style="text-align: center;">backtick</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Text fields and Quoted Strings</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;"><strong>`{</strong></td>',(⎕ucs 10)
_,←'<td style="text-align: center;">{</td>',(⎕ucs 10),'<td style="text-align: center;">left brace</td>',(⎕ucs 10),'<td style="text-align: center;">Text fields only</td>',(⎕ucs 10),'</tr>',(⎕ucs 10)
_,←'<tr>',(⎕ucs 10),'<td style="text-align: center;"><strong>`}</strong></td>',(⎕ucs 10),'<td style="text-align: center;">}</td>',(⎕ucs 10),'<td style="text-align: center;">right brace</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Text fields only</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</tbody>',(⎕ucs 10),'</table>',(⎕ucs 10),'<p>Other instances of the backtick character in <strong>Text</strong>'
_,←(⎕ucs 10),'fields or <strong>Quoted strings</strong> in <strong>Code</strong>',(⎕ucs 10),'fields will be <span class="margin-note">Sometimes a backtick is just a',(⎕ucs 10),'back',(⎕ucs 173)
_,←'tick.</span> treated literally.</p>',(⎕ucs 10),'<h2 data-number="5.7" id="quoted-strings-in-code-fields"><span',(⎕ucs 10),'class="header-section-number">5.7</span> Quoted Strings in Code',(⎕ucs 10)
_,←'Fields</h2>',(⎕ucs 10),'<p>As mentioned in the introduction, <strong>Quoted strings</strong> in',(⎕ucs 10),'<strong>Code</strong> fields allow several delimiting quote styles:</p>',(⎕ucs 10),'<ul>'
_,←(⎕ucs 10),'<li><strong>double-quotes</strong><br>',(⎕ucs 10),'<code>∆F ''{"like ',(⎕ucs 171),'this',(⎕ucs 187),' one"}''</code> or',(⎕ucs 10),'<code>∆F ''{"like ''''this'''' one."}''</code>,</li>'
_,←(⎕ucs 10),'<li><strong>double angle quotation marks</strong>,<br>',(⎕ucs 10),'<code>∆F ''{',(⎕ucs 171),'like "this" or ''''this''''.',(⎕ucs 187),'}''</code>,<br />',(⎕ucs 10),'as well as</li>'
_,←(⎕ucs 10),'<li><em>APL</em>',(⎕ucs 8217),'s tried-and-true embedded',(⎕ucs 10),'<strong>single-quotes</strong>,<br>',(⎕ucs 10),'<code>∆F ''{''''shown like ''''''''this'''''''', "this" or '
_,←(⎕ucs 171),'this',(⎕ucs 187),'.''''}''</code>.</li>',(⎕ucs 10),'</ul>',(⎕ucs 10),'<p><span class="margin-note">Compare these',(⎕ucs 10),'examples:<br>',(⎕ucs 8195),'<strong>Invalid:</strong>'
_,←(⎕ucs 8194),'<span',(⎕ucs 10),'class="red"><strong>∆F',(⎕ucs 8194 8216 123 8220),'abc`',(⎕ucs 8221),'def',(⎕ucs 8221 125 8217),'</strong></span><br>',(⎕ucs 8195),'<strong>Valid:</strong>'
_,←(⎕ucs 8194),'<code>∆F ''{"abc""def"}''</code>',(⎕ucs 10),'</span> If you wish to include a traditional delimiting quote',(⎕ucs 10)
_,←'(<code>''</code> or <code>"</code>) or the closing quote of a quote pair',(⎕ucs 10),'(<code>',(⎕ucs 171),'</code>',(⎕ucs 8194),'<code>',(⎕ucs 187),'</code>) within the <strong>Quoted',(⎕ucs 10)
_,←'string</strong>, you must double it. You may <em>not</em> use an escape',(⎕ucs 10),'sequence (e.g.',(⎕ucs 160),'<code>`"</code>) for this purpose.</p>',(⎕ucs 10)
_,←'<p><a id="table-quote-characters" class="scroll-target"></a></p>',(⎕ucs 10),'<table>',(⎕ucs 10),'<caption>5f. <strong>Doubling Quote Character in Quoted',(⎕ucs 10),'String</strong></caption>'
_,←(⎕ucs 10),'<colgroup>',(⎕ucs 10),'<col style="width: 14%" />',(⎕ucs 10),'<col style="width: 51%" />',(⎕ucs 10),'<col style="width: 34%" />',(⎕ucs 10),'</colgroup>',(⎕ucs 10),'<thead>',(⎕ucs 10)
_,←'<tr>',(⎕ucs 10),'<th style="text-align: center;">Quote(s)</th>',(⎕ucs 10),'<th style="text-align: center;">Example</th>',(⎕ucs 10),'<th style="text-align: center;">Result</th>',(⎕ucs 10),'</tr>'
_,←(⎕ucs 10),'</thead>',(⎕ucs 10),'<tbody>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;"><code>"</code></td>',(⎕ucs 10),'<td',(⎕ucs 10)
_,←'style="text-align: center;"><code>∆F ''{"like ""this"" example"}''</code></td>',(⎕ucs 10),'<td style="text-align: center;"><code>like "this" example</code></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>'
_,←(⎕ucs 10),'<td style="text-align: center;"><code>''</code></td>',(⎕ucs 10),'<td',(⎕ucs 10),'style="text-align: center;"><code>∆F ''{''''like ''''''''this'''''''' example''''}''</code></td>'
_,←(⎕ucs 10),'<td style="text-align: center;"><code>like ''this'' example</code></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;"><code>',(⎕ucs 171 32 187)
_,←'</code></td>',(⎕ucs 10),'<td',(⎕ucs 10),'style="text-align: center;"><code>∆F ''{',(⎕ucs 171),'or ',(⎕ucs 171),'this',(⎕ucs 187 187),' one',(⎕ucs 187),'}''</code></td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><code>or ',(⎕ucs 171),'this',(⎕ucs 187),' one</code></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</tbody>',(⎕ucs 10),'</table>',(⎕ucs 10)
_,←'<p>Note that the opening quote <code>',(⎕ucs 171),'</code> is treated as an ordinary',(⎕ucs 10),'character within the string. The clumsiness of the standard single quote',(⎕ucs 10)
_,←'<code>''</code> examples is due to the fact that the single quote is the',(⎕ucs 10),'required delimiter for the outermost (<em>APL</em>-level) string.</p>',(⎕ucs 10)
_,←'<h2 data-number="5.8" id="omega-shortcut-expressions-details"><span',(⎕ucs 10),'class="header-section-number">5.8</span> Omega Shortcut Expressions:',(⎕ucs 10),'Details</h2>',(⎕ucs 10)
_,←'<ol start="3" type="1">',(⎕ucs 10),'<li>All <strong>Omega</strong> shortcut expressions in the',(⎕ucs 10),'<em>f',(⎕ucs 8209),'string</em> are evaluated left to right and are',(⎕ucs 10)
_,←'⎕IO-independent.</li>',(⎕ucs 10),'<li><strong>',(⎕ucs 9081),'</strong> is a synonym for <strong>`⍵</strong>. It is',(⎕ucs 10),'Unicode character <code>⎕UCS 9081</code>. Either glyph has a special'
_,←(⎕ucs 10),'meaning <em>only</em> within <strong>Code</strong> fields and outside',(⎕ucs 10),'<strong>Quoted strings</strong>.</li>',(⎕ucs 10),'<li><strong>`⍵',(⎕ucs 119889 119889)
_,←'</strong> or <strong>',(⎕ucs 9081 119889 119889),'</strong> is equivalent to the',(⎕ucs 10),'expression <code>(⍵⊃⍨dd+⎕IO)</code>. Here <strong>',(⎕ucs 119889 119889),'</strong> must be a',(⎕ucs 10)
_,←'<em>non-negative integer</em> with at least 1 digit.</li>',(⎕ucs 10),'<li><strong>`⍵</strong> or <strong>',(⎕ucs 9081),'</strong> (with',(⎕ucs 10)
_,←'<strong><em>no</em></strong> digits appended) is equivalent to',(⎕ucs 10),'<code>(⍵⊃⍨1+ii+⎕IO)</code>, where <em>ii</em> is the index of the most',(⎕ucs 10)
_,←'recent <strong>Omega</strong> expression (of either type) to its left in',(⎕ucs 10),'the <em>f-string</em>;if there is no such expression, <em>ii</em> is',(⎕ucs 10),'<code>1</code>.</li>',(⎕ucs 10)
_,←'<li>The <em>f',(⎕ucs 8209),'string</em> itself (the 0-th element of',(⎕ucs 10),'<strong>⍵</strong>) is always accessed as <code>`⍵0</code> or',(⎕ucs 10),'<code>',(⎕ucs 9081)
_,←'0</code>. It may only be accessed <em>explicitly.</em></li>',(⎕ucs 10),'<li>If an element of the dfn',(⎕ucs 8217),'s right argument <strong>⍵</strong> is',(⎕ucs 10)
_,←'accessed at runtime via any means, shortcut or traditional, that element',(⎕ucs 10),'<strong><em>must</em></strong> exist.</li>',(⎕ucs 10),'</ol>',(⎕ucs 10)
_,←'<h2 data-number="5.9" id="serialise-shortcut-expressions-details"><span',(⎕ucs 10),'class="header-section-number">5.9</span> <strong>Serialise</strong>',(⎕ucs 10)
_,←'Shortcut Expressions: Details</h2>',(⎕ucs 10),'<p>Serialise ( <code>`S</code>) uses Dyalog <em>APL</em>',(⎕ucs 8217),'s Array',(⎕ucs 10)
_,←'Notation (APLAN)<span class="margin-note"><strong>APLAN</strong>:',(⎕ucs 10),'<em>⎕SE.Dyalog.Array.Serialise</em>.</span> to display the object to its',(⎕ucs 10)
_,←'right. It is intended to have roughly the same behaviour as displaying',(⎕ucs 10),'an object with <code>]APLAN.output on</code>. (See Dyalog documentation',(⎕ucs 10),'for details).</p>',(⎕ucs 10)
_,←'<ol type="1">',(⎕ucs 10),'<li>Serialise displays objects of classes 2 and 9',(⎕ucs 8212),' data arrays and',(⎕ucs 10),'namespaces',(⎕ucs 8212),' in Array Notation, as long as they contain'
_,←(⎕ucs 10),'<strong><em>no</em></strong> functions or operators.</li>',(⎕ucs 10),'<li>If <code>⍵</code> <em>includes</em> a function or',(⎕ucs 10)
_,←'operator,<code>`S</code> will display <code>⍵</code>',(⎕ucs 10),'<em>unformatted</em>, rather than in APLAN format.</li>',(⎕ucs 10),'</ol>',(⎕ucs 10),'<div>',(⎕ucs 10)
_,←'<h2 data-number="5.10" id="wrap-shortcut-details"><span',(⎕ucs 10),'class="header-section-number">5.10</span> Wrap Shortcut: Details</h2>',(⎕ucs 10),'<ol type="1">',(⎕ucs 10)
_,←'<li>Syntax: <code>[⍺←''''''''] `W ⍵</code>.</li>',(⎕ucs 10),'<li>Let <code>L←0⊃2⍴⍺</code> and <code>R←1⊃2⍴⍺</code>.</li>',(⎕ucs 10),'<li>Wrap each row <code>X',(⎕ucs 8242)
_,←'</code> of the simple arrays <code>X</code> in',(⎕ucs 10),'<code>⍵</code> (or the entire array <code>X</code> if a simple vector or',(⎕ucs 10)
_,←'scalar) in decorators <code>L</code> and <code>R</code>:',(⎕ucs 10),'<code>L,(⍕X',(⎕ucs 8242),'),R</code>.</li>',(⎕ucs 10),'<li><code>⍵</code> is an array of any shape and depth.<code>L</code>and'
_,←(⎕ucs 10),'<code>R</code>are char. vectors or scalars or <code>⍬</code> (treated as',(⎕ucs 10),'<code>''''</code>).</li>',(⎕ucs 10)
_,←'<li>If there is one scalar or enclosed vector <code>⍺</code>, it is',(⎕ucs 10),'replicated <em>per (2) above</em>.</li>',(⎕ucs 10)
_,←'<li>By default,<code>⍺← ''''''''</code>,<em>i.e.</em> <em>APL</em> quotes',(⎕ucs 10),'will wrap the array ⍵, row by row, whether character, numeric or',(⎕ucs 10),'otherwise.</li>',(⎕ucs 10),'</ol>'
_,←(⎕ucs 10),'<h2 data-number="5.11" id="session-library-shortcut-details"><span',(⎕ucs 10),'class="header-section-number">5.11</span> Session Library Shortcut:',(⎕ucs 10),'Details</h2>',(⎕ucs 10)
_,←'<ol type="1">',(⎕ucs 10),'<li><p>If <span class="margin-note">The search <strong>path</strong>',(⎕ucs 10),'depends on settings. Here, we assume the default <code>auto</code>',(⎕ucs 10)
_,←'option and <code>]load</code>-time par',(⎕ucs 173 97 173),'meters. See <a',(⎕ucs 10),'href="#session-library-shortcut-parameters">Lib',(⎕ucs 173),'rary Parameters</a> and',(⎕ucs 10)
_,←'<a href="#session-library-shortcut-filetypes-of-source-files">File',(⎕ucs 173),'types',(⎕ucs 10),'of Lib',(⎕ucs 173),'rary Source Files</a> below.</span> an object <code>£.name</code>',(⎕ucs 10)
_,←'is referenced, but not yet defined in <code>£</code>, an attempt is',(⎕ucs 10),'made',(⎕ucs 8212),' during <strong>∆F</strong>',(⎕ucs 8217),'s left-to-right <em>scanning</em>',(⎕ucs 10),'phase'
_,←(⎕ucs 8212),' to copy it to <code>£</code> from (in order) directory',(⎕ucs 10),'<strong>./MyDyalogLib</strong>, workspace <strong>dfns</strong>, and the',(⎕ucs 10)
_,←'current directory <strong>./</strong>, <em>unless</em> it is being',(⎕ucs 10),'assigned (via a simple <code>←</code>) or has <span',(⎕ucs 10)
_,←'class="margin-note">Once a name is seen, no attempt will be made to load',(⎕ucs 10),'it.</span>already been seen in this <strong>∆F</strong> call. It will be',(⎕ucs 10)
_,←'available for the duration of the <em>APL</em> session.</p></li>',(⎕ucs 10),'<li><p>If a name is a <em>qualified</em> name, i.e.',(⎕ucs 160),'if it is of the form',(⎕ucs 10)
_,←'<code>£.nm1.nm2</code>, <code>£.nm1.nm2.nm3</code>, etc., then',(⎕ucs 10),'<strong>∆F</strong> attempts to load the name',(⎕ucs 10)
_,←'<strong><em>nm1</em></strong>, presumed to be a namespace (or a function',(⎕ucs 10),'returning a namespace). If a namespace, the <em>entire</em> namespace is',(⎕ucs 10)
_,←'loaded, not just the object specified.</p></li>',(⎕ucs 10),'<li><p>While objects of the form <code>£.name</code> will be',(⎕ucs 10)
_,←'automatically retrieved (if not defined), names in other <code>£</code>',(⎕ucs 10),'expressions, like <code>£.(name1 name2)</code> or',(⎕ucs 10)
_,←'<code>£.⎕NC "name3"</code>, will be ignored during the scanning',(⎕ucs 10),'phase;</p></li>',(⎕ucs 10),'<li><p>In the case of a simple assignment (<code>£.name←val</code>), the',(⎕ucs 10)
_,←'object assigned must be new or of an <em>APL</em> class compatible with',(⎕ucs 10),'its existing value, else a domain error will be signaled. Even if seen',(⎕ucs 10)
_,←'later in the scan, the object will be assumed to have been set by the',(⎕ucs 10),'user.</p></li>',(⎕ucs 10),'<li><p>Simple modified assignments of the form <code>£.name+←val</code>',(⎕ucs 10)
_,←'are allowed: the object <code>name</code> will be retrieved (if not',(⎕ucs 10),'present) before modification.</p></li>',(⎕ucs 10),'</ol>',(⎕ucs 10),'<h3 data-number="5.11.1"',(⎕ucs 10)
_,←'id="session-library-shortcut-filetypes-of-source-files"><span',(⎕ucs 10),'class="header-section-number">5.11.1</span> Session Library Shortcut:',(⎕ucs 10),'Filetypes of Source Files</h3>',(⎕ucs 10)
_,←'<p><span',(⎕ucs 10),'class="margin-note"><br><br><br><br><br><br><br><br><br><br><br><strong>apla:</strong>',(⎕ucs 10),'Encoded using <em>APL</em> Array Notation (Dyalog',(⎕ucs 10)
_,←'20).<br><br><br><strong>txt:</strong> Each line of file is converted to',(⎕ucs 10),'a Unicode char. vector.</span></p>',(⎕ucs 10),'<p><a id="table-library-filetypes" class="scroll-target"></a></p>'
_,←(⎕ucs 10),'<table>',(⎕ucs 10),'<caption>5g. <strong>Library Filetypes: Meaning</strong></caption>',(⎕ucs 10),'<colgroup>',(⎕ucs 10),'<col style="width: 16%" />',(⎕ucs 10)
_,←'<col style="width: 23%" />',(⎕ucs 10),'<col style="width: 16%" />',(⎕ucs 10),'<col style="width: 10%" />',(⎕ucs 10),'<col style="width: 14%" />',(⎕ucs 10),'<col style="width: 19%" />',(⎕ucs 10)
_,←'</colgroup>',(⎕ucs 10),'<thead>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<th style="text-align: center;"><br>Filetype</th>',(⎕ucs 10),'<th style="text-align: center;"><br>Action</th>',(⎕ucs 10)
_,←'<th style="text-align: center;"><em>APL</em> Class ⎕NC</th>',(⎕ucs 10),'<th style="text-align: center;">Key APL<br>Service</th>',(⎕ucs 10)
_,←'<th style="text-align: center;">Available<br>by Default?</th>',(⎕ucs 10),'<th style="text-align: center;">Type <br>Enforced?</th>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</thead>',(⎕ucs 10),'<tbody>'
_,←(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;">.aplf</td>',(⎕ucs 10),'<td style="text-align: center;">Fixes function</td>',(⎕ucs 10),'<td style="text-align: center;">3</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">⎕FIX</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'<small> FUTURE</small></td>'
_,←(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;">.aplo</td>',(⎕ucs 10),'<td style="text-align: center;">Fixes operator</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">4</td>',(⎕ucs 10),'<td style="text-align: center;">⎕FIX</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">',(⎕ucs 10004),'<small> FUTURE</small></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;">.apln</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Fixes ns script</td>',(⎕ucs 10),'<td style="text-align: center;">9</td>',(⎕ucs 10),'<td style="text-align: center;">⎕FIX</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'<small> FUTURE</small></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;">.apla</td>',(⎕ucs 10),'<td style="text-align: center;">Assigns array or ns<br>(array',(⎕ucs 10),'notation)</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">2, 9</td>',(⎕ucs 10),'<td style="text-align: center;"><em>assignment</em></td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;">.json</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Fixes ns from JSON5</td>',(⎕ucs 10),'<td style="text-align: center;">9</td>',(⎕ucs 10),'<td style="text-align: center;">⎕JSON</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;">.txt</td>',(⎕ucs 10),'<td style="text-align: center;">Assigns a char. vector</td>',(⎕ucs 10),'<td style="text-align: center;">2</td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><em>assignment</em></td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>'
_,←(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;">.aplv</td>',(⎕ucs 10),'<td style="text-align: center;">Assigns a char. vector</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">2</td>',(⎕ucs 10),'<td style="text-align: center;"><em>assignment</em></td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;">.aplvv</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">Assigns char. vector of vectors</td>',(⎕ucs 10),'<td style="text-align: center;">2</td>',(⎕ucs 10),'<td style="text-align: center;"><em>assignment</em></td>'
_,←(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;">.aplm</td>',(⎕ucs 10),'<td style="text-align: center;">Assigns char. matrix</td>',(⎕ucs 10),'<td style="text-align: center;">2</td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><em>assignment</em></td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>'
_,←(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10),'<td style="text-align: center;">.dyalog</td>',(⎕ucs 10),'<td style="text-align: center;">Fixes object</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">3, 4, 9</td>',(⎕ucs 10),'<td style="text-align: center;">⎕FIX</td>',(⎕ucs 10),'<td style="text-align: center;">',(⎕ucs 10004),'</td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><span class="red"><strong>',(⎕ucs 10008),'<small>',(⎕ucs 10),'NEVER</small></strong></span></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'<tr>',(⎕ucs 10)
_,←'<td style="text-align: center;">user-specified</td>',(⎕ucs 10),'<td style="text-align: center;">Fixes object</td>',(⎕ucs 10),'<td style="text-align: center;">3, 4, 9</td>',(⎕ucs 10)
_,←'<td style="text-align: center;">⎕FIX</td>',(⎕ucs 10),'<td style="text-align: center;"><span',(⎕ucs 10),'class="red"><strong>',(⎕ucs 10008),'</strong></span></td>',(⎕ucs 10)
_,←'<td style="text-align: center;"><span class="red"><strong>',(⎕ucs 10008),'<small>',(⎕ucs 10),'NEVER</small></strong></span></td>',(⎕ucs 10),'</tr>',(⎕ucs 10),'</tbody>',(⎕ucs 10),'</table>'
_,←(⎕ucs 10),'<h3 data-number="5.11.2" id="session-library-shortcut-parameters"><span',(⎕ucs 10),'class="header-section-number">5.11.2</span> Session Library Shortcut:',(⎕ucs 10),'Parameters</h3>'
_,←(⎕ucs 10),'<p>The <span class="margin-note">If the automatic search feature is',(⎕ucs 10),'enabled',(⎕ucs 8212),' the default',(⎕ucs 8212),', the <em>first</em> time each name is used there'
_,←(⎕ucs 10),'is the potential for substantial overhead in searching for, loading, and',(⎕ucs 10),'fixing it in the session library.</span> Session Library shortcut',(⎕ucs 10)
_,←'(<code>£</code> or <code>`L</code>) is deceptively simple, but the code',(⎕ucs 10),'to support it is a tad complex. The complex components run only when',(⎕ucs 10)
_,←'<strong>∆F</strong> is loaded. If the <strong>auto</strong> parameter is',(⎕ucs 10),'<code>1</code>, there is a modest performance impact at runtime. If',(⎕ucs 10)
_,←'<code>0</code>, the runtime impact of the feature is more modest',(⎕ucs 10),'still.</p>',(⎕ucs 10),'<p>To support the Session Library auto-load process, there are',(⎕ucs 10)
_,←'parameters that may <em>optionally</em> be tailored:</p>',(⎕ucs 10),'<ul>',(⎕ucs 10),'<li><strong>LIB_ACTIVE</strong>: A global variable set in',(⎕ucs 10),'FString.dyalog.',(⎕ucs 10),'<ul>'
_,←(⎕ucs 10),'<li>2: Load default and user parameters (default);</li>',(⎕ucs 10),'<li>1: Load default parameters ONLY;</li>',(⎕ucs 10),'<li>0: No autoload features should be available.</li>',(⎕ucs 10)
_,←'</ul></li>',(⎕ucs 10),'</ul>',(⎕ucs 10),'<p>In addition, there are user parameters settable in the file',(⎕ucs 10),'<strong>.∆F</strong> in the user',(⎕ucs 8217),'s home directory:</p>',(⎕ucs 10)
_,←'<ul>',(⎕ucs 10),'<li><strong>auto:</strong> allowing <strong>∆F</strong> to automatically',(⎕ucs 10),'load undefined objects of the form <code>£.obj</code> or',(⎕ucs 10)
_,←'<code>`L.obj</code> into the Session Library from workspaces or files on',(⎕ucs 10),'the search path;</li>',(⎕ucs 10),'<li><strong>verbose:</strong> providing limited information on',(⎕ucs 10)
_,←'parameters, object loading, <em>etc.</em>;</li>',(⎕ucs 10),'<li><strong>path:</strong> listing what directories to search for the',(⎕ucs 10),'object definitions;</li>',(⎕ucs 10)
_,←'<li><strong>prefix:</strong> literal character vectors to prefix to each',(⎕ucs 10),'file name during the object search;</li>',(⎕ucs 10)
_,←'<li><strong>suffix:</strong> <span class="margin-note">More details',(⎕ucs 10),'appear below.<br>Don',(⎕ucs 8217),'t forget the ',(⎕ucs 8216 46 8217),' prefix!</span>filetypes that',(⎕ucs 10)
_,←'indicate the types of objects in our ',(⎕ucs 8220),'library,',(⎕ucs 8221),' along with any expected',(⎕ucs 10),'conversions.</li>',(⎕ucs 10),'</ul>',(⎕ucs 10)
_,←'<p>The built-in <em>(default)</em> parameter file <span',(⎕ucs 10),'class="margin-note">Additional doc',(⎕ucs 173),'ument',(⎕ucs 173),'ation is need',(⎕ucs 173),'ed, should this go',(⎕ucs 10)
_,←'forward.</span> is documented <em>below</em>.</p>',(⎕ucs 10),'<details>',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'<em><span style="opacity:0.6;">Show/Hide</span> Default £ibrary'
_,←(⎕ucs 10),'Parameter File</em> <big><strong>.',(⎕ucs 8201),'∆F</strong></big>',(⎕ucs 10),'</summary>',(⎕ucs 10),'<p><a id="table-library-parameters" class="scroll-target"></a></p>',(⎕ucs 10)
_,←'<pre class="skip"><code>(',(⎕ucs 10),'  ⍝ Default (Internal) Library Parameter File  (in APL Array Notation) ',(⎕ucs 10),'  ⍝ Default file:           ∆F/∆FParmDefs.apla',(⎕ucs 10)
_,←'  ⍝ User parameter file:   ./.∆F (no filetype)  ',(⎕ucs 10),'  ⍝ Global settings that impact the two parameter files:',(⎕ucs 10),'  ⍝    LIB_ACTIVE, VERBOSE ',(⎕ucs 10),'  ⍝ LIB_ACTIVE: ',(⎕ucs 10)
_,←'  ⍝           Setting  Do we want to use the SESSION LIBRARY autoload feature?',(⎕ucs 10),'  ⍝ LIB_ACTIVE:  2     Yes. Load default and user parameters',(⎕ucs 10)
_,←'  ⍝              1     Yes. Load default parameters ONLY.',(⎕ucs 10),'  ⍝              0     No.  No autoload features should be available.',(⎕ucs 10)
_,←'  ⍝ VERBOSE: Compile-time and run-time verbosity flag',(⎕ucs 10),'  ⍝                ',(⎕ucs 10),'  ⍝ Items not to be (re)set by user may be omitted in user .∆F file.           ',(⎕ucs 10)
_,←'  ⍝ If (verbose: ⎕NULL), then VERBOSE [note 1] is used for verbose.',(⎕ucs 10),'  ⍝ If (prefix: ⎕NULL) or (prefix: ⍬), then (prefix: &#39;&#39; ',(⎕ucs 9671),')     ',(⎕ucs 10),'  ⍝ [note 1] '
_,←(⎕ucs 10),'   ',(⎕ucs 10),'  ⍝ Parameter auto:',(⎕ucs 10),'  ⍝   0: user must load own objects; nothing is automatic.                ',(⎕ucs 10)
_,←'  ⍝   1: dfns and files (if any) searched in sequence set by dfnsOrder.',(⎕ucs 10),'  ⍝      See path for directory search sequence. ',(⎕ucs 10)
_,←'  ⍝ If the user sets (auto: 0) as a ∆F option, then objects already loaded will',(⎕ucs 10),'  ⍝ be found and used normally, but no new objects will be autoloaded. New objects',(⎕ucs 10)
_,←'  ⍝ may be created explicitly (e.g. via &#39;obj&#39; ⎕CY &#39;ws&#39; or £.obj←val), as expected.',(⎕ucs 10),'  ⍝ Note: If (load: 0) or if there are no files or workspaces in the search path,'
_,←(⎕ucs 10),'  ⍝       auto is set to 0, since no objects will ever be found.                    ',(⎕ucs 10),'    auto: 1',(⎕ucs 10),'      ',(⎕ucs 10),'  ⍝ verbose: ',(⎕ucs 10)
_,←'  ⍝    If 0 (quiet), ',(⎕ucs 10),'  ⍝    If 1 (verbose).  ',(⎕ucs 10),'  ⍝    If ⎕NULL, value is set from VERBOSE (see above).',(⎕ucs 10),'    verbose: ⎕NULL  ',(⎕ucs 10)
_,←'                                                          ',(⎕ucs 10),'  ⍝ path: The file dirs and/or workspaces to search IN ORDER left to right:',(⎕ucs 10)
_,←'  ⍝    e.g. path: [ &#39;fd1&#39;, &#39;fd2&#39;, [&#39;ws1&#39;, &#39;wsdir/ws2&#39;], &#39;fd3&#39;, [&#39;ws3&#39;]]',(⎕ucs 10)
_,←'  ⍝    For a file directory, the item must be a simple char vector',(⎕ucs 10),'  ⍝        &#39;MyDyalogLib&#39;',(⎕ucs 10)
_,←'  ⍝    For workspaces, the item must be a vector of one or more char vectors',(⎕ucs 10),'  ⍝        (⊂&#39;dfns&#39;) or (⊂&#39;MyDyalogLib/mathfns&#39;) or (&#39;dfns&#39;, &#39;myDfns&#39;)'
_,←(⎕ucs 10),'  ⍝  To indicate we don&#39;t want to search ANY files, ',(⎕ucs 10),'  ⍝     best: (load: 0)',(⎕ucs 10),'  ⍝     ok:   (path: ⎕NULL)',(⎕ucs 10)
_,←'  ⍝           directory      workspace    directory',(⎕ucs 10),'    path:  ( &#39;MyDyalogLib&#39; ',(⎕ucs 9671),' (&#39;dfns&#39;',(⎕ucs 9671),')  ',(⎕ucs 9671),'  &#39;.&#39;     ',(⎕ucs 9671)
_,←' )  ',(⎕ucs 10),'                  ',(⎕ucs 10),'  ⍝ prefix: literal string to prefix to each name, when searching directories.',(⎕ucs 10),'  ⍝     Ignored for workspaces.',(⎕ucs 10)
_,←'  ⍝     Default is ⍬ or (equivalently) &#39;&#39;',(⎕ucs 10),'  ⍝     Example given name &#39;mydfn&#39; and (prefix: &#39;∆F_&#39; &#39;MyLib/&#39; ',(⎕ucs 9671),' suffix: ⊂&#39;.aplf&#39;)  '
_,←(⎕ucs 10),'  ⍝     ==&gt; (&#39;∆F_mydfn.aplf&#39;  &#39;MyLib/mydfn.aplf&#39;)   ',(⎕ucs 10),'    prefix: ⍬ ',(⎕ucs 10),'                              ',(⎕ucs 10)
_,←'  ⍝ suffix: at least one suffix is required for files to be checked.',(⎕ucs 10),'  ⍝ ∘  Note: Don&#39;t forget the &#39;.&#39;.',(⎕ucs 10)
_,←'  ⍝ ∘  Suffixes don&#39;t apply to workspaces. See documentation for definitions.',(⎕ucs 10),'  ⍝ ∘  By default, unknown filetypes are not enabled. ',(⎕ucs 10)
_,←'  ⍝    If they are enabled, they work the same as &#39;dyalog&#39;.',(⎕ucs 10),'  ⍝ ∘  If possible, place most used suffixes first.',(⎕ucs 10),'    suffix: (&#39;.aplf&#39; ',(⎕ucs 9671)
_,←' &#39;.apla&#39; ',(⎕ucs 9671),' &#39;.aplo&#39; ',(⎕ucs 9671),' &#39;.apln&#39; ',(⎕ucs 9671),' &#39;.json&#39;',(⎕ucs 9671),' &#39;.txt&#39; ',(⎕ucs 9671),'&#39;.dyalog&#39;)    ',(⎕ucs 10)
_,←'                  ',(⎕ucs 10),'  ⍝  Internal Runtime (hidden) Parameters (not shown). Do not modify or delete. ',(⎕ucs 10),'  ⍝     ⍙readParms,⍙fullPath                                          '
_,←(⎕ucs 10),')    </code></pre>',(⎕ucs 10),'</details>',(⎕ucs 10),'<hr />',(⎕ucs 10),'</div>',(⎕ucs 10),'</details>',(⎕ucs 10),'<div class="page-break">',(⎕ucs 10 10),'</div>',(⎕ucs 10)
_,←'<h1 data-number="6" id="appendices"><span',(⎕ucs 10),'class="header-section-number">6</span> Appendices</h1>',(⎕ucs 10),'<details>',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194)
_,←'<span style="opacity:0.6;">Show/Hide</span> <em>Appendices</em>',(⎕ucs 10),'</summary>',(⎕ucs 10),'<p><a id="inside-appendices" class="scroll-target"></a></p>',(⎕ucs 10)
_,←'<h2 data-number="6.1" id="appendix-i-underdocumented-features"><span',(⎕ucs 10),'class="header-section-number">6.1</span> Appendix I: Un(der)documented',(⎕ucs 10),'Features</h2>',(⎕ucs 10)
_,←'<h3 data-number="6.1.1" id="f-option-for-dfn-source-code"><span',(⎕ucs 10),'class="header-section-number">6.1.1</span> ∆F Option for Dfn Source',(⎕ucs 10),'Code</h3>',(⎕ucs 10)
_,←'<p>If the <a href="#f-option-details"><strong><em>dfn</em></strong>',(⎕ucs 10),'option</a> is <code>¯1</code>, <em>equivalently</em>',(⎕ucs 10)
_,←'<code>(dfn: ¯1)</code><span class="margin-note">In simple terms, this',(⎕ucs 10),'option returns the character representation of the <em>dfn</em> returned',(⎕ucs 10)
_,←'via the <strong><em>dfn</em></strong> option. </span>, then',(⎕ucs 10),'<strong>∆F</strong> returns a character vector that contains the source',(⎕ucs 10)
_,←'code for the <em>dfn</em> returned via <code>(dfn: 1)</code>. If',(⎕ucs 10),'<strong><em>verbose</em></strong> is also set, newlines from',(⎕ucs 10),'<code>`',(⎕ucs 9671)
_,←'</code> are shown as visible <code>',(⎕ucs 9252),'</code>. However, since this',(⎕ucs 10),'option <em>returns</em> the code string, the',(⎕ucs 10),'<strong><em>verbose</em></strong> option won'
_,←(⎕ucs 8217),'t also <em>display</em> the',(⎕ucs 10),'code string.</p>',(⎕ucs 10),'<h3 data-number="6.1.2" id="future-behaviours"><span',(⎕ucs 10)
_,←'class="header-section-number">6.1.2</span> Future Behaviours</h3>',(⎕ucs 10),'<p>There are three future behaviours of APL primitives optionally',(⎕ucs 10)
_,←'supported by <strong>∆F</strong>: an extension to circle diaeresis (⍥),',(⎕ucs 10),'the right shoe underscore (',(⎕ucs 8839),'), and the ellipsis (',(⎕ucs 8230),'). Each is available',(⎕ucs 10)
_,←'if included in the value of <span class="margin-note">See',(⎕ucs 10),'below</span>load-time parameter, <code>FUTURES</code>. By default,',(⎕ucs 10),'<code>FUTURES← ''⍥',(⎕ucs 8839 8230)
_,←'''</code>.</p>',(⎕ucs 10),'<h4 data-number="6.1.2.1"',(⎕ucs 10),'id="future-behaviour-of-circle-diaeresis-here-today"><span',(⎕ucs 10)
_,←'class="header-section-number">6.1.2.1</span> Future Behaviour of ⍥',(⎕ucs 10),'(Circle Diaeresis) Here Today</h4>',(⎕ucs 10),'<p>As a load-time option, <strong>∆F</strong> adds <span',(⎕ucs 10)
_,←'class="margin-note">See <strong>abrudz dyalog-apl-extended',(⎕ucs 10),'/CircleDiaeresis.dyalog</strong> on Github [retrieved',(⎕ucs 10),'2026-02-13].</span> Adám Brudzewsky',(⎕ucs 8217)
_,←'s <strong>Depth operator</strong>',(⎕ucs 10),'extension to circle diaeresis (⍥), which works similarly to rank (⍤),',(⎕ucs 10),'but selects array components based on depth rather than rank. If the'
_,←(⎕ucs 10),'value of the load-time parameter <span class="margin-note">See',(⎕ucs 10),'<code>FUTURES</code> global variable in ∆F/FString.dyalog.</span>',(⎕ucs 10)
_,←'<code>FUTURES</code> includes <code>''⍥''</code>, then this fun',(⎕ucs 10),'<em>future</em> feature will be recognized within code fields, without',(⎕ucs 10)
_,←'impacting other capabilities of <code>⍥</code>. For more information,',(⎕ucs 10),'see <a id="displayText" href="javascript:linkAlert();"><span',(⎕ucs 10)
_,←'class="linkNote">https://aplwiki.com/wiki/Depth_(operator)</span></a>.</p>',(⎕ucs 10),'<h4 data-number="6.1.2.2"',(⎕ucs 10),'id="future-behaviour-of-select-sane-indexing-here-today"><span'
_,←(⎕ucs 10),'class="header-section-number">6.1.2.2</span> Future Behaviour of ',(⎕ucs 8839 10),'(Select / Sane Indexing) Here Today</h4>',(⎕ucs 10)
_,←'<p>As a load-time option, <strong>∆F</strong> adds the ',(⎕ucs 8220),'future',(⎕ucs 8221 10),'<strong>Select</strong> function (also known as <strong>Sane',(⎕ucs 10)
_,←'indexing</strong>) if the value of the load-time parameter <span',(⎕ucs 10),'class="margin-note">See <code>FUTURES</code> global variable in',(⎕ucs 10)
_,←'∆F/FString.dyalog.</span> <code>FUTURES</code> includes',(⎕ucs 10),'<code>''⍥''</code>. For more information, see',(⎕ucs 10),'<a id="displayText" href="javascript:linkAlert();"><span',(⎕ucs 10)
_,←'class="linkNote">https://aplwiki.com/wiki/From</span></a>.</p>',(⎕ucs 10),'<h4 data-number="6.1.2.3"',(⎕ucs 10),'id="future-behaviour-of-ellipsis-range-function-here-today"><span',(⎕ucs 10)
_,←'class="header-section-number">6.1.2.3</span> Future Behaviour of ',(⎕ucs 8230 10),'(Ellipsis [',(⎕ucs 8220),'range',(⎕ucs 8221),' function]) Here Today</h4>',(⎕ucs 10)
_,←'<p>As a load-time option, <strong>∆F</strong> adds the ',(⎕ucs 8220),'future',(⎕ucs 8221 10),'<strong>Ellipsis</strong> function, which is a ',(⎕ucs 8220),'range',(⎕ucs 8221),' function similar'
_,←(⎕ucs 10),'<span class="margin-note">See <strong>abrudz</strong>',(⎕ucs 10),'dyalog-apl-extended on Github [retrieved 2026-02-13].</span> to function',(⎕ucs 10)
_,←'<strong>to</strong> in the <em>dfns</em> workspace, extended to handle',(⎕ucs 10),'characters as well as integers (see discussion at',(⎕ucs 10)
_,←'https://dfns.dyalog.com/n_to.htm). E.g. <code>''a'' ',(⎕ucs 8230),' ''j''</code> is the',(⎕ucs 10),'same as ',(⎕ucs 8216),'abcdefghij',(⎕ucs 8217),', just as <code>1 ',(⎕ucs 8230)
_,←' 10</code> is the same as `1 2 3',(⎕ucs 10),'4 5 6 7 8 9 10',(⎕ucs 8217),'. This is similar to Python',(⎕ucs 8217),'s range() function.</p>',(⎕ucs 10)
_,←'<h3 data-number="6.1.3" id="f-helps-secret-variant"><span',(⎕ucs 10),'class="header-section-number">6.1.3</span> ∆F Help',(⎕ucs 8217),'s Secret Variant</h3>',(⎕ucs 10)
_,←'<p><code>∆F⍨''help''</code> has a secret variant: <span',(⎕ucs 10),'class="margin-note"><em>synonym:</em>',(⎕ucs 10),'<code>∆F⍨''help-n''</code>.</span><code>∆F⍨''help-narrow''</code>. With this'
_,←(⎕ucs 10),'variant, the help session will start up in a narrower window',(⎕ucs 10),'<em>without</em> side notes. If the user widens the window, the side',(⎕ucs 10)
_,←'notes will appear, as in the default case: <span',(⎕ucs 10),'class="margin-note"><em>synonym:</em>',(⎕ucs 10),'<code>∆F⍨''help-wide''</code>.</span><code>∆F⍨''help''</code>.</p>',(⎕ucs 10)
_,←'<h3 data-number="6.1.4" id="fs-library-parameter-option-parms"><span',(⎕ucs 10),'class="header-section-number">6.1.4</span> ∆F',(⎕ucs 8217),'s Library Parameter',(⎕ucs 10),'Option: ',(⎕ucs 8216)
_,←'parms',(⎕ucs 8217),'</h3>',(⎕ucs 10),'<p>Normally, ∆F £ibrary parameters are established when',(⎕ucs 10),'<strong>∆F</strong> and associated libraries are loaded (<em>e.g.</em>',(⎕ucs 10)
_,←'via <code>]load ∆F -t=⎕SE</code>). After editing the parameter file',(⎕ucs 10),'<strong>./.∆F,</strong> you may wish to update the active parameters,',(⎕ucs 10)
_,←'while maintaining existing user £ibrary session objects, which would',(⎕ucs 10),'otherwise be lost during a <code>]load</code> operation. For such an',(⎕ucs 10),'update, use <strong>∆F</strong>'
_,←(⎕ucs 8217),'s <code>''parms''</code> option.</p>',(⎕ucs 10),'<p><code>∆F⍨ ''parms''</code> reads the user parameter file',(⎕ucs 10)
_,←'<strong>./.∆F,</strong> updates the <em>£ibrary</em> parameters,',(⎕ucs 10),'returning them in alphabetical order along with their values as a single',(⎕ucs 10)
_,←'character matrix. No current session objects are affected.</p>',(⎕ucs 10),'<h3 data-number="6.1.5" id="fs-library-parameter-option-globals"><span',(⎕ucs 10)
_,←'class="header-section-number">6.1.5</span> ∆F',(⎕ucs 8217),'s Library Parameter',(⎕ucs 10),'Option: ',(⎕ucs 8216),'globals',(⎕ucs 8217),'</h3>',(⎕ucs 10)
_,←'<p><strong>∆F</strong> has a number of load-time parameters (global',(⎕ucs 10),'variables) that set its runtime behaviour for all users. You can view',(⎕ucs 10)
_,←'these parameters using the call: <code>∆F⍨ ''globals''</code>. The',(⎕ucs 10),'parameters include:</p>',(⎕ucs 10),'<pre class="skip"><code>',(⎕ucs 10)
_,←'  TRAP_ERRORS      VERBOSE_RUNTIME      VERBOSE_LOADTIME  SIGNAL_LIB_ERRS',(⎕ucs 10),'  ESCAPE_CHAR      QUOTES_SUPPLEMENTAL  INLINE_DEF        HELP_HTML_FI   ',(⎕ucs 10)
_,←'  LIB_ACTIVE       LIB_PARM_FI          LIB_USER_FI       LIB_SRC_FI',(⎕ucs 10),'  OPTS_KW          OPTS_DEFval          OPTS_N',(⎕ucs 10)
_,←'  VERBOSE_RUNTIME  VERSION              FUTURES</code></pre>',(⎕ucs 10),'<p>The meaning of each parameter and appropriate values are currently',(⎕ucs 10)
_,←'documented solely within the <strong>∆F</strong> code itself.</p>',(⎕ucs 10),'<h2 data-number="6.2" id="appendix-ii-python-fstrings"><span',(⎕ucs 10)
_,←'class="header-section-number">6.2</span> Appendix II: Python',(⎕ucs 10 102 8209),'strings</h2>',(⎕ucs 10),'<p>For more information on Python f-strings, <em>see</em>:</p>',(⎕ucs 10),'<p>'
_,←(⎕ucs 8195),'<a id="displayText" href="javascript:linkAlert();"><span',(⎕ucs 10),'class="linkNote">https://docs.python.org/3/tutorial/inputoutput.html#formatted-string-literals</span></a>.</p>'
_,←(⎕ucs 10),'</details>',(⎕ucs 10),'<h1 data-number="7" id="index-of-topics"><span',(⎕ucs 10),'class="header-section-number">7</span> Index of Topics</h1>',(⎕ucs 10),'<details id="TOC">',(⎕ucs 10)
_,←'<!-- option: open  Set id="TOC" here only. -->',(⎕ucs 10),'<summary class="summary">',(⎕ucs 10 8194),'<span style="opacity:0.6;">Show/Hide</span> <em>Index</em>',(⎕ucs 10),'</summary>',(⎕ucs 10)
_,←'<p><a id="inside-index" class="scroll-target"></a></p>',(⎕ucs 10),'<p><span',(⎕ucs 10),'class="margin-note"><big><big>',(⎕ucs 8195),'<strong>KEY</strong></big><br><strong><big><span',(⎕ucs 10)
_,←'class="red"><strong><big>',(⎕ucs 9632),'</big> Major',(⎕ucs 10),'topic</strong></span></big><br><span class="green"><strong><big>',(⎕ucs 9632),'</big>',(⎕ucs 10)
_,←'Topic in table or figure</strong></span><br><big>',(⎕ucs 9632),'</big> Regular',(⎕ucs 10),'entry</strong></big></span></p>',(⎕ucs 10),'<div class="multi-column-text" style="font-size:85%;">'
_,←(⎕ucs 10),'<!-- INDEX_BEGIN -->',(⎕ucs 10),'<!-- Generated by ∆F_toc: 2025-12-31T14:15:45 -->',(⎕ucs 10),'<p><a href="#the-above-shortcut"                            > <strong>`A',(⎕ucs 10)
_,←'(above)</strong>',(⎕ucs 8195),'<big><span class="blue">4.12</span></big></a><br>',(⎕ucs 10),'<a href="#the-above-shortcut"                            > <strong>Above',(⎕ucs 10),'shortcut</strong>'
_,←(⎕ucs 8195),'<big><span class="blue">4.12</span></big></a><br>',(⎕ucs 10),'<a href="#inside-appendices"                             > <span',(⎕ucs 10)
_,←'class="red"><big><strong>Appendices</strong></big></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">6.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-serialise-shortcut"                        > <strong>Array',(⎕ucs 10),'notation, serialise</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.19</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#the-box-shortcut"                              > <strong>`B',(⎕ucs 10),'(box)</strong>',(⎕ucs 8195),'<big><span class="blue">4.5</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#box-mode"                                      > <strong>Box',(⎕ucs 10),'option</strong>',(⎕ucs 8195),'<big><span class="blue">4.6</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-box-shortcut"                              > <strong>Box',(⎕ucs 10),'shortcut</strong>',(⎕ucs 8195),'<big><span class="blue">4.5</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-shortcut-for-numeric-commas"               > <strong>`C',(⎕ucs 10),'(numeric commas)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.10</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#table-call-syntax"                             > <span',(⎕ucs 10),'class="green"><strong>Call syntax</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue"><small><em>Table</em></small> 5a.</span></big></a><br>',(⎕ucs 10),'<a href="#table-escapes"                                 > <span',(⎕ucs 10),'class="green"><strong>Code field escape'
_,←(⎕ucs 10),'sequences</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 5e.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#code-field-shortcuts"                          > <span',(⎕ucs 10),'class="red"><big><strong>Code field',(⎕ucs 10),'shortcuts</strong></big></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">5.5</span></big></a><br>',(⎕ucs 10),'<a href="#table-brief-shortcuts"                         > <span',(⎕ucs 10),'class="green"><strong>Code field shortcuts,',(⎕ucs 10)
_,←'brief</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 3d.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#table-shortcuts"                               > <span',(⎕ucs 10),'class="green"><strong>Code field shortcuts,',(⎕ucs 10),'details</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue"><small><em>Table</em></small> 5d.</span></big></a><br>',(⎕ucs 10),'<a href="#code-fields"                                   > <strong>Code',(⎕ucs 10),'fields</strong>',(⎕ucs 8195)
_,←'<big><span class="blue">4.1</span></big></a><br>',(⎕ucs 10),'<a href="#code-fields-continued"                         > <strong>Code',(⎕ucs 10),'fields (continued)</strong>',(⎕ucs 8195)
_,←'<big><span',(⎕ucs 10),'class="blue">4.4</span></big></a><br>',(⎕ucs 10),'<a href="#quoted-strings-in-code-fields"                 > <strong>Code',(⎕ucs 10),'fields, quoted strings in</strong>'
_,←(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.7</span></big></a><br>',(⎕ucs 10),'<a href="#the-shortcut-for-numeric-commas"               >',(⎕ucs 10)
_,←'<strong>Commas shortcut, numeric</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.10</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#a-shortcut-for-dates-and-times-part-ii"        > <strong>`D',(⎕ucs 10),'(date)</strong>',(⎕ucs 8195),'<big><span class="blue">4.17</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#a-shortcut-for-dates-and-times-part-ii"        > <strong>Date',(⎕ucs 10),'shortcut (alias)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.17</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#table-default-options"                         > <span',(⎕ucs 10),'class="green"><strong>Default options</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue"><small><em>Table</em></small> 5c.</span></big></a><br>',(⎕ucs 10),'<a href="#precomputed-fstrings-with-the-dfn-option"      > <strong>Dfn',(⎕ucs 10)
_,←'option, precomputed F-strings</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.22</span></big></a><br>',(⎕ucs 10),'<a href="#table-quote-characters"                        > <span'
_,←(⎕ucs 10),'class="green"><strong>Doubling quote',(⎕ucs 10),'characters</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 5f.</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#omega-shortcut-expressions-details"            >',(⎕ucs 10),'<strong>Escape omega, details</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.8</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#table-escapes"                                 > <span',(⎕ucs 10),'class="green"><strong>Escape sequences</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue"><small><em>Table</em></small> 5e.</span></big></a><br>',(⎕ucs 10),'<a href="#escape-sequences-text-fields-quoted-strings"   >',(⎕ucs 10)
_,←'<strong>Escape sequences in quoted strings</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.6</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#escape-sequences-text-fields-quoted-strings"   >',(⎕ucs 10),'<strong>Escape sequences in text fields</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.6</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#inside-examples"                               > <span',(⎕ucs 10),'class="red"><big><strong>Examples</strong></big></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">4.</span></big></a><br>',(⎕ucs 10),'<a href="#the-format-shortcut"                           > <strong>`F',(⎕ucs 10),'(format)</strong>',(⎕ucs 8195)
_,←'<big><span class="blue">4.9</span></big></a><br>',(⎕ucs 10),'<a href="#table-field-types"                             > <span',(⎕ucs 10),'class="green"><strong>Field types</strong></span>'
_,←(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 2a.</span></big></a><br>',(⎕ucs 10),'<a href="#table-library-parameters"                      > <span',(⎕ucs 10)
_,←'class="green"><strong>File, of library parameters',(⎕ucs 10),'(.∆F)</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Fig.</em></small> 4.21</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#table-library-filetypes"                       > <span',(⎕ucs 10),'class="green"><strong>Filetypes, library: see `L and',(⎕ucs 10),'£</strong></span>',(⎕ucs 8195)
_,←'<big><span class="blue"><small><em>Table</em></small>',(⎕ucs 10),'5g.</span></big></a><br>',(⎕ucs 10),'<a href="#the-format-shortcut"                           >',(⎕ucs 10)
_,←'<strong>Format shortcut</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.9</span></big></a><br>',(⎕ucs 10),'<a href="#referencing-the-fstring-itself"                >',(⎕ucs 10)
_,←'<strong>F-string, referencing</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.8</span></big></a><br>',(⎕ucs 10),'<a href="#intro"                                         >',(⎕ucs 10)
_,←'<strong>F-strings, definition</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">0.</span></big></a><br>',(⎕ucs 10),'<a href="#appendix-ii-python-fstrings"                   >',(⎕ucs 10)
_,←'<strong>F-strings, Python</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">6.2</span></big></a><br>',(⎕ucs 10),'<a href="#table-call-syntax"                             > <span',(⎕ucs 10)
_,←'class="green"><strong>∆F Call Syntax</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 5a.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#f-call-syntax-overview"                        > <strong>∆F',(⎕ucs 10),'call syntax overview</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.1</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#f-fstring-building-blocks"                     > <strong>∆F',(⎕ucs 10),'f-string building blocks</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.4</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#f-installation"                                > <strong>∆F',(⎕ucs 10),'installation</strong>',(⎕ucs 8195),'<big><span class="blue">1.1</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#loading-and-running-f"                         > <strong>∆F',(⎕ucs 10),'loading and running</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">1.2</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#f-option-details"                              > <strong>∆F',(⎕ucs 10),'option details</strong>',(⎕ucs 8195),'<big><span class="blue">5.2</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#inside-preparing"                              > <span',(⎕ucs 10),'class="red"><big><strong>∆F preparing to',(⎕ucs 10),'run</strong></big></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">1.</span></big></a><br>',(⎕ucs 10),'<a href="#inside-reference"                              > <span',(⎕ucs 10),'class="red"><big><strong>∆F reference',(⎕ucs 10)
_,←'section</strong></big></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.</span></big></a><br>',(⎕ucs 10),'<a href="#f-return-value"                                > <strong>∆F',(⎕ucs 10)
_,←'return values</strong>',(⎕ucs 8195),'<big><span class="blue">5.3</span></big></a><br>',(⎕ucs 10),'<a href="#displaying-f-help-in-apl"                      > <strong>Help,',(⎕ucs 10)
_,←'displaying in Apl</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">1.3</span></big></a><br>',(⎕ucs 10),'<a href="#self-documenting-code-fields-sdcfs"            >',(⎕ucs 10)
_,←'<strong>Horizontal SDCF (→)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.11</span></big></a><br>',(⎕ucs 10),'<a href="#f-installation"                                >',(⎕ucs 10)
_,←'<strong>Installing ∆F</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">1.1</span></big></a><br>',(⎕ucs 10),'<a href="#text-justification-shortcut"                   > <strong>`J'
_,←(⎕ucs 10),'(Justification)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.13</span></big></a><br>',(⎕ucs 10),'<a href="#text-justification-shortcut"                   >',(⎕ucs 10)
_,←'<strong>Justification shortcut</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.13</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-session-library-shortcut"                  > <strong>`L',(⎕ucs 10),'(library)</strong>',(⎕ucs 8195),'<big><span class="blue">4.21</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#table-library-filetypes"                       > <span',(⎕ucs 10),'class="green"><strong>Library Filetypes: see `L and',(⎕ucs 10),'£</strong></span>',(⎕ucs 8195)
_,←'<big><span class="blue"><small><em>Table</em></small>',(⎕ucs 10),'5g.</span></big></a><br>',(⎕ucs 10),'<a href="#table-library-parameters"                      > <span',(⎕ucs 10)
_,←'class="green"><strong>Library parameters, file of',(⎕ucs 10),'(.∆F)</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Fig.</em></small> 4.21</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#session-library-shortcut-details"              >',(⎕ucs 10),'<strong>Library shortcut, details</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">5.11</span></big></a><br>',(⎕ucs 10),'<a href="#the-session-library-shortcut"                  >',(⎕ucs 10),'<strong>Library shortcut, session</strong>',(⎕ucs 8195),'<big><span'
_,←(⎕ucs 10),'class="blue">4.21</span></big></a><br>',(⎕ucs 10),'<a href="#loading-and-running-f"                         >',(⎕ucs 10),'<strong>Loading ∆F</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">1.2</span></big></a><br>',(⎕ucs 10),'<a href="#multiline-f-strings-in-dyalog-20"              >',(⎕ucs 10),'<strong>Multiline f-strings, Dyalog 20</strong>',(⎕ucs 8195),'<big><span'
_,←(⎕ucs 10),'class="blue">4.23</span></big></a><br>',(⎕ucs 10),'<a href="#null-space-fields"                             > <strong>Null',(⎕ucs 10),'space fields</strong>',(⎕ucs 8195)
_,←'<big><span class="blue">4.3</span></big></a><br>',(⎕ucs 10),'<a href="#the-shortcut-for-numeric-commas"               >',(⎕ucs 10),'<strong>Numeric commas shortcut</strong>',(⎕ucs 8195)
_,←'<big><span',(⎕ucs 10),'class="blue">4.10</span></big></a><br>',(⎕ucs 10),'<a href="#omega-shortcut-expressions-details"            > <strong>Omega',(⎕ucs 10)
_,←'shortcut expressions, details</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.8</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#omega-shortcuts-explicit"                      > <strong>Omega',(⎕ucs 10),'shortcuts, explicit</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.7</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#omega-shortcuts-implicit"                      > <strong>Omega',(⎕ucs 10),'shortcuts, implicit</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">4.14</span></big></a><br>',(⎕ucs 10),'<a href="#omega-shortcut-expressions-details"            > <strong>Omega',(⎕ucs 10),'underscore (',(⎕ucs 9081),'), details</strong>',(⎕ucs 8195)
_,←'<big><span',(⎕ucs 10),'class="blue">5.8</span></big></a><br>',(⎕ucs 10),'<a href="#table-option-details"                          > <span',(⎕ucs 10)
_,←'class="green"><strong>Option details</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 5b.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#table-default-options"                         > <span',(⎕ucs 10),'class="green"><strong>Options, default</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue"><small><em>Table</em></small> 5c.</span></big></a><br>',(⎕ucs 10),'<a href="#inside-overview"                               > <span',(⎕ucs 10)
_,←'class="red"><big><strong>Overview</strong></big></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">2.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#precomputed-fstrings-with-the-dfn-option"      >',(⎕ucs 10),'<strong>Precomputed F',(⎕ucs 8209),'strings</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">4.22</span></big></a><br>',(⎕ucs 10),'<a href="#inside-preparing"                              > <span',(⎕ucs 10),'class="red"><big><strong>Preparing to run',(⎕ucs 10)
_,←'∆F</strong></big></span>',(⎕ucs 8195),'<big><span class="blue">1.</span></big></a><br>',(⎕ucs 10),'<a href="#appendix-ii-python-fstrings"                   >',(⎕ucs 10),'<strong>Python f'
_,←(⎕ucs 8209),'strings</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">6.2</span></big></a><br>',(⎕ucs 10),'<a href="#the-quote-shortcut"                            > <strong>`Q',(⎕ucs 10)
_,←'(quote)</strong>',(⎕ucs 8195),'<big><span class="blue">4.18</span></big></a><br>',(⎕ucs 10),'<a href="#inside-quick-start"                            > <span',(⎕ucs 10)
_,←'class="red"><big><strong>Quick start</strong></big></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">3.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#table-quote-characters"                        > <span',(⎕ucs 10),'class="green"><strong>Quote characters,',(⎕ucs 10),'doubling</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue"><small><em>Table</em></small> 5f.</span></big></a><br>',(⎕ucs 10),'<a href="#the-quote-shortcut"                            > <strong>Quote',(⎕ucs 10),'shortcut</strong>',(⎕ucs 8195)
_,←'<big><span class="blue">4.18</span></big></a><br>',(⎕ucs 10),'<a href="#table-quote-characters"                        > <span',(⎕ucs 10),'class="green"><strong>Quoted strings, doubling quote'
_,←(⎕ucs 10),'chars.</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 5f.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#escape-sequences-text-fields-quoted-strings"   >',(⎕ucs 10),'<strong>Quoted strings, escape sequences in</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">5.6</span></big></a><br>',(⎕ucs 10),'<a href="#quoted-strings-in-code-fields"                 >',(⎕ucs 10),'<strong>Quoted strings in code fields</strong>',(⎕ucs 8195),'<big><span'
_,←(⎕ucs 10),'class="blue">5.7</span></big></a><br>',(⎕ucs 10),'<a href="#loading-and-running-f"                         >',(⎕ucs 10),'<strong>Running ∆F</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">1.2</span></big></a><br>',(⎕ucs 10),'<a href="#the-serialise-shortcut"                        > <strong>`S',(⎕ucs 10),'(serialise)</strong>',(⎕ucs 8195)
_,←'<big><span class="blue">4.19</span></big></a><br>',(⎕ucs 10),'<a href="#self-documenting-code-fields-sdcfs"            >',(⎕ucs 10),'<strong>SDCFs: self-documenting code fields</strong>'
_,←(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.11</span></big></a><br>',(⎕ucs 10),'<a href="#self-documenting-code-fields-sdcfs"            >',(⎕ucs 10)
_,←'<strong>Self-documenting code fields (SDCFs)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.11</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-serialise-shortcut"                        >',(⎕ucs 10),'<strong>Serialise shortcut, array notation</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">4.19</span></big></a><br>',(⎕ucs 10),'<a href="#serialise-shortcut-expressions-details"        >',(⎕ucs 10),'<strong>Serialise shortcut, details</strong>',(⎕ucs 8195),'<big><span'
_,←(⎕ucs 10),'class="blue">5.9</span></big></a><br>',(⎕ucs 10),'<a href="#table-library-parameters"                      > <span',(⎕ucs 10),'class="green"><strong>Session library parameters, file'
_,←(⎕ucs 10),'(.∆F)</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Fig.</em></small> 4.21</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-session-library-shortcut"                  >',(⎕ucs 10),'<strong>Session library shortcut</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.21</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#session-library-shortcut-details"              >',(⎕ucs 10),'<strong>Session library shortcut, details</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">5.11</span></big></a><br>',(⎕ucs 10),'<a href="#code-field-shortcuts"                          > <span',(⎕ucs 10),'class="red"><big><strong>Shortcuts, all</strong></big></span>'
_,←(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.5</span></big></a><br>',(⎕ucs 10),'<a href="#table-brief-shortcuts"                         > <span',(⎕ucs 10)
_,←'class="green"><strong>Shortcuts, brief</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 3a.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#table-shortcuts"                               > <span',(⎕ucs 10),'class="green"><strong>Shortcuts, details</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue"><small><em>Table</em></small> 5d.</span></big></a><br>',(⎕ucs 10),'<a href="#shortcuts-with-apl-expressions"                >',(⎕ucs 10)
_,←'<strong>Shortcuts, with Apl expressions</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.15</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#text-fields-and-space-fields"                  > <strong>Space',(⎕ucs 10),'fields</strong>',(⎕ucs 8195),'<big><span class="blue">4.2</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#null-space-fields"                             > <strong>Space',(⎕ucs 10),'fields, null</strong>',(⎕ucs 8195),'<big><span class="blue">4.3</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#inside-reference"                              > <span',(⎕ucs 10),'class="red"><big><strong>Syntax (∆F',(⎕ucs 10),'reference)</strong></big></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">5.</span></big></a><br>',(⎕ucs 10),'<a href="#table-call-syntax"                             > <span',(⎕ucs 10),'class="green"><strong>Syntax, ∆F Call</strong></span>',(⎕ucs 8195)
_,←'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 5a.</span></big></a><br>',(⎕ucs 10),'<a href="#a-shortcut-for-dates-and-times-part-i"         > <strong>`T',(⎕ucs 10)
_,←'(time)</strong>',(⎕ucs 8195),'<big><span class="blue">4.16</span></big></a><br>',(⎕ucs 10),'<a href="#table-escapes"                                 > <span',(⎕ucs 10)
_,←'class="green"><strong>Text field escape',(⎕ucs 10),'sequences</strong></span>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue"><small><em>Table</em></small> 5e.</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#text-fields-and-space-fields"                  > <strong>Text',(⎕ucs 10),'fields</strong>',(⎕ucs 8195),'<big><span class="blue">4.2</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#escape-sequences-text-fields-quoted-strings"   > <strong>Text',(⎕ucs 10),'fields, escape sequences in</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.6</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#a-shortcut-for-dates-and-times-part-i"         > <strong>Time',(⎕ucs 10),'shortcut</strong>',(⎕ucs 8195),'<big><span class="blue">4.16</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#appendix-i-underdocumented-features"           >',(⎕ucs 10),'<strong>Underdocumented features</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">6.1</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#appendix-i-underdocumented-features"           >',(⎕ucs 10),'<strong>Undocumented features</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">6.1</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#self-documenting-code-fields-sdcfs"            >',(⎕ucs 10),'<strong>Vertical SDCF (↓ or %)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.11</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#the-wrap-shortcut"                             > <strong>`W',(⎕ucs 10),'(wrap)</strong>',(⎕ucs 8195),'<big><span class="blue">4.20</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-wrap-shortcut"                             > <strong>Wrap',(⎕ucs 10),'shortcut</strong>',(⎕ucs 8195),'<big><span class="blue">4.20</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#wrap-shortcut-details"                         > <strong>Wrap',(⎕ucs 10),'shortcut, details</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">5.10</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-format-shortcut"                           > <strong>$',(⎕ucs 10),'(format)</strong>',(⎕ucs 8195),'<big><span class="blue">4.9</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-above-shortcut"                            > <strong>%',(⎕ucs 10),'(above)</strong>',(⎕ucs 8195),'<big><span class="blue">4.12</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#self-documenting-code-fields-sdcfs"            > <strong>%',(⎕ucs 10),'(vertical SDCF)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.11</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#the-session-library-shortcut"                  > <strong>£',(⎕ucs 10),'(library)</strong>',(⎕ucs 8195),'<big><span class="blue">4.21</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#self-documenting-code-fields-sdcfs"            > <strong>→',(⎕ucs 10),'(horizontal SDCF)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.11</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#self-documenting-code-fields-sdcfs"            > <strong>↓',(⎕ucs 10),'(vertical SDCF)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.11</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#omega-shortcut-expressions-details"            > <strong>`⍵',(⎕ucs 10),'and ',(⎕ucs 9081),', details</strong>',(⎕ucs 8195),'<big><span class="blue">5.8</span></big></a><br>',(⎕ucs 10)
_,←'<a href="#omega-shortcuts-implicit"                      > <strong>`⍵, ',(⎕ucs 9081 10),'(omega, implicit)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.14</span></big></a><br>'
_,←(⎕ucs 10),'<a href="#omega-shortcuts-explicit"                      > <strong>`⍵',(⎕ucs 119889 119889 44 10 9081 119889 119889),' (omega, explicit)</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10)
_,←'class="blue">4.7</span></big></a><br>',(⎕ucs 10),'<a href="#omega-shortcuts-implicit"                      > <strong>',(⎕ucs 9081 10),'[<strong>⍵</strong>-underscore]: see <em>`⍵</em></strong>'
_,←(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.14</span></big></a><br>',(⎕ucs 10),'<a href="#omega-shortcuts-explicit"                      > <strong>',(⎕ucs 9081 119889 119889 10)
_,←'[<strong>⍵</strong>-underscore]: see `⍵',(⎕ucs 119889 119889),'</strong>',(⎕ucs 8195),'<big><span',(⎕ucs 10),'class="blue">4.7</span></big></a><br> <!-- INDEX_END --></p>',(⎕ucs 10),'</div>'
_,←(⎕ucs 10),'</details>',(⎕ucs 10),'<!-- Put a set of navigation tools at a fixed position at the bottom of the Help screen',(⎕ucs 10),'-->',(⎕ucs 10)
_,←'<div class="doc-footer" style="text-align: left;padding-left:60px;">',(⎕ucs 10),'<div class="button-container">',(⎕ucs 10)
_,←'<p><input type="button" value="Back" class="button happy-button" onclick="history.back()"/>',(⎕ucs 10),'<button id="toggleDetails" class="button happy-button" style="width: 130px;">Expand'
_,←(⎕ucs 10),'All</button>',(⎕ucs (4/160),10),'<input type="button" class="button normal-button" value="Top" onclick="window.location=''#top''"/>',(⎕ucs 10)
_,←'<input type="button" class="button normal-button" value="Quick Start" onclick="window.location=''#inside-quick-start''"/>',(⎕ucs 10)
_,←'<input type="button" class="button normal-button" value="Examples" onclick="window.location=''#inside-examples''"/>',(⎕ucs 10)
_,←'<input type="button" class="button normal-button" value="Reference" onclick="window.location=''#inside-reference''"/>',(⎕ucs 10),'<!-- ',(⎕ucs 10)
_,←' <input type="button" class="button normal-button" value="Appendices" onclick="window.location=''#appendices''"/> ',(⎕ucs 10),'-->',(⎕ucs 10)
_,←'<input type="button" class="button normal-button" value="Index" onclick="window.location=''#inside-index''"/>',(⎕ucs 10)
_,←'<input type="button" class="button normal-button" value="Bottom" onclick="window.location=''#index-of-topics''"/>',(⎕ucs (4/160),10)
_,←'<input type="button" class="button happy-button" value="Print" onclick="myPrint()">',(⎕ucs 10),'<button onclick="closeWindowNow()" class="button warn-button">Close',(⎕ucs 10),'Window</button></p>'
_,←(⎕ucs 10),'</div>',(⎕ucs 10),'</div>',(⎕ucs 10),'<hr />',(⎕ucs 10),'<p><br> <span id="copyright" style="font-family:cursive;"> Copyright',(⎕ucs 10),'<big>',(⎕ucs 169)
_,←'</big> 2026 Sam the Cat Foundation. [Version 0.1.3: 2026-01-20]',(⎕ucs 10),'</span> <br></p>',(⎕ucs 10),'</div>',(⎕ucs 10),'<p><!-- End div for right-margin-bar --></p>',(⎕ucs 10)
_,←'<!-- a hidden modal expression -->',(⎕ucs 10),'<div id="pAlertMsg" class="pAlertMsg">',(⎕ucs 10),'<p><span id="pAlertPfx" style="font-size: 40px;"> </span> <span',(⎕ucs 10),'id="pAlertText"'
_,←(⎕ucs 10),'style="font-weight: bold; font-size: 20px;font-family: Tahoma,  sans-serif;">',(⎕ucs 10),'</span></p>',(⎕ucs 10),'</div>',(⎕ucs 10),'<!-- (C) 2026 Sam the Cat Foundation -->',(⎕ucs 10)
_,←'</body>',(⎕ucs 10),'</html>',(⎕ucs 10)
helpHtml←_

lb←'{'

lb_rb←'{}'

libra←'£'

lp←'('

nl←(⎕ucs 13)

nlVis←(⎕ucs 9252)

om←'⍵'

omUs←(⎕ucs 9081)

om_omUs←(⎕ucs 9077 9081)

pct←'%'

qtsL←(⎕ucs 34 39 171 12300 187)

qtsR←(⎕ucs 34 39 187 12301 171)

ra←'→'

rb←'}'

rp←')'

rsu←(⎕ucs 8839)

scA2←(15⍴' ⎕SE.FString.A') '{⎕ML←1⋄⍺←⍬⋄⊃⍪/(⌈2÷⍨w-m)⌽¨f↑⍤1⍨¨m←⌈/w←⊃∘⌽⍤⍴¨f←⎕FMT¨⍺ ⍵⋄}' 'A'

scB2←(15⍴' ⎕SE.FString.B') '{⎕ML←1⋄d←|≡⍵⋄⍺←0⋄⍺⎕SE.Dyalog.Utils.disp⊂⍣(1≥d),⍣(0=d)⊢⍵⋄}' 'B'

_←⍬
_,←,⊂15⍴' ⎕SE.FString.C'
_,←,⊂'{⎕IO⎕ML←0 1⋄nd←≢def←3 '',''⋄⍺←def⋄Opt←⍕¨{⋄o←⍵⋄isN←(⎕D∊⍨⊃o)∨0=⊃0⍴o⋄isN:o,(def↑⍨-0⌈nd-≢o)⋄(def↑⍨0⌈nd-≢o),⌽o⋄}⋄Esc←{⍵≡⍥,''&'':''\&''⋄⍵/⍨1+''\''=⍵}⋄n s←Opt ⍺⋄src←''[.Ee]\d+'',⍥⊂''(?<=\d)(?=(\d{'',n,''})+([-¯.Ee]|(?=\s|$)))''⋄snk←''&'',⍥⊂''&'',⍨Esc s⋄w←src⎕R snk⍤1⍕⍵⋄⊃⍣(1=≢⍵)⊢w⋄}'
_,←,'C'
scC2←_

_←⍬
_,←,⊂15⍴' ⎕SE.FString.Ö'
_,←,⊂'{⍺←⊣⋄depths←⌽3⍴⌽⍵⍵⋄m l r←depths-⍨(|≡¨⍵ ⍺ ⍵)×depths≥0⋄max encl←''¨⊂''⍴¨⍨l(⌈,∘|-)r⋄el er←(1 0=l≤r)/¨⊂encl⋄0::⎕SIGNAL⎕EN⋄⍎''('',el,''⍺)⍺⍺'',max,er,''⍵''⋄}'
_,←,⊂,'Ö'
scCD2←_

_←⍬
_,←,⊂15⍴' ⎕SE.FString.Ë'
_,←,⊂'{⍺←⊢⋄⍺{⎕IO←0⋄Char←0 2∊⍨10|⎕DR⋄end←⊃⍵⋄tail←1↓⍵⋄charend←Char end⋄default←⎕UCS⍣charend⊢0⋄⍺←default⋄charbegins←Char¨¯2↑⍺⋄lead←-(2-charend)⌊(≢⍺)⌊+/charend=charbegins⋄head←lead↓⍺⋄begin←(¯1⌊lead)↑¯2↑default,lead↑⍺⋄charend:head,tail,⍨⎕UCS(⎕UCS begin)∇⎕UCS end⋄from step←-⍨\2↑begin,begin+×end-begin⋄head,tail,⍨from+step×⍳0⌈1+⌊(end-from)÷step+step=0⋄}⍤1⊢⍵}'
_,←,⊂,'Ë'
scEl2←_

scF2←2⍴⊂6⍴' ⎕FMT'

_←⍬
_,←,⊂15⍴' ⎕SE.FString.J'
_,←,⊂'{⎕PP←34⋄⍺←''L''⋄B←{+/∧\'' ''=⍵}⋄w⌽⍨(1⎕C ⍺){o←⊂⍺⋄o∊''L'' ¯1:B ⍵⋄o∊''R'' 1:-B⌽⍵⋄o∊''C'' 0:⌈0.5×⍵-⍥B⌽⍵⋄⎕SIGNAL⊂(''EN'' 11)(''Message'' ''Shortcut option (⍺) was invalid'')⋄}w←⎕FMT ⍵⋄}'
_,←,'J'
scJ2←_

scM2←(15⍴' ⎕SE.FString.M') '{⎕ML←1⋄⍺←⊢⋄⊃,/((⌈/≢¨)↑¨⊢)⎕FMT¨⍺ ⍵⋄}' 'M'

_←⍬
_,←,⊂15⍴' ⎕SE.FString.Q'
_,←,⊂'{⍺←''''''''⋄1<|≡⍵:⍺∘∇¨⍵⋄(0=⍴⍴⍵)∧1=≡⍵:⍵⋄(0≠≡⍵)∧326=⎕DR ⍵:⍺∘∇¨⍵⋄⎕ML←1⋄⍺{0=80|⎕DR ⍵:⍺,⍺,⍨⍵/⍨1+⍺=⍵⋄⍵}⍤1⊢⍵⋄}'
_,←,'Q'
scQ2←_

scS2←(15⍴' ⎕SE.FString.S') '{⎕ML←1⋄11 16 6::⍵⋄⍺←0⋄⋄1=≢s←⍺⎕SE.Dyalog.Array.Serialise ⍵:⊃s⋄⋄⍪s⋄}' 'S'

scSel2←2⍴⊂⎕ucs 40 8834 9051 9015 41

scT2←(15⍴' ⎕SE.FString.T') '{⎕ML←1⋄⍺←''%ISO%''⋄∊⍣(1=≡⍵)⊢⍺(1200⌶)⊢1⎕DT⊆⍵⋄}' 'T'

scW2←(15⍴' ⎕SE.FString.W') '{⎕ML←1⋄⍺←⎕UCS 39⋄1<|≡⍵:⍺∘∇¨⍵⋄L R←2⍴⍺⋄{L,R,⍨⍕⍵}⍤1⊢⍵⋄}' 'W'

scÐ2←(15⍴' ⎕SE.FString.Ð') '0∘⎕SE.Dyalog.Utils.disp¯1∘↓' 'Ð'

selCodeStr←(⎕ucs 40 8834 9051 9015 41)

selfDoc←'→↓%'

sp←' '

sp_sq←' '''

sq←''''

tfBrkList←'`{'

êBr←⊂('EN' 11) ('Message' 'Unpaired brace "{"')

êCfLogic←⊂('EN' 11) ('Message' 'A logic error has occurred processing a code field')

êHelpFi←⊂('EN' 22) ('Message' (('Help file "∆F/Help.html" not found in current directory (CD)',(⎕ucs 13),'                 CD: "/Users/petermsiegel/MyDyalogLibrary/pmsLibrary/src/"')))

êOpt←⊂('EN' 11) ('Message' 'Invalid option(s) in left argument. For help: ∆F⍨''help''')

êQt←⊂('EN' 11) ('Message' 'Unpaired quote in code field')

∆THIS←'⎕SE.FString'

⎕ex '_'

⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

A←{
      ⎕ML←1 ⋄ ⍺←⍬
      ⊃⍪/(⌈2÷⍨w-m)⌽¨f↑⍤1⍨¨m←⌈/w←⊃∘⌽⍤⍴¨f←⎕FMT¨⍺ ⍵
    }

AplQt←''''∘'⊣' ',' ('⊣' ',⍨' ('⊢' ('⊢⍤/' '⍨') (1 '+' '=')))

B←{
      ⎕ML←1 ⋄ d←|≡⍵ ⋄ ⍺←0
      ⍺ ⎕SE.Dyalog.Utils.disp⊂⍣(1≥d),⍣(0=d)⊢⍵
    }

C←{
      ⎕IO ⎕ML←0 1 ⋄ nd←≢def←3 ',' ⋄ ⍺←def
      Opt←⍕¨{
        o←⍵ ⋄ isN←(⎕D∊⍨⊃o)∨0=⊃0⍴o
        isN:o,(def↑⍨-0⌈nd-≢o) ⋄ (def↑⍨0⌈nd-≢o),⌽o
      }
      Esc←{⍵≡⍥,'&':'\&' ⋄ ⍵/⍨1+'\'=⍵}
      n s←Opt ⍺
      src←'[.Ee]\d+',⍥⊂'(?<=\d)(?=(\d{',n,'})+([-¯.Ee]|(?=\s|$)))'
      snk←'&',⍥⊂'&',⍨Esc s
      w←src ⎕R snk⍤1⍕⍵
      ⊃⍣(1=≢⍵)⊢w
    }

CFBrk←'⌊/' ('⍳' '∘' ('"`{}$',(⎕ucs 9081),'→↓%£''',(⎕ucs 171 12300 187 9061 8839 8230)))

CFDfn←'{∘,' (',' '∘' '}⍵')

CFEsc←{
    0=≢⍵:esc
      c w←(0⌷⍵)(1↓⍵) ⋄ ⍺.cfL+←1
    c∊om_omUs:⍺ CFOm w
    c='L':(⍺ libUtils.LibAuto w)w
      p←sc.Map c
    sc.nEsc>p:(⍺.inline p⊃sc.tbl)w
    c∊⍥⎕C ⎕A:⎕SIGNAL êScBad c
      ⎕SIGNAL êEsc c
  }

CFOm←{
      oLen oVal w←IntOpt ⍵
  ×oLen:('(⍵⊃⍨',')',⍨'⎕IO+',⍕⍺.omC←oVal)w⊣⍺.cfL+←oLen
         ('(⍵⊃⍨',')',⍨'⎕IO+',⍕⍺.omC)w⊣⍺.omC+←1
  }

CFQS←{ûsr←⍺ ⋄ qtL w←⍵
      qtR←(qtsL⍳qtL)⌷qtsR
      CFSBrk←⌊/⍳∘(esc qtR)
      Scan←{
          a lW←⍺
        0=≢⍵:⍺
          p←CFSBrk ⍵
        p=≢⍵:⎕SIGNAL êQt
          c c2←2↑p↓⍵
        c=esc:(a,(p↑⍵),map)lW ∇ ⍵↓⍨lW+←p+skip⊣map skip←ûsr.nl CFQSEsc c2 qtR
        c2=qtR:(a,⍵↑⍨p+1)lW ∇ ⍵↓⍨lW+←p+2
          (AplQt a,p↑⍵)(lW+p)
      }
      qS lW←'' 1 Scan w
      qS(w↓⍨ûsr.cfL+←lW)
  }

CFQSEsc←{c2 qtR←⍵
    c2∊dia2:⍺ 2
    c2=qtR:esc 1
    c2=esc:c2 2
       (esc,c2)2
  }

F←(,⊂'⎕FMT')

∇    ok←Initialise;fn_ns;Add2Path
    :Trap ok←0
        :If APL_VERSION<20
            ⎕←↑1⍴⊂'❌❌❌ This version of ∆F requires Dyalog 20 or later'
            ⎕SIGNAL 911
        :EndIf
        fn_ns←⎕THIS
        :If ADD_∆F_TO_PATH
            Add2Path←{
              R←('(\s|^)',⍵,'(\s|$)')⎕R' '
              ⍵,' ',R⊣⍺
            }⍥('⎕se' '\s+'⎕R'\u&' ' '⍠1)∘⍕
            ⎕PATH←⎕PATH Add2Path fn_ns
        :EndIf
        0 1 ⎕EXPORT¨(⎕NL ¯3 ¯4)(⊂'∆F')
        sc←LoadShortcutCalls
        LoadHelp HELP_HTML_FI
        LIB_ACTIVE←LoadLibAuto LIB_SRC_FI LIB_ACTIVE KEEP_SRC_CM
        ShowGlobalsIf VERBOSE_RUNTIME
    :Else
        ⎕←↑⎕DMX.DM ⋄ ⎕←'Stack: ' ⋄ ⎕←4{⍺≥≢⍵:'   ',⍵ ⋄ ⍺ ∇ ⍺↓⍵⊣⎕←'   ',⍺↑⍵}⎕XSI
        ⎕←↑1⍴⊂'❌❌❌ ∆F Initialisation has failed!'
    :EndTrap
∇

IntOpt←{
    wid←+/∧\⍵∊⎕D
    wid(⊃⊃⌽⎕VFI wid↑⍵)(wid↓⍵)
  }

J←{
        ⎕PP←34 ⋄ ⍺←'L' ⋄ B←{+/∧\' '=⍵}
        w⌽⍨(1 ⎕C ⍺){o←⊂⍺
          o∊'L' ¯1:B ⍵
          o∊'R' 1:-B⌽⍵
          o∊'C' 0:⌈0.5×⍵-⍥B⌽⍵
          ⎕SIGNAL⊂('EN' 11)('Message' 'Shortcut option (⍺) was invalid')
        }w←⎕FMT ⍵
    }

∇    {ok}←LoadHelp hfi;e1;e2
    :Trap 22
        ⎕THIS.helpHtml←⊃⎕NGET hfi
        :If VERBOSE_LOADTIME ⋄ ⎕←'✅✅✅ Loaded Help Html File "',hfi,'"' ⋄ :EndIf
        ok←1
    :Else
        e1←'❗❗❗ WARNING: When loading ∆Fapl, the help file "',hfi,'" was not found in current directory.'
        e2←'❗❗❗ WARNING: ∆F help will not be available without user intervention.'
        e1,(⎕UCS 13),e2
        ok←0
    :EndTrap
∇

∇    {libActive}←LoadLibAuto(libFi libActive keepCm)
    ;how
    how←' from "',libFi,'" into "','"',⍨∆THIS
    :If libActive=0
        ⎕←↑1⍴⊂'❗❗❗ WARNING: Library autoload services were not loaded',how
        ⎕←'✅✅✅ LIB_ACTIVE is set to ',(⍕libActive),' in ∆F/FString.dyalog'
        ⎕←'✅✅✅ £ and `L shortcuts are available without them, as if (auto: 0) is set.'
        :Return
    :EndIf
    :Trap 22
        ⎕FIX⍠'FixWithErrors' 0⊣⎕SE.∆F⍙Share.library
        :If VERBOSE_LOADTIME
            ⎕←'✅✅✅ Loaded services for Library shortcut (£)',how
        :EndIf
    :Else
        libActive←0
        ⎕←↑1⍴⊂'❗❗❗ WARNING: Unable to load Library autoload services',how
        ⎕←'✅✅✅ £ and `L shortcuts are available without autoload (auto: 0).'
    :EndTrap
∇

∇    {sc}←LoadShortcutCalls
  ;cdFut;elFut;rsuFut;g;grps;scEscCodes;_
  ;CPublish;Fn2Inline;In
    CPublish←{
        ⍺←1 ⋄ alt(nm char)←⍺ ⍵
      0≡alt:2⍴char
        (' ',' ',⍨∆THIS,'.',nm)(alt Fn2Inline nm)nm
    }
    Fn2Inline←{
      0≠⊃0⍴⍺:⍺
        s←61 ⎕ATX ⍵
        b←(⊂f↓⍨2+'←'⍳⍨f←⊃s),1↓s
        src snk←↓⍉↑(
          ('''[^'']*''' '\0')
          ('\h*⍝.*' '')
          ('^\h+|\h+$' '')
          ('\h*([←⋄⎕{}()]+)\h*' '\1')
        )
        ib←src ⎕R snk⍠('Mode' 'M')⊣b
      1=≢ib:⊃ib
        '{',1↓¯1↓∊'⋄',⍨¨ib
    }
    cdFut elFut rsuFut←cd el rsu{(⍺∊FUTURES)∧0≠≢⍵}cdNm elNm'dummy'
    grps←(
      cdFut'CircleDiaeresis (⍥) Depth-Extension'
      elFut'Ellipsis (…) Extension of dfns ¨to¨'
      rsuFut'Right-Shoe Underscore (⊇) Select/Sane Indexing'
    )
    :For g :In grps
       :If VERBOSE_LOADTIME
          _←'❌❌❌' '✅✅✅'⊃⍨⊃g
          ⎕←_,' Future feature',(' not ' ' '⊃⍨⊃g),'available: ',⊃⌽g
       :EndIf
    :EndFor
  scA2 scB2 scC2 scJ2 scM2 scQ2 scS2 scT2 scW2←CPublish¨'ABCJMQSTW'
  scÐ2←'0∘⎕SE.Dyalog.Utils.disp¯1∘↓'CPublish'Ð'
  scF2←2⍴⊂' ⎕FMT '
  scCD2 scEl2←cdFut elFut CPublish¨(cdNm cd)(elNm el)
  scSel2←2⍴⊂rsu selCodeStr⊃⍨rsuFut
  sc←(
     tbl:↓⍉↑scA2 scB2 scC2 scT2 scF2 scJ2 scQ2 scS2 scT2 scW2 scÐ2 scM2 scCD2 scEl2 scSel2
     nEsc:≢scEscCodes←'ABCDFJQSTW'
  )
  sc.Map←scEscCodes∘⍳
∇

M←{
      ⎕ML←1
      ⍺←⊢ ⋄ ⊃,/((⌈/≢¨)↑¨⊢)⎕FMT¨⍺ ⍵
    }

OrderFlds←'⌽' ',' ('∊∘⌽' ',∘⍬')

Q←{
      ⍺←''''
      1<|≡⍵:⍺∘∇¨⍵
      (0=⍴⍴⍵)∧1=≡⍵:⍵
      (0≠≡⍵)∧326=⎕DR ⍵:⍺∘∇¨⍵
      ⎕ML←1
      ⍺{0=80|⎕DR ⍵:⍺,⍺,⍨⍵/⍨1+⍺=⍵ ⋄ ⍵}⍤1⊢⍵
    }

S←{
      ⎕ML←1 ⋄ 11 16 6::⍵ ⋄ ⍺←0 ⋄
      1=≢s←⍺ ⎕SE.Dyalog.Array.Serialise ⍵:⊃s ⋄
      ⍪s
    }

SFCode←('(' ',' ('⊢' '⊢' (',' '∘' '⍴'''')'))) '⍕'

ScanFStr←{
    ScanAll←{
        p←TFBrk ⍵
      p=≢⍵:ûsr TFProc ⍺,⍵
        pfx←p↑⍵ ⋄ c←p⌷⍵ ⋄ w←(p+1)↓⍵
      c=esc:(⍺,pfx,ûsr.nl TFEsc w)∇ 1↓w
        _←ûsr TFProc ⍺,pfx
        ûsr.cfBeg←w
      rb=⊃w:''∇ 1↓w
        nSp←w↓⍨←+/∧\' '=w
      rb=⊃w:''∇ 1↓w⊣ûsr.flds,←⊂SFCode nSp
        a w←''ScanCF w⊣ûsr.(cfL brC)←nSp 1
        ûsr.flds,←⊂lp,a,rp
        ''∇ w
    }
    ScanCF←{
        ûsr.cfL+←1+p←CFBrk ⍵
      p=≢⍵:⎕SIGNAL êBr
        pfx←⍺,p↑⍵
        c←p⌷⍵
        w←(p+1)↓⍵
     (c=rb)∧ûsr.brC≤1:(CFDfn pfx)w
      c∊lb_rb:(pfx,c)∇ w⊣ûsr.brC+←-/c=lb_rb
      c∊qtsL:(pfx,a)∇ w⊣a w←ûsr CFQS c w
      c=dol:(pfx,scF)∇ w
      c=esc:(pfx,a)∇ w⊣a w←ûsr CFEsc w
      c=omUs:(pfx,a)∇ w⊣a w←ûsr CFOm w
      c=libra:(pfx,ûsr libUtils.LibAuto w)∇ w
      c∊FUTURES:w ∇⍨pfx,scCD scEl scSel c⊃⍨cd el rsu⍳c
      ~c∊selfDoc:⎕SIGNAL êCfLogic
      ûsr.brC>1:w ∇⍨pfx,c scA⊃⍨c=pct
        p←+/∧\' '=w
      rb≠⊃p↓w:w ∇⍨pfx,c scA⊃⍨c=pct
        cfLit←AplQt ûsr.cfBeg↑⍨ûsr.cfL+p
        fmtr←scA scM⊃⍨c='→'
        (cfLit,fmtr,CFDfn pfx)((p+1)↓w)
    }
    ûsr←⍺
  0∊ûsr.(verbose box auto inline(|dfn))∊0 1:⎕SIGNAL êOpt
    scA scCD scEl scÐ scF scM scSel←ûsr.inline⊃¨(
      scA2 ⋄ scCD2 ⋄ scEl2 ⋄ scÐ2 ⋄ scF2 ⋄ scM2 ⋄ scSel2
    )
    ûsr.acache←⍬
    ûsr.nl←ûsr.verbose⊃nl nlVis
    ûsr.flds←⍬
    ûsr.omC←0
    ûsr.auto∧←libUtils.pârms.auto
    flds←''ScanAll⊢fstr←∊⍵
    VMsg←(⎕∘←)⍣(ûsr.(verbose∧¯1≠dfn))
  0=≢flds:VMsg'(1 0⍴⍬)','⍨'/⍨ûsr.dfn≠0
    code←CFDfn(ûsr.box⊃scM scÐ),OrderFlds flds
  0=ûsr.dfn:VMsg code
    fstrQ←',⍨⊂',AplQt fstr
    VMsg lb,code,fstrQ,rb
  }

ShowAll←{
      ⎕←'Symbols:'
      ⎕←ShowSymbols ⍬
      ⎕←'Globals:'
      ⎕←ShowGlobalsIf 1
      ⎕←'(Library) Parms:'
      ⎕←'  ',,libUtils.LoadParms(verbose:1 ⋄ compact:1 ⋄ runtime:1)
      ⎕←'(Library) Path:'
      ⎕←'  ',libUtils.ShowPath ⍬
    1:_←⍬
  }

ShowGlobalsIf←{S←1∘⎕SE.Dyalog.Array.Serialise
    ~⍵:_←1 0⍴0
      vv←{9=⎕NC'⍵':⊂⍕⍵ ⋄ S ⍵}¨⎕VGET gg←⊂∘⍋⍛⌷⍨GLOBALS
      _←{((gg⍳⊂⍵)⊃vv)←⊂S ⎕VGET ⍵}'QUOTE_STYLES'
    1:_←↑'(',')',⍨vv{∊'  ',⍵,' ',⍺}¨(1+⌈/≢¨gg)↑¨gg,¨':'
  }

ShowSymbols←{
    ↑(
      ('  Special: "⍹£`"       ⍝ ⍹:omega-underscore, £:libra(ry), `:escape')
      ('  Futures: "',FUTURES,'"')
    )
  }

Special←{
    val←⎕C⍕⍵
    2≠⎕NC'val':⎕SIGNAL êOpt
    'parms-c'≡val:_←libUtils.LoadParms(verbose:1 ⋄ compact:1 ⋄ runtime:1)
    'parms'≡5↑val:_←libUtils.LoadParms(verbose:1 ⋄ compact:0 ⋄ runtime:1)
    'path'≡val:_←libUtils.ShowPath ⍬
    'glo'≡3↑val:_←ShowGlobalsIf 1
    'sym'≡3↑val:_←ShowSymbols ⍬
    '*'≡val:_←ShowAll ⍬
    'help'≢4↑val:⎕SIGNAL êOpt
      CLoadHtml←{
        22::⎕SIGNAL êHelpFi
        0=⎕NC ⍵:⊢⎕THIS.helpHtml←⊃⎕NGET HELP_HTML_FI
          ⎕THIS.helpHtml
      }
      RenderHtml←{
        0::16 ⎕SIGNAL⍨'NONCE ERROR: No renderer available to display HELP information'
        0::⍬⊣3500⌶⍺
          ⍬⊣'htmlObj'⎕WC'HTMLRenderer',⍥⊆⍵
      }
      html←CLoadHtml'helpHtml'
      s←(900 1000)(900 1350)⊃⍨~'-n'(1∘∊⍷)val
      obj←('HTML'html)(s,⍨⊂'Size')(15 35,⍨⊂'Posn')('Coord' 'ScaledPixel')
      1 0⍴⍬⊣html RenderHtml obj
  }

T←{
      ⎕ML←1 ⋄ ⍺←'%ISO%'
      ∊⍣(1=≡⍵)⊢⍺(1200⌶)⊢1 ⎕DT⊆⍵
    }

TFBrk←'⌊/' ('⍳' '∘' '`{')

TFEsc←{0=≢⍵:esc ⋄ c←0⌷⍵ ⋄ c∊dia2:⍺ ⋄ c∊esc_lb_rb:c ⋄ esc,c}

TFProc←{0=≢⍵:⍺.flds ⋄ ⍺.flds,←⊂sp_sq,sq,⍨⍵/⍨1+sq=⍵ ⋄ ⍺.flds}

TrimR←'⊢' '↓⍨' ('-' '∘' ('⊥⍨' ' =⊢'))

W←{
      ⎕ML←1 ⋄ ⍺←⎕UCS 39
      1<|≡⍵:⍺∘∇¨⍵
      L R←2⍴⍺ ⋄ {L,R,⍨⍕⍵}⍤1⊢⍵
    }

Ê←{⍺←11 ⋄ ⊂'EN'⍺,⍥⊂'Message'⍵}

Ë←{
     ⍺←⊢
     ⍺{⎕IO←0
         Char←0 2∊⍨10|⎕DR                                  ⍝ character?
         end←⊃⍵                                            ⍝ of sub-sequence
         tail←1↓⍵                                          ⍝ to be appended
         charend←Char end                                  ⍝ character ⍵?
         default←⎕UCS⍣charend⊢0                            ⍝ default begin from 0
         ⍺←default                                         ⍝ default if monadic
         charbegins←Char¨¯2↑⍺                              ⍝ character ⍺?
         lead←-(2-charend)⌊(≢⍺)⌊+/charend=charbegins       ⍝ to be considered
         head←lead↓⍺                                       ⍝ to be prepended
         begin←(¯1⌊lead)↑¯2↑default,lead↑⍺                 ⍝ first one/two items
         charend:head,tail,⍨⎕UCS(⎕UCS begin)∇ ⎕UCS end    ⍝ char sequences
         from step←-⍨\2↑begin,begin+×end-begin             ⍝ step default is +/- 1
         head,tail,⍨from+step×⍳0⌈1+⌊(end-from)÷step+step=0 ⍝ ⍺ thru ⍵ inclusive
     }⍤1⊢⍵}

Ð←(0 '∘' ('⎕SE.Dyalog.Utils' '.' ('disp←{⎕IO ⎕ML←0 1                           ⍝ Boxed sketch of nested array.' '' '          ⍺←⍬ ⋄ opts←⍺,(⍴,⍺)↓1 1 1 0 ⎕PP          ⍝ option defaults:' '          dec bch ctd sep ⎕PP←5↑opts              ⍝ decor, smooth, centred, separate pp.' '' ('          ul uc ur←bch⊃⌽''',(⎕ucs 9484 9516 9488),''' ''.''                 ⍝ upper',(⎕ucs 9472 9472 9488 32 9484,3/9472),'left') ('          ml mc mr←bch⊃⌽''',(⎕ucs 9500 9532 9508),''' ''|+|''               ⍝ middle',(⎕ucs 9472 9532 215 9532 9472),'centre') ('          ll lc lr←bch⊃⌽''',(⎕ucs 9492 9524 9496),''' ''''''''                ⍝ lower',(⎕ucs 9472 9472 9496 32 9492 9472 9472),'right') ('          vt hz←bch⊃⌽''',(⎕ucs 9474 9472),''' ''|-''                    ⍝ vertical and horizontal.') '' '          box←{                                   ⍝ Recursive boxing of nested array.' '              isor ⍵:⎕FMT⊂⍵                       ⍝ ⎕or: ''∇name''.' '              1=≡,⍵:dec open ⎕PP ∆FMT1 dec open ⍵     ⍝ simple array: format.' '              mat←matr 1/dec open ⍵               ⍝ matrix of opened subarrays.' '              r c←×⍴mat                           ⍝ non-null rows/cols.' '              dec<0∊r c:c/r⌿∇ 1 open mat          ⍝ undecorated null: empty result.' '              subs←aligned ∇¨mat                  ⍝ aligned boxed subarrays.' '              (≢⍴⍵)gaps ⍵ plane subs              ⍝ collection into single plane.' '          }' '' '          aligned←{                               ⍝ Alignment and centring.' '              rows cols←sepr⍴¨⍵                   ⍝ subarray dimensions.' '              sizes←(⌈/rows)∘.,⌈⌿cols             ⍝ aligned subarray sizes.' '              ctd=0:sizes↑¨⍵                      ⍝ top-left alignment.' '              v h←sepr⌈0.5×↑(⍴¨⍵)-sizes           ⍝ vertical and horizontal rotation.' '              v⊖¨h⌽¨sizes↑¨⍵                      ⍝ centred aligned subarrays.' '          }' '' '          gaps←{                                  ⍝ Gap-separated sub-planes.' '              sep≤⍺≤2:⍵                           ⍝ not separating: done.' '              subs←(⍺-1)∇¨⍵                       ⍝ sub-hyperplanes.' '              width←⊃⌽⍴⊃subs                      ⍝ width of inter-plane gap.' '              fill←(⍺ width-3 0)⍴'' ''              ⍝ inter-plane gap.' '              ↑{⍺⍪fill⍪⍵}/1 open subs             ⍝ gap-separated planes.' '          }' '' '          plane←{                                 ⍝ Boxed rank-2 plane.' '              sep∧2<⍴⍴⍺:⍺ join ⍵                  ⍝ gap-separated sub-planes.' '              odec←(dec shape ⍺)outer ⍵           ⍝ outer type and shape decoration.' '              idec←inner ⍺                        ⍝ inner type and shape decorations.' '              (odec,idec)collect ⍵                ⍝ collected, formatted subarrays.' '          }' '' '          join←{                                  ⍝ Join of gap-separated sub-planes.' '              sep←(≢⍵)÷1⌈≢⍺                       ⍝ sub plane separation.' '              split←(0=sep|⍳≢⍵)⊂[0]⍵              ⍝ separation along first axis.' '              (⊂⍤¯1⊢⍺)plane¨split                 ⍝ sub-plane join.' '          }' '' '          outer←{                                 ⍝ Outer decoration.' '              sizes←1 0{⊃↓(⍉⍣⍺)⍵}¨sepr⍴¨⍵         ⍝ row and col sizes of subarrays.' '              sides←sizes/¨¨vt hz                 ⍝ vert and horiz cell sides.' '              bords←dec↓¨ml uc glue¨sides         ⍝ joined up outer borders.' '              ↑,¨/(ul'''')⍺ bords(ll ur)            ⍝ vertical and horizontal borders.' '          }' '' '          inner←{                                 ⍝ Inner subarray decorations.' '              deco←{(type ⍵),1 shape ⍵}           ⍝ type and shape decorators.' '              sepr deco¨matr dec open ⍵           ⍝ decorators: tt vv hh .' '          }' '' '          collect←{                               ⍝ Collected subarrays.' '              lft top tt vv hh←⍺                  ⍝ array and subarray decorations.' '              cells←vv right 1 open tt hh lower ⍵ ⍝ cells boxed right and below.' '              boxes←(dec∨0∊⍴⍵)open cells          ⍝ opened to avoid ,/⍬ problem.' '              lft,top⍪↑⍪⌿,/boxes                  ⍝ completed collection.' '          }' '' '          right←{                                 ⍝ Border right each subarray.' '              types←2⊥¨(⍳⍴⍵)=⊂¯1+⍴⍵               ⍝ right border lower corner types.' '              chars←mc mr lc lr[types]            ⍝    ..     ..      ..      chars.' '              rgt←{⍵,(-≢⍵)↑(≢⍵)1 1/vt,⍺}          ⍝ form right border.' '              ((matr 1 open ⍺),¨chars)rgt¨⍵       ⍝ cells bordered right.' '          }' '' '          lower←{                                 ⍝ Border below each subarray.' '              bot←{⍵⍪(-1⊃⍴⍵)↑⍺ split ⍵}           ⍝ lower border.' '              split←{((¯2+1⊃⍴⍵)/hz)glue ⍺}        ⍝ decorators split with horiz line.' '              (matr↑,¨/⍺)bot¨matr ⍵               ⍝ cells bordered below.' '          }' '' '          type←{                                  ⍝ Type decoration char.' ('              dec<|≡⍵:hz                          ⍝ nested: ''',(⎕ucs 9472 39)) '              isor ⍵:''∇''                          ⍝ ⎕or:    ''∇''' '              sst←{                               ⍝ simple scalar type.' '                  0=dec×⍴⍴⍵:hz                    ⍝ undecorated or scalar ⍕⍵: char,' '                  (⊃⍵∊''¯'',⎕D)⊃''#~''                ⍝ otherwise, number or space ref.' '              }∘⍕                                 ⍝ ⍕ distinguishes type of scalar.' '              0=≡⍵:sst ⍵                          ⍝ simple scalar: type.' '              {(1=⍴⍵)⊃''+''⍵}∪,sst¨dec open ⍵       ⍝ array: mixed or uniform type.' '          }' '' '          shape←{                                 ⍝ Row and column shape decorators.' '              dec≤0=⍴⍴⍵:⍺/¨vt hz                  ⍝ no decoration or scalar.' '              cols←(×¯1↑⍴⍵)⊃''⊖→''                  ⍝ zero or more cols.' '              rsig←(××/¯1↓⍴⍵)⊃''⌽↓''                ⍝ zero or more rows.' '              rows←(¯1+3⌊⍴⍴⍵)⊃vt rsig''⍒''          ⍝ high rank decorator overrides.' '              rows cols                           ⍝ shape decorators.' '          }' '' '          matr←{↑,↓⍵}                             ⍝ matrix from non-scalar array.' '          sepr←{+/¨1⊂↑⍵}                          ⍝ vec-of-mats from mat-of-vecs.' '          open←{16::(1⌈⍴⍵)⍴⊂''[ref]'' ⋄ (⍺⌈⍴⍵)⍴⍵}   ⍝ stretched to expose nulls.' '          isor←{1 ⍬≡(≡⍵)(⍴⍵)}                     ⍝ is ⎕or of object?' '          glue←{0=⍴⍵:⍵ ⋄ ↑⍺{⍺,⍺⍺,⍵}/⍵}            ⍝ ⍵ interspersed with ⍺s.' '' '          isor ⍵:⎕FMT⊂⍵                           ⍝ simple ⎕OR: done.' '          1=≡,⍵:⎕PP ∆FMT1 ⍵                           ⍝ simple array: done.' '          box ⍵                                   ⍝ recursive boxing of array.' '      }'))) (¯1 '∘' '↓')

êEsc←(,⊂'Ê←{⍺←11 ⋄ ⊂''EN''⍺,⍥⊂''Message''⍵}') ('T1←{' '                  t1←''Sequence "`'',⍵,''" not valid in code fields outside strings.''' '                  t2←''Did you mean "'',⍵,''"?''' '                  t1,nl,(17⍴''''),t2' '               }')

êScBad←(,⊂'Ê←{⍺←11 ⋄ ⊂''EN''⍺,⍥⊂''Message''⍵}') (,⊂'{''Sequence "`'',⍵,''" does not represent a valid shortcut.''}')

∇    result←{opts}∆F args
      :Trap TRAP_ERRORS/0
        :If 900⌶0
            opts←⎕NS OPTS_DEFns
        :ElseIf 9=⎕NC'opts'
            opts←⎕NS OPTS_DEFns opts
        :ElseIf 11 83∊⍨⎕DR opts ⋄ :AndIf OPTS_KW≥⍥≢opts
            opts←OPTS_DEFns ⎕NS⍛⎕VSET(OPTS_KW↑⍨≢opts)opts
        :Else
            result←args Special opts ⋄ :Return
        :EndIf
        args←,⊆args
        :Select opts.dfn
        :Case 0
            result←opts((⊃⎕RSI){⍺⍺⍎⍺ ScanFStr⊃⍵⊣⎕EX'opts' 'args'})args
        :Case 1
            result←⎕RSI⊃⍛⍎opts ScanFStr⊃args
        :Case ¯1
            result←opts ScanFStr⊃args
        :Else
            result←Special opts
        :EndSelect
    :Else
        ⎕SIGNAL⊂⎕DMX.('EM' 'EN' 'Message',⍥⊂¨('∆F ',EM)EN Message)
    :EndTrap
       ⍝! (C) Copyright 2025, 2026 Sam the Cat Foundation
∇

Ö←{                                     ⍝ Apply fn ⍺⍺ at depths ⍵⍵.
    ⍺←⊣
    depths←⌽3⍴⌽⍵⍵                       ⍝ expand right operand
    m l r←depths-⍨(|≡¨⍵ ⍺ ⍵)×depths≥0   ⍝ ¨ digs top-down
    max encl←'¨⊂'⍴¨⍨l(⌈,∘|-)r           ⍝ find number of ¨s and ⊂s
    el er←(1 0=l≤r)/¨⊂encl              ⍝ where do the ⊂s go?
    0::⎕SIGNAL ⎕EN                      ⍝ bubble errors up
    ⍎'(',el,'⍺)⍺⍺',max,er,'⍵'           ⍝ do it!
}


:Namespace OPTS_DEFns
⍝ === VARIABLES ===

auto←1

box←0

dfn←0

inline←0

verbose←0


⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

:EndNamespace 
:Namespace QUOTE_STYLES
⍝ === VARIABLES ===

CH1←(⎕ucs 12298 12299)

CH2←(⎕ucs 12300 12301)

DE1←(⎕ucs 187 171)

DE2←(⎕ucs 8222 8220)

DE3←(⎕ucs 8218 8216)

FR1←(⎕ucs 171 187)

FR2←(⎕ucs 8220 8221)

FR3←(⎕ucs 8216 8217)

JP1←(⎕ucs 12300 12301)

JP2←(⎕ucs 12302 12303)


⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

:EndNamespace 
:Namespace libUtils
⍝ === VARIABLES ===

nmSym←'0123456789_abcdefghijklmnopqrstuvwxyz∆ABCDEFGHIJKLMNOPQRSTUVWXYZ⍙ÁÂÃÇÈÊËÌÍÎÏÐÒÓÔÕÙÚÛÝþãìðòõÀÄÅÆÉÑÖØÜßàáâäåæçèéêëíîïñóôöøùúûü'

ûLibNm←'⎕SE.FString.userLibrary'

ûLibTok←'⎕SE.FString.userLibrary '


⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

Deserialise←{ ⍝ Convert text to array
          ⍺←⍬ ⍝ 1=safe exec expr; 0=return expr; ¯1=unsafe exec expr; ¯2=force APL model
          (model beSafe execute)←(¯2∘=,0∘⌈,1⌊|)serialise.FirstNum ⍺,1
          caller←serialise.FirstNs ⍺,⊃⎕RSI
     
               ⍝ Make normalised simple vector:
          w←↓⍣(2=≢⍴⍵)⊢⍵                  ⍝ if mat, make nested
          w←~⍤∊∘(⎕UCS 10 13)⍛⊆⍣(∨/⍵∊⍨⎕UCS 10 13)⊢w ⍝ if simple, make simple
     
          beSafe>Safe w:⎕SIGNAL⊂('EN' 11)('Message' 'Unsafe array notation')
     
                                     ⍝ fall back to APL model on error
          model<execute:caller ∇{2::⍵ ⍺⍺⍨¯2,⍺ ⋄ ⍺ ∆APLAN,⍵}w
     
          q←''''
          ⎕IO←0
          SEP←'⋄',⎕UCS 10 13
     
          Unquot←{(⍺⍺ ⍵)×~≠\q=⍵}
          SepMask←∊∘SEP Unquot
          ParenLev←+\(×¯3+7|¯3+'([{)]}'∘⍳)Unquot
     
          Paren←1⌽')(',⊢
          Split←{1↓¨⍺⍺⊂Over(1∘,)⍵}
     
          Over←{(⍵⍵ ⍺)⍺⍺(⍵⍵ ⍵)}
          EachIfAny←{0=≢⍵:⍵ ⋄ ⍺ ⍺⍺¨⍵}
          EachNonempty←{⍺ ⍺⍺ EachIfAny Over((×≢¨⍵~¨' ')/⊢)⍵}
     
          Parse←{
              0=≢⍵:''
              bot←0=⍺
              (2≤≢⍵)>∨/¯1↓bot:⍺ SubParse ⍵
              p←bot×SepMask ⍵
              ∨/p:∊{1=≢⍵:',⊂',⍵ ⋄ ⍵}⍺(Paren ∇)EachNonempty Over(p Split)⍵
              p←2(1,>/∨¯1↓0,</)bot
              ∨/1↓p:∊(p⊂⍺)∇¨p⊂⍵
              ⍵
          }
     
          ErrIfEmpty←{⍵⊣'Array doesn''t have a prototype'⎕SIGNAL 11/⍨(0=≢⍵)}
     
          SubParse←{
              ('})]'⍳⊃⌽⍵)≠('{(['⍳⊃⍵):'Bad bracketing'⎕SIGNAL 2
              (a w)←(1↓¯1∘↓)¨(⍺-1)⍵
              '['=⊃⍵:Paren'{⎕ML←1⋄↑⍵}1/¨',Paren ErrIfEmpty a Parse w ⍝ high-rank
              ':'∊⍵/⍨(1=⍺)×~≠\q=⍵:a Namespace w ⍝ ns
              '('=⊃⍵:Paren{⍵,'⎕NS⍬'/⍨0=≢⍵}a Parse w ⍝ vector/empty ns
              ⍵ ⍝ dfn
          }
     
          SysVar←(⎕C sysVars)∊⍨' '~¨⍨⎕C∘⊆
     
          ParseLine←{
              c←⍵⍳':'
              1≥≢(c↓⍵)~' ':'Missing value'⎕SIGNAL 6
              name←c↑⍵
              (SysVar⍱¯1≠⎕NC)name:'Invalid name'⎕SIGNAL 2
              name(name,'←',⍺ Parse Over((c+1)↓⊢)⍵)
          }
     
          Namespace←{
              p←(0=⍺)×SepMask ⍵
              (names assns)←↓⍉↑⍺ ParseLine EachNonempty Over(p Split)⍵
              quadMask←SysVar names
              quadAssns←'{⍵.(⍵',(∊'⊣',¨quadMask/assns),')}'
              names/⍨←~quadMask
              assns/⍨←~quadMask
              names,←(0=≢names)/⊂''
              ∊'({'(assns,¨'⋄')quadAssns'⎕NS'('(, '∘,¨q,¨names,¨⊂q')')'}⍬)'
          }
     
          Execute←{   ⍝ overcome LIMIT ERROR on more than 4096 parenthesised expressions
              ExecuteEach←{         ⍝ split at level-1 parentheses and execute each
                  l←(t=¯1)++\t←{1 ¯1 0['()'⍳⍵]}Unquot ⍵ ⍝ parenthesis type and level
                  (h x t l)←(1 0 0 0=⊂∧\l=0)/¨⍵ ⍵ t l   ⍝ extract header before first opening parenthesis
                  ⍺{0::0 ⋄ r←⍺⍎⍵ ⋄ ~(⊃⎕NC'r')∊3 4}h:⍺⍎⍵ ⍝ header must be an functional expression
                  H←⍺{⍺⍺⍎⍵⍵,'⍵'}h                       ⍝ function to apply header to array
                  ' '∨.≠(l=0)/x:⍺⍎⍵                     ⍝ something outside level-1 parentheses - must fall back to ⍎
                  x←(((l>0)∧(l≠1)∨(t=0))×+\(t=1)∧(l=1))⊆x   ⍝ cut expression within level-1 parentheses
                  1=≢x:H ⍺ ∇⊃x                          ⍝ single expression : don't enclose with ¨
                  DEBUG∧1<⌈/l:H ⍺ ∇¨x                    ⍝ force going through the hard code
                  10::H ⍺ ∇¨x ⋄ H ⍺⍎¨x                  ⍝ attempt to ⍎¨ with a single guard - otherwise dig each
              }
              DEBUG:⍺ ExecuteEach ⍵           ⍝ force going through the hard code
              10::⍺ ExecuteEach ⍵ ⋄ ⍺⍎⍵       ⍝ attempt simple ⍎ and catch LIMIT ERROR
          }
     
          w←'''[^'']*''' '⍝.*'⎕R'&' ''⍠'ResultText' 'Simple'⊢w ⍝ strip comments
          w/⍨←{(∨\⍵)∧⌽∨\⌽⍵}33≤⎕UCS w     ⍝ strip leading/trailing non-printables
     
          pl←ParenLev w
          (0≠⊢/pl)∨(∨/0>pl):'Unmatched brackets'⎕SIGNAL 2
          ∨/(pl=0)×SepMask w:'Multi-line input'⎕SIGNAL 11
          caller Execute⍣execute⊢pl Parse w ⍝ materialise namespace as child of calling namespace
      }

Serialise←{
          ⍺←⍬
          num←serialise.FirstNum ⍺,0
          caller←serialise.FirstNs ⍺,⊃⎕RSI
     
          Bad←{(caller code)←⍵
              '+'∊⍺:0
              value←Deserialise caller.{⍺⍺ ⍵}code ⍝ deserialise in caller namespace to have proper ⎕FR
              code≢caller serialise.Ser value  ⍝ serialisation must round-trip
          }
          code←caller serialise.Ser ⍵
          ⍺ Bad caller code:'It would not be possible to deserialise the generated array notation'⎕SIGNAL 16
     
          code Format⍨1∊⍺
      }

GenFullPath←{
        pfx pth←⍵.(prefix path)
        ⍬{
        0=≢⍵:⍺
          p←⊂⊃⍵
        2<|≡p:(⍺,p)∇ 1↓⍵
          (⍺,,p∘.,'/'∘.,pfx)∇ 1↓⍵
        }pth
      }

LibAuto←{
    ~⍺.auto:ûLibTok
        w←NoLB ⍵
    '.'≠⊃w:ûLibTok
        w←NoLB 1↓w
        len←NmSpan w
        nm←len↑w
    nm⊂⍛∊⍺.acache:ûLibTok
        ⍺.acache,←⊂nm
    0≠ûLib.⎕NC nm:ûLibTok
        w←len↓w
    '←'=⊃w~'∘ ':ûLibTok
        _←⍺ LoadObj nm
                             ûLibTok
  }

∇    {libRef}←LibComplete libRef
    libRef.⎕DF ⎕NULL
    ûLibTok←' ',⍨ûLibNm←⍕ûLib←libRef
    ûLib.⎕DF'£=[',ûLibNm,']'
∇

LibNoAuto←{ûLibTok}

LoadDefaultParms←{fi←⍵
      2 6 11::_←pârms⊣0 LoadErr'Default parameter file "',fi,'" has errors'
      ~⎕NEXISTS fi:fi Err'does not exist'
          _←'pârms'⎕NS AN2Apl⊃⎕NGET fi 1
          pârms.verbose←(⍬ ⎕NULL∊⍨⊂pârms.verbose)⊃pârms.verbose ##.VERBOSE_RUNTIME
      1:_←pârms⊣pârms.⍙readParms←1 0
    }

LoadErr←{isUsrP←⍺
        warn←'❗❗❗ ∆F LIB. WARNING: '
        amsg←(⊂'Library Autoload is '),¨'not available' 'available',¨'' ' with default parameters.'
        _←{0=≢⍵:⍬ ⋄ ⊢⎕←warn,⍵}¨⍵ ⎕DMX.Message(isUsrP⊃amsg)
        ⎕THIS.(LibAuto←LibNoAuto)
        pârms.(auto ⍙readParms←0(0 0))
      1:_←0
    }

LoadObj←{
      SubScanFiles←{
        0=≢⍵:rcNF ⍬ ⋄ 22 11::rcER ⍬⊣êDMX⊢←⎕DMX
        fi←⊃⍵
        ~⎕NEXISTS fi:∇ 1↓⍵
        FixByType←{
          sfx←⊂⊃⌽⎕NPARTS fi←⍵
          IfF sfx:rcEN rcOK⊃⍨êNm⊂⍛∊êNms⊢←2 ûLib.⎕FIX _FOpts êErrFi⊢←fi
          IfA sfx:rcOK⊣ûLib ⎕VSET⊂êNm(AN2Apl⊃⎕NGET fi 1)
          IfJ sfx:rcOK⊣ûLib ⎕VSET⊂êNm(⎕JSON _JOpts⊃⎕NGET fi 0)
          IfT sfx:rcOK⊣ûLib ⎕VSET⊂êNm(⊃⎕NGET fi(OptT sfx))
                    rcEN rcOK⊃⍨êNm⊂⍛∊êNms⊢←êNm FixOrAssign fi
        }
        (FixByType fi)('file:"',fi,'"')
      }
              t0←'.aplf' '.aplo' '.apln' '.dyalog'
      IfF←∊∘t0
      IfA←≡∘⊂∘'.apla'
      IfJ←≡∘⊂∘'.json'
              t1←'.txt' '.aplv' '.aplvv' '.aplm'
      IfT←∊∘t1
      OptT←⌷∘0 0 1 2(t1∘⍳)
      _FOpts←⍠('FixWithErrors' 0)('Quiet' 1)
      _JOpts←⍠('Dialect' 'JSON5')('Compact' 0)('Null'⎕NULL)
      FixOrAssign←{
        19 11::⍺⊂⍛⊣ûLib ⎕VSET⊂⍺(AN2Apl⊃⎕NGET ⍵ 1)
          2 ûLib.⎕FIX _FOpts êErrFi⊢←⍵
      }
      SubScanWS←{path subp←⍺ ⍵
        0=≢subp:ScanPath 1↓path
          FixFromWS←{11::rcNF ⍬ ⋄ rcOK('ws:"',⍵,'"')⊣⍺ ûLib.⎕CY ⍵}
          ret←êNm FixFromWS⊃subp
        rcNF≠⊃ret:ret ⋄ path ∇ 1↓subp
      }
      ScanPath←{
        0=≢⍵:rcNF ⍬ ⋄ path←⍵ ⋄ cur←⊃path
        1<|≡cur:path SubScanWS cur
          ff←,(⊂cur)∘.,(⊂êNm),¨pârms.suffix
          rcNF≠⊃ret←SubScanFiles ff:ret
          ∇ 1↓path
      }
      EndScan←{rc libE←⍺
        (~êVerbose)∧rc=rcOK:rc ⋄ (srcFi dest)←⍵
          qNms←'"',⍨3↓∊(êNm⊂⍛,êNms~⊂êNm),⍨¨⊂'", "'
        rc=rcOK:rc⊣⎕←'∆F: Copied ',qNms,' into £ibrary',(0≠≢srcFi)/' from ',srcFi
          Ê←rc∘{
            en message←⍵
            libE:⎕SIGNAL⊂('EN'en)('Message'message)('EM')
            ~êVerbose:⍺ ⋄ ⍺⊣⎕←('∆F ',⎕EM en),': ',message
          }
        rc=rcNF:Ê 11('Object "',êNm,'" not found on search path')
        rc=rcEN:Ê 11('Obj "',êNm,'" not present in ',srcFi)
        rc=rcER:Ê êDMX.EN,⍥⊂'Error loading ',êNms,' into user library (',êDMX.Message,')'
                 Ê 911('EndScan Logic Error: Unknown Return Code')
      }
      ûsr←⍺
      êNms←,⊂êNm←⍵
      êDMX←⍬
      êErrFi←''
      êVerbose←∨/(ûsr pârms).verbose
      rcOK rcNF rcER rcEN←1 0 ¯1 ¯2
      rc where←ScanPath pârms.⍙fullPath
    1:_←rc ##.SIGNAL_LIB_ERRS EndScan where ûLib
  }

∇    {rc}←LoadParms parmNs
    ;v;c;r;parms
    parms←↑'verbose' 'compact' 'runtime'
    v c r←parmNs ⎕VGET parms 0
    rc←1 0⍴⍬
    SetBaseParms ⍬
    :If ##.LIB_ACTIVE≥1
        LoadDefaultParms ##.LIB_PARM_FI
        :If ##.LIB_ACTIVE=2
        :AndIf rc←pârms.⍙readParms[0]
          r LoadUserParms ##.LIB_USER_FI
        :EndIf
        :If ~0∊≢¨pârms.(prefix path)
            pârms.⍙fullPath←GenFullPath pârms
        :Else
            pârms.⍙fullPath←⍬
            v LoadErr'The user parameter file generates an empty search path.'
        :EndIf
        rc←v(c _CShow)pârms
    :EndIf
∇

LoadUserParms←{runtime parmFi←⍺ ⍵
      ~pârms.⍙readParms[0]:_←0
        _←runtime ReadUserParms parmFi
        _←ParmsSpecial pârms
    }

NmSpan←0 '⍳⍨' ('∊' '∘' '0123456789_abcdefghijklmnopqrstuvwxyz∆ABCDEFGHIJKLMNOPQRSTUVWXYZ⍙ÁÂÃÇÈÊËÌÍÎÏÐÒÓÔÕÙÚÛÝþãìðòõÀÄÅÆÉÑÖØÜßàáâäåæçèéêëíîïñóôöøùúûü')

NoLB←{(∨\' '≠⍵)/⍵}

ParmsSpecial←{
        ⍺←('verbose'##.VERBOSE_RUNTIME)('prefix'(,⊂''))('auto' 0)('path'⍬)('suffix'⍬)
        ⍵ ⎕VSET ⍺/⍨(⍬∘≡∨⎕NULL∘≡)∘⍵.⎕OR∘⊃¨⍺
      }

ReadUserParms←{
        ~⎕NEXISTS ⍵:⍬
        0::'∆F ReadUser Parms Failed, but error was not trapped'⎕SIGNAL 911
        2 6 11/⍨~⍺::_←1 LoadErr'User parameter file "',⍵,'" has errors'
          _←'pârms'⎕NS AN2Apl⊃⎕NGET ⍵ 1
          0⊣pârms.⍙readParms[1]←1
      }

SetBaseParms←{
        ⍙readParms auto path prefix suffix verbose←(0 0)0 ⍬ ⍬ ⍬(##.VERBOSE_RUNTIME)
        'pârms'⎕NS'⍙readParms' 'auto' 'path' 'prefix' 'suffix' 'verbose'
    }

ShowPath←{⊃1 Apl2AN pârms.⍙fullPath}

_CShow←{⍺←0
        0::1 0⍴⎕←'❌❌❌ ∆F Load: Error displaying runtime parameters'
        (~⍺)∧~⍵.verbose:_←1 0⍴''
        0=≢nl←⍵.⎕NL ¯2:_←1 0⍴''
        1:_←↑⍺⍺ Apl2AN ⍵.{⎕NS{⍵/⍨'⍙'≠⊃¨⍵}⍵}nl
      }


:Namespace pârms
⍝ === VARIABLES ===

auto←1

path←'MyDyalogLib' (,⊂'dfns') '.'

prefix←,⊂''

suffix←'.aplf' '.apla' '.aplo' '.apln' '.json' '.dyalog' '.txt' '.aplv' '.aplvv' '.aplm'

verbose←0

⍙fullPath←'MyDyalogLib/' (,⊂'dfns') './'

⍙readParms←2⍴1


⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

:EndNamespace 
:Namespace ûLib
(⎕IO ⎕ML ⎕WX)←0 1 3

:EndNamespace 
:EndNamespace 
:Namespace sc
⍝ === VARIABLES ===

nEsc←10

tbl←((15⍴' ⎕SE.FString.A') (15⍴' ⎕SE.FString.B') (15⍴' ⎕SE.FString.C') (15⍴' ⎕SE.FString.T') (6⍴' ⎕FMT') (15⍴' ⎕SE.FString.J') (15⍴' ⎕SE.FString.Q') (15⍴' ⎕SE.FString.S') (15⍴' ⎕SE.FString.T') (15⍴' ⎕SE.FString.W') (15⍴' ⎕SE.FString.Ð') (15⍴' ⎕SE.FString.M') (15⍴' ⎕SE.FString.Ö') (15⍴' ⎕SE.FString.Ë') (⎕ucs 40 8834 9051 9015 41)) ('{⎕ML←1⋄⍺←⍬⋄⊃⍪/(⌈2÷⍨w-m)⌽¨f↑⍤1⍨¨m←⌈/w←⊃∘⌽⍤⍴¨f←⎕FMT¨⍺ ⍵⋄}' '{⎕ML←1⋄d←|≡⍵⋄⍺←0⋄⍺⎕SE.Dyalog.Utils.disp⊂⍣(1≥d),⍣(0=d)⊢⍵⋄}' '{⎕IO⎕ML←0 1⋄nd←≢def←3 '',''⋄⍺←def⋄Opt←⍕¨{⋄o←⍵⋄isN←(⎕D∊⍨⊃o)∨0=⊃0⍴o⋄isN:o,(def↑⍨-0⌈nd-≢o)⋄(def↑⍨0⌈nd-≢o),⌽o⋄}⋄Esc←{⍵≡⍥,''&'':''\&''⋄⍵/⍨1+''\''=⍵}⋄n s←Opt ⍺⋄src←''[.Ee]\d+'',⍥⊂''(?<=\d)(?=(\d{'',n,''})+([-¯.Ee]|(?=\s|$)))''⋄snk←''&'',⍥⊂''&'',⍨Esc s⋄w←src⎕R snk⍤1⍕⍵⋄⊃⍣(1=≢⍵)⊢w⋄}' '{⎕ML←1⋄⍺←''%ISO%''⋄∊⍣(1=≡⍵)⊢⍺(1200⌶)⊢1⎕DT⊆⍵⋄}' (6⍴' ⎕FMT') '{⎕PP←34⋄⍺←''L''⋄B←{+/∧\'' ''=⍵}⋄w⌽⍨(1⎕C ⍺){o←⊂⍺⋄o∊''L'' ¯1:B ⍵⋄o∊''R'' 1:-B⌽⍵⋄o∊''C'' 0:⌈0.5×⍵-⍥B⌽⍵⋄⎕SIGNAL⊂(''EN'' 11)(''Message'' ''Shortcut option (⍺) was invalid'')⋄}w←⎕FMT ⍵⋄}' '{⍺←''''''''⋄1<|≡⍵:⍺∘∇¨⍵⋄(0=⍴⍴⍵)∧1=≡⍵:⍵⋄(0≠≡⍵)∧326=⎕DR ⍵:⍺∘∇¨⍵⋄⎕ML←1⋄⍺{0=80|⎕DR ⍵:⍺,⍺,⍨⍵/⍨1+⍺=⍵⋄⍵}⍤1⊢⍵⋄}' '{⎕ML←1⋄11 16 6::⍵⋄⍺←0⋄⋄1=≢s←⍺⎕SE.Dyalog.Array.Serialise ⍵:⊃s⋄⋄⍪s⋄}' '{⎕ML←1⋄⍺←''%ISO%''⋄∊⍣(1=≡⍵)⊢⍺(1200⌶)⊢1⎕DT⊆⍵⋄}' '{⎕ML←1⋄⍺←⎕UCS 39⋄1<|≡⍵:⍺∘∇¨⍵⋄L R←2⍴⍺⋄{L,R,⍨⍕⍵}⍤1⊢⍵⋄}' '0∘⎕SE.Dyalog.Utils.disp¯1∘↓' '{⎕ML←1⋄⍺←⊢⋄⊃,/((⌈/≢¨)↑¨⊢)⎕FMT¨⍺ ⍵⋄}' '{⍺←⊣⋄depths←⌽3⍴⌽⍵⍵⋄m l r←depths-⍨(|≡¨⍵ ⍺ ⍵)×depths≥0⋄max encl←''¨⊂''⍴¨⍨l(⌈,∘|-)r⋄el er←(1 0=l≤r)/¨⊂encl⋄0::⎕SIGNAL⎕EN⋄⍎''('',el,''⍺)⍺⍺'',max,er,''⍵''⋄}' '{⍺←⊢⋄⍺{⎕IO←0⋄Char←0 2∊⍨10|⎕DR⋄end←⊃⍵⋄tail←1↓⍵⋄charend←Char end⋄default←⎕UCS⍣charend⊢0⋄⍺←default⋄charbegins←Char¨¯2↑⍺⋄lead←-(2-charend)⌊(≢⍺)⌊+/charend=charbegins⋄head←lead↓⍺⋄begin←(¯1⌊lead)↑¯2↑default,lead↑⍺⋄charend:head,tail,⍨⎕UCS(⎕UCS begin)∇⎕UCS end⋄from step←-⍨\2↑begin,begin+×end-begin⋄head,tail,⍨from+step×⍳0⌈1+⌊(end-from)÷step+step=0⋄}⍤1⊢⍵}' (⎕ucs 40 8834 9051 9015 41)) ('A' 'B' 'C' 'T' (6⍴' ') 'J' 'Q' 'S' 'T' 'W' 'Ð' 'M' (,'Ö') (,'Ë') (5⍴' '))


⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

Map←'ABCDFJQSTW'∘⍳

:EndNamespace 
:Namespace userLibrary
(⎕IO ⎕ML ⎕WX)←0 1 3

:EndNamespace 
:EndNamespace 
