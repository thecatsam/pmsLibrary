 nameOut←{left}naLinkC fnContent;_;fName;name;nameDef;opts;td;temp;⎕IO
 ⎕IO←0
⍝ naLinkC: Take C source passed, compile and link it, then
⍝    associate it with an APL function via the specified name association.
⍝ Syntax:
⍝     nameOut ← APL_name name_assoc [options] ∇ file_Spec
⍝  ⍺  APL_name:    An APL function name (string), to be the left argument to ⎕NA.
⍝                  It will be the name of the library used as well.
⍝     name_assoc:  The ⎕NA name association specification string.
⍝                  The name of the library ⎕NA requires here is replaced
⍝                  by <APL_name.so>.
⍝                  Use the APL name or at least a single non-blank character
⍝                  per the required APL syntax.
⍝     options:     A single string with any options (currently, none).
⍝  ⍵  file_spec:   Either a vector of strings, each a line of 1 or more
⍝                  compilable C functions, or
⍝                  a standard filename of a compilable C function, usually with suffix '.c'.
⍝     nameOut←     the name of the function created (APL_name) or,
⍝                  (currently) an integral code:
⍝                     1   Compile of C-code failed
⍝                     2   Name association (⎕NA) failed
⍝ 1. 'demo' 'myDemo.so|demo1 U1 U1 >0C' naLinkC 'line1' 'line2' ... 'lineN'
⍝   generates these steps:
⍝     In a temp directory,
⍝     copy:            lines 1...N into an APL variable
⍝     create:          a file _demo.c containing lines 1...N;
⍝     run in shell:    clang -shared -o _demo.so _demo.c
⍝     execute in APL:  name←'demo' ⎕NA 'myDemo.so|demo1 U1 U1 >0C'
⍝     clean up:        (remove temporary files)
⍝     return:          name
⍝ 2. 'demo' 'myDemo.so|demo1 U1 U1 >0C' naLinkC 'myFiles/myDemo.c'
⍝     copy:            'myFiles/myDemo.c' into an APL var
⍝     then proceed as in (1).
⍝ 3.  naLinkC 'ignored' (no left arg presented)
⍝     returns HELP information only.

⍝ Example
⍝   divCode←HERE
⍝     double divide(int left, int right){
⍝     return (double)left*right;
⍝     }
⍝
⍝   APL:   'div'  'F8 math|divide I4 I4 ' naLinkC divCode



⍝ If no left arg, naLinkC displays HELP info...
 :If 0=⎕NC'left'
     :If 'DEMO'≡fnContent
         ⎕SHADOW'code' 'specs'
         code←⊂'muladd(int count, double *a, double *b, double *c){'
         code,←⊂' int i;for (i=0; i<count; ++i){a[i]=a[i]*b[i]+c[i];}'
         code,←'  return;' '} '
         specs←'*|muladd count =F[] <F[] <F[]'
         :Trap 0
             '[1] code:'
             ↑(⊂'    '),¨code
             '[2] naLinkC...'
             '   ''muladd'' ''',specs,''' naLinkC code'
             :If 0≠1↑0⍴'muladd'specs naLinkC code
                 '[3] Created C routine "div" in the workspace'
                 '    res@F ← muladd a@F b@F c@F'
                 '[4] Try muladd n a b c  ⍝ a[n] ← a[n] * b[n] + c[n]'
             :Else
                 ∘
             :EndIf
         :Else
             'Something unexpected went wrong running DEMO'
             ⎕←↑⎕DMX.DM
         :EndTrap
     :Else
         ⎕←'HELP on naLinkC'
         ⎕←'Call Syntax: name nameDefinition [opts] ∇ fileName|fileContent'
     :EndIf
     →0
 :EndIf
 left←⊆left

⍝ Must specify 2 strings in ⍺: ⎕NA.⍺ ⎕NA.⍵
⍝ andptionally a 3rd arg, options
 'naLinkC: Invalid left argument'⎕SIGNAL 11/⍨~2 3∊⍨≢left
 name nameDef opts←3↑left,⊂''

 fnContent←⊆fnContent
 :If 1=≢fnContent
     :Trap 22 11
         fnContent←⎕NGET fnContent 1
     :Else
         ⎕SIGNAL/'naLinkC: invalid right argument'
     :EndTrap
 :ElseIf 2=⍴⍴fnContent
     fnContent←↓fnContent
 :EndIf

 temp←(td←739⌶0),'/',name
 (⊂fnContent)⎕NPUT(temp,'.c')1

 :Trap 11
     _←⎕SH'cd ',td,';clang -shared -o ',temp,'.so ',temp,'.c' ⍝ Assigning forces Signal on failure
     :Trap 0
        ⍝ Since ⎕NA requires a library name, but we're using the <APL_name>.so,
        ⍝ we ignore the name specified (could be *, = or the actual name).
         ⎕EX name
         nameOut←name ⎕NA('[^ ]+(?=\|)'⎕R(temp,'.so')⊣nameDef)
     :Else
         nameOut←2
     :EndTrap
 :Else
     nameOut←1
 :EndTrap


 1(⎕NDELETE⍠1)'/tmp/_',name,'.*'
