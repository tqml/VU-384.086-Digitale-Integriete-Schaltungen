library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity blockcode_tb is
  --port () ;
end blockcode_tb;

architecture arch of blockcode_tb is


component blockcode port(
    rst         : in   std_logic;
    clk         : in   std_logic;
    data_valid  : in   std_logic;
    data        : in   std_logic_vector(0 to 5-1);
    sink_ready  : in   std_logic;
    code_valid  : out  std_logic;
    code        : out  std_logic_vector(0 to 8-1)
);
end component;


    signal rst         :  std_logic;
    signal clk         :  std_logic;
    signal data_valid  :  std_logic;
    signal data        :  std_logic_vector(0 to 5-1);
    signal sink_ready  :  std_logic;
    signal code_valid  :  std_logic;
    signal code        :  std_logic_vector(0 to 8-1);

    signal code_expected : std_logic_vector(0 to 8-1);
    signal code_valid_expected : std_logic;

    signal SIMEND : std_logic := '0';
    constant PERIOD : time := 20 ns;

begin

uut : blockcode port map (
    rst => rst,
    clk => clk,
    data_valid => data_valid,
    data => data,
    sink_ready => sink_ready,
    code_valid => code_valid,
    code => code
);

clkgen : process
begin
    if SIMEND = '0' then
        clk <= '0';
        wait for PERIOD/2;
        clk <= '1';
        wait for PERIOD/2;
    else
        wait;
    end if;
end process ; -- clkgen

stimuli : process
begin
    wait for PERIOD/4;
    
    rst <= '1';
    sink_ready <= '0';

    wait for PERIOD;
    rst <= '0';
    data <= "00000";
    data_valid <= '1';

    wait for PERIOD;
    data <= "00001";
    data_valid <= '1';

    wait for PERIOD;
    data <= "00010";
    data_valid <= '1';

    wait for PERIOD;
    data <= "00011";
    data_valid <= '1';

    wait for PERIOD;
    data <= "00011";
    data_valid <= '0';
    sink_ready <= '1';
    
    wait for PERIOD;
    wait for PERIOD;
    wait for PERIOD;

    SIMEND <= '1';
    wait;
end process ; -- stimuli

end arch ; -- arch