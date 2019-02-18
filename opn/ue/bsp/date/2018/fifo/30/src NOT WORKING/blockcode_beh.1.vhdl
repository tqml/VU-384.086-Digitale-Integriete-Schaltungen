library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture behavior1 of blockcode is
    
    type FFBuffer is array (0 to 3) of std_logic_vector(0 to 7);
    
    -- the fifo memory
    signal FifoBuffer : FFBuffer;
    
    -- the num of elements in the fifo
    signal FifoCount : integer range 0 to 3;

begin

    encode_process : process( clk )
    variable encoded_value : std_logic_vector(0 to 7);
    begin
        if rising_edge(clk) then
            if rst = '1' then
            
                FifoBuffer(0) <= X"00";
                FifoBuffer(1) <= X"00";
                FifoBuffer(2) <= X"00";
                FifoBuffer(3) <= X"00";
                FifoCount <= 0;
                code_valid <= '0';
                code <= X"00";
            
            elsif data_valid = '1' then
                
                -- Encode Data
                encoded_value(0 to 5-1) := data(0 to 5-1);
                encoded_value(5) := data(1) xor data(4);
                encoded_value(6) := data(0) xor data(4);
                encoded_value(7) := data(1) xor data(2);

                -- Output or place in fifo
                if sink_ready = '1' and FifoCount = 0 then
                    code <= encoded_value;
                    code_valid <= '1';   
                elsif sink_ready = '1' and FifoCount > 0 then
                    code <= FifoBuffer(0);
                    code_valid <= '1';
                    -- Shift codes
                    ShiftFifo : for i in 0 to FifoCount-1 loop
                        FifoBuffer(i) <= FifoBuffer(i+1);
                    end loop ; -- ShiftFifo    
                    -- Append code
                    FifoBuffer(FifoCount) <= encoded_value;
                
                elsif sink_ready = '0' and FifoCount < 4 then
                    code_valid <= '0';
                    code <= X"00"; -- don't care
                    FifoBuffer(FifoCount) <= encoded_value;
                    FifoCount <= FifoCount + 1;
                else 
                    code_valid <= '0';
                    code <= X"00"; -- don't care
                end if ;

            elsif FifoCount > 0 then -- Use values from the fifo
                code <= FifoBuffer(0); -- first value
                code_valid <= '1';
                -- Shift codes
                for i in 0 to FifoCount-1 loop
                    FifoBuffer(i) <= FifoBuffer(i+1);
                end loop ; -- ShiftFifo    
                
                -- decrement value
                FifoCount <= FifoCount - 1;
                
            else -- No valid data and no values in the buffer
                code_valid <= '0';
                code <= X"00";
            end if;
        end if;
                

    end process ; -- encode_process


end behavior1;
