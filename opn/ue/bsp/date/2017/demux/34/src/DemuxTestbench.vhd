--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:33:17 10/07/2017
-- Design Name:   
-- Module Name:   /home/consti/gitclones/Digital_Integrierte_Schaltungen/Task1/DemuxTestbench.vhd
-- Project Name:  Task1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: demux
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
 
ENTITY DemuxTestbench IS
END DemuxTestbench;
 
ARCHITECTURE behavior OF DemuxTestbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT demux
    PORT(
         IN1 : IN  std_logic_vector(4 downto 0);
         SEL : IN  std_logic_vector(1 downto 0);
         OUT1 : OUT  std_logic_vector(4 downto 0);
         OUT2 : OUT  std_logic_vector(4 downto 0);
         OUT3 : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal IN1 : std_logic_vector(4 downto 0) := (others => '0');
   signal SEL : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal OUT1 : std_logic_vector(4 downto 0);
   signal OUT2 : std_logic_vector(4 downto 0);
   signal OUT3 : std_logic_vector(4 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: demux PORT MAP (
          IN1 => IN1,
          SEL => SEL,
          OUT1 => OUT1,
          OUT2 => OUT2,
          OUT3 => OUT3
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for period*10;
		
		-- 00 - OUT1 --
		SEL <= "00";
		IN1 <= "01010";
		assert OUT1 = "01010" report "OUT1 Correct for SEL=00 and IN1=01010";
		assert OUT2 = "00000" report "OUT2 Correct for SEL=00 and IN1=01010";
		assert OUT2 = "00000" report "OUT3 Correct for SEL=00 and IN1=01010";
		wait for 10 ns;	
		
		-- 01 - OUT2 --
		SEL <= "01";
		IN1 <= "01010";
		assert OUT1 = "00000" report "OUT1 Correct for SEL=01 and IN1=01010";
		assert OUT2 = "01010" report "OUT2 Correct for SEL=01 and IN1=01010";
		assert OUT2 = "00000" report "OUT3 Correct for SEL=01 and IN1=01010";
		wait for 10 ns;	
		
		-- 11 - OUT3 --
		SEL <= "10";
		IN1 <= "01010";
		assert OUT1 = "00000" report "OUT1 Correct for SEL=10 and IN1=01010";
		assert OUT2 = "00000" report "OUT2 Correct for SEL=10 and IN1=01010";
		assert OUT2 = "01010" report "OUT3 Correct for SEL=10 and IN1=01010";
		wait for 10 ns;	
		
		-- 11 - All0 --
		SEL <= "11";
		IN1 <= "01010";
		assert OUT1 = "00000" report "OUT1 Correct for SEL=11 and IN1=01010";
		assert OUT2 = "00000" report "OUT2 Correct for SEL=11 and IN1=01010";
		assert OUT2 = "00000" report "OUT3 Correct for SEL=11 and IN1=01010";
		wait for 100 ns;	
		
      -- insert stimulus here 

      wait;
   end process;

END;
