library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

--    port(  Clk,enable : in std_logic;
--     		A,B : in std_logic_vector(3 downto 0);
--     		slc : in std_logic_vector(1 downto 0); 
--     		R : out std_logic_vector(3 downto 0); 
--     		flag : out std_logic);

architecture behavior of ALU is
	signal add_a_b: std_logic_vector(4 downto 0);
begin

--Execute parallel to process
add_a_b <= std_logic_vector(unsigned('0' & A) + unsigned('0' & B));

main: process (Clk, enable)
variable RESULT:std_logic_vector(4 downto 0) := "00000";
variable testBit:bit_vector(1 downto 0) := "00";
begin

--Only do anything when enable is high
if enable = '1' then
	--Only >>>update<<< the output when Clk is rising
	if rising_edge(Clk) then
			case slc is
				--ADD
				when "00" =>
					R <= add_a_b(3 downto 0); --Super clever, super fast, Nebenlaeufigkeit!
					flag <= add_a_b(4);
				--XOR
				when "01" =>
					RESULT := '0' & (A xor B); --Save away result for parity check
					R <= RESULT(3 downto 0);
					flag <= not(RESULT(3) xor RESULT(2) xor RESULT(1) xor RESULT(0));
				--OR
				when "10" =>
					RESULT := '0' & (A or B);
					R <= RESULT(3 downto 0);
					flag <= not(RESULT(3) xor RESULT(2) xor RESULT(1) xor RESULT(0));
				--ROTATE LEFT
				when "11" =>
					R <= std_logic_vector(rotate_left(signed(A),1));
					flag <= A(3);
				when others =>
					R <= "0000";
					flag <= '0';
			end case;
	else
		--Output only changes on the rising edge of the clock #frustrating!
	end if;
else
	if rising_edge(Clk) then
		R <= "0000";
		flag <= '0';
	end if;
end if;
end process;

--main: process (Clk, enable, slc)
--variable RESULT, varA, varB: std_logic_vector(4 downto 0);
--variable ROTATE: std_logic_vector(4 downto 0);
--variable varFLAG: std_logic;
--begin
--	R <= "0000";
--	flag <= '0';
--	varFLAG := '0';
--	varA := '0' & A;
--	varB := '0' & B;
--	RESULT := "00100";
--	
--
--		if enable = '1' then
--			case slc is
--				--ADD
--				when "00" =>
--					RESULT := std_logic_vector((unsigned(varA)) + (unsigned(varB)));
--					if RESULT(4) = '1' then 
--						varFLAG := '1';	--Write Overflow Bit
--					end if;
--				--XOR
--				when "01" =>
--					RESULT := varA xor varB;
--					if RESULT = "00000" then
--						varFLAG := '1';
--					else
--						varFLAG := not(RESULT(3) xor RESULT(2) xor RESULT(1) xor RESULT(0));
--					end if;
--				--OR
--				when "10" =>
--					RESULT := varA or varB;
--					if RESULT = "00000" then
--						varFLAG := '1';
--					else
--						varFLAG := not(RESULT(3) xor RESULT(2) xor RESULT(1) xor RESULT(0));
--					end if;	
--				--ROTATE LEFT, A<<1
--				when "11" =>
--					ROTATE := '0' & std_logic_vector(rotate_left(signed(A),1));
--					RESULT := '0' & ROTATE(3 downto 0);
--					varFLAG := RESULT(0);
--				when others =>
--					RESULT := "00000";
--					varFLAG := '0';
--			end case;
--			--R <= RESULT(3 downto 0);
--			--flag <= varFLAG;
--		else
--			--ALU is disabled, R and flag zero
--			RESULT := "00000";
--			varFLAG := '0';
--		end if;
--	
--	if rising_edge(Clk) then
--		R <= RESULT(3 downto 0);
--		flag <= varFLAG;
--	else
--		-- Output only changes on the rising edge of the clock #frustrating!
--	end if;	
--end process;

end behavior;
