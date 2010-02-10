package mx.rpc.test
{
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.Responder;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   
   import org.flexunit.Assert;
   import org.flexunit.async.Async;

   public class HTTPServiceStubTest
   {
      private var fixture : HTTPServiceStub;
      
      [Before]
      public function setUp() : void
      {
         fixture = new HTTPServiceStub("http://someurl.com");
         fixture.delay = 500;
      }
      
      [After]
      public function tearDown() : void
      {
         fixture = null;
      }
      
      [Test(async)]
      public function testSendWithResultWithService() : void
      {
         var result : Function = 
            function (event : ResultEvent, passThroughData : *) : void
            {
               Assert.assertEquals("GOAL!", event.result);
            };
         
         fixture.result(null, "GOAL!");
         fixture.addEventListener(ResultEvent.RESULT, Async.asyncHandler(this, result, 2000));
         
         fixture.send();
      }
      
      [Test(async)]
      public function testSendWithResultWithToken() : void
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
         
         fixture.result(null, "GOAL!");
         
         var token : AsyncToken = fixture.send();
         token.addResponder(Async.asyncResponder(this, new Responder(result, fault), 2000));
      }
      
      [Test(async)]
      public function testSendWithFaultWithService() : void
      {
         var expected : Fault = new Fault("0", "EPOCH FAIL", "some details");
         
         var fault : Function = 
            function (event : FaultEvent, passThroughData : *) : void
            {
               Assert.assertEquals(expected, event.fault);
            };
         
         fixture.result(null, expected);
         fixture.addEventListener(FaultEvent.FAULT, Async.asyncHandler(this, fault, 2000));
         
         fixture.send();
      }
      
      [Test(async)]
      public function testSendWithFaultWithToken() : void
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
         
         fixture.result(null, expected);
         
         var token : AsyncToken = fixture.send();
         token.addResponder(Async.asyncResponder(this, new Responder(result, fault), 2000));
      }
      
      [Test(async)]
      public function testSetResultDataWithNullParameters() : void
      {
         var expected : Object = {passed: true};
         
         var result : Function =
            function (event : ResultEvent, passThroughData : * ) : void
            {
               Assert.assertEquals(expected, event.result);
            };
         
         fixture.result(null, expected);
         fixture.addEventListener(ResultEvent.RESULT, Async.asyncHandler(this, result, 2000));
         fixture.send();
      }
      
      [Test(async)]
      public function testSetResultDataWithNonNullParameters() : void
      {
         var params : Object = {query: "some query string"};
         var expected : Object = {passed: true};
         
         var result : Function =
            function (event : ResultEvent, passThroughData : * ) : void
            {
               Assert.assertEquals(expected, event.result);
            };
         
         fixture.result(params, expected);
         fixture.addEventListener(ResultEvent.RESULT, Async.asyncHandler(this, result, 2000));
         fixture.send(params);
      }
   }
}