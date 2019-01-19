library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture behavior of ROM is

begin

ROM_PROCESS : process (Clk)
	--variable addr0 : std_logic_vector(13 downto 0) := "00000000110010";
	
	type type_addr is array (0 to 12) of std_logic_vector(13 downto 0);
	variable array_addr : type_addr := ("00000000110010", "00000000110011", "00000000110100", "00000000110101", "00000000110110", "00000000110111", "00000000111000", "00000000111001", "00000000111010", "00000000111011", "00000000111100", "00000000111101", "00000000111110");
	--variable array_addr : type_addr := (addr0, addr0+1, addr0+10, addr0+11, addr0+100, addr0+101, addr0+110, addr+111, addr0+1000, addr0+1001, addr0+1010, addr0+1011, addr0+1100);
	
	type type_inst is array (0 to 12) of std_logic_vector(15 downto 0);
	variable array_inst : type_inst := ("1110100000000101", "0101001101010111", "0100100010111001", "0100110011011110", "0111001111110101", "1000011110111110", "0111101010110010", "0100101100000010", "0101100001100010", "1111110010111110", "1101110101101000", "1101111011101110", "0011110011111011");
	
	variable a_done : std_logic;
	
	begin
	if rising_edge(Clk) then
		a_done := '0';
		
		if (enable = '0') then
			output <= "0000000000000000";
		else
			-- iterate through all addresses
			for i in 0 to 12 loop
				if array_addr(i) = addr then
					output <= array_inst(i);
					a_done := '1';
				end if;
			end loop;
			-- if any address beside the defined ones, set output to 0
			if (a_done = '0') then
				output <= "0000000000000000";
			end if;
		end if;
	end if;
	end process ROM_PROCESS;
	

end behavior;
