package olib.ecs;

/**
 * Base class for a component
**/
@:autoBuild(olib.ecs.Macros.addComponentId())
class Component
{
    static var nextComponentId:Int = 0;

    public static function getId():Int
    {
        return nextComponentId++;
    }
}

typedef CStruct =
{
    public var id:Int;
}
