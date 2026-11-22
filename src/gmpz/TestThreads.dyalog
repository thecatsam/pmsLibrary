:Namespace TestThreads

⍝ This is file: gmpz/TestThreads.dyalog

⍝ Load gmpz at top level, if not there.
∇ ok←LoadGmpz
  :If ok←0= #.⎕NC 'gmpz'
      ⎕← #.⎕FIX 'gmpz/gmpz.dyalog'
  :EndIf
  gmpz←#.gmpz
∇
LoadGmpz

∇ RunAll ; line
  line← '========================================================================='

  line
  ⎕←'Testing for correctness and race conditions'
  line
  ''
  ⎕← RaceConditions (100 200)
  ''
  ''
  line
  ⎕←'Testing for Efficiency and Lock Contention'
  line
  ''
  ⎕← Contention
  ''
∇

⍝ =========================================================================
⍝ 1. CORRECTNESS & RACE-CONDITION SUITE
⍝ =========================================================================

∇ r←RaceConditions(nThreads nIters);serial;workers;ok;results;okShared;okDeadlock;okGI
  ⎕←'1A. Scratch-buffer race test:' nThreads 'threads x' nIters 'iterations...'
  ⍝ Serial baseline: deterministic chain forcing string & integer scratch conversion
  serial←Worker nIters
  ⍝ Spawn concurrent threads all competing for the class-level :Hold
  workers←Worker&¨nThreads⍴nIters
  results←⎕TSYNC workers
  ok←∧/results≡¨⊂serial

  ⎕←'1B. Shared-instance mutation & limb-realloc test: 50 threads x' nIters 'iterations...'
  okShared←TestSharedInstance 50 nIters

  ⎕←' 1C. Multi-operand AB-BA deadlock safety test: 2 threads x 2000 iterations...'
  okDeadlock←TestDeadlockSafety 2000

  ⎕←'1D. Lock-free GI operator concurrency test: 50 threads x' nIters 'iterations...'
  okGI←TestGIThreads 50 nIters

  :If ok∧okShared∧okDeadlock∧okGI
      r←'All correctness & race-condition checks passed!'
  :Else
      r←'FAILED — Scratch:',ok,' SharedInstance:',okShared,' Deadlock:',okDeadlock,' GI:',okGI
  :EndIf
∇

∇ ok←TestGIThreads(nThreads nIters);serial;workers;results;GI
  GI←#.GI
  serial←GIWorker nIters
  workers←GIWorker&¨nThreads⍴nIters
  results←⎕TSYNC workers
  ok←∧/results≡¨⊂serial
∇

∇ res←GIWorker nIters;GI;x;y;q;r;i
  GI←#.GI
  x←gmpz.New '123456789012345678901'
  y←gmpz.New 7
  :For i :In ⍳nIters
      x←(x +GI '100000000000000000000') -GI (-GI y)
      (q r)←x ÷∘|GI (i+3)
      x←(q ⌈GI y) +GI (r ×GI (i+2))
  :EndFor
  res←(⌷x) (≢GI x) (16 ⊤GI x)
∇

∇ res←Worker nIters;acc;i
  acc←gmpz.New 1
  ⍝ Force scratch buffer 1, 2, and 3 usage via APL ints and numeric strings
  :For i :In ⍳nIters
      acc.Add i
      '100000000000000000000' acc.Add acc
      acc.Sub '99999999999999999999'
      (i+3) acc.Mul acc
      acc.Div (i+2)
  :EndFor
  res←⌷acc
∇

∇ ok←TestSharedInstance(nThreads nIters);serial;shared;workers;i
  ⍝ Serial baseline: exact sum of nThreads * nIters increments + 31-digit additions
  serial←gmpz.New 0
  :For i :In ⍳nThreads×nIters
      serial.Inc
      serial.Add '1000000000000000000000000000000'
  :EndFor

  ⍝ Concurrent workers all mutating the exact same gmpz instance
  shared←gmpz.New 0
  workers←shared∘SharedAdder&¨nThreads⍴nIters
  ⎕TSYNC workers

  ok←(⌷shared)≡⌷serial
∇

∇ {r}←shared SharedAdder iters;i
  :For i :In ⍳iters
      shared.Inc
      shared.Add '1000000000000000000000000000000'
  :EndFor
  r←1
∇

∇ ok←TestDeadlockSafety nIters;x;y;w1;w2
  x←gmpz.New '123456789012345678901234567890'
  y←gmpz.New '987654321098765432109876543210'

  ⍝ Thread 1 locks (y, x) while Thread 2 locks (x, y) in opposition
  w1←(x y)∘DeadlockWorkerA&nIters
  w2←(x y)∘DeadlockWorkerB&nIters
  ⎕TSYNC w1 w2
  ok←1
∇

∇ {r}←xy DeadlockWorkerA iters;x;y;i
  (x y)←xy
  :For i :In ⍳iters
      x y.Add x
      y x.Sub y
  :EndFor
  r←1
∇

∇ {r}←xy DeadlockWorkerB iters;x;y;i
  (x y)←xy
  :For i :In ⍳iters
      y x.Add y
      x y.Sub x
  :EndFor
  r←1
∇

⍝ =========================================================================
⍝ 2. EFFICIENCY & LOCK-CONTENTION BENCHMARKS
⍝ =========================================================================

∇ res←Contention
  ⍝ Convenience entry point running all contention & scaling suites
  ⎕←'--- A. Scratch Lock Contention (Pure gmpz vs. String/Int) ---'
  ⎕←BenchScratchContention (1 2 4 8) 20000
  ⎕←'--- B. Instance Lock Contention (Hot Shared vs. Sharded) ---'
  ⎕←BenchInstanceContention (1 2 4 8) 20000
  ⎕←'--- C. Heavy GMP Blocking (NextPrime vs. Scratch Ops) ---'
  ⎕←BenchLongHoldBlocking 4 5000
  ⎕←'--- D. Global RandState Contention ---'
  ⎕←BenchRandContention (1 2 4 8) 20000
  ⎕←'--- E. Multi-Core Isolate Scaling (4 Threads vs. 4 OS Isolates) ---'
  ⎕←BenchIsolateScaling 4 40
  res←'Benchmarks complete.'
∇

⍝ --- Benchmark A: Shared Scratch Buffer Lock Contention ---
∇ res←BenchScratchContention(threadCounts totalOps);n;opsPerThread;tGmpz;tScratch
  res←1 4⍴'Threads' 'Pure_gmpz_ms' 'Scratch_Hold_ms' 'Slowdown_Ratio'
  :For n :In threadCounts
      opsPerThread←⌊totalOps÷n
      tGmpz←TimeScratchThreads n opsPerThread 0
      tScratch←TimeScratchThreads n opsPerThread 1
      res⍪←n tGmpz tScratch (0.01×⌊0.5+100×tScratch÷1⌈tGmpz)
  :EndFor
∇

∇ ms←TimeScratchThreads(nThreads iters useScratch);t0;workers
  t0←NowMs
  workers←useScratch∘ScratchWorker&¨nThreads⍴iters
  ⎕TSYNC workers
  ms←(NowMs)-t0
∇

∇ {r}←useScratch ScratchWorker iters;acc;k1;k2;i
  acc←gmpz.New 1
  :If useScratch
      :For i :In ⍳iters
          '1000000000000000000000000000000' acc.Add acc
          acc.Sub '999999999999999999999999999999'
      :EndFor
  :Else
      k1←gmpz.New '1000000000000000000000000000000'
      k2←gmpz.New '999999999999999999999999999999'
      :For i :In ⍳iters
          k1 acc.Add acc
          acc.Sub k2
      :EndFor
  :EndIf
  r←1
∇

⍝ --- Benchmark B: Hot Shared Instance vs. Sharded Instances ---
∇ res←BenchInstanceContention(threadCounts totalOps);n;iters;tHot;tSharded;shared;t0;workers
  res←1 4⍴'Threads' 'Hot_Shared_ms' 'Sharded_ms' 'Contention_Ratio'
  :For n :In threadCounts
      iters←⌊totalOps÷n

      shared←gmpz.New 1
      t0←NowMs
      workers←shared∘HotWorker&¨n⍴iters
      ⎕TSYNC workers
      tHot←(NowMs)-t0

      t0←NowMs
      workers←ShardedWorker&¨n⍴iters
      ⎕TSYNC workers
      tSharded←(NowMs)-t0

      res⍪←n tHot tSharded (0.01×⌊0.5+100×tHot÷1⌈tSharded)
  :EndFor
∇

∇ {r}←shared HotWorker iters;step;i
  step←gmpz.New '123456789012345678901234567890'
  :For i :In ⍳iters
      shared.Add step
  :EndFor
  r←1
∇

∇ {r}←ShardedWorker iters;local;step;i
  local←gmpz.New 1
  step←gmpz.New '123456789012345678901234567890'
  :For i :In ⍳iters
      local.Add step
  :EndFor
  r←1
∇

⍝ --- Benchmark C: Long-Running C Calls Holding Locks ---
∇ res←BenchLongHoldBlocking(nBgThreads nFgIters);big;bgWorkers;t0;fgMs;baseMs
  t0←NowMs
  {}FgScratchTask nFgIters
  baseMs←(NowMs)-t0

  big←gmpz.New 2
  1536 big.Shift big
  bgWorkers←big∘BgHeavyTask&¨nBgThreads⍴40

  t0←NowMs
  {}FgScratchTask nFgIters
  fgMs←(NowMs)-t0

  ⎕TSYNC bgWorkers
  res←'Baseline_FG_ms' 'Under_Heavy_Load_ms' 'Ratio'⍪baseMs fgMs (0.01×⌊0.5+100×fgMs÷1⌈baseMs)
∇

∇ {r}←FgScratchTask iters;x;i
  x←gmpz.New 0
  :For i :In ⍳iters
      x.Add '98765432109876543210987654321'
  :EndFor
  r←1
∇

∇ {r}←big BgHeavyTask iters;p;i
  p←big.Copy
  :For i :In ⍳iters
      p.NextPrime p
  :EndFor
  r←1
∇

⍝ --- Benchmark D: Shared gmp_randstate_t Lock Contention ---
∇ res←BenchRandContention(threadCounts totalCalls);n;iters;t0;workers;ms
  res←1 3⍴'Threads' 'Elapsed_ms' 'Calls_Per_Sec'
  :For n :In threadCounts
      iters←⌊totalCalls÷n
      t0←NowMs
      workers←RandWorker&¨n⍴iters
      ⎕TSYNC workers
      ms←1⌈(NowMs)-t0
      res⍪←n ms (⌊1000×(n×iters)÷ms)
  :EndFor
∇

∇ {r}←RandWorker iters;z;i
  z←gmpz.New 0
  :For i :In ⍳iters
      z.RandB 256
  :EndFor
  r←1
∇

⍝ --- Benchmark E: Multi-Core Isolate Scaling (Threads vs. OS Isolates) ---
∇ res←BenchIsolateScaling(nWorkers nIters);isoNS;isos;seed;seedStr;offsets;t0;tWorkers;tRes;tMs;futures;iRes;iMs;match
  ⍝ Load Dyalog's built-in isolate workspace into a local sub-namespace
  isoNS←⎕NS ''
  'isolate' isoNS.⎕CY 'isolate'

  ⍝ Build 1536-bit seed and distinct offsets per worker
  seed←gmpz.New 2
  1536 seed.Shift seed
  seedStr←seed.GetInBase 62
  offsets←100000×⍳nWorkers

  ⍝ 1. Single-process APL green threads (&)
  t0←NowMs
  tWorkers←(⊂seedStr)∘IsoPrimeWorker&¨nIters,¨offsets
  tRes←⎕TSYNC tWorkers
  tMs←1⌈(NowMs)-t0

  ⍝ 2. Multi-process OS isolates (true multi-core execution)
  isos←isoNS.isolate.New¨nWorkers⍴⊂''
  {}2 isos.⎕FIX ⊂'gmpz/gmpz.dyalog'
  ⍝ {}isos.⎕FX ⊂⎕NR 'LoadIsoGmpz'
  ⍝ {}⍕¨isos.LoadIsoGmpz
  {}isos.⎕FX ⊂⎕NR 'IsoPrimeWorker'

  t0←NowMs
  futures←(nWorkers⍴⊂seedStr) isos.IsoPrimeWorker nIters,¨offsets
   iRes←⍕¨futures
  iMs←1⌈(NowMs)-t0

  _← isos.Close
  match←tRes≡iRes

  res←1 4⍴'Threads_ms' 'Isolates_ms' 'Speedup' 'Exact_Match'
  res⍪←tMs iMs (0.01×⌊0.5+100×tMs÷iMs) match
∇

∇ resStr←seedStr IsoPrimeWorker iters_offset;nIters;offset;p;i
  (nIters offset)←iters_offset
  p←gmpz.New0
  62 p.Set ∊seedStr
  p.Add offset
  :For i :In ⍳nIters
      p.NextPrime p
  :EndFor
  resStr←p.GetInBase 62
∇

∇ ok←LoadIsoGmpz
  {}2 #.⎕FIX 'gmpz/gmpz.dyalog'
  ok←1
∇

∇ ms←NowMs;ts;⎕FR
  ⎕FR←1287
  ⍝ High-resolution wall-clock timestamp in milliseconds from ⎕TS
  ts←⎕TS
  ms←(24 60 60 1000⊥4↑3↓ts)+86400000×1 ⎕DT ⊂3↑ts
∇

CR ← ⎕UCS 13 
⎕DF (⍕⎕THIS),CR,'∘ Run',CR,'   TestThreads.RunAll'
:EndNamespace