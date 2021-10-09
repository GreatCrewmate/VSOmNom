package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitLeftExtra:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitRightExtra:FlxSprite;
	var portraitLeftExtraTwo:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'roping':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('omnom/dialogueBox');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear instance 1', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], "", 24);
			case 'star':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('omnom/dialogueBox');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear instance 1', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], "", 24);
			case 'bamboo':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('omnom/dialogueBox');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear instance 1', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], "", 24);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-20, 80);
		portraitLeft.frames = Paths.getSparrowAtlas('omnom/dialogue/OmNomPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Om Nom Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitLeftExtra = new FlxSprite(-20, 80);
		portraitLeftExtra.frames = Paths.getSparrowAtlas('omnom/dialogue/OmNomPortraitQA');
		portraitLeftExtra.animation.addByPrefix('enterQA', 'Om Nom Portrait Enter QA', 24, false);
		portraitLeftExtra.setGraphicSize(Std.int(portraitLeftExtra.width * 0.9));
		portraitLeftExtra.updateHitbox();
		portraitLeftExtra.scrollFactor.set();
		add(portraitLeftExtra);
		portraitLeftExtra.visible = false;

		portraitRight = new FlxSprite(0, 80);
		portraitRight.frames = Paths.getSparrowAtlas('omnom/dialogue/BoyfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		portraitRightExtra = new FlxSprite(0, 80);
		portraitRightExtra.frames = Paths.getSparrowAtlas('omnom/dialogue/bfgfPortrait');
		portraitRightExtra.animation.addByPrefix('enterSca', 'Boyfriend portrait enterSca', 24, false);
		portraitRightExtra.animation.addByPrefix('enterWor', 'Boyfriend portrait enterWor', 24, false);
		portraitRightExtra.animation.addByPrefix('enterShy', 'Boyfriend portrait enterShying', 24, false);
		portraitRightExtra.animation.addByPrefix('enterGF', 'Girlfriend portrait enter', 24, false);
		portraitRightExtra.animation.addByPrefix('enterGFFP', 'Girlfriend portrait enterF', 24, false);
		portraitRightExtra.setGraphicSize(Std.int(portraitRightExtra.width * 0.9));
		portraitRightExtra.updateHitbox();
		portraitRightExtra.scrollFactor.set();
		add(portraitRightExtra);
		portraitRightExtra.visible = false;

		portraitLeftExtraTwo = new FlxSprite(0, 80);
		portraitLeftExtraTwo.frames = Paths.getSparrowAtlas('omnom/dialogue/OmNomPortraitExtra');
		portraitLeftExtraTwo.animation.addByPrefix('enterOmCa', 'Om Nom Portrait EnterSca', 24, false);
		portraitLeftExtraTwo.animation.addByPrefix('enterOmAng', 'Om Nom Portrait EnterAng', 24, false);
		portraitLeftExtraTwo.setGraphicSize(Std.int(portraitLeftExtraTwo.width * 0.9));
		portraitLeftExtraTwo.updateHitbox();
		portraitLeftExtraTwo.scrollFactor.set();
		add(portraitLeftExtraTwo);
		portraitLeftExtraTwo.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('omnom/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFE0E0E0;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFFA1A1A1;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						portraitLeftExtra.visible = false;
						portraitRightExtra.visible = false;
						portraitLeftExtraTwo.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'omnom':
				portraitRight.visible = false;
				portraitRightExtra.visible = false;
				portraitLeftExtra.visible = false;
				portraitLeftExtraTwo.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'omnomqa':
				portraitRight.visible = false;
				portraitRightExtra.visible = false;
				portraitLeft.visible = false;
				portraitLeftExtraTwo.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeftExtra.visible = true;
					portraitLeftExtra.animation.play('enterQA');
				}
			case 'bf':
				portraitLeft.visible = false;
				portraitLeftExtra.visible = false;
				portraitRightExtra.visible = false;
				portraitLeftExtraTwo.visible = false;
				if (!portraitLeft.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'bfscared':
				portraitLeft.visible = false;
				portraitLeftExtra.visible = false;
				portraitRight.visible = false;
				portraitLeftExtraTwo.visible = false;
				if (!portraitLeft.visible)
				{
					portraitRightExtra.visible = true;
					portraitRightExtra.animation.play('enterSca');
				}
			case 'bfwor':
				portraitLeft.visible = false;
				portraitLeftExtra.visible = false;
				portraitRight.visible = false;
				portraitLeftExtraTwo.visible = false;
				if (!portraitLeft.visible)
				{
					portraitRightExtra.visible = true;
					portraitRightExtra.animation.play('enterWor');
				}
			case 'bfshy':
				portraitLeft.visible = false;
				portraitLeftExtra.visible = false;
				portraitRight.visible = false;
				portraitLeftExtraTwo.visible = false;
				if (!portraitLeft.visible)
				{
					portraitRightExtra.visible = true;
					portraitRightExtra.animation.play('enterShy');
				}
			case 'gf':
				portraitLeft.visible = false;
				portraitLeftExtra.visible = false;
				portraitRight.visible = false;
				portraitLeftExtraTwo.visible = false;
				if (!portraitLeft.visible)
				{
					portraitRightExtra.visible = true;
					portraitRightExtra.animation.play('enterGF');
				}
			case 'gffacep':
				portraitLeft.visible = false;
				portraitLeftExtra.visible = false;
				portraitRight.visible = false;
				portraitLeftExtraTwo.visible = false;
				if (!portraitLeft.visible)
				{
					portraitRightExtra.visible = true;
					portraitRightExtra.animation.play('enterGFFP');
				}
			case 'omnomsca':
				portraitLeft.visible = false;
				portraitLeftExtra.visible = false;
				portraitRight.visible = false;
				portraitRightExtra.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeftExtraTwo.visible = true;
					portraitLeftExtraTwo.animation.play('enterOmCa');
				}
			case 'omnomangry':
				portraitLeft.visible = false;
				portraitLeftExtra.visible = false;
				portraitRight.visible = false;
				portraitRightExtra.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeftExtraTwo.visible = true;
					portraitLeftExtraTwo.animation.play('enterOmAng');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
