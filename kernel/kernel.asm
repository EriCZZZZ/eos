SELECTOR_KERNEL_CS      equ     8   ; 8= 0x1000 idx=1 TI=0 RPL=0

extern  cstart
extern  spurious_irq
extern  exception_handler

extern  gdt_ptr
extern  idt_ptr
extern  disp_pos

[SECTION .bss]
StackSpace      resb    2 * 1024
StackTop:

[section .text]

global  _start

; interrupt
global divide_error
global single_step_exception
global nmi
global breakpoint_exception
global overflow
global bounds_check
global inval_opcode
global copr_not_available
global double_fault
global copr_seg_overrun
global inval_tss
global segment_not_present
global stack_exception
global general_protection
global page_fault
global copr_error

global hwint00
global hwint01
global hwint02
global hwint03
global hwint04
global hwint05
global hwint06
global hwint07
global hwint08
global hwint09
global hwint10
global hwint11
global hwint12
global hwint13
global hwint14
global hwint15

; interrupt end

_start:
    mov     esp, StackTop

    mov     dword [disp_pos], 0

    sgdt    [gdt_ptr]   ; 存储GDTR
    call    cstart
    lgdt    [gdt_ptr]
    lidt    [idt_ptr]

    jmp     SELECTOR_KERNEL_CS:csinit

csinit:
    push    0
    popfd

    sti         ; enable interrupt

    hlt

divide_error:
    push    0xFFFFFFFF
    push    0
    jmp     exception
single_step_exception:
    push    0xFFFFFFFF
    push    1
    jmp     exception
nmi:
    push    0xFFFFFFFF
    push    2
    jmp     exception
breakpoint_exception:
    push    0xFFFFFFFF
    push    3
    jmp     exception
overflow:
    push    0xFFFFFFFF
    push    4
    jmp     exception
bounds_check:
    push    0xFFFFFFFF
    push    5
    jmp     exception
inval_opcode:
    push    0xFFFFFFFF
    push    6
    jmp     exception
copr_not_available:
    push    0xFFFFFFFF
    push    7
    jmp     exception
double_fault:
    push    0xFFFFFFFF
    push    8
    jmp     exception
copr_seg_overrun:
    push    0xFFFFFFFF
    push    9
    jmp     exception
inval_tss:
    push    0xFFFFFFFF
    push    10
    jmp     exception
segment_not_present:
    push    0xFFFFFFFF
    push    11
    jmp     exception
stack_exception:
    push    0xFFFFFFFF
    push    12
    jmp     exception
general_protection:
    push    0xFFFFFFFF
    push    13
    jmp     exception
page_fault:
    push    0xFFFFFFFF
    push    14
    jmp     exception
copr_error:
    push    0xFFFFFFFF
    push    16
    jmp     exception
exception:
    call    exception_handler
    add     esp, 4*2
    hlt

%include "utils.inc.asm"

ALIGN   16
hwint00:
    hwint_master 0
ALIGN   16
hwint01:
    hwint_master 1
ALIGN   16
hwint02:
    hwint_master 2
ALIGN   16
hwint03:
    hwint_master 3
ALIGN   16
hwint04:
    hwint_master 4
ALIGN   16
hwint05:
    hwint_master 5
ALIGN   16
hwint06:
    hwint_master 6
ALIGN   16
hwint07:
    hwint_master 7
ALIGN   16
hwint08:
    hwint_slave 8
ALIGN   16
hwint09:
    hwint_slave 9
ALIGN   16
hwint10:
    hwint_slave 10
ALIGN   16
hwint11:
    hwint_slave 11
ALIGN   16
hwint12:
    hwint_slave 12
ALIGN   16
hwint13:
    hwint_slave 13
ALIGN   16
hwint14:
    hwint_slave 14
ALIGN   16
hwint15:
    hwint_slave 15
