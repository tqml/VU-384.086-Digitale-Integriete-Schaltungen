library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



architecture behavior of blockcode is
    
    type FFBuffer is array (0 to 3) of std_logic_vector(0 to 7);
    
    -- the fifo memory
    signal FifoBuffer : FFBuffer;
    
    signal isFull   : std_logic := '0'; -- indicates that the buffer is full
    signal head     : integer range 0 to 3 := 0; -- head position (where to take/pop)
    signal tail     : integer range 0 to 3 := 0; -- tail position (where to insert/push)

    signal encoded_data : std_logic_vector(0 to 7);
    
    signal   ctrl         : std_logic_vector(1 downto 0);
    constant ctrl_no_op   : std_logic_vector(1 downto 0) := "00";
    constant ctrl_push    : std_logic_vector(1 downto 0) := "01";
    constant ctrl_pop     : std_logic_vector(1 downto 0) := "10";
    constant ctrl_pushpop : std_logic_vector(1 downto 0) := "11";

    -- This mechanism toggles the behaviour what should happs when the FIFO is full
    -- and a new code should be appended. Either the oldest or the newest code could
    -- be thrown away.
    constant keepOldestCode : boolean := false;

begin


-- Combine values to control signal
ctrl(1) <= sink_ready;
ctrl(0) <= data_valid;

-- Encode the data
encoded_data(0 to 4) <= data;
encoded_data(5) <= data(1) xor data(4);
encoded_data(6) <= data(0) xor data(4);
encoded_data(7) <= data(1) xor data(2);




encode_process : process( clk )
variable head_next : integer range 0 to 3; -- next head position
variable tail_next : integer range 0 to 3; -- next tail position
begin
    if rising_edge(clk) then
        if rst =  '1' then
            -- Reset everything
            reset_buffer_loop : for i in 0 to 3 loop
                FifoBuffer(i) <= X"00";
            end loop ; -- reset_buffer_loop
            head <= 0;
            tail <= 0;
            isFull <= '0';
            code_valid <= '0';
            code <= X"XX"; -- this only works in VHDL 08
        else
            -- define next head/tail ptrs
            if head = 3 then head_next := 0; else head_next := head + 1; end if;
            if tail = 3 then tail_next := 0; else tail_next := tail + 1; end if;

            case ctrl is
                
                -- Pop: Sink is ready, but source data is not valid
                when ctrl_pop =>

                    -- use the first code (maybe not valid)
                    code <= FifoBuffer(head);
                    
                    if head = tail and isFull = '0' then -- is empty
                        code_valid <= '0';
                    else
                        code_valid <= '1'; -- code is valid
                        head <= head_next; -- update head to next code in buffer
                        isFull <= '0'; -- buffer is not full anymore
                    end if;


                -- Push: Sink is not ready but source data is valid
                when ctrl_push => 
                    
                    -- output code is always valid, because either a stored code is used or 
                    -- the new data is encoded, stored and outputted.
                    code_valid <= '1';
                    
                    -- determine which code should be used as output
                    if head = tail and isFull = '0' then -- is empty
                        code <= encoded_data;
                    else  -- is not empty
                        code <= FifoBuffer(head); -- use oldest code
                    end if;

                    if isFull = '0' then
                        FifoBuffer(tail) <= encoded_data; -- append code to tail
                        tail <= tail_next; -- update tail but do not update head (sink is not ready)
                    else -- is full
                        if keepOldestCode then
                            -- do nothing
                        else
                            FifoBuffer(tail) <= encoded_data; -- append code to tail
                            tail <= tail_next; -- update tail but do not update head (sink is not ready)
                            head <= head_next; -- throw away oldest code    
                        end if;
                    end if;

                    
                    
                    -- if the buffer is full on next write mark a bit
                    -- this gets valid on the next iteration
                    if tail_next = head then
                        isFull <= '1';
                    end if;
                
                
                when ctrl_pushpop => -- simultanius push & pop
                    
                    -- code is always valid (either use stored code or new value)
                    code_valid <= '1';

                    if head = tail and isFull = '0' then -- buffer is empty
                        code <= encoded_data; -- direct code output    
                    else
                        code <= FifoBuffer(head);
                        FifoBuffer(tail) <= encoded_data;
                        head <= head_next;
                        tail <= tail_next;
                    end if ;

                when others => -- other cases (used )
                    code_valid <= '0';
                    code <= X"XX";
            end case;
            
        end if;
    end if ;
end process ; -- encode_process


end behavior;
