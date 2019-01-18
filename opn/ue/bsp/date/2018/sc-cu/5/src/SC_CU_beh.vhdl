library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture behavioral of SC_CU is	

begin
main: process(Opcode, Funct, Zero)


constant LW : std_logic_vector(5 downto 0) 		:= "100011";


constant RTYPE: std_logic_vector(5 downto 0) 	:= "000000";

constant IXORFUNCT: std_logic_vector(5 downto 0):= "100110";
constant SUBFUNCT: std_logic_vector(5 downto 0) := "100010";
constant ORFUNCT: std_logic_vector(5 downto 0):="100101";
constant NORFUNCT: std_logic_vector(5 downto 0) :="100111";

constant ALUADD : std_logic_vector(2 downto 0)	:= "000";
constant ALUSUB : std_logic_vector(2 downto 0)	:= "010";
constant ALUOR  : std_logic_vector(2 downto 0)  := "101";
constant ALUNOR : std_logic_vector(2 downto 0)  := "111";

begin

case Opcode is
	when LW =>                        --lw
        RegDst      <= '0';            
        Branch      <= '0';       
        Jump        <= '0';            
        MemRead     <= '1';             
        MemtoReg    <= '1';             
        MemWrite    <= '0';             
        ALUControl  <= ALUADD;          
        ALUSrc      <= '1';             
        RegWrite    <= '1'; 
	when RTYPE =>
        RegDst      <= '1';             
        Branch      <= '0';             
        Jump        <= '0';             
        MemRead     <= '0';
        MemtoReg    <= '0'; 
        MemWrite    <= '0';
			case Funct is
				when NORFUNCT =>
					ALUControl <= ALUNOR;
				when ORFUNCT =>
					ALUControl <= ALUOR;
                when SUBFUNCT =>
                    ALUControl <= ALUSUB;
				when others =>
					ALUControl <= "000";
			end case;
		 
        ALUSrc      <= '0';           
        RegWrite    <= '1'; 
	when others =>
        RegDst      <= '0';
        Branch      <= '0';    
        Jump        <= '0';   
        MemRead     <= '0'; 
        MemtoReg    <= '0'; 
        MemWrite    <= '0'; 
        ALUControl  <= "000";
        ALUSrc      <= '0'; 
        RegWrite    <= '0'; 
end case;
end process;
end behavioral;
