package olib.ecs.tests;

import hl.types.IntMap;

class Main
{
    static function main()
    {
        trace("hello world!");
        var ecs = new ECS();

        var archetype = new Archetype([MyComponentA.id, MyComponentC.id], ecs);

        ecs.addArchetype(archetype);

        var georges = ecs.createEntity();
        var melany = ecs.createEntity();
        var john = ecs.createEntity();

        ecs.addComponent(georges, new MyComponentA("georges"));
        ecs.addComponent(melany, new MyComponentA("melany"));
        ecs.addComponent(melany, new MyComponentC("melany"));
        ecs.addComponent(john, new MyComponentB("john"));
        ecs.addComponent(john, new MyComponentA("john"));
        ecs.addComponent(john, new MyComponentC("john"));

        var bob = ecs.createEntity();
        ecs.addComponent(bob, new MyComponentA("bob"));
        ecs.addComponent(bob, new MyComponentB("bob"));
        ecs.addComponent(bob, new MyComponentC("bob"));

        ecs.removeComponent(bob, MyComponentB.id);
        ecs.removeComponent(bob, MyComponentC.id);

        for (entity in archetype.getEntities())
        {
            var c:MyComponentA = ecs.getComponent(entity, MyComponentA.id);
            trace(c.name);
        }
    }
}

class MyComponentA extends Component
{
    public var name:String;

    public function new(name:String)
    {
        this.name = name;
    }
}

class MyComponentB extends Component
{
    public var name:String;

    public function new(name:String)
    {
        this.name = name;
    }
}

class MyComponentC extends Component
{
    public var name:String;

    public function new(name:String)
    {
        this.name = name;
    }
}
