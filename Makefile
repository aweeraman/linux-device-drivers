KVERSION = $(shell uname -r)

obj-m := simple_module.o simple_module_init.o simple_module_exit.o

obj-m += combined_module.o
combined_module-objs := simple_module_init.o simple_module_exit.o

obj-m += simple_module_export_symbols.o simple_module_use_symbols.o

obj-m += simple_module_param.o

all:
	make -C /lib/modules/$(KVERSION)/build M=$(shell pwd) modules

clean:
	make -C /lib/modules/$(KVERSION)/build M=$(shell pwd) clean
