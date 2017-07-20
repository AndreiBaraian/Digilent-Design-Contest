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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divider_50KHz is
    Port ( clk : in STD_LOGIC;
           clk50khz : out STD_LOGIC);
end clk_divider_50KHz;

architecture a_clk_divider_50KHz of clk_divider_50KHz is

begin


end a_clk_divider_50KHz;
