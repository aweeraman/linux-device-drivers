KVERSION = $(shell uname -r)

obj-m := simple_module.o simple_module_init.o simple_module_exit.o

obj-m += combined_module.o
combined_module-objs := simple_module_init.o simple_module_exit.o

obj-m += simple_module_export_symbols.o simple_module_use_symbols.o

obj-m += simple_module_param.o

obj-m += simple_character_driver.o

obj-m += simple_kthread.o

obj-m += simple_spinlock.o

all:
	make -C /lib/modules/$(KVERSION)/build M=$(shell pwd) modules

clean:
	make -C /lib/modules/$(KVERSION)/build M=$(shell pwd) clean

docker-make:
	docker run --rm -it -v $(PWD):/src aweeraman/kernel /bin/bash -c "make -C /lib/modules/4.9.0-4-amd64/build M=/src modules"

docker-clean:
	docker run --rm -it -v $(PWD):/src aweeraman/kernel /bin/bash -c "make -C /lib/modules/4.9.0-4-amd64/build M=/src clean"
