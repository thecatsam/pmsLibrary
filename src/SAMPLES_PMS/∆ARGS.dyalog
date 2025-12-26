 ∆ARGS←{
 ⍝  {extras}←{where←calling_NS} (parmlist ∆ARGS opts) arglist)
 ⍝            required@SV: list of required arguments
 ⍝            argList:     An argument list of the form:
 ⍝                         'name1' (val1) 'name2' (val2) etc., val any object.
 ⍝            parmList:    Default variables and their values
 ⍝                         'name1' (val1) ...
 ⍝            opts[0]:     1 - Allow extra args (default)
 ⍝                         0 - Don't allow extra args
 ⍝            opts[1]:     1 - Return ⎕SHADOW list, without processing arglist,
 ⍝                             where list includes required and extra names.
 ⍝                             Usage:   ⍎(... ∆ARGS 1) ...   ⍝ Shadows as specified.
 ⍝                         0 - Sets variables listed from arglist, including all required.
 ⍝            where:       a ns ref, defaulting to ⊃⎕RSI (where ∆ARGS was called from). Optional.
 ⍝   Returns any extras named defined beyond the required.

     0≠2|≢⍵:11 ⎕SIGNAL⍨'∆ARGS: Must be even number of argument, value pairs'

     ⎕IO ⎕ML←0 1
     ⍺←⊃⎕RSI ⋄ where←⍺
     extrasOk shadow←2↑⍵⍵            ⍝ Defaults: noExtras: 0; shadow: 0

     pnames pvals←↓⍉(0.5×≢⍺⍺)2⍴⍺⍺   ⍝ parms  If ⎕NULL appears in pnames, no extras (optional) names are allowed
     anames avals←↓⍉(0.5×≢⍵)2⍴⍵     ⍝ args
     extras←anames~pnames

     (~extrasOk)∧0≠≢extras:11 ⎕SIGNAL⍨'∆ARGS: Optional args are not allowed:',∊' ',¨extras
     9≠⎕NC'where':11 ⎕SIGNAL⍨'∆ARGS: left argument (⍺) must be a namespace reference, if present.'

     shadow:'⎕SHADOW',∊{' ''',⍵,''''}¨pnames,extras

     (pnames pvals)/⍨←⊂~pnames∊anames

 ⍝ In case of ordering requirements, the LEFTMOST arg mapping is executed FIRST.
 ⍝ (If the same name appears twice, its value will be the one to the right).
     ok←(pnames,anames){
         0::0
         ' '∊⍺:0         ⍝ Prohibit 'abc de'.  (¯1=⎕NC ⍺) also prohibits allowed '⎕IO'.
         where⍎⍺,'←⍵⋄1'
     }¨(pvals,avals)

     0∊ok:11 ⎕SIGNAL'∆ARGS: Some names could not be assigned values: ',(anames/⍨~ok)
     1:extras←extras

 }
