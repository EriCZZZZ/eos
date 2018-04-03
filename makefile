# build os

# vars
ASM		= nasm
ASMFLAGS	= -I include/ -I boot/include/
ASMFLAGS_BUILD_COM		= -I include/ -I boot/include/ -D _BUILD_COM_
OUTPUT_PATH	= ./build

TARGET		= boot.bin loader.bin kernel.bin os.img

everything : rm_img $(OUTPUT_PATH) $(TARGET)

boot.com : ./boot/boot.asm
	rm -rf $(OUTPUT_PATH)/$@
	$(ASM) $(ASMFLAGS_BUILD_COM) -o $(OUTPUT_PATH)/$@ $<

rm_img :
	rm -f $(OUTPUT_PATH)/os.img

clean : 
	rm -f $(OUTPUT_PATH)/*

all : clean everything

$(OUTPUT_PATH) :
	mkdir -p $(OUTPUT_PATH)

boot.bin : ./boot/boot.asm 
	$(ASM) $(ASMFLAGS) -o $(OUTPUT_PATH)/$@ $<

loader.bin : ./boot/loader.asm
	$(ASM) $(ASMFLAGS) -o $(OUTPUT_PATH)/$@ $<

kernel.bin : ./kernel/kernel.asm
	$(ASM) $(ASMFLAGS) -o $(OUTPUT_PATH)/$@ $<

os.img : boot.bin loader.bin kernel.bin
	bximage -mode=create -fd=1.44M -q $(OUTPUT_PATH)/$@
	dd if=$(OUTPUT_PATH)/boot.bin of=$(OUTPUT_PATH)/$@ bs=512 count=1 conv=notrunc
	sudo mount $(OUTPUT_PATH)/$@ /mnt/floppy
	sudo cp $(OUTPUT_PATH)/loader.bin /mnt/floppy/
	sudo cp $(OUTPUT_PATH)/kernel.bin /mnt/floppy/
	sudo umount /mnt/floppy
