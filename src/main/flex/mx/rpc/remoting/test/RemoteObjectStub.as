package mx.rpc.remoting.test
{
   import flash.utils.Dictionary;
   
   import mx.rpc.AbstractOperation;
   import mx.rpc.Fault;
   import mx.rpc.remoting.RemoteObject;

   public dynamic class RemoteObjectStub extends RemoteObject
   {
      private var methods : Dictionary;
      
      //default num of milliseconds to wait before dispatching events
      //don't put too low otherwise your token responders may not be registered
      public var delay : Number = 500;
      
      public function RemoteObjectStub(destination : String = null)
      {
         super(destination);
         methods = new Dictionary();
      }
      
      public function result(methodName : String, args : Array,  data : Object) : void
      {
         if(!methodName || methodName.length == 0)
         {
            throw new Error("Cannot use null or empty method names in RemoteObjectStub.");
         }
         
         if(!args)
         {
            args = [];
         }
         
         if(!methods[methodName])
         {
            methods[methodName] = new Array();
         }
         
         methods[methodName].push(new RemoteObjectSignature(args, data));
      }
      
      public function fault(methodName : String, args : Array, code : String, string : String, detail : String, rootCause : Object) : void
      {
         var fault : Fault = new Fault(code, string, detail);
         fault.rootCause = rootCause;
         
         this.result(methodName, args, fault);
      }
      
      override public function getOperation(name : String) : AbstractOperation
      {
         return new RemoteOperationStub(this, name, methods[name]);
      }
   }
}