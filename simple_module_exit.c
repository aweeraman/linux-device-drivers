#include <linux/module.h>
#include "simple_module.h"

MODULE_LICENSE("GPL");

void simple_module_exit(void)
{
  printk(KERN_ALERT "Inside %s function\n", __FUNCTION__);
  simple_function_2();
}

// Since there's no module_init callback, there's no initialization performed
// but the module can be unloaded as usual as there is a module_exit callback
module_exit(simple_module_exit);
