library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux is
    port ( IN1  : in  std_logic_vector((5 - 1) downto 0);
           SEL  : in  std_logic_vector((2 - 1) downto 0);
           OUT1 : out std_logic_vector((5 - 1) downto 0);
           OUT2 : out std_logic_vector((5 - 1) downto 0);
           OUT3 : out std_logic_vector((5 - 1) downto 0));

end demux;
--
--architecture Behavioral of demux is
--
--begin
--
--
--end Behavioral;