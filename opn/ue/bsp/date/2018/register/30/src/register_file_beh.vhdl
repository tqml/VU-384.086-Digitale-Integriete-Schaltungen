library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

architecture behavioral of register_file is

    -- Define Memory
    type RegisterBank is array ( 0 to 7 ) of std_logic_vector(15 downto 0);
    
    -- Declare the Memory with Proper initialization
    signal R : RegisterBank := (others => X"0000");
    

    signal s_out : std_logic_vector(15 downto 0);

    signal R0_W_sig : std_logic_vector(15 downto 0);
    signal R0_W_sig2 : std_logic_vector(15 downto 0);
    signal R0_R_sig : std_logic_vector(15 downto 0);
    signal R0_W_SHIFTED_sig : std_logic_vector(15 downto 0);
    
    signal R_0 : std_logic_vector(15 downto 0);
    signal R_1 : std_logic_vector(15 downto 0);
    signal R_2 : std_logic_vector(15 downto 0);
    signal R_3 : std_logic_vector(15 downto 0);
    signal R_4 : std_logic_vector(15 downto 0);
    signal R_5 : std_logic_vector(15 downto 0);
    signal R_6 : std_logic_vector(15 downto 0);
    signal R_7 : std_logic_vector(15 downto 0);

    
    
begin

    R_0 <= R(0);
    R_1 <= R(1);
    R_2 <= R(2);
    R_3 <= R(3);
    R_4 <= R(4);
    R_5 <= R(5);
    R_6 <= R(6);
    R_7 <= R(7);


    -- Process to handle access to read and write access
    p1 : process( CLK, RA1, WE2, WA2 )

    variable R0_W : std_logic_vector(15 downto 0);
    variable R0_R : std_logic_vector(15 downto 0);
    variable R0_W_SHIFTED : std_logic_vector(15 downto 0);

    -- Address Variables
    variable W_ADDR1 : integer range 0 TO 7;
    variable W_ADDR2 : integer range 0 TO 7;
    variable R_ADDR1 : integer range 0 TO 7;
    
    begin

        W_ADDR1 := to_integer(unsigned(WA1));
        W_ADDR2 := to_integer(unsigned(WA2));
        R_ADDR1 := to_integer(unsigned(RA1));

        -- ASYNC Access to register 1
        if WE2 = '1' and RA1 = "000" then
            R0_R := R(0); 
            R0_R(W_ADDR2) := IN2; -- Put Input at the right position
            Output <= R0_R; -- Shift to output
            --R(0) <= R0_R; -- store it anyway
            --Output(0) <= IN2;
        end if;


        if rising_edge(CLK) then

            if WE1 = '1' and WA1 = RA1 then
                Output <= IN1;
            else 
                Output <= R(R_ADDR1);
            end if ;

            if WE1 = '1' and WA1 /= "000" then 
                R(W_ADDR1) <= IN1;
            end if;

            if WE2 = '1' then
                R0_W := R(0); 
                R0_W(W_ADDR2) := IN2; -- Put Input at the right position
                R(0) <= R0_W;
            end if;

        end if ;
    end process ; -- p1


end behavioral;
