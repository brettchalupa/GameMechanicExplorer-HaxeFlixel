// This simple example uses HaxeFlixel

// Copyright © 2014 John Watson (Example in JS and Assets)
// Copyright © 2014 Christopher Kaster (Port to HaxeFlixel)
// Licensed under the terms of the MIT License

package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.FlxObject;

class PlayState extends FlxState {

	private var player:FlxSprite;
	private var ground:FlxGroup;

	// set a flag for tracking if we've double jumped
	private var canDoubleJump = true;

	// define movement constants
	private var MAX_SPEED:Int = 250;
	private var ACCELERATION:Int = 600;
	private var DRAG:Int = 400;
	private var GRAVITY:Int = 980;
	private var JUMP_SPEED:Int = -600; // negative y is up

	// define keys
	private var LEFT_KEYS = ["LEFT", "A"];
	private var RIGHT_KEYS = ["RIGHT", "D"];
	private var UP_KEYS = ["UP", "W", "SPACE"];

	// setup the example
	public override function create():Void {
		super.create();

		FlxG.mouse.visible = false;

		// set stage background to something sky colored
		FlxG.cameras.bgColor = 0xFF4488CC; // ARGB

		// create the player
		player = new FlxSprite();
		player.loadGraphic("assets/player.png");

		player.x = FlxG.width / 2;
		player.y = FlxG.height - 64;

		// set player maximum movement speed
		player.maxVelocity.x = this.MAX_SPEED;
		player.maxVelocity.y = this.MAX_SPEED * 10;

		// add drag to the player that slows them down when they are not accelerating
		player.drag.x = this.DRAG;

		// add gravity
		player.acceleration.y = this.GRAVITY;

		// create the ground
		ground = new FlxGroup();

		for(i in 0...Std.int(FlxG.width / 32)) {
			var x = i * 32;

			// create new ground block
			var groundBlock = new FlxSprite(x, FlxG.height - 32);
			groundBlock.loadGraphic("assets/ground.png");

			// make the block immovable
			groundBlock.immovable = true;

			// add ground block to ground group
			ground.add(groundBlock);
		}

		// add some height markers
		var heightMarkers:FlxGroup = new FlxGroup();

		var y = FlxG.height - 32;

		while(y >= 64) {

			for(i in 0...Std.int(FlxG.width / 32)) {
				var x = i * 32;

				var marker = new FlxSprite(x, y);

				marker.loadGraphic("assets/heightmarker.png");

				heightMarkers.add(marker);
			}

			y -= 32;
		}

		// add ground group and player to the stage
		this.add(ground);
		this.add(player);
		this.add(heightMarkers);
	}

	public override function destroy():Void {
		super.destroy();
	}

	// update() method is called every frame
	public override function update():Void {
		var onTheGround = player.isTouching(FlxObject.FLOOR);

		if(leftPressed()) {
			// if the LEFT key is down, set the players velocity to move left
			player.acceleration.x = -this.ACCELERATION;
		} else if(rightPressed()) {
			// if the RIGHT key is down, set the players velocity to move right
			player.acceleration.x = this.ACCELERATION;
		} else {
			player.acceleration.x = 0;
		}

		if(onTheGround) {
			canDoubleJump = true;
		}

		if(upPressed(true)) {
			if(canDoubleJump || onTheGround) {
				// jump when player is touching the ground or they can double jump
				player.velocity.y = this.JUMP_SPEED;

				if(!onTheGround) {
					canDoubleJump = false;
				}
			}

		}

		super.update();

		// collide the player with the ground
		FlxG.collide(player, ground);
	}

	private function leftPressed(?useJustPressed:Bool = false):Bool {
		var leftKeyPressed = useJustPressed ? FlxG.keys.anyJustPressed(LEFT_KEYS) : FlxG.keys.anyPressed(LEFT_KEYS);

		var pressed = useJustPressed ? FlxG.mouse.justPressed : FlxG.mouse.pressed;

		var touchLeft = pressed && FlxG.mouse.x < FlxG.width / 4;

		return leftKeyPressed || touchLeft;
	}

	private function rightPressed(?useJustPressed:Bool = false):Bool {
		var rightKeyPressed = useJustPressed ? FlxG.keys.anyJustPressed(RIGHT_KEYS) : FlxG.keys.anyPressed(RIGHT_KEYS);

		var pressed = useJustPressed ? FlxG.mouse.justPressed : FlxG.mouse.pressed;

		var touchRight = pressed && FlxG.mouse.x > FlxG.width / 2 + FlxG.width / 4;

		return rightKeyPressed || touchRight;
	}

	private function upPressed(?useJustPressed:Bool = false):Bool {
		var upKeyPressed = useJustPressed ? FlxG.keys.anyJustPressed(UP_KEYS) : FlxG.keys.anyPressed(UP_KEYS);

		var pressed = useJustPressed ? FlxG.mouse.justPressed : FlxG.mouse.pressed;

		var touchUp = pressed && FlxG.mouse.y < FlxG.height /2;

		return upKeyPressed || touchUp;
	}
}