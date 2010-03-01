package mx.rpc.remoting.test.sample
{
   import flash.events.Event;
   
   import mx.events.PropertyChangeEvent;

   [Event(name="statusChanged", type="flash.events.Event")]
   public class User
   {
      public static const AUTHENTICATED : String = "authenticated";
      public static const DENIED : String = "denied";
      
      public var id : String;
      public var password : String;
      public var token : String;
      
      private var _status : String;
      
      public function User()
      {
      }
      
      [Bindable]
      public function get status() : String
      {
         return _status;
      }
      
      public function set status(value : String) : void
      {
         var changeEvent : PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "status", _status, value);
         
         _status = value;
         
         dispatchEvent(changeEvent);
         dispatchEvent(new Event("statusChanged"));
      }
   }
}