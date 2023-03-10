----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2022 22:36:02
-- Design Name: 
-- Module Name: FpSQRT - Behavioral
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

entity FpSQRT is
    generic ( expLen: positive:= 8;
              mLen: positive := 23);
    Port ( exponent: std_logic_vector(expLen-1 downto 0);
           mantissa: std_logic_vector(mLen-1 downto 0);
           exponentOUT: out std_logic_vector(expLen-1 downto 0);
           mantissaOUT: out std_logic_vector(mLen-1 downto 0));
end FpSQRT;

architecture Behavioral of FpSQRT is
constant bias: signed (expLen downto 0):=TO_SIGNED(2**(expLen-1)-1, expLen+1);
constant FXP_SIZE: integer:= 2*((mLen+1)/2+1);
constant nanVal : std_logic_vector(expLen + 1 downto 0) := (others => '1');
constant infVal : std_logic_vector(expLen downto 0) := (others => '1');
signal exp, denormalized_exp, logicalExponent, shiftedExp: signed(expLen downto 0);
signal normalized_exp: std_logic_vector(expLen downto 0);
signal denormalized_mantissa, fixPSQRT_imput: std_logic_vector(0 to FXP_SIZE-1);
signal computedMantissa: std_logic_vector(mLen-1 downto 0);
signal err_flag, nan, inf: std_logic := '0';
signal dummy : std_logic_vector(mLen to FXP_SIZE/2-1);
begin
    nan <= '1' when exponent & mantissa(mLen-1 downto mLen-2) = nanVal else '0';
    inf <= '1' when exponent & mantissa(mLen-1) = infVal else '0';
    err_flag <= nan or inf;
    
    exp <= signed("0"&exponent) - bias;
    
    denormalized_mantissa(0)<='1';
    denormalized_mantissa(1 to mLen)<=mantissa;
    denormalized_mantissa(mLen+1 to FXP_SIZE-1)<=(others=>'0');
    
    denormalized_exp <= exp + TO_SIGNED(1, expLen+1) when exp(0)='1' else exp + TO_SIGNED(2, expLen+1);
--    exponentOUT <= std_logic_vector((denormalized_exp(expLen-1)&denormalized_exp(expLen-1 downto 1)) + BIAS) when err_flag = '0' 
--                   else exponent;
    fixPSQRT_imput<=denormalized_mantissa when exp(0)='1' else '0'&denormalized_mantissa(0 to FXP_SIZE-2);
    fixed_point_sqrt: entity WORK.fixedPointSQRT generic map (FXP_SIZE/2) 
                                                 port map ( x => fixPSQRT_imput,
--                                                 qt(0 to mLen-1) => computedMantissa,
--                                                 qt(mLen to FXP_SIZE/2-1) => dummy);
                                                 qt(0 to FXP_SIZE/2-1) => computedMantissa(mLen-1 downto mLen-1 - FXP_SIZE/2 + 1));
    computedMantissa(mLen - FXP_SIZE/2 - 1 downto 0) <= (others => '0');
    mantissaOUT <= mantissa when err_flag = '1' else 
                   computedMantissa(mLen-2 downto 0)&"0" when computedMantissa(mLen-1) = '1' else 
                   computedMantissa(mLen-3 downto 0)&"00";
    shiftedExp <= denormalized_exp(expLen)&denormalized_exp(expLen downto 1);
    normalized_exp <= std_logic_vector(shiftedExp - TO_SIGNED(1, expLen+1) + BIAS) when computedMantissa(mLen-1)='1' else 
                         std_logic_vector(shiftedExp - TO_SIGNED(2, expLen+1) + BIAS);
    exponentOUT <= normalized_exp(expLen - 1 downto 0) when err_flag = '0' 
                   else exponent;
end Behavioral;
