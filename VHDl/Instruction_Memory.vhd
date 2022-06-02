----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 11:22:06
-- Design Name: 
-- Module Name: Instruction_Memory - Behavioral
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

entity Instruction_Memory is
    Port ( inAddr : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           outData : out STD_LOGIC_VECTOR (31 downto 0));
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
type tab is array(0 to 255) of std_logic_vector(31 downto 0);
signal tabMemory : tab;

begin

    tabMemory <= ("00000010000001000000000000000001","00000010000001000000000000000010","00010000000001000000000100000110", others => "00000000000000000000000000000000");
--    process
--    begin
--        wait until clk'event and clk = '1';
            
            outData <= tabMemory(to_integer(unsigned(inAddr)));
--    end process;
end Behavioral;
