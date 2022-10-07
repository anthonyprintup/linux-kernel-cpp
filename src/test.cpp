extern "C" int _printk(const char *fmt, ...);

int value {};
[[gnu::used]] struct A {
    A() noexcept {
        _printk("A::A() %i\n", value++);
    }
    ~A() {
        _printk("A::~A() %i\n", --value);
    }
} a_instance1 {}, a_instance2 {};
