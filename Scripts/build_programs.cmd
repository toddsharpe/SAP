@set PATH=%PATH%;build\x64\Debug\

if not exist "build\programs" mkdir build\programs

ASM.exe programs\add.asm build\programs\add.bin build\fpga\add.mem
ASM.exe programs\fib.asm build\programs\fib.bin build\fpga\fib.mem
