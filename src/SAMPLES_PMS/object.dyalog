 object←{⍺←2⍴10 ⎕PW ⋄ mh mw←2⍴⍺,2⍴2*31
     ⎕IO ⎕ML ⎕PP CR←0 3 34(⎕UCS 10)
     he ve←⎕UCS 8230 8942 ⋄ he ve←⎕UCS 9002 128314
     h w←⍴obj←⎕FMT⍕⍵
     {
         (h≤mh)∧(w≤mw):⍵
         o←(h w⌊mh mw)⍴⍵
         o⊣{h≤mh:⍬ ⋄ (¯1↑o)←' ' ⋄ ⊣o[mh-1;⍳⌈0.5×¯1↑⍴o]←ve
         }{w≤mw:⍬ ⋄ ⊢(¯1↑[1]o)←he
         }⍬
     }obj
 }
