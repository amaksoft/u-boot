/* SPDX-License-Identifier: BSD-2-Clause */
/*
 * U-Boot aarch64 EFI linker script
 *
 * Modified from elf_aarch64_efi.lds in gnu-efi
 */

OUTPUT_FORMAT("elf64-littleaarch64", "elf64-littleaarch64", "elf64-littleaarch64")
OUTPUT_ARCH(aarch64)

PHDRS
{
	data PT_LOAD FLAGS(3); /* SHF_WRITE | SHF_ALLOC */
}

ENTRY(_start)
SECTIONS
{
	.text 0x0 : {
		_text = .;
		*(.text.head)
		*(.text)
		*(.text.*)
		*(.gnu.linkonce.t.*)
		*(.srodata)
		*(.rodata*)
		. = ALIGN(16);
	}
	.rela.dyn : { *(.rela.dyn) }
	.rela.plt : { *(.rela.plt) }
	.rela.got : { *(.rela.got) }
	.rela.data : { *(.rela.data) *(.rela.data*) }
	_etext = .;
	_text_size = . - _text;
	. = ALIGN(4096);
	.dynamic  : { *(.dynamic) }
	.data : {
		_data = .;
		*(.sdata)
		*(.data)
		*(.data1)
		*(.data.*)
		*(.got.plt)
		*(.got)

		/*
		 * The EFI loader doesn't seem to like a .bss section, so we
		 * stick it all into .data:
		 */
		. = ALIGN(16);
		_bss = .;
		*(.sbss)
		*(.scommon)
		*(.dynbss)
		*(.bss)
		*(.bss.*)
		*(COMMON)
		. = ALIGN(512);
		_bss_end = .;
		_edata = .;
	} :data
	_data_size = _edata - _data;

	. = ALIGN(4096);
	.dynsym   : { *(.dynsym) }
	. = ALIGN(4096);
	.dynstr   : { *(.dynstr) }
	. = ALIGN(4096);
	.note.gnu.build-id : { *(.note.gnu.build-id) }
	/DISCARD/ : {
		*(.rel.reloc)
		*(.eh_frame)
		*(.note.GNU-stack)
	}
	.comment 0 : { *(.comment) }
}
