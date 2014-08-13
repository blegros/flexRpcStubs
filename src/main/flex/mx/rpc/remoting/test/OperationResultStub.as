/*===================================================================
* Systar BusinessBridgeFx V2 ; Copyright © 2011 Systar, all rights reserved.
* @Author:  amsellem
* @Creation: 11 avr. 2011 00:37:03
*=================================================================*/

package mx.rpc.remoting.test
{
	import mx.rpc.Fault;

	public class OperationResultStub
	{
		public function OperationResultStub(operationName:String=null, args:Array=null, resultOrFault:Object=null, ignoreArgs: Boolean = false )
		{
			this._operationName = operationName;  
			this._args = args;  
			this._data = resultOrFault;  
			this._ignoreArgs = ignoreArgs; 
			super();
		}
		
		private var _operationName: String;
		private var _args: Array;
		private var _data: Object;
		private var _ignoreArgs: Boolean;
		
	//	public function setResult(operationName : String, args : Array,  data : *) : void




		public function get operationName():String
		{
			return _operationName;
		}
		
		public function set operationName(value:String):void
		{
			_operationName = value;
		}


		public function get args():Array
		{
			return _args;
		}


		public function set args(value:Array):void
		{
			_args = value;
		}
		
		
		public function set result(value:Object):void
		{
			_data = value;
		}
		
		
		public function get ignoreArgs():Boolean
		{
			return _ignoreArgs;
		}

		public function set ignoreArgs(value:Boolean):void
		{
			_ignoreArgs = value;
		}
		
		/**
		 * @return  a valid result Object or a Fault 
		 * */
		internal function getResultOrFault():Object {
			return _data; 
		}
		







		
	}
}