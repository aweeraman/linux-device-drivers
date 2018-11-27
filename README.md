# Compiling the Kernel

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

# Installing the Kernel

```
cd /etc/mkinitcpio.d
cp linux.preset custom.preset
vi custom.preset
cp arch/x86_64/boot/bzImage /boot/vmlinuz-custom
mkinitcpio -p custom
grub-mkconfig -o /boot/grub/grub.cfg
```

# Running the Kernel in Qemu

Qemu can be used for running the built kernel in a virtualized environment
and testing it in isolation without affecting the host
system in case of bugs or issues with the kernel.

To do that, first create images for initrd and the root file system:

```
make build-rootfs
```

Set the "linux" symlink to the kernel source directory which contains a
built kernel in arch/x86_64/boot/bzImage. You can then launch it with Qemu
using the following:

```
make qemu-start
```

## Debugging the kernel using gdb

```
make qemu-debug

-- from another shell--
gdb
target remote :1234
hbreak start_kernel
continue
```
