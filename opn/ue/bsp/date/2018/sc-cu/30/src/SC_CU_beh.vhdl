library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture behavioral of SC_CU is	


constant OP_SW : std_logic_vector(5 downto 0) := "101011";
constant OP_J : std_logic_vector(5 downto 0) := "000010";
constant OP_NOR : std_logic_vector(5 downto 0) := "000000";
constant OP_LW : std_logic_vector(5 downto 0) := "100011";
constant FUNCT_NOR : std_logic_vector(5 downto 0) := "100111";
constant ALU_CTR_ADD : std_logic_vector(2 downto 0) := "000";
constant ALU_CTR_NOR : std_logic_vector(2 downto 0) := "111";

begin
main : process( Zero, Opcode, Funct)
begin
    case Opcode is
        when OP_NOR => -- ALU OPERATION ?

            -- Check if FUNCT is valid
            if Funct = "100111" then
                ALUControl <= ALU_CTR_NOR;
                RegDst     <= '1'; -- Dest is bits 11-15
                Branch     <= '0';
                Jump       <= '0';
                MemRead    <= '0';
                MemtoReg   <= '0';
                MemWrite   <= '0';
                ALUSrc     <= '0'; -- Register source
                RegWrite   <= '1'; -- write to register
            else
                ALUControl <= ALU_CTR_NOR;
                RegDst     <= '0';
                Branch     <= '0';
                Jump       <= '0';
                MemRead    <= '0';
                MemtoReg   <= '0';
                MemWrite   <= '0';
                ALUSrc     <= '0';
                RegWrite   <= '0';
            end if;

            

        when OP_SW => -- STORE WORD
            ALUControl <= ALU_CTR_ADD;
            RegDst     <= '0';
            Branch     <= '0';
            Jump       <= '0';
            MemRead    <= '0';
            MemtoReg   <= '0';
            MemWrite   <= '1'; -- write the memory to result address of the ALU
            ALUSrc     <= '1'; -- select the immediate value
            RegWrite   <= '0';

        when OP_LW => -- LOAD WORD
            ALUControl <= ALU_CTR_ADD;
            RegDst     <= '0';
            Branch     <= '0';
            Jump       <= '0';
            MemRead    <= '1'; -- read from memory
            MemtoReg   <= '1'; -- write to register
            MemWrite   <= '0'; -- read the memory
            ALUSrc     <= '1'; -- select the immediate value
            RegWrite   <= '1'; -- write to register
    
        when OP_J => -- JUMP
            ALUControl <= ALU_CTR_ADD;
            RegDst     <= '0';
            Branch     <= '0';
            Jump       <= '1';
            MemRead    <= '0';
            MemtoReg   <= '0';
            MemWrite   <= '0'; -- write the memory to result address of the ALU
            ALUSrc     <= '0'; -- select the immediate value
            RegWrite   <= '0';
        when others => -- do nothing all zero
            ALUControl <= ALU_CTR_ADD;
            RegDst     <= '0';
            Branch     <= '0';
            Jump       <= '0';
            MemRead    <= '0';
            MemtoReg   <= '0';
            MemWrite   <= '0'; 
            ALUSrc     <= '0'; 
            RegWrite   <= '0';

    end case;
end process ; -- main
    

end behavioral;
