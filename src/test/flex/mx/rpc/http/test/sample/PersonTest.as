package mx.rpc.http.test.sample
{
   import flash.events.Event;
   
   import mx.rpc.events.FaultEvent;
   import mx.rpc.http.test.HTTPServiceStub;
   
   import org.flexunit.Assert;
   import org.flexunit.async.Async;
   import org.hamcrest.core.anything;
   import org.hamcrest.text.containsString;

   public class PersonTest
   {
      private var fixture : Person;        //class under test
      private var stub : HTTPServiceStub;  //stub for HTTPService dependency in Person
      
      [Before]
      public function setUp() : void
      {
         stub = new HTTPServiceStub("http://myrestfulservice.com/person");
         stub.delay = 500;  //setup delay to emulate HTTP call, make sure to set test async timeouts longer than service delay
         
         fixture = new Person();
         fixture.service = stub;  //inject stub as dependency
      }
      
      [Test(async)]
      public function testSaveOnCreateNotifiesOfSaveAndUpdatesPerson() : void
      {
         //set the result of id 42 for a call with no ID
         stub.result(
            {id: -1, name: containsString("Dobbs"), phone: "555-5555"}, 
            null, 
            42
         );
         
         //listen for created event to make assertions
         fixture.addEventListener(
            Person.CREATED, 
            Async.asyncHandler(
               this, 
               function (event : Event, passThroughData : Object) : void
               {
                  Assert.assertEquals(42, fixture.id);  //assert id is now set
               }, 
               1000
            )
         );
         
         fixture.name = "Bob Dobbs";
         fixture.phone = "555-5555";
         fixture.save();
      }
      
      [Test(async)]
      public function testSaveOnUpdateNotifiesOfSaveAndDoesntUpdatePerson() : void
      {
         //set null result to be returned on update
         stub.result(
            {id: 87, name: "Bob Dobbs", phone: anything()}, 
            {"X-Method-Override": "PUT"}, 
            null
         );
         
         //listen for updated event to make assertions
         fixture.addEventListener(
            Person.UPDATED, 
            Async.asyncHandler(
               this, 
               function (event : Event, passThroughData : Object) : void
               {
                  Assert.assertEquals(87, fixture.id);  //assert id is unchanged
               }, 
               1000
            )
         );
         
         //set up state to obtain correct stub
         fixture.id = 87;
         fixture.name = "Bob Dobbs";
         fixture.phone = "555-5555";
         fixture.save();
      }
      
      [Test(async)]
      public function testSaveRedispatchesEventOnFaultBecauseThisIsAnExampleAndImLazy() : void
      {
         //Set fault to show a 404
         stub.fault(
            {id: 87, name: null, phone: null}, 
            {"X-Method-Override": "PUT"}, 
            "404", 
            "Not Found", 
            "Say wha?"
         );
         
         //listen for fault event to assert pass through
         fixture.addEventListener(
            FaultEvent.FAULT, 
            Async.asyncHandler(
               this, 
               function (event : FaultEvent, passThroughData : Object) : void
               {
                  Assert.assertStrictlyEquals(fixture, event.target);
                  Assert.assertEquals("404", event.fault.faultCode);
                  Assert.assertEquals("Not Found", event.fault.faultString);
                  Assert.assertEquals("Say wha?", event.fault.faultDetail);
               }, 
               1000
            )
         );
            
         //set id to satisfy signature for fault to be found
         fixture.id = 87;
         fixture.save();
      }
   }
}