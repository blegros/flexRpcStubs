package mx.rpc.test
{
   import org.flexunit.Assert;
   import org.hamcrest.date.DateEqualMatcher;
   import org.hamcrest.object.IsEqualMatcher;
   import org.hamcrest.object.IsInstanceOfMatcher;
   import org.hamcrest.text.RegExpMatcher;

   public class EqualityUtilTest
   {
      [Test]
      public function testValueToMatcherProducesRegexMatcher() : void
      {
         var value : RegExp = /abcd*/g;
         Assert.assertTrue(EqualityUtil.valueToMatcher(value) is RegExpMatcher);
      }
      
      [Test]
      public function testValueToMatcherProducesDateMatcher() : void
      {
         var value : Date = new Date();
         Assert.assertTrue(EqualityUtil.valueToMatcher(value) is DateEqualMatcher);
      }
      
      [Test]
      public function testValueToMatcherProducesClassMatcher() : void
      {
         var value : Class = String;
         Assert.assertTrue(EqualityUtil.valueToMatcher(value) is IsInstanceOfMatcher);
      }
      
      [Test]
      public function testValueToMatcherProducesEqualsMatcher() : void
      {
         var value : String = "abcd";
         Assert.assertTrue(EqualityUtil.valueToMatcher(value) is IsEqualMatcher);
      }
   }
}