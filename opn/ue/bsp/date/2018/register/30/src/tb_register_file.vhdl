library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb_register_file is
  
end tb_register_file;

architecture behavior of tb_register_file is

component register_file port(
     IN1    : in  std_logic_vector((16 - 1) downto 0);
     WA1    : in  std_logic_vector((3 - 1) downto 0);
     WE1    : in  std_logic; -- WRITE ENABLE
     IN2    : in  std_logic;
     WA2    : in  std_logic_vector((3 - 1) downto 0);
     WE2    : in  std_logic; -- Write Enable 2
     RA1    : in  std_logic_vector((3 - 1) downto 0);
     CLK    : in  std_logic;
     Output : out std_logic_vector((16 - 1) downto 0)
     );
end component;


signal IN1    :  std_logic_vector((16 - 1) downto 0);
signal WA1    :  std_logic_vector((3 - 1) downto 0);
signal WE1    :  std_logic; -- WRITE ENABLE
signal IN2    :  std_logic;
signal WA2    :  std_logic_vector((3 - 1) downto 0);
signal WE2    :  std_logic; -- Write Enable 2
signal RA1    :  std_logic_vector((3 - 1) downto 0);
signal CLK    :  std_logic;
signal Output :  std_logic_vector((16 - 1) downto 0);

signal SIMEND : std_logic := '0';
constant PERIOD : time := 20 ns;

begin

-- port mapping
dut : register_file port map(
    IN1 => IN1,
    WA1 => WA1,
    WE1 => WE1,
    IN2 => IN2,
    WA2 => WA2,
    WE2 => WE2,
    RA1 => RA1,
    CLK => CLK,
    Output => Output
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
variable output_value : integer := 0;
begin

   -- Give Address a defined value to remove number assertations warnings
   RA1 <= std_logic_vector(to_unsigned(0, RA1'length));
   WA1 <= std_logic_vector(to_unsigned(0, WA1'length));
   WA2 <= std_logic_vector(to_unsigned(0, WA2'length));

   wait for PERIOD/4;
   WE1 <= '0';
   IN2 <= '0';
   WE2 <= '0';
   WA2 <= std_logic_vector(to_unsigned(0, WA1'length));
   RA1 <= std_logic_vector(to_unsigned(0, RA1'length));

   wait for PERIOD;
   -- SIMULTANIOUS READ WRITE
   WE1 <= '1';
   -- READ ADDRESS = WRITE ADDRESS
   WA1 <= std_logic_vector(to_unsigned(5, WA1'length));
   RA1 <= std_logic_vector(to_unsigned(5, RA1'length));
   IN1 <= std_logic_vector(to_unsigned(15, IN1'length));
   
   -- wait until rising_edge(clk);
   wait on clk;
   RA1 <= std_logic_vector(to_unsigned(3, RA1'length));
   -- wait for PERIOD/4;
   assert Output = IN1 
   report "Input should be passed through at the next rising edge"
   severity error;
    
   wait for PERIOD;
   -- SIMULTANIOUS READ WRITE
   WE1 <= '1';
   -- READ ADDRESS = WRITE ADDRESS
   WA1 <= std_logic_vector(to_unsigned(1, WA1'length));
   RA1 <= std_logic_vector(to_unsigned(1, RA1'length));
   IN1 <= std_logic_vector(to_unsigned(255, IN1'length));
   
   
   assert Output = IN1 
   report "Input should be passed through at the next rising edge"
   severity error;

   wait for PERIOD;
   -- SIMULTANIOUS READ WRITE
   WE1 <= '1';
   -- READ ADDRESS = WRITE ADDRESS
   WA1 <= std_logic_vector(to_unsigned(1, WA1'length));
   RA1 <= std_logic_vector(to_unsigned(2, RA1'length));
   IN1 <= std_logic_vector(to_unsigned(15, IN1'length));

   wait for 2*PERIOD;

   RA1 <= std_logic_vector(to_unsigned(0, RA1'length));
   WE1 <= '0';
   WE2 <= '1';
   WA2 <= std_logic_vector(to_unsigned(4, RA1'length));
   

   wait for 2 * PERIOD;

   -- GO ASYNC
   wait until rising_edge(clk); -- wait to the next rising edge
   
   wait for PERIOD/8;
   IN2 <= '1';
   WA2 <= std_logic_vector(to_unsigned(4, RA1'length));

   wait for PERIOD/8;
   IN2 <= '1';
   WA2 <= std_logic_vector(to_unsigned(6, RA1'length));

   wait for PERIOD/8;
   IN2 <= '1';
   WA2 <= std_logic_vector(to_unsigned(2, RA1'length));


   -- GO SYNC AGAIN
   wait until rising_edge(clk); -- wait to the next rising edge
   wait for PERIOD;
   wait for 2 * PERIOD;
   
   for i in 1 to 7 loop
      WE1 <= '1';
      IN1 <= std_logic_vector(to_unsigned(i, IN1'length));
      WA1 <= std_logic_vector(to_unsigned(i, WA1'length));
      wait for PERIOD;
      WE1 <= '0';
      RA1 <= std_logic_vector(to_unsigned(i, RA1'length));
      
      wait for PERIOD/2;
      
      output_value := to_integer(unsigned(Output));
      
      assert output_value = i
      report "Stored Data does not match" & ". Expected: " & integer'image(i)
            & " recieved: " & integer'image(output_value)
      severity error;

      wait for PERIOD/2;
   end loop ; --   IN1 <= X"0000";
   
   IN1 <= std_logic_vector(to_unsigned(0, IN1'length));
   RA1 <= std_logic_vector(to_unsigned(0, RA1'length));
   WE1 <= '0';
   wait for 4*PERIOD;

   
   for i in 0 to 7 loop
      WE2 <= '1';
      IN2 <= '1';
      WA2 <= std_logic_vector(to_unsigned(i, WA2'length));
      
      wait for PERIOD;
      
      WE2 <= '0';
      RA1 <= std_logic_vector(to_unsigned(0, RA1'length));
      
      wait for PERIOD/2;

      output_value := to_integer(unsigned(Output));
      
      assert Output(i) = '1'
      report "Stored Data does not match" & ". Expected: " & integer'image(i)
            & " recieved: " & integer'image(output_value)
      severity error;

      wait for PERIOD/2;
   end loop ; -- 
   SIMEND <= '1';
   wait;
   
end process ; -- stimuli

end behavior; -- behavior