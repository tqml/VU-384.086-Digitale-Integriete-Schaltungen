library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--	port(
--		CLK         : in   std_logic;
--		Opcode      : in   std_logic_vector(6-1 downto 0);
--		Funct       : in   std_logic_vector(6-1 downto 0);
--		Zero        : in   std_logic;
--		IRWrite     : out  std_logic;
--		MemWrite    : out  std_logic;
--		IorD        : out  std_logic;
--		PCWrite     : out  std_logic;
--		PCSrc       : out  std_logic_vector(2-1 downto 0);
--		ALUControl  : out  std_logic_vector(3-1 downto 0);
--		ALUSrcB     : out  std_logic_vector(2-1 downto 0);
--		ALUSrcA     : out  std_logic;
--		RegWrite    : out  std_logic;
--		MemtoReg    : out  std_logic;
--		RegDst      : out  std_logic
--	);


-- Fetch --> Decode --> Execute --> Write
architecture behavior of MC_CU is
type state_t is (fetch, decode, execute, idle, stall);
signal state: state_t := idle;


begin


-- Statemachine. With every Rising edge proceed one stage
stateProcess: process(CLK)
begin
    if rising_edge(CLK) then
        case state is
            when fetch =>
                state <= decode;
            when decode =>
                state <= execute;
            when execute =>
                state <= stall; --Delay to let exec finish
            when idle => 
                state <= fetch;
            when stall =>
                state <= fetch;
        end case;
    end if;
end process;

main: process(CLK, state, Opcode) 

constant RTYPE   : std_logic_vector(5 downto 0) := "000000";
constant OPT_OR  : std_logic_vector(5 downto 0) := "000000";
constant OPT_NOR : std_logic_vector(5 downto 0) := "000000";

constant FUNCT_OR  : std_logic_vector(5 downto 0) := "100101";
constant FUNCT_NOR : std_logic_vector(5 downto 0) := "100111";

constant ALU_NOR : std_logic_vector(2 downto 0) := "111";
constant ALU_OR  : std_logic_vector(2 downto 0) := "101";
constant ALU_ADD : std_logic_vector(2 downto 0) := "000";

variable controlVector : std_logic_vector(14 downto 0);
variable operation : std_logic;
variable CurState   : std_logic_vector(3 downto 0);

begin
--Single Cycle Implementation would look like this.
--But now we need Fetch, Decode, Execute all in place.
--And where is the fetch part anyways?
--Probably set IRWrite to 1, to get Data from Instr/DataMemory??
--Fetching takes one cycle, decoding takes one cycle.
--Fetch Instruction value by setting IRWrite to 1 ~ First Cycle.
--Decode in the next ~ Second Cycle.
--But in the Second Cycle, already do a Fetch in the first one already?!!!
--RegDst must be one for my operations as I want to write to rd
--Data / Instruction Memory contains our instructions, if we set IorD we decide
--whether teh data memory input address comes from the program counter register 
--or from the ALU Result register. So it is basically for immediate ALU
--instructions. But do I ever do an immediate jump? With my current given 
--ooperations I always will increase by 4 and never do any
-- non constant jumps in my instruction memory.sudo 

case state is
    when idle =>
        controlVector := "000000000000000";
    when fetch =>
        -- Set IRWrite to 1 to get instruction
        -- Set ALUSrcB to 01 to increase program counter by 4
        -- Set ALUSrcA to 0 to get value from PC
        -- Set PCSrc to 00 (async) or 01 (synced)
        -- Set PCWrite to 1 to write the new async PC value to memory
		  -- Set IorD to 0 to set correct new PC value
        -- Set ALUControl to 000 for adding PC
        -- Set Regwrite to 0, because we don't want to set those registers
        -- Set MemToReg to 0 as we don't want to write anything to registers
        -- Set to 0 as we don't want to write anything to registers
        controlVector := "100100000010000"; 
    when decode =>
        if Opcode = RTYPE then
            operation := '1';
        else
            operation := '0';
        end if;
		   controlVector := "000000000000000"; 
    when execute =>
        -- load rs and rt into ALU, send ALU Control Signal
        -- Set IRWrite to 0 as we don't need an instruction
        -- Set MemWrite to 0 as we don't want to write to memory
        -- Set IorD to 0 as we don't want to write to memory
        -- Set PCWrite to 0 as we don't want to write the PC
        -- Set PCSrc to  as we don't want to do stuff with PC
        -- Set ALUControl to Operation
        -- Set ALUSrcB to 00 as we want to use register data 2 src
        -- Set ALUSrcA to 1 as we want to use register data 1 src
        -- Set RegWrite to 0 as we don't yet want to write the result
        -- Set MemtoReg to 0 as we don't yet want to write the result
        -- Set RegDst to 0 as we don't yet want to write the result
        controlVector := "000000000001000";
        if operation = '1' then
            case Funct is
                when FUNCT_OR =>
                    controlVector := controlVector or ("000000" & ALU_OR & "000000");        
                when FUNCT_NOR =>
                    controlVector := controlVector or ("000000" & ALU_NOR & "000000");        
                when others => 
                    null;
				end case;
        end if;
    when stall =>
        -- save alu result into register specified by rd 
        -- Set RegWrite to 1 as we want to write the result from execute
        -- Set MemtoReg to 0 as we want to write the ALU Result
        -- Set RegDst to 1 as we want to write to rd register (15-11)
        controlVector := "000000000000101";
    when others =>
        controlVector := "000000000000000";
end case;

--Assign all registers.
IRWrite    <= controlVector(14);
MemWrite   <= controlVector(13);
IorD       <= controlVector(12);
PCWrite    <= controlVector(11);
PCSrc      <= controlVector(10 downto 9);
ALUControl <= controlVector(8 downto 6);
ALUSrcB    <= controlVector(5 downto 4);
ALUSrcA    <= controlVector(3);
RegWrite   <= controlVector(2);
Memtoreg   <= controlVector(1);
RegDst     <= controlVector(0);

end process;
end behavior;
