----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2017 01:27:54 PM
-- Design Name: 
-- Module Name: ultrasonic - a_ultrasonic
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

entity ultrasonic is
    Port ( clk : in STD_LOGIC;
           trig : inout STD_LOGIC;
           echo : in STD_LOGIC;
           led: out STD_LOGIC_VECTOR(3 downto 0));
end ultrasonic;

architecture a_ultrasonic of ultrasonic is

component  clk_divider_100KHz is
    Port ( clk : in STD_LOGIC;
           clk100khz : out STD_LOGIC);
end component;

component TriggerGenerator is
    Port ( clk : in STD_LOGIC;          -- 100KHz
           trig : out STD_LOGIC;
           echo_rst: out STD_LOGIC);
end component;

component echo_period is
    Port ( clk : in STD_LOGIC;  --100KHz
            rst: in STD_LOGIC;
            en : in STD_LOGIC;
           period_count : out STD_LOGIC_VECTOR (12 downto 0));
end component;


signal clk_100khz: std_logic;
signal echo_rst: std_logic;
signal en_echo_period: std_logic;
signal period_counted: std_logic_vector(12 downto 0);
signal reg: std_logic_vector(1 downto 0);
signal trigger: std_logic;
begin
    
    CLOCK_100KHz:       clk_divider_100KHz port map (clk => clk, clk100khz => clk_100khz);
    TRIGGER_SIGNAL:     TriggerGenerator port map (clk => clk_100khz, trig => trigger, echo_rst => echo_rst);
    COUNT_ECHO_PERIOD:  echo_period port map (clk => clk_100khz, rst => echo_rst, en => en_echo_period, period_count => period_counted);
    
    trig <= trigger;
    
    start_stop_count_echo_period: process(clk_100khz, trigger, echo, en_echo_period, period_counted)
    variable v_reg: std_logic_vector(1 downto 0) := (others => '0');
    variable v_en_echo_period : std_logic := '0';
    variable leds : std_logic_vector(3 downto 0) := (others => '0');
    
    begin
        
       if rising_edge(clk_100khz) then
            if trigger = '1' then              --we are triggering
                v_reg := (others => '0');
                v_en_echo_period :='0';
                
            else
                v_reg := echo & reg(1);     --shift right
                
                if v_reg = "10" or v_reg = "11" then    --start or continue counting echo period
                    v_en_echo_period := '1';
                else
                    v_en_echo_period := '0';            -- stop counting
                    
                    if v_reg = "01" then                --the period_counted signal now has the period of the echo signal
                                                        --now we will analyze the period and see how far the object is
                                                        -- peridod(in us)/58 = distance (in cm)
                       if period_counted  <= 59 then    -- less than 10 cm: (58 * 10 cm)/ 10us + 1; ((59 - 1 ) * 10us )/58 = 10 cm 
                            leds := "1000";
                       elsif period_counted <= 117 then   -- less than 20 cm: (58 * 20 cm)/ 10us + 1; ((117 - 1 ) * 10us )/58 = 20 cm
                           leds := "0100";
                       elsif period_counted <= 175 then   -- less than 30 cm: (58 * 30 cm)/ 10us + 1; ((175 - 1 ) * 10us )/58 = 20 cm
                            leds := "0010";
                       else 
                            leds := "0001";
                       end if; 
                       
                    end if;
                end if;
            end if;
         end if;
       
      en_echo_period <= v_en_echo_period;  
      reg <= v_reg;
      led <= leds;   
    end process start_stop_count_echo_period;
    
    
end a_ultrasonic;
