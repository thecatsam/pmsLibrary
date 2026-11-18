Nonce←{
    cdB cdE←'<code>' '</code>'
    x←⊃⎕NGET'gmpz/README.md' 1

    x←'^\h*\|([^|]+|\\|)+\|'⎕R{'`[^`]+`'⎕R{cdB,cdE,⍨1↓¯1↓'\h'⎕R'\&nbsp;'⊣⍵.Match}⍵.Match}x

   ⍝ ⎕ED'x'

    (⊂x)⎕NPUT'gmpz/README.md' 1
}
