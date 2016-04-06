import std.stdio;
import std.typecons;

immutable class List(T)
{
    alias Cons = Tuple!(immutable T, "head", immutable List, "tail");

    static immutable class Item
    {
        this(immutable T data, immutable Item next) immutable 
        {
            this.data = data;
            this.next = next;
        }
        
        immutable T data;
        immutable Item next;
    }

    this() immutable 
    {
        _head = null;
        length = 0;
    }

    this(immutable T data, immutable List tail) immutable 
    {
        _head = new immutable Item(data, tail._head);
        length = tail.length + 1;
    }

    private this(immutable Item head, ulong length) immutable
    {
        _head = head;
        this.length = length;
    }

    static immutable(List) fromArray(immutable T[] arr) pure
    {
        immutable(List) delegate(immutable List, immutable long) pure f;
        f = delegate (list, index) => index == -1 
            ? list 
            : f(new immutable List(arr[index], list), index - 1);
    
        return f(List.nil(), arr.length - 1);
    }

    static immutable(List) cons(immutable T head, immutable List tail) pure { return new immutable List(head, tail); }
    static immutable(List) nil() pure { return new immutable List; }

    bool empty() pure { return _head is null; }

    immutable(T) head() pure { assert(!empty()); return _head.data; }
    immutable(List) tail() pure { assert(!empty()); return new immutable List(_head.next, length - 1); }

    immutable Cons destruct() pure { return Cons(head(), tail()); }

    immutable(List) take(ulong n)
    {
        return 0 == n 
            ? new immutable List
            : new immutable List(_head.data, tail().take(n - 1));
    }

    public immutable ulong length;

    private immutable Item _head;
}

//immutable class Thunk(T)
//{
//    this(T delegate() delay) immutable { this._delay = delay; }
//
//    T force() { return _delay(); }
//
//    private T delegate() _delay;
//}

class Data
{
    this(int x) immutable { this.x = x; }
    int x;
}

//void hello2()
//{
////    auto thunk = new immutable Thunk!int(() => 5);
//    writeln(thunk.force());
//}

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
