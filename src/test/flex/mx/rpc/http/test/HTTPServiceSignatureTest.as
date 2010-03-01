package mx.rpc.http.test
{
   import mx.utils.ObjectUtil;
   
   import org.flexunit.Assert;
   import org.hamcrest.core.both;
   import org.hamcrest.core.not;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.text.containsString;

   public class HTTPServiceSignatureTest
   {
      [Test]
      public function testGetResult() : void
      {
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(null, null, "success");
         Assert.assertEquals("success", fixture.result);
      }
      
      [Test]
      public function testMatchesWithNoParamsAndNoHeaders() : void
      {
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(null, null, "success");
         Assert.assertTrue(fixture.matches(null, null));
      }
      
      [Test]
      public function testMatchesWithNoParamsAndHeaders() : void
      {
         var signatureHeaders : Object = {
            prop1: "value1",
            prop2: "value2"
         };
            
         var callHeaders : Object = ObjectUtil.copy(signatureHeaders);
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(null, signatureHeaders, "success");
         Assert.assertTrue(fixture.matches(null, callHeaders));
      }
      
      [Test]
      public function testMatchesWithParamsAndHeaders() : void
      {
         var signatureHeaders : Object = {
            prop1: "value1",
            prop2: "value2"
         };
         var callHeaders : Object = ObjectUtil.copy(signatureHeaders);
         
         var signatureParams : Object = {
            q1: "value1",
            q2: "value2"
         };
            
         var callParams : Object = ObjectUtil.copy(signatureParams);
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(signatureParams, signatureHeaders, "success");
         Assert.assertTrue(fixture.matches(callParams, callHeaders));
      }
      
      [Test]
      public function testMatchesWithOnlyLiteralParams() : void
      {
         var signatureParams : Object = {
            prop1: "value1",
            prop2: "value2"
         };
         
         var callParams : Object = ObjectUtil.copy(signatureParams);
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(signatureParams, null, "success");
         Assert.assertTrue(fixture.matches(callParams));
      }
      
      [Test]
      public function testMatchesWithOnlyMatcherParams() : void
      {
         var signatureParams : Object = {
            prop1: both(equalTo("good")).and(not(equalTo("bad"))),
            prop2: containsString("value")
         };
            
         var callParams : Object = {
            prop1: "good",
            prop2: "value2"
         };
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(signatureParams, null, "success");
         Assert.assertTrue(fixture.matches(callParams));
      }
      
      [Test]
      public function testMatchesWithLiteralAndMatcherParams() : void
      {
         var signatureParams : Object = {
            prop1: both(equalTo("good")).and(not(equalTo("bad"))),
            prop2: "value2"
         };
         
         var callParams : Object = {
            prop1: "good",
            prop2: "value2"
         };
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(signatureParams, null, "success");
         Assert.assertTrue(fixture.matches(callParams));
      }
      
      [Test]
      public function testMatchesWithOnlyLiteralHeaders() : void
      {
         var signatureHeaders : Object = {
            prop1: "value1",
            prop2: "value2"
         };
         
         var callHeaders : Object = ObjectUtil.copy(signatureHeaders);
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(null, signatureHeaders, "success");
         Assert.assertTrue(fixture.matches(null, callHeaders));
      }
      
      [Test]
      public function testMatchesWithOnlyMatcherHeaders() : void
      {
         var signatureHeaders : Object = {
            prop1: both(equalTo("good")).and(not(equalTo("bad"))),
            prop2: containsString("value")
         };
         
         var callHeaders : Object = {
            prop1: "good",
            prop2: "value2"
         };
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(null, signatureHeaders, "success");
         Assert.assertTrue(fixture.matches(null, callHeaders));
      }
      
      [Test]
      public function testMatchesWithLiteralAndMatcherHeaders() : void
      {
         var signatureHeaders : Object = {
            prop1: both(equalTo("good")).and(not(equalTo("bad"))),
            prop2: "value2"
         };
         
         var callHeaders : Object = {
            prop1: "good",
            prop2: "value2"
         };
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(null, signatureHeaders, "success");
         Assert.assertTrue(fixture.matches(null, callHeaders));
      }
      
      [Test]
      public function testMatchFailsOnOnlyLiterals() : void
      {
         var signatureParams : Object = {
            prop1: "blah1",
            prop2: "blah2"
         };
         
         var callParams : Object = {
            prop1: "bad1",
            prop2: "bad2"
         };
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(signatureParams, null, "success");
         Assert.assertFalse(fixture.matches(callParams));
      }
      
      [Test]
      public function testMatchFailsOnOnlyMatchers() : void
      {
         var signatureParams : Object = {
            prop1: not("value1"),
            prop2: not("value2")
         };
         
         var callParams : Object = {
            prop1: "value1",
            prop2: "value2"
         };
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(signatureParams, null, "success");
         Assert.assertFalse(fixture.matches(callParams));
      }
      
      [Test]
      public function testMatchFailsOnBothLiteralsAndMatchers() : void
      {
         var signatureParams : Object = {
            prop1: not("value1"),
            prop2: "blah2"
         };
         
         var callParams : Object = {
            prop1: "value1",
            prop2: "value2"
         };
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(signatureParams, null, "success");
         Assert.assertFalse(fixture.matches(callParams));
      }
      
      [Test]
      public function testDoesNotMatchWhenCallHasLessPropertiesThanSignature() : void
      {
         var signatureParams : Object = {
            prop1: both(equalTo("good")).and(not(equalTo("bad"))),
            prop2: "value2"
         };
         
         var callParams : Object = {
            prop1: "good"
         };
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(signatureParams, null, "success");
         Assert.assertFalse(fixture.matches(callParams));
      }
      
      [Test]
      public function testDoesNotMatchWhenCallHasMorePropertiesThanSignature() : void
      {
         var signatureParams : Object = {
            prop1: both(equalTo("good")).and(not(equalTo("bad"))),
            prop2: "value2"
         };
         
         var callParams : Object = {
            prop1: "good",
            prop2: "value2",
            prop3: 1234
         };
         
         var fixture : HTTPServiceSignature = new HTTPServiceSignature(signatureParams, null, "success");
         Assert.assertFalse(fixture.matches(callParams));
      }
   }
}