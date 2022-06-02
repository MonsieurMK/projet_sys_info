----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2022 14:50:59
-- Design Name: 
-- Module Name: Compteur_16bits - Behavioral
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Compteur_8bits is
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Load : in STD_LOGIC;
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           Enable : in STD_LOGIC;
           --Sens : in STD_LOGIC;
           Dout : out STD_LOGIC_VECTOR (7 downto 0));
end Compteur_8bits;

architecture Behavioral of Compteur_8bits is

    signal aux : STD_LOGIC_VECTOR(7 downto 0);
begin
    Dout <= aux;
    process
    begin
        wait until clk'event and clk = '1';
            if Reset = '1' then
                aux <= (others => '0');
                
            elsif Load = '1'then 
                    aux <= Din;
            elsif Enable = '0' then
                        --if Sens = '0' then
                            --aux <= aux - 1;
                        --else 
                aux <= aux + 1;
                        --end if;
            end if;
        
    end process;
end Behavioral;