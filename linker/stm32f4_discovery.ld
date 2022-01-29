ENTRY(Reset_Handler)

MEMORY
{
    FLASH(rx):ORIGIN =0x08000000, LENGTH =1024K
    SRAM(rwx):ORIGIN =0x20000000, LENGTH =128K
}

SECTIONS
{
    .text :
    {
        *(.isr_vector)
        *(.text)
        *(.rodata)
        . = ALIGN(4);
        _end_of_text = .;   
    }>FLASH AT> FLASH

    _la_data = LOADADDR(.data);
    .data :
    {
        _start_data = .;
        *(.data)
        . = ALIGN(4);
        _end_data = .;
    }>SRAM AT> FLASH

    .bss :
    {
        _start_bss = .;
        __bss_start__ = _start_bss;
        *(.bss)
        *(COMMON)
        . = ALIGN(4);
        _end_bss = .;
        __bss_end__ = _end_bss;
        . = ALIGN(4);
        end = .;
    }> SRAM
}