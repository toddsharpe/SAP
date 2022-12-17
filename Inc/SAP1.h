#pragma once

#include <cstdint>
#include <map>
#include <string>

namespace SAP1
{
	enum Opcodes : uint8_t
	{
		NOP = 0b0000,
		LDA = 0b0001,
		ADD = 0b0010,
		SUB = 0b0011,
		STA = 0b0100,
		LDI = 0b0101,
		JMP = 0b0110,
		JC  = 0b0111,
		JZ  = 0b1000,
		OUT = 0b1110,
		HLT = 0b1111,

		//Pseudo op code
		DATA = 0xFF
	};

	static std::map<std::string, Opcodes> ParseTable =
	{
		{ "NOP", Opcodes::NOP },
		{ "LDA", Opcodes::LDA },
		{ "ADD", Opcodes::ADD },
		{ "SUB", Opcodes::SUB },
		{ "STA", Opcodes::STA },
		{ "LDI", Opcodes::LDI },
		{ "JMP", Opcodes::JMP },
		{ "JC",  Opcodes::JC },
		{ "JZ",  Opcodes::JZ },
		{ "OUT", Opcodes::OUT },
		{ "HLT", Opcodes::HLT },
	};

	struct Instruction
	{
		Instruction() : Opcode(), Arg()
		{}
		
		Opcodes Opcode;
		uint8_t Arg;
	};

	static constexpr size_t RamSize = 16;

	struct Program
	{
		Instruction Instructions[RamSize];
	};
}
;