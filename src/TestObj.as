package  
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class TestObj extends EventDispatcher implements ITest2
	{
		
		public function TestObj(target:IEventDispatcher=null) 
		{
			super(target);
			
		}
		
	}

}