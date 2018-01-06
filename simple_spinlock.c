#include <linux/module.h>
#include <linux/spinlock.h>

MODULE_LICENSE("GPL");

// Initialize the spinlock
static DEFINE_SPINLOCK(slock);

int simple_module_init(void)
{
  spin_lock(&slock);
  printk(KERN_ALERT "Inside critical section in %s\n", __FUNCTION__);
  spin_unlock(&slock);

  return 0;
}

void simple_module_exit(void)
{
  printk(KERN_ALERT "Inside %s function\n", __FUNCTION__);
}

module_init(simple_module_init);
module_exit(simple_module_exit);
