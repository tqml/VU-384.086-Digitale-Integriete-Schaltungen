library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity fifo is
  port (
    clk : in std_logic;
    reset : in std_logic;
    fifo_ctrl : in std_logic_vector(1 downto 0);
    d_in : in std_logic_vector(7 downto 0);
    d_out : out std_logic_vector(7 downto 0);
    d_out_valid : out std_logic
  ) ;
end fifo;

architecture behavior of fifo is

    type fifo_memory is array (0 to 3) of std_logic_vector(7 downto 0);
        
    constant size : integer := 4;
    constant fifo_ctrl_no_op : std_logic_vector(1 downto 0) := "00";
    constant fifo_ctrl_push : std_logic_vector(1 downto 0) := "01";
    constant fifo_ctrl_pop : std_logic_vector(1 downto 0) := "10";
    constant fifo_ctrl_pushpop : std_logic_vector(1 downto 0) := "11";

    signal head : integer range 0 to 4-1 := 0;
    signal tail : integer range 0 to 4-1 := 0;
    
    signal memory : fifo_memory;

begin

    main : process( clk )
    begin
        if rising_edge(clk) then
            if reset = '1' then 
                head <= 0;
                tail <= 0;
                d_out <= X"00";
                d_out_valid <= '0';
                flush_loop : for i in 0 to size-1 loop
                    memory(i) <= X"00";
                end loop ; -- flush_loop
            else
                case fifo_ctrl is
                    when fifo_ctrl_no_op =>
                        d_out <= X"00";
                    when fifo_ctrl_pushpop =>
                         
                        if head = tail then
                            -- fifo empty ->
                            d_out <= d_in;
                        else 
                            d_out <= memory(head);
                            memory(tail) <= d_in;
                            tail <= tail + 1;
                            head <= head + 1;
                        end if;
                    when fifo_ctrl_push =>
                        memory(tail) <= d_in;
                        tail <= tail + 1;
                        if tail + 1 = head then
                            head <= head + 1;
                        end if;
        
                    when fifo_ctrl_pop =>
                        d_out <= memory(head);
                        head <= head + 1;
                        if head + 1 = tail then 
                            tail <= tail + 1;
                        end if;
                    when others =>
                        d_out <= X"00";
                        d_out_valid <= '0';
                end case;
            end if;
            
            
        end if ;
    end process ; -- main
end behavior ; -- behavior
