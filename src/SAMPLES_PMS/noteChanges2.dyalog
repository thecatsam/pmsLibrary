 res←noteChanges2 args;_∆NC2
 ⍝ Mixed tradfn, dfn version

 :Implements Trigger *

 ⍝ Explicit calls:
 ⍝  ∘ noteChanges 'ns'  (case ignored)
 ⍝        Returns reference to __noteChanges__ namespace containing
 ⍝              List:    the list of changed objects (with duplicates, if any)
 ⍝        creating __noteChanges__ if it does not exist.
 ⍝  ∘ noteChanges 'unique'
 ⍝       Returns the current list of unique object names in order received
 ⍝  ∘ noteChanges 'list'
 ⍝       Returns the current list of object names in order received
 ⍝  ∘ noteChanges '⎕EX'
 ⍝        Expunges the __noteChanges__ namespace
 ⍝        Returns 1  if it was present AS a namespace and expunged; 0 otherwise.
 ⍝ Implicit calls (via Trigger):
 ⍝  ∘ Adds each changed object to __noteChanges__.List, then
 ⍝    creating __noteChanges__ if it does not exist.

 _∆NC2←{
     STATICnm←'ø.noteChanges'    ⍝ Choose a "private" namespace...

     '⎕EX'≡⍵:{9=⎕NC ⍵:⎕EX ⍵ ⋄ 0}STATICnm
     '⎕SOURCE'≡⍵:'res←∆NCtrigger args;_∆NC2' ':implements trigger *',(⎕NR'_∆NC2'),⊂'res←_∆NC2 args'


     STATIC←STATICnm{0≠⎕NC ⍺:⍎⍺ ⋄ ⍎⍺ ⎕NS'List'⊣List←⍵}⍬

     ncw←⎕NC'⍵'
     list←{∪⍣⍵⊣STATIC.List}

     ncw=9:STATIC.List,←⊂⍵.Name  ⍝ Trigger (Implicit calls)
     ncw≠2:⎕SIGNAL 11
     opt←819⌶⍵                   ⍝ Explicit calls
     'ns' 'namespace'∊⍨⊂opt:STATIC
     'list'≡opt:list 0
     'unique'≡opt:list 1
     ⎕SIGNAL 11
 }

 :Trap 999
     res←_∆NC2 args
 :Else
     ⎕DMX.EN ⎕SIGNAL⍨'noteChanges ',⎕DMX.EM
 :EndTrap
