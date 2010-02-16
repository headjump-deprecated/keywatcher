package de.headjump.keywatch {
	import de.headjump.Helper;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class KeyWatcher {
		private static var _always_focus_clip:Sprite;
		private static var _always_focus_function:Function;
		private var _watches:Array;
		private var _history:Array;
		private var _previous_down_time:Number;
		private var _time_per_press:int;
		private var _show_history:Boolean;
		private var _active:Boolean;
		
		/**
		 * @param 	st			stage (receiving key downs)
		 * @param	time_per_press	after this time the press history will be cleared
		 */
		public function KeyWatcher(st:Stage, time_per_press:int = 450) {
			initStage(st);
			initAttribs(time_per_press);
		}
		
		protected function initStage(st:Stage):void {
			st.addEventListener(KeyboardEvent.KEY_DOWN, doOnKeyDown, true);
		}
		
		private function initAttribs(time_per_press:int):void {
			_active = true;
			_time_per_press = time_per_press;
			_watches = [];
			_history = [];
			_previous_down_time = new Date().time;
			_show_history = false;
			
			this.watch("watching", traceWatching);	// trace all watches
			this.watch("history", toggleShowHistory);  // toggle trace history on key down
		}
		
		private function traceWatching():void {
			trace(this);
		}
		
		private function toggleShowHistory():void {
			_show_history = !_show_history;
		}
		
		public function get active():Boolean {
			return _active;
		}
		
		public function set active(active:Boolean):void {
			_active = active;
		}
		
		private function doOnKeyDown(evt:KeyboardEvent):void {
			if (!active) return;
			var time:Number = new Date().time;
			if (time - _previous_down_time > _time_per_press) {
				_history = [];
			}
			_previous_down_time = time;
			_history.push(evt.keyCode);
			
			var ind:int = indexOf(_history);
			if (ind != -1) {
				(_watches[ind]["callback"] as Function).call();
			}
			if(_show_history) trace(String.fromCharCode(evt.charCode) + " - " + _history);
		}
		
		/**
		 * watches keydown for the phrase "keys"
		 * @param	keys		Array of keycodes || "keys-string || 
		 * @param	callback	function called when keys were recognized
		 */
		public function watch(keys:*, callback:Function):void {
			var k:Array;
			if (keys is String) {
				k = Ky.stringToKeys(keys as String);
			} else if (keys is Array) {
				k = Ky.mixedArrayToKeys(keys as Array);
			} else {
				throw new Error("KeyWatcher: unsupported type for 'keys' param: " + keys);
			}
			if (k.length === 0) return;
			if (alreadyWatching(k)) throw new Error("Already watching " + k);
			_watches.push(Helper.o("keys", k, "callback", callback));
		}
		
		private function alreadyWatching(keys:Array):Boolean {
			return indexOf(keys) != -1;
		}
		
		/**
		 * searches for keys in _watches
		 * @param	key keys
		 * @return	-1 if not found, otherwise index of keys in watches
		 */
		private function indexOf(keys:Array):int {
			for (var i:int = 0; i < _watches.length; i++) {
				if(areKeys(_watches[i]["keys"] as Array, keys)) {
					return i;
				}
			}
			return -1;
		}
		
		public function toString():String {
			var res:String = "watching for...";
			for each(var c:Object in _watches) {
				res = res.concat("\n  " + Ky.keysToString(c["keys"]) + " // " + c["keys"]);
			}
			return res;
		}
		
		/**
		 * unwatch keys
		 * @param	keys 	array || string || mixed array ["string", 65, "bla"]
		 */
		public function unwatch(keys:*):void {
			var k:Array;
			if (keys is String) {
				k = Ky.stringToKeys(keys as String);
			} else if (keys is Array) {
				k = Ky.mixedArrayToKeys(keys as Array);
			} else {
				throw new Error("KeyWatcher: unsupported type for 'keys' param: " + keys);
			}
			
			var ind:int = indexOf(k);
			if (ind != -1) {
				_watches.splice(ind, 1);
			}
		}
		
		private function areKeys(keys1:Array, keys2:Array):Boolean {
			if (keys1.length != keys2.length) return false;
			for (var i:int = 0; i < keys1.length; i++) {
				if (keys1[i] != keys2[i]) return false;
			}
			return true;
		}
		
		public static function killAlwaysFocus(st:Stage):void {
			if (_always_focus_function === null) return;
			st.removeEventListener(FocusEvent.FOCUS_OUT, _always_focus_function);
		}
		
		public static function alwaysFocus(st:Stage):void {
			if (_always_focus_clip === null) {
				_always_focus_clip = new Sprite();
				_always_focus_clip.mouseEnabled = false;
				_always_focus_clip.mouseChildren = false;
			}
			
			if (_always_focus_function === null) {
				_always_focus_function = function(evt:FocusEvent):void {
					if (st.focus != _always_focus_clip) st.focus = _always_focus_clip;
				}
			}
			
			st.addChildAt(_always_focus_clip, 0);
			st.focus = _always_focus_clip;
			st.addEventListener(FocusEvent.FOCUS_OUT, _always_focus_function);
		}
	}
}