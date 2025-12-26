 r←mandelbrot;⎕IO;ch
 ⍝ http://www.dyalog.com/blog/2014/08/isolated-mandelbrot-set-explorer/
 ⎕IO←0
 ch←'∘'
 r←(¯2↑ch)[9>|⊃{⍺+⍵*2}/9⍴⊂¯3×0.7J0.5-⍉a∘.+0J1×a←(⍳n+1)÷n←98]
