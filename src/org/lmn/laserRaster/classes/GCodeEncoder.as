
package org.lmn.laserRaster.classes
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import mx.controls.Text;

	import mx.utils.Base64Encoder;

	import org.lmn.laserRaster.LaserConfiguration;
	//import org.lmn.laserRaster.StartConfiguration;

	public class GCodeEncoder
	{

		static public function generateGCode(incomingBitmap:BitmapData, appliedFilter:ColorMatrixFilter):String
		{
					
			var resolution:Number = LaserConfiguration.RES;
			var powerMax:Number = 255 / (100 / LaserConfiguration.PMAX);
			var powerMin:Number = 255 / (100 / LaserConfiguration.PMIN);
			var speed:Number = 10000 / (100 / LaserConfiguration.SPD);
			var xoffset:Number = LaserConfiguration.XOFF;
			var yoffset:Number = LaserConfiguration.YOFF;
			
			var gcode:String = LaserConfiguration.PREAMBLE;
			var color:uint;
			var red:uint;
			var green:uint;
			var blue:uint;
			var bwColor:uint;
			
			
			var lastbwColor:uint;
			var intensity:uint;
			var xPosi:Number = 0;
			var yPosi:Number = 0;
			var xMove:Number = 0;
			var yMove:Number = 0;
			var x:int = 1;
			var y:int = 0;
			var direction:int = 1;
			var dir:int = 0;
			var forward:int = 1;
			var reverse: int = 2;
			var moveToEnd: int = 0;
			var done: int = 3;
			var none:int = 0;
			var imageWidth:int = 0;
			var imageHeight:int = 0;

			var ba:ByteArray = new ByteArray();

			var encoder:Base64Encoder = new Base64Encoder();
			encoder.insertNewLines = false;

			var myImage:BitmapData = incomingBitmap.clone();
            var output:String;

			myImage.applyFilter(myImage, new Rectangle(0, 0, myImage.width, myImage.height),
					new Point(), appliedFilter);
					
			y = myImage.height - 1;
			imageWidth = myImage.width - 1;
			imageHeight = myImage.height;
			lastbwColor = 300;
			
			xMove = (resolution / 2) + xoffset;
			yMove = (resolution / 2) + yoffset;
			yPosi = resolution / 2;
			
			gcode = gcode + "G1 X" + xMove + " Y" + yMove + " F10000\r\n";
			gcode = gcode + "G1 F" + speed + "\r\n";
			
			xMove = resolution / 2;
			yMove = resolution / 2;
			
			while (x < myImage.width - 1 || y > resolution)
			{
				color = myImage.getPixel(x, y); //scan each pixel in the image
				red = color & 0xFF0000 >> 16;
				green = color & 0x00FF00 >> 8;
				blue = color & 0x0000FF >> 0;
				bwColor = (red + green + blue) / 3; //take the average of the RGB value to get the greyscale
				
						
					if (x < imageWidth && direction == forward) 
					{
						x ++;
						xPosi += resolution;
						xMove = xPosi - (resolution / 2);
					}
				
					if (x > 1 && direction == reverse) 
					{
						x --;
						xPosi -= resolution;
						xMove = xPosi + (resolution * 1.5);
					}
				
					if (x == imageWidth && direction == forward)
					{
						direction = none;
						dir = forward;
						moveToEnd = forward;
					}
				
					if (x == 1 && direction == reverse)
					{		
						direction = none;
						dir = reverse;
						moveToEnd = reverse;
					}				
				
					if (moveToEnd == done) 
					{
						y --;
						yPosi += resolution;
						yMove = yPosi;
						lastbwColor = 255;
						moveToEnd = none;
						if (dir == forward) 
						{
							direction = reverse;
							xPosi += resolution;
						}
						else 
						{
							direction = forward;
							xPosi -= resolution;
						}
					}				
				
					if (moveToEnd == forward) 
					{
						xMove = xPosi + (resolution * 1.5);
						lastbwColor = bwColor;
						moveToEnd = done;
						if (y == resolution) 
						{
							y = 0;
						}
					}				
				
					if (moveToEnd == reverse) 
					{
						xMove = resolution / 2;
						lastbwColor = bwColor;
						moveToEnd = done;
						if (y == resolution) 
						{
							y = 0;
							x = imageWidth;
						}
					}
				
				if (bwColor != lastbwColor || moveToEnd != 0) 
				{
					var power:int;
					//var lastpwr:int;
					//var lasty:Number;
					
					if (lastbwColor > 255) 
					{
						lastbwColor = bwColor;	
					}
					
					intensity = 255 - lastbwColor; //inverse so darker is higher value
						
					if (intensity < 4) 
					{
						intensity = 0;
					}
					
					power = (intensity / 255) * (powerMax - powerMin) + powerMin;
					
					/* //Only move if power change - needs fine tuning
					if (power != lastpwr || yMove != lasty) {
						var movex:Number = xMove + xoffset;
						var movey:Number = yMove + yoffset;					
						gcode = gcode + "G1 X" +toFixed(movex, 4) + " Y" +toFixed(movey, 4) + " S" + power + "\r\n";
						lastpwr = power;
						lasty = yMove;
					}
					*/
					var movex:Number = xMove + xoffset;
					var movey:Number = yMove + yoffset;					
					gcode = gcode + "G1 X" +toFixed(movex, 4) + " Y" +toFixed(movey, 4) + " S" + power + "\r\n";
										
				}
				
				lastbwColor = bwColor;				
			}

			gcode = gcode + LaserConfiguration.POSTAMBLE;

			return gcode;
		}
		
		static public function toFixed(number:Number, precision:int):Number
		{
				precision = Math.pow(10, precision);
				return Math.round(number * precision) / precision;
		}
		

	}
}
