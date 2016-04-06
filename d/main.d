import std.stdio;
import Immutable.list;

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

void main() 
{
    hello();
}
