--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:48:06 12/20/2017
-- Design Name:   
-- Module Name:   /home/consti/gitclones/Digital_Integrierte_Schaltungen/Task8/tbh/mc_cu.vhd
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
 
ENTITY mc_cu IS
END mc_cu;
 
ARCHITECTURE behavior OF mc_cu IS 
 
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
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
