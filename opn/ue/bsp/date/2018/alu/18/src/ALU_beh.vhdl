library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

architecture behavior of ALU is
signal A_u, B_u : unsigned(3 downto 0);

begin

ALU_PROCESS : process (Clk)

begin

if rising_edge(Clk) then
	A_u <= unsigned(A);
	B_u <= unsigned(B);
	flag <= '0';
	
	if enable then
		case slc is
			when "00" => -- SUB: subtract B from A
				R <= std_logic_vector(A_u - B_u);
				flag <= '1' when ((A_u - B_u) = "0000") else '0';
			when "01" => -- AND: Logical AND between A and B
				R <= A and B;
				if (R = "0000") then
					flag <= '1';
				end if;
			when "10" => -- Comparator: Compares A with B and outputs A on R
				R <= A;
				if A_u >= B_u then
					flag <= '1';
				end if;
			when "11" => -- Shift Left: Shift all bits of A one bit to the left, LSB = 0, output to R
				flag <= A(3);
				R <= std_logic_vector(unsigned(A) sll 1);
			when others =>
		end case;
	else 
		R <= "0000";
		flag <= '0';
	end if;
	
end if;

end process ALU_PROCESS;

end behavior;
