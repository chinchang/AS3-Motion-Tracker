/**
 * CMotionTracker.as
 * Author : Kushagra Gour  a.k.a. Chin Chang ( chinchang457@gmail.com )
 * 
 * 9 June 2011
 * 
 * Description: Motion tracking class.
 * version 1.0
 *  
 * Copyright 2011 Kushagra Gour
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package  com.chang.motiontracker
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.geom.Rectangle;
	
	public class CMotionTacker extends Point 
	{
		
		private var input:Video;
		private var curr:BitmapData;
		private var last:BitmapData;
		private var trackImg:BitmapData;
		private var areaThreshold:int;
		private var motion:Boolean;
		private var camX:int;
		private var camY:int;
		private var brect:Rectangle;
		
		/**
		 * Construtor
		 * @param	v	A video object to track the motion
		 */
		public function CMotionTacker(v:Video) {
			input = v;			
			areaThreshold = 50;
			camX = input.width;
			camY = input.height;
			trackImg = new BitmapData(camX, camY);
			last = new BitmapData(camX, camY);
		}
		
		/**
		 * Track motion
		 */
		public function track():Boolean {
			var curr:BitmapData = new BitmapData(camX, camY);
			
			curr.draw(input);	
			
			var rect:Rectangle = new Rectangle(0, 0, camX, camY);
			var p:Point = new Point();
			
			trackImg = curr.clone();
						
			// get the difference of the current and last image
			trackImg.draw(last, null, null, BlendMode.DIFFERENCE);
						
			// brighten the image
			var mat:Array = [0, 0, 0,
							0, 15, 0,
							0, 0, 0];		
			var conv:ConvolutionFilter = new ConvolutionFilter(3, 3, mat);
			conv.divisor = 1;			
			trackImg.applyFilter(trackImg, rect, p, conv);
			
			// black areas now represent still area, INVERT it to get motion areas as black
			trackImg.draw(trackImg, null, null, BlendMode.INVERT);
			
			// blur the image
			trackImg.applyFilter(trackImg, rect, p, new BlurFilter(8, 8));
			
			// get bounding rectangle containing black areas
			brect = trackImg.getColorBoundsRect(0x00ffffff, 0x00000000, true);
			
			// area of the tracked area
			var area:int = brect.width * brect.height;
			
			// calculate amount of motion detected, valid if greater than threshold
			motion = false;
			if (area > areaThreshold) {
				motion = true;
				this.x = brect.x + brect.width / 2;
				this.y = brect.y + brect.height / 2;
			}
			
			// copy current image to last pic
			last.copyPixels(curr, rect, p);
			return motion;
		}
		
		/**
		 * Get the processed image which is used to track motion.
		 */
		public function get trackImage():BitmapData {
			return trackImg;
		}
		
		/**
		 * Get the rectangle tha bounds the current area of motion.
		 */
		public function get bound():Rectangle {
			return brect;
		}
		
	}// eof class
	}// eof package