// This simple example uses HaxeFlixel

// Copyright © 2014 John Watson (Example in JS and Assets)
// Copyright © 2014 Christopher Kaster (Port to HaxeFlixel)
// Licensed under the terms of the MIT License

package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxTimer;

class PlayState extends FlxState {

	// a sprite that represents our gun
	private var gun:FlxSprite;

	// group that contains the bullets
	private var bulletPool:FlxTypedGroup<FlxSprite>;

	// variable to track the elapsed time
	private var elapsed:Float = 0xFFFF;

	// define constants
	private var SHOT_DELAY = 0.1; // 100ms
	private var BULLET_SPEED = 500;
	private var NUMBER_OF_BULLETS = 1;

	// setup the example
	public override function create():Void {
		super.create();

		// Set stage background to something sky colored
		FlxG.cameras.bgColor = 0xFF4488CC; // ARGB

		// create the gun sprite
		gun = new FlxSprite(50, FlxG.height / 2);
		gun.loadGraphic("assets/bullet.png");

		// create a pool of bullets that we can shoot
		bulletPool = new FlxTypedGroup<FlxSprite>();

		// fill the bulletPool with the maximum number of bullets that can exist at once
		for(i in 0...NUMBER_OF_BULLETS) {
			// create bullet
			var bullet = new FlxSprite(this.gun.x, this.gun.y);
			bullet.loadGraphic("assets/bullet.png");

			// add bullet to pool
			bulletPool.add(bullet);

			// set its initial state to "dead" - it will be revived when it's shot
			bullet.kill();
		}

		// add gun and bulletPool to this FlxState (this is what causes them to update and draw)
		this.add(gun);
		this.add(bulletPool);
	}

	public override function destroy():Void {
		super.destroy();
	}

	// update() method is called every frame
	public override function update():Void {
		// add to elapsed time
		elapsed += FlxG.elapsed;

		// if primary mouse button is pressed and enough time has elapsed since last shot
		if(FlxG.mouse.justPressed && elapsed >= SHOT_DELAY) {
			shootBullet();

			// reset elapsed
			elapsed = 0;
		}

		// if a bullet is alive and not on screen, kill it!
		for(bullet in bulletPool) {
			if(bullet.alive && !bullet.isOnScreen(FlxG.camera)) {
				bullet.kill();
			}
		}

		super.update();
	}

	private function shootBullet():Void {
		// get a dead bullet from the pool
		var bullet = cast bulletPool.getFirstDead();

		// if there is no dead bullet return
		if(bullet == null) {
			return;
		}

		// mark bullet as alive
		bullet.revive();

		// set the bullet position to the gun position.
		bullet.reset(this.gun.x, this.gun.y);

		// shoot it! Peng!
		bullet.velocity.x = this.BULLET_SPEED;
		bullet.velocity.y = 0;
	}
}