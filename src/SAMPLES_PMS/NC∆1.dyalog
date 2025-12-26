 NC∆1←{
     ⍺←⎕THIS
     STATICnm←'ø.noteChanges'    ⍝ Choose a "private" namespace...

     '⎕EX'≡⍵:⍺.{9=⎕NC ⍵:⎕EX ⍵ ⋄ 0}STATICnm
     me←'NC∆1'
     '⎕SOURCE'≡⍵:('res←∆NCtrigger args;',me)':implements trigger *',(⎕NR me),⊂'res←',me,' ',' args'


     STATIC←⍺{0≠⍺.⎕NC ⍵:⍺⍎⍵ ⋄ ⍺⍎⍵ ⍺.⎕NS'List'⊣List←⍬}STATICnm

     ncw←⎕NC'⍵'
     list←{∪⍣⍵⊣STATIC.List}

     ncw=9:STATIC.List,←⊂⍵.Name  ⍝ Trigger (Implicit calls)
     ncw≠2:⎕SIGNAL 11
     opt←819⌶⍵                   ⍝ Explicit calls
     'init'≡opt:STATIC.List←⍬⊣_←⍺.⎕FX ∇'⎕SOURCE'
     'ns' 'namespace'∊⍨⊂opt:STATIC
     'list'≡opt:list 0
     'unique'≡opt:list 1
     'clear'≡opt:STATIC.List←⍬
     ⎕SIGNAL/('NC∆1: ',⎕DMX.EM)⎕DMX.EN
 }
