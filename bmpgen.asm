format ELF executable
entry start

segment readable writeable
;bmp header
header db $42,$4d
;size of the bmp file
       db $fa,$00,$00,$00
;unused
       db $00,$00
;unused
       db $00,$00
;offset where the pixel data can be found
       db $7a,$00,$00,$00
;dib header
       db $6c,$00,$00,$00
;width
       db $08,$00,$00,$00
;height
       db $08,$00,$00,$00
;planes
       db $01,$00
;bits per pixel
       db $20,$00
;compression
       db $00,$00,$00,$00
;size of the bitmap data (with padding)
       db $40,$00,$00,$00
;print resolution
       db $13,$0b,$00,$00
       db $13,$0b,$00,$00
;colors in the palette
       db $00,$00,$00,$00
;important colors
       db $00,$00,$00,$00
;red channel bit mask
       db $00,$00,$00,$00
;green channel mask
       db $00,$00,$00,$00
;blue channel mask
       db $00,$00,$00,$00
;alpha channel mask
       db $00,$00,$00,$00
;LCS_WINDOWS_COLOR_SPACE
       db $20,$6e,$69,$57
;color space endpoints
       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;red gamma
       db $00,$00,$00,$00
;green gamma
       db $00,$00,$00,$00
;blue gamma
       db $00,$00,$00,$00
header_s = $-header
;start of the bmp data
conten dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
       dd $00,$00,$00,$00
conten_s = $-conten

; *** Random Generator: linear congruential generator (LCG)
;randConst dd $00003039 ;ANSI C: Addition constant:   =      12345
;randMult  dd $41C64E6D ;ANSI C: Multiplicator:       = 1103515245
;randShift dd $00000000 ;ANSI C: No shift necessary
;randMask  dd $7FFFFFFF ;ANSI C: Take bits 0..30
;randValue dd $3C6EF35F ;Initial value & result container

fd_in rb 1
fd_out rb 1
name db 'bmpgen.bmp',$00
enterdata db "Enter your file data (256 bytes max): ",$00
enterdata_s = $-enterdata
done db "File generated successfully.",$0a,$00
done_s = $-done

segment readable executable
start:
;ask the user to fill the bmp with data
    push 4
    pop eax
    push 1
    pop ebx
    push enterdata
    pop ecx
    push enterdata_s
    pop edx
    int $80

    push 3
    pop eax
    xor ebx,ebx
    push conten
    pop ecx
    push conten_s
    pop edx
    int $80

;create the file
    push 8
    pop eax
    push name
    pop ebx
    push 777
    pop ecx
    int $80

    mov dword[fd_out],eax

;rndDoubleFunc:
;    push edx                 ;Save edx register
;    mov eax,[randValue]      ;Calculate
;    mov edx,[randMult]       ;R(n+1) :=
;    mul edx                  ;(R(n)*MULT + CONST)
;    add eax,[randConst]      ;MOD MASK
;    and eax,[randMask]       ;in CPU register and
;    mov dword[randValue],eax ;save back R(n+1)
;    pop edx                  ;Restore edx regsiter
;    fild dword[randValue]    ;Normalize
;    fidiv dword[randMask]    ;to ONE in FPU
;    ret                      ;Return

;seedDoubleFunc:
;    push edx                 ;Save edx register
;    rdtsc                    ;Get real time clock
;    and eax,[randMask]       ;and mask it and
;    mov dword[randValue],eax ;save back as R(n+1)
;    pop edx                  ;Restore edx regsiter
;    fild dword[randValue]    ;Normalize
;    fidiv dword[randMask]    ;to ONE in FPU
;    ret                      ;Return

;write stuff to the file
    push 4
    pop eax
    mov ebx,dword[fd_out]
    push header
    pop ecx
    push header_s
    pop edx
    int $80

    push 4
    pop eax
    mov ebx,dword[fd_out]
    push conten
    pop ecx
    push conten_s
    pop edx
    int $80

;close it
    push 6
    pop eax
    mov ebx,dword[fd_out]

;warn the user that the file was created
    push 4
    pop eax
    push 1
    pop ebx
    push done
    pop ecx
    push done_s
    pop edx
    int $80

;quit
    push 1
    pop eax
    xor ebx,ebx
    int $80
