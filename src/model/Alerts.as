package model 
{
	/**
	 * ...
	 * @author 
	 */
	public class Alerts 
	{
		
		private static const WIN_GAME:String = 'U HAVE WIN THE GAME';
		private static const LOSE_GAME:String = 'U HAVE FAIL';
		
		public static function getEndGameText(gameTime:Number, minesFounded:Number, mineFieldSize:Number, isWin:Boolean):String
		{
			var s:String = START_SCREEN;
			s = s.replace('%time%', gameTime.toString());
			s = s.replace('%mines%', minesFounded.toString());
			s = s.replace('%field%', mineFieldSize.toString());
			s = s.replace('%field%', mineFieldSize.toString());
			s = s.replace('%gameStatus%', isWin? WIN_GAME:LOSE_GAME);
			
			return s;
		}
		
		public static var START_SCREEN:String = 
												
													'ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ'
												+	'\n\n\n\n\n'
												+'	<font size="35">GAME OVER</font>\n'
												+'	<font size="35">%gameStatus%</font>\n'												
												+	'\n'
												+   'YOUR GAME TIME:%time%\n'
												+   'MINES FOUNDED:%mines%\n'
												+   'MINE FIELD SIZE:%field%x%field%\n'
												//+   'HIGH SCORE:\n'
												+	'\n\n\n\n\n\n'
												+	'<button><a href="event:restart">RESTART GAME</a></button>\n'
												+	'\n\n\n\n\n'

												+	'ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ ʕ·ᴥ·ʔ'
		
		
	}

}