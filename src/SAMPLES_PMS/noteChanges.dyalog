 res←noteChanges args;∆;STATICnm;list
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

 STATICnm←'ø.noteChanges'    ⍝ Choose a "private" namespace...

 :If args≡'⎕EX' ⋄ res←{9=⎕NC ⍵:⎕EX ⍵ ⋄ 0}STATICnm ⋄ :Return ⋄ :EndIf

 ∆←STATICnm{0≠⎕NC ⍺:⍎⍺ ⋄ ⍎⍺ ⎕NS'List'⊣List←⍵}⍬

 :Select ⍬⍴⎕NC'args'
 :Case 9 ⍝ Trigger (no result)
     ∆.List,←⊂args.Name
 :Case 2 ⍝ Explicit: ns ← ∇ 'ns'
     list←{∪⍣⍵⊣∆.List}
     :Select 819⌶args
     :CaseList 'ns' 'namespace'
         res←∆
     :Case 'list'
         res←list 0
     :Case 'unique'
         res←list 1
     :EndSelect
 :EndSelect
