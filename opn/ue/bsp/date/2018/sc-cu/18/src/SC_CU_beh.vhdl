library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture behavioral of SC_CU is	

constant FUNCT_SLT : std_logic_vector(5 downto 0) := "101010";
constant FUNCT_AND : std_logic_vector(5 downto 0) := "100100";
-- Instructions
constant OPCODE_SW : std_logic_vector(5 downto 0) := "101011";
constant OPCODE_AND_SLT : std_logic_vector(5 downto 0) := "000000";
constant OPCODE_J : std_logic_vector(5 downto 0) := "000010";

-- ALU instructions
constant ALU_ADD : std_logic_vector(2 downto 0) := "000";
constant ALU_SLT : std_logic_vector(2 downto 0) := "001";
constant ALU_AND : std_logic_vector(2 downto 0) := "100";

-- Write register input MUX
constant RegDst_15to11 : std_logic := '1';		-- from bits 15 - 11 of the instruction
constant RegDst_20to16 : std_logic := '0';		-- from bits 20 - 16 of the instruction

-- ALU source A input MUX
constant BRANCH_SL2 : std_logic := '1';
constant BRANCH_Normal : std_logic := '0';

constant JUMP_Addr : std_logic := '1';
constant JUMP_ALU : std_logic := '0';

-- ALU source B input MUX
constant ALUSrc_RD2 : std_logic := '0';
constant ALUSrc_IMM : std_logic := '1';

-- Write data input MUX
constant MemtoReg_DataMem : std_logic := '1';	-- from data memory
constant MemtoReg_ALU : std_logic := '0';		-- from ALU result register


signal cycle : integer := 0;

begin

PROCESS_CU : process(Opcode, Funct)

begin

case Opcode is
	-- OPCODE_SLT and OPCODE_AND are the same!
	when OPCODE_AND_SLT =>
		case Funct is
			when FUNCT_AND =>
				RegDst <= RegDst_15to11;
				ALUSrc <= ALUSrc_RD2;
				ALUControl <= ALU_AND;
				MemtoReg <= MemtoReg_ALU;
				RegWrite <= '1';
				
				Jump <= JUMP_ALU;
				MemWrite <= '0';
				
			when FUNCT_SLT =>
				ALUSrc <= ALUSrc_RD2;
				ALUControl <= ALU_SLT;
				MemtoReg <= MemtoReg_ALU;
				RegWrite <= '1';
				RegDst <= RegDst_15to11;
				
				Jump <= JUMP_ALU;
				MemWrite <= '0';
				
			when others => null;
		end case;
		
	when OPCODE_SW =>
		
		ALUSrc <= ALUSrc_IMM;
		MemWrite <= '1';
		ALUControl <= ALU_ADD;
		
		Jump <= JUMP_ALU;
		RegWrite <= '0';
		

	when OPCODE_J =>
		Jump <= JUMP_Addr;
		
		RegWrite <= '0';
		MemWrite <= '0';
	when others => null;
end case;
		
Branch <= BRANCH_Normal;
MemRead <= '0';
	
end process PROCESS_CU;

end behavioral;
