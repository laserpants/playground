module Immutable.Lazy.suspension;

immutable class Suspension(T) 
{
    this(T delegate() delay) immutable
    {
        this.delay = delay;
    }

    T eval()
    {
        return delay();
    }

    private T delegate() delay;
}
