package olib.ecs;

/**
 * A definition for an entity with a specific set of components
**/
class Archetype
{
    static var nextArchetypeId:Int = 0;

    public var componentIds(default, null):Array<Int>;

    var ecs:ECS;

    public var id(default, null):Int;

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

    // public function refresh():Void
    // {
    //     var entities;
    //     if (componentIds.length == 0)
    //         entities = [];
    //     else if (componentIds.length == 1)
    //         entities = ecs.getEntities(componentIds[0]);
    //     else
    //     {
    //         var result = ecs.getEntities(componentIds[0]);
    //         for (i in 1...componentIds.length)
    //         {
    //             var entities = ecs.getEntities(componentIds[i]);
    //             if (entities == null)
    //                 continue;
    //             result = result.filter(e -> entities.indexOf(e) != -1);
    //         }
    //         entities = result;
    //     }
    //     ecs.entitiesByArchetype.set(id, entities);
    // }
}
