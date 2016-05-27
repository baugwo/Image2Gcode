
package org.lmn.laserRaster
{
	public class LaserConfiguration
	{
		public var RESOLUTION:Number = 0.2;  //X and Y Stepover Resolution
		public var SPEED:int = 25;  //X and Y Stepover Resolution
		public var MAXPOWER:int = 60;  //X and Y Stepover Resolution
		public var MINPOWER:int = 0;  //X and Y Stepover Resolution
		public var STARTX:Number = 0;  //X Start Position
		public var STARTY:Number = 0;  //Y Start Position
		public var BORDER:int = 0;  //Border passes
		public var SWEEP:String = "Horizontal";  //Sweep direction
		

		public function newData(newResolution:Number, newSpeed:int, maxPower:int, minPower:int, newStartx:Number, newStarty:Number, newBorder:int, newSweep:String):void
		{
						
			if (newSpeed > 180) 
			{
				newSpeed = 180;
			}
			if (maxPower > 100) 
			{
				maxPower = 100;
			}
			if (minPower >= maxPower) 
			{
				minPower = maxPower - 1;
			}
			RESOLUTION = newResolution;
			SPEED = newSpeed;
			MAXPOWER = maxPower;
			MINPOWER = minPower;
			RES = newResolution;
			SPD = newSpeed;
			PMAX = maxPower;
			PMIN = minPower;
			STARTX = newStartx;
			STARTY = newStarty;
			XOFF = newStartx;
			YOFF = newStarty;
			BODR = newBorder;
			BORDER = newBorder;
			SWEP = newSweep;
			SWEEP = newSweep;
		}

		public function get newResolutionMM():Number
		{
			return RESOLUTION;
		}
		
		public function get newSpeedP():int
		{
			return SPEED;
		}
		
		public function get maxPowerP():int
		{
			return MAXPOWER;
		}
		
		public function get minPowerP():int
		{
			return MINPOWER;
		}
		
		public function get newStartxP():Number
		{
			return STARTX;
		}
		
		public function get newStartyP():Number
		{
			return STARTY;
		}
		
		public function get newBorderP():int
		{
			return BORDER;
		}
		
		public function get newSweepP():String
		{
			return SWEEP;
		}
		
		public static var RES:Number = new Number(0.2);  //X and Y Stepover Resolution
		public static const PPMM:Number = 1 / RES;  //Pixels per Millimeter
		public static const PPI:Number = PPMM * 0.0393701;  //Pixels per Inch

		public static var PMAX:int = new int(0); //Maximum power percent
		public static var PMIN:int = new int(0); //Minimum power percent
		public static var SPD:int = new int(0); //Millimeters per Minute
		public static var XOFF:Number = new Number(0); //X Offset
		public static var YOFF:Number = new Number(0); //Y Offset
		public static var BODR:int = new int(0); //Border passes
		public static var SWEP:String = new String("0"); //Sweep direction

		public function LaserConfiguration()
		{
		}
	}
}
