ENTRY(Reset_Handler)

_estack = ORIGIN(RAM_DATA) + LENGTH(RAM_DATA);

_Min_Heap_Size = 0x1000;  /* 4 KiB */
_Stack_Size = 0x800;     /* 2 KiB */

MEMORY {
  FLASH       (rx): ORIGIN = 0x08000000, LENGTH = 0x0000F7FF
  RAM_VECT   (xrw): ORIGIN = 0x20000000, LENGTH = 0x00000200
  RAM_DATA   (xrw): ORIGIN = 0x20000200, LENGTH = 0x00002E00
  CCMRAM      (rw): ORIGIN = 0x10000000, LENGTH = 0x00001000
}

SECTIONS {
  /* ========================= */
  /* Flash section */
  /* ========================= */

  .isr_vector : {
    . = ALIGN(4);
    KEEP(*(.isr_vector))
    . = ALIGN(4);
  } >FLASH

  .text : {
    . = ALIGN(4);
    _stext = .;        /* define a global symbol at text start */

    *(.text)           /* .text sections (code) */
    *(.text*)          /* .text* sections (code) */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */

    *(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    _etext = .;        /* define a global symbols at end of code */
  } >FLASH

  .rodata : {
    . = ALIGN(4);
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
  } >FLASH

  .ARM.extab : {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } >FLASH

  .ARM : {
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
  } >FLASH

  .preinit_array : {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >FLASH

  .init_array : {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
  } >FLASH

  .fini_array : {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } >FLASH

  _sidata = LOADADDR(.data);

  .data : {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */

    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
  } >RAM_DATA AT> FLASH

  _siccmram = LOADADDR(.ccmram);
  .ccmram : {
    . = ALIGN(4);
    _sccmram = .;
    *(.ccmram)
    *(.ccmram*)
    . = ALIGN(4);
    _eccmram = .;
  } >CCMRAM AT> FLASH


  /* ========================= */
  /* RAM section */
  /* ========================= */

  .ram_vector : {
    . = ALIGN(4);
    KEEP(*(.ram_vector))
    . = ALIGN(4);
  } >RAM_VECT AT> FLASH

  .bss : {
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;

    . = ALIGN(4);
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM_DATA

  ._user_heap : {
    _sheap = .;
    PROVIDE ( end = . );
    PROVIDE ( _end = . );

    . = ORIGIN(RAM_DATA) + LENGTH(RAM_DATA) - _Stack_Size;
    _eheap = .;

    /* ASSERT(_eheap >= (_sheap + _Min_Heap_Size), "region RAM is too small for heap"); */
  } >RAM_DATA

  .user_stack : {
    . = ALIGN(8);
    _sstack = .;

    . = ORIGIN(RAM_DATA) + LENGTH(RAM_DATA);
    _estack = .;

    ASSERT((_sstack + _Stack_Size) <= _estack, "region RAM is too small for stack");
  } >RAM_DATA

  /DISCARD/ : {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )

    *(.note.*)
    *(.comment)
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
}

