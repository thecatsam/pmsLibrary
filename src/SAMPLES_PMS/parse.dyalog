 parse←{
     ⍝ ⍺: opts (by default)-- each a string or namespace
     ⍝ ⍵: parms
     ⍝ If ⍺ omitted, ⍵ must be a string
     ⍝ opts: Each token is a separate APL string or namespace
     ⍝  force:          -f                          0
     ⍝  debug:          -d                          0
     ⍝  callerNs:       -c nsRef|nsStr              (the actual caller)
     ⍝  defaultLib:     -l nsRef|nsStr              ⍙⍙.require *
     ⍝                  nsRef                       **
     ⍝  outputParms:    -o  's'|'d'|'sd'            'sd'
     ⍝  ends opt list:  --
     ⍝ ----------------------
     ⍝ *  The defaultLib is by default within (prefixed with) the callerNs.
     ⍝ ** A simple nsRef by itself (# but not '#') is treated as -l nsRef.

     ⍺←⎕NULL

     force debug out caller lib←0 0 0 ⍬ ⍬
     monad opts args←⍺{
         ⍺≡⎕NULL:1(' '(≠⊆⊢)⍵)⍵
         0 ⍺ ⍵
     }⍵

     is←{⍵≡⍺↑⍨≢⍵}
     _←{
         ⍵≥≢opts:1
         o←⍵⊃opts ⋄ next skip←⍵+1 2
         3::('require: value for option ',o,' missing')⎕SIGNAL 11

         9=⎕NC'o':∇ next⊣lib∘←o
         o is'-f':∇ next⊣force∘←1
         o is'-d':∇ next⊣debug∘←1
         o is'-c':∇ skip⊣caller∘←next⊃opts
         o is'-l':∇ skip⊣lib∘←next⊃opts
         o is'-o':∇ skip⊣out∘←{(2×'s'∊⍵)+('d'∊⍵)}next⊃opts
         o is'--':1⊣args∘←next↓opts
         monad:1⊣args∘←⍵↓opts
         'require: invalid option(s) found'⎕SIGNAL 11
     }0
     result←force debug out caller lib args
     ~debug:result
     ⎕←'force  'force ⋄ ⎕←'debug  'debug
     ⎕←'out    'out ⋄ ⋄ ⎕←'caller 'caller
     ⎕←'lib    'lib ⋄ ⋄ ⎕←'args  'args
     result
 }
