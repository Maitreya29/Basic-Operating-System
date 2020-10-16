if ! which nasm > /dev/null; then install-pkg nasm; fi
if ! which qemu-system-x86_64 > /dev/null; then install-pkg qemu; fi

nasm -f elf32 Loader.asm -o Loader.o
ld -T Link.ld -melf_i386 Loader.o -o ./iso/boot/kernel
qemu-system-x86_64 -kernel ./iso/boot/kernel