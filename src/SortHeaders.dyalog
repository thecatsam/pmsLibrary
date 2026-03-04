 msg←{ref}SortHeaders name;⎕IO
 ;before;err;fmtName;fn;fns;header;headerNames;inter;lines;locals;localsLineNo;localsLineNos;src;syntax;∆NR
⍝ Function to sort the local variables in function headers
⍝ Will remove the function arguments variable(s) from the local names.

 ⎕IO←0 ⍝ to match ⎕S

⍝ Add the calling namespace of name if absent.
 ref←⎕VGET⊂'ref'(⊃⎕RSI)

⍝ Prepend formatted ns path unless absolute
 fmtName←((⍱/'#⎕'∊name)/ref⍕⍛,'.'),name

⍝ Check if the name exists
 ⎕SIGNAL(3.1 4.1 9.1∊⍨42 ref.⎕ATX name)↓⊂(
     'EN' 6
     ('Message'
         '"',fmtName,'" does not exist')
 )

⍝ if namespace, extract tradfn/tradop names
 :If 9=40 ref.⎕ATX name
     fns←(name,'.')∘,¨(ref ⎕VGET name).⎕NL-3.1 4.1
 :Else
     fns←⊂name
 :EndIf

⍝ Nested representation of name
 src←62 ref.⎕ATX name

 :For fn :In fns
⍝ Extract function source
     (before lines)←54 55 ref.⎕ATX fn
     ∆NR←lines↑before↓src

     header←⊃∆NR
     localsLineNos←0,'^\s*;'⎕S 2⊢∆NR ⍝ header + any that begins with ;

     headerNames←~⍤∊∘'∇{}()← '⍛⊆'[;⍝]+'⎕R''⊢header
     :For localsLineNo :In localsLineNos
         (syntax locals)←2↑'^[^;⍝]*' '.+'⎕S'&'⊢localsLineNo⊃∆NR
         (localsLineNo⊃∆NR)←syntax,∊';',¨⊂⍤⍋⍛⌷headerNames~⍨∪';'∘≠⍛⊆locals~' '
     :EndFor

⍝ To put a single space around the ← ,= ,≠ when not within quotes or comments
     ∆NR←'''[^'']*''|⍝.*' '\s*([←=≠])\s*'⎕R'&' ' \1 '⊢∆NR

⍝ Remove the trailing blanks
     ∆NR←' +$'⎕R''⊢∆NR

⍝ Put back where it came from
     (lines↑before↓src)←∆NR
 :EndFor

 err←⊂('EN' 11)('Message' ⋄ 'Error fixing "',fmtName,'"')
⍝ Fix the function
 :Trap 11
     inter←∊2 ref.⎕FIX src ⍝ ⎕FIX Will keep the white space
     ⎕SIGNAL err↓⍨inter≡name
 :Else
     ⎕SIGNAL
 :EndTrap
 msg←(⊃⎕SI),': Success fixing: "',fmtName,'"'
