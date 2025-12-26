 ∆ENUM←{
   ⍝    ns ←  ['descriptor'] ∇ 'elem1 elem2 ... '
   ⍝    ns: a namespace (see below)
   ⍝    descriptor: optional string; default 'enum'
   ⍝    elem1: a string which represents a valid APL name, nm1
   ⍝           ns.nm1←0, ..., ns.nmN←N-1
   ⍝        OR a string with + separating APL names, nm1a nm1b..., such that
   ⍝           ns.(nm1a nm2a...)←0, ...
   ⍝    ns: a namespace with these variables:
   ⍝        ∆KEYS:         list of all the names in order, left to right.
   ⍝        ∆VALS:         list of the values for each name ordered by ∆KEYS
   ⍝        ∆PKEYS:        list of all the primary names in order
   ⍝        ∆ENUM:         list of all the unique values in order (starting with 0)
   ⍝                       Useful for enumerations :FOR i :in colors.∆ALL
   ⍝        ∆COUNT:        count of unique keys
   ⍝        The display form for ns is of the form:
   ⍝            "descriptor: elem1 elem2 ..."
   ⍝
     ⍝0::'∆ENUM: Invalid enumeration'⎕SIGNAL 11
     ⍺←'enum'
     count←≢elements←' '(≠⊆⊢)⍵
     ns←⎕NS''
     _←ns.⎕DF ⍺,': ',⍵
     ns.(∆KEYS←∆PKEYS←∆VALS←⍬)
     ns.(∆ENUM ∆COUNT)←(⍳count)(count)
     _←elements ns.{
         ∆KEYS,←cur←'+'(≠⊆⊢)⍺
         ∆PKEYS,←⊂⊃cur
         ∆VALS,←(≢cur)⍴⍵
         ⍎(⍕cur),'←⍵'
     }¨ns.∆ENUM
     ns⊣ns.⎕DF{⎕PW≥≢⍵:⍵ ⋄ '...',⍨⍵↑⍨⎕PW-3}⍺,': ',⍵
 }
