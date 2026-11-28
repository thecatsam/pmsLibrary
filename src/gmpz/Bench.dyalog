:Namespace

⍝ GmpzBench — benchmark standard gmpz methods vs GI calls, vector lengths 1..n.
⍝ Requires gmpz loaded (]load gmpz/gmpz). Paste-and-check: not run in Dyalog by Muse.
⍝
⍝ Call:  GmpzBench n
⍝        (bits minMs maxTot) GmpzBench n
⍝   n       max vector length (benchmarks lengths 1..n)
⍝   bits    operand size in bits                 (default 256)
⍝   minMs   target minimum ms per measure        (default 100)
⍝   maxTot  cap on total ops per measure         (default 10000)
⍝ Returns a namespace with lens, ops, std, gi (ms for L ops), ratio (gi÷std),
⍝ and the bits/minMs/maxTot used. Plots ratio vs length (one line per op, in
⍝ ops order); re-plot absolute times from std/gi if you prefer.
⍝
⍝ Method: for each op and length L, tot = L×reps fresh operand pairs are
⍝ prepared (not timed), then the op is applied to all of them in one timed
⍝ interval, doubling reps until the interval reaches minMs (so the measured
⍝ time is far above the millisecond timer resolution) or tot reaches maxTot.
⍝ No resets and no baseline subtraction: the timed interval is pure apply.
⍝ Operands are freed before the next (larger) batch, and results are
⍝ discarded immediately, so live instances stay bounded by one batch.
⍝ Timing uses ⎕AI[2] (connect/wall time at ⎕IO←0), because ⎕AI[1] CPU time
⍝ does not include time spent in ⎕NA/GMP calls. Standard methods are in
⍝ place; GI allocates a fresh result per call — that allocation gap is what
⍝ the benchmark exposes. The gmpz RNG is reseeded (RandSeed 12345) so
⍝ operands are reproducible.

∇ res←{opts} GmpzBench n ; ⎕IO; ⎕ML; bits; minMs; maxTot; lens; ops; std; gi; ratio; TimeOp; MakeOperands; ApplyOperands; MakeTemplate; x; y; d; exp; mod; powExp; shiftAmt
  ⎕IO←0 ⋄ ⎕ML←1
  :If 900⌶⍬ ⋄ opts←256 100 10000 ⋄ :EndIf
  bits minMs maxTot←opts
  lens←1+⍳n
  ops←'Add' 'Mul' 'Div' 'DivRem' 'Pow' 'PowM' 'ShiftL' 'ShiftR' 'Gcd' 'Res'
  std←(≢ops) n⍴0 ⋄ gi←(≢ops) n⍴0

  ⍝ Operand templates: bits-bit values with the leading bit set (non-zero, full size).
  gmpz.RandSeed 12345
  MakeTemplate←{(2*GI (⍵-1)) +GI (?GI -(⍵-1))}
  x←MakeTemplate bits ⋄ y←MakeTemplate bits ⋄ d←MakeTemplate ⌈bits÷2 ⋄ exp←MakeTemplate bits ⋄ mod←MakeTemplate bits
  powExp←16 ⋄ shiftAmt←64

  ⍝ Timer. MakeOperands(tot)→tot fresh operand pairs; ApplyOperands(operands)
  ⍝ applies the op to all of them once, discarding results (returns ⍬).
  ⍝ TimeOp(L)→ms for L ops: time one batch of tot=L×reps ops as a single
  ⍝ interval, doubling reps until the interval reaches minMs or tot reaches
  ⍝ maxTot; report el÷reps. Operands are freed before recursing.
  ⍝ (⎕AI[2] is connect/wall time in ms at ⎕IO←0.)
  TimeOp←{
      L←⍵
      Go←{
          reps←⍵
          tot←L×reps
          operands←MakeOperands tot
          t0←⎕AI[2]
          sink←ApplyOperands operands
          el←(⎕AI[2])-t0
          operands←⍬
          (el≥minMs)∨(tot≥maxTot): el÷reps
          ∇ reps×2
      }
      Go 1
  }

  ⎕←'Add'
  MakeOperands←{(gmpz.New¨ ⍵⍴⊂x) (gmpz.New¨ ⍵⍴⊂y)}
  ApplyOperands←{dest sv←⍵ ⋄ dest {⍺.Add ⍵}¨ sv ⋄ ⍬}
  std[0;]←TimeOp¨ lens
  ApplyOperands←{xv sv←⍵ ⋄ xv +GI¨ sv ⋄ ⍬}
  gi[0;]←TimeOp¨ lens

  ⎕←'Mul'
  ApplyOperands←{dest sv←⍵ ⋄ dest {⍺.Mul ⍵}¨ sv ⋄ ⍬}
  std[1;]←TimeOp¨ lens
  ApplyOperands←{xv sv←⍵ ⋄ xv ×GI¨ sv ⋄ ⍬}
  gi[1;]←TimeOp¨ lens

  ⎕←'Div'
  MakeOperands←{(gmpz.New¨ ⍵⍴⊂x) (gmpz.New¨ ⍵⍴⊂d)}
  ApplyOperands←{dest sv←⍵ ⋄ dest {⍺.Div ⍵}¨ sv ⋄ ⍬}
  std[2;]←TimeOp¨ lens
  ApplyOperands←{xv sv←⍵ ⋄ xv ÷GI¨ sv ⋄ ⍬}
  gi[2;]←TimeOp¨ lens

  ⎕←'DivRem'
  ApplyOperands←{dest sv←⍵ ⋄ dest {⍺.DivRem ⍵}¨ sv ⋄ ⍬}
  std[3;]←TimeOp¨ lens
  ApplyOperands←{xv sv←⍵ ⋄ xv ÷∘|GI¨ sv ⋄ ⍬}
  gi[3;]←TimeOp¨ lens

  ⎕←'Pow'
  MakeOperands←{gmpz.New¨ ⍵⍴⊂x}
  ApplyOperands←{⍵.Pow¨ powExp ⋄ ⍬}
  std[4;]←TimeOp¨ lens
  ApplyOperands←{⍵ *GI¨ powExp ⋄ ⍬}
  gi[4;]←TimeOp¨ lens

  ⎕←'PowM'
  ApplyOperands←{{⍵.PowM (exp mod)}¨ ⍵ ⋄ ⍬}
  std[5;]←TimeOp¨ lens
  ApplyOperands←{{⍵ *∘|GI (exp mod)}¨ ⍵ ⋄ ⍬}
  gi[5;]←TimeOp¨ lens

  ⎕←'ShiftL'
  MakeOperands←{(gmpz.New¨ ⍵⍴0) (gmpz.New¨ ⍵⍴⊂x)}
  ApplyOperands←{dest val←⍵ ⋄ dest {shiftAmt ⍺.Shift ⍵}¨ val ⋄ ⍬}
  std[6;]←TimeOp¨ lens
  MakeOperands←{gmpz.New¨ ⍵⍴⊂x}
  ApplyOperands←{shiftAmt ⌽GI¨ ⍵ ⋄ ⍬}
  gi[6;]←TimeOp¨ lens

  ⎕←'ShiftR'
  MakeOperands←{(gmpz.New¨ ⍵⍴0) (gmpz.New¨ ⍵⍴⊂x)}
  ApplyOperands←{dest val←⍵ ⋄ dest {(-shiftAmt) ⍺.Shift ⍵}¨ val ⋄ ⍬}
  std[7;]←TimeOp¨ lens
  MakeOperands←{gmpz.New¨ ⍵⍴⊂x}
  ApplyOperands←{(-shiftAmt) ⌽GI¨ ⍵ ⋄ ⍬}
  gi[7;]←TimeOp¨ lens

  ⎕←'Gcd'
  MakeOperands←{(gmpz.New¨ ⍵⍴⊂x) (gmpz.New¨ ⍵⍴⊂y)}
  ApplyOperands←{dest sv←⍵ ⋄ dest {⍺.Gcd ⍵}¨ sv ⋄ ⍬}
  std[8;]←TimeOp¨ lens
  ApplyOperands←{xv sv←⍵ ⋄ xv ∨GI¨ sv ⋄ ⍬}
  gi[8;]←TimeOp¨ lens

  ⎕←'Res'
  MakeOperands←{(gmpz.New¨ ⍵⍴0) (gmpz.New¨ ⍵⍴⊂x)}
  ApplyOperands←{dest val←⍵ ⋄ dest {d ⍺.Res ⍵}¨ val ⋄ ⍬}
  std[9;]←TimeOp¨ lens
  MakeOperands←{gmpz.New¨ ⍵⍴⊂x}
  ApplyOperands←{d |GI¨ ⍵ ⋄ ⍬}
  gi[9;]←TimeOp¨ lens

  ratio←gi÷std+0=std
  res←() ⎕NS 'lens' 'ops' 'std' 'gi' 'ratio' 'bits' 'minMs' 'maxTot'

  ⍝ Plot ratio vs length (rows = ops, in ops order). Best-effort; data is in res.
  :Trap 0
      #.gmpzBenchRatio←ratio
      ⎕SE.UCMD 'Plot #.gmpzBenchRatio'
  :EndTrap
  ⎕EX '#.gmpzBenchRatio'
∇
⎕DF ##.⎕FX ⎕NR 'GmpzBench'
:EndNamespace
