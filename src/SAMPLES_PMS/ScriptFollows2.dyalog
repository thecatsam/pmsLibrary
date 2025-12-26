 lines←ScriptFollows3
 lines←{howMuch←1+1⊃⎕LC⊣where←0⊃⎕RSI⊣what←1⊃⎕SI⊣⎕IO←0⋄{{⌽(∨\' '≠⍵)/⍵}¨↓⌽{⍵⌿⍨∊'⍝'≠1↑⍤1⊣⍵}{1↓[1]⍵⌿⍨∧\∊'⍝'=1↑⍤1⊣⍵}⍵⌽⍨+/∧\' '=⍵}howMuch↓{where.(180⌶)what}⍣(0=≢lines)⊣lines←where.⎕CR what}0
