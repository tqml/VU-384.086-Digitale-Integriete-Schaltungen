library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

architecture behavior of ALU is
signal sub_a_b: std_logic_vector(4 downto 0);
begin

process (Clk, enable)
variable RESULT:std_logic_vector(4 downto 0) := "00000";
variable testBit:bit_vector(1 downto 0) := "00";
begin

--Gain a bit of speed when computing these signals seperately
sub_a_b <= std_logic_vector(unsigned('0' & A) - unsigned('0' & B));


if enable = '1' then
	if rising_edge(Clk) then
			case slc is
				--SUB
				when "00" =>
					R <= sub_a_b(3 downto 0);
					flag <= sub_a_b(4);
				--OR
				when "01" =>
					RESULT := '0' & (A or B); 
					R <= RESULT(3 downto 0);
					flag <= not(RESULT(3) or RESULT(2) or RESULT(1) or RESULT(0));
				--AND
				when "10" =>
					RESULT := '0' & (A and B);
					R <= RESULT(3 downto 0);
					flag <= not(RESULT(3) or RESULT(2) or RESULT(1) or RESULT(0));
				--ROTATE RIGHT
				when "11" =>
					R <= std_logic_vector(rotate_right(signed(A),1));
					flag <= A(0);
				when others =>
					R <= "0000";
					flag <= '0';
			end case;
	end if;
else
	if rising_edge(Clk) then
		R <= "0000";
		flag <= '0';
	end if;
end if;
end process;

end behavior;
