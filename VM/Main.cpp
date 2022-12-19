#include <SAP1.h>

#include <iostream>
#include <fstream>
#include <vector>

using namespace std;
using namespace SAP1;

#define Assert(c) if (!(c)) __debugbreak()

int main(int argc, char** argv)
{
	std::cout << "SAP1 Virtual Machine" << std::endl;

	if (argc != 2)
	{
		std::cout << "Usage: VM.exe out_bin" << std::endl;
		return -1;
	}

	//Read bin
	ifstream bin(argv[1], std::ios_base::binary);
	Assert(bin.is_open());

	//Get length of file
	bin.seekg(0, std::ios::end);
	size_t length = bin.tellg();

	//Read file to byte array
	uint8_t* memory = new uint8_t[length];
	bin.seekg(0, std::ios::beg);
	bin.read((char*)memory, length);

	//Machine model
	uint8_t PC = 0;
	uint8_t A = 0;
	uint8_t B = 0;
	uint8_t IR = 0;// Instruction reg?
	uint8_t CF = 0;
	uint8_t ZF = 0;
	uint8_t OUT = 0;
	bool running = true;

	std::cout << "Out: " << std::endl;
	while (running)
	{
		uint8_t byte = memory[PC];

		uint8_t op = byte >> 4;
		uint8_t arg = byte & 0x0F;

		switch ((Opcodes)op)
		{
		case Opcodes::NOP:
			break;

		case Opcodes::LDA:
			A = memory[arg];
			break;

		case Opcodes::ADD:
			CF = (uint16_t(A) + uint16_t(memory[arg])) > 255;

			B = memory[arg];
			A += B;

			ZF = A == 0;
			break;

		case Opcodes::SUB:
			CF = (uint16_t(A) - uint16_t(memory[arg])) > 255;

			B = memory[arg];
			A -= B;

			ZF = A == 0;
			break;

		case Opcodes::STA:
			memory[arg] = A;
			break;

		case Opcodes::LDI:
			A = arg;
			break;

		case Opcodes::JMP:
			PC = arg - 1; //Compensate for increment below
			break;

		case Opcodes::JC:
			if (CF)
			{
				PC = arg - 1;
			}
			break;

		case Opcodes::JZ:
			if (ZF)
			{
				PC = arg - 1;
			}
			break;

		case Opcodes::OUT:
			OUT = A;
			std::cout << std::hex << "0x" << (int)OUT << "\n";
			break;

		case Opcodes::HLT:
			running = false;
			break;

		default:
			Assert(false);
		}

		PC++;
	}
	std::cout << std::endl;

	std::cout << "Machine State:" << std::endl;
	std::cout << "PC 0x" << std::hex << (int)PC << std::endl;
	std::cout << "A 0x" << std::hex << (int)A << std::endl;
	std::cout << "B 0x" << std::hex << (int)B << std::endl;
	std::cout << "CF "<< (int)CF << std::endl;
	std::cout << "ZF " << (int)ZF << std::endl;
	std::cout << "OUT 0x" << std::hex << (int)OUT << std::endl;
	std::cout << std::endl << "Done!" << std::endl;
}
