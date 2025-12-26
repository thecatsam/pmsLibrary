:class tokenMgr

    ⎕IO←0
    ⎕ML←1
  ⍝ Class fields
    :Field Public Shared tokenMgrStart← 37+2*25
    :Field Public Shared tokenMgrCur←tokenMgrStart
    :Field Public Shared tokenMgrLast←tokenMgrStart+¯1+200000
    :Field Public Shared tokenMgrFile←'.tokenMgrFile'
    :Field Public Shared tokenMgrClasses←⍬
    :Field Public Shared tokenMgrSpecs←⍬
  ⍝ Instance fields
    :Field Public tokenClass
    :Field Public tokenFirst
    :Field Public tokenCount

    ∇ new1(class first count)
      :Implements  Constructor
      :Access Public
      tokenClass←class
      tokenFirst←first
      tokenCount←count
      tokenMgrClass
    ∇
    ∇ cleanup;found;p;q
      :Implements  Destructor
      found p q←find tokenClass
      :If found
          tokenMgrClasses←q/tokenMgrClasses
          tokenMgrSpecs←q/tokenMgrSpecs
              ⍝ write out tokenMgrClasses and Specs
      :Else
          ('tokenMgr: Class "',tokenClass,'" does not exist')⎕SIGNAL 11
      :EndIf
    ∇

    ∇ (found p q)←find(class);found;p;q;n 
      p←tokenMgrClasses⍳⊂class
      :If found←p<≢n←tokenMgrClasses
          q←p≠⍳n
      :Else
          found p q←0 ¯1 0
      :EndIf
    ∇

    ∇ allocate(class count)
      found p q←find class
      :IF found
        :IF (1⊃tokenMgrSpecs[p])=count
            :Return
        :Else   ⍝ Reallocate
            delete p q
            token
        :Endif 
      :Endif 
    ∇


:endClass
