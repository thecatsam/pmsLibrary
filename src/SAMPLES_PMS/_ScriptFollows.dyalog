 l←ScriptFollows∆Code
 l←'{ dlb←{(+/∧\' '=⍵)↓⍵}⋄l←w.⎕NR n⊣h←1+1⊃⎕LC⊣w←1⊃⎕RSI⊣n←1⊃⎕SI⊣⎕IO←0'
 l,←'⋄{⍵/⍨''⍝''≠⊃¨⍵}{1↓¨⍵/⍨∧\''⍝''=⊃¨⍵}dlb¨{0≠≢l:⍵ ⋄ ⌽∘dlb∘⌽¨h↓↓w.(180⌶)n}h↓l}0'
 ⍝ May be substituted in place...
