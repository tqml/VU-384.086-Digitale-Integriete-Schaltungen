library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture behavior of ROM is
signal short_addr: std_logic_vector (3 downto 0);

type ROM_t is array (144 to 155) of std_logic_vector(9 downto 0);
constant ROM_Data: ROM_t:=(
"0010000011",
"1000100100",
"0011001000",
"1100001010",
"1110100001",
"1011110001",
"1000110111",
"0001110011",
"0011101100",
"1100111100",
"1100111100",
"0011010011",
others =>"0000000000"
);

begin
process(Clk)
begin
if falling_edge(Clk) then
	if enable = '1' then
		if to_integer(unsigned(addr)) > 155 OR to_integer(unsigned(addr)) < 144 then
			output <= "0000000000";
		else	
			output <= ROM_Data(to_integer(unsigned(addr)));
		end if;
	else
		output <= "0000000000";
	end if;
end if;
end process;
end behavior;
