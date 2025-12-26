 div_decorator←{
     ⍝ APL equivalent to Python decorators...
     ⍝ Example:  div← {⍺←⊢ ⋄ ⍺÷⍵} div_decorator
     ⍺←⊢
     divfix←{⍺←⊢ ⋄ ⎕←⍵ ⋄ inf←⌊/⍬ ⋄ 0≡⍺ 0:inf ⋄ inf××⍺}
     overflow←'@The result of division is too large. Fix up: making result +- infinity.'
     divbyzero←'@Dividing by 0. Fix up: making ⍵ smallest positive number.'

     11::{⍺←⊢
         ⍵:⍺ divfix overflow
         ⎕SIGNAL/⎕DMX.((EM,⍨'@')EN)
     }⎕DMX.ENX=1

     ⍵≠0:⍺ ⍺⍺ ⍵

     ⍺ divfix divbyzero

 }
