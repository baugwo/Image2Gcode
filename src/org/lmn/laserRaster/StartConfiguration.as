
package org.lmn.laserRaster
{
	public class StartConfiguration
	{
		

		public function startData():void //tsm:Boolean, tmd:Boolean, tlg:Boolean, tel:Boolean
		{			
			/*if (tsm == true) {
				XBL = 0.02;
				YBL = 0.02;
			}
			else if (tmd == true) {
				XBL = 0.05;
				YBL = 0.05;
			}
			else if (tlg == true) {
				XBL = 0.1;
				YBL = 0.1;
			} 
			else
			{
				XBL = 0.15;
				YBL = 0.15;
			}*/
		}		
		
		public static var XBL:Number = new Number(0.01); //X Backlash
		public static var YBL:Number = new Number(0.01); //Y Backlash

		public function StartConfiguration()
		{
		}
	}
}
