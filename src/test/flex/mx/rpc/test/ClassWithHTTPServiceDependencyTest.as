package mx.rpc.test
{
   import mx.events.DynamicEvent;
   import mx.rpc.Fault;
   
   import org.flexunit.Assert;
   import org.flexunit.async.Async;
   
   public class ClassWithHTTPServiceDependencyTest
   {
      private var _classBeingTested : ClassWithHTTPServiceDependency;
      private var _stub : HTTPServiceStub;
      
      [Before]
      public function setUp() : void
      {
         _classBeingTested = new ClassWithHTTPServiceDependency();
         _stub = new HTTPServiceStub();
         _stub.delay = 500;
         _classBeingTested.service = _stub;
      }
      
      [Test(async)]
      public function testSendWithTokenResult() : void
      {
         _stub.result(null, "GOAL!");
         var result : Function = function (event : DynamicEvent, passThroughData : Object) : void
         {
            Assert.assertEquals("GOAL!", event.payload);
         };
            
         _classBeingTested.addEventListener(ClassWithHTTPServiceDependency.SUCCESS_EVENT, Async.asyncHandler(this, result, 2000));
         _classBeingTested.methodWithEventRegisteredOnToken();
      }
      
      [Test(async)]
      public function testSendWithClassResult() : void
      {
         _stub.result(null, "GOAL!");
         var result : Function = function (event : DynamicEvent, passThroughData : Object) : void
         {
            Assert.assertEquals("GOAL!", event.payload);
         };
            
         _classBeingTested.addEventListener(ClassWithHTTPServiceDependency.SUCCESS_EVENT, Async.asyncHandler(this, result, 2000));
         _classBeingTested.methodWithEventRegisteredOnService();
      }
      
      [Test(async)]
      public function testSendWithTokenFault() : void
      {
         _stub.fault(null, "0", "EPOCH FAIL", "some details");
         var result : Function = function (event : DynamicEvent, passThroughData : Object) : void
         {
            var fault : Fault = event.payload as Fault;
            Assert.assertEquals("0", fault.faultCode);
            Assert.assertEquals("EPOCH FAIL", fault.faultString);
            Assert.assertEquals("some details", fault.faultDetail);
         };
            
         _classBeingTested.addEventListener(ClassWithHTTPServiceDependency.FAIL_EVENT, Async.asyncHandler(this, result, 2000));
         _classBeingTested.methodWithEventRegisteredOnToken();
      }
      
      [Test(async)]
      public function testSendWithClassFault() : void
      {
         _stub.fault(null, "0", "EPOCH FAIL", "some details");
         var result : Function = function (event : DynamicEvent, passThroughData : Object) : void
         {
            var fault : Fault = event.payload as Fault;
            Assert.assertEquals("0", fault.faultCode);
            Assert.assertEquals("EPOCH FAIL", fault.faultString);
            Assert.assertEquals("some details", fault.faultDetail);
         };
            
         _classBeingTested.addEventListener(ClassWithHTTPServiceDependency.FAIL_EVENT, Async.asyncHandler(this, result, 2000));
         _classBeingTested.methodWithEventRegisteredOnService();
      }
   }
}