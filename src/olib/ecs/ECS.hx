package olib.ecs;

import olib.ecs.Component.CStruct;

/**
 * The ECS Manager
**/
class ECS
{
    public var entities(default, null):SparseGrid<Component> = new SparseGrid();
    public var entitiesByComponent(default, null):SparseSet<Array<Int>> = new SparseSet();
    public var componentTypes(default, null):Array<CStruct> = new Array<CStruct>();
    public var archetypesByComponent(default, null):SparseSet<Array<Archetype>> = new SparseSet();
    public var entitiesByArchetype(default, null):SparseSet<Array<Int>> = new SparseSet();
    public var entityCounter(default, null):Int = 0;

    public function new() {}

    public inline function createEntity():Int
    {
        var entity = entityCounter++;
        entities.set(entity, 0, null);

        return entity;
    }

    public inline function addArchetype(archetype:Archetype):Void
    {
        entitiesByArchetype.set(archetype.id, new Array<Int>());
        for (i in 0...archetype.componentIds.length)
        {
            var componentId = archetype.componentIds[i];

            if (!archetypesByComponent.exists(componentId))
                archetypesByComponent.set(componentId, new Array<Archetype>());

            var a = archetypesByComponent.get(componentId);
            a.push(archetype);
        }
    }

    public function addComponent(entity:Int, component:Component):Void
    {
        var componentClass:CStruct = cast Type.getClass(component);
        var componentId:Int = componentClass.id;
        componentTypes[componentId] = cast componentClass;

        if (!entitiesByComponent.exists(componentId))
            entitiesByComponent.set(componentId, new Array<Int>());
        var e = entitiesByComponent.get(componentId);
        e.push(entity);

        entities.set(entity, componentId, component);

        // refresh all related artefacts
        // if (archetypesByComponent.exists(componentId) && archetypesByComponent.get(componentId) != null)
        // {
        //     for (archetype in archetypesByComponent.get(componentId))
        //     {
        //         archetype.fetch();
        //     }
        // }

        // refresh only the affected entity of an archetype
        if (archetypesByComponent.exists(componentId) && archetypesByComponent.get(componentId) != null)
        {
            for (archetype in archetypesByComponent.get(componentId))
            {
                if (archetype.matches(entity))
                    entitiesByArchetype.get(archetype.id).push(entity);
            }
        }
    }

    public inline function getComponent<T:Component>(entity:Int, componentId:Int):T
    {
        return cast entities.get(entity, componentId);
    }

    public inline function getEntities(componentId:Int):Array<Int>
    {
        return entitiesByComponent.get(componentId);
    }

    public inline function getComponents(entity:Int):Array<Component>
    {
        return entities.getData(entity);
    }

    public inline function hasComponent(entity:Int, componentId:Int):Bool
    {
        return return entities.get(entity, componentId) != null;
    }

    public function removeComponent<T:Component>(entity:Int, componentId:Int):T
    {
        var s = entities.get(entity, componentId);
        entities.set(entity, componentId, null);
        entitiesByComponent.get(componentId).remove(entity);

        // refresh all related artefacts
        // if (archetypesByComponent.exists(componentId))
        // {
        //     for (archetype in archetypesByComponent.data[componentId])
        //     {
        //         archetype.fetch();
        //     }
        // }

        // refresh only the affected entity of an archetype
        if (archetypesByComponent.exists(componentId))
        {
            for (archetype in archetypesByComponent.get(componentId))
            {
                entitiesByArchetype.get(archetype.id).remove(entity);
            }
        }

        return cast s;
    }
}
