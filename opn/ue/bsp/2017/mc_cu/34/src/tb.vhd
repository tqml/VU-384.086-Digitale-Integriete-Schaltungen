--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:50:34 12/20/2017
-- Design Name:   
-- Module Name:   /home/consti/gitclones/Digital_Integrierte_Schaltungen/Task8/tbh/tb.vhd
-- Project Name:  Task8
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MC_CU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MC_CU
    PORT(
         CLK : IN  std_logic;
         Opcode : IN  std_logic_vector(5 downto 0);
         Funct : IN  std_logic_vector(5 downto 0);
         Zero : IN  std_logic;
         IRWrite : OUT  std_logic;
         MemWrite : OUT  std_logic;
         IorD : OUT  std_logic;
         PCWrite : OUT  std_logic;
         PCSrc : OUT  std_logic_vector(1 downto 0);
         ALUControl : OUT  std_logic_vector(2 downto 0);
         ALUSrcB : OUT  std_logic_vector(1 downto 0);
         ALUSrcA : OUT  std_logic;
         RegWrite : OUT  std_logic;
         MemtoReg : OUT  std_logic;
         RegDst : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Opcode : std_logic_vector(5 downto 0) := (others => '0');
   signal Funct : std_logic_vector(5 downto 0) := (others => '0');
   signal Zero : std_logic := '0';

 	--Outputs
   signal IRWrite : std_logic;
   signal MemWrite : std_logic;
   signal IorD : std_logic;
   signal PCWrite : std_logic;
   signal PCSrc : std_logic_vector(1 downto 0);
   signal ALUControl : std_logic_vector(2 downto 0);
   signal ALUSrcB : std_logic_vector(1 downto 0);
   signal ALUSrcA : std_logic;
   signal RegWrite : std_logic;
   signal MemtoReg : std_logic;
   signal RegDst : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	
	type state_t is (fetch, decode, execute, idle, stall);
	signal state: state_t := idle;
	signal next_state: state_t := fetch;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MC_CU PORT MAP (
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

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
		
	begin		
      -- hold reset state for 100 ns.
      
		--wait until CLK = '1';
		state <= next_state;
		
		Funct <= "100101";	-- OR Operation
		
		-- Fetch Cycle
		wait until CLK = '1';
		if state = fetch then
			wait for 1ps;
			assert IRWrite = '1' report "Fetch Cycle: IRWrite is 0, should be 1" severity error;
			assert MemWrite = '0' report "Fetch Cycle: MemWrite is 1, should be 0" severity error;
			assert IorD = '0' report "Fetch Cycle: IorD is 1, should be 0" severity error;
			assert PCWrite = '1' report "Fetch Cycle: PCWrite is 0, should be 1" severity error;
			assert PCSrc = "00" report "Fetch Cycle: PCSrc is not 00" severity error;
			assert ALUControl = "000" report "Fetch Cycle: ALUControl is not 00" severity error;
			assert ALUSrcB = "01" report "Fetch Cycle: ALUSrcB is not 01" severity error;
			assert ALUSrcA = '0' report "Fetch Cycle: ALUSrcA is not 0" severity error;
			assert RegWrite = '0' report "Fetch Cycle: RegWrite is not 0" severity error;
			assert MemtoReg = '0' report "Fetch Cycle: MemtoReg is not 0" severity error;
			assert RegDst = '0' report "Fetch Cycle: RegDst is not 0" severity error;
			state <= decode;
		end if;
		
		--Decode Cycle
		wait until CLK = '1';
		if state = decode then
			wait for 1ps;
			--Nothing really happens here
			assert IRWrite = '0' report "Decode Cycle: IRWrite is 1, should be 0" severity error;
			assert MemWrite = '0' report "Decode Cycle: MemWrite is 1, should be 0" severity error;
			assert IorD = '0' report "Decode Cycle: IorD is 1, should be 0" severity error;
			assert PCWrite = '0' report "Decode Cycle: PCWrite is 0, should be 1" severity error;
			assert PCSrc = "00" report "Decode Cycle: PCSrc is not 00" severity error;
			assert ALUControl = "000" report "Decode Cycle: ALUControl is not 00" severity error;
			assert ALUSrcB = "00" report "Decode Cycle: ALUSrcB is not 01" severity error;
			assert ALUSrcA = '0' report "Decode Cycle: ALUSrcA is not 0" severity error;
			assert RegWrite = '0' report "Decode Cycle: RegWrite is not 0" severity error;
			assert MemtoReg = '0' report "Decode Cycle: MemtoReg is not 0" severity error;
			assert RegDst = '0' report "Decode Cycle: RegDst is not 0" severity error;
			state <= execute;
		end if;
		
		--Execute Cycle
		wait until CLK = '1';
		if state = execute then
			wait for 1ps;
			assert IRWrite = '0'      report "Execute Cycle: IRWrite is 0, should be 1" severity error;
			assert MemWrite = '0'     report "Execute Cycle: MemWrite is 1, should be 0" severity error;
			assert IorD = '0'         report "Execute Cycle: IorD is 1, should be 0" severity error;
			assert PCWrite = '0'      report "Execute Cycle: PCWrite is 0, should be 1" severity error;
			assert PCSrc = "00"       report "Execute Cycle: PCSrc is not 00" severity error;
			assert ALUControl = "101" report "Execute Cycle: ALUControl is not 101" severity error;
			assert ALUSrcB = "00"     report "Execute Cycle: ALUSrcB is not 00" severity error;
			assert ALUSrcA = '1'      report "Execute Cycle: ALUSrcA is not 1" severity error;
			assert RegWrite = '0'     report "Execute Cycle: RegWrite is not 0" severity error;
			assert MemtoReg = '0'     report "Execute Cycle: MemtoReg is not 0" severity error;
			assert RegDst = '0'       report "Execute Cycle: RegDst is not 0" severity error;
			state <= stall;
		end if;
		
		--Stall Cycle
		wait until CLK = '1';
		if state = stall then
			wait for 1ps;
			assert IRWrite = '0'      report "Stall Cycle: IRWrite is not 0" severity error;
			assert MemWrite = '0'     report "Stall Cycle: MemWrite is is not 0" severity error;
			assert IorD = '0'         report "Stall Cycle: IorD is is not 0" severity error;
			assert PCWrite = '0'      report "Stall Cycle: PCWrite is not 0" severity error;
			assert PCSrc = "00"       report "Stall Cycle: PCSrc is not 00" severity error;
			assert ALUControl = "000" report "Stall Cycle: ALUControl is not 00" severity error;
			assert ALUSrcB = "00"     report "Stall Cycle: ALUSrcB is not 01" severity error;
			assert ALUSrcA = '0'      report "Stall Cycle: ALUSrcA is not 0" severity error;
			assert RegWrite = '1'     report "Stall Cycle: RegWrite is not 1" severity error;
			assert MemtoReg = '0'     report "Stall Cycle: MemtoReg is not 0" severity error;
			assert RegDst = '1'       report "Stall Cycle: RegDst is not 1" severity error;
			state <= fetch;
		end if;
		
      -- insert stimulus here 

      wait;
   end process;

END;
