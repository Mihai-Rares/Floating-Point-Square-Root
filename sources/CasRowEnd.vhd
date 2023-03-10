----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2022 20:33:21
-- Design Name: 
-- Module Name: CasRowEnd - Behavioral
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

entity CasRowEnd is
    Port ( qin, x1, x2: in std_logic;
           cout, r1, r2: out std_logic);
end CasRowEnd;

architecture Behavioral of CasRowEnd is
signal q1, q2, c21, nq: std_logic;
begin
     nq <= not qin;
     cas1: entity work.CAS port map ( qin => qin, 
                                     din => nq,
                                     x => x1,
                                     qout => q1,
                                     r => r1,
                                     cin => c21,
                                     cout => cout);
    cas2: entity work.CAS port map ( qin => q1, 
                                     din => '1',
                                     x => x2,
                                     qout => q2,
                                     r => r2,
                                     cin => q2,
                                     cout => c21);
end Behavioral;
