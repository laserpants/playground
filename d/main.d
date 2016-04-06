import std.stdio;
import Immutable.list;
import Immutable.Lazy.list;
import Immutable.Lazy.suspension;

class Data
{
    this(int x) immutable { this.x = x; }
    int x;
}

void hello()
{
    auto list = List!Data.fromArray([new immutable Data(1), new immutable Data(2), new immutable Data(3)]);

    assert(list.length == 3);
    assert(list.head().x == 1);
    assert(list.tail().head().x == 2);
    assert(list.tail().tail().head().x == 3);

    auto cons = list.destruct();
    assert(cons.tail.length == 2);
    assert(cons.head.x == 1);

    auto list2 = List!Data.fromArray([new immutable Data(1), new immutable Data(2), new immutable Data(3), new immutable Data(4), new immutable Data(5), new immutable Data(6)]);
    auto list3 = list2.take(4);

    assert(list3.length == 4);
    assert(list3.head().x == 1);
    assert(list3.tail().head().x == 2);
    assert(list3.tail().tail().head().x == 3);
    assert(list3.tail().tail().tail().head().x == 4);

    auto list4 = list2.tail().take(4);

    assert(list4.length == 4);
    assert(list4.head().x == 2);
    assert(list4.tail().head().x == 3);
    assert(list4.tail().tail().head().x == 4);
    assert(list4.tail().tail().tail().head().x == 5);
}

class LL
{
    static class Item
    {
        this(int data, LL tail) 
        {
            this.data = data;
            this.tail = tail;
        }

        int data;
        LL tail;
    }

    this(int data, LL tail)
    {
        _head = new immutable Suspension!Item(() => new Item(data, tail));
    }

    this()
    {
        _head = null;
    }

    private this(immutable Suspension!Item item)
    {
        _head = item;
    }

    int head() { return _head.eval().data; }

    LL tail() { return _head.eval().tail; }

    LL take(int n)
    {
        if (0 == n)
            return new LL;
        Item item = _head.eval();
        return new LL(item.data, tail().take(n - 1));
    }

    immutable Suspension!Item _head;
}

LL enumFrom(int n)
{
    return new LL(n, enumFrom(n + 1));
}

void hello2()
{
    auto susp = new immutable Suspension!int(() => 5);

    int n = susp.eval();

    writeln(n);

    LL list3 = enumFrom(1);

    //auto list4 = list3.take(10);

    writeln("XX");

    /*
    LL list = new LL;

    auto list2 = new LL(5, list);

    writeln(list2.head());
    */

    //auto list2 = LazyList!int.cons(() => 5, list);

    //assert(5 == list2.head().force());
}

void main() 
{
    hello();
    hello2();
}
