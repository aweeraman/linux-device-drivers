# Qemu for Kernel Development

Qemu can be used for creating a virtual image where kernel development
and testing can be performed in isolation without affecting the host
system in case of bugs or issues with the kernel.

To do that, first create a Qemu image of a Linux distribution of your
choice. The example below is for Arch Linux:


```
qemu-system-x86_64 -m 1024 -cdrom ../arch/archlinux-2017.12.01-x86_64.iso -boot menu=on -drive file=rootfs.img,format=raw
```

Follow the installation instructions for your distribution. [Here are the steps for Arch Linux.](https://wiki.archlinux.org/index.php/installation_guide)

Make sure to run the following steps from after completing the Arch
setup to install the Grub bootloader:

```
pacman -S grub os-prober
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

You can then boot into Qemu using the following:

```
qemu-system-x86_64 -m 1024 -drive file=rootfs.img
```

To attach a debugger to the kernel:

```
qemu-system-x86_64 -m 1024 -drive file=rootfs.img -s -S
gdb
file vmlinuz
target remote :1234
hbreak start_kernel
continue
```

# Compile the Kernel

Install the pre-requisites in Arch, and compile the kernel, making sure to enable
required parameters such as 'CONFIG_DEBUG_INFO'.

```
pacman -S base-devel bc
make clean mrproper
zcat /proc/config.gz > .config
make nconfig
time make -j 5
sudo make modules_install
```
