----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2022 14:49:02
-- Design Name: 
-- Module Name: Sim_Proc - Behavioral
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

entity Sim_Proc is
    -- Port ();
end Sim_Proc;

architecture Behavioral of Sim_Proc is
component CPU is 
    Port ( clkCPU : in STD_LOGIC;
           outACPU: out STD_LOGIC_VECTOR (7 downto 0);
           outBCPU: out STD_LOGIC_VECTOR (7 downto 0);                 
           outCCPU: out STD_LOGIC_VECTOR (7 downto 0);
           outOPCPU: out STD_LOGIC_VECTOR (7 downto 0);
           ResetCPU : in STD_LOGIC);
end component;

signal clkSim: STD_LOGIC;
signal outASim: STD_LOGIC_VECTOR(7 downto 0);
signal outBSim: STD_LOGIC_VECTOR(7 downto 0);
signal outCSim: STD_LOGIC_VECTOR(7 downto 0);
signal outOPSim: STD_LOGIC_VECTOR(7 downto 0);
signal resetSim: STD_LOGIC;
begin
    Proc : CPU port map (clkCPU => clkSim, outACPU => outASim, outBCPU => outBSim, outCCPU => outCSim, outOPCPU => outOPSim, ResetCPU => resetSim);
    
    process
    begin
        wait for 100ns;
        if clkSim = '1' then
            clkSim <= '0';
        else
            clkSim <= '1';
        end if;
    end process;
resetSim <= '1', '0' after 200ns;
end Behavioral;
