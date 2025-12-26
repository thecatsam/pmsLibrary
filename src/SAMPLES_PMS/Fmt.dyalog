 out←{pFlag}Fmt in;rP;cP
 pFlag←{0::⍵ ⋄ pFlag}0   ⍝ pFlag: 1- surround complex numbers with parens; 0- don't.

 ⍝ Build complex number pattern cP
 rP←'(¯? (?: \d+ (?: \.\d+ )?)(?: [eE] ¯?\d+ )?)'
 cP←' '~⍨rP,'(?: [jJ]',rP,')'

 ⍝ Build replacement of realJimag as real+imagI w/ optional parens
 cR←pFlag{⍺:'(',')',⍨⍵ ⋄ ⍵}'\1+\2i'

 out←↑cP ⎕R cR⊣↓⎕FMT in
