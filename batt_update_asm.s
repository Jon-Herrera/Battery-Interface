.text                           # IMPORTANT: subsequent stuff is executable
.global set_batt_from_ports
        
## ENTRY POINT FOR REQUIRED FUNCTION
set_batt_from_ports:
        ## assembly instructions here
        ## %rdi is the pointer to (batt_t)


        ## a useful technique for this problem
        movw    BATT_VOLTAGE_PORT(%rip), %si
        # x

        movb    BATT_STATUS_PORT(%rip), %dl
        # y

        cmpw    $0, %si
        jge     .CONTINUE
        # ERROR
        movl    $1, %eax 
        ret

.CONTINUE:
        # battV = x
        movw    %si, %ax
        cwtl
        # battV >> 1
        sarl    $1, %eax

        # battP = battV
        movl    %eax, %ecx
        # battP- 3000
        subl    $3000, %ecx
        # battP >> 3
        sarl    $3, %ecx
        # forcing bounds
        cmpl    $0, %ecx
        jge     .BOTTOM_BOUND_GOOD
        movl    $0, %ecx
.BOTTOM_BOUND_GOOD:
        cmpl    $100, %ecx
        jle     .BOTH_BOUNDS_GOOD
        movl    $100, %ecx
.BOTH_BOUNDS_GOOD:
        movl    %edx, %edx
        # bit-shifting
        shrb    $4, %dl
        andb    $1, %dl
        # ifnot equal
        movb    $2, %r9b
        # jump equal
        je      .STORE_FIELDS
        movb    $1, %r9b
.STORE_FIELDS:
        movw    %ax, 0(%rdi)
        movb    %cl, 2(%rdi)
        movb    %r9b, 3(%rdi)
        movl    $0, %eax
        ret


        # load global variable into register
        # Check the C type of the variable
        #    char / short / int / long
        # and use one of
        #    movb / movw / movl / movq 
        # and appropriately sized destination register                                            

        ## DON'T FORGET TO RETURN FROM FUNCTION

### Change to definint semi-global variables used with the next function 
### via the '.data' directive
.data                           # IMPORTANT: use .data directive for data section
	
my_int:                         # declare location an single int
        .int 1234               # value 1234

other_int:                      # declare another accessible via name 'other_int'
        .int 0b0101             # binary value as per C '0b' convention

my_array:                       # declare multiple ints sequentially starting at location
        .int 20                 # 'my_array' for an array. Each are spaced 4 bytes from the
        .int 0x00014            # next and can be given values using the same prefixes as 
        .int 0b11110            # are understood by gcc.
number_bit_mask_array:
        .int 0b0111111
        .int 0b0000110
        .int 0b1011011
        .int 0b1001111
        .int 0b1100110
        .int 0b1101101
        .int 0b1111101
        .int 0b0000111
        .int 0b1111111
        .int 0b1101111

## WARNING: Don't forget to switch back to .text as below
## Otherwise you may get weird permission errors when executing 
.text

.global  set_display_from_batt

## ENTRY POINT FOR REQUIRED FUNCTION
set_display_from_batt:
        pushq   %rbx
        pushq   %r12
        pushq   %r13
        
        # loads in bit masks
        leaq    number_bit_mask_array(%rip), %rax
        # errorr case
        cmpw    $0, %di
        jl      .ERROR_DISPLAY
        

        # bringing/ extending volts to int
        movswl    %di, %r13d
        #shrl    $16, %r13d
        #percent
        andl    $0xFF, %ecx
        # ecx is percent
        movl    %edi, %ecx
        sarl    $16, %ecx
        andw    $0xFF, %cx
        #mode
        movl    %edi, %edx
        sarl    $24, %edx

        #deciding whether percent or volts
        cmpb    $1, %dl
        je      .PERCENT
        cmpb    $2, %dl
        je      .VOLTS
        jmp     .ERROR_DISPLAY
.PERCENT:
        movl    $0, (%rsi)
       #  *display |= (1 << 0);
        orl     $1, (%rsi)
        # eax = perc
        movl    %ecx, %eax
        movl    $10, %r8d
        movl    $0, %edx
        idivl   %r8d
        # r10 is right
        movl    %edx, %r10d
        movl    %eax, %eax
        movl    $0, %edx
        idivl   %r8d
        # r11 is mid
        movl    %edx, %r11d 
        movl    %eax, %r12d
        # r12 is left
        testl   %r12d, %r12d
        jz      .LEFT_GOOD
        leaq    number_bit_mask_array(%rip), %rax
        movl    (%rax, %r12, 4), %edx
        # *display |= (bits[left] << 17);
        shll    $17, %edx
        orl     %edx, (%rsi)

.LEFT_GOOD:
        # ifmid != 0 || left != 0){ //condition for if it's at 100%
            #*display |= (bits[mid] << 10);
        # }
        testl   %r11d, %r11d
        jne     .SET_MID
        testl   %r12d, %r12d
        jz      .MID_GOOD
.SET_MID:
        # *display |= (bits[mid] << 10);
        leaq    number_bit_mask_array(%rip), %rax
        movl    (%rax, %r11, 4), %edx
        shll    $10, %edx
        orl     %edx, (%rsi)
.MID_GOOD:
        # *display |= (bits[right] << 3);
        leaq    number_bit_mask_array(%rip), %rax
        movl    (%rax, %r10, 4), %edx
        shll    $3, %edx
        orl     %edx, (%rsi)
        jmp     .BARS
.VOLTS:
        movl    $0, (%rsi)
        orl     $6, (%rsi)
        # int volt = batt.mlvolts;
        movl    %r13d, %eax
        movl    $10, %r8d
        movl    $0, %edx
        idivl   %r8d
        # edi = rightmost digit thinking about how to round
        cmpl    $5, %edx
        jl      .NO_ROUND
        addl    $1, %eax
.NO_ROUND:
        # r9 is rightmost
        movl    %eax, %r9d
        movl    %r9d, %eax
        movl    $0, %edx
        movl    $10, %r8d
        idivl   %r8d
        # r10 is mid
        movl    %edx, %r10d
        movl    $0, %edx
        idivl   %r8d
        # r11 is left
        movl    %edx, %r11d
        movl    %eax, %r12d
        leaq    number_bit_mask_array(%rip), %rax
        movl    (%rax, %r12, 4), %edx
        # *display |= (bits[left] << 17);
        shll    $17, %edx
        orl     %edx, (%rsi)
        # *display |= (bits[mid] << 10);
        leaq    number_bit_mask_array(%rip), %rax
        movl    (%rax, %r11, 4), %edx
        shll    $10, %edx
        orl     %edx, (%rsi)
        # *display |= (bits[right] << 3);
        leaq    number_bit_mask_array(%rip), %rax
        movl    (%rax, %r10, 4), %edx
        shll    $3, %edx
        orl     %edx, (%rsi)
        jmp     .BARS
.BARS:
        movl    %ecx, %eax
        # ifbatt.percent > 5) *display |= (1 << (24)); //battery level setting
        cmp     $5, %eax
        jle     .BAR2
        orl     $(1 << 24), (%rsi)
.BAR2:
        # ifbatt.percent > 29) *display |= (1 << (25));
        cmp     $29, %eax
        jle     .BAR3
        orl     $(1 << 25), (%rsi)
.BAR3:
        # ifbatt.percent > 49) *display |= (1 << (26));
        cmp     $49, %eax
        jle     .BAR4
        orl     $(1 << 26), (%rsi)
.BAR4:
        # ifbatt.percent > 69) *display |= (1 << (27));
        cmp     $69, %eax
        jle     .BAR5
        orl     $(1 << 27), (%rsi)
.BAR5:
        # ifbatt.percent > 89) *display |= (1 << (28));
        cmp     $89, %eax
        jle     .DONE
        orl     $(1 << 28), (%rsi)
.DONE:
        # pop and return
        movl    $0, %eax
        popq    %r13
        popq    %r12
        popq    %rbx
        ## DON'T FORGET TO RETURN FROM FUNCTIONS
        ret
.ERROR_DISPLAY:
        # pop and return
        movl    $1, %eax
        popq    %r13
        popq    %r12
        popq    %rbx
        ## DON'T FORGET TO RETURN FROM FUNCTIONS
        ret
.global batt_update
        
## ENTRY POINT FOR REQUIRED FUNCTION
batt_update:
        subq    $24,%rsp    # adjust the stack pointer to make space for local values AND align to a 16-byte boundary
        movl    $0, 0(%rsp)
        movq    %rbx, 8(%rsp)
        leaq    0(%rsp), %rdi
        movq    %rdi, %rbx 
        call    set_batt_from_ports   # stack aligned, call function return val from func in rax or eax
        cmpl    $0, %eax
        jne     .RETURN1
        movl    (%rbx), %edi
        leaq    BATT_DISPLAY_PORT(%rip), %rsi
        call    set_display_from_batt  # stack still aligned, call other function return val from func in rax or eax
        cmpl    $0, %eax
        jne     .RETURN1
        movl    $0, %eax
        jmp     .DONE_UP
.RETURN1:
        movl    $1, %eax
.DONE_UP:
        movq    8(%rsp), %rbx
        addq    $24,%rsp    # restore the stack pointer to its original value
	    ## assembly instructions here
        ret