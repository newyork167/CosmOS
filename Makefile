makefile_path 	:= $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir 	:= $(dir $(makefile_path))
bootloader_dir	:= $(dir $(current_dir)bootloader/)

.PHONY: clean-bootloader
clean-bootloader:
	rm -f $(bootloader_dir)/bootloader*.bin
	rm -f $(bootloader_dir)/*.o

.PHONY: bootloader-x86_64
bootloader-x86_64: clean-bootloader
	echo $(bootloader_dir)
	nasm -f bin $(bootloader_dir)/bootloader-x86_64.s -o $(bootloader_dir)/bootloader-x86_64.bin

.PHONY: bootloader-arm64
bootloader-arm64: clean-bootloader
	as -o $(bootloader_dir)/bootloader-arm64.o $(bootloader_dir)/bootloader-arm64.s
	ld -s -o $(bootloader_dir)/bootloader-arm64.bin $(bootloader_dir)/bootloader-arm64.o
	rm $(bootloader_dir)//bootloader-arm64.o

.PHONY: bootloader-x86_64-qemu
bootloader-x86_64-qemu: bootloader-x86_64
	qemu-system-x86_64 -drive format=raw,file=$(bootloader_dir)/bootloader-x86_64.bin
	#qemu-system-x86_64 -fda $(bootloader_dir)/bootloader-x86_64.bin

.PHONY: bootloader-arm64-qemu
bootloader-arm64-qemu: bootloader-arm64
	qemu-system-aarch64 \
    -machine virt \
    -serial stdio \
    -cpu cortex-a53 \
    -bios u-boot.bin \
    -fda $(bootloader_dir)/bootloader-arm64.bin