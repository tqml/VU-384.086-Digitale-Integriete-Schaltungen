library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture behavior2 of blockcode is
    
    type FFBuffer is array (0 to 3) of std_logic_vector(0 to 7);
    
    -- the fifo memory
    signal FifoBuffer : FFBuffer;
    
    -- the num of elements in the fifo
    signal count_ff : integer range 0 to 7;
    
    
   

begin

encode_process : process( clk )
variable encoded_value : std_logic_vector(0 to 7);
variable element_added : integer range 0 to 1 := 0;
variable element_popped : integer range 0 to 1 := 0;
variable insert_index : integer range 0 to 7;
begin
    if rising_edge(clk) then
        
        if rst =  '1' then
            FifoBuffer(0) <= X"00";
            FifoBuffer(1) <= X"00";
            FifoBuffer(2) <= X"00";
            FifoBuffer(3) <= X"00";
            count_ff <= 0;
            code_valid <= '0';
            code <= X"00";
        else
            insert_index := count_ff;

            -- output fifo
            code <= FifoBuffer(0);
            if count_ff > 0 then code_valid <= '1'; else code_valid <= '0'; end if;
            
            if sink_ready = '1' then
                -- shift register
                FifoBuffer(0) <= FifoBuffer(1);
                FifoBuffer(1) <= FifoBuffer(2);
                FifoBuffer(2) <= FifoBuffer(3);
                
                -- Note that element has been removed
                element_popped := 1;
                insert_index := insert_index - 1;
            end if;

            if data_valid = '1' then
                encoded_value(0 to 5-1) := data(0 to 5-1);
                encoded_value(5) := data(1) xor data(4);
                encoded_value(6) := data(0) xor data(4);
                encoded_value(7) := data(1) xor data(2);
                
                --insert_index := count_ff-1 when element_popped = 1 else count_ff;
                element_added := 1;
                if insert_index /= 4 then
                    FifoBuffer(insert_index) <= encoded_value; -- append encoded value
                end if ;    
            end if ;
            
            -- Set the counter signal right. 
            -- Take care of over and underflow
            if count_ff = 0 then
                count_ff <= count_ff + element_added;
            elsif count_ff = 4 then
                count_ff <= count_ff - element_popped;
            else
                count_ff <= count_ff - element_popped + element_added;    
            end if ;
            
        end if;
    end if ;
end process ; -- encode_process


end behavior2;
