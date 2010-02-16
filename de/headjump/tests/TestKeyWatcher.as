package de.headjump.tests {
	import asunit.framework.TestCase;
	import de.headjump.keywatch.Ky;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	/**
	 * Mainly tests for key-array generation ("string" -> [keyChar])
	 */
	public class TestKeyWatcher extends TestCase {
		private var kw:KeyWatcherWithoutStageRef;
		
		public function TestKeyWatcher(testMethod:String = null) {
			super(testMethod);
		}
		
		protected override function setUp():void {
			try {
				kw = new KeyWatcherWithoutStageRef(null);
			} catch (e:Error) {
				trace(e);
			}
		}
		
		private function dummy():void {
			// noop
		}
		
		public function testWatchKeycodeArray():void {
			var a:Array = [65, 66, 67, 68];
			var s:String = "" + a;
			assertEquals("keys not watched before", -1, String("" + kw).indexOf(s)); 
			kw.watch(a, dummy);
			assertNotSame("keys watched now", -1, String("" + kw).indexOf(s)); 
			kw.unwatch(a);
			assertEquals("keys not watched after unwatch", -1, String("" + kw).indexOf(s)); 
		}
		
		public function testWatchString():void {
			var sending_this:String = "start";
			var should_be:String = "" + ([83, 84, 65, 82, 84]);
			kw.watch(sending_this, dummy);
			assertNotSame("keys watched now", -1, String("" + kw).indexOf(should_be));
			kw.unwatch(sending_this);
			assertEquals("keys unwatched", -1, String("" + kw).indexOf(should_be));
		}
		
		public function testWatchMixedArray():void {
			var sending_this:Array = ["sta", 65, 66, "r t"];
			var should_be:String = "" + ([83, 84, 65, 65, 66, 82, 32, 84]);
			kw.watch(sending_this, dummy);
			assertNotSame("keys watched now", -1, String("" + kw).indexOf(should_be));
			kw.unwatch(sending_this);
			assertEquals("keys unwatched", -1, String("" + kw).indexOf(should_be));
		}
		
		public function testIgnoreCharCase():void {
			var sending_this:String = "sTArt";
			var should_be:String = "" + ([83, 84, 65, 82, 84]);
			kw.watch(sending_this, dummy);
			assertNotSame("keys watched now", -1, String("" + kw).indexOf(should_be));
			kw.unwatch(sending_this);
			assertEquals("keys unwatched", -1, String("" + kw).indexOf(should_be));
		}
		
	}
}