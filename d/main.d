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
    
        return f(List.empty(), arr.length - 1);
    }

    static immutable(List) cons(immutable T head, immutable List tail) pure { return new immutable List(head, tail); }
    static immutable(List) cons(immutable Cons cons) pure { return new immutable List(cons.head, cons.tail); }
    static immutable(List) empty() pure { return new immutable List; }

    bool isEmpty() pure { return _head is null; }

    immutable(T) head() pure { assert(!isEmpty()); return _head.data; }
    immutable(List) tail() pure { assert(!isEmpty()); return new immutable List(_head.next, length - 1); }

    immutable Cons destruct() pure { return Cons(head(), tail()); }

    public immutable ulong length;

    private immutable Item _head;
}

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
}

void main() 
{
    hello();
}
