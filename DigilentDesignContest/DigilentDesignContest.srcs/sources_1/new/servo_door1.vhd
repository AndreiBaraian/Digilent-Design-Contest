----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2017 09:16:47 PM
-- Design Name: 
-- Module Name: servo - a_servo
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

entity servo1 is
    Port ( clk : in STD_LOGIC;
           move : in STD_LOGIC_VECTOR(1 downto 0);  --00 or 11 do not move, 01 - 0 degrees, 10 - 180 degrees
           servo_sig : out STD_LOGIC);
end servo1;

architecture a_servo of servo1 is

component clk_divider_4KHz is
    Port ( clk     : in STD_LOGIC;      --clk in has f = 125 MHz
           clk_out : out STD_LOGIC);    --clk_out will have f = 4KHz ( T = 0.25 ms)
end component;

signal clk_4khz        : std_logic;
signal count_20ms      : std_logic_vector(6 downto 0) := (others => '0'); --we will count until 81 (in order to have 20ms period) because we have T = 0.25ms
signal count_pulse     : std_logic_vector(3 downto 0) := (others => '0'); --we will count up to 2 or 10 in order to have T1 = 0.75 ms or T2 = 2 ms
    
begin
    
    CLK_4KHZ_DIVIDER: clk_divider_4KHz port map (clk => clk, clk_out => clk_4khz);
    
    move_servo_proc: process (clk_4khz, move, count_20ms, count_pulse)
    variable count_pulse_bool: boolean := false;
    
    begin
    servo_sig <= '0';  
                   
    if rising_edge(clk_4khz) then
        if count_20ms = 81 then
            count_20ms <= (others => '0');
            count_pulse <= (others => '0');  --20ms have pased so we
            count_pulse_bool := true;       --start sending pulse again
        else
            count_20ms <= count_20ms + 1;
                                               
            if count_pulse_bool = true then
                case move is
                    when "01" => --move to 180 degrees (open the door)
                                if count_pulse = 9 then     --HIGH time of the 20ms period is 2 ms
                                    count_pulse_bool := false;
                                    count_pulse <= (others => '0');
                                else
                                    count_pulse <= count_pulse + 1;
                                    servo_sig <= '1';
                                end if;
                    when "10" => --move to 0 degrees (close the door)
                                if count_pulse = 3 then         --HIGH time of the 20ms period is 0.75 ms
                                     count_pulse_bool := false;
                                     count_pulse <= (others => '0');
                                else
                                     count_pulse <= count_pulse + 1;
                                     servo_sig <= '1';
                                end if;

                    when others => count_pulse_bool := false;        --send only LOW to the servo so that it will not move
                end case;
           end if;
        end if;
    end if;
    end process move_servo_proc;
end a_servo;