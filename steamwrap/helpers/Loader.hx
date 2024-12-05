package steamwrap.helpers;

#if macro
import haxe.macro.Expr;
#end


class Loader
{
	#if cpp
	public static function __init__()
	{
		cpp.Lib.pushDllSearchPath( "" + cpp.Lib.getBinDirectory() );
		cpp.Lib.pushDllSearchPath( "ndll/" + cpp.Lib.getBinDirectory() );
		cpp.Lib.pushDllSearchPath( "project/ndll/" + cpp.Lib.getBinDirectory() );
	}
	#end

	public static inline macro function load(inName2:Expr, inSig:Expr)
	{
		#if cpp
		return macro cpp.Prime.load("steamwrap", $inName2, $inSig, false);
		#else
		return macro null;
		#end
	}
	
	public static var loadErrors:Array<String> = [];
	#if !macro
	private static function fallback() { }
	/**
	 * Attempts to load a function from SteamWrap C++ library.
	 * If that fails, logs the error and returns a fallback function to reduce the odds of hard crashing on call to a broken function.
	 */
	public static function loadRaw(name:String, argc:Int):Dynamic {
		#if cpp
		try {
			var r = cpp.Lib.load("steamwrap", name, argc);
			if (r != null) return r;
		} catch (e:Dynamic) {
		#else var e = "Hashlink not supported"; #end
			loadErrors.push(Std.string(e));
		#if cpp } #end
		return function() {
			trace('Error: $name is not loaded.');
			return null;
		};
	}
	#end
}
