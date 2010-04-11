package mx.rpc.test
{
   import org.hamcrest.Matcher;
   import org.hamcrest.date.dateEqual;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.instanceOf;
   import org.hamcrest.text.re;

   /**
    * Utility used to share behavior for equality used in stub signatures.
    */ 
   public class EqualityUtil
   {
      /**
       * Borrowed from mockolate's MockingCouverture: 
       * http://github.com/drewbourne/mockolate/blob/master/mockolate/src/mockolate/ingredients/MockingCouverture.as
       */ 
      public static function valueToMatcher(signatureValue : *) : Matcher
      {
         var matcher : Matcher = equalTo(signatureValue);
         
         if (signatureValue is RegExp)
         {
            matcher = re(signatureValue as RegExp);
         }
         else if (signatureValue is Date)
         {
            matcher = dateEqual(signatureValue);
         }
         else if (signatureValue is Class)
         {
            matcher = instanceOf(signatureValue);
         }
         else if (signatureValue is Matcher)
         {
            matcher = signatureValue as Matcher;
         }
         
         return matcher;
      }
   }
}