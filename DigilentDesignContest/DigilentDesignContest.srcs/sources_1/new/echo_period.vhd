----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2017 06:30:01 PM
-- Design Name: 
-- Module Name: cnt2 - Behavioral
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

entity echo_period is
    Port ( clk : in STD_LOGIC;  --100KHz
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           period_count : out STD_LOGIC_VECTOR (12 downto 0));
end echo_period;

architecture a_echo_period of echo_period is

begin

    count_period: process(clk,rst)
    variable cnt_period:std_logic_vector(12 downto 0) := (others => '0');
    
    begin
        if rst = '1' then
            cnt_period := (others => '0');
        else 
            if rising_edge(clk) then
             if en = '1' then 
                cnt_period := cnt_period + 1;
             else
                cnt_period := (others => '0');
            end if;
           end if;
        end if;
        
     period_count <= cnt_period;
    end process count_period;
    
end a_echo_period;
