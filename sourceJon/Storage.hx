package;

import haxe.io.Path;
import haxe.Exception;
import lime.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Storage
{
	public static function copyNecessaryFiles():Void
	{
		for (file in Assets.list().filter(folder -> folder.startsWith('assets/videos')))
		{
			if (Path.extension(file) == 'webm')
			{
				// Ment for FNF's libraries system...
				final shit:String = file.replace(file.substring(0, file.indexOf('/', 0) + 1), '');
				final library:String = shit.replace(shit.substring(shit.indexOf('/', 0), shit.length), '');

				@:privateAccess
				Storage.copyFile(Assets.libraryPaths.exists(library) ? '$library:$file' : file, file);
			}
		}
	}

	/**
	 * This is mostly a fork of https://github.com/openfl/hxp/blob/master/src/hxp/System.hx#L595
	 */
	public static function mkDirs(directory:String):Void
	{
		var total:String = '';

		if (directory.substr(0, 1) == '/')
			total = '/';

		final parts:Array<String> = directory.split('/');

		if (parts.length > 0 && parts[0].indexOf(':') > -1)
			parts.shift();

		for (part in parts)
		{
			if (part != '.' && part.length > 0)
			{
				if (total != '/' && total.length > 0)
					total += '/';

				total += part;

				if (!FileSystem.exists(total))
					FileSystem.createDirectory(total);
			}
		}
	}

	public static function copyFile(copyPath:String, savePath:String):Void
	{
		try
		{
			if (!FileSystem.exists(savePath) && Assets.exists(copyPath))
			{
				if (!FileSystem.exists(Path.directory(savePath)))
					Storage.mkDirs(Path.directory(savePath));

				File.saveBytes(savePath, Assets.getBytes(copyPath));
			}
		}
		catch (e:Exception)
			trace(e.message);
	}
}
