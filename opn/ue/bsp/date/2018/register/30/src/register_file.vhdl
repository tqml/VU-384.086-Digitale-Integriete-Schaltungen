library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity register_file is
    port(
        -- Input Data
         IN1    : in  std_logic_vector((16 - 1) downto 0);
         -- Write Address 1
         WA1    : in  std_logic_vector((3 - 1) downto 0);
         WE1    : in  std_logic; -- WRITE ENABLE

         -- INPUT DATA 2
         IN2    : in  std_logic;
         -- WRITE Address 2
         WA2    : in  std_logic_vector((3 - 1) downto 0);
         WE2    : in  std_logic; -- Write Enable 2

         -- Read Address 1
         RA1    : in  std_logic_vector((3 - 1) downto 0);

         CLK    : in  std_logic;

         Output : out std_logic_vector((16 - 1) downto 0)
         );
end register_file;