import std.stdio;
import std.algorithm.iteration;

class Data
{
    this(int x) immutable { this.x = x; }

    int x;
}

immutable class List(T)
{
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

    private this(immutable Item head, uint length) immutable
    {
        _head = head;
        this.length = length;
    }

    //static immutable(List) cons(immutable T head, immutable List tail) 
    //{
    //    return new immutable List(head, tail);
    //}

    //static immutable(List) cons2(immutable List tail, immutable T head)
    //{
    //    return new immutable List(head, tail);
    //}

    //static int cons3(int x, immutable T head)
    //{
    //    return 123123;
    //}

    bool empty() pure { return _head is null; }

    immutable(T) head() pure { assert(!empty()); return _head.data; }
    immutable(List) tail() pure { assert(!empty()); return new immutable List(_head.next, length - 1); }

    public immutable uint length;

    private immutable Item _head;
}


immutable(List!Data) xx(immutable List!Data seed, immutable Data[] arr)
{
    immutable(List!Data) x(immutable List!Data);
    uint index = 0;
    x = delegate (immutable List!Data list) { 
        return index == 1 
            ? new immutable List!Data(arr[index++], list)
            : x(new immutable List!Data(arr[index++], list));
    };
    return x(seed);
}

immutable(List!Data) conz(immutable List!Data tail, immutable Data head) 
{
    return new immutable List!Data(head, tail);
}

void hello()
{
    immutable List!Data nil = new immutable List!Data;

    //reduce!(List!Data.cons)(nil)([new immutable Data(1), new immutable Data(2)]);

    //int c = reduce!(xxx)(10, [new immutable Data(1), new immutable Data(2)]);

    //immutable Data item = new immutable Data(0);

    //immutable Data[] arr = []; // new immutable Data(1), new immutable Data(2)];

    //auto x = conz(nil, new immutable Data(1));

    //reduce!(conz)(nil, arr);
    //reduce!(List!Data.cons3)(0, arr);

    //List!Data.banana(data);

    //auto list2 = List!Data.cons(new immutable Data(1), list);
    //auto list3 = List!Data.cons(new immutable Data(222), list2);

    //assert(list3.length == 2);

    //writeln(list3.tail().head().x);
}

void main() 
{
    hello();
}
