 cookies force;InterceptedURLs;_;html;⎕IO
 ⎕IO←0
 :If ~force∊0 1
     'Sorry. right argument "force" must be 1 or 0.'
     :Return
 :EndIf

 html←∆HERE   ⍝ ⍠ SPACES CR
⍝      <!DOCTYPE html>
⍝      <html>
⍝      <head>
⍝      <script>

⍝      function setCookie(cname,cvalue,exdays){
⍝          var d=new Date ();
⍝          d.setTime(d.getTime ()+(exdays*24*60*60*1000));
⍝          var expires="expires="+d.toGMTString ();
⍝          document.cookie=cname+"="+cvalue+";"+expires+";path=/";
⍝      }

⍝      function getCookie(cname){
⍝          var name=cname+"=";
⍝          var decodedCookie=decodeURIComponent(document.cookie);
⍝          var ca=decodedCookie.split(';');
⍝          for(var i=0;i<ca.length;i++){
⍝              var c=ca[i];
⍝              while(c.charAt(0)==' '){
⍝                  c=c.substring(1);
⍝              }
⍝              if(c.indexOf(name)==0){
⍝                  return c.substring(name.length,c.length);
⍝              }
⍝          }
⍝          return "";
⍝      }

⍝      function checkCookie (){
⍝          var user=getCookie("DyalogCookie");
⍝          var force="⍞FORCE_VALUE⍞"
⍝          if(user!="" && force!="YES"){
⍝              alert("Welcome again "+user);
⍝          }else{
⍝              user=prompt("Please enter your name:","");
⍝              if(user!=""&&user!=null){
⍝                  setCookie("DyalogCookie ",user,30);
⍝              }
⍝          }
⍝      }

⍝      </script>
⍝      </head>
⍝      <body onload="checkCookie ()">
⍝      </body>
⍝      </html>

     html←'⍞FORCE_VALUE⍞' ⎕R (force⊃'NO' 'YES')  ⊣html

 InterceptedURLs←1 2⍴'*' 1
 _←InterceptedURLs{'ignore'⎕WC'HTMLRenderer'⍵('InterceptedURLs'⍺)}&html
