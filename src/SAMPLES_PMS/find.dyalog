 find←{
     ⍺←{∪{(':'≠⍵)⊆⍵}'.:',1↓∊':',¨{⊢2 ⎕NQ'.' 'GetEnvironment'⍵}¨⍵}'FSPATH' 'WSPATH'

     0=≢⍺:''

     pfx←(⊃⍺),'/',⍵
     ⎕NEXISTS full←pfx,'.dyapp':⍵ full(⊃⎕NGET full 1)
     ⎕NEXISTS full←pfx,'.dyalog':⍵ full(⊃⎕NGET full 1)

     (1↓⍺)∇ ⍵
 }
