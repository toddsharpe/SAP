@set PATH=%PATH%;build\x64\Debug\

if not exist "build\fpga" mkdir build\fpga

UCode.exe build\fpga\ucode.mem
