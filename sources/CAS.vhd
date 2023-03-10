----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2022 19:57:38
-- Design Name: 
-- Module Name: CAS - Behavioral
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

entity CAS is
    Port ( Din, Cin, qin, x: in std_logic;
           Dout, Cout, qout, r: out std_logic);
end CAS;

architecture Behavioral of CAS is
signal op2: std_logic;
begin
    qout <= qin;
    Dout <= Din;
    op2 <= Din xor qin;
    r <= x xor op2 xor cin;
    cout <= (x and op2) or (x and cin) or (op2 and cin);
end Behavioral;
