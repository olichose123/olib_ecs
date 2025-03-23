package olib.ecs.tests;

import utest.Assert;
import utest.Test;

class ECSTest extends Test
{
    function testCreateEntity()
    {
        var ecs = new ECS();
        var entity = ecs.createEntity();
        Assert.equals(entity, 0);
    }

    function testComponentId()
    {
        var ecs = new ECS();
        var entity = ecs.createEntity();
        var component = new MyComponentA("test");
        ecs.addComponent(entity, component);
        Assert.equals(ecs.entities.get(entity, 0), component);
    }

    function testAddRemoveComponent()
    {
        var ecs = new ECS();
        var entity = ecs.createEntity();
        var componentA = new MyComponentA("potato");
        var componentB = new MyComponentB("banana");

        ecs.addComponent(entity, componentA);
        ecs.addComponent(entity, componentB);
        Assert.isTrue(ecs.getComponent(entity, MyComponentA.id) != null);
        Assert.isTrue(ecs.getComponent(entity, MyComponentB.id) != null);

        ecs.removeComponent(entity, MyComponentA.id);
        ecs.removeComponent(entity, MyComponentB.id);
        Assert.isTrue(ecs.getComponent(entity, MyComponentA.id) == null);
        Assert.isTrue(ecs.getComponent(entity, MyComponentB.id) == null);
    }

    function testArchetype()
    {
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

        Assert.equals(archetype.getEntities().length, 3);
        Assert.notContains(georges, archetype.getEntities());
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
