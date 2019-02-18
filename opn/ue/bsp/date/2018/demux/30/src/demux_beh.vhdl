library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


architecture behavior of demux is


begin

    OUT1 <= IN1 when SEL = "000" else (others => '0');
    OUT2 <= IN1 when SEL = "001" else (others => '0');
    OUT3 <= IN1 when SEL = "010" else (others => '0');
    OUT4 <= IN1 when SEL = "011" else (others => '0');
    OUT5 <= IN1 when SEL = "100" else (others => '0');

end behavior;