:Namespace PlotFormat

⍝ Produced by TooterTurtle-0
⍝ https://gitlab.com/tooterturtle-0/Workspaces/-/blob/main/plotformat?ref_type=heads

⍝ Copied 2026-01-222 by PMS

    ∇ l←a and b;c;d
      →(((2<⍴⍴a)∨3<⍴⍴b),0≠⍴⍴b)/L17,L3
      b←,b
     L3:→(((3=⍴⍴b)∧1≠1⍴⍴b),2=⍴⍴a)/L17,L7
      a←,a
      →(∧/((⍴a)≠1,d),1≠d←1⍴¯2⌽⍴b)/L16
      a←(((d×⍴a)⌊d⌈⍴a),1)⍴a
     L7:→(1≠⍴⍴b)/L9
      b←(((⍴b)⌈(1=⍴b)×1⍴⍴a),1)⍴b
     L9:→((∧/d≠1,1⍴⍴a),1≠d←1⍴¯2⌽⍴b)/L16,L11
      b←(((3=⍴⍴b)⍴1),(1⍴⍴a),1⍴⌽⍴b)⍴b
     L11:→(3=⍴⍴b)/L14
      l←(((c←1⍴⌽⍴a)⍴0),(1⍴⌽⍴b)⍴1)\b
      →0×⍴⍴l[;⍳c]←a
     L14:l←(1,((c←1⍴⌽⍴a)⍴0),(¯1+1⍴⌽⍴b)⍴1)\b
      →0×⍴⍴l[;;1+⍳c]←a
     L16:→0=⍴⎕←'Arguments of  and  are not conformable.'
     L17:'An argument of  and  is of improper rank.'
    ∇

    ∇ demo;a;o;⎕IO
      ⎕IO←1
      80 plot⍉3 64⍴a,(¯1+o÷⌈/(o←⍟1+6×a)÷2),1○a←((2×○1)×¯1+⍳64)÷64
    ∇

∇r← howplot 
r←↑(
'THE FUNCTION PLOT WILL GRAPH ONE OR MORE FUNCTIONS'
'SIMULTANEOUSLY, AUTOMATICALLY SCALING THE VALUES TO FIT'
'APPROXIMATELY WITHIN SCALE DIMENSIONS SPECIFIED BY THE USER'
'IT WILL WORK ONLY IN 1-0RIGIN INDEXING.'
'THE FORM IN WHICH PLOT IS USED IS~'
'   SCALESIZE PLOT FUNCTION'
'   LEFT ARGUMENT: ONE OR TWO NUMBERS' 
'     - THE FIRST NUMBER SPECIFIES THE APPROXIMATE SIZE OF THE'
'       VERTICAL AXIS AND THE SECOND NUMBER DOES THE SAME'
'       FOR THE HORIZONTAL AXISo'
'     - IF ONLY ONE NUMBER IS SUPPLIED, IT IS APPLIED TO BOTH'
'       AXES.'
'     - THERE IS NO BUILT-IN LIMIT TO THE DIMENSIONS, AND A'
'       HORIZON21AL AXIS LAHGER THAN THE WORKSPACE WIDTH WILL'
'       CAUSE SOME POINTS TO BE PRINTED ON THE NEXT LOWER'
'       LINE.'
'   RIGHT ARGUMENT: A RECTANGULAR ARRAY WITH RANK 3.'
'    - SCALAR: WILL BE TREATED AS A VECTOR OF LENGTH ONE'
'    - VECTOR: WILL BE PLOTTED AS ORDINATE AGAINST ITS OWN'
'      INDICES AS ABSCISSA 0'
'    - MATRIX: THE LEFTMOST COLUMN WILL BE TAKEN AS THE'
'      ABSCISSA AND ALL OTHER COLUMNS WILL BE PLOTTED AS'
'      ORDINATES A DIFFERENT PLOTTING SYMBOL UP TO THE'
'      NUMBER OF SYMBOLS AVAILABLE WILL BE USED FOR EACH'
'      COLUMN IN CASE TWO ORDINATES HAVE A COMMON POINT,'
'      THE SYMBOL FOR THE COLUMN FURTHEST TO THE RIGHT WILL'
'      BE USED.'
'    - 3-DIMENSIONAL ARRAY: THE FIRST PLANE WILL BE PLOTTED'
'      AS A MATRIX, AND ALL OTHER PLANES WILL BE DISREGARDED.'
)
∇
∇r← howformat 
r←↑(
'THE FUNCTIONS DFT AND EFT WILL ARRAY NUMBERS IN DECIMAL AND'
'EXPONENTIAL FORM, RESPECTIVELY, FOR TABULAR OUTPUT. THEY'
'MAY BE USED TO GENERATE IMMEDIATE OUTPUT, OR TO STORE AN'
'IMAGE FOR LATER PRINTING. THE TWO FORMS ARE:'
'  PATTERN DFT TABLE'
'  PATTERN EFT TABLE'
'AND'
'  IMAGE+PATTERN DFT TABLE'
'  IMAGE+PATTERN EFT TABLE'
'THESE FUNCTIONS WORK PROPERLY ONLY WITH 1-0RIGIN INDEXING?'
'  RIGHT ARGUMENT: AN ARRAY TO BE FORMED,'
'     IT MUST BE NUMERICAL, AND OF RANK 3. THE FIRST'
'     PLANE OF A 3-DIMENSIONAL ARRAY WILL BE TREATED AS A'
'     MATRIX, AND ALL OTHEH PLANES WILL BE DISREGARDED 0'
'     ARRAYS OF HIGHER RANK WILL BE SIGNALLED AS A RANK'
'     PROBLEM.'
'   LEFT ARGUMENT: ONE OR MORE INTEGERS TO CONTROL THE FORMAT.'
'     FRACTIONAL NUMBERS WILL BE SIGNALLED AS A DOMAIN'
'     PROBLEM'
'   ∘ A SINGLE INTEGER:'
'     - DFT: SPECIFIES THE NUMBER OF DIGITS TO THE RIGHT OF'
'       THE DECIMAL POINT IN DECIMAL FORMAT.'
'     - EFT: SPECIFIES THE NUMBER OF SIGNIFICANT DIGITS IN'
'       EXPONENTIAL FORMAT. ONE DIGIT ALWAYS APPEARS TO THE'
'       LEFT OF THE DECIMAL POINT. COLUMNS WILL BE SPACED'
'       UNIFORMLY, WITH SPACING SUCH THAT THERE WILL BE TWO'
'       SPACES BETWEEN THE CLOSEST NUMBERS.'
'   ∘ A PAIR OF INTEGERS: THE FIRST SPECIFIES THE TOTAL'
'     NUMBER OF SPACES TO BE ALLOCATED TO EACH COLUMN, AND'
'      THE SECOND IS USED AS ABOVE.'
'     DFT: THE FIRST NUMBER MUST BE AT LEAST TWO LARGER'
'         THAN THE SECOND'
'     EFT: THE FIRST NUMBER MUST BE AT LEAST SIX LARGER'
'         THAN THE SECOND. IF THE LEFT NUMBER IS TOO SMALL,'
'         THIS WILL BE SIGNALLED AS A DOMAIN PROBLEM'
'   ∘ MORE THAN ONE PAIR OF INTEGERS:'
'     THERE MUST BE ONE PAIR'
'     FOR EACH COLUMN OF OUTPUT (OR EACH ELEMENT OF A VEC-'
'     TOR). EACH PAIR WILL BE INTERPRETED AS ABOVE, AND'
'     WILL APPLY TO THE LAYOUT OF THE CORRESPONDING COLUMN.'
'     IF THE NUMBER OF PAIRS DOES NOT MATCH THE NUMBER OF'
'     COLUMNS, THIS WILL BE SIGNALLED AS A LENGTH PROBLEM.'
)
∇

    ∇ describe
      ''
      'The working functions in this  workspace are:'
      ''
      '   and   dft   eft   plot   vs'
      ''
      'The names and composition of the groups in this workspace are:'
      ''
      '   dftgp:        and  dft'
      '   eftgp:        and  eft'
      '   plotgp:       and  plot  vs'
      '   desgp:        describe   howformat   howplot'
      ''
      'desgp can be used to conveniently erase the descriptive matter'
      'to make more room in the workspace.  The other groups can be used'
      'to selectively copy the indicated functions.'
      ''
      'Syntax                          Description'
      '¯¯¯¯¯¯                          ¯¯¯¯¯¯¯¯¯¯¯'
      'z←a and b          Essentially a column-catenator, with some extra'
      '                   effects when the arguments are not matrices.'
      '                   This function is designed to be used either'
      '                   independently, or in conjunction with vs.'
      '                   together, they provide a convenient way of form-'
      '                   ing input to the plot function.'
      ''
      'z←a dft b          Forms fixed-point output.  More detailed direc-'
      '                   tions can be found in the variable howformat.'
      ''
      'z←a eft b          Forms exponential output.  More detailed direc-'
      '                   tions can be found in the variable howformat.'
      ''
      'a plot b           Graphs one or more functions simultaneously.'
      '                   directions for using plot can be found in the'
      '                   variable howplot.'
      ''
      'z←a vs b           Essentially a column-catenator, similar to and,'
      '                   except that the right-hand argument must be of'
      '                   rank ≤ 1.  It is designed primarily to provide'
      '                   convenient formation of input to plot func-'
      '                   tion.  Whether used by itself or with and, vs'
      '                   will cause its right argument to appear as the'
      '                   leftmost column of the resultant array.  (The'
      '                   resultant will be an array of rank three,'
      '                   consisting of a single plane).'
      ''
      'Both and and vs will work with either 1 or 0-origin indexing.'
      ''
    ∇

    ∇ z←w dft x;d;e;f;g;h;i;j;k;l;y;⎕IO
      ⎕IO←1 ⋄ d←' 0123456789.¯'
      →(∨/w≠⌊w←,w+(h←0)×l←1<⍴⍴x)/dfterr+0×f←2
      →(3 2 1<⍴⍴x)/(dfterr+f←0),L5 L6
      →(⍴⍴⍴x←((∨/1 2=⍴w)⌽1 2)⍉(1,⍴,x)⍴x)/L6
     L5:x←(0 1 1/⍴x)⍴x
     L6:→((∧/(⍴w)≠1 2,2×e←1⍴⌽⍴x),1≠⍴w)/(dfterr×f←1),L9
      i←1+⌈/0,,⌊10⍟|x+1>|x
      w←(2+i+w+(w≠0)+∨/,x<0),w
     L9:→(∨/2>-/[1]w←⍉(e,2)⍴w)/dfterr+0×f←2
      z←((k←1⍴⍴x),+/w[1;])⍴' '
      x←⌊0.5+x×10*(⍴x)⍴w[2;]
     dftlp:→(e<h←h+1)/dftend
      j←1+⌊10|(|y←x[;h])∘.÷10*¯1+⌽⍳i←w[1;h]
      j←(,j)×g←,⍉(⌽⍴j)⍴(,⍉(j≠1)∨.∧(⍳i)∘.≤⍳i-f+1),(k×1+f←w[2;h])⍴1
      →(∧/0≤y)/L17
      j[1+(⍴j)|¯1+(i-+/(k,i)⍴g)+i×¯1+⍳k]←12×y<0
     L17:j←(k,i)⍴j
     L18:→(0=f)/L21
      j←j[;(1⌽⍳g),(g←-/w[;h])+⍳f]
      j[;g]←11
     L21:→dftlp×⍴⍴⍴z[;(+/w[1;⍳h-1])+⍳i]←d[1+j]
     dftend:→l/0
      →0×⍴z←,z
     dfterr:'dft ',(3 6⍴' rank lengthdomain')[f+1;],' problem.'
    ∇

    ∇ z←w eft x;d;e;h;j;k;l;q;s;t;u;y;⎕IO
      ⎕IO←1 ⋄ d←'0123456789.e ¯'
      →(∨/w≠⌊w←,w+(h←0)×l←1<⍴⍴x)/efterr+0×k←2
     L3:→(3 2 1<⍴⍴x)/(efterr+k←0),L5 L6
      x←((∨/1 2=⍴w)⌽1 2)⍉(1,⍴,x)⍴x
     L5:x←(⌽2⍴⌽⍴x)⍴x
     L6:→((∧/(⍴w)≠1 2,2×e←1⍴⌽⍴x),1≠⍴w)/(efterr×k←1),L8
      w←(w+6+(∨/,x<0)+∨/,1>|x),w
     L8:→(∨/6>-/[1]w←⍉(e,2)⍴w)/efterr+0×k←2
      z←((k←1⍴⍴x),+/w[1;])⍴' '
     eftlp:→(e<h←h+1)/eftend
      s←1+⌊10⍟|y+0=y←x[;h]
      u←1+⌊10⍟|y+0=y←⌊0.5+(10*q-15)+y×10*(q←w[2;h])-s
      j←(((t-4)⍴1),4⍴0)\1+⌊10|(|y÷10*u>q)∘.÷10*¯1+⌽⍳¯4+t←w[1;h]
      j[;t-2 1]←1+⌊10|(|s-u≤q)∘.÷10 1
      j[;(⍳u←t-4+q),t]←13
      j[;1,u,t,t-3]←⍉(4,k)⍴(k⍴11),(13+0>y,s-1),k⍴12
      j[;⍳t-3]←j[;(1⌽⍳u+1),(u+1+⍳q)]
      j[;t-2 1 0]←(-s≤0)⌽j[;t-2 1 0]
      →eftlp×⍴⍴⍴z[;(+/w[1;⍳h-1])+⍳t]←d[j]
     eftend:→l/0
      →0×⍴z←,z
     efterr:'eft ',(3 6⍴' rank lengthdomain')[k+1;],' problem.'
    ∇

    ∇ {b}←a plot b;c;d;f;g;h;i;j;l;t;y;hz;nb;vt;pt;st;isv;u;⎕IO;⎕ML
      ⎕IO←1 ⋄ ⎕ML←3 ⋄ PC←'○*∘∇∆⎕'
      HS←0
      ST←1 2 5
      SM←5 10
      →((0=×/(2⍴a),⍴b),3 2 1<⍴⍴b)/0,prkerr,plotl2,plotl3
      →plotl3×⍴⍴⍴b←⍉(2,d)⍴(⍳d←⍴,b),b
     plotl2:b←b[1;;]
     plotl3:y←1+⍳(⍴b)[2]-1
      c←((⌈/⌈/b[;y])-⌊/⌊/b[;y]),(⌈/b[;1])-⌊/b[;1]
      f←|(2⍴a)÷c+(c=0)×b[1;2 1]+b[1;2 1]=0
      f←(ST[+/(⌊0.0001+f×10*-g)∘.≥ST])×10*g←⌊10⍟f
      g←(SM÷f)×⌊((⌊/⌊/b[;y]),⌊/b[;1])×f÷SM←16⌊SM⌈1 4
      b[;1]←⌊0.5+f[2]×b[;1]-g[2]
      b[;y]←⌊0.5+f[1]×b[;y]-g[1]
      h←SM×⌈((⌈/⌈/b[;y]),⌈/b[;1])÷SM
      nb←g[1]+(SM[1]÷f[1])×0,⍳h[1]÷SM[1]
      hz←g[2]+(SM[2]÷f[2])×0,⍳h[2]÷SM[2]
      ⎕←0⍴st←6⍴~isv←1≠u←9
     plotl4:vt←∨/0>nb←nb×10*u-st[6-isv]←i←1+⌈/⌊10⍟|(nb≠0)/nb
      pt←⌊1+10|pt-1|pt←0.00001+(|nb)∘.÷10*¯1+⌽⍳u
      l←u+1-(⌽((c←⍴nb)⍴1)∧.=pt)⍳0
     L22:→((u>t←vt+⌈/i,(l+l≠i),(i≤0)×2+l-i),st[2-isv]←st[2-isv]∨l≥u-vt+l>i)/L25,L24
      →L22×⍴⍴⍴st[4-isv]←i←1
     L24:→plotl4×⍴⍴nb←SM[1+~isv]×¯1+⍳c
     L25:pt←(-vt+0⌈1-i)⌽pt
      pt←(,pt)×j←,⍉(⌽⍴pt)⍴(,⍉(1≠pt)∨.∧(⍳u)∘.≤⍳vt⌈i-1),(c×u+1-i←vt+i⌈i≤0)⍴1
      →L29×⍳~vt
      pt[(u-+/(c,u)⍴j)+u×¯1+⍳c]←11×nb<0
     L29:pt←(~(⍳u+j)∊(i+j),⍳¯1+j←u-t)\(1 0+c,u)⍴pt,u⍴0
      pt[⍳c;i+j]←12
      pt←' 0123456789-.'[1+pt[;⍳u-1]]
      →plotl13×⍳~isv
      l←1,h[2]⍴0×c←h[1]
     plotl8:l←(l×HS×c≠0)⌈1,h[2]⍴0
      l[1+(d≠0)/b[;1]]←(d≠0)/d←(c=b[;y])⌈.×y
      →(c≠0)/plotl11
      l←l⌈0=(SM[2]÷2)|0,⍳h[2]
     plotl11:pt[((⍴pt)[1],1+c÷SM[1])[1+0=SM[1]|c];],(' |',(⍴y)⍴PC)[1+l]
      →(0≤c←c-1)⍴plotl8
      →(u=u←SM[2]-~isv←~⍴⍴nb←,hz)⍴plotl4
     plotl13:⎕←(SM[2]-9)⌽(,(0 0,(u-1)⍴1)\pt),' '
      →(st[1 3 2 4],1)/L43,L45,L47,L49,L52
     L43:⎕←'origin and scale factor for ordinate: ',⍕g[1],÷f[1]
      →L46×⍳0=st[3]
     L45:⎕←'scale factor for ordinate: ',⍕10*st[5]-1
     L46:→L48×⍳0=st[2]
     L47:⎕←'origin and scale factor for abscissa: ',⍕g[2],÷f[2]
     L48:→0×⍳0=st[4]
     L49:⎕←'scale factor for abscissa: ',⍕10*st[6]-1
      →0
     prkerr:'the right argument of  plot  must have rank ≤ 3.'
     L52:
    ∇

    ∇ m←a vs b;c;d
      →(((⍴⍴b←,b)<⍴⍴b),2 1 0<⍴⍴a)/L8,L8,L4,L3
      a←((⍴b),1)⍴a
     L3:a←((×/⍴a),1)⍴a
     L4:→(∧/(⍴b)≠1,1⍴⍴a)/L9
      m←(0,(1⍴⌽⍴a)⍴1)\a
      m[;⍳1]←b
      →0×⍴⍴m←(1,⍴m)⍴m
     L8:→0=⍴⎕←'an argument of  vs  is of improper rank.'
     L9:'arguments of  vs  are not conformable.'
    ∇

:EndNamespace
