----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2018 14:30:14
-- Design Name: 
-- Module Name: fifo_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo_tb is
--  Port ( );
end fifo_tb;

architecture Behavioral of fifo_tb is

component fifo is
  port (
    clk : in std_logic;
    reset : in std_logic;
    fifo_ctrl : in std_logic_vector(1 downto 0);
    d_in : in std_logic_vector(7 downto 0);
    d_out : out std_logic_vector(7 downto 0)
  ) ;
end component;

signal clk : std_logic;
signal reset : std_logic;
signal fifo_ctrl : std_logic_vector(1 downto 0);
signal d_in : std_logic_vector(7 downto 0);
signal d_out : std_logic_vector(7 downto 0);

constant PERIOD : time := 20 ns;
signal SIMEND : std_logic := '0';

begin


dut : fifo port map(
   clk => clk,
   reset => reset,
   fifo_ctrl => fifo_ctrl,
   d_in => d_in,
   d_out => d_out);
   
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
end process; -- clkgen


stimuli : process
begin

wait for PERIOD/4;

fifo_ctrl <= "00";
reset <= '1';

wait for PERIOD/2;
reset <= '0';
fifo_ctrl <= "11";
d_in <= X"07";

wait for PERIOD/2;
assert d_out = X"07" report "Wrong Output" severity error;

fifo_ctrl <= "01";
d_in <= X"05";
wait for PERIOD;
d_in <= X"06";
wait for PERIOD;
d_in <= X"07";
wait for PERIOD;
d_in <= X"08";
wait for PERIOD;

fifo_ctrl <= "10";
wait for PERIOD/2; 
assert d_out = X"05" report "Wrong Output" severity error;
wait for PERIOD; 
assert d_out = X"06" report "Wrong Output" severity error;
wait for PERIOD; 
assert d_out = X"07" report "Wrong Output" severity error;
wait for PERIOD;  
assert d_out = X"08" report "Wrong Output" severity error;

SIMEND <= '1';
wait;

end process; -- stimuli





end Behavioral;
