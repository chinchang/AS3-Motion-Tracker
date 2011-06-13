/**
 * Main.as
 * Author : Kushagra Gour  a.k.a. Chin Chang ( chinchang457@gmail.com )
 * 
 * 9 June 2011
 * 
 * Description: Demo app to show CMotionTracker class.
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

package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import com.chang.motiontracker.CMotionTacker;
	
	public class Main extends Sprite 
	{
		private var mt:CMotionTacker;
		
		private var v:Video;
		private var view:Bitmap;
		private var camX:int = 320;
		private var camY:int = 240;
		private var bound:Sprite = new Sprite();
				
		public function Main():void 
		{			
			var c:Camera = Camera.getCamera();
			c.setMode(camX, camY, 30);
			
			v = new Video();
			v.attachCamera(c);
			v.x = v.y = 10;
			addChild(v);
			
			// provide a video instance to CMotionTracker			
			mt = new CMotionTacker(v);
			
			// Draw a bitmap to see what actually is happening
			view = new Bitmap(new BitmapData(camX,camY));
			view.x = 10 + camX + 10;
			view.y = 10;
			addChild(view);
			
			addChild(bound);
			v.addEventListener(Event.EXIT_FRAME, loop);
			
		}
		
		private function loop(e:Event):void {
			var p:Point = new Point();
			
			// if there is motion
			if (mt.track()){
				p.x = mt.x + view.x;
				p.y = mt.y + view.y;			
				
				bound.graphics.clear();				
				bound.graphics.lineStyle(2, 0x0000ff);
				
				// CMotionTracker's bound property returns a rectangle containing the tracked area
				bound.graphics.drawRect(mt.bound.x + view.x, mt.bound.y, mt.bound.width, mt.bound.height);
				
				bound.graphics.lineStyle(2, 0x0000ff);				
				bound.graphics.drawCircle(p.x, p.y, 3);
				bound.graphics.lineStyle(2, 0xff0000);
				bound.graphics.drawCircle(p.x - view.x, p.y, 3);
			}
			
			// CMotionTracker's trackImage is the processed bitmapdata
			// show it in the view bitmap
			view.bitmapData = mt.trackImage;			
		}
	}// eof class
}// eof package
		