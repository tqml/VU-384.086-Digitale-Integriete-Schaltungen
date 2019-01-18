library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



architecture behavior of demux is
signal TMP1 : std_logic_vector((5-1) downto 0);
signal TMP2 : std_logic_vector((5-1) downto 0);
signal TMP3 : std_logic_vector((5-1) downto 0);

begin

process (SEL, IN1) begin

	case SEL is
		when "00" => 
			TMP1 <= IN1;
			TMP2 <= "00000";
			TMP3 <= "00000";
		when "01" => 
			TMP1 <= "00000";
			TMP2 <= IN1;
			TMP3 <= "00000";
		when "10" => 
			TMP1 <= "00000";
			TMP2 <= "00000";
			TMP3 <= IN1;
		when others =>
			TMP1 <= "00000";
			TMP2 <= "00000";
			TMP3 <= "00000";
	end case;
end process;

OUT1 <= TMP1;
OUT2 <= TMP2;
OUT3 <= TMP3;
end behavior;