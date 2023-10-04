package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import hxvlc.flixel.FlxVideo;

class VideoState extends MusicBeatState
{
	var leSource:String;
	var transClass:FlxState;
	var fuckingVolume:Float = 1;
	var video:FlxVideo;

	public function new(source:String, toTrans:FlxState):Void
	{
		super();

		FlxG.autoPause = false;

		fuckingVolume = FlxG.sound.music.volume;

		FlxG.sound.music.volume = 0;

		leSource = source;
		transClass = toTrans;
	}
	
	override function create():Void
	{
		add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));

		super.create();

		video = new FlxVideo();
		video.onEndReached.add(function()
		{
			video.dispose();

			FlxG.autoPause = true;
			FlxG.sound.music.volume = fuckingVolume;
			FlxG.switchState(transClass);
		});
		video.play(leSource);
	}
	
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (controls.ACCEPT && video.isPlaying)
			video.onEndReached.dispatch();
	}
}
