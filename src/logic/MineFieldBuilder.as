package logic 
{
	import model.CellConstants;
	import model.GameModel;
	import model.MineFieldCellModel;
	import model.MineFieldModel;
	import model.MineFieldModel;
	/**
	 * ...
	 * @author Nikro
	 */
	public class MineFieldBuilder 
	{
		private var mineFieldModel:MineFieldModel;
		
		public function MineFieldBuilder() 
		{
			
		}
		
		public function makeMineField(mineFieldModel:MineFieldModel, gameModel:GameModel):void
		{
			var j:int;
			var i:int;
			this.mineFieldModel = mineFieldModel;
			
			mineFieldModel.actualField = new Vector.<Vector.<int>>(mineFieldModel.fieldHeight, true);
			mineFieldModel.viewField = new Vector.<Vector.<MineFieldCellModel>>(mineFieldModel.fieldHeight, true);
			gameModel.gameTime = 0;
			gameModel.openedField = 0;
			gameModel.foundedMines = 0;
			
			for (i = 0; i < mineFieldModel.fieldWidth; i++)
			{
				mineFieldModel.actualField[i] = new Vector.<int>(mineFieldModel.fieldWidth, true);
				mineFieldModel.viewField[i] = new Vector.<MineFieldCellModel>(mineFieldModel.fieldWidth, true);
				
				for (j = 0; j < mineFieldModel.fieldHeight; j++)
				{
					mineFieldModel.actualField[i][j] = 0;
					
					mineFieldModel.viewField[i][j] = new MineFieldCellModel(mineFieldModel.actualField[i][j], CellConstants.CLOSE_STATE);
					
					
				}
			}
			
			for (i = 0; i < gameModel.minesCount; i++)
			{
				var iIndex:int = Math.random() * mineFieldModel.fieldWidth;
				var jIndex:int = Math.random() * mineFieldModel.fieldHeight;
				
				if (mineFieldModel.actualField[iIndex][jIndex] == 0)
				{
					mineFieldModel.actualField[iIndex][jIndex] = -1;
				}
				else
				{
					i--;
					continue;
				}
					
			}
			
			for (i = 0; i < mineFieldModel.fieldWidth; i++)
			{
				for (j = 0; j < mineFieldModel.fieldHeight; j++)
				{
					if (mineFieldModel.actualField[i][j] != -1)
					{
						mineFieldModel.actualField[i][j] = calcMines(i, j, mineFieldModel.actualField);
					}
					
					mineFieldModel.viewField[i][j].fieldStatus = mineFieldModel.actualField[i][j];
				}
			}
		}
		
		public function calcMines(i:int, j:int, field:Vector.<Vector.<int>>):int
		{
			var count:int = 0;
			var startI:int = i - 1;
			var startJ:int = j - 1;
			var endI:int = i + 2;
			var endJ:int = j + 2;
			
			if (startI < 0)
				startI = 0;
				
			if (startJ < 0 )
				startJ = 0;
				
			if (endI > mineFieldModel.fieldWidth)
				endI = mineFieldModel.fieldWidth;
				
			if (endJ > mineFieldModel.fieldHeight)
				endJ = mineFieldModel.fieldHeight;
				
			for (var i:int = startI; i < endI; i++)
			{
				for (var j:int = startJ; j < endJ; j++)
				{
					if (field[i][j] == -1)
						count++;
				}
			}
			
			return count;
		}
		
	}

}