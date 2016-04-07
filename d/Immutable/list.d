module Immutable.list;

import std.typecons;

immutable class List(T)
{
    alias Cons = Tuple!(immutable T, "head", immutable List, "tail");

    static immutable class Item
    {
        this(immutable ref T data, immutable ref Item next) immutable 
        {
            this.data = data;
            this.next = next;
            this.length = next ? next.length + 1 : 1;
        }
        
        immutable T data;
        immutable Item next;
        immutable ulong length;
    }

    this() immutable 
    {
        _head = null;
    }

    this(immutable ref T data, immutable List tail) immutable 
    {
        _head = new immutable Item(data, tail._head);
    }

    this(immutable T data, immutable List tail) immutable 
    {
        _head = new immutable Item(data, tail._head);
    }

    private this(immutable ref Item head) immutable
    {
        _head = head;
    }

    static immutable(List) fromArray(immutable T[] arr) pure
    {
        immutable(List) delegate(immutable List, immutable long) pure f;
        f = delegate (list, index) => index == -1 
            ? list 
            : f(List.cons(arr[index], list), index - 1);
    
        return f(List.nil(), arr.length - 1);
    }

    static immutable(List) cons(immutable ref T head, immutable List tail) pure 
    { 
        return new immutable List(head, tail); 
    }

    static immutable(List) cons(immutable T head, immutable List tail) pure 
    { 
        return new immutable List(head, tail); 
    }

    static immutable(List) nil() pure { return new immutable List; }

    ulong length() pure { return _head ? _head.length : 0; }
    bool empty() pure { return _head is null; }

    immutable(T) head() pure { assert(!empty()); return _head.data; }
    immutable(List) tail() pure { assert(!empty()); return new immutable List(_head.next); }

    immutable Cons destruct() pure { return Cons(_head.data, tail()); }

    immutable(List) take(ulong n) pure
    {
        return 0 == n 
            ? new immutable List
            : new immutable List(_head.data, tail().take(n - 1));
    }

    private immutable Item _head;
}
