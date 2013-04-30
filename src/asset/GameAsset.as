package asset 
{
	import flash.utils.ByteArray;
	import org.as3commons.zip.Zip;
	/**
	 * ...
	 * @author Nikro
	 */
	public class GameAsset 
	{
		[Embed(source = "../../asset/asset.zip", mimeType = "application/octet-stream")]
		private static var assetPackSource:Class;
		private static var assetPack:ByteArray = new assetPackSource();
		
		public static function getZip():Zip
		{
			var zip:Zip = new Zip();
			zip.loadBytes(assetPack);
			
			return zip;
		}
		
		
		
	}

}