package
{
   import mx.rpc.http.test.HTTPServiceSignatureTest;
   import mx.rpc.http.test.HTTPServiceStubTest;
   import mx.rpc.http.test.sample.PersonTest;
   import mx.rpc.remoting.test.RemoteObjectSignatureTest;
   import mx.rpc.remoting.test.RemoteObjectStubTest;
   import mx.rpc.remoting.test.sample.UserControllerTest;
   import mx.rpc.test.EqualityUtil;
   import mx.rpc.test.EqualityUtilTest;

   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class AllTests
   {
      public var httpServiceStubTest : HTTPServiceStubTest;
      public var httpServiceSignatureTest : HTTPServiceSignatureTest;
      public var remoteObjectStubTest : RemoteObjectStubTest;
      public var remoteObjectSignatureTest : RemoteObjectSignatureTest;
      public var personTest : PersonTest;
      public var userControllerTest : UserControllerTest;
      public var equalityUtiTest : EqualityUtilTest;
   }
}