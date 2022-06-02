----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 11:32:50
-- Design Name: 
-- Module Name: PIpeline - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pipeline is
    Port ( inOp : in STD_LOGIC_VECTOR (7 downto 0);
           inA : in STD_LOGIC_VECTOR (7 downto 0);
           inB : in STD_LOGIC_VECTOR (7 downto 0);
           inC : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           outOp : out STD_LOGIC_VECTOR (7 downto 0);
           outA : out STD_LOGIC_VECTOR (7 downto 0);
           outB : out STD_LOGIC_VECTOR (7 downto 0);
           outC : out STD_LOGIC_VECTOR (7 downto 0));

end Pipeline;

architecture Behavioral of Pipeline is
 
begin
    process
    begin
        wait until clk'event and clk = '1';
            outA <= inA;
            outB <= inB;
            outC <= inC;
            outOp <= inOp;
            
    end process;
end Behavioral;
