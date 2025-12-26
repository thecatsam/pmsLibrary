 reqRecursive←{
 ⍝ - Look in object (a set of lines) and
 ⍝   replace regex '^\h*⍝::require xxx (xxx a valid arg to ]require)
 ⍝   with a call to ]require -R xxx
 ⍝ -     rcList@IV ← reqRecursive object@SVV|SM
 ⍝ - The directive is preprocessed, i.e.
 ⍝   will be called unconditionally (i.e. Dyalog :IF stmts etc are ignored).
 ⍝ - Returns 1 for each ⍝::require found and successfully processed;
 ⍝           0 for each ⍝::require found, but unsuccessfully processed.
 ⍝   or ⍬ if no ⍝::require directives found.

 ⍝::require fred jack ted
     0::⎕SIGNAL/'reqRecursive: recursive scan for ⍝::require behaved unexpectedly' 911
     {⎕SE.UCMD'require -o=b -R ',⍵}¨'^\h*⍝::require\h*(.*)$'⎕S'\1'⊣{2=⍴⍴⍵:↓⍵ ⋄ ⍵}⍵

 }
