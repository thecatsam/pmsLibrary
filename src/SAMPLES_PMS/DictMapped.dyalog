:Namespace DictMappedNs
  ⍝ A simple, namespace-based, dictionary. Fast, low overhead.
  ⍝ Uses Triggers to map local vars onto dictionary namespace and vice versa
  ⍝ See docs/TinyDict.help

    dict_count←0
  ⍝ TinyDict: Make namespace visible as <TinyDict> if TinyDict is in ⎕PATH
    ∇ ns←DictMapped
      ns←⎕THIS
    ∇
    ##.⎕FX '⎕THIS' ⎕R (⍕⎕THIS)⊣⎕NR 'DictMapped'

    ∇ sub←new;dict;st
      {}⎕EX'__set_trigger__'
      dict←⎕NS ⎕THIS
      dict.sub←sub←⎕NS''
      sub.Dict←dict   ⍝ Link sub back up!
      dict.default←⍬
      dict_count+←1
      sub.⎕DF'DictMapped[',(⍕dict_count),']'
      sub.⎕FX'__set_trigger__ arg' ' :Implements Trigger *' 'arg.Name ⎕THIS.Dict.put1x ⎕OR arg.Name'
    ∇

    ∇ sub←{def}∆MAPPEDDICT pairs;dict
      dict←(sub←⎕THIS.new).Dict
      :If 0≠⎕NC'def'
          dict.default←def
      :EndIf
      :If 0<≢pairs
          dict.(Keys Vals)←{⍺←⍴⍴pairs
              2≠⍺:↓⍉↑⍵    ⍝  ('one' 1)('two' 2) ('three' 3)
              1=⊃⍺:,⍵     ⍝  ⍪ ('one' 'two' 'three') (1 2 3)
              ↓⍵          ⍝  ↑('one' 'two')(1 2)
          }pairs
      :EndIf
    ∇
    _←##.⎕FX '⎕THIS'  ⎕R (⍕⎕THIS) ⊣⎕NR '∆MAPPEDDICT'

    ⎕IO ⎕ML←0 1
    keysF valsF←⍬ ⍬
  ⍝ default is defined in New or, optionally, in ∆TINYDICT.

  ⍝ Set "methods"  keys, vals, values for vars keysF valsF
    ∇ k←keys
      k←keysF
    ∇
    ∇ v←vals
      v←valsF
    ∇
    ∇ v←values
      v←valsF
    ∇

    ∇ r←get keys;e;ie;ine;p
      keys←,keys
      p←keysF⍳keys
      r←keys        ⍝ r will have the shape, but not content, of keys.
      :If 0≠≢ie←⍸e←p<≢keysF
          r[ie]←valsF[e/p]
      :EndIf
      :If 0≠≢ine←⍸~e
          :If 0≠⎕NC'default'
              r[ine]←⊂default
          :Else
              ⎕SIGNAL/('TinyDict: One or more keys undefined: ',keys[ine])11
          :EndIf
      :EndIf
    ∇

    ∇ r←get1 key;p
      p←keysF⍳⊂key
      :If p≥≢keysF
          :If 0≠⎕NC'default'
              r←default
          :Else
              ⎕SIGNAL/('TinyDict: Key undefined: ',key)11
          :EndIf
      :Else
          r←p⊃valsF
      :EndIf
    ∇

    ∇ {vals}←{keys}put vals;e;ePut1;ePut2;ie;kv;n;p
      ePUT1←'TinyDict/put (1adic): one or more key-value pairs required' 11
      ePUT2←'TinyDict/put (2adic): number of keys and values must match' 11
      :If 0=⎕NC'keys'    ⍝ monadic put:   put (k1 v1)(k2 v2)...
          kv←↓⍉↑vals
          :If 2≠≢kv ⋄ ⎕SIGNAL/ePUT1 ⋄ :EndIf
          keys vals←kv
      :ElseIf (≢keys)≠(≢vals)
          ⎕SIGNAL/ePUT2
      :EndIf
      keys vals←(,keys)(,vals)
      e←(≢keysF)>p←keysF⍳keys
      :If 0≠≢ie←⍸e    ⍝ Any existing keys?
          valsF[e/p]←e/vals
      :EndIf
      :If 1∊n←~e      ⍝ Any new keys?
        ⍝ If a key appears >1ce, use the LAST value for that key.
          p←(≢keys)-1+(⌽keys)⍳∪n/keys
          (keysF valsF),←(keys[p])(vals[p])
      :EndIf
      :Trap 4 11
          {}(mangle¨keys){0::'' ⋄ sub⍎⍺,'←⍵'}¨vals
      :Else
          'At least one key is not a simple string'⎕SIGNAL 11
      :EndTrap
    ∇

    ∇ {val}←{key}put1 val;p
    ⍝  put1 key val   OR    key put1 val
      :If 0=⎕NC'key'
          key val←val
      :EndIf
      p←keysF⍳⊂key
      :If p≥≢keysF
          keysF,←⊂key ⋄ valsF,←⊂val
      :Else
          (p⊃valsF)←val
      :EndIf
      :Trap 4 11
          {}(mangle key){0::'' ⋄ sub⍎⍺,'←⍵'}val
      :Else
          'Key not a simple string'⎕SIGNAL 11
      :EndTrap
    ∇

    ∇ {val}←key put1x val;p
      key←1 mangle key
      p←keysF⍳⊂key
      :If p≥≢keysF
          keysF,←⊂key ⋄ valsF,←⊂val
      :Else
          (p⊃valsF)←val
      :EndIf
    ∇

    ∇ {b}←del1 key;p;q
      p←keysF⍳⊂key
      :If p≥≢keysF
          b←0   ⍝ Not deleted
      :Else
          b←1   ⍝ Deleted...
          q←1⍴⍨≢keysF ⋄ q[p]←0
          keysF valsF←(q/keysF)(q/valsF)
      :EndIf
      {}{0::'' ⋄ sub.⎕EX ⍵}mangle key
    ∇

  ⍝ del: Inefficient (just haven't gotten around to it)
    ∇ {b}←del keys
      b←del1¨keys
    ∇

    ∇ b←has_default
      b←0≠⎕NC'default'
    ∇

    ∇ r←table
      r←keysF,[0.5]valsF
    ∇

    ∇ s←{un}mangle string
    ⍝    0 mangle string: Convert a string to a valid APL id, if possible.
    ⍝      *** DEFAULT
    ⍝    1 mangle string: Convert a valid APL id into its source string.
      :If 0=⎕NC'un' ⋄ un←0 ⋄ :EndIf
      s←un(7162⌶)string
    ∇

    ∇ help;HELP
      HELP←↑3↓¨⊃⎕NGET'pmsLibrary/docs/TinyDict.help' 1
      ⎕ED'HELP'
    ∇

:EndNamespace
