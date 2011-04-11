package mx.rpc.remoting.test
{
	import flash.utils.Dictionary;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.Fault;
	import mx.rpc.remoting.RemoteObject;
	
	[DefaultProperty("results")]
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
		
		
		[ArrayElementType("mx.rpc.remoting.test.OperationResultStub")]
		
		/** support for MXML stubbing of operation results
		 * 
		 * @param results
		 * 
		 */
		public function set results(results:Array):void
		{
			// process child results
			for each ( var resultStub: OperationResultStub in results) {
				this.setResult( resultStub.operationName, resultStub.args, resultStub.getResultOrFault(), resultStub.ignoreArgs);
			}
		}
		
		/**
		 * 
		 * @param methodName  operation name
		 * @param args  arguments (as array) for which the result is valid. pass null for any match
		 * @param data  result that will be returned
		 * 
		 */
		public function setResult(operationName : String, args : Array,  data : *, ignoreArgs: Boolean = false) : void
		{
			if(!operationName || operationName.length == 0)
			{
				throw new Error("Cannot use null or empty method names in RemoteObjectStub.");
			}
			
			if (!args) 
				args=[];
			
			if(!methods[operationName])
			{
				methods[operationName] = new Dictionary();
			}
			
			if(!ignoreArgs)
				methods[operationName][args.toString()] = data;
			else 
				methods[operationName][RemoteOperationStub.ANY_ARGUMENT] = data;
			
			
		}
		
		
		public function setFault(operationName : String, args : Array, code : String, string : String, detail : String, ignoreArgs: Boolean = false ) : void
		{
			var fault : Fault = new Fault(code, string, detail);
			this.setResult(operationName, args, fault,ignoreArgs);
		}
		
		/* modifed so as to use a standard Operation when no result or fault is set = partial stubbing */
		override public function getOperation(operationName : String) : AbstractOperation
		{
			if (operationName in methods)
				return new RemoteOperationStub(this, operationName, methods[operationName]);  
			else 
				return super.getOperation(operationName);
		}
	}
}
