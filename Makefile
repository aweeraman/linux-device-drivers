KVERSION = $(shell uname -r)

obj-y += 1_simple_modules/
obj-y += 2_threads_and_locks/
obj-y += 3_character_devices/

all:
	make -C /lib/modules/$(KVERSION)/build M=$(shell pwd) modules

clean:
	make -C /lib/modules/$(KVERSION)/build M=$(shell pwd) clean

docker-make:
	docker run --rm -it -v $(PWD):/src aweeraman/kernel /bin/bash -c "make -C /lib/modules/4.9.0-4-amd64/build M=/src modules"

docker-clean:
	docker run --rm -it -v $(PWD):/src aweeraman/kernel /bin/bash -c "make -C /lib/modules/4.9.0-4-amd64/build M=/src clean"
