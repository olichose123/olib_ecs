package olib.ecs;

import haxe.ds.StringMap;

abstract class ArchetypeGroup<T>
{
    public var parent(default, null):Archetype;

    var entities(default, null):Array<Int> = [];

    public function new(parent:Archetype)
    {
        this.parent = parent;
        @:privateAccess parent.groups.push(this);
    }

    function onAddedToArchetype(entity:Int):Void
    {
        if (entities.contains(entity))
            throw "Entity already in group";
        entities.push(entity);
    }

    public function onRemovedFromArchetype(entity:Int):Void
    {
        if (!entities.contains(entity))
            throw "Entity not in group";
        entities.remove(entity);
        removeFromGroup(entity);
    }

    abstract public function getEntityGroup(entity:Int):T;

    abstract public function getGroupEntities(group:T):Array<Int>;

    abstract public function removeFromGroup(entity:Int):Void;

    abstract public function setGroup(entity:Int, group:T):Void;

    public function dispose():Void
    {
        @:privateAccess parent.groups.remove(this);
        entities.resize(0);
        entities = null;
        parent = null;
    }
}

class ArchetypeStringGroup extends ArchetypeGroup<String>
{
    var entitiesByGroup:StringMap<Array<Int>> = new StringMap();
    var entitiesGroup:Array<String> = [];

    public function new(parent:Archetype)
    {
        super(parent);
    }

    public function getEntityGroup(entity:Int):String
    {
        if (entitiesGroup[entity] == null)
            return null;
        return entitiesGroup[entity];
    }

    public function getGroupEntities(group:String):Array<Int>
    {
        if (entitiesByGroup.exists(group))
            return entitiesByGroup.get(group);
        else
        {
            entitiesByGroup.set(group, []);
            return entitiesByGroup.get(group);
        }
    }

    public function removeFromGroup(entity:Int):Void
    {
        // nothing to change
        if (entitiesGroup[entity] == null)
            return;

        // remove entity from old group
        entitiesByGroup.get(entitiesGroup[entity]).remove(entity);
        entitiesGroup[entity] = null;
    }

    function setGroup(entity:Int, newValue:String):Void
    {
        removeFromGroup(entity);

        // if the new group does not exist, create it
        if (!entitiesByGroup.exists(newValue))
            entitiesByGroup.set(newValue, []);

        entitiesByGroup.get(newValue).push(entity);
        entitiesGroup[entity] = newValue;
    }

    override function dispose()
    {
        super.dispose();
        entitiesByGroup = null;
        entitiesGroup.resize(0);
        entitiesGroup = null;
    }
}

typedef Coord =
{
    x:Int,
    y:Int
};

class ArchetypeGroup2D extends ArchetypeGroup<Coord>
{
    var entitiesByGroup:Array<Array<Array<Int>>> = [];
    var entitiesGroup:Array<Coord> = [];

    public function new(parent:Archetype)
    {
        super(parent);
    }

    public function getEntityGroup(entity:Int):Coord
    {
        if (entitiesGroup[entity] == null)
            return null;
        return entitiesGroup[entity];
    }

    public function getGroupEntities(group:Coord):Array<Int>
    {
        if (entitiesByGroup[group.x] == null)
            entitiesByGroup[group.x] = [];

        if (entitiesByGroup[group.x][group.y] == null)
            entitiesByGroup[group.x][group.y] = [];

        return entitiesByGroup[group.x][group.y];
    }

    public function removeFromGroup(entity:Int):Void
    {
        // nothing to change
        if (entitiesGroup[entity] == null)
            return;

        // remove entity from old group
        entitiesByGroup[entitiesGroup[entity].x][entitiesGroup[entity].y].remove(entity);
        entitiesGroup[entity] = null;
    }

    function setGroup(entity:Int, newValue:Coord):Void
    {
        removeFromGroup(entity);

        // if the new group does not exist, create it
        if (entitiesByGroup[newValue.x] == null)
            entitiesByGroup[newValue.x] = [];

        if (entitiesByGroup[newValue.x][newValue.y] == null)
            entitiesByGroup[newValue.x][newValue.y] = [];

        entitiesByGroup[newValue.x][newValue.y].push(entity);
        entitiesGroup[entity] = newValue;
    }

    override function dispose()
    {
        super.dispose();
        entitiesByGroup.resize(0);
        entitiesByGroup = null;
        entitiesGroup.resize(0);
        entitiesGroup = null;
    }
}
