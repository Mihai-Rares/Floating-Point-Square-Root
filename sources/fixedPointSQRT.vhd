----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2022 22:10:23
-- Design Name: 
-- Module Name: fixedPointSQRT - Behavioral
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

entity fixedPointSQRT is
    Generic (n: positive range 2 to positive'high:=4);
    Port ( x: in std_logic_vector(0 to 2*n-1);
           qt: out std_logic_vector(0 to n-1);
           rm: out std_logic_vector(0 to 2*n-1));
end fixedPointSQRT;

architecture Behavioral of fixedPointSQRT is
signal d: std_logic_vector(0 to n*(n+1)/2 );
signal r: std_logic_vector(0 to (n+2)*(n+1)/2-2);
signal q: std_logic_vector(0 to n-1);
begin
    d(0) <= '0';
    firstRow: entity work.CasRowEnd port map(qin => '1', x1 => x(0), x2 => x(1),
                                             cout => q(0), r1 => r(0), r2 => r(1));
    matrix: for i in 2 to n generate
            casRow: entity work.CasRow generic map(i)
                                       port map( qin => q(i-2),
                                                 xl1 => x(2*i-2),
                                                 xl2 => x(2*i-1),
                                                 din => d((i-2)*(i-1)/2 to (i-2)*(i-1)/2+i-2),
                                                 rin => r( i*(i-1)/2-1 to i*(i+1)/2-2),
                                                 rout(0) => rm(i-2),
                                                 rout(1 to i+1) => r((i+1)*i/2-1 to (i+1)*(i+2)/2-2),
                                                 dout => d((i-1)*i/2 to (i-1)*i/2+i-1),
                                                 qout => q(i-1));
    end generate;
    qt <= q;
    rm(n-1 to 2*n-1) <= r((n+2)*(n+1)/2-n-2 to (n+2)*(n+1)/2-2);
end Behavioral;
