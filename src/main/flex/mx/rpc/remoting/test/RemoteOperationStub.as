package mx.rpc.remoting.test
{

   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;

   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.IResponder;
   import mx.rpc.events.AbstractEvent;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.remoting.Operation;
   import mx.rpc.remoting.RemoteObject;
   import mx.rpc.remoting.test.RemoteObjectSignature;
   import mx.rpc.remoting.test.RemoteObjectStub;

   public class RemoteOperationStub extends Operation
   {
      public var signatures : Array;

      private var token : AsyncToken;
      private var args : Array;

      public function RemoteOperationStub (remoteObject : RemoteObject,  name : String,  signatures : Array)
      {
         super(remoteObject,  name);
         this.signatures = signatures;
      }

      override public function send (... args : Array) : AsyncToken
      {
         if(!args || (args.length == 0 && this.arguments))
         {
            if(this.arguments is Array)
            {
               args = this.arguments as Array;
            }
            else
            {
               args = [];
               for(var i : int = 0;  i < argumentNames.length;  ++i)
               {
                  args[i] = this.arguments[argumentNames[i]];
               }
            }
         }

         return configureResponseTimer(args);
      }

      private function configureResponseTimer (args : Array) : AsyncToken
      {
         token = new AsyncToken(null);
         this.args = args;

         var stub : RemoteObjectStub = RemoteObjectStub(service);

         //use a time to give time for the caller to map responders to the asyncToken
         var timer : Timer = new Timer(stub.delay,  1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,  handleTimer);

         timer.start();

         return token;
      }

      private function handleTimer (event : TimerEvent) : void
      {
         //find signature
         var result : Object = findSignatureResult(args);
         var resultEvent : AbstractEvent = generateEvent(result);

         //loop over all responders to emulate a successful call being made
         for each(var responder : IResponder in token.responders)
         {
            var response : Function = result is Fault ? responder.fault : responder.result;
            response.apply(null,  [resultEvent]);
         }

         //send the result event to the RemoteObject
         service.dispatchEvent(resultEvent);
      }

      private function findSignatureResult (args : Array) : Object
      {
         var found : RemoteObjectSignature = null;

         for each(var signature : RemoteObjectSignature in signatures)
         {
            if(signature.matches(args))
            {
               found = signature;
               break;
            }
         }

         if(!found)
         {
            throw new Error("No signature found for this call.");
         }

         return found.result;
      }

      private function generateEvent (result : Object) : AbstractEvent
      {
         if(result is Fault)
         {
            return new FaultEvent(FaultEvent.FAULT,  false,  true,  result as Fault);
         }
         else
         {
            return new ResultEvent(ResultEvent.RESULT,  false,  true,  result);
         }
      }
   }
}