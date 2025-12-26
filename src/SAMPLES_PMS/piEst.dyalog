 piEst←{
   ⍝ Monte Carlo estimator for pi: based on <n> throws at a dartboard.
   ⍝ Call:         res ← piEst n [n2 n3... nN]
   ⍝ Returns res:  estimate for pi, absolute error, relative error
   ⍝
     1<≢⍵:↑∇¨⍵

     n←⍵
     ⎕PP←34 ⋄ ⎕IO←0 ⋄ ⎕DCT←⎕CT←0

     chunkSize←10000                  ⍝ Chunk tries for very large n
     hits←{
         hits n_left n_zeros←⍵
         x y←?n_zeros n_zeros         ⍝ Randomly throw dart at unit square.
         h2←⊃+/2*⍨x y                 ⍝ Determine (square of) hypotenuse of each point.
         hits+←+/1≥h2                 ⍝ Note hits:  # of points within the unit circle.

         n_left-←chunkSize
         n_left≤0:hits
         n_left<chunkSize:∇ hits n_left(n_left⍴0)    ⍝  Recalculate n_zeros as few times as possible.
         ∇ hits n_left n_zeros
     }0 n(0⍴⍨chunkSize⌊n)

     pi_true←○1
     pi_est←n÷⍨4×hits
     error_rel←pi_true÷⍨error_abs←pi_est-pi_true
     mag←⌊0.5+|10⍟error_rel

     pi_est error_abs error_rel mag
 }
