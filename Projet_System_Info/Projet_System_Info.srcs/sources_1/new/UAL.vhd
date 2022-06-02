----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2022 16:13:04
-- Design Name: 
-- Module Name: UAL - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UAL is
    Port ( inA : in STD_LOGIC_VECTOR (7 downto 0);
           inB : in STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in STD_LOGIC_VECTOR (7 downto 0);
           --isNeg : out STD_LOGIC;
           --isOverflow : out STD_LOGIC;
           --isNull : out STD_LOGIC;
           --hasCarry : out STD_LOGIC;
           Out_S : out STD_LOGIC_VECTOR (7 downto 0));
end UAL;

architecture Behavioral of UAL is
    signal aux_out : STD_LOGIC_VECTOR(15 downto 0);
begin
    aux_out <= inA * inB;

    Out_S <= inA + inB when Ctrl_Alu = "00000001" else
             inA - inB when Ctrl_Alu = "00000011" else
             aux_out(7 downto 0) when Ctrl_Alu = "00000010" else
               std_logic_vector(unsigned(inA) / unsigned(inB)) when Ctrl_Alu = "00000100" else
               inA;
               
    --process (inA, inB, Ctrl_Alu)
    --begin
        
        
        --case Ctrl_Alu is
            -- Addition
            --when "00000001" => aux_out <=    inA + inB;  
                                        --if((inA + inB) > 2**(Out_S'length-1)-1) then 
                                        --    hasCarry <= '1'; 
                                        --else 
                                        --    hasCarry <= '0'; 
                                        --end if;  
            -- Soustraction                                  
            --when "00000010" => aux_out <=    inA - inB;  
                                        --if((inA - inB )< 0) then 
                                        --    isNeg <= '1'; 
                                        --else 
                                        --    isNeg <= '0'; 
                                        --end if; to_integer(u
                                        
            -- Multiplication
            --when "00000011" => aux_out <=    inA * inB;
                                        --if((inA * inB) > 2**(Out_S'length-1)-1) then 
                                        --   isOverflow <= '1'; 
                                        --else 
                                        --   isOverflow <= '0'; 
                                        --end if;     
                                                        
            --when "00000100" => aux_out <= std_logic_vector(unsigned(inA) / unsigned(inB)); -- Division -- a vérifier car "/" n'existe pas
            
            -- Logical Shift Left -- a refaire
            --when "00001001" => aux_out <= std_logic_vector(shift_left(unsigned(inA), to_integer(unsigned(inB)))); 
            
            -- Logical Shift Right -- a refaire
            --when "00001010" => aux_out <= std_logic_vector(shift_right(unsigned(inA), to_integer(unsigned(inB)))); 
            
            --when others => aux_out <= inA;                             -- Other
        --end case;
                

        --if(aux_out = "00000000") then
        --    isNull <= '1';
        --else
        --    isNull <= '0';
        --end if;
        
        
        --Out_S <= aux_out;
    --end process;
end Behavioral;
