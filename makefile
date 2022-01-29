#Linh

PRO_DIR		:= .
PROJ_NAME	:= Test_linker_startup_file_with_StandartMakefile
OUTPUT_PATH	:= $(PRO_DIR)/output

INC_DIR		:= $(PRO_DIR)/inc
##add src folder
SRC_DIR		:= $(PRO_DIR)/src
SRC_DIR		+= $(PRO_DIR)/src1
LINKER_FILES	:= $(PRO_DIR)/linker/stm32f4_discovery.ld

#lay tat ca cac file .c trong 2 src kem duong dan
SRC_FILES	:= $(foreach SRC_DIR,$(SRC_DIR),$(wildcard $(SRC_DIR)/*.c))
INC_FILES	:= $(foreach INC_DIR,$(INC_DIR),$(wildcard $(INC_DIR)/*.h))

#nhu tren, in ra cac file .c nhung k in ra dia chi
OBJ_FILES	:= $(notdir $(SRC_FILES))
#chuyen tu .c o tren sang .o
OBJ_FILES	:= $(subst .c,.o,$(OBJ_FILES))

PATH_OBJS	:= $(foreach OBJ_FILES,$(OBJ_FILES),$(OUTPUT_PATH)/$(OBJ_FILES))

vpath %.c $(SRC_DIR)
vpath %.h $(INC_DIR)

COMPILER_DIR :=

#compiler
CC			= arm-none-eabi-gcc
MACH		= cortex-m4
#compiler option
CFLAGS		= -c -mcpu=$(MACH) -mthumb -std=gnu11 -Wall -O0 -I$(INC_DIR)
#linker option
LDFLAGS		= -nostdlib -T $(LINKER_FILES) -Wl,-Map=$(OUTPUT_PATH)/$(PROJ_NAME).map

build: $(OBJ_FILES) $(LINKER_FILES)
	$(CC) $(LDFLAGS) $(PATH_OBJS) -o $(OUTPUT_PATH)/$(PROJ_NAME).elf
	arm-none-eabi-objcopy -O ihex $(OUTPUT_PATH)/$(PROJ_NAME).elf $(OUTPUT_PATH)/$(PROJ_NAME).hex
	size $(OUTPUT_PATH)/$(PROJ_NAME).elf
%.o: %.c $(INC_FILES)
	$(CC) $(CFLAGS) -c $< -o $(OUTPUT_PATH)/$@

clean:
	rm -rf *.o *.elf *.hex *.map $(OUTPUT_PATH)/*
load:
	openocd -f board/stm32f4discovery.cfg
print-%:
	@echo $($(subst print-,,$@))