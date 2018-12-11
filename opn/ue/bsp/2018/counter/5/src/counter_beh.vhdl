library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture behavior of counter is

begin

process(CLK,AsyncClear)

begin
if (AsyncClear='1') then
Output<="000000";
Overflow<='0';
end if;

if rising_edge(Clk) then
    if (RST='1') then
    Output<="000000";
    Overflow<='0';
    elsif (SyncLoadInput='1') then
    Output<= Input;
    Overflow<='0';
    elsif (Output= "111111") then
    Output<="000000";
    Overflow<='1';
    else
    Output<=std_logic_vector( unsigned(Output) + 1 );
    Overflow<='0';
    end if;
end if;
end process;

end behavior;
