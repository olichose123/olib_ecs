package olib.ecs;

/**
 * A definition for an entity with a specific set of components
**/
class Archetype
{
    static var nextArchetypeId:Int = 0;

    public var componentIds(default, null):Array<Int>;

    public var id(default, null):Int;

    var ecs:ECS;
    var groups:Array<ArchetypeGroup<Dynamic>> = [];

    public function new(componentIds:Array<Int>, ecs:ECS)
    {
        if (ecs == null)
            throw "ECS cannot be null";
        id = nextArchetypeId++;
        this.ecs = ecs;

        this.componentIds = componentIds ?? [];
    }

    public function getEntities():Array<Int>
    {
        if (ecs.entitiesByArchetype.exists(id))
            return ecs.entitiesByArchetype.get(id);
        else
            return [];
    }

    public function matches(entity:Int):Bool
    {
        for (i in 0...componentIds.length)
        {
            if (ecs.entities.get(entity, componentIds[i]) == null)
                return false;
        }
        return true;
    }
}
