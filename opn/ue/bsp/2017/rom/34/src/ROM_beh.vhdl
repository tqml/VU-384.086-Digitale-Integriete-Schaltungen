library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--entity ROM is
--    port(  Clk,enable : in std_logic;
--	   addr : in std_logic_vector(15 downto 0);
--     	   output : out std_logic_vector(13 downto 0));
--end ROM;  

--01100000000010
--10111010101101
--10111010110000
--11101111011111
--01110000100111
--01001111111110
--10110001010111
--10000000111011
--10010111000101
--01110101011101
--11001101111011
--00011110100110

architecture behavior of ROM is
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

begin

test: process (Clk) 
begin
if falling_edge(Clk) then
	if enable = '1' then
		if to_integer(unsigned(addr)) > 165 OR to_integer(unsigned(addr)) < 153 then
			output <= "00000000000000";
		else	
			output <= ROMS(to_integer(unsigned(addr)));
		end if;
	else
		output <= "00000000000000";
	end if;
end if;
end process;

end behavior;
