import std.stdio;

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
    }

    this(immutable T data, immutable List tail) immutable 
    {
        _head = new immutable Item(data, tail._head);
    }

    private this(immutable Item head) immutable
    {
        _head = head;
    }

    static immutable(List) cons(immutable T head, immutable List tail) 
    {
        return new immutable List(head, tail);
    }

    bool empty() pure { return _head is null; }

    immutable(T) head() pure { assert(!empty()); return _head.data; }
    immutable(List) tail() pure { assert(!empty()); return new immutable List(_head.next); }

    private immutable Item _head;
}

void hello()
{
    auto list = new immutable List!Data;
    auto list2 = List!Data.cons(new immutable Data(1), list);
    auto list3 = List!Data.cons(new immutable Data(222), list2);

    writeln(list3.tail().head().x);
}

void main() 
{
    hello();
}
