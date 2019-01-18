--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:39:12 10/18/2017
-- Design Name:   
-- Module Name:   /home/consti/gitclones/Digital_Integrierte_Schaltungen/Task5/tbh/testbench.vhd
-- Project Name:  Task5
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY testbench IS
END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         Clk : IN  std_logic;
         enable : IN  std_logic;
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         slc : IN  std_logic_vector(1 downto 0);
         R : OUT  std_logic_vector(3 downto 0);
         flag : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal enable : std_logic := '0';
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(3 downto 0) := (others => '0');
   signal slc : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal R : std_logic_vector(3 downto 0);
   signal flag : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          Clk => Clk,
          enable => enable,
          A => A,
          B => B,
          slc => slc,
          R => R,
          flag => flag
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		--at 42 ns: Error: Error for ADD instruction: A=0000, B=0001; expected R=0001, expected flag='0', received R=0000, received flag='0'
		A <= "0000";
		B <= "0001";
		slc <= "00";
		enable <= '1';
		wait until Clk = '1';
		wait for 1ps;
		assert R = "0001" report "Error for ADD instruction: A=0000, B=0001; expected R=0001, expected flag='0', received R=0000, received flag='0'";
		assert flag = '0' report "Error for ADD instruction: A=0000, B=0001; expected R=0001, expected flag='0', received R=0000, received flag='0'";
		enable <= '0';
		wait for Clk_period*2;
		
      -- Addition without Overflow Flag 
   	A <= "0001";
      B <= "1010";
		slc <= "00";
      enable <= '1';
      wait until Clk = '1'; 
      wait for 1ps;
      assert R = "1011" report "R: Addition without overflow failed";
      assert flag = '0' report "flag: Addition without overflow failed";
		enable <= '0';
      wait for Clk_period*2;

      -- Adition with Overflow Flag
      A <= "1111";
      B <= "0001";
		slc <= "00";
      enable <= '1';
      wait until Clk = '1';
      wait for 1ps;
      assert R = "0000" report "R: Addition with overflow failed";
      assert flag = '1' report "flag: Addition with overflow failed";
		enable <= '0';
      wait for Clk_period*2;

      -- XOR with Odd Parity 0
      A <= "1010";
      B <= "0101";
		slc <= "01";
      enable <= '1';
      wait until Clk = '1';
      wait for 1ps;
      assert R = "1111" report "R: XOR without Odd Parity failed";
      assert flag = '1' report "flag: XOR without Odd Parity failed";
      enable <= '0';
		wait for Clk_period*2;
		
      -- XOR with Odd Parity 1
      A <= "1100";
      B <= "1101";
		slc <= "01";
      enable <= '1';
      wait until Clk = '1';
      wait for 1ps;
      assert R = "0001" report "R: XOR with Odd Parity failed";
      assert flag = '0' report "flag: XOR with Odd Parity failed";
      enable <= '0';
		wait for Clk_period*2;
      
      -- OR with Odd Parity 0
      A <= "1010";
      B <= "0101";
		slc <= "10";
      enable <= '1';
      wait until Clk = '1';
      wait for 1ps;
      assert R = "1111" report "R: OR without Odd Parity failed";
      assert flag = '1' report "flag: OR without Odd Parity failed";
		enable <= '0';
      wait for Clk_period*2;
      
      -- OR with Odd Parity 1
      A <= "1100";
      B <= "1101";
		slc <= "10";
      enable <= '1';
      wait until Clk = '1';
      wait for 1ps;
      assert R = "1101" report "R: OR with Odd Parity failed";
      assert flag = '0' report "flag: OR with Odd Parity failed";
		enable <= '0';
      wait for Clk_period*2;
      
		--at 10733ns: Error: Error for OR instruction: A=0000, B=0000; expected R=0000, expected flag='1', received R=0000, received flag='0'
		A <= "0000";
		B <= "0000";
		slc <= "10";
		enable <= '1';
		wait until Clk = '1';
		wait for 1ps;
		assert R = "0000" report "Error for OR instruction: A=0000, B=0000; expected R=0000, expected flag='1', received R=0000, received flag='0'";
		assert flag = '1' report "Error for OR instruction: A=0000, B=0000; expected R=0000, expected flag='1', received R=0000, received flag='0'";
		enable <= '0';
		wait for Clk_period*2;
		
      -- Shift Left with MSB 0
      A <= "0111";
		slc <= "11";
      enable <= '1';
      wait until Clk = '1';
      wait for 1ps;
      assert R = "1110" report "R: Shift without MSB failed";
      assert flag = '0' report "flag: Shift without flag failed";
      enable <= '0'; 
      wait for Clk_period*2;
      
      -- Shift Left with MSB 1
      A <= "1110";
		slc <= "11";
      enable <= '1';
      wait until Clk = '1';
      wait for 1ps;
      assert R = "1101" report "R: Shift with MSB failed";
      assert flag = '1' report "flag: Shift with flag failed";
		enable <= '0';
      wait for Clk_period*2;
      

      wait;
   end process;

END;
