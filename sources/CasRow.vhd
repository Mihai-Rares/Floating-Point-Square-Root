----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2022 20:10:02
-- Design Name: 
-- Module Name: CasRow - Behavioral
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

entity CasRow is
    Generic ( n: natural range 2 to natural'high);
    Port ( qin, xl1, xl2: in std_logic; 
           din: in std_logic_vector(0 to n-2);
           rin: in std_logic_vector(0 to n-1);
           rout: out std_logic_vector(0 to n+1);
           dout: out std_logic_vector(0 to n-1);
           qout: out std_logic);
end CasRow;

architecture Behavioral of CasRow is
signal q, c: std_logic_vector (0 to n);
signal d: std_logic_vector (0 to n-1);
begin
    d <= din & q(n-1);
    q(0) <= qin; 
    qout <= c(0);
   rowBody: for i in 0 to n-1 generate
        cas: entity work.CAS port map ( din => d(i),
                                        qin => q(i),
                                        x => rin(i),
                                        cin => c(i+1),
                                        qout => q(i+1),
                                        dout => dout(i),
                                        r => rout(i),
                                        cout => c(i) );
        end generate;
    rowEnd: entity work.CasRowEnd port map ( qin => q(n), x1 => xl1, x2 => xl2, cout => c(n), r1 => rout(n), r2 => rout(n+1) );
end Behavioral;
