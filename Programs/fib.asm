LDI 0x1
STA [0xE]
LDI 0x0
STA [0xF]
OUT
LDA [0xE]
ADD [0xF]
STA [0xE]
OUT
LDA [0xF]
ADD [0xE]
JC [0xD]
JMP [0x3]
HLT
0
1
# https://github.com/stackbuffer/TinyE8/blob/main/programs/fib.asm