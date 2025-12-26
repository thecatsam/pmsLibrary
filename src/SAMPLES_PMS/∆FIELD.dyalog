 ∆FIELD←{
  ⍝ ∆FIELD
  ⍝ match@S ← pcreNs [default←''] ∇ fieldID@(S|I)
  ⍝
  ⍝ ∆FIELD  : Returns the matched PCRE field <fieldNum> or <fieldName>
  ⍝           for PCRE namespace passed via ⎕R or ⎕S as ⍵;
  ⍝           if none, returns '' or default specified.
  ⍝ match ← pcreNS [default] ∇ fieldID
  ⍝    fieldID: the field number (0=entire match) or a name (if specified in the match)
  ⍝    pcreNS:  the namespace passed via ⎕R/S to its right arg as ⍵.
  ⍝    default: a string vector. ⎕NULL or a number is valid, but will cause an error
  ⍝             if returned from an ⎕R right-hand function.
  ⍝ Note: Doesn't fail on missing field ids. No problem:
  ⍝       '(\d+)'⎕R {0::'???' ⋄ ⍕÷⍎⍵ ∆FIELD 1}⊣'1 2 3'
  ⍝    1 0.5 0.333333333
  ⍝       '(\d+)'⎕R {0::'???' ⋄ ⍕÷⍎⍵ ∆FIELD 1}⊣'10 000 5'
  ⍝    0.1 ??? 0.2
  ⍝ Note: You can handle several fields at once using ∆FIELD¨ as here:
  ⍝        name1 fld3←⍵ ∆FIELD¨'name1' 3
  ⍝        name1 fld3←(⊂⍵ ⎕NULL) ∆FIELD¨'name1' 3    ⍝ Note ⊂
  ⍝ See also <fieldValN>, a faster alternative (when the default value of '' is used.)
     ns def←2↑⍺,⊂''
     ' '=1↑0⍴⍵:⍺ ∇ ns.Names⍳⊂⍵
     ⍵=0:ns.Match                                  ⍝ Fast way to get whole match
     ⍵≥≢ns.Lengths:def                             ⍝ Field not defined AT ALL → ''
     ns.Lengths[⍵]=¯1:def                          ⍝ Defined field, but not used HERE (within this submatch) → ''
     ns.(Lengths[⍵]↑Offsets[⍵]↓Block)              ⍝ Simple match
 }
