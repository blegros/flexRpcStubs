package
{
   import mx.rpc.test.ClassWithHTTPServiceDependencyTest;
   import mx.rpc.test.HTTPServiceStubTest;
   import mx.rpc.test.RemoteObjectStubTest;

   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class AllTests
   {
      public var httpServiceStubTest : HTTPServiceStubTest;
      public var remoteObjectStubTest : RemoteObjectStubTest;
      public var classWithHTTPServiceDependencyTest : ClassWithHTTPServiceDependencyTest;
   }
}