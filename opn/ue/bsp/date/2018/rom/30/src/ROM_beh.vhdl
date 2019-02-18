library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture behavior of ROM is
                                            -- 0000000011001011
    constant lower_addr : std_logic_vector := "0000000010111010";
    constant upper_addr : std_logic_vector := "0000000011001010";

    constant ADDR_LOW : integer := to_integer(unsigned(lower_addr));
    constant ADDRMAX : integer := 2**16 - 1;
    
    signal offset : integer range 0 to 16;

    -- https://www.edaboard.com/showthread.php?38052-How-can-I-describe-a-ROM-in-VHDL
    type mem is array ( 0 to 16 ) of std_logic_vector(10 downto 0);
    constant RomMemory : mem := (    
        0  => "11110000100", 
        1  => "11011001000",
        2  => "01110101100",
        3  => "10100101001",
        4  => "10011110010",
        5  => "10100101100",
        6  => "00110111100",
        7  => "10110100110",
        8  => "01010100100",
        9  => "11000001111",
        10 => "10110011000",
        11 => "01011001111",
        12 => "00001100011",
        13 => "01000000111",
        14 => "00000111001",
        15 => "01010010101",
        16 => "11010110101");

begin

    p1 : process( Clk, enable )
    begin
        if enable = '0'  then 
            output <= (others => '0');
        elsif rising_edge(Clk) then

            -- 00000000 1011 1010 =  0xBA
            -- 00000000 1100 1010 =  0xCA

            if  (addr >= lower_addr) and (addr <= upper_addr) then
                -- offset <= to_integer(unsigned(addr)) - to_integer(unsigned(lower_addr));                
                -- output <= RomMemory(offset);
                output <= RomMemory(to_integer(unsigned(addr)) - ADDR_LOW);
            else
                output <= (others => '0');        
            end if;

            

        end if;
    end process ; -- p1

end behavior;
