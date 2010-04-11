package mx.rpc.remoting.test
{
   import mx.rpc.test.EqualityUtil;
   
   import org.hamcrest.Matcher;

   public class RemoteObjectSignature
   {
      private var signature : Array;
      private var _result : Object;
      
      public function RemoteObjectSignature(params : Array, result : Object = null)
      {
         this.signature = params;
         this._result = result;
      }
      
      public function matches(call : Array) : Boolean
      {
         if(signature === call) //same instance?
         {
            return true;
         }
         
         if(signature.length != call.length)
         {
            return false;
         }
         
         var i : int = 0;
         for(i = 0; i < signature.length; i++)
         {
            var matcher : Matcher = EqualityUtil.valueToMatcher(signature[i]);
            if(!matcher.matches(call[i]))
            {
               return false;
            }
         }
         
         return true;
      }
      
      public function get result() : Object
      {
         return _result;
      }
   }
}