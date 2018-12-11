library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--entity SC_CU is
--    port( Opcode    : in  std_logic_vector(5 downto 0);
--          Funct     : in  std_logic_vector(5 downto 0);
--          Zero      : in  std_logic;
--
--          RegDst    : out std_logic;
--          Branch    : out std_logic;
--          Jump      : out std_logic;
--          MemRead   : out std_logic;
--          MemtoReg  : out std_logic;
--          MemWrite  : out std_logic;
--          ALUControl: out std_logic_vector(2 downto 0);
--          ALUSrc    : out std_logic;
--          RegWrite  : out std_logic);
--end SC_CU;


architecture behavioral of SC_CU is	

begin

-- Differentiate between R Type Instruction
-- and I Type Instruction by looking at the Opcode?

main: process(Opcode, Funct, Zero)
variable test : std_logic_vector(2 downto 0) := "000";
--OPCODES TO BE USED FOR I TYPE-----------------------------
constant BNE : std_logic_vector(5 downto 0) 		:= "000101";
constant BEQ : std_logic_vector(5 downto 0) 		:= "000100";

--OPCODES TO BE USED FOR R TYPE-----------------------------
constant RTYPE: std_logic_vector(5 downto 0) 	:= "000000";


--FUCODES TO BE USED FOR R TYPE-----------------------------
constant IXORFUNCT: std_logic_vector(5 downto 0):= "100110";
constant SUBFUNCT: std_logic_vector(5 downto 0) := "100010";

--ALUControl Function Codes---------------------------------
constant ALUXOR : std_logic_vector(2 downto 0)	:= "110";
constant ALUSUB : std_logic_vector(2 downto 0)	:= "010";

begin

-- Equality when the zero flag is 1
	
case Opcode is
	when BNE =>
        RegDst      <= '0';             -- IMM, so rt needs to contain RegDst
        Branch      <= not Zero;        -- Only branch if unequal, aka Zero is 0
        Jump        <= '0';             -- Not jumping yet
        MemRead     <= '0';             -- Not reading from data memory yet
        MemtoReg    <= '0';             -- Not writing to reg yet  
        MemWrite    <= '0';             -- Not writing to memory yet
        ALUControl  <= ALUSUB;          -- Substract the values for Zero flag
        ALUSrc      <= '0';             -- rs and rt are the input for the ALU 
        RegWrite    <= '0'; 
	when BEQ =>
        RegDst      <= '0';             -- IMM, so rt needs to contain RegDst
        Branch      <= Zero;            -- Branch if equal, aka Zero is 1
        Jump        <= '0';             -- Not jumping yet 
        MemRead     <= '0'; 
        MemtoReg    <= '0'; 
        MemWrite    <= '0'; 
        ALUControl  <= ALUSUB;          -- Substract the values for the Zero flag
        ALUSrc      <= '0';             -- rs and rt are the input for the ALU
        RegWrite    <= '0'; 
	when RTYPE =>
        RegDst      <= '1';             -- R, so rd contains RegDst
        Branch      <= '0';             -- XOR contains no branch 
        Jump        <= '0';             -- XOR doesn't jump
        MemRead     <= '0'; 				 -- 
        MemtoReg    <= '0'; 
        MemWrite    <= '0'; 
		
			case Funct is
				when IXORFUNCT =>
					ALUControl <= ALUXOR;
				when SUBFUNCT =>
					ALUControl <= ALUSUB;
				when others =>
					test:="000";
					ALUControl <= "000";
			end case;
		 
        ALUSrc      <= '0';             -- Definitve rt and rs as values
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
