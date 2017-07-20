----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2017 01:29:20 PM
-- Design Name: 
-- Module Name: clk_divider_50KHz - a_clk_divider_50KHz
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divider_100KHz is
    Port ( clk : in STD_LOGIC;
           clk100khz : out STD_LOGIC);
end clk_divider_100KHz;

architecture a_clk_divider_100KHz of clk_divider_100KHz is

begin
    
    --zybo has a clock of 125 MHz frequency
    --we divide that frequency to 100KHz, because a clk with f = 100KHz has a period of 10us
    --(and 50% duty cycle), hence, the trigger will be HIGH one period (10us) of that clk 
    
    clk_div: process(clk)
    
    variable cnt: std_logic_vector(9 downto 0) := (others => '0');
    variable new_clk: std_logic := '1';
    variable i: integer := 1;
    --125MHz/100KHz = 1250, so the HIGH part will be from 0 to 625 and the LOW part from 626 to 1250 (or again from 0 to 625)
    begin
        if rising_edge(clk) then
            if cnt = 625 +  i then
                new_clk := not new_clk;
                cnt := (others => '0');
                i := 1 - i;
            else
                cnt := cnt + 1;
            end if;
          
        end if;
        
    clk100khz <= new_clk;
    end process clk_div;

end a_clk_divider_100KHz;
