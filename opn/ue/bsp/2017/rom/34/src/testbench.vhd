--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:54:58 10/11/2017
-- Design Name:   
-- Module Name:   /home/consti/gitclones/Digital_Integrierte_Schaltungen/Task3/tbh/testbench.vhd
-- Project Name:  Task3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ROM
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
use IEEE.numeric_std.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testbench IS
END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ROM
    PORT(
         Clk : IN  std_logic;
         enable : IN  std_logic;
         addr : IN  std_logic_vector(15 downto 0);
         output : OUT  std_logic_vector(13 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal enable : std_logic := '0';
   signal addr : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(13 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
	signal I : unsigned(15 downto 0):= (others => '0');
	
	constant ADDR_RANGE: integer:= 8;
	constant	DATA_WIDTH: integer:= 14;
	type ROM_TYPE is array (153 to 2**ADDR_RANGE) of
	std_logic_vector(DATA_WIDTH-1 downto 0);

	constant ROMS : ROM_TYPE :=
	(b"01100000000010",
	b"10111010101101",
	b"10111010110000",
	b"11101111011111",
	b"01110000100111",
	b"01001111111110",
	b"10110001010111",
	b"10000000111011",
	b"10010111000101",
	b"01110101011101",
	b"11001101111011",
	b"00011110100110",
	others => b"00000000000000");
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ROM PORT MAP (
          Clk => Clk,
          enable => enable,
          addr => addr,
          output => output
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
      wait for 10 ns;	
		for I in 153 to 164 loop
			addr <= std_logic_vector(to_unsigned(I,16));
			
			enable <= '1';
			wait until Clk = '0';
			wait for 1 ps;
			assert ROMS(I) = output report "One didn't match";
			wait for 10 ns;
		end loop;
      -- insert stimulus here 

      wait;
   end process;

END;
