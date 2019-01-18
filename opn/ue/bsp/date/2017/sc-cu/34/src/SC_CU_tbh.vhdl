--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:46:34 12/04/2017
-- Design Name:   
-- Module Name:   /home/consti/gitclones/Digital_Integrierte_Schaltungen/Task7/tbh/SC_CU_tbh.vhdl
-- Project Name:  Task7
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SC_CU
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
 
ENTITY SC_CU_tbh IS
END SC_CU_tbh;
 
ARCHITECTURE behavior OF SC_CU_tbh IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SC_CU
    PORT(
         Opcode : IN  std_logic_vector(5 downto 0);
         Funct : IN  std_logic_vector(5 downto 0);
         Zero : IN  std_logic;
         RegDst : OUT  std_logic;
         Branch : OUT  std_logic;
         Jump : OUT  std_logic;
         MemRead : OUT  std_logic;
         MemtoReg : OUT  std_logic;
         MemWrite : OUT  std_logic;
         ALUControl : OUT  std_logic_vector(2 downto 0);
         ALUSrc : OUT  std_logic;
         RegWrite : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Opcode : std_logic_vector(5 downto 0) := (others => '0');
   signal Funct : std_logic_vector(5 downto 0) := (others => '0');
   signal Zero : std_logic := '0';

 	--Outputs
   signal RegDst : std_logic;
   signal Branch : std_logic;
   signal Jump : std_logic;
   signal MemRead : std_logic;
   signal MemtoReg : std_logic;
   signal MemWrite : std_logic;
   signal ALUControl : std_logic_vector(2 downto 0);
   signal ALUSrc : std_logic;
   signal RegWrite : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SC_CU PORT MAP (
          Opcode => Opcode,
          Funct => Funct,
          Zero => Zero,
          RegDst => RegDst,
          Branch => Branch,
          Jump => Jump,
          MemRead => MemRead,
          MemtoReg => MemtoReg,
          MemWrite => MemWrite,
          ALUControl => ALUControl,
          ALUSrc => ALUSrc,
          RegWrite => RegWrite
        );

   

   -- Stimulus process
   stim_proc: process
   begin		
		--XOR
		Opcode <= "000000";
		Funct <= "100110";
		Zero <= '0';
		wait for 1ps;
		assert ALUControl = "110" report "XOR Wrong control";
		wait for 10ns;
		Opcode <= "000000";
		Funct <= "100010";
		Zero <= '0';
		wait for 10ns;
		Opcode <= "000101";
		Funct <=  "000000";
		Zero <= '1';
		wait for 100ns;
   end process;

END;
