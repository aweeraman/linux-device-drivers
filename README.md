# Compiling the Kernel

Install the pre-requisites in Arch, and invoke the make target to compile the kernel.

```
pacman -S base-devel bc
git clone https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
make SRCDIR=./staging
```

# Running the Kernel in Qemu

Qemu can be used for running the built kernel in a virtualized environment
and testing it in isolation without affecting the host
system in case of bugs or issues with the kernel.

To do that, first create images for initrd and the root file system:

```
make build-rootfs SRCDIR=../staging
```

Set the "linux" symlink to the kernel source directory which contains a
built kernel in arch/x86_64/boot/bzImage. You can then launch it with Qemu
using the following:

```
make qemu-start SRCDIR=../staging
```

## Debugging the kernel using gdb

```
make qemu-debug SRCDIR=../staging

-- from another shell--
gdb
target remote :1234
hbreak start_kernel
continue
```
