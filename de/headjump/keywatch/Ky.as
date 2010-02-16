package de.headjump.keywatch {
	
	public class Ky {
		public static const A:uint = 65;
		public static const B:uint = 66;
		public static const C:uint = 67;
		public static const D:uint = 68;
		public static const E:uint = 69;
		public static const F:uint = 70;
		public static const G:uint = 71;
		public static const H:uint = 72;
		public static const I:uint = 73;
		public static const J:uint = 74;
		public static const K:uint = 75;
		public static const L:uint = 76;
		public static const M:uint = 77;
		public static const N:uint = 78;
		public static const O:uint = 79;
		public static const P:uint = 80;
		public static const Q:uint = 81;
		public static const R:uint = 82;
		public static const S:uint = 83;
		public static const T:uint = 84;
		public static const U:uint = 85;
		public static const V:uint = 86;
		public static const W:uint = 87;
		public static const X:uint = 88;
		public static const Y:uint = 89;
		public static const Z:uint = 90;
		public static const SPACE:uint = 32;
		public static const N1:uint = 49;
		public static const N2:uint = 50;
		public static const N3:uint = 51;
		public static const N4:uint = 52;
		public static const N5:uint = 53;
		public static const N6:uint = 54;
		public static const N7:uint = 55;
		public static const N8:uint = 56;
		public static const N9:uint = 57;
		public static const N0:uint = 48;
		
		public static var mapping:Object;
		
		/**
		 * takes an Array containing strings and uint keycodes and concatenates them to an array only with keycodes
		 * @param	a	["hello", 65, 66, 67, "world"]
		 * @return Array with uint keycodes only
		 */
		public static function mixedArrayToKeys(a:Array):Array {
			var res:Array = [];
			for (var i:int; i < a.length; i++) {
				var c:* = a[i];
				if (c is String) {
					res = res.concat(Ky.stringToKeys(c));
				} else if (c is Number) {
					res.push(c as Number);
				} else {
					throw new Error("KeyWatcher: unsupported type in 'keys' array: " + c);
				}
			}
			return res;
		}
		
		/**
		 * builds mappint hash if null
		 */
		private static function ensureMapping():void {
			if (mapping == null) buildMapping();			
		}
		
		/**
		 * tries to decode keys to chars again. slow performance (reverses mapping), just for testing purpose and seldom use!
		 */
		public static function keysToString(keys:Array):String {
			ensureMapping();
			var res:String = "";
			for (var i:int = 0; i < keys.length; i++) {
				var found:Boolean = false;
				for (var c:String in mapping) {
					if (mapping[c] === keys[i]) {
						res = res.concat(c);
						found = true;
						break;
					}					
				}
				if (!found) {
					res = res.concat("[" + keys[i] + "]");
				}
			}
			return res;
		}
		
		public static function stringToKeys(s:String):Array {
			s = s.toLowerCase();
			ensureMapping();
			var res:Array = [];
			for (var i:int = 0; i < s.length; i++) {
				var c:* = mapping[s.charAt(i)];
				if (c != undefined) {
					res.push(c as uint);
				} else {
					throw new Error("KeyWatcher: character '" + s.charAt(i) + "'not in mapping :(");
				}
			}
			return res;
		}
		
		private static function buildMapping():void {
			mapping = { };
			mapping["a"] = A;
			mapping["b"] = B;
			mapping["c"] = C;
			mapping["d"] = D;
			mapping["e"] = E;
			mapping["f"] = F;
			mapping["g"] = G;
			mapping["h"] = H;
			mapping["i"] = I;
			mapping["j"] = J;
			mapping["k"] = K;
			mapping["l"] = L;
			mapping["m"] = M;
			mapping["n"] = N;
			mapping["o"] = O;
			mapping["p"] = P;
			mapping["q"] = Q;
			mapping["r"] = R;
			mapping["s"] = S;
			mapping["t"] = T;
			mapping["u"] = U;
			mapping["v"] = V;
			mapping["w"] = W;
			mapping["x"] = X;
			mapping["y"] = Y;
			mapping["z"] = Z;
			mapping[" "] = SPACE;
			mapping["1"] = N1;
			mapping["2"] = N2;
			mapping["3"] = N3;
			mapping["4"] = N4;
			mapping["5"] = N5;
			mapping["6"] = N6;
			mapping["7"] = N7;
			mapping["8"] = N8;
			mapping["9"] = N9;
			mapping["0"] = N0;
		}
	}
}