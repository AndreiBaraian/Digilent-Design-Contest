----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2017 02:43:10 PM
-- Design Name: 
-- Module Name: cnt1 - Behavioral
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

entity TriggerGenerator is
    Port ( clk : in STD_LOGIC;          -- 100KHz
           trig : out STD_LOGIC;
           echo_rst: out STD_LOGIC);
end TriggerGenerator;

architecture Behavioral of TriggerGenerator is


begin
    
    --trig will be HIGH for 10us, after that we count approximately 65ms (this is the
    --time that we wait for the echo signal), and after 65ms have passed we send 
    --another 10us trig signal
    counter_trigger: process(clk) 
   
    variable cnt: std_logic_vector(12 downto 0) := (others => '0');
    variable v_trig, v_echo_rst : std_logic := '0';
    variable start_trig : boolean := true;
    variable i: integer := 0;   --i is to count 2 rising edges (we will let trig to be HIGH FOR 20 us
    begin
        
        if rising_edge(clk) then
            if v_trig = '0' and cnt = 0 and start_trig = true and i = 0 then     --start triggering 
                v_trig := '1';                                         --(HIGH for 10us)
               -- start_trig := false;
                i := i + 1;
                v_echo_rst := '1';
            elsif v_trig = '1' and cnt = 0 and start_trig = true and i = 1 then --continue triggering
                v_trig := '1';                                          --(HIGH another 10us)
                i := 0;
                start_trig := false;
                v_echo_rst := '1';
           else
              if v_trig = '1' and cnt = 0 and start_trig = false then --stop triggering
                v_trig := '0';                                       --10us have passed
                v_echo_rst := '0';                              
              else                      --we are counting those 65ms to pass
                v_echo_rst := '0';
                if cnt = 6501 then    --the 65ms have passed (65ms/10us = 6500), the 1 from 6501 is to count the last rising edge
                    cnt := (others => '0');                             --so that we have 65ms
                    start_trig := true;
                    v_echo_rst := '1';
                 else
                  cnt := cnt + 1;
                end if;
               end if;
              end if;
         end if;
         
        echo_rst <= v_echo_rst;  
        trig <= v_trig;
    end process counter_trigger;
    

end Behavioral;
