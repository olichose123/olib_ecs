package olib.ecs;

/**
 * A Sparse set implementation
**/
class SparseSet<T> implements ISparseSet<T>
{
    public var data(default, null):Array<T>;
    public var sparse(default, null):Array<Null<Int>>;
    public var dense(default, null):Array<Null<Int>>;
    public var size(default, null):Int = 0;

    public function new()
    {
        data = [];
        sparse = [];
        dense = [];
        size = 0;
    }

    public function getNextIndex():Int
        return sparse.length;

    public inline function exists(index:Int):Bool
        return index >= 0 && sparse[index] != null && sparse[index] < size && dense[sparse[index]] == index;

    public inline function set(index:Int, ?value:T):Int
    {
        if (exists(index))
        {
            data[sparse[index]] = value;
            return sparse[index];
        }
        else
        {
            dense[size] = index;
            sparse[index] = size;
            data[size] = value;
            return size++;
        }
    }

    public function get(index:Int):T
    {
        if (!exists(index))
            return null;
        return data[sparse[index]];
    }

    public inline function getIndex(densePos:Int):Int
    {
        return dense[densePos];
    }

    public inline function remove(index:Int):Void
    {
        if (!exists(index))
            return;

        data[sparse[index]] = data[size - 1];
        data[size - 1] = null;

        dense[sparse[index]] = dense[size - 1];
        sparse[dense[size - 1]] = sparse[index];
        sparse[index] = null; // can be ignored
        // dense.resize(size - 1); // can be ignroed
        size--;
    }

    public inline function matches(index:Int, item:T):Bool
    {
        return exists(index) && data[sparse[index]] == item;
    }

    public inline function getData(index:Int):T
    {
        if (!exists(index))
            return null;
        return data[sparse[index]];
    }

    public inline function clear():Void
    {
        sparse.resize(0);
        dense.resize(0);
        data.resize(0);
        size = 0;
    }
}

interface ISparseSet<T>
{
    public function getNextIndex():Int;

    public function exists(index:Int):Bool;

    public function set(index:Int, ?value:T):Int;

    public function get(index:Int):T;

    public function getIndex(densePos:Int):Int;

    public function remove(index:Int):Void;

    public function matches(index:Int, item:T):Bool;

    public function getData(index:Int):T;

    public function clear():Void;
}
