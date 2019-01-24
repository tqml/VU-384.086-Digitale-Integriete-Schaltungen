library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ROM is
    port(  Clk,enable : in std_logic;
	   addr : in std_logic_vector(13 downto 0);
     	   output : out std_logic_vector(15 downto 0));
end ROM;
