 CMPX←{
   ⍝ CMPX: Execute each code string on cmd line (⍵1 ⍵2 ...) or prompted (0=≢⍵), returning timing,
   ⍝    Based on dfns::cmpx, with three enhancements:
   ⍝       [1] executes in caller namespace, not CMPX namespace.
   ⍝       [2] prints results in order of fastest to slowest.
   ⍝       [3] allows prompting for code lines if ⍵ is ⍬ or ''.
   ⍝    Syntax: [⍺] CMPX  code1 code2 ... codeN
   ⍝            [⍺] CMPX  ⍬  (or '')
   ⍝                codeN: a string containing code, executable in the caller namespace
   ⍝                ⍺:     see cmpx for usage.

   ⍝ Error messages...
     0::⎕←{dm0 dm1←⍵
         pCodeExtra←'^(CMPX\[\d+\])? *\{[^⊣]+⊣' '⋄ *⎕AI}⍺$'
         dm0,' executing code: ',pCodeExtra ⎕R''⊣dm1
     }2⍴⎕DMX.DM

   ⍝ PMS: Prompt for lines, if ⍵ is ⍬
     0=≢_lîñêß_←{LQ RQ←⎕UCS 8220+0 1
         0≠≢⍵:⍵
         ⎕←'Enter one expression on each line. → to abort NOW.'
         {⍺←1
             line←⍞↓⍨≢⍞←∊'[',(⍕⍺),'] '
             '!^→'∊⍨1↑line~' ':⍬ ⋄ 0≠≢line~' ':(⍺+1)∇ ⍵,⊂line ⋄ 0=≢⍵:⍵
             ⍵⊣⎕←'Timing:',∊(⊂'  ',LQ),¨RQ,⍨¨⍵
         }⍬
     }⍵:_←''

     ⍺←⍬                                         ⍝ ⍺ options: raw cpu cols.
     ⍺(⊃⌽⎕RSI).{                                 ⍝ PMS: Caller env!
         (⍎⍵)-⎕AI                                ⍝ time of ⍺ expr-iterations.
     }{⎕IO ⎕ML←0 1                               ⍝ local sysvars (see Notes).
         dflt←{⍵+⍺×⍵=0}                          ⍝ ⍺ default if ⍵=0.
         raw cpu cols secs←0 0 40 1 dflt¨4↑⍺     ⍝ raw/cpu times, hist wdth secs
         clock←(2-cpu)∘⊃                         ⍝ 0:elapsed, 1:cpu
         count nett←1 ⍺⍺{                        ⍝ loop count and times.
             times←⍺ ⍺⍺{                         ⍝ time for each expression.
                 head←'{0<⍵:∇⍵-1⊣'               ⍝ loop pre- and
                 tail←'⋄⎕AI}⍺'                   ⍝ post-amble.
                 clock ⍺ ⍺⍺ head,⍵,tail          ⍝ time for ⍺ loops of expr.
             }¨⍵                                 ⍝ ... for each expression.
             (secs×1000)>+/times÷≢⍵:(⍺×2)∇ ⍵     ⍝ too quick: reiterate × 2.
             null←'{0<⍵:∇⍵-⊢1⋄⎕AI}⍺'             ⍝ null loop for "control" time.
             adj←{⍵-0⌊⌊/⍵}                       ⍝ adjusted to clear -ive vals.
             ⍺,⊂adj times-clock ⍺ ⍺⍺ null        ⍝ times - null loop overhead.
         }⍵                                      ⍝ vector of expressions.
         hist←↑{(⌊0.5+cols×⍵÷⌈/⍵)⍴¨'⎕'}nett      ⍝ simple histogram.
         raw:nett÷count×1000                     ⍝ raw numeric result.
         esec←↑6 ¯2∘⍕¨nett÷count×1000            ⍝ e-format seconds.
         rels←⌊100×¯1+{⍵÷⊃⍵}1⌈nett               ⍝ percentages relative to 1st.
         sign←{(1+×⍵)⊃'- +'}                     ⍝ sign: - +.
         fpcs←⌽↑{'%',⌽(sign ⍵),⍕|⍵}¨rels         ⍝ formatted percentages.
         diff←{⍵⊃' *'}¨×{⍵⍳⍵},⍵⍵¨⍵               ⍝ result differences.
         exps←diff,' ',↑⍵                        ⍝ exprs with diff markers.
         pref←{↑⍺∘,¨↓⍵}                          ⍝ ⍺-prefix of rows of matrix ⍵.
         cmps←' | 'pref fpcs,' ',hist            ⍝ percents and histogram.
         1=≢⍵:esec                               ⍝ single expr: time only.
       ⍝ PMS: SORTED!
         (⊂⍋nett)⌷exps,' → 'pref esec,cmps       ⍝ [*] expr → secs | %s histo.
     }(⊃⌽⎕RSI).{              ⍝ PMS: CALLER ENV  ⍝ right operand:
         ⍎⍵                                      ⍝ PMS: expr executed in native envt.
     }⊆_lîñêß_                                   ⍝ vector of subject exprs.
 }
