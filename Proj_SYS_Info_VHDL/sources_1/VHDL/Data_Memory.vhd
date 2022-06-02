----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 10:42:00
-- Design Name: 
-- Module Name: Data_Memory - Behavioral
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

entity Data_Memory is
    Port ( inAddr : in STD_LOGIC_VECTOR (7 downto 0);
           inData : in STD_LOGIC_VECTOR (7 downto 0);
           readWrite : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           outData : out STD_LOGIC_VECTOR (7 downto 0));
end Data_Memory;

architecture Behavioral of Data_Memory is
type tab is array(15 downto 0) of std_logic_vector(7 downto 0);
signal tabRegistre : tab;
--signal index: std_logic_vector(3 downto 0);
begin
    process
    begin
        wait until clk'event and clk = '0';
            if rst = '1' then
                for i in 0 to 15 loop
                    tabRegistre(i) <= "00000000";
                end loop;
            end if;
            if readWrite = '1' then
                outData <= tabRegistre(to_integer(unsigned(inAddr)));
            else 
                tabRegistre(to_integer(unsigned(inAddr))) <= inData;
            end if;
    end process;
end Behavioral;
