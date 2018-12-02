BASEDIR   = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SRCDIR   ?= $(BASEDIR)/linux
MODDIR   ?= $(BASEDIR)/build
CONFIG   ?= $(BASEDIR)/config/default
MNTDIR   ?= $(BASEDIR)/mnt
KVERSION  = $(shell make -s -C $(SRCDIR) kernelversion)

obj-y += 1_simple_modules/
obj-y += 2_threads_and_locks/
obj-y += 3_character_devices/

all: kernel modules_install update-rootfs
	make -C $(MODDIR)/lib/modules/$(KVERSION)/build M=$(shell pwd) modules
	make -C $(MODDIR)/lib/modules/$(KVERSION)/build M=$(shell pwd) modules_install INSTALL_MOD_PATH=$(MODDIR)

kernel: | $(SRCDIR)
	bash -c "time make -j 4 -C $(SRCDIR)"

$(SRCDIR):
	@echo "$(SRCDIR) does not exist"
	@exit 1

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
	mkinitcpio -r $(MODDIR) -g initrd.img -k $(KVERSION)

build-rootfs: build-initrd
	dd if=/dev/zero of=rootfs.img bs=4096 count=512000
	mkfs.ext4 rootfs.img
	mkdir $(MNTDIR)
	sudo mount rootfs.img $(MNTDIR)
	sudo pacstrap $(MNTDIR) base
	sudo umount $(MNTDIR)
	sudo rm -rf $(MNTDIR)

update-rootfs:
	mkdir $(MNTDIR)
	sudo mount rootfs.img $(MNTDIR)
	sudo cp -r $(MODDIR)/lib/modules/* $(MNTDIR)/lib/modules/
	sudo umount $(MNTDIR)
	sudo rm -rf $(MNTDIR)

qemu-start:
	qemu-system-x86_64 -m 512 -nographic --enable-kvm -kernel $(SRCDIR)/arch/x86_64/boot/bzImage -initrd initrd.img -hda rootfs.img -append "root=/dev/sda rw console=ttyS0"

qemu-debug:
	qemu-system-x86_64 -m 512 -nographic --enable-kvm -kernel $(SRCDIR)/arch/x86_64/boot/bzImage -initrd initrd.img -hda rootfs.img -append "root=/dev/sda rw console=ttyS0" -s -S
