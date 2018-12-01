BASEDIR   = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
KVERSION  = $(shell make -s -C linux kernelversion)
SRCDIR   ?= $(BASEDIR)/linux
MODDIR   ?= $(BASEDIR)/build

obj-y += 1_simple_modules/
obj-y += 2_threads_and_locks/
obj-y += 3_character_devices/

all: kernel modules_install build-rootfs
	make -C $(MODDIR)/lib/modules/$(KVERSION)/build M=$(shell pwd) modules

kernel:
	bash -c "time make -j 4 -C $(SRCDIR)"

modules_install:
	mkdir -p $(MODDIR) 2>/dev/null
	bash -c "time make -j 4 -C $(SRCDIR) modules_install INSTALL_MOD_PATH=$(MODDIR)"

clean:
	make -C $(MODDIR)/lib/modules/$(KVERSION)/build M=$(shell pwd) clean
	rm -rf $(MODDIR)
	make -C $(SRCDIR) clean
	rm -rf build
	rm -f initrd.img
	rm -f rootfs.img

build-initrd:
	sudo mkinitcpio -r $(MODDIR) -g initrd.img -k $(KVERSION)

build-rootfs: build-initrd
	dd if=/dev/zero of=rootfs.img bs=4096 count=12800
	mkfs.ext4 rootfs.img
	mkdir mnt
	sudo mount rootfs.img mnt
	zcat initrd.img | sudo cpio -idm -D mnt
	sudo mknod -m 622 mnt/dev/console c 5 1
	sudo mknod -m 666 mnt/dev/null c 1 3
	sudo mknod -m 666 mnt/dev/zero c 1 5
	sudo mknod -m 666 mnt/dev/ptmx c 5 2
	sudo mknod -m 666 mnt/dev/tty c 5 0
	sudo mknod -m 444 mnt/dev/random c 1 8
	sudo mknod -m 444 mnt/dev/urandom c 1 9
	sudo chown root:tty mnt/dev/{console,ptmx,tty}
	sudo mkdir mnt/etc/init.d
	sudo touch mnt/etc/init.d/rcS
	sudo chmod 755 mnt/etc/init.d/rcS
	sudo umount mnt
	sudo rm -rf mnt

qemu-start:
	qemu-system-x86_64 -m 256 -nographic --enable-kvm -kernel linux/arch/x86_64/boot/bzImage -initrd initrd.img -hda rootfs.img -append "root=/dev/sda console=ttyS0"

qemu-debug:
	qemu-system-x86_64 -m 256 -nographic --enable-kvm -kernel linux/arch/x86_64/boot/bzImage -initrd initrd.img -hda rootfs.img -append "root=/dev/sda console=ttyS0" -s -S
