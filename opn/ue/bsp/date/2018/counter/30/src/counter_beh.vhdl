library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

architecture behavior of counter is
    --constant zeroCount : unsigned(6-1 downto 0) := to_unsigned(0, 6);
    signal count   : STD_LOGIC_VECTOR (5 downto 0) := "000000";
begin

    -- Update output
    Output <= count;

    CLK_RISE : process( CLK, AsyncClear )
    variable x : std_logic_vector(5 downto 0);
    begin
        if Enable = '0' then
            -- Do nothing and ignore everything
        elsif AsyncClear = '1' then
            count <= "000000";
        elsif rising_edge(CLK) then
            if RST = '1' then
                count <= "000000";
            elsif SyncLoadInput = '1' then
                count <= Input;
            else
                -- x := x + '1';
                count <= count + '1';
            end if ;        
        end if;
    end process ; -- CLK_RISE

end behavior;