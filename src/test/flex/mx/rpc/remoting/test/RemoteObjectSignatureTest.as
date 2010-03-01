package mx.rpc.remoting.test
{
   import org.flexunit.Assert;
   import org.hamcrest.core.both;
   import org.hamcrest.core.not;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.text.containsString;

   public class RemoteObjectSignatureTest
   {
      [Test]
      public function testGetResult() : void
      {
         var fixture : RemoteObjectSignature = new RemoteObjectSignature(null, "success");
         Assert.assertEquals("success", fixture.result);
      }
      
      [Test]
      public function testWithNoParams() : void
      {
         var fixture : RemoteObjectSignature = new RemoteObjectSignature(null, "success");
         Assert.assertTrue(fixture.matches(null));
      }
      
      [Test]
      public function testWithOnlyLiteralParams() : void
      {
         var signature : Array = ["value1", 1235];
         var call : Array = signature.map(function (item : Object, index : Number, array : Array) : Object { return item; });

         var fixture : RemoteObjectSignature = new RemoteObjectSignature(signature, "success");
         Assert.assertTrue(fixture.matches(call));
      }
      
      [Test]
      public function testWithOnlyMatcherParams() : void
      {
         var signature : Array = [both(equalTo("good")).and(not(equalTo("bad"))), containsString("value")];
         var call : Array = ["good", "value1"];
         
         var fixture : RemoteObjectSignature = new RemoteObjectSignature(signature, "success");
         Assert.assertTrue(fixture.matches(call));
      }
      
      [Test]
      public function testWithLiteralAndMatcherParams() : void
      {
         var signature : Array = [both(equalTo("good")).and(not(equalTo("bad"))), "value1"];
         var call : Array = ["good", "value1"];
         
         var fixture : RemoteObjectSignature = new RemoteObjectSignature(signature, "success");
         Assert.assertTrue(fixture.matches(call));
      }
      
      [Test]
      public function testMatchFailsWithOnlyLiteralParams() : void
      {
         var signature : Array = ["value1", 1235];
         var call : Array = ["value2", 0000];
         
         var fixture : RemoteObjectSignature = new RemoteObjectSignature(signature, "success");
         Assert.assertFalse(fixture.matches(call));
      }
      
      [Test]
      public function testMatchFailsWithOnlyMatcherParams() : void
      {
         var signature : Array = [both(equalTo("good")).and(not(equalTo("bad"))), containsString("value")];
         var call : Array = ["bad", "blah1"];
         
         var fixture : RemoteObjectSignature = new RemoteObjectSignature(signature, "success");
         Assert.assertFalse(fixture.matches(call));
      }
      
      [Test]
      public function testMatchFailsWithLiteralAndMatcherParams() : void
      {
         var signature : Array = [both(equalTo("good")).and(not(equalTo("bad"))), "value1"];
         var call : Array = ["bad", "value2"];
         
         var fixture : RemoteObjectSignature = new RemoteObjectSignature(signature, "success");
         Assert.assertFalse(fixture.matches(call));
      }
      
      [Test]
      public function testParamLengthDoesNotMatchWithLongerSignature() : void
      {
         var signature : Array = ["value1", 1235, "extra"];
         var call : Array = ["value1", 1235];
         
         var fixture : RemoteObjectSignature = new RemoteObjectSignature(signature, "success");
         Assert.assertFalse(fixture.matches(call));
      }
      
      [Test]
      public function testParamLengthDoesNotMatchWithLongerCall() : void
      {
         var signature : Array = ["value1", 1235];
         var call : Array = ["value1", 1235,  "extra"];
         
         var fixture : RemoteObjectSignature = new RemoteObjectSignature(signature, "success");
         Assert.assertFalse(fixture.matches(call));
      }
   }
}