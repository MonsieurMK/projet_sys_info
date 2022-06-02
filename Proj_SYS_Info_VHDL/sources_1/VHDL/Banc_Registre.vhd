----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 09:59:36
-- Design Name: 
-- Module Name: Banc_Registre - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Banc_Registre is
    Port ( getA : in STD_LOGIC_VECTOR (3 downto 0);
           getB : in STD_LOGIC_VECTOR (3 downto 0);
           inAddr : in STD_LOGIC_VECTOR (3 downto 0);
           allowWriting : in STD_LOGIC;
           inData : in STD_LOGIC_VECTOR (7 downto 0);
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           outQA : out STD_LOGIC_VECTOR (7 downto 0);
           outQB : out STD_LOGIC_VECTOR (7 downto 0));
end Banc_Registre;

architecture Behavioral of Banc_Registre is
type tab is array(15 downto 0) of std_logic_vector(7 downto 0);
signal tabRegistre : tab;
begin
    process
    begin
        wait until clk'event and clk = '0';
            if rst = '1' then
                for i in 0 to 15 loop
                    tabRegistre(i) <= "00000000";
                end loop;
            end if;

            if allowWriting = '1' then
                tabRegistre(to_integer(unsigned(inAddr))) <= inData;
            end if;
 
    end process;
    
    outQA <= tabRegistre(to_integer(unsigned(getA)));
    outQB <= tabRegistre(to_integer(unsigned(getB)));
    
end Behavioral;
