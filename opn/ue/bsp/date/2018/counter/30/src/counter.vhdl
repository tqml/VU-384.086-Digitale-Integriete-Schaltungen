library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
	port(
		CLK         : in   std_logic;
		RST         : in   std_logic;
		Enable      : in   std_logic;	
		SyncLoadInput   : in   std_logic;
		AsyncClear   : in   std_logic;
		Input       : in   std_logic_vector((6-1) downto 0);	
		Output      : out  std_logic_vector((6-1) downto 0)
	);
end counter;