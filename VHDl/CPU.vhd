----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2022 11:54:34
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
    Port ( clkCPU : in STD_LOGIC;
           outACPU : out STD_LOGIC_VECTOR (7 downto 0);
           outBCPU : out STD_LOGIC_VECTOR (7 downto 0);
           outCCPU : out STD_LOGIC_VECTOR (7 downto 0);
           outOPCPU : out STD_LOGIC_VECTOR (7 downto 0);
           ResetCPU : in STD_LOGIC);
end CPU;

architecture Behavioral of CPU is

    component Instruction_Memory is
    Port ( inAddr : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           outData : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component Banc_Registre is
        Port ( getA : in STD_LOGIC_VECTOR (3 downto 0);
               getB : in STD_LOGIC_VECTOR (3 downto 0);
               inAddr : in STD_LOGIC_VECTOR (3 downto 0);
               allowWriting : in STD_LOGIC;
               inData : in STD_LOGIC_VECTOR (7 downto 0);
               rst : in STD_LOGIC;
               clk : in STD_LOGIC;
               outQA : out STD_LOGIC_VECTOR (7 downto 0);
               outQB : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component UAL is
        Port ( inA : in STD_LOGIC_VECTOR (7 downto 0);
               inB : in STD_LOGIC_VECTOR (7 downto 0);
               Ctrl_Alu : in STD_LOGIC_VECTOR (7 downto 0);
               --isNeg : out STD_LOGIC;
               --isOverflow : out STD_LOGIC;
               --isNull : out STD_LOGIC;
               --hasCarry : out STD_LOGIC;
               Out_S : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Data_Memory is
        Port ( inAddr : in STD_LOGIC_VECTOR (7 downto 0);
               inData : in STD_LOGIC_VECTOR (7 downto 0);
               readWrite : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk : in STD_LOGIC;
               outData : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Pipeline is
        Port ( inOp : in STD_LOGIC_VECTOR (7 downto 0);
               inA : in STD_LOGIC_VECTOR (7 downto 0);
               inB : in STD_LOGIC_VECTOR (7 downto 0);
               inC : in STD_LOGIC_VECTOR (7 downto 0);
               clk : in STD_LOGIC;
               outOp : out STD_LOGIC_VECTOR (7 downto 0);
               outA : out STD_LOGIC_VECTOR (7 downto 0);
               outB : out STD_LOGIC_VECTOR (7 downto 0);
               outC : out STD_LOGIC_VECTOR (7 downto 0));
               
    end component;
    
    component Compteur_8bits is
        Port ( clk : in STD_LOGIC;
               Reset : in STD_LOGIC;
               Load : in STD_LOGIC;
               Din : in STD_LOGIC_VECTOR (7 downto 0);
               Enable : in STD_LOGIC;
               --Sens : in STD_LOGIC;
               Dout : out STD_LOGIC_VECTOR (7 downto 0));
               
    end component;
    
    
    component AleaManager is
        Port  ( inOP1 : in STD_LOGIC_VECTOR (7 downto 0);
                inB1 : in STD_LOGIC_VECTOR (7 downto 0);
                inC1 : in STD_LOGIC_VECTOR (7 downto 0);
                inOP2 : in STD_LOGIC_VECTOR (7 downto 0);
                inA2 : in STD_LOGIC_VECTOR (7 downto 0);
                inOP3 : in STD_LOGIC_VECTOR (7 downto 0);
                inA3 : in STD_LOGIC_VECTOR (7 downto 0);
                inOP4 : in STD_LOGIC_VECTOR (7 downto 0);
                inA4 : in STD_LOGIC_VECTOR (7 downto 0);
                isNOP : OUT STD_LOGIC);
    end component;
    
    signal inAddr1 : STD_LOGIC_VECTOR (7 downto 0);
    signal outData_instructMem : STD_LOGIC_VECTOR (31 downto 0);
    signal outOP1, outA1, outB1, outC1, auxOP: STD_LOGIC_VECTOR (7 downto 0);
    signal outOP2, outA2, outB2, outC2, inB2: STD_LOGIC_VECTOR (7 downto 0);
    signal outOP3, outA3, outB3, outC3, inB3: STD_LOGIC_VECTOR (7 downto 0);
    signal outOP4, outA4, outB4, outC4, inB4: STD_LOGIC_VECTOR (7 downto 0);
    signal outBancReg, inAddrMemDonnee, outMemDonnee, inDataMemDonnee: STD_LOGIC_VECTOR (7 downto 0); 
    signal isWritingAllowed, isWritingMem, isNop : STD_LOGIC;
   

begin
    outOPCPU <= outOP4;
    outACPU <= outA4;
    outBCPU <= outB4;
    outCCPU <= outC4;
    ip : Compteur_8bits port map(clk => clkCPU, Reset => ResetCPU, Enable => isNop, Dout => inAddr1, Din => "00000000", Load => '0');
    
    instructMemory : Instruction_Memory port map (
        inAddr => inAddr1,
        clk => clkCPU,
        outData => outData_instructMem);
    
    pipe1 : Pipeline port map (
        inOp => outData_instructMem(7 downto 0),
        inA => outData_instructMem(15 downto 8),
        inB => outData_instructMem(23 downto 16),
        inC => outData_instructMem(31 downto 24),
        clk => clkCPU,
        outOp => outOp1,
        outA => outA1,
        outB => outB1,
        outC => outC1);
               
    bancRegistre : Banc_Registre port map (
        getA => outB1(3 downto 0),
        getB => outC1(3 downto 0),
        outQA => outBancReg,
        inAddr => outA4(3 downto 0), 
        allowWriting => isWritingAllowed,
        inData => outB4,
        rst => resetCPU,
        clk => clkCPU);        
                                                      
    pipe2 : Pipeline port map (
        inOp => auxOp,
        inA => outA1,
        inB => inB2,
        inC => outC1,
        clk => clkCPU,
        outOp => outOp2,
        outA => outA2,
        outB => outB2,
        outC => outC2);
                 
    ual1 : UAL port map (
        inA => outB2,
        inB => outC2,
        Ctrl_Alu => outOP2,
        Out_S => inB3);
                
    pipe3 : Pipeline port map (
        inOp => outOp2, 
        inA => outA2, 
        inB => inB3, 
        inC => outC2, 
        clk => clkCPU,
        outOp => outOp3, 
        outA => outA3, 
        outB => outB3, 
        outC => outC3);
                      
    memDonnee :  Data_Memory port map ( 
        inAddr => inAddrMemDonnee,
        inData => inDataMemDonnee,
        readWrite => isWritingMem,
        rst => ResetCPU,
        clk => clkCPU, 
        outData => outMemDonnee);     
                               
    pipe4 : Pipeline port map (
        inOp => outOp3,
        inA => outA3,
        inB => inB4,
        inC => "00000000",
        clk => clkCPU,
        outOp => outOp4,
        outA => outA4,
        outB => outB4,
        outC => outC4);
    
    alea : AleaManager port map(
        inOp1 => outData_instructMem(7 downto 0),
        inB1 => outData_instructMem(23 downto 16),
        inC1 => outData_instructMem(31 downto 24),
        inOP2 => outOP1,
        inA2 => outA1,
        inOP3 => outOP2,
        inA3 => outA2,
        inOP4 => outOP3,
        inA4 => outA3,
        isNOP => isNop); 
    
    auxOP <= X"ff" when isNop = '1' else outOP1;
    inB2 <= outBancReg when auxOp = "00000101" else outB1; 
    isWritingMem <= '1' when outOp3 = "00000111" else '0';
    inAddrMemDonnee <= outA3 when outOp3= "00001000";
    inDataMemDonnee <= outB3 when outOp3= "00001000";
    isWritingAllowed <= '1' when (outOp4 = "00000110" or outOp4 ="00000001" or outOp4 ="00000011" or outOp4 ="00000010" or outOp4 ="00000100" or outOp4 ="00000111" or outOp4 ="00000101" or outOp4 ="00001000") else '0';
    inB4 <= outMemDonnee when outOp3 = "00000111" else outB3;    

    
end Behavioral;
