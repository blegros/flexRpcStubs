package mx.rpc.test
{
   import flash.utils.Dictionary;
   
   import mx.rpc.AbstractOperation;
   import mx.rpc.Fault;
   import mx.rpc.remoting.RemoteObject;

   public dynamic class RemoteObjectStub extends RemoteObject
   {
      private var _resultData : Dictionary;
      
      //default num of milliseconds to wait before dispatching events
      //don't put too low otherwise your token responders may not be registered
      public var delay : Number = 500;
      
      public function RemoteObjectStub(destination : String = null)
      {
         super(destination);
         _resultData = new Dictionary();
      }
      
      public function result(methodName : String, args : Array,  data : *) : void
      {
         if(!methodName || methodName.length == 0)
         {
            throw new Error("Cannot use null or empty method names in RemoteObjectStub.");
         }
         
         if(!args)
         {
            args = [];
         }
         
         if(!_resultData[methodName])
         {
            _resultData[methodName] = new Dictionary();
         }
         
         _resultData[methodName][args.toString()] = data;
      }
      
      public function fault(methodName : String, args : Array, code : String, string : String, detail : String) : void
      {
         var fault : Fault = new Fault(code, string, detail);
         this.result(methodName, args, fault);
      }
      
      override public function getOperation(name : String) : AbstractOperation
      {
         return new OperationStub(this, name, _resultData[name]);
      }
   }
}

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
import mx.rpc.test.RemoteObjectStub;

internal class OperationStub extends Operation
{
   public var _resultData : Dictionary;
   
   private var token : AsyncToken;
   private var args : Array;
   
   public function OperationStub(remoteObject : RemoteObject, name : String, resultData : Dictionary)
   {
      super(remoteObject, name);
      _resultData = resultData;
   }
   
   override public function send(... args:Array) : AsyncToken
   {
      if(!args || (args.length == 0 && this.arguments))
      {
         if (this.arguments is Array)
         {
            args = this.arguments as Array;
         }
         else
         {
            args = [];
            for (var i:int = 0; i < argumentNames.length; ++i)
            {
                args[i] = this.arguments[argumentNames[i]];
            }
         }
      }
      
      return configureResponseTimer(args);
   }
   
   private function configureResponseTimer(args : Array) : AsyncToken
   {
      token = new AsyncToken(null);
      this.args = args;
      
      var stub : RemoteObjectStub = RemoteObjectStub(service);
      
      //use a time to give time for the caller to map responders to the asyncToken
      var timer : Timer = new Timer(stub.delay, 1);
      timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);
      
      timer.start();
      
      return token;
   }
   
   private function handleTimer(event : TimerEvent) : void
   {
      //loop over all responders to emulate a successful call being made
      for each(var responder : IResponder in token.responders)
      {
         var response : Function = isFault(args) ? responder.fault : responder.result;
         response.apply(null, [generateEvent(args)]);
      }

      //send the result event to the RemoteObject as well
      service.dispatchEvent(generateEvent(args));
   }
   
   private function isFault(args : Array) : Boolean
   {
      return (_resultData[args.toString()] is Fault);
   }
   
   private function generateEvent(args : Array) : AbstractEvent
   {
      if(isFault(args))
      {
         return new FaultEvent(FaultEvent.FAULT, false, true, _resultData[args.toString()]);
      }
      else
      {
         var result : * = _resultData[args.toString()];
         return new ResultEvent(ResultEvent.RESULT, false, true, _resultData[args.toString()]);
      }
   }
}