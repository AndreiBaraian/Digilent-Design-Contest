----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2017 09:02:48 PM
-- Design Name: 
-- Module Name: clk_divider_2KHz - a_clk_divider_2KHz
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divider_4KHz is
    Port ( clk : in STD_LOGIC;          --clk in has f = 125 MHz
           clk_out : out STD_LOGIC);    --clk_out will have f = 4KHz ( T = 0.25 ms)
end clk_divider_4KHz;

architecture a_clk_divider_4KHz of clk_divider_4KHz is

         -- 125 MHz / 4Khz = 31250 ==> HIGH part of clk_out will be 
         -- from 0 to 15625 and LOW part again from 0 to 15625
                                
signal cnt : std_logic_vector(13 downto 0) := (others => '0');
    
begin

    clk_divider_to_4khz: process(clk)
    variable clock: std_logic := '0';
    
    begin
        if rising_edge(clk) then
            if cnt = 15625  then
                clock := not clock;
                cnt(13 downto 1) <= (others => '0');
                cnt(0) <= '1';
            else
                cnt <= cnt + 1;
            end if;
       end if;
    
    clk_out <= clock;
    end process clk_divider_to_4khz;

end a_clk_divider_4KHz;
