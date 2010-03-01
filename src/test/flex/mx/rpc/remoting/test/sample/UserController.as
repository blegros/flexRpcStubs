package mx.rpc.remoting.test.sample
{
   import mx.rpc.AsyncToken;
   import mx.rpc.Responder;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.remoting.RemoteObject;

   public class UserController
   {
      //dependencies
      public var service : RemoteObject;

      public function UserController ()
      {
      }

      [Mediate(event="authenticateUser",  properties="user")]
      public function authenticate (user : User) : void
      {
         //on a successful call to authenticate
         var onAuthenticated : Function = function (event : ResultEvent) : void
            {
               user.token = event.result as String;
               user.status = User.AUTHENTICATED;
            };

         //on an unmapped exception thrown from the call to authenticate
         var onDenial : Function = function (event : FaultEvent) : void
            {
               user.status = User.DENIED;
            };

         var token : AsyncToken = service.authenticate(user.id,  user.password);
         token.addResponder(new Responder(onAuthenticated,  onDenial));
      }
   }
}