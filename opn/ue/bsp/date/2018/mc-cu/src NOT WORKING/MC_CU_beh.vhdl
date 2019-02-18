library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture behavior of MC_CU is

    -- Define enumeration for the instruction states
    type operation_mode is (idle, fetch, decode, exec1, exec2);
    
    -- current operation
    signal current_state : operation_mode := fetch;

    signal  current_state_index : std_logic_vector(2 downto 0) := "001";
    constant STATE_INDEX_IDLE   : std_logic_vector(2 downto 0) := "000";
    constant STATE_INDEX_FETCH  : std_logic_vector(2 downto 0) := "001";
    constant STATE_INDEX_DECODE : std_logic_vector(2 downto 0) := "010";
    constant STATE_INDEX_EXEC1  : std_logic_vector(2 downto 0) := "011";
    constant STATE_INDEX_EXEC2  : std_logic_vector(2 downto 0) := "100";

    signal possible_branching_in_progess : std_logic := '0';

    -- OP codes
    constant OP_ALU   : std_logic_vector(5 downto 0) := "000000";
    constant OP_BNE   : std_logic_vector(5 downto 0) := "000101";

    -- Function codes
    constant FUNCT_OR : std_logic_vector(5 downto 0) := "100101";
    
    -- ALU Control Signals
    constant ALU_CTRL_ADD : std_logic_vector(2 downto 0) := "010";
    constant ALU_CTRL_SUB : std_logic_vector(2 downto 0) := "000";
    constant ALU_CTRL_OR  : std_logic_vector(2 downto 0) := "101";
    
    -- ALU Souce A Selection
    constant ALU_SRC_A_PC  : std_logic := '0';
    constant ALU_SRC_A_REG : std_logic := '1';

    -- ALU Source B Selection
    constant ALU_SRC_B_REG              : std_logic_vector(1 downto 0) := "00";
    constant ALU_SRC_B_4                : std_logic_vector(1 downto 0) := "01";
    constant ALU_SRC_B_IM_VALUE         : std_logic_vector(1 downto 0) := "10";
    constant ALU_SRC_B_IM_VALUE_SHIFTED : std_logic_vector(1 downto 0) := "11";
    
    -- PC Source
    constant PC_SRC_ALU    : std_logic_vector(1 downto 0) := "00";
    constant PC_SRC_STORED : std_logic_vector(1 downto 0) := "01";
    constant PC_SRC_JUMP   : std_logic_vector(1 downto 0) := "10";

    -- Instruciton Or Data Memory Selection
    constant SELECT_INSTRUCTION : std_logic := '0';
    constant SELECT_DATA        : std_logic := '1';

begin

    update_state : process( clk )
    begin
        if rising_edge(clk) then
            case( current_state ) is
                when idle =>
                    current_state <= fetch;
                    current_state_index <= STATE_INDEX_FETCH;
                -- when fetch =>
                --     current_state <= decode;
                --     current_state_index <= STATE_INDEX_DECODE;
                -- when decode =>
                --     current_state <= exec1;
                --     current_state_index <= STATE_INDEX_EXEC1;
                -- when exec1 =>
                --     if Opcode = OP_ALU and Funct = FUNCT_OR then
                --         -- For the OR operation we need an extra execution cycle
                --         current_state <= exec2;
                --         current_state_index <= STATE_INDEX_EXEC2;
                --     elsif Opcode = OP_BNE then
                --         current_state <= fetch;
                --         current_state_index <= STATE_INDEX_FETCH;
                --         --possible_branching_in_progess <= '0';
                --     else 
                --         current_state <= fetch;
                --         current_state_index <= STATE_INDEX_FETCH;
                --     end if;
                -- when exec2 =>
                --     current_state <= fetch;
                --     current_state_index <= STATE_INDEX_FETCH;
                when others =>
                    -- this should not be possible but for the sake of completeness
                    current_state <= fetch;
                    current_state_index <= STATE_INDEX_FETCH;
                    -- possible_branching_in_progess <= '0';
            end case;
        end if;
    end process; -- update_state

    -- Operate on each clock cycle but also perform async updates if the ZERO flag changes
    main : process(Zero, current_state) 
    begin
        case( current_state ) is
            when fetch =>
                -- During the fetch clock cycle the instruction is read from 
                -- the current program counter value (PC) and is saved to the 
                -- instruction register. Also during the fetch clock cycle 
                -- the PC register is incremented by 4 using the ALU.
                
                IRWrite     <= '1'; -- write the old PC to instruction register 
                MemWrite    <= '0';
                IorD        <= SELECT_INSTRUCTION;
                PCWrite     <= '1'; -- Overwrite the PC with the new value
                PCSrc       <= PC_SRC_ALU;
                ALUControl  <= ALU_CTRL_ADD;
                ALUSrcB     <= ALU_SRC_B_4; -- add constant of 4
                ALUSrcA     <= ALU_SRC_A_PC; -- Select PC
                RegWrite    <= '0';
                MemtoReg    <= '0';
                RegDst      <= '0';
            
            when decode =>
                -- The next clock cycle is used to decode the instruction in the control
                -- unit. Because the instruction might be a bne instruction which might 
                -- lead to a branch to a new program counter value, this new program 
                -- counter value has to be calculated during the decode clock cycle. 
                -- This means during decode the current PC value has to be added to the 
                -- potential immediate value in the ALU. The potential immediate value 
                -- has to be shifted left by 2 Bits beforehand. This makes the branching 
                -- address available in the register which saves the ALU Result.

                IRWrite     <= '0';
                MemWrite    <= '0';
                IorD        <= SELECT_INSTRUCTION;
                PCWrite     <= '0'; -- Overwrite the PC with the new value
                PCSrc       <= "00";
                ALUControl  <= ALU_CTRL_ADD;
                ALUSrcB     <= ALU_SRC_B_IM_VALUE_SHIFTED; -- shift the IM Value
                ALUSrcA     <= ALU_SRC_A_PC; -- Select PC
                RegWrite    <= '0';
                MemtoReg    <= '0';
                RegDst      <= '0';

            when exec1 =>  
                case( Opcode ) is      
                    when OP_ALU =>
                        -- OR OPERATION
                        if Funct = FUNCT_OR then -- OR OPERATION
                            IRWrite     <= '0'; 
                            MemWrite    <= '0';
                            IorD        <= SELECT_DATA;
                            PCWrite     <= '0'; 
                            PCSrc       <= "00";
                            ALUControl  <= ALU_CTRL_OR; -- SEND OR Signal
                            ALUSrcB     <= ALU_SRC_B_REG; -- Select Register 2
                            ALUSrcA     <= ALU_SRC_A_REG; -- Select Register 1
                            RegWrite    <= '0';
                            MemtoReg    <= '0';
                            RegDst      <= '0';
                        end if;
                    
                    -- BRANCH NOT EQUALS
                    when OP_BNE =>
                        IRWrite     <= '0'; 
                        MemWrite    <= '0';
                        IorD        <= SELECT_DATA;
                        PCWrite     <= '0'; -- this is set seperatly
                        PCSrc       <= PC_SRC_STORED;
                        ALUControl  <= ALU_CTRL_SUB; -- SEND Sub Signal
                        ALUSrcB     <= ALU_SRC_B_REG; -- Select Register 2
                        ALUSrcA     <= ALU_SRC_A_REG; -- Select Register 1
                        RegWrite    <= '0';
                        MemtoReg    <= '0';
                        RegDst      <= '0';

                        -- Set a flag that branching is in progress
                        if possible_branching_in_progess = '0' and  current_state'event then
                            possible_branching_in_progess <= '1'; -- possible branching in progress
                        elsif possible_branching_in_progess = '1' and Zero'event and Zero = '0' then
                             possible_branching_in_progess <= '0'; -- possible branching in progress
                             PCWrite <= '1';
                        else
                             PCWrite <= '0';
                        end if;

                        

                    when others =>
                        -- should not happen anyway but set everything to zero 
                        -- to prevent latches
                        IRWrite     <= '0'; 
                        MemWrite    <= '0';
                        IorD        <= '0';
                        PCWrite     <= '0'; 
                        PCSrc       <= "00";
                        ALUControl  <= ALU_CTRL_ADD; 
                        ALUSrcB     <= "00"; 
                        ALUSrcA     <= '0'; 
                        RegWrite    <= '0'; 
                        MemtoReg    <= '0'; 
                        RegDst      <= '0'; 
                end case ;
            when exec2 =>
                if Opcode = OP_ALU and Funct = FUNCT_OR then
                    IRWrite     <= '0'; 
                    MemWrite    <= '0';
                    IorD        <= SELECT_DATA;
                    PCWrite     <= '0'; 
                    PCSrc       <= "00";
                    ALUControl  <= ALU_CTRL_OR; 
                    ALUSrcB     <= ALU_SRC_B_REG; 
                    ALUSrcA     <= ALU_SRC_A_REG; 
                    RegWrite    <= '1'; -- write reg
                    MemtoReg    <= '0'; -- select ALU result to store
                    RegDst      <= '1'; -- select destination register
                else 
                    -- should not happen anyway but set everything to zero 
                    -- to prevent latches
                    IRWrite     <= '0'; 
                    MemWrite    <= '0';
                    IorD        <= '0';
                    PCWrite     <= '0'; 
                    PCSrc       <= "00";
                    ALUControl  <= ALU_CTRL_ADD; 
                    ALUSrcB     <= "00"; 
                    ALUSrcA     <= '0'; 
                    RegWrite    <= '0'; 
                    MemtoReg    <= '0'; 
                    RegDst      <= '0'; 
                end if;    
            when others =>
                -- should not happen anyway but set everything to zero 
                -- to prevent latches
                IRWrite     <= '0'; 
                MemWrite    <= '0';
                IorD        <= '0';
                PCWrite     <= '0'; 
                PCSrc       <= "00";
                ALUControl  <= ALU_CTRL_ADD; 
                ALUSrcB     <= "00"; 
                ALUSrcA     <= '0'; 
                RegWrite    <= '0'; 
                MemtoReg    <= '0'; 
                RegDst      <= '0'; 
        end case ;
    end process ; -- main

end behavior;