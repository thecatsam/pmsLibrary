      
      ∇TEST __
        ;fns
          :IF 0=⎕NC 'CMPX'
             ⎕SE.UCMD 'load CMPX'
          :ENDIF 
          fns←'hash' 'hash4' 'hashAP' 'hashCRC' 'hashDJB2'
          fns,←'hashFast' 'hashK' 'hashKnuth' 'hashPy' 'hashTab' 'hashX'
          cmds←fns,¨⊂' __'
          'Comparing ',(⍕≢fns),' hash functions. Argument length: ',(⍕≢__)
          '   'fns
          (≢__) CMPX  cmds
      ∇
      hash←{
       ⍝ result ← [seed←660774557] hash string:CA
       ⍝ Returns 32-bit signed hash from a simple char array of any size and a seed (primes are good)
       ⍝ Pseudocode:
       ⍝    Create hashRaw: h[N] ←  int32 < (33×h[N-1]) + c[N] >
       ⍝                            where c[N] the Nth char of string
       ⍝                            int32<ø> is the int32 version of ø
       ⍝    Create hash:    hash ←  (⊂offset ⌽ mixed) ⌷ bits32<hashRaw>
       ⍝                            where offset←32|hashRaw, a number between 0 and 31
       ⍝                            given mixed is an "arbitrary" distribution of 32 bits
       ⍝                            and bits32<ø> is ø viewed as 32 bits.
       ⍝    Return:         hash
          ⍺←660774557
          1<|≡⍵:⍺ ∇¨⍵
          ⎕FR ⎕IO←645 0 ⋄ int32←(2*31)∘| ⋄ bits32←{32↑11 ⎕DR ⍵} ⋄ int32b←323∘⎕DR
       ⍝  Hash: create raw 32-bit hash, char by char, starting with a 32-bit prime hash 'seed'
          initial←⍺
          hashString←initial∘{
              0=≢⍵:⍺
              c←⎕UCS⊃⍵
              (1↓⍵)∇⍨int32 c+⍺×33
          }∘,
       ⍝  Mix: distribute bits of h arbitrarily, as a function of 32|h
          mixed←19 29 25 11 30 14 10 20 28 0 9 18 12 13 31 21 15 27 22 26 16 5 17 3 23 24 6 7 4 8 2 1
          mixBits←mixed∘{
              off←⊂⍺⌽⍨32|⍵                 ⍝ Rotate mixed bits by 0-31, depending on hash value
              mix←off⌷bits32 ⍵             ⍝ Convert to (32) bits and mix
              ⍬⍴int32b mix                ⍝ Return as int32
          }
       ⍝  Go!
          mixBits hashString ⍵
      }

      hash4←{
          ⎕IO←0
          1<|≡⍵:∇¨⍵
          ⊃323 ⎕DR≠⌿f⌽⍨⍳≢f←11 ⎕DR⍪323 ⎕DR(4×⌈4÷⍨≢u8)⍴u8,3⍴≢u8←'UTF-8'⎕UCS ⍵
      }

      hashAP←{
        ⍝ Arash Partow hash
        ⍝    unsigned int hash = 0xAAAAAAAA;
        ⍝    for (i = 0; i < length; ++str, ++i)
        ⍝       hash ^= ((i & 1) == 0) ? (  (hash <<  7)  ^ (*str) * (hash >> 3)) :
        ⍝                                (~((hash << 11) + ((*str) ^ (hash >> 5))));
        ⍝ Extension: if ⍺ is 1, we'll chunk into 4-byte UTF-8 sequences instead of single chars
        ⍝    (Runs about 2-3 times faster [more on longer strings]
          ⍺←0 ⋄ 1<|≡⍵:⍺ ∇¨⍵
          BOOL←{32↑11 ⎕DR ⍵} ⋄ INT←323∘⎕DR
          h0←⊂32⍴1 0                        ⍝ h0: 32⍴1 0; Signed dec int ¯1431655766  ; Hex 0xAAAAAAAA
          flag←1
        ⍝ 15% faster to keep ⍵ boolean during the fold (including h0)
          map←{                             ⍝ ⍺: int32, ⍵: bool32
              flag∘←~flag ⋄ aB←BOOL ⍺
              flag:(7⌽h)≠aB≠¯3⌽h←⍵  ⍝ ⌽ in place of shiftL/R
              ~(11⌽h)≠aB≠¯5⌽h←⍵
          }
          ~⍺:INT⊃map/h0,⍨⎕UCS⌽,⍵
          ∆UCS←{80=⎕DR ⍵:⎕UCS ⍵ ⋄ 'UTF-8'⎕UCS ⍵}
          INT⊃map/h0,⍨323 ⎕DR(0⍴⍨4|4-4|≢,⍵),∆UCS⌽,⍵
      }

    ∇ h←hashCRC s;by;crcTable;⎕IO;seed
      ⎕IO←0
      i2b←{32↑11 ⎕DR ⍵} ⋄ b2i←323∘⎕DR
      seed←i2b 255
    ⍝ See crcTable function (256 entries)
      crcTable←0 1996959894 ¯1846436140 ¯420041146 124634137 1886057615 ¯1768138037 ¯509908387 249268274 2044508324 ¯1624631582 ¯399694216 162941995 2125561021 ¯1740123399 ¯280960401 498536548 1789927666 ¯1941533000 ¯79577566 450548861 1843258603 ¯1960097105 ¯64193991 325883990 1684777152 ¯2103638394 ¯174442988 335633487 1661365465 ¯2047819107 ¯218631669 997073096 1281953886 ¯1432371684 ¯577204594 1006888145 1258607687 ¯1376617981 ¯621458795 901097722 1119000684 ¯1539033558 ¯750582080 853044451 1172266101 ¯1557532111 ¯735133017 651767980 1373503546 ¯1222070656 ¯1070620950 565507253 1454621731 ¯1337628057 ¯951952655 671266974 1594198024 ¯1175247282 ¯822864164 795835527 1483230225 ¯1096883627 ¯912665917 1994146192 31158534 ¯416424124 ¯1876234282 1907459465 112637215 ¯532669605 ¯1756943411 2013776290 251722036 ¯369731726 ¯1628346392 2137656763 141376813 ¯291794071 ¯1717787649 1802195444 476864866 ¯90517720 ¯1919025230 1812370925 453092731 ¯34141377 ¯1963967575 1706088902 314042704 ¯197048554 ¯2092533884 1658658271 366619977 ¯215186675 ¯2077510757 1303535960 984961486 ¯599523444 ¯1421553890 1256170817 1037604311 ¯617727085 ¯1406596347 1131014506 879679996 ¯761759814 ¯1516288208 1141124467 855842277 ¯705317983 ¯1561165001 1342533948 654459306 ¯1040912400 ¯1225531526 1466479909 544179635 ¯963040265 ¯1315038367 1591671054 702138776 ¯818976802 ¯1205315764 1504918807 783551873 ¯935156795 ¯1085959341 ¯1840808736 ¯448770998 62317068 1957810842 ¯1792362297 ¯500332463 81470997 1943803523 ¯1667435282 ¯342113156 225274430 2053790376 ¯1678692107 ¯319422365 167816743 2097651377 ¯1880068932 ¯118006738 503444072 1762050814 ¯2002933597 ¯6645707 426522225 1852507879 ¯2127829878 ¯164834272 282753626 1742555852 ¯2042224495 ¯247394297 397917763 1622183637 ¯1456907240 ¯567382910 953729732 1340076626 ¯1371236337 ¯649877351 1068828381 1219638859 ¯1477258202 ¯789191500 906185462 1090812512 ¯1600188355 ¯677896021 829329135 1181335161 ¯1264694156 ¯1013351194 628085408 1382605366 ¯1275885461 ¯990594819 570562233 1426400815 ¯1169832894 ¯851249960 733239954 1555261956 ¯1121451943 ¯902876977 752459403 1541320221 ¯459588272 ¯1818489382 1969922972 40735498 ¯470353577 ¯1796093503 1913087877 83908371 ¯364857986 ¯1656257044 2075208622 213261112 ¯315788955 ¯1708506637 2094854071 198958881 ¯114545364 ¯1909776962 1759359992 534414190 ¯29234893 ¯1991845467 1873836001 414664567 ¯134765286 ¯2131716720 1711684554 285281116 ¯258318079 ¯2019733097 1634467795 376229701 ¯537584248 ¯1460523758 1308918612 956543938 ¯661071457 ¯1348474615 1231636301 1047427035 ¯785476170 ¯1507220188 1088359270 936918000 ¯700231251 ¯1589354181 1202900863 817233897 ¯1035858460 ¯1253753482 1404277552 615818150 ¯986723845 ¯1305937555 1423857449 601450431 ¯862353966 ¯1147226808 1567103746 711928724 ¯873184823 ¯1124896417 1510334235 755167117
     
      by←'UTF-8'⎕UCS,s                             ⍝ Generate 8-byte entries...
      h←b2i seed{                                 ⍝ Grab int32s based on bytes + prior elements
          0=≢⍵:⍺
          h←⍺
          h≠←11 ⎕DR crcTable[256|b2i ⍺≠i2b⊃⍵]     ⍝ Here, std:  ⍺ xor c, where c←⊃s
          h ∇ 1↓⍵
      }by
    ∇

      hashDJB2←{
        ⍝ A Dan Bernstein hash
        ⍝ djb2
        ⍝ /* initial: 5381. hash ← hash × 33 + c */
          1<|≡⍵:∇¨⍵
     
          i32←2147483648   ⍝ 2*31
          init←5381        ⍝ int16: 5831
          ⊃{
              i32|⍺+⍵×33    ⍝ Handles multibyte chars...
          }/⌽init,⎕UCS ⍵    ⍝ init is never ⍺
      }

      hashFast←{
          1<|≡⍵:∇¨⍵
          nI←≢bufI←('UTF-8'⎕UCS,⍵),83 ⎕DR≢⍵
          of←0
          ⊃323 ⎕DR⊃{of∘←nI|of+1 ⋄ ⍺≠⍵⌽⍨of⌷bufI}⌿↓11 ⎕DR(3⌈⌈0.25×≢bufI)4⍴bufI
      }

      hashK←{
        ⍝  hash ← [seed←660774557] hashK string (or string1 string2...)
        ⍝  ⍝ Knuth hashing
        ⍝     unsigned int DEKHash(const char* str, unsigned int length)
        ⍝       hash[N] = ((hash[N-1] << 5) ^ (hash[N-1] >> 27)) ^ (*str);
        ⍝ Since int32b must return a 32-bit integer, we don't need to force into 32-bit range
          ⍺←660774557
          2=≡⍵:⍺ ∇¨⍵
   ⍝ bits32c/i: convert single char or int (1, 2, 4 bytes) to 32 bit int
   ⍝ int32b:  convert 32-bit rep of int to APL integer
          bits32i←bits32c←{32↑11 ⎕DR ⍵} ⋄ int32b←⊢∘⊃∘(323∘⎕DR)
  ⍝  Hash: create raw 32-bit hash, char by char, starting with a 32-bit prime hash 'seed'
  ⍝  ⍺: initial hash is an extension. Knuth used 0.
          (bits32i ⍺)∘{
              0=≢⍵:int32b ⍺
              (1↓⍵)∇⍨(bits32c⊃⍵)≠(5⌽⍺)
          }∘,⍵
      }

      hashKnuth←{
        ⍝  h ← [seed←660774557] hashK string (or string1 string2...)
        ⍝  Knuth hashing (modified)
        ⍝     unsigned int DEKHash(const char* str, unsigned int length)
        ⍝       hash[N] = ((hash[N-1] << 5) ^ (hash[N-1] >> 27)) ^ (*str);
        ⍝ Since int32b must return a 32-bit integer, we don't need to force into 32-bit range
          ⍺←660774557
          1<|≡⍵:⍺ ∇¨⍵
          ab←11 ⎕DR ⍺
   ⍝ bits32c/i: convert single char or int (1, 2, 4 bytes) to 32 bit int
   ⍝ int32b:  convert 32-bit rep of int to APL integer
          int32b←⊢∘⊃∘(323∘⎕DR)
  ⍝  Hash: create raw 32-bit hash, char by char, starting with a 32-bit prime hash 'seed'
  ⍝  ⍺: initial hash is an extension. Knuth used 0.
  ⍝  MODIFIEDis a lot faster than STD
  ⍝  MODIFIED - convert entire string to bits and grab 32 at a time!
          s←↓((⌈r÷32)32⊣r←≢s)⍴(s←ab,11 ⎕DR ⍵),31⍴0
          int32b⊃{⍵≠5⌽⍺}/s
      }

      hashPy←{
   ⍝ Built on Python's hashing function with additions...
          1<|≡⍵:∇¨⍵ ⋄ ⎕IO←0
   ⍝        in          out
   ⍝ bI     bits        int32
   ⍝ cI8    string      UTF-8 as 8-bit int
   ⍝ nB     num         bits
   ⍝ xB     num/char    bits
   ⍝ xB32   num/char    32 bits
          bI←323∘⎕DR ⋄ nB←(2*31)∘{11 ⎕DR ⍺|⍵} ⋄ xB←11∘⎕DR ⋄ xB32←{32↑11 ⎕DR ⍵}
          cI8←'UTF-8'∘⎕UCS
   ⍝ 32-bit primes.  For initial hash, python uses the string pointer p
          primes←4758751 4758757 4758791 4758799 4758811 4758821 4758823 4758833 4758847 4758857 4758863 4758893 4758913 4758931 4758937 4758959
          strn←cI8 ⍵
          init←xB((≢primes)|⊃strn)⌷primes
     
          hash←init{h s←⍺ ⍵
              0=≢⍵:⍺
              h←((⊃s)⌽nB 1000003×bI h)≠xB32⊃s ⍝ We add (⊃s)⌽... to mix bits...
              h ∇ 1↓s
          }strn
          ⊃bI hash≠7⌽xB32≢strn
     
        ⍝ static long string_hash(PyStringObject *a)
        ⍝ {
        ⍝     register Py_ssize_t len;
        ⍝     register unsigned char *p;
        ⍝     register long x;
     
        ⍝     if (a->ob_shash != -1)
        ⍝         return a->ob_shash;
        ⍝     len = Py_SIZE(a);                  ⍝ len of string
        ⍝     p = (unsigned char *) a->ob_sval;  ⍝ ptr to string
        ⍝     x = *p << 7;
        ⍝     while (--len >= 0)
        ⍝         x = (1000003*x) ^ *p++;
        ⍝     x ^= Py_SIZE(a);             ⍝
        ⍝     if (x == -1)
        ⍝         x = -2;
        ⍝     a->ob_shash = x;
        ⍝     return x;
        ⍝ }
      }

      hashTab←{
        ⍝ hash ←  [mix] hashT strings
        ⍝    strings:  1 or more char vectors (or scalars)
        ⍝    mix:      if defined to 1, result will be mixed by an extra bit shift
        ⍝    hash:     1 or more int32s (or smaller)
        ⍝ An table-driven alternative to hashCRC that's as fast as possible...
        ⍝ seed←119 ¯115 122 121    ⍝  seed ← 83 ⎕DR 2038074743   ⍝ A Prime #...
        ⍝ iT: table of 32-bit integers (std CRC table). We process as bits.
          ⎕IO←0 ⋄ ⍺←0
          1<|≡⍵:⍺ ∇¨⍵
          iT←¯441845639 1996959894 ¯1846436140 ¯420041146 124634137 1886057615 ¯1768138037 ¯509908387 249268274 2044508324 ¯1624631582 ¯399694216 162941995 2125561021 ¯1740123399 ¯280960401 498536548 1789927666 ¯1941533000 ¯79577566 450548861 1843258603 ¯1960097105 ¯64193991 325883990 1684777152 ¯2103638394 ¯174442988 335633487 1661365465 ¯2047819107 ¯218631669 997073096 1281953886 ¯1432371684 ¯577204594 1006888145 1258607687 ¯1376617981 ¯621458795 901097722 1119000684 ¯1539033558 ¯750582080 853044451 1172266101 ¯1557532111 ¯735133017 651767980 1373503546 ¯1222070656 ¯1070620950 565507253 1454621731 ¯1337628057 ¯951952655 671266974 1594198024 ¯1175247282 ¯822864164 795835527 1483230225 ¯1096883627 ¯912665917 1994146192 31158534 ¯416424124 ¯1876234282 1907459465 112637215 ¯532669605 ¯1756943411 2013776290 251722036 ¯369731726 ¯1628346392 2137656763 141376813 ¯291794071 ¯1717787649 1802195444 476864866 ¯90517720 ¯1919025230 1812370925 453092731 ¯34141377 ¯1963967575 1706088902 314042704 ¯197048554 ¯2092533884 1658658271 366619977 ¯215186675 ¯2077510757 1303535960 984961486 ¯599523444 ¯1421553890 1256170817 1037604311 ¯617727085 ¯1406596347 1131014506 879679996 ¯761759814 ¯1516288208 1141124467 855842277 ¯705317983 ¯1561165001 1342533948 654459306 ¯1040912400 ¯1225531526 1466479909 544179635 ¯963040265 ¯1315038367 1591671054 702138776 ¯818976802 ¯1205315764 1504918807 783551873 ¯935156795 ¯1085959341 ¯1840808736 ¯448770998 62317068 1957810842 ¯1792362297 ¯500332463 81470997 1943803523 ¯1667435282 ¯342113156 225274430 2053790376 ¯1678692107 ¯319422365 167816743 2097651377 ¯1880068932 ¯118006738 503444072 1762050814 ¯2002933597 ¯6645707 426522225 1852507879 ¯2127829878 ¯164834272 282753626 1742555852 ¯2042224495 ¯247394297 397917763 1622183637 ¯1456907240 ¯567382910 953729732 1340076626 ¯1371236337 ¯649877351 1068828381 1219638859 ¯1477258202 ¯789191500 906185462 1090812512 ¯1600188355 ¯677896021 829329135 1181335161 ¯1264694156 ¯1013351194 628085408 1382605366 ¯1275885461 ¯990594819 570562233 1426400815 ¯1169832894 ¯851249960 733239954 1555261956 ¯1121451943 ¯902876977 752459403 1541320221 ¯459588272 ¯1818489382 1969922972 40735498 ¯470353577 ¯1796093503 1913087877 83908371 ¯364857986 ¯1656257044 2075208622 213261112 ¯315788955 ¯1708506637 2094854071 198958881 ¯114545364 ¯1909776962 1759359992 534414190 ¯29234893 ¯1991845467 1873836001 414664567 ¯134765286 ¯2131716720 1711684554 285281116 ¯258318079 ¯2019733097 1634467795 376229701 ¯537584248 ¯1460523758 1308918612 956543938 ¯661071457 ¯1348474615 1231636301 1047427035 ¯785476170 ¯1507220188 1088359270 936918000 ¯700231251 ¯1589354181 1202900863 817233897 ¯1035858460 ¯1253753482 1404277552 615818150 ¯986723845 ¯1305937555 1423857449 601450431 ¯862353966 ¯1147226808 1567103746 711928724 ¯873184823 ¯1124896417 1510334235 755167117
          bits←≠⌿11 ⎕DR⍪iT[⌽256|(1+⍳≢e8)×e8←119 ¯115 122 121,'UTF-8'⎕UCS ⍵]
          ~⍺:⊃323 ⎕DR bits
          ⊃323 ⎕DR(17⌽bits)≠¯11⌽bits        ⍝ Mix!
        ⍝ 1     2  3                 4         5                6
        ⍝ [1] bits to 32-bit int
        ⍝ [2] xor mapping from string to bits, from start to end
        ⍝ [3] int32 table to 256×32 bit rep
        ⍝ [4] table row based on character AND order
        ⍝ [5] seed: 32-bit mapping from prime, to ensure good mix for small strings
        ⍝ [6] convert string to UTF-8, so each char is reasonably compact (few leading 0s).
      }

      hashX←{⎕IO←0
          1<|≡⍵:∇¨⍵
          prime←2106722209
          n←⌈32÷⍨≢buf←∊11∘⎕DR¨prime(≢⍵)(⌽⍵)
          ⊃323 ⎕DR⊃bits←{(11⌽⍺)≠¯7⌽⍵}/↓n 32⍴buf
      }
