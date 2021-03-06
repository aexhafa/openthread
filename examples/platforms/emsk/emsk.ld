/*
 *  Copyright (c) 2017, The OpenThread Authors.
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. Neither the name of the copyright holder nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGE.
 */

SEARCH_DIR(.)
GROUP(../../../examples/platforms/emsk/libopenthread-emsk.a libgcc.a libc.a libnosys.a)

MEMORY
{
 ICCM : ORIGIN = 0x00000000, LENGTH = 0x10000
 DCCM : ORIGIN = 0x80000000, LENGTH = 0x10000
 EXT_RAM : ORIGIN = 0x10000000, LENGTH = 0x8000000
}
ENTRY(_start)
SECTIONS
{
 .init :
 {
  _f_init = .;
  KEEP (*(.init_vector))
  KEEP (*(.init_bootstrap))
  _e_init = .;
 } > EXT_RAM
 .vector : ALIGN(1024)
 {
  _f_vector = .;
  *(.vector)
  _e_vector = .;
 } > EXT_RAM
 .text : ALIGN(4)
 {
  _f_text = .;
  *(.text .text.* .gnu.linkonce.t.*)
  _e_text = .;
 } > EXT_RAM
 .rodata : ALIGN(4)
 {
  _f_rodata = .;
  . = ALIGN(4);
  __CTOR_LIST__ = .;
  LONG((__CTOR_END__ - __CTOR_LIST__) / 4 - 2)
  KEEP(*(SORT_BY_NAME(".ctors*")))
  LONG(0)
  __CTOR_END__ = .;
  . = ALIGN(4);
  __init_array_start = .;
  KEEP(*(SORT_BY_NAME(".init_array*")))
  __init_array_end = .;
  . = ALIGN(4);
  __DTOR_LIST__ = .;
  LONG((__DTOR_END__ - __DTOR_LIST__) / 4 - 2)
  KEEP(*(SORT_BY_NAME(".dtors*")))
  LONG(0)
  __DTOR_END__ = .;
  *(.rodata .rodata.* .gnu.linkonce.r.*)
  _e_rodata = .;
 } > EXT_RAM
 .data : ALIGN(4)
 {
  _f_data = .;
  *(.data .data.* .gnu.linkonce.d.*)
  _f_sdata = .;
  __SDATA_BEGIN__ = .;
  *(.sdata .sdata.* .gnu.linkonce.s.*)
  _e_sdata = .;
  _e_data = .;
 } > EXT_RAM AT > EXT_RAM
 .bss (NOLOAD) : ALIGN(8)
 {
  PROVIDE (__sbss_start = .);
  PROVIDE (___sbss_start = .);
  _f_bss = .;
  _f_sbss = .;
  *(.dynsbss)
  *(.sbss .sbss.* .gnu.linkonce.sb.*)
  *(.scommon)
  _e_sbss = .;
  PROVIDE (__sbss_end = .);
  PROVIDE (___sbss_end = .);
  *(.dynbss)
  *(.bss .bss.* .gnu.linkonce.b.*)
  *(COMMON)
  _e_bss = .;
 } > EXT_RAM
 .stack (NOLOAD) :
 {
  . = ALIGN(4);
  _f_stack = .;
  . = . + 524288;
  _e_stack = .;
 } > EXT_RAM
 .heap (NOLOAD) :
 {
  . = ALIGN(4);
  __start_heap = . ;
  _f_heap = .;
  . = . + 524288;
  _e_heap = .;
  __end_heap = . ;
 } > EXT_RAM
 _load_addr_text = LOADADDR(.text);
 _load_addr_rodata = LOADADDR(.rodata);
 _load_addr_data = LOADADDR(.data);
}
