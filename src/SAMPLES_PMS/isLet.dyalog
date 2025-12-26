 (is isnt)←isLet lets;l
 ⍝ Returns two vectors (is isnt):
 ⍝     is:   letters in <lets> that are in pcre regexp list for Unicode
 ⍝     isnt: ditto, are not in pcre...
 is←isnt←⍬

 :For l :In lets
     :If ×≢'\pL'⎕S 0⍠('UCP' 1)⊣l
         is,←l
     :Else
         isnt,←l
     :EndIf
 :EndFor
 is isnt←{⍵⌷⍨⊂⍋⍵}¨is isnt
