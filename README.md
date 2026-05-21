# <img src=".github/flixel3d.webp" height="24"> Flixel3D 

A 3D rendering addon for HaxeFlixel, using OpenGL.

> [!CAUTION]
> This library is still in development, and is not yet stable or feature-complete enough to be used in serious projects.

## Installation

Installing via Git:

```
haxelib git flixel3d https://github.com/CodenameCrew/flixel3d
```

Add the following to your `Project.xml`:

```xml
<haxelib name="flixel3d" />
```

## Supported Platforms

✅ Windows, Linux, MacOS, Android, IOS, HTML5

❌ Flash

## Documentation

The API reference can be found at 
https://kitzsh.github.io/flixel3d-api-reference.

## Usage

### Model Loading / Scene rendering:

```haxe
import flixel3d.Flx3DScene;
import flixel3d.Flx3DModel;

var scene:Flx3DScene = new Flx3DScene();
for (i in -1...2) {
	var model:Flx3DModel = new Flx3DModel();
	model.loadMeshes("assets/models/SuzanneMonkey.obj");
	model.x = i * 3;
	model.z = -10;
	model.angularVelocity3D.y = i * 50;
	scene.objects.add(model);
}
add(scene);
```

### Material Application
```haxe
var model = new Flx3DModel(0, 0, -10);
model.loadMeshes("flixel3d/models/haxe.obj");

model.angularVelocity3D.y = 30;
model.scale.set(1.5, 1.5, 1.5);

var green = new Flx3DShadelessColorMaterial(0xFF00B902);
var red = new Flx3DShadelessColorMaterial(0xFFF52704);
var yellow = new Flx3DShadelessColorMaterial(0xFFFFC103);
var darkblue = new Flx3DShadelessColorMaterial(0xFF3641FF);
var lightblue = new Flx3DShadelessColorMaterial(0xFF04CDFB);

model.applyMaterials([
	"Center" => green,
	"X-TL" => yellow,
	"X-TR" => red,
	"X-BL" => darkblue,
	"X-BR" => lightblue,
	"X+TL" => yellow,
	"X+TR" => red,
	"X+BL" => darkblue,
	"X+BR" => lightblue,
]);
```

## License

The MIT License

Copyright (C)2024-2026 Codename Engine Developers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
