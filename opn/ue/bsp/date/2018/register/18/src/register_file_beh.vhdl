library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

architecture behavioral of register_file is

-- Register declaration & initialisation
signal REG0, REG1, REG2, REG3, REG4, REG5, REG6 : std_logic_vector(15 downto 0) := "0000000000000000";

begin

R_PROCESS : process (Clk)

begin



if rising_edge(CLK) then
	-- When write address WA1 is identical with read address RA1, pass through IN1 to Output at the next rising edge of CLK.
	if (WA1 = RA1) and (rising_edge(CLK)) then
		Output <= IN1;
	end if;
	
	-- When simultaneous read and write from REG0, pass through IN2 to Output at next rising edge of CLK.
	if (WE2 = '1') and (RA1 = "000") and (rising_edge(CLK)) then
		Output(0) <= IN2;
	end if;
	
	-- If Write Enable 1 is set, write IN1 to the corresponding register
	if (WE1 = '1') then
		case WA1 is
			when "001" =>
				REG1 <= IN1;
			when "010" =>
				REG2 <= IN1;
			when "011" =>
				REG3 <= IN1;
			when "100" =>
				REG4 <= IN1;
			when "101" =>
				REG5 <= IN1;
			when "110" =>
				REG6 <= IN1;
			when others =>
		end case;
	end if;
	
	-- If Write Enable 2 is set, write IN2 to the corresponding bit
	if (WE2 = '1') then
		case WA2 is
			when "00" =>
				REG0(0) <= IN2;
			when "01" =>
				REG0(1) <= IN2;
			when "10" =>
				REG0(2) <= IN2;
			when "11" =>
				REG0(3) <= IN2;
			when others =>
		end case;
	end if;
	
	-- Read register
	case RA1 is
	when "000" =>
		Output <= REG0;
	when "001" =>
		Output <= REG1;
	when "010" =>
		Output <= REG2;
	when "011" =>
		Output <= REG3;
	when "100" =>
		Output <= REG4;
	when "101" =>
		Output <= REG5;
	when "110" =>
		Output <= REG6;
	when others =>
end case;
end if;

end process R_PROCESS;
end behavioral;
