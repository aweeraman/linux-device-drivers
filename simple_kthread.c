#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/delay.h>

MODULE_LICENSE("GPL");

static struct task_struct *kthread_struct;

static int thread_fn(void *unused) 
{
  while(1) {
    printk(KERN_INFO "Simple thread is running");
    ssleep(5);
  }

  printk(KERN_INFO "Simple thread is stopping");

  do_exit(0);
  return 0;
}

static int __init simple_module_init(void)
{
  printk(KERN_INFO "Creating thread");

  kthread_struct = kthread_run(thread_fn, NULL, "simplethread");

  if (kthread_struct) {
    printk(KERN_INFO "Created thread SUCCESSFULLY\n");
  } else {
    printk(KERN_ERR "Creating thread FAILED\n");
  }

  return 0;
}

static void __exit simple_module_exit(void)
{
  printk(KERN_ALERT "Inside %s function\n", __FUNCTION__);

  if (kthread_struct) {
    kthread_stop(kthread_struct);
    printk(KERN_INFO "Simple thread stopped");
  }
}

module_init(simple_module_init);
module_exit(simple_module_exit);
