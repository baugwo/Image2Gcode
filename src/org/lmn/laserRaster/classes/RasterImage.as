/**
 * Created with IntelliJ IDEA.
 * User: Nicholas Kwiatkowski
 * Date: 6/8/2014
 * Time: 4:33 PM
 *
 */
package org.lmn.laserRaster.classes
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	import org.lmn.laserRaster.LaserConfiguration;


	[Event(name="ExportFinished",type="flash.events.Event")]
	[Event(name="ExportFailed",type="flash.events.Event")]
    [Event(name="RasterImageUpdate",type="flash.events.Event")]
	public class RasterImage
	{
		public var source:Bitmap = new Bitmap();
		public var bwMatrix:Array = [0.22, 0.71, 0.06, 0, 0, 0.22, 0.71, 0.06, 0, 0, 0.22, 0.71, 0.06, 0, 0, 0, 0, 0, 1, 0];
		public var bwFilter:ColorMatrixFilter;
		
		public static var frName:String = new String();

		[Bindable] public var imageLoaded:Boolean = false;

		private var fr:FileReference = new FileReference();
		private var frSave:FileReference = new FileReference();
		private var border:int = 0;

		public function RasterImage()
		{
			fr.addEventListener(Event.SELECT, selectedFile);
			fr.addEventListener(Event.COMPLETE, fileLoaded);

			frSave.addEventListener(Event.COMPLETE, exportFileComplete);
			frSave.addEventListener(IOErrorEvent.IO_ERROR, errorSavingFile);

			bwFilter = new ColorMatrixFilter(bwMatrix);
		}

		public function loadImageFromDisk():void
		{
			var fileImageFilter:FileFilter = new FileFilter("Image Files (*.jpg, *.jpeg, *.gif, *.png)","*.jpg;*.jpeg;*.png;*.gif");
			fr.browse([fileImageFilter]);

		}

		private function selectedFile(event:Event):void
		{
			fr.load();
			frName = fr.name;
		}

		private function fileLoaded(event:Event):void
		{
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
            loader.loadBytes(fr.data);
		}

        private function loadBytesHandler(event:Event):void
        {
            var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
            loaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);
			source = loaderInfo.content as Bitmap;
			imageLoaded = true;
            var e:Event = new Event("RasterImageUpdate");
            dispatchEvent(e);
        }

		public function resizeImage(newHeight:Number, newWidth:Number):void //myImage.resizeImage(Number(newHeight.text) * (1 / LaserConfiguration.RES), Number(newWidth.text) * (1 / LaserConfiguration.RES));
		{
			var scaleX:Number = (newWidth * (1 / LaserConfiguration.RES)) / source.width;
			var scaleY:Number = (newHeight * (1 / LaserConfiguration.RES)) / source.height;
			
			var wSize:Number = newWidth * (1 / LaserConfiguration.RES);
			var hSize:Number = newHeight * (1 / LaserConfiguration.RES);

			var newBitmap:BitmapData = new BitmapData(wSize, hSize);
			newBitmap.draw(source.bitmapData, new Matrix(scaleX, 0, 0, scaleY));

			source = new Bitmap(newBitmap);
		}

		public function borders(newBorder:int):void 
		{
			border = newBorder;
		}

		public function rotateImage():void
		{
			var newBitmap:BitmapData = new BitmapData(source.height , source.width);
			var rotationalMatrix:Matrix = new Matrix();

			rotationalMatrix.rotate(Math.PI /2);
			rotationalMatrix.tx = source.height;

			newBitmap.draw(source.bitmapData, rotationalMatrix);

			source = new Bitmap(newBitmap);
		}

		public function exportGCode():void
		{
					
			var outputFileName:String = "LaserImage" + ".glsr";

			frSave.save(GCodeEncoder.generateGCode(source.bitmapData, bwFilter), outputFileName);
		}

		private function exportFileComplete(event:Event):void
		{
			var e:Event = new Event("ExportFinished");
			dispatchEvent(e);
		}

		private function errorSavingFile(event:IOErrorEvent):void
		{
			trace("[ERROR] ",event.text);
			var e:Event = new Event("ExportFailed");
			dispatchEvent(e);
		}			
		
		static public function toFixed(number:Number, precision:int):Number
		{
				precision = Math.pow(10, precision);
				return Math.round(number * precision) / precision;
		}

		public function get imageWidthInPX():Number
		{
			return source.width;//PPPX;
		}

		public function get imageHeightInPX():Number
		{
			return source.height;//PPPX;
		}

		public function get imageWidthInMM():Number
		{
			return toFixed((source.width / (1 / LaserConfiguration.RES)), 2);//PPMM;
		}

		public function get imageHeightInMM():Number
		{
			return toFixed((source.height / (1 / LaserConfiguration.RES)), 2);//PPMM;
		}

		public function get imageWidthInInch():Number
		{
			return source.width / ((1 / LaserConfiguration.RES) * 0.0393701);//PPI;
		}

		public function get imageHeightInInch():Number
		{
			return source.height / ((1 / LaserConfiguration.RES) * 0.0393701);//PPI;
		}

		public function reloadFilter():void
		{
			bwFilter = new ColorMatrixFilter(bwMatrix);
		}

		public function getPrintTime():Number
		{
			return ((((imageHeightInPX * imageWidthInMM)  / (LaserConfiguration.SPD * 100)) * 2.57) +  ((((imageHeightInMM + imageWidthInMM) * 2) * border) / (LaserConfiguration.SPD * 100))) + 0.5;
		}

		public function get fileName():String
		{
			return fr.name;
		}

	}
}
