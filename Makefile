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

docker-build-kernel:
	docker run --rm -it -v $(PWD):/src aweeraman/kernel /bin/bash -c "cd /src/linux; make clean; time make -j 5"

qemu-start:
	qemu-system-x86_64 -m 4096M -smp 4 -vga std -drive file=rootfs.img,format=raw -net nic,model=e1000 -net user,hostfwd=tcp::1139-:139,hostfwd=tcp::1445-:445,hostfwd=udp::1137-:137,hostfwd=udp::1138-:138

qemu-start-debug:
	qemu-system-x86_64 -m 4096M -smp 4 -vga std -drive file=rootfs.img,format=raw -net nic,model=e1000 -net user,hostfwd=tcp::1139-:139,hostfwd=tcp::1445-:445,hostfwd=udp::1137-:137,hostfwd=udp::1138-:138 -s -S
