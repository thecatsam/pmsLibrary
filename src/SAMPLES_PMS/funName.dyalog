 funName←{
   ⍝ Takes the first line of a dfn or tradfn and returns its name or ⍬ (if invalid).
   ⍝ Requires header line* of tradfn or 'name←{' prefix* of a dfn.
   ⍝ The header line may have a ∇ prefix (blanks are tolerated).
   ⍝ tradfn fred:    'abc←{xxx} fred b'
   ⍝ dfn    abc:     'abc←{xxx}'
   ⍝        -----------------------
   ⍝        * Must be in ⎕CR/⎕NR/⎕VR format; only the first line is checked.
   ⍝ Returns name of dfn/tradfn OR ⍬.
     2=⍴⍴⍵:∇↓⍵                                ⍝ Allow ⎕CR format or ⎕NR.
     f←⊃⊆⍵                                    ⍝ Consider only first line
     f←f↓⍨'∇'=⊃f←f↓⍨+/∧\' '=f                 ⍝ Remove leading spaces and optl ∇ prefix.
     nm←(⎕NS'').⎕FX f''             ⍝ Tradfn? ⍝ If can fix ok, is a tradfn or a complete dfn.
     0≠⊃nm:nm                                 ⍝ ... Yes. Return name.
                                    ⍝ Dfn?    ⍝ Do 2nd since res←{name1} is also a tradfn pfx.
     dP op←'^\h*([\w∆⍙]+)\h*←\h*\{'('UCP' 1)  ⍝ Matches dfn prefix?
     (¯1≠⎕NC nm)/nm←⊃dP ⎕S'\1'⍠op⊣f           ⍝ ... If yes, with valid name, return name. Else ⍬.
 }
