library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity MC_CU_tb is
  -- port () ;
end MC_CU_tb;

architecture behavior of MC_CU_tb is

    component MC_CU is port(
        CLK         : in   std_logic;
		Opcode      : in   std_logic_vector(6-1 downto 0);
		Funct       : in   std_logic_vector(6-1 downto 0);
		Zero        : in   std_logic;
		IRWrite     : out  std_logic;
		MemWrite    : out  std_logic;
		IorD        : out  std_logic;
		PCWrite     : out  std_logic;
		PCSrc       : out  std_logic_vector(2-1 downto 0);
		ALUControl  : out  std_logic_vector(3-1 downto 0);
		ALUSrcB     : out  std_logic_vector(2-1 downto 0);
		ALUSrcA     : out  std_logic;
		RegWrite    : out  std_logic;
		MemtoReg    : out  std_logic;
		RegDst      : out  std_logic
    );
    end component;

    signal CLK      : std_logic;
    signal Opcode   : std_logic_vector(6-1 downto 0);
    signal Funct    : std_logic_vector(6-1 downto 0);
    signal Zero     : std_logic;
    signal IRWrite  : std_logic;
    signal MemWrite : std_logic;
    signal IorD     : std_logic;
    signal PCWrite  : std_logic;
    signal PCSrc    : std_logic_vector(2-1 downto 0);
    signal ALUControl   : std_logic_vector(3-1 downto 0);
    signal ALUSrcB  : std_logic_vector(2-1 downto 0);
    signal ALUSrcA  : std_logic;
    signal RegWrite : std_logic;
    signal MemtoReg : std_logic;
    signal RegDst   : std_logic;

    signal SIMEND : std_logic := '0';
    constant PERIOD : time := 20 ns;


    constant OP_ALU   : std_logic_vector(5 downto 0) := "000000";
    constant OP_BNE   : std_logic_vector(5 downto 0) := "000101";

begin

UUT : MC_CU port map(
    CLK => CLK,
    Opcode => Opcode,
    Funct => Funct,
    Zero => Zero,
    IRWrite => IRWrite,
    MemWrite => MemWrite,
    IorD => IorD,
    PCWrite => PCWrite,
    PCSrc => PCSrc,
    ALUControl => ALUControl,
    ALUSrcB => ALUSrcB,
    ALUSrcA => ALUSrcA,
    RegWrite => RegWrite,
    MemtoReg => MemtoReg,
    RegDst => RegDst
);

clkgen : process
begin
    if SIMEND = '0' then
        CLK <= '0';
        wait for PERIOD/2;
        CLK <= '1';
        wait for PERIOD/2;
    else
        wait;
    end if;
end process ; -- clkgen

stimuli : process
begin
    wait for PERIOD/4;
    Zero <= 'X';
    Funct <= "XXXXXX";
    Opcode <= "XXXXXX";

    -- IDLE
    wait for PERIOD;
    -- FETCH
    Opcode <= OP_BNE; -- BRANCH NOT EQUALS
    Funct <= "XXXXXX";
    Zero <= '1';
    wait for PERIOD;
    -- DECODE
    Zero <= '1', '0' AFTER 4 ns;
    
    wait for PERIOD;
    -- EXECUTE
    wait for PERIOD;
    wait for PERIOD;


    SIMEND <= '1';
    wait;

end process ; -- stimuli


end behavior ; -- behavior