library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity ALU2 is
    port(  Clk,enable : in std_logic;
     		A,B : in std_logic_vector(3 downto 0);
     		slc : in std_logic_vector(1 downto 0); 
     		R : out std_logic_vector(3 downto 0); 
     		flag : out std_logic);
end ALU2;  


architecture behavior of ALU2 is

signal A_I  : integer range 0 to 32; -- just in case
signal B_I  : integer range 0 to 32; -- just in case

begin

-- R <= "0000" when enable = '0';
-- flag <= '0' when enable = '0';

A_I <= to_integer(unsigned(A));
B_I <= to_integer(unsigned(B));

p1 : process( Clk )
variable or_result : std_logic_vector(3 downto 0);
begin
    if enable = '0' then
        R <= "0000";
        flag <= '0';
    elsif rising_edge(Clk) and enable = '1' then
        case slc is -- Select Operation
            -- add    
            when "00" => 
                R <= std_logic_vector(unsigned(A) + unsigned(B)); 
                if (A_I + B_I) > 15 then
                    flag <= '1'; -- overflow
                else 
                    flag <= '0';
                end if;

            -- compare
            when "01" =>
                R <= A;
                if A > B or A = B then -- greater or equal
                    flag <= '1';
                else
                    flag <= '0';    
                end if ;
            
            -- or
            when "10" =>
                or_result := A or B;
                R <= or_result;
                
                if or_result = "0000" then
                    flag <= '1';
                else
                    flag <= '0';
                end if ;
                

            -- shift left
            when "11" =>
                flag <= A(3);    
                R(3) <= A(2);
                R(2) <= A(1);
                R(1) <= A(0);
                R(0) <= '0';
                
            -- for other wired cases (High-Z, Dont Care?)
            when others => 
                R <= "0000";
                flag <= '0';
        end case;
    end if ;
end process ; -- p1


end behavior;
