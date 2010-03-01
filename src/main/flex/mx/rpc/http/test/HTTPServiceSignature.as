package mx.rpc.http.test
{
   import org.hamcrest.Matcher;

   public class HTTPServiceSignature
   {
      private var paramsSignature : Object;
      private var headersSignature : Object;
      private var _result : Object;      

      public function HTTPServiceSignature (params : Object, headers : Object, result : Object)
      {
         this.paramsSignature = params;
         this.headersSignature = headers;
         this._result = result;
      }

      public function matches (paramsCall : Object,  headersCall : Object = null) : Boolean
      {
         return objectsMatch(paramsSignature, paramsCall) && objectsMatch(headersSignature, headersCall);
      }

      private function objectsMatch (signature : Object,  call : Object) : Boolean
      {
         if(signature === call) //same instance?
         {
            return true;
         }
         
         if(!propertyLengthsMatch(signature, call))
         {
            return false;
         }
         
         for(var property : String in call)
         {
            if(!signature[property] && call[property]) //object property not in this signature
            {
               return false;
            }
            else if(signature[property] is Matcher) //case for matchers
            {
               var matcher : Matcher = signature[property] as Matcher;
               if(!matcher.matches(call[property]))
               {
                  return false;
               }
            }
            else //case for literals
            {
               if(signature[property] != call[property])
               {
                  return false;
               }
            }
         }

         return true;
      }
      
      private function propertyLengthsMatch(signature : Object, call : Object) : Boolean
      {
         var signatureCount : uint = 0;
         var callCount : uint = 0;
         var temp : String = null;
         
         for(temp in signature)
         {
            signatureCount++;
         }
         
         for(temp in call)
         {
            callCount++;
         }
         
         return signatureCount == callCount;
      }
      
      public function get result() : Object
      {
         return _result;
      }
   }
}