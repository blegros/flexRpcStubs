package mx.rpc.test
{
   import flash.events.EventDispatcher;
   
   import mx.events.DynamicEvent;
   import mx.rpc.AsyncToken;
   import mx.rpc.Responder;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.http.HTTPService;
   
   [Event(name='successEvent', type='mx.events.DynamicEvent')]
   [Event(name='failEvent', type='mx.events.DynamicEvent')]
   public class ClassWithHTTPServiceDependency extends EventDispatcher
   {
      public static const SUCCESS_EVENT : String = "successEvent";
      public static const FAIL_EVENT : String = "failEvent";
      public static const PARAMS : Object = {query: "some text"};
      
      public var service : HTTPService;
      
      public function ClassWithHTTPServiceDependency()
      {
         this.service = new HTTPService();
      }

      public function methodWithEventRegisteredOnToken() : void
      {
         var token : AsyncToken = service.send();
         token.addResponder(new Responder(resultRecieved, faultRecieved));
      }
      
      public function methodWithEventRegisteredOnService() : void
      {
         service.addEventListener(ResultEvent.RESULT, resultRecieved);
         service.addEventListener(FaultEvent.FAULT, faultRecieved);
         
         service.send();
      }
      
      private function resultRecieved(event : ResultEvent) : void
      {
         var success : DynamicEvent = new DynamicEvent(SUCCESS_EVENT);
         success.payload = event.result;
         
         this.dispatchEvent(success);
      }
      
      private function faultRecieved(event : FaultEvent) : void
      {
         var fail : DynamicEvent = new DynamicEvent(FAIL_EVENT);
         fail.payload = event.fault;
         
         this.dispatchEvent(fail);
      }
   }
}