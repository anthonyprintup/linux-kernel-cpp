#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

extern void call_constructors();
extern void call_destructors();

static int __init load_kernel_module() {
    call_constructors();

    pr_info("Loaded the kernel module.\n");
    return 0;
}
static void __exit unload_kernel_module() {
    call_destructors();

    pr_info("Unloaded the kernel module.\n");
}

module_init(load_kernel_module)
module_exit(unload_kernel_module)

MODULE_AUTHOR("Anthony Printup <anthony@printup.io>");
MODULE_DESCRIPTION("POC C++ Kernel Module");
MODULE_VERSION("v1.0.0");
MODULE_LICENSE("Proprietary");
