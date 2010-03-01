package mx.rpc.remoting.test.sample
{
   import flash.events.Event;
   
   import mx.rpc.remoting.test.RemoteObjectStub;
   
   import org.flexunit.Assert;
   import org.flexunit.async.Async;
   import org.hamcrest.core.anything;

   public class UserControllerTest
   {
      private var fixture : UserController; //class under test
      private var stub : RemoteObjectStub;  //stub for RemoteObject dependency in controller
      
      [Before]
      public function setUp() : void
      {
         stub = new RemoteObjectStub("userservice");
         stub.delay = 500;  //setup delay to emulate AMF call, make sure to set test async timeouts longer than service delay
         
         fixture = new UserController();
         fixture.service = stub;  //inject stub as dependency
      }
      
      [Test(async)]
      public function testAuthenticateIsAcceptedAndUserGetRemainingCredentials() : void
      {
         //setup token result for successful login
         stub.result("authenticate", [anything(), "dobbs"], "1234lk32jl42432azfbr4354");
         
         //build domain class being processed by controller
         var user : User = new User();
         user.id = "bob";
         user.password = "dobbs";
         
         //listen for statusChanged event to assert success
         user.addEventListener(
            "statusChanged", 
            Async.asyncHandler(
               this,
               function (event : Event, passThroughData : Object) : void
               {
                  Assert.assertEquals(User.AUTHENTICATED, user.status);
                  Assert.assertNotNull(user.token);
                  Assert.assertEquals("1234lk32jl42432azfbr4354", user.token);
               },
               1000
            )
         );
         
         //make call to authenticate the provided user
         fixture.authenticate(user);
      } 
      
      [Test(async)]
      public function testAuthenticateIsDenied() : void
      {
         //setup signature for failed authentication
         stub.fault("authenticate", ["bob", "dobbs"], null, null, null, null);
         
         //build domain class being processed by controller
         var user : User = new User();
         user.id = "bob";
         user.password = "dobbs";
         
         //listen for statusChanged event to assert success
         user.addEventListener(
            "statusChanged", 
            Async.asyncHandler(
               this,
               function (event : Event, passThroughData : Object) : void
               {
                  Assert.assertEquals(User.DENIED, user.status);
                  Assert.assertNull(user.token);
               },
               1000
            )
         );
 
         //make call to authenticate the provided user
         fixture.authenticate(user);
      }
   }
}