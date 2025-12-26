 millerRabin←{
     _←UCMD'require bigInt'
     isAnyOf←{0=≢⍵:0 ⋄ ⍺=BI⊃⍵:1 ⋄ ⍺ ∇ 1↓⍵}

⍝  From: https://jeremykun.com/2013/06/16/miller-rabin-primality-test/
⍝
⍝  def decompose(n):
⍝     exponentOfTwo = 0
⍝
⍝     while n % 2 == 0:
⍝        n = n/2
⍝        exponentOfTwo += 1
⍝
⍝     return exponentOfTwo, n
     decompose←{ ⍝ [⍺=exponentOfTwo]  ⍵=n
         ⍺←0
         0≠BI 2|BI ⍵:⍺ ⍵
         (⍺+1)∇ ⍵ bi.shiftB ¯1
     }
⍝
⍝  def isWitness(possibleWitness, p, exponent, remainder):
⍝     possibleWitness = pow(possibleWitness, remainder, p)
⍝
⍝     if possibleWitness == 1 or possibleWitness == p - 1:
⍝        return False
⍝
⍝     for _ in range(exponent):
⍝        possibleWitness = pow(possibleWitness, 2, p)
⍝
⍝        if possibleWitness == p - 1:
⍝           return False
⍝
⍝     return True    ⍝ [EndFor 1]
     isWitness←{
         pW p p1 exp rem←⍵   ⍝ We pass p1 for efficiency:   p1←<BI p
         pW←p|BI pW*BI rem
         1=BI pW:0
         p1=BI pW:0
         {
             ⍵≤BI 0:1   ⍝ [EndFor 1] above
             pW←p|BI pW*BI 2
             pW=BI p1:0
             ∇<BI 1
         }exp
     }
⍝
⍝  def probablyPrime(p, accuracy=100):
⍝     if p == 2 or p == 3: return True
⍝     if p < 2: return False
⍝
⍝     exponent, remainder = decompose(p - 1)
⍝
⍝     for _ in range(accuracy):
⍝        possibleWitness = random.randint(2, p - 2)
⍝        if isWitness(possibleWitness, p, exponent, remainder):
⍝           return False
⍝
⍝     return True  [EndFor 2]

     probablyPrime←{   ⍝ ⍺=accuracy, ⍵=p
         ⍺←1
         accuracy←⍺   ⍝ Whatever default you want (≥1)
         p←bi.∆ ⍵
         p isAnyOf 2 3 5 7 11:1
         p1←<BI p
         p<BI 2:0
         exp rem←decompose<BI p
         {acc←⍵
             acc<1:1     ⍝ EndFor 2
             pW←2+BI?BI p-BI 3    ⍝ 2...p-2 ←←  2 + (0..p-4  ← rand p-3)
             isWitness pW p p1 exp rem:0
             ∇ acc-1
         }accuracy
     }

     ⍺←⊢
     ⍺ probablyPrime ⍵
 }
