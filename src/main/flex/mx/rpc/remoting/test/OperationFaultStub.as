/*===================================================================
* Systar BusinessBridgeFx V2 ; Copyright © 2011 Systar, all rights reserved.
* @Author:  amsellem
* @Creation: 11 avr. 2011 00:37:03
*=================================================================*/

package mx.rpc.remoting.test
{
	import mx.rpc.Fault;

	[Exclude(name="result",kind="property")]
	public class OperationFaultStub extends OperationResultStub
	{
		public function OperationFaultStub(operationName:String=null, args:Array=null, faultCode:String=null, faultString:String=null, faultDetail:String=null, ignoreArgs:Boolean=false)
		{
			this._faultCode = faultCode;  
			this._faultString = faultString;  
			this._faultDetail = faultDetail;  
			super(operationName, args, null, ignoreArgs);
		}
		
		
		private var _faultCode: String;
		private var _faultString: String;
		private var _faultDetail: String; 
		
	//	public function setResult(operationName : String, args : Array,  data : *) : void


		public function set faultCode(value:String):void
		{
			_faultCode = value;
		}

		public function set faultString(value:String):void
		{
			_faultString = value;
		}

		public function set faultDetail(value:String):void
		{
			_faultDetail = value;
		}

		
		internal override function getResultOrFault():Object
		{
			
			return new Fault( _faultCode, _faultString, _faultDetail);
		}


		
	}
}