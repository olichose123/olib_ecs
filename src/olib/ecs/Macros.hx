package olib.ecs;

import haxe.macro.Expr;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.Field;
import haxe.macro.Context;

using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using StringTools;

class Macros
{
    macro public static function addComponentId():Array<Field>
    {
        var fields = Context.getBuildFields();
        var type = Context.toComplexType(Context.getLocalType());
        var typeName:String = switch (type)
        {
            case TPath(p):
                if (p.sub != null) p.sub; else p.name;
            default:
                null;
        };

        fields.push({
            name: "id",
            access: [APublic, AStatic, AFinal],
            pos: Context.currentPos(),
            kind: FVar(macro :Int, macro olib.ecs.Component.getId())
        });

        return fields;
    }

    macro public static function addArchetypeId():Array<Field>
    {
        var fields = Context.getBuildFields();
        var type = Context.toComplexType(Context.getLocalType());
        var typeName:String = switch (type)
        {
            case TPath(p):
                if (p.sub != null) p.sub; else p.name;
            default:
                null;
        };

        fields.push({
            name: "id",
            access: [APublic, AStatic, AFinal],
            pos: Context.currentPos(),
            kind: FVar(macro :Int, macro olib.ecs.Archetype.getId())
        });

        return fields;
    }
}
