package olib.ecs;

/**
 * 2-dimensional sparse set
**/
class SparseGrid<T>
{
    public var data(default, null):Array<Array<T>>;
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

    public inline function set(index:Int, id:Int = 0, ?value:T):Int
    {
        if (exists(index))
        {
            if (data[sparse[index]] == null)
                data[sparse[index]] = [];
            data[sparse[index]][id] = value;
            return sparse[index];
        }
        else
        {
            dense[size] = index;
            sparse[index] = size;
            if (data[size] == null)
                data[size] = [];
            data[size][id] = value;
            return size++;
        }
    }

    public inline function get(index:Int, id:Int):T
    {
        if (!exists(index))
            return null;
        return data[sparse[index]][id];
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

    public inline function matches(index:Int, ids:Array<Int>):Bool
    {
        if (!exists(index))
            return false;

        for (j in 0...ids.length)
        {
            if (data[sparse[index]][ids[j]] == null)
                return false;
        }
        return true;
    }

    public inline function getData(index:Int):Array<T>
    {
        if (!exists(index))
            return null;
        return data[sparse[index]];
    }

    public inline function clear():Void
    {
        sparse.resize(0);
        dense.resize(0);
        for (i in 0...data.length)
        {
            data[i].resize(0);
            data[i] = null;
        }
        data.resize(0);
        size = 0;
    }
}
