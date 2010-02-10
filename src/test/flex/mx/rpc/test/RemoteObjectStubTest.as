package mx.rpc.test
{
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.Responder;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   
   import org.flexunit.Assert;
   import org.flexunit.async.Async;
   
   public class RemoteObjectStubTest
   {
      private var fixture : RemoteObjectStub;
      
      [Before]
      public function setUp() : void
      {
         fixture = new RemoteObjectStub("someDummyDestination");
      }
      
      [After]
      public function tearDown() : void
      {
         fixture = null;
      }
      
      [Test(async)]
      public function testMethodResultWithService() : void
      {
          var result : Function = 
            function (event : ResultEvent, passThroughData : *) : void
            {
               Assert.assertEquals("GOAL!", event.result);
            };
         
         fixture.result("method1", null, "GOAL!");
         fixture.addEventListener(ResultEvent.RESULT, Async.asyncHandler(this, result, 2000));
         
         fixture.method1();
      }
      
      [Test(async)]
      public function testMethodResultWithToken() : void
      {
         var result : Function = 
            function (event : ResultEvent) : void
            {
               Assert.assertEquals("GOAL!", event.result);
            };
         
         var fault : Function = 
            function (event : FaultEvent) : void
            {
               Assert.fail("NO FAULTS SHOULD BE THROWN DURING THIS TEST!");
            };
         
         fixture.result("method1", null, "GOAL!");
         
         var token : AsyncToken = fixture.method1();
         token.addResponder(Async.asyncResponder(this, new Responder(result, fault), 2000));
      }
      
      [Test(async)]
      public function testMethodFaultWithService() : void
      {
         var expected : Fault = new Fault("0", "EPOCH FAIL", "some details");
         
         var fault : Function = 
            function (event : FaultEvent, passThroughData : *) : void
            {
               Assert.assertEquals(expected, event.fault);
            };
         
         fixture.result("method1", null, expected);
         fixture.addEventListener(FaultEvent.FAULT, Async.asyncHandler(this, fault, 2000));
         
         fixture.method1();
      }
      
      [Test(async)]
      public function testMethodFaultWithToken() : void
      {
         var expected : Fault = new Fault("0", "EPOCH FAIL", "some details");
         
         var result : Function = 
            function (event : ResultEvent) : void
            {
               Assert.fail("NO RESULTS SHOULD BE AVAILABLE DURING THIS TEST!");
            };
         
         var fault : Function = 
            function (event : FaultEvent) : void
            {
               Assert.assertEquals(expected, event.fault);
            };
         
         fixture.result("method1", null, expected);
         
         var token : AsyncToken = fixture.method1();
         token.addResponder(Async.asyncResponder(this, new Responder(result, fault), 2000));
      }
      
      [Test(async)]
      public function testMethodResultWithNoParams() : void
      {
         var expected : Object = {passed: true};
         
         var result : Function =
            function (event : ResultEvent, passThroughData : * ) : void
            {
               Assert.assertEquals(expected, event.result);
            };
         
         fixture.result("emptyMethod", null, expected);
         fixture.addEventListener(ResultEvent.RESULT, Async.asyncHandler(this, result, 2000));
         fixture.emptyMethod();
      }
      
      [Test(async)]
      public function testMethodResultWithParams() : void
      {
         var params : Array = [{query: "some query string"}, "param2", ["blah"]];
         var expected : Object = {passed: true};
         
         var result : Function =
            function (event : ResultEvent, passThroughData : * ) : void
            {
               Assert.assertEquals(expected, event.result);
            };
         
         fixture.result("methodWithParams", params, expected);
         fixture.addEventListener(ResultEvent.RESULT, Async.asyncHandler(this, result, 2000));
         fixture.methodWithParams(params);
      }
   }
}