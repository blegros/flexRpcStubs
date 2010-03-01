package mx.rpc.remoting.test
{
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.Responder;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   
   import org.flexunit.Assert;
   import org.flexunit.async.Async;
   import org.hamcrest.text.containsString;
   
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
      
      [Test]
      public function testGetOperation() : void
      {
         Assert.assertTrue(fixture.getOperation("blah") is RemoteOperationStub);
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
         var rootCause : Object = {};
         
         var fault : Function = 
            function (event : FaultEvent, passThroughData : *) : void
            {
               var fault : Fault = event.fault;
               Assert.assertEquals("0", fault.faultCode);
               Assert.assertEquals("EPOCH FAIL", fault.faultString);
               Assert.assertEquals("some details", fault.faultDetail);
               Assert.assertStrictlyEquals(rootCause, fault.rootCause);
            };
         
         fixture.fault("method1", null, "0", "EPOCH FAIL", "some details", rootCause);
         fixture.addEventListener(FaultEvent.FAULT, Async.asyncHandler(this, fault, 2000));
         
         fixture.method1();
      }
      
      [Test(async)]
      public function testMethodFaultWithToken() : void
      {
         var result : Function = 
            function (event : ResultEvent) : void
            {
               Assert.fail("NO RESULTS SHOULD BE AVAILABLE DURING THIS TEST!");
            };
         
         var rootCause : Object = {};
         
         var fault : Function = 
            function (event : FaultEvent) : void
            {
               var fault : Fault = event.fault;
               Assert.assertEquals("0", fault.faultCode);
               Assert.assertEquals("EPOCH FAIL", fault.faultString);
               Assert.assertEquals("some details", fault.faultDetail);
               Assert.assertStrictlyEquals(rootCause, fault.rootCause);
            };
         
         fixture.fault("method1", null, "0", "EPOCH FAIL", "some details", rootCause);
         
         var token : AsyncToken = fixture.method1();
         token.addResponder(Async.asyncResponder(this, new Responder(result, fault), 2000));
      }
      
      [Test(async)]
      public function testMethodResultWithParams() : void
      {
         var signature : Array = [containsString("blah"), "param2"];
         var expected : Object = {passed: true};
         
         var result : Function =
            function (event : ResultEvent, passThroughData : * ) : void
            {
               Assert.assertEquals(expected, event.result);
            };
         
         fixture.result("methodWithParams", signature, expected);
         fixture.addEventListener(ResultEvent.RESULT, Async.asyncHandler(this, result, 2000));
         fixture.methodWithParams("blah1", "param2");
      }
   }
}