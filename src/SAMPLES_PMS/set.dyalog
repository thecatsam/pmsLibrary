 set←{⍺←⊢
   ⍝ A range of "set" functions that always return results in TAO (sorted) order.
   ⍝ 2adic: (im)proper subset, (im)proper superset, union, intersection, without, equals, not equals
   ⍝ 1adic: canonical (⊢ or ∪)

     err←⎕SIGNAL∘11
     0::⎕SIGNAL/⎕DMX.(EM EN)
     sort←{(⊂⍋⍵)⌷⍵}
     aa←⍺⍺
     3≠⎕NC'aa':err'set: left operand (⍺⍺) must be a function'
     fn←{1=≢⍵:⍬⍴⍵ ⋄ ⍵≡'⊂=':'≤' ⋄ ⍵≡'⊃=':'≥' ⋄ err'Invalid function combination: ',⍵}⎕NR'aa'

     monad←⍵≡⍺ ⍵
     monad:{
         fn∊'∪⊢⊣':sort ⍵
         err'set: Not defined: monadic ',fn
     }∪⍵

     fn∊'>⊃':⍵(<∇∇)⍺
     fn='≥':⍵(≤∇∇)⍺
     '∪'≡fn:sort ⍺∪⍵
     '∩'≡fn:sort ⍺∩⍵
     '~'≡fn:sort ⍺~⍵
     (sort∪⍺){
         fn∊'≡=':⍺≡⍵
         fn∊'≢≠':⍺≢⍵

         sub←⍺≡(⍴⍺)⍴⍵
         fn∊'<⊂':sub∧(≢⍺)≠≢⍵
         fn∊'≤⊆':sub∧(≢⍺)≤≢⍵
         err'set: Not defined: dyadic ',fn
     }sort∪⍵
 }
