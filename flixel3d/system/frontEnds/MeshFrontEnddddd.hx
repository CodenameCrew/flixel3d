package flixel3d.system.frontEnds;

import haxe.exceptions.NotImplementedException;

import flixel3d.system.Flx3DAssets.FlxMeshFormat;
import flixel3d.system.Flx3DAssets.FlxMeshFormat;
import flixel3d.system.Flx3DAssets.FlxMeshAsset;
import flixel3d.system.Flx3DAssets.FlxMeshFormat;
import flixel3d.FlxMesh;

import openfl.Assets;
/**
 * Internal storage system to prevent meshes from being used repeatedly in memory.
 *
 * Accessed via `FlxG3D.mesh`.
 */
class MeshFrontEnd
{
    var _cache:Map<String, FlxMesh>;

    public function new()
    {
        reset();
    }

    /**
	 * Gets FlxGraphic object from this storage by specified key.
	 * @param	key	Key for FlxGraphic object (its name)
	 * @return	FlxGraphic with the key name, or null if there is no such object
	 */
	public inline function get(key:String):FlxGraphic
    {
        return _cache.get(key);
    }

    public inline function checkCache(key:String):Bool
    {
        return get(key) != null;
    }

    public function add(mesh:FlxMeshAsset, unique:Bool = false, ?key:String, ?format:FlxMeshFormat):FlxMesh
    {
        if ((mesh is Bytes))
        {
            return FlxMesh.fromBytes(mesh, format, unique, key, true);
        }

        // String case
        return FlxMesh.fromAssetKey(mesh, unique, key, true, format);
    }

    public inline function addMesh(mesh:FlxMesh):FlxMesh
    {
        _cache.set(mesh.key, loadedMesh);
        return mesh;
    }
}