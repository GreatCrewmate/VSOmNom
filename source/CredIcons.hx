package;

import flixel.FlxSprite;
import flixel.FlxG;

class CredIcons extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public function new(char:String = 'vini', isPlayer:Bool = false)
	{
		super();

		loadGraphic(Paths.image('CredIcons'), true, 150, 150);

		antialiasing = true;
		animation.add('vini', [0], 0, false, isPlayer);
		animation.add('gcrew', [1], 0, false, isPlayer);
		animation.add('miawni', [2], 0, false, isPlayer);
		animation.add('mello-and-dandi', [3], 0, false, isPlayer);
		animation.add('shellbilly', [4], 0, false, isPlayer);
		animation.add('v-eleven', [5], 0, false, isPlayer);
		animation.play(char);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}