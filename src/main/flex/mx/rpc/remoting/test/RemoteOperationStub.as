package mx.rpc.remoting.test
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.messaging.messages.RemotingMessage;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.AbstractEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.Operation;
	import mx.rpc.remoting.RemoteObject;
	import mx.utils.StringUtil;
	
	
	public class RemoteOperationStub extends Operation
	{
		public static const ANY_ARGUMENT: Object = { id: "*" };  // special marker, by identity
		
		
		public var _resultDataDic : Dictionary;
		
		private var token : AsyncToken;
		private var args : Array;
		
		public function RemoteOperationStub(remoteObject : RemoteObject, name : String, resultData : Dictionary)
		{
			super(remoteObject, name);
			_resultDataDic = resultData;
		}
		
		override public function send(... args:Array) : AsyncToken
		{
			return configureResponseTimer(args);
		}
		
		private function configureResponseTimer(args : Array) : AsyncToken
		{
			
			this.args = args;
			
			var message:RemotingMessage = new RemotingMessage();
			message.operation = name;
			message.body = args;
			token = new AsyncToken(message);
			
			var stub : RemoteObjectStub = RemoteObjectStub(service);
			
			//use a time to give time for the caller to map responders to the asyncToken
			var timer : Timer = new Timer(stub.delay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);
			
			timer.start();
			
			return token;
		}
		
		private function handleTimer(event : TimerEvent) : void
		{
			var resultData: Object = _resultDataDic[args.toString()];
			if (!resultData) {
				// try first with any arg
				resultData = _resultDataDic[ANY_ARGUMENT];
				if (!resultData)
					throw new Error(StringUtil.substitute("OperationStub {0} has no result or fault for args {1} or ignoreArgs was not set to true ", name, args.toString()));
			}
			var isF: Boolean = resultData is Fault;
			
			//loop over all responders to emulate a successful call being made
			for each(var responder : IResponder in token.responders)
			{
				var response : Function = isF ? responder.fault : responder.result;
				response.apply(null, [generateEvent(resultData,isF)]);
			}
			
			//send the result event to the RemoteObject as well
			service.dispatchEvent(generateEvent(resultData,isF));
		}
		
		private function isFault(args : Array) : Boolean
		{
			return (  _resultDataDic[args.toString()] is Fault);
		}
		
		private function generateEvent(data: Object, isF: Boolean ) : AbstractEvent
		{
			if(isF)
			{
				return new FaultEvent(FaultEvent.FAULT, false, true,  data as Fault);
			}
			else
			{
				return new ResultEvent(ResultEvent.RESULT, false, true, data);
			}
		}
	}
}

