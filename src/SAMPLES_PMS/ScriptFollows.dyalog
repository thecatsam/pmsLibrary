 lines←ScriptFollows
 ;what;howMuch;where;⎕IO
⍝ Treat following commented lines in caller as a script, lines beginning with ⍝⍝ are stripped out
 howMuch←1+1⊃⎕LC⊣where←0⊃⎕RSI⊣what←1⊃⎕SI⊣⎕IO←0
 lines←{
     ⍵/⍨'⍝'≠⊃¨⍵                                  ⍝ Omit ⍝⍝ Comments
 }{
     1↓¨⍵/⍨∧\'⍝'=⊃¨⍵                             ⍝ Code in Comments only
 }{
     ⍵↓⍨+/∧\' '=⍵                                ⍝ No leading blanks
 }¨{
     {
         ⍵↓⍨-+/∧\' '=⌽⍵                          ⍝ No trailing blanks
     }¨howMuch↓↓where.(180⌶)what                 ⍝ Class Method (returns mx)
 }⍣(0=≢lines)⊣howMuch↓lines←where.⎕NR what       ⍝ (External) Function (returns char vectors)
