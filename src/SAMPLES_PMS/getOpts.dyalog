getOpts←{
  ⍝ Decodes options of the form  ('name1' value) or ('name2') or ('name3' val1 val2 val3)
  ⍝ Returns a namespace ns with objects:
  ⍝      ns.name1←⊂value, ns.name2←1 or ns.name3←val1 val2 val3 
  ⍝ If nameN begins with a hyphen, the hyphen is replaced with an underscore.
  ⍝ (Thus, _name1 is the same as -name1).
  ⍝ ⍺: List of names and attributes in this form:
  ⍝    ('nameN' ['num' | 'str' | 'ns'])




}
