ENTRY(boot_start)

MEMORY
{
    RETRAM_CM4 : ORIGIN = 0x00000000, LENGTH = 0x10000
}

PHDRS
{
    vectors PT_LOAD FLAGS(5);
    text    PT_LOAD FLAGS(5);
    data    PT_LOAD FLAGS(6);

    /*
     * XXX Currently required to avoid warning, probably because of
     * different alignments of .data and .bss.
     */
    bss     PT_LOAD FLAGS(6);
}

SECTIONS
{
    .vectors : {
        *(.vectors)
    } > RETRAM_CM4 : vectors

    .text : {
        *(.text*)
        *(.rodata*)
    } > RETRAM_CM4 : text

    .data : {
        _data_start = .;
        *(.data*)
        _data_end = .;
    } > RETRAM_CM4 : data

    .bss : {
        _bss_start = .;
        *(.bss)
        _bss_end = .;
    } > RETRAM_CM4 : bss

    /*
     * The .eh_frame section is used by DWARF tools to unwind the stack,
     * allowing software to dump stack traces. Although this section could
     * safely be left in the kernel image, it may confuse people who
     * disassemble it.
     */
    /DISCARD/ : {
        *(.eh_frame)
        *(.ARM*)
    }
}
