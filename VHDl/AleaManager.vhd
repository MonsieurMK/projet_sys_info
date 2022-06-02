----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2022 11:56:52
-- Design Name: 
-- Module Name: AleaManager - Behavioral
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

entity AleaManager is
    Port (
    inOP1 : in STD_LOGIC_VECTOR (7 downto 0);
    inB1 : in STD_LOGIC_VECTOR (7 downto 0);
    inC1 : in STD_LOGIC_VECTOR (7 downto 0);
    inOP2 : in STD_LOGIC_VECTOR (7 downto 0);
    inA2 : in STD_LOGIC_VECTOR (7 downto 0);
    inOP3 : in STD_LOGIC_VECTOR (7 downto 0);
    inA3 : in STD_LOGIC_VECTOR (7 downto 0);
    inOP4 : in STD_LOGIC_VECTOR (7 downto 0);
    inA4 : in STD_LOGIC_VECTOR (7 downto 0);
    isNOP : OUT STD_LOGIC);
end AleaManager;

architecture Behavioral of AleaManager is
    signal CheckFirstOP, CheckOtherOP : STD_LOGIC;
begin
    
    -- check l'opération voulus pour savoir si elle fais une opération de lecture (toutes sauf AFC)
    CheckFirstOP <= '1' when (
        inOP1 = ("00000001" or
                 "00000010" or
                 "00000011" or
                 "00000100" or
                 "00000101" or
                 "00001000" or
                 "00000111")) else '0';
                 
    -- check toutes les opérations sauf STORE pour prevoir une écriture (hormis le premier pipeline)
    CheckOtherOP <= '1' when ( 
        (inOP2 or inOP3 or inOP4) =("00000001" or
                                    "00000010" or
                                    "00000011" or
                                    "00000100" or
                                    "00000101" or
                                    "00000110" or
                                    "00000111")) else '0';
        
     isNOP <= '1' when (CheckFirstOP = '1' and CheckOtherOP = '1' and (( inB1 or inC1 ) = ( inA2 or inA3 or inA4))) else '0';
end Behavioral;
