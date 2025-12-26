 ns←decl ∆OPT args;NL;d;def;defFlag;hasDef;longType;name;ns;pat;type
 ⍝
 ns←⎕NS'' ⋄ NL←⎕UCS 10
 ⍝ types:
 ⍝   A Any, B Boolean, I Integer, N Number, C Char, S String, R Reference (Namespace Ref or String)
 :For d :In ⊆decl
     pat←'-?([\w∆⍙]+)((?:@[\w∆⍙]+)?)(?|((\?).*)|(()))'
     name type def hasDef←pat ⎕R'\1\n\2\n\3\n\4\n'⊣⊆d
     type def←1↓¨type def ⋄ hasDef←≢hasDef ⋄ type←(0=≢type)⊃type'A'
     longType←('ABINCSR'⍳type)⊃'Any' 'Boolean' 'Integer' 'Number' 'Char' 'String' 'Reference' 'Unknown'
     defFlag←hasDef⊃'no def' 'has def'
     d name type longType defFlag def
 :EndFor
