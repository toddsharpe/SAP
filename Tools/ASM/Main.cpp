#include <SAP1.h>
#include <iostream>
#include <string>
#include <fstream>

using namespace std;
using namespace SAP1;

#define Assert(c) if (!(c)) __debugbreak()

void ParseFile(const std::string& asm_file, Program& program);
void WriteProgram(const std::string & bin_file, Program& program);
void WriteMem(const std::string & mem_file, Program& program);

int main(int argc, char** argv)
{
	if (argc < 3)
	{
		std::cout << "Usage: asm.exe asm_file out_bin [out_mem]" << std::endl;
		return -1;
	}

	Program program;
	ParseFile(std::string(argv[1]), program);
	WriteProgram(argv[2], program);

	if (argc >= 4)
	{
		WriteMem(argv[3], program);
	}

	return 0;
}

void ParseFile(const std::string& asm_file, Program& program)
{
	std::ifstream file(asm_file);
	Assert(file.is_open());

	std::string op;
	size_t address = 0;
	while (file >> op)
	{
		if (op[0] == '#')
		{
			//Ignore line
			std::getline(file, op);
			continue;
		}

		Instruction instruction;
		
		//Look up opcode
		const auto& it = ParseTable.find(op);
		if (it == ParseTable.end())
		{
			uint8_t data = stoi(op);
			instruction.Opcode = Opcodes::DATA;
			instruction.Arg = data;
		}
		else
		{
			instruction.Opcode = it->second;
			switch (instruction.Opcode)
			{
			case Opcodes::LDA:
			case Opcodes::ADD:
			case Opcodes::SUB:
			case Opcodes::STA:
			case Opcodes::JMP:
			case Opcodes::JC:
			case Opcodes::JZ:
			{
				// Operations with memory operands
				file >> op;

				uint32_t address;
				sscanf_s(op.c_str(), "[0x%x]", &address);
				instruction.Arg = (uint8_t)address;
			}
			break;

			case Opcodes::LDI:
			{
				// Operations with memory operands
				file >> op;

				uint32_t imm;
				sscanf_s(op.c_str(), "0x%x", &imm);
				instruction.Arg = (uint8_t)imm;
			}
			break;

			case Opcodes::NOP:
			case Opcodes::OUT:
			case Opcodes::HLT:
				//Operations with no operands
				break;
			}
		}

		program.Instructions[address] = instruction;
		address++;
	}
}

void WriteProgram(const std::string& bin_file, Program& program)
{
	ofstream fout;
	fout.open(bin_file, ios::binary | ios::out);
	for (const Instruction& instruction : program.Instructions)
	{
		switch (instruction.Opcode)
		{
		case Opcodes::DATA:
			fout << instruction.Arg;
			break;

		default:
			//Opcode is upper 4 bits
			//Arg is lower 4 bits
			uint8_t value = (instruction.Opcode << 4) | instruction.Arg;
			fout << value;
			break;
		}
	}
}

void WriteMem(const std::string& mem_file, Program& program)
{
	ofstream fout(mem_file);
	for (const Instruction& instruction : program.Instructions)
	{
		switch (instruction.Opcode)
		{
		case Opcodes::DATA:
			fout << std::hex << (int)instruction.Arg << std::endl;
			break;

		default:
			//Opcode is upper 4 bits
			//Arg is lower 4 bits
			uint8_t value = (instruction.Opcode << 4) | instruction.Arg;
			fout << std::hex << (int)value << std::endl;
			break;
		}
	}
}