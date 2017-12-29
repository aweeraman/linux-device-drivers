#include <linux/init.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");

// __init causes the init method to be unloaded after execution
// to reclaim its memory. This can be used in cases where applicable
// to reduce the memory footprint.
__init int simple_module_init(void)
{
  printk(KERN_ALERT "Inside %s function\n", __FUNCTION__);
  return 0;
}

// Since there's no module_exit callback, this module is permanently loaded into
// kernel space.
module_init(simple_module_init);
