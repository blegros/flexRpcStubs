package mx.rpc.http.test
{
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.Responder;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   
   import org.flexunit.Assert;
   import org.flexunit.async.Async;
   import org.hamcrest.text.containsString;

   public class HTTPServiceStubTest
   {
      private var fixture : HTTPServiceStub;
      
      [Before]
      public function setUp() : void
      {
         fixture = new HTTPServiceStub("http://someurl.com");
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
         
         fixture.result(null, null, "GET", "GOAL!");
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
         
         fixture.result(null, null, "GET", "GOAL!");
         
         var token : AsyncToken = fixture.send();
         token.addResponder(Async.asyncResponder(this, new Responder(result, fault), 2000));
      }
      
      [Test(async)]
      public function testSendWithFaultWithService() : void
      {
         var fault : Function = 
            function (event : FaultEvent, passThroughData : *) : void
            {
               var fault : Fault = event.fault;
               Assert.assertEquals("0", fault.faultCode);
               Assert.assertEquals("EPOCH FAIL", fault.faultString);
               Assert.assertEquals("some details", fault.faultDetail);
               Assert.assertNull(fault.rootCause);
            };
         
         fixture.fault(null, null, "GET", "0", "EPOCH FAIL", "some details");
         fixture.addEventListener(FaultEvent.FAULT, Async.asyncHandler(this, fault, 2000));
         
         fixture.send();
      }
      
      [Test(async)]
      public function testSendWithFaultWithToken() : void
      {
         var result : Function = 
            function (event : ResultEvent) : void
            {
               Assert.fail("NO RESULTS SHOULD BE AVAILABLE DURING THIS TEST!");
            };
         
         var fault : Function = 
            function (event : FaultEvent) : void
            {
               var fault : Fault = event.fault;
               Assert.assertEquals("0", fault.faultCode);
               Assert.assertEquals("EPOCH FAIL", fault.faultString);
               Assert.assertEquals("some details", fault.faultDetail);
               Assert.assertNull(fault.rootCause);
            };
         
         fixture.fault(null, null, "GET", "0", "EPOCH FAIL", "some details");
         
         var token : AsyncToken = fixture.send();
         token.addResponder(Async.asyncResponder(this, new Responder(result, fault), 2000));
      }
      
      [Test(async)]
      public function testSetResultDataWithParametersAndHeaders() : void
      {
         var params : Object = {query: "abcd1234", var1: containsString("attrib")};
         var headers : Object = {Accept: "text/plain", Host: containsString("w3.org")};
         var expected : Object = {passed: true};
         
         var result : Function =
            function (event : ResultEvent, passThroughData : * ) : void
            {
               Assert.assertEquals(expected, event.result);
            };
         
         fixture.result(params, headers, "GET", expected);
         fixture.addEventListener(ResultEvent.RESULT, Async.asyncHandler(this, result, 2000));
         fixture.headers = {Accept: "text/plain", Host: "www.w3.org"};
         fixture.send({query: "abcd1234", var1: "attrib1"});
      }
   }
}