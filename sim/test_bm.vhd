----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- https://zero.sci-hub.se/389/21bd8906524889052f9e94a55b29cffe/samavi2008.pdf#%5B%7B%22num%22%3A271%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22FitR%22%7D%2C0%2C662%2C578%2C662%5D
-- Create Date: 02.11.2022 01:30:54
-- Design Name: 
-- Module Name: test_bm - Behavioral
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

entity test_bm is
--  Port ( );
end test_bm;

architecture Behavioral of test_bm is
--constant n: integer:= 8;
--signal q: std_logic_vector(0 to n-1);
--signal qt, cout, r1, r2: std_logic;
--signal x, r: std_logic_vector(0 to 2*n-1);
--signal s1: std_logic_vector (0 to 3):="0001";
--signal s2: std_logic_vector(3 downto 0);
--signal dout: std_logic_vector(0 to 1);
constant mLen : integer := 52;
constant expLen : integer :=11;
constant test_vect_len: integer := 4;
type test_vector_type is array(0 to test_vect_len-1) of std_logic_vector(expLen + mLen downto 0);
constant PROPAGATION_DELAY: TIME := 10 ns; 
constant number_in:    test_vector_type:=( x"3FD0000000000000", x"4022000000000000", x"4059000000000000", x"4079000000000000");
constant number_out:    test_vector_type:=(x"3FE0000000000000", x"4008000000000000", x"4024000000000000", x"4034000000000000");
signal number, numberOut : std_logic_vector(mLen + expLen downto 0);
signal mantissa, mantissaout : std_logic_vector(mLen - 1 downto 0);
signal exponent, exponentout : std_logic_vector(expLen - 1 downto 0);
begin
    mantissa <= number(mLen - 1 downto 0);
    exponent <= number(mLen + expLen -1 downto mLen);
--    number <= x"40F86A0800000000";
    numberOut <= "0" & exponentOut & mantissaOut;
    fpsqrt: entity work.FpSQRT generic map (expLen, mLen) port map( exponent => exponent,
                                                       mantissa => mantissa,
                                                       exponentOut => exponentOut,
                                                       mantissaOut => mantissaOut);
    gen_next_test: process
        variable currectRez, realOutput: std_logic_vector(mLen + expLen downto 0); 
        variable nrErr: integer := 0;
        begin
            nrErr:=0;
            for i in 0 to test_vect_len-1 loop
                number <= number_in(i);
                wait for PROPAGATION_DELAY;
                currectRez := number_out(i);
                realOutput := numberOut;
                if realOutput /= currectRez then
                    report "Eroare la iteratia "
                             & INTEGER'image(i)
                            severity ERROR;
                            nrErr := nrErr + 1;
                    end if;
                end loop;           
            report "Testare terminata cu " &
                    INTEGER'image (nrErr) & " erori";          
            end process gen_next_test;  
end Behavioral;
