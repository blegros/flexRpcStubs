package mx.rpc.http.test
{
   import mx.rpc.http.HTTPService;
   import mx.rpc.test.EqualityUtil;
   
   import org.hamcrest.Matcher;
   import org.hamcrest.object.equalTo;

   public class HTTPServiceSignature
   {
      private var paramsSignature : Object;
      private var headersSignature : Object;
      private var methodSignature : String;
      private var _result : Object;      

      public function HTTPServiceSignature (params : Object, headers : Object = null, method : String = "GET", result : Object = null)
      {
         this.paramsSignature = params;
         this.headersSignature = headers;
         this.methodSignature = method;
         this._result = result;
      }

      public function matches (paramsCall : Object,  headersCall : Object, methodCall : String) : Boolean
      {
         var methodMatches : Boolean = equalTo(methodCall.toUpperCase()).matches(methodSignature); 
         return objectsMatch(paramsSignature, paramsCall) && objectsMatch(headersSignature, headersCall) && methodMatches;
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
            
            var matcher : Matcher = EqualityUtil.valueToMatcher(signature[property]);
            if(!matcher.matches(call[property]))
            {
               return false;
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