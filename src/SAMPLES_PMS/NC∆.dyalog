 NC∆←{
   ⍝ NC∆: "Nameclass delta"
   ⍝ Looks at list of objects that have changed since the last call in a namespace ⍵[0].
   ⍝ For functions/ops, will also note those that have a different timestamp
   ⍝ Normally, looks only at fns, ops, and namespaces
   ⍝ Can be overridden with a 2nd right arg ⍵[1] (or args ⍵[2 3 ...]) with object types (floats/ints)
   ⍝ To compare only what's different (otherwise everything is new)!
   ⍝
   ⍝ I. Create baseline for fns and ops in namespace UPDATE
   ⍝      base ← NC∆ UPDATE 3 4      ⍝ or (3 4)
   ⍝      ... ⍝ Change existing objects and add new ones
   ⍝ II. Determine updates: new, changed, removed objects compared to baseline
   ⍝      added changed removed ← NC∆ base [1: keep]     ⍝ Gets namespace and classes from <base>
   ⍝            keep: continue to have Trigger monitor for changes in variables (default: don't).

 ⍝ Bugs: changes to existing objects can't be detected except for fns/ops
     ⎕IO←0
     ⍺←⎕NS''  ⍝ To hide all the objects move names out of # even if newObjs is there.!
     ⍺.theKeyword←⊂'__NC∆_OBJECT__'

     ⍺._∆NC2←{
         ⍺←⎕THIS
         STATICnm←'ø.noteChanges'    ⍝ Choose a "private" namespace...

         '⎕EX'≡⍵:⍺.{9=⎕NC ⍵:⎕EX ⍵ ⋄ 0}STATICnm
         '⎕SOURCE'≡⍵:'res←∆NCtrigger args;_∆NC2' ':implements trigger *',(⎕NR'_∆NC2'),⊂'res←_∆NC2 args'


         STATIC←⍺{0≠⍺.⎕NC ⍵:⍺⍎⍵ ⋄ ⍺⍎⍵ ⍺.⎕NS'List'⊣List←⍬}STATICnm

         ncw←⎕NC'⍵'
         list←{∪⍣⍵⊣STATIC.List}

         ncw=9:STATIC.List,←⊂⍵.Name  ⍝ Trigger (Implicit calls)
         ncw≠2:⎕SIGNAL 11
         opt←819⌶⍵                   ⍝ Explicit calls
         'init'≡opt:STATIC.List←⍬⊣_←⍺.⎕FX _∆NC2'⎕SOURCE'
         'ns' 'namespace'∊⍨⊂opt:STATIC
         'list'≡opt:list 0
         'unique'≡opt:list 1
         'clear'≡opt:STATIC.List←⍬
         ⎕SIGNAL 11
     }

     ⍺.create_baseline←{
         typeErr←'NC∆ baseline syntax: ∇ namespace [ [nc1 nc2 ...] ]' 11
         myNs←0⊃⍵
         _←myNs _∆NC2'init'
         types←(2 3 9.1){0=≢⍵:⍺ ⋄ ⍵}0~⍨0,∊1↓⍵
         0∊(⌊types)∊⍳10:⎕SIGNAL/typeErr
         old←∪myNs.⎕NL-types

         theKeyword old(↓myNs.⎕AT old)myNs types
     }∘,
     ⍺.whats_new←{
         badObjErr←'NC∆ update syntax: right arg not result returned by NC∆ baseline call' 11
         0::⎕SIGNAL/badObjErr
         (kw old old_attr myNs types)keep←{2=≢⍵:⍵ ⋄ ⍵ 0}⍵
         theKeyword≢kw:∘err∘

         addedTrigger←keep{⍺←0
             0::⍬⊣⎕←'NC∆: Trigger data not present (trigger terminated by user)'
             l←myNs _∆NC2'unique'
             ⍺:l
             l⊣myNs _∆NC2'⎕EX'
         }0

         cur←∪myNs.⎕NL-types
         added←cur~old
         removed←old~cur
         changed←removed~⍨old/⍨old_attr[⍳≢old]≢¨↓myNs.⎕AT old
         ⋄ addT←addedTrigger~removed
         ⋄ added,←addT
         ⋄ changed~←added
         added changed removed
     }
     ⍺.isNs←{0::0 ⋄ ⍵∊# ⎕SE:1 ⋄ 9.1=⎕NC⊂,'⍵'}    ⍝ Returns 1 for namespaces, # or ⎕SE

     ⍺.isNs⊃⍵:⍺.create_baseline ⍵         ⍝ baseline if 1st elem of ⍵ is a namespace
     ⍺.whats_new ⍵                        ⍝ update otherwise (5 items starting with theKeyword)

 }
