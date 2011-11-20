extern (C) void monitor_clear();

extern(C) void monitor_write(in char *c);

extern(C) void kernelMain(){
    monitor_clear();
    monitor_write("Hello world\n");
}
