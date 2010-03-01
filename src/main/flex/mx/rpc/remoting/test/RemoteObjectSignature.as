package mx.rpc.remoting.test
{
   import org.hamcrest.Matcher;

   public class RemoteObjectSignature
   {
      private var signature : Array;
      private var _result : Object;
      
      public function RemoteObjectSignature(params : Array, result : Object)
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
            if(signature[i] is Matcher) //case for matchers
            {
               var matcher : Matcher = signature[i] as Matcher;
               if(!matcher.matches(call[i]))
               {
                  return false;
               }
            }
            else //case for literals
            {
               if(signature[i] != call[i])
               {
                  return false;
               }
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