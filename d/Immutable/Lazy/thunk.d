module Immutable.Lazy.thunk;

immutable class Thunk(T) {
    this(T delegate() thunk) immutable { this.thunk = thunk; }
    T force() { return thunk(); }

    static immutable(Thunk) delay(T delegate() thunk) { return new immutable Thunk(thunk); }

    private T delegate() thunk;
}
