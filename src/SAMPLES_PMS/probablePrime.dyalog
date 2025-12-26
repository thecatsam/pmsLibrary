isTrue←N isProbablePrime certainty;k;primes;t
⍝  
⍝  def is_prime(n, k=128):
⍝      """ Test if a number is prime
⍝          Args:
⍝              n -- int -- the number to test
⍝              k -- int -- the number of tests to do
⍝          return True if n is prime
⍝      """
⍝      # Test if n is not even.
⍝      # But care, 2 is prime !
⍝      if n == 2 or n == 3:
⍝          return True
⍝      if n <= 1 or n % 2 == 0:
⍝          return False
⍝      # find r and s
⍝      s = 0
⍝      r = n - 1
⍝      while r & 1 == 0:
⍝          s += 1
⍝          r //= 2
⍝      # do k tests
⍝      for _ in range(k):
⍝          a = randrange(2, n - 1)
⍝          x = pow(a, r, n)
⍝          if x != 1 and x != n - 1:
⍝              j = 1
⍝              while j < s and x != n - 1:
⍝                  x = pow(x, 2, n)
⍝                  if x == 1:
⍝                      return False
⍝                  j += 1
⍝              if x != n - 1:
⍝                  return False
⍝      return True
⍝  

⍝  Return 1 if N is a likely prime to (integer) degree certainty:
⍝  where p >>  1 - .5*certainty, where p is the actual probability N is prime.
⍝ 
⍝  certainty: 1   2    3     4      5       10           20
⍝  p >>       0.5 0.75 0.875 0.9375 0.96875 0.9990234375 0.9999990463
⍝
⍝    /** When checking the probability of primes, it is most efficient to
⍝      * first check the factoring of small primes, so we'll use this array.
⍝     */
⍝     private static final int[] primes =
   primes← 2   3   5   7  11  13  17  19  23  29  31  37  41  43
   primes,←  47  53  59  61  67  71  73  79  83  89  97 101 103 107
   primes,←  109 113 127 131 137 139 149 151 157 163 167 173 179 181
   primes,←191 193 197 199 211 223 227 229 233 239 241 251 
⍝   
⍝     /** HAC (Handbook of Applied Cryptography)  Alfred Menezes & al. Table 4.4. */
⍝     private static final int[] k =
   MAXINT←bi.impU ¯1+2*31   ⍝ Unsigned bigInt
   k←100 150 200 250 300 350 400 500 600 800 1250 MAXINT ⍝ (¯1+2*31) MAXINT
⍝     private static final int[] t =
   t← 27  18  15  12   9   8   7   6   5   4    3  2
⍝  ---------------------
⍝       public boolean isProbablePrime(int certainty)
⍝      {
⍝        if (certainty < 1)
⍝          return true;
⍝    
   :if (certainty<1) ⋄ isTrue←1 ⋄ :return ⋄ :Endif 

   Nsgn Ndat←N←bi.import N 

⍝        /** We'll use the Rabin-Miller algorithm for doing a probabilistic
⍝         * primality test.  It is fast, easy and has faster decreasing odds of a
⍝         * composite passing than with other tests.  This means that this
⍝         * method will actually have a probability much greater than the
⍝         * 1 - .5^certainty specified in the JCL (p. 117), but I don't think
⍝         * anyone will complain about better performance with greater certainty.
⍝         *
⍝         * The Rabin-Miller algorithm can be found on pp. 259-261 of "Applied
⍝         * Cryptography, Second Edition" by Bruce Schneier.
⍝         */
⍝    
⍝        // First rule out small prime factors
⍝        BigInteger rem = new BigInteger();
⍝        int i;
⍝        for (i = 0; i < primes.length; i++)
     nSmall← 1=≢nDat
     :For i :in ⍳≢primes
⍝          {
⍝        if (words == null && ival == primes[i])
⍝          return true;
⍝    
⍝            divide(this, smallFixNums[primes[i] - minFixNum], null, rem, TRUNCATE);
⍝            if (rem.canonicalize().isZero())  
⍝                return false;
        :IF nSmall ⋄ :AndIf isTrue←primes[i]=data 
            :Return  
        :Endif 
        :IF 0 = Ndat bi.remU ,primes[i]
            isTrue←0 ⋄ :return  
        :Endif
    :EndFor
⍝          }
⍝    
⍝        // Now perform the Rabin-Miller test.
⍝    
⍝        // Set b to the number of times 2 evenly divides (this - 1).
⍝        // I.e. 2^b is the largest power of 2 that divides (this - 1).
⍝        BigInteger pMinus1 = add(this, -1);
⍝        int b = pMinus1.getLowestSetBit();
⍝
⍝        // Set m such that this = 1 + 2^b * m.
⍝        BigInteger m = pMinus1.divide(valueOf(2L << b - 1));
          pMinus1←bi._dec N
          b←0 ⋄ m∆←⊃⌽pMinus1
          :while 0=⊃⌽m∆ _←m∆ bi._divU ,2
                 b+←1 ⋄ m←m∆
          :endWhile
⍝    
⍝        // The HAC (Handbook of Applied Cryptography), Alfred Menezes & al. Note
⍝        // 4.49 (controlling the error probability) gives the number of trials
⍝        // for an error probability of 1/2**80, given the number of bits in the
⍝        // number to test.  we shall use these numbers as is if/when 'certainty'
⍝        // is less or equal to 80, and twice as much if it's greater.
⍝        int bits = this.bitLength();
⍝        for (i = 0; i < k.length; i++)
⍝          if (bits <= k[i])
⍝            break;
⍝        int trials = t[i];
⍝        if (certainty > 80)
⍝          trials *= 2;
⍝        BigInteger z;
⍝        for (int t = 0; t < trials; t++)
⍝          {
⍝            // The HAC (Handbook of Applied Cryptography), Alfred Menezes & al.
⍝            // Remark 4.28 states: "...A strategy that is sometimes employed
⍝            // is to fix the bases a to be the first few primes instead of
⍝            // choosing them at random.
⍝        z = smallFixNums[primes[t] - minFixNum].modPow(m, this);
⍝        if (z.isOne() || z.equals(pMinus1))
⍝          continue;            // Passes the test; may be prime.
⍝    
⍝        for (i = 0; i < b; )
⍝          {
⍝            if (z.isOne())
⍝              return false;
⍝            i++;
⍝            if (z.equals(pMinus1))
⍝              break;            // Passes the test; may be prime.
⍝    
⍝            z = z.modPow(valueOf(2), this);
⍝          }
⍝    
⍝        if (i == b && !z.equals(pMinus1))
⍝          return false;
⍝          }
⍝        return true;
⍝      }
