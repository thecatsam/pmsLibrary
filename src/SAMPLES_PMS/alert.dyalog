 {html}←{fmt}alert msg;FMTjs
 ⍝ "DEMO of HTML Renderer to show an APL alert box with arbitrary Unicode characters.
 ⍝  HTMLRenderer won't accept anything but single-byte chars.
 ⍝  Javascript uses UTF-16 internally, so passing UTF-8 chars is too simple."
 ⍝ Syntax:
 ⍝   {html} ← {fmt} alert msg
 ⍝      msg:  Any APL object that ⎕FMT accepts (that makes sense to you).
 ⍝      fmt:  optional ⎕FMT left arg (see FMTjs).
 ⍝      html: (shyly) The actual html presented to HTMLRenderer.
 ⍝ Details:
 ⍝   ∘ To produce multiple rows, present a matrix directly, via ↑, ⍴, etc.
 ⍝   ∘ Uses ⎕FMT to produce sensible visible output
 ⍝     1.  alert 'Whoops. ⎕IO must be 1 or 0'         ⍝ Simple
 ⍝     2.  alert ↑'  You' '  must' '   be' 'kidding'  ⍝ Multi-line centered
 ⍝     3.  alert ↑'Line1⍴''abc''' 'Line2 ⍞'           ⍝ Multi-line mixed Unicode
 ⍝     4.  alert ?2 3⍴0                               ⍝ A matrix of random #s
 ⍝     5.  alert '丠丠丠'                              ⍝ CJK characters ok
 ⍝     6.  alert 'Poo 💩 is hex 01F4A9'               ⍝ high-range Unicode ok
 ⍝ Bugs:
 ⍝   Even though the renderer window is size (0 0), it is still there.

 html←'<!DOCTYPE HTML><html><body><p></p><script>'
 html,←'alert(''⍞ALERT⍞'');</script><p></p></body></html>'   ⍝ ⍞ALERT⍞ replaced by string modified from <msg>

⍝ FMTjs:
⍝    "For an APL object ⍵, convert via ⎕FMT (1- or 2-adic),
⍝     then encode as Javascript string with the same appearance.
⍝     All ctl chars, special chars, and chars above 255, can safely
⍝     be encoded via \u{h…h} (≤6 hex digits), \uhhhh (4), and \xhh (2). (Javascript ≥6).
⍝     As a demonstration, uses \xhh and \uhhhh where possible, but not much string space is saved."
⍝ Syntax:
⍝    js ← [fmt] FMTjs apl
⍝       apl: An APL object, valid for ⎕FMT.
⍝       fmt: If present, std valid left arg to ⎕FMT.
⍝       js:  A Javascript string valid within single or double quotes.
⍝
 FMTjs←{⍺←⊢ ⋄ ⎕IO←0
     hexD←⎕D,'ABCDEF'
     avoid←'%''"&\'                               ⍝ We encode via \x, noting in theory % can be encoded as \%, etc.
     safe←(⎕UCS 32+⍳256-32)~avoid                 ⍝ safe: (⎕UCS 32-255) avoiding % ' " & and \
     c2hjs←{                                      ⍝ encode hex in js format as compactly as possible
         2≥≢⍵:'\\x',¯2↑'00',⍵
         4≥≢⍵:'\\u',¯4↑'0000',⍵
         '\\u{',⍵,'}'                             ⍝ 6 digits max, e.g. 5 for '💩' poo(p)
     }∘{hexD[16⊥⍣¯1⊣⎕UCS ⍵]}¨                     ⍝ returns minimal hex digits for each char passed.
                                                  ⍝ ⍵: an APL object in the domain of ⎕FMT.
     msg←¯1↓,(⍺ ⎕FMT ⍵),⎕UCS 13                   ⍝ msg: map ⍵ to a flat char. vector with line separators.

     unsafe←~msg∊safe                             ⍝ unsafe: 0 or more chars to be encoded.
     av←msg∊avoid
     (unsafe/msg)←c2hjs unsafe/msg                ⍝ msg: map unsafe char scalars to enclosed strings.
     ∊msg                                         ⍝ msg: flattened down again
 }

 :If 0=⎕NC'fmt' ⋄ fmt←⊢ ⋄ :EndIf

 html←'⍞ALERT⍞'⎕R(fmt FMTjs msg)⊣html
                                                  ⍝ Run in own thread so alert window stays open after fn exit.
 {'ignored'⎕WC'HTMLRenderer'⍵('Size'(0 0))}&html  ⍝ Size (0 0): makes extra renderer window invisible
