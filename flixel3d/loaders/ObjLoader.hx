package flixel3d.loaders;

import flixel3d.FlxMeshData.VertexAttribute;
import haxe.io.Eof;
import haxe.exceptions.NotImplementedException;
import flixel.util.typeLimit.OneOfTwo;
import openfl.utils.ByteArray;

/**
 * Loads .obj files
 *
 * Spec: https://www.martinreddy.net/gfx/3d/OBJ.spec
 * Spec: https://www.fileformat.info/format/material/
 *
**/
class ObjLoader extends BaseLoader {
	public function new() {
		super("obj");
	}

	private var faces:Array<String> = [];

	private var curName:String;
	private var firstMesh:Bool = true;

	private var elementOffset:UInt = 0;

	/**
	 * Parses a line from the .obj file.
	 * Throws an exception if invalid data is detected.
	**/
	// BUG: Quads don't always load correctly. The current workaround is to manually triangulate quads in Blender.
	// TODO: Add MTL support
	private function parseLine(line:String) {
		var splitLine:Array<String> = line.split(" ");
		switch (splitLine[0]) {
			/*case "#": // comment
				case "mtllib": // the file wth material data
				case "o": // idk what this is, probably the name of the object? */
			case "o": // new FlxMeshData with name
				if (!firstMesh) {
					// var attributes:Array<VertexAttribute> = [{name: "vPosition", count: 3}, {name: "vTexCoord", count: 2}];
					meshes.set(curName, FlxMeshData.fromArray(vertexArray, elementArray, []));
					// faceOffsetVertex += vertexCoords.length;
					// faceOffsetTexture += textureCoords.length;
					elementOffset += elementArray.length;
					// trace(curName, vertexArray, elementArray);
					vertexArray = [];
					elementArray = [];
					/*vertexCoords = [];
						normalCoords = [];
						textureCoords = []; */
				}
				firstMesh = false;
				curName = splitLine[1];

			// trace(splitLine[1]);
			case "v": // vertex coord
				var vertex:Array<Float> = [];
				for (i in 1...4) {
					vertex.push(Std.parseFloat(splitLine[i]));
					// vertexCoords.writeFloat(Std.parseFloat(splitLine[i]));
				}
				vertexCoords.push(vertex);
			case "vn": // normal coord
				var normal:Array<Float> = [];
				for (i in 1...4) {
					normal.push(Std.parseFloat(splitLine[i]));
					// normalCoords.writeFloat(Std.parseFloat(splitLine[i]));
				}
				normalCoords.push(normal);
			case "vt": // texture coord
				var texture:Array<Float> = [];
				for (i in 1...3) {
					texture.push(Std.parseFloat(splitLine[i]));
					// textureCoords.writeFloat(Std.parseFloat(splitLine[i]));
				}
				textureCoords.push(texture);
			case "f": // face
				var numVertices = splitLine.length - 1;
				var elements:Array<UInt> = [];
				var vertices = new Array<Array<String>>();
				var faceVertexCount:UInt = 0;
				// trace(numVertices);
				for (i in 0...numVertices) {
					var faceVertex = splitLine[i + 1].split("/");
					vertices.push(faceVertex);
					// trace(faceVertex);

					// trace(Std.parseInt(faceVertex[0]));
					// trace(vertexCoords);
					// trace(vertexCoords[Std.parseInt(faceVertex[0]) - 1 - faceOffsetVertex], vertexCoords.length);
					// trace(vertexCoords[Std.parseInt(faceVertex[0]) - 1 - faceOffsetVertex].length, vertexCoords.length);
					for (v in vertexCoords[Std.parseInt(faceVertex[0]) - 1])
						// vertexBuffer.writeFloat(v);
						vertexArray.push(v);

					for (i in 0...3) {
						vertexArray.push(1);
						// vertexBuffer.writeFloat(1); // vertex colour (note: maybe add option to disable vertex colours on mesh to reduce bandwidth?)
					}

					for (v in textureCoords[Std.parseInt(faceVertex[1]) - 1])
						// vertexBuffer.writeFloat(v);
						vertexArray.push(v);
					// elementBuffer.writeUnsignedInt(vertexCount++);
					// trace(faceVertexCount);

					// create more indices to split the stinky quad into two triangles
					/*if (numVertices == 4 && faceVertexCount == 3)
						{
							elements.push(elements[1]);
							elements.push(elements[2]);
					}*/

					elements.push(vertexCount++ - elementOffset);
					faceVertexCount++;
				}
				switch (numVertices) {
					case 3: // we need to make
						for (element in elements) {
							elementArray.push(element);
							// elementBuffer.writeUnsignedInt(element);
						}
					case 4:
						// https://gamedev.stackexchange.com/a/45685 🙏 BLESS 🙏
						elementArray.push(elements[0]);
						elementArray.push(elements[1]);
						elementArray.push(elements[2]);

						elementArray.push(elements[2]);
						elementArray.push(elements[3]);
						elementArray.push(elements[0]);
				}
		}
	}

	public override function load(data:OneOfTwo<String, haxe.io.Bytes>):Map<String, FlxMeshData> {
		super.load(data);

		try {
			while (true) {
				var line = this.data.readLine();
				parseLine(line);
			}
		} catch (e:Eof) {
			parseLine("o end");
		}

		// meshes.set("lol", FlxMeshData.fromArray(vertexArray, elementArray, [])); // return FlxMeshData.fromArray(vertexArray, elementArray);

		return meshes;
	}
}
