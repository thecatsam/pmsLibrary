 ⍝ A dyalog APL preprocessor
 ⍝ Takes an input file <file> in 2 ⎕FIX format, preprocesses the file, then 2 ⎕FIX's it, and
 ⍝ returns the objects found or ⎕FIX error messages.

 ⎕←'REVISED'
 
 ⎕IO ⎕ML←0 1

::LET a.b.c.d←1
::LET in_trouble←0

::IF  (a.b.c.d + 1)=2
  ::message a.b.c.d + 1 is 2
::ELSE
  ::message a.b.c.d + 1 is not 2
::ENDIF

::LET in_trouble←in_trouble+5

::IF in_trouble>2
     ::MESSAGE in_trouble exceeds 2
::ENDIF

::DEF ⎕SE.a.b.c

::IF fred..def ∨ #.mary.jack..unDef ∨ ⎕SE.a.b.c..DEF
   'hi'
::ENDIF

::UNDEF silly

::IF silly..def
     This should be ignored!
::END

::LET time ← ⎕TS + 5

::LET time2 ← ⎕TS - time

::LET time3← time2 + not_defined

::LET revNow← ⌽1 2 3..
      4 5 6..
      7 8 9

::IFDEF silly
⍝ There should be no comments on the next two lines!
 pfx obj sfx←⎕NPARTS file           ⍝ LINE1
 a←⍳b                               ⍝ LINE2
::ELSE
⍝ This should be executed
  executed←"this should run
            perfectly
            fine"
::ENDIF

 str←"This is one line
      and this is the second
      and this is the third."

 
 ::DEFINE iota ← {⍺←⊢ ⋄ ⍺ ⍳ ⍵}
 ::DEFINE mary ← 10 20 100 30
 ::DEFINE ted  ← 100
 ::DEFINE lots ← 1 2 3 4 5 ..
                 6 7 8 9 10 ..
                 11 12 13 14 15..
                 16 17 18 19 20
 ::DEFINE more ← (⌽1 2 3 4 5
                  6 7 8 9 10
                  11 12 13 14 15)

 ::DEFINE silly← {
     a←⍳5
     b←⍳6
     c←'one dark night'
 }
 a←10 20 ..  ⍝ ignore1
   30 40 ..  ⍝ ignore2
   50        ⍝ ignore3

 ⎕←lots iota more

 2 silly lots

 
 ⎕←'mary' "iota" "ted's stuff ""and more"""  'jack''s stuff "and" ''more'''
 ::DEFINE fred←55
 :If sfx≢''
     :If sfx≢'.dyalog'
         obj,←sfx ⋄ sfx←''
     :EndIf
 :Else
     sfx←'.dyalog'
 :EndIf

 :: define elephant←'rhinoceros'

 ::DEF JACK←'This is a test.'

 ::DEF JACK2←"This is 
              a test
              on multiple lines."

 code←{0::⎕NULL ⋄ ⊃⎕NGET ⍵ 1}pfx,obj,sfx

 :If code≡⎕NULL ⋄ ⎕SIGNAL/'File not found' 11 ⋄ :EndIf

 ⍝⍝⍝ process

 ⍝⍝⍝ Write out so we can ⎕FIX

 tmp←(739⌶0),'/',obj,sfx

 ⎕←'The answer is ',fred
 :: DEFINE fred←99
 ⎕←'The answer is ',fred

 ::   defiNe  VALUE_NULL
 
 ::undef JACK

 (⊂code)⎕NPUT tmp
 objects←2 ⎕FIX'file://',tmp
  
  
