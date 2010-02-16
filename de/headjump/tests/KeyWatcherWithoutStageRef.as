package de.headjump.tests {
	import de.headjump.keywatch.KeyWatcher;
	import flash.display.Stage;
	
	public class KeyWatcherWithoutStageRef extends KeyWatcher {
		
		public function KeyWatcherWithoutStageRef(st:Stage, time_per_press:int = 350) {
			super(st, time_per_press);
		}
		
		protected override function initStage(st:Stage):void {
			// ignoring stage, because is null
		}

	}
}