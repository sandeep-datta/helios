// D import file generated from 'src\core\time.d'
module core.time;
import core.exception;
import core.stdc.time;
import core.stdc.stdio;
version (Windows)
{
    import core.sys.windows.windows;
}
else
{
    version (Posix)
{
    import core.sys.posix.time;
    import core.sys.posix.sys.time;
}
}
version (OSX)
{
    public import core.sys.osx.mach.kern_return;

    extern (C) 
{
    struct mach_timebase_info_data_t
{
    uint numer;
    uint denom;
}
    alias mach_timebase_info_data_t* mach_timebase_info_t;
    kern_return_t mach_timebase_info(mach_timebase_info_t);
    ulong mach_absolute_time();
}
}
struct Duration
{
        public 
{
    const pure nothrow @safe int opCmp(in Duration rhs);
        template opBinary(string op,D) if ((op == "+" || op == "-") && (is(_Unqual!(D) == Duration) || is(_Unqual!(D) == TickDuration)))
{
const pure nothrow @safe Duration opBinary(in D rhs)
{
static if(is(_Unqual!(D) == Duration))
{
return Duration(mixin("_hnsecs " ~ op ~ " rhs._hnsecs"));
}
else
{
if (is(_Unqual!(D) == TickDuration))
return Duration(mixin("_hnsecs " ~ op ~ " rhs.hnsecs"));
}

}
}
        ref template opOpAssign(string op,D) if ((op == "+" || op == "-") && (is(_Unqual!(D) == Duration) || is(_Unqual!(D) == TickDuration)))
{
pure nothrow @safe Duration opOpAssign(in D rhs)
{
static if(is(_Unqual!(D) == Duration))
{
mixin("_hnsecs " ~ op ~ "= rhs._hnsecs;");
}
else
{
if (is(_Unqual!(D) == TickDuration))
mixin("_hnsecs " ~ op ~ "= rhs.hnsecs;");
}

return this;
}
}

        template opBinary(string op) if (op == "*")
{
const pure nothrow @safe Duration opBinary(long value)
{
return Duration(_hnsecs * value);
}
}
        ref template opOpAssign(string op) if (op == "*")
{
pure nothrow @safe Duration opOpAssign(long value)
{
_hnsecs *= value;
return this;
}
}

        template opBinary(string op) if (op == "/")
{
const pure @safe Duration opBinary(long value)
{
if (value == 0)
throw new TimeException("Attempted division by 0.");
return Duration(_hnsecs / value);
}
}
        ref template opOpAssign(string op) if (op == "/")
{
pure @safe Duration opOpAssign(long value)
{
if (value == 0)
throw new TimeException("Attempted division by 0.");
_hnsecs /= value;
return this;
}
}

        template opBinaryRight(string op) if (op == "*")
{
const pure nothrow @safe Duration opBinaryRight(long value)
{
return opBinary!(op)(value);
}
}
        template opUnary(string op) if (op == "-")
{
const pure nothrow @safe Duration opUnary()
{
return Duration(-_hnsecs);
}
}
        template opCast(T) if (is(T == TickDuration))
{
const pure nothrow @safe TickDuration opCast()
{
return TickDuration.from!("hnsecs")(_hnsecs);
}
}
    version (Posix)
{
    }
    template get(string units) if (units == "weeks" || units == "days" || units == "hours" || units == "minutes" || units == "seconds")
{
const pure nothrow @safe long get()
{
static if(units == "weeks")
{
return getUnitsFromHNSecs!("weeks")(_hnsecs);
}
else
{
immutable hnsecs = removeUnitsFromHNSecs!(nextLargerTimeUnits!(units))(_hnsecs);
return getUnitsFromHNSecs!(units)(hnsecs);
}

}
}
        @property const pure nothrow @safe long weeks()
{
return get!("weeks")();
}

        @property const pure nothrow @safe long days()
{
return get!("days")();
}

        @property const pure nothrow @safe long hours()
{
return get!("hours")();
}

        @property const pure nothrow @safe long minutes()
{
return get!("minutes")();
}

        @property const pure nothrow @safe long seconds()
{
return get!("seconds")();
}

        @property const pure nothrow @safe FracSec fracSec();

            @property template total(string units) if (units == "weeks" || units == "days" || units == "hours" || units == "minutes" || units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs" || units == "nsecs")
{
const pure nothrow @safe long total()
{
static if(units == "nsecs")
{
return convert!("hnsecs","nsecs")(_hnsecs);
}
else
{
return getUnitsFromHNSecs!(units)(_hnsecs);
}

}
}

        string toString()
{
return _toStringImpl();
}
    const pure nothrow @safe string toString()
{
return _toStringImpl();
}
        @property const pure nothrow @safe bool isNegative()
{
return _hnsecs < 0;
}

        private 
{
    const pure nothrow @safe string _toStringImpl();
        nothrow pure @safe this(long hnsecs)
{
_hnsecs = hnsecs;
}

    long _hnsecs;
}
}
}
template dur(string units) if (units == "weeks" || units == "days" || units == "hours" || units == "minutes" || units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs" || units == "nsecs")
{
pure nothrow @safe Duration dur(long length)
{
return Duration(convert!(units,"hnsecs")(length));
}
}
struct TickDuration
{
    static immutable long ticksPerSec;

    static immutable TickDuration appOrigin;

    @trusted shared static this();

        long length;
    template to(string units,T) if ((units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs" || units == "nsecs") && (__traits(isIntegral,T) && T.sizeof >= 4))
{
const pure nothrow @safe T to()
{
enum unitsPerSec = convert!("seconds",units)(1);
if (ticksPerSec >= unitsPerSec)
return cast(T)(length / (ticksPerSec / unitsPerSec));
else
return cast(T)(length * (unitsPerSec / ticksPerSec));
}
}
    template to(string units,T) if ((units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs" || units == "nsecs") && __traits(isFloating,T))
{
const pure nothrow @safe T to()
{
static if(units == "seconds")
{
return length / cast(T)ticksPerSec;
}
else
{
enum unitsPerSec = convert!("seconds",units)(1);
return to!("seconds",T) * unitsPerSec;
}

}
}
    @property const pure nothrow @safe long seconds()
{
return to!("seconds",long)();
}

        @property const pure nothrow @safe long msecs()
{
return to!("msecs",long)();
}

    @property const pure nothrow @safe long usecs()
{
return to!("usecs",long)();
}

    @property const pure nothrow @safe long hnsecs()
{
return to!("hnsecs",long)();
}

    @property const pure nothrow @safe long nsecs()
{
return to!("nsecs",long)();
}

    static template from(string units) if (units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs" || units == "nsecs")
{
pure nothrow @safe TickDuration from(long value)
{
enum unitsPerSec = convert!("seconds",units)(1);
if (ticksPerSec >= unitsPerSec)
return TickDuration(value * (ticksPerSec / unitsPerSec));
else
return TickDuration(value / (unitsPerSec / ticksPerSec));
}
}

                version (Posix)
{
    }
    version (Linux)
{
    }
    template opCast(T) if (is(T == Duration))
{
const pure nothrow @safe Duration opCast()
{
return Duration(hnsecs);
}
}
    version (linux)
{
    }
    ref template opOpAssign(string op) if (op == "+" || op == "-")
{
pure nothrow @safe TickDuration opOpAssign(in TickDuration rhs)
{
mixin("length " ~ op ~ "= rhs.length;");
return this;
}
}

        template opBinary(string op) if (op == "-" || op == "+")
{
const pure nothrow @safe TickDuration opBinary(in TickDuration rhs)
{
return TickDuration(mixin("length " ~ op ~ " rhs.length"));
}
}
        template opUnary(string op) if (op == "-")
{
const pure nothrow @safe TickDuration opUnary()
{
return TickDuration(-length);
}
}
        const pure nothrow @safe bool opEquals(ref const TickDuration rhs)
{
return length == rhs.length;
}
        const pure nothrow @safe int opCmp(ref const TickDuration rhs)
{
return length < rhs.length ? -1 : length == rhs.length ? 0 : 1;
}
        template opOpAssign(string op,T) if (op == "*" && (__traits(isIntegral,T) || __traits(isFloating,T)))
{
pure nothrow @safe void opOpAssign(T value)
{
length *= value;
}
}
        template opOpAssign(string op,T) if (op == "/" && (__traits(isIntegral,T) || __traits(isFloating,T)))
{
pure @safe void opOpAssign(T value)
{
if (value == 0)
throw new TimeException("Attempted division by 0.");
length /= value;
}
}
        template opBinary(string op,T) if (op == "*" && (__traits(isIntegral,T) || __traits(isFloating,T)))
{
const pure nothrow @safe TickDuration opBinary(T value)
{
return TickDuration(cast(long)(length * value));
}
}
        template opBinary(string op,T) if (op == "/" && (__traits(isIntegral,T) || __traits(isFloating,T)))
{
const pure @safe TickDuration opBinary(T value)
{
if (value == 0)
throw new TimeException("Attempted division by 0.");
return TickDuration(cast(long)(length / value));
}
}
    nothrow pure @safe this(long ticks)
{
this.length = ticks;
}

    static @property @trusted TickDuration currSystemTick();

    }
template convert(string from,string to) if ((from == "years" || from == "months") && (to == "years" || to == "months"))
{
pure nothrow @safe long convert(long value)
{
static if(from == "years")
{
static if(to == "years")
{
return value;
}
else
{
static if(to == "months")
{
return value * 12;
}
else
{
static assert(0,"A generic month or year cannot be converted to or from smaller units.");
}

}

}
else
{
static if(from == "months")
{
static if(to == "years")
{
return value / 12;
}
else
{
static if(to == "months")
{
return value;
}
else
{
static assert(0,"A generic month or year cannot be converted to or from smaller units.");
}

}

}
else
{
static assert(0,"Template constraint broken. Invalid time unit string.");
}

}

}
}
static template convert(string from,string to) if ((from == "weeks" || from == "days" || from == "hours" || from == "minutes" || from == "seconds" || from == "msecs" || from == "usecs" || from == "hnsecs") && (to == "weeks" || to == "days" || to == "hours" || to == "minutes" || to == "seconds" || to == "msecs" || to == "usecs" || to == "hnsecs"))
{
pure nothrow @safe long convert(long value)
{
return hnsecsPer!(from) * value / hnsecsPer!(to);
}
}

static template convert(string from,string to) if (from == "nsecs" && (to == "weeks" || to == "days" || to == "hours" || to == "minutes" || to == "seconds" || to == "msecs" || to == "usecs" || to == "hnsecs" || to == "nsecs") || to == "nsecs" && (from == "weeks" || from == "days" || from == "hours" || from == "minutes" || from == "seconds" || from == "msecs" || from == "usecs" || from == "hnsecs" || from == "nsecs"))
{
pure nothrow @safe long convert(long value)
{
static if(from == "nsecs" && to == "nsecs")
{
return value;
}
else
{
static if(from == "nsecs")
{
return convert!("hnsecs",to)(value / 100);
}
else
{
static if(to == "nsecs")
{
return convert!(from,"hnsecs")(value) * 100;
}
else
{
static assert(0);
}

}

}

}
}

struct FracSec
{
    public 
{
    static template from(string units) if (units == "msecs" || units == "usecs" || units == "hnsecs" || units == "nsecs")
{
pure @safe FracSec from(long value)
{
return FracSec(cast(int)convert!(units,"hnsecs")(value));
}
}

        template opUnary(string op) if (op == "-")
{
const nothrow @safe FracSec opUnary()
{
try
return FracSec(-_hnsecs);
catch(Exception e)
{
assert(0,"FracSec's constructor threw.");
}
}
}
        @property const pure nothrow @safe int msecs()
{
return cast(int)convert!("hnsecs","msecs")(_hnsecs);
}

        @property pure @safe void msecs(int milliseconds)
{
immutable hnsecs = cast(int)convert!("msecs","hnsecs")(milliseconds);
_enforceValid(hnsecs);
_hnsecs = hnsecs;
}

        @property const pure nothrow @safe int usecs()
{
return cast(int)convert!("hnsecs","usecs")(_hnsecs);
}

        @property pure @safe void usecs(int microseconds)
{
immutable hnsecs = cast(int)convert!("usecs","hnsecs")(microseconds);
_enforceValid(hnsecs);
_hnsecs = hnsecs;
}

        @property const pure nothrow @safe int hnsecs()
{
return _hnsecs;
}

        @property pure @safe void hnsecs(int hnsecs)
{
_enforceValid(hnsecs);
_hnsecs = hnsecs;
}

        @property const pure nothrow @safe int nsecs()
{
return cast(int)convert!("hnsecs","nsecs")(_hnsecs);
}

        @property pure @safe void nsecs(long nsecs)
{
if (nsecs < 0)
_enforceValid(-1);
immutable hnsecs = cast(int)convert!("nsecs","hnsecs")(nsecs);
_enforceValid(hnsecs);
_hnsecs = hnsecs;
}

        string toString()
{
return _toStringImpl();
}
    const pure nothrow @safe string toString()
{
return _toStringImpl();
}
        private 
{
    const pure nothrow @safe string _toStringImpl();
        static pure @safe bool _valid(int hnsecs)
{
enum second = convert!("seconds","hnsecs")(1);
return hnsecs > -second && hnsecs < second;
}

    static pure @safe void _enforceValid(int hnsecs);

    pure @safe this(int hnsecs)
{
_enforceValid(hnsecs);
_hnsecs = hnsecs;
}

    pure @safe 
    int _hnsecs;
}
}
}
class TimeException : Exception
{
    nothrow this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null)
{
super(msg,file,line,next);
}

}
private 
{
    template hnsecsPer(string units) if (units == "weeks" || units == "days" || units == "hours" || units == "minutes" || units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs")
{
static if(units == "hnsecs")
{
    enum hnsecsPer = 1L;
}
else
{
    static if(units == "usecs")
{
    enum hnsecsPer = 10L;
}
else
{
    static if(units == "msecs")
{
    enum hnsecsPer = 1000 * hnsecsPer!("usecs");
}
else
{
    static if(units == "seconds")
{
    enum hnsecsPer = 1000 * hnsecsPer!("msecs");
}
else
{
    static if(units == "minutes")
{
    enum hnsecsPer = 60 * hnsecsPer!("seconds");
}
else
{
    static if(units == "hours")
{
    enum hnsecsPer = 60 * hnsecsPer!("minutes");
}
else
{
    static if(units == "days")
{
    enum hnsecsPer = 24 * hnsecsPer!("hours");
}
else
{
    static if(units == "weeks")
{
    enum hnsecsPer = 7 * hnsecsPer!("days");
}
}
}
}
}
}
}
}
}
    template splitUnitsFromHNSecs(string units) if (units == "weeks" || units == "days" || units == "hours" || units == "minutes" || units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs")
{
pure nothrow @safe long splitUnitsFromHNSecs(ref long hnsecs)
{
immutable value = convert!("hnsecs",units)(hnsecs);
hnsecs -= convert!(units,"hnsecs")(value);
return value;
}
}
        template getUnitsFromHNSecs(string units) if (units == "weeks" || units == "days" || units == "hours" || units == "minutes" || units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs")
{
pure nothrow @safe long getUnitsFromHNSecs(long hnsecs)
{
return convert!("hnsecs",units)(hnsecs);
}
}
        template removeUnitsFromHNSecs(string units) if (units == "weeks" || units == "days" || units == "hours" || units == "minutes" || units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs")
{
pure nothrow @safe long removeUnitsFromHNSecs(long hnsecs)
{
immutable value = convert!("hnsecs",units)(hnsecs);
return hnsecs - convert!(units,"hnsecs")(value);
}
}
        bool validTimeUnits(string[] units...);
    template nextLargerTimeUnits(string units) if (units == "days" || units == "hours" || units == "minutes" || units == "seconds" || units == "msecs" || units == "usecs" || units == "hnsecs" || units == "nsecs")
{
static if(units == "days")
{
    enum nextLargerTimeUnits = "weeks";
}
else
{
    static if(units == "hours")
{
    enum nextLargerTimeUnits = "days";
}
else
{
    static if(units == "minutes")
{
    enum nextLargerTimeUnits = "hours";
}
else
{
    static if(units == "seconds")
{
    enum nextLargerTimeUnits = "minutes";
}
else
{
    static if(units == "msecs")
{
    enum nextLargerTimeUnits = "seconds";
}
else
{
    static if(units == "usecs")
{
    enum nextLargerTimeUnits = "msecs";
}
else
{
    static if(units == "hnsecs")
{
    enum nextLargerTimeUnits = "usecs";
}
else
{
    static if(units == "nsecs")
{
    enum nextLargerTimeUnits = "hnsecs";
}
else
{
    static assert(0,"Broken template constraint");
}
}
}
}
}
}
}
}
}
        pure nothrow @safe string numToString(long value);
    private template _Unqual(T)
{
version (none)
{
    static if(is(T U == const(U)))
{
    alias _Unqual!(U) _Unqual;
}
else
{
    static if(is(T U == immutable(U)))
{
    alias _Unqual!(U) _Unqual;
}
else
{
    static if(is(T U == shared(U)))
{
    alias _Unqual!(U) _Unqual;
}
else
{
    alias T _Unqual;
}
}
}
}
else
{
    static if(is(T U == shared(const(U))))
{
    alias U _Unqual;
}
else
{
    static if(is(T U == const(U)))
{
    alias U _Unqual;
}
else
{
    static if(is(T U == immutable(U)))
{
    alias U _Unqual;
}
else
{
    static if(is(T U == shared(U)))
{
    alias U _Unqual;
}
else
{
    alias T _Unqual;
}
}
}
}
}
}

        private template _TypeTuple(TList...)
{
alias TList _TypeTuple;
}

    version (unittest)
{
    template _assertThrown(T : Throwable = Exception,E)
{
void _assertThrown(lazy E expression, string msg = null, string file = __FILE__, size_t line = __LINE__)
{
bool thrown = false;
try
expression();
catch(T t)
{
thrown = true;
}
if (!thrown)
{
immutable tail = msg.length == 0 ? "." : ": " ~ msg;
throw new AssertError("assertThrown() failed: No " ~ E.stringof ~ " was thrown" ~ tail,file,line);
}
}
}
}
    }
