----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2017 05:29:22 PM
-- Design Name: 
-- Module Name: blink_100khz - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity blink_100khz is
    Port (clk: in std_logic;
           blink: out std_logic );
end blink_100khz;

architecture Behavioral of blink_100khz is

begin

    process(clk)
    variable i: std_logic_vector(19 downto 0) := (others => '0');
    variable j: std_logic := '0';
    
    begin
        if rising_edge(clk) then
            if i = 500_000 then
                j := not j;
                i := (others => '0');
            else 
                i:= i + 1;
            end if;
        end if;
       blink <= j;
     end process;
end Behavioral;
