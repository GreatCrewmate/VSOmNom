package;

import openfl.display.BitmapData;
import openfl.system.System;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.addons.transition.FlxTransitionableState;

import Discord.DiscordClient;

using StringTools;

class CredState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	
	private var iconArray:Array<CredIcons> = [];
	public static var credits:Array<String> = [];

	override function create()
	{
		var creditsList = CoolUtil.coolTextFile(Paths.cred('creditsList'));

		for (i in 0...creditsList.length)
		{
			var data:Array<String> = creditsList[i].split(';');
			credits.push(data[0]);
		}
		
		DiscordClient.changePresence("In the Credits Menu", null);
		
		FlxG.sound.playMusic(Paths.music("breakfast", 'shared'));
        FlxG.sound.music.fadeIn(1, 0, 0.7);
		
		FlxG.autoPause = false;
	
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bgcredits'));
		add(bg);

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...credits.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, new EReg('_', 'g').replace(new EReg('0', 'g').replace(credits[i], 'O'), ' '), true, false);
			songText.isMenuItem = true;
			songText.targetY = i;

			if(credits[i].contains("~")){
				songText.color = 0xFFEDA361;
			}
			else if (credits[i] != '')
			{
				var icon:CredIcons = new CredIcons(StringTools.replace(credits[i], " ", "-").toLowerCase());
				icon.sprTracker = songText;
				iconArray.push(icon);
				add(icon);
			}

			grpSongs.add(songText);

		}

		changeSelection();

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.F)
		{
		FlxG.fullscreen = !FlxG.fullscreen;
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.autoPause = true;
			FlxG.switchState(new MainMenuState());
		}

	}

	function changeSelection(change:Int = 0)
	{

		curSelected += change;

		if (curSelected < 0)
			curSelected = credits.length - 1;
		if (curSelected >= credits.length)
			curSelected = 0;

		var changeTyxt = curSelected;

		if(credits[curSelected] == "" || credits[curSelected].contains(":") && credits[curSelected] != "PROGRAMMERS:"){
			changeSelection(change == 0 ? 1 : change);
		}

		if(changeTyxt == curSelected){
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			

			if (iconArray[i].animation.curAnim.name == StringTools.replace(credits[curSelected], " ", "-").toLowerCase())
				iconArray[i].alpha = 1;
			else
			{
				iconArray[i].alpha = 0.6;
			}
				
		}

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}

	}
}