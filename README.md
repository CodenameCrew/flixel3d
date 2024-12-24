# Flixel3D

A 3D engine for flixel, using OpenGL.

> [!CAUTION]
> This library is still in development, and is not yet ready for use.

## Installation

Installing via Git:

```
haxelib git flixel3d https://github.com/FNF-CNE-Devs/flixel3d
```

Add the following to your `Project.xml`:

```xml
<haxelib name="flixel3d" />
```

## Usage

### Model loading:
```haxe
import flixel3d.FlxModel;

var sprite:FlxSprite = new FlxSprite();
sprite.loadGraphic("assets/sprite.png");
add(sprite);

var model:FlxModel = new FlxModel();
model.loadFbxModel("assets/model.fbx");
model.angularVelocity3D.z = 30; // rotate the model
add(model);

var crown:FlxSprite = new FlxSprite();
crown.loadGraphic("assets/crown.png");
add(crown);
```

### Scene rendering:

```haxe
import flixel3d.FlxScene;

var scene:FlxScene = new FlxScene();
for (i in 0...2) {
	var model:FlxModel = new FlxModel();
	model.loadFbxModel("assets/model.fbx");
	model.x = i * 100;
	scene.add(model);
}
add(scene);
```

### Surface rendering:

```haxe
import flixel3d.FlxSurface;

var surface:FlxSurface = new FlxSurface();

var sprite = new FlxSprite(0, 0);
sprite.loadGraphic("assets/sprite.png");
surface.add(sprite);

sprite = new FlxSprite(100, 0);
sprite.loadGraphic("assets/sprite.png");
surface.add(sprite);

add(surface);
```

## License

MIT
