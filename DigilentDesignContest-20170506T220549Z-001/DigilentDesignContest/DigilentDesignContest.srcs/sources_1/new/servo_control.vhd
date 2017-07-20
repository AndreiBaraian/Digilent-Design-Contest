----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2017 05:47:35 PM
-- Design Name: 
-- Module Name: main - a_main
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

entity servoControl is
    port (clk : in std_logic;
          servo_status : in std_logic_vector(4 downto 0); --each bit represents a servo, i.e., if it is 0 ==> do not move, else move the servo
          servo_signals: out std_logic_vector(4 downto 0)
   );
end servoControl;

architecture a_main of servoControl is

component servo1 is
    Port ( clk : in STD_LOGIC;
           move : in STD_LOGIC_VECTOR(1 downto 0);  --00 or 11 do not move, 01 - 0 degrees, 10 - 180 degrees
           servo_sig : out STD_LOGIC);
end component;

component servo2 is
    Port ( clk : in STD_LOGIC;
           move : in STD_LOGIC_VECTOR(1 downto 0);  --00 or 11 do not move, 01 - 0 degrees, 10 - 180 degrees
           servo_sig : out STD_LOGIC);
end component;

component servo3 is
    Port ( clk : in STD_LOGIC;
           move : in STD_LOGIC_VECTOR(1 downto 0);  --00 or 11 do not move, 01 - 0 degrees, 10 - 180 degrees
           servo_sig : out STD_LOGIC);
end component;

component servo4 is
    Port ( clk : in STD_LOGIC;
           move : in STD_LOGIC_VECTOR(1 downto 0);  --00 or 11 do not move, 01 - 0 degrees, 10 - 180 degrees
           servo_sig : out STD_LOGIC);
end component;

component servo5 is
    Port ( clk : in STD_LOGIC;
           move : in STD_LOGIC_VECTOR(1 downto 0);  --00 or 11 do not move, 01 - 0 degrees, 10 - 180 degrees
           servo_sig : out STD_LOGIC);
end component;

signal move_servo1: std_logic_vector(1 downto 0);
signal move_servo2: std_logic_vector(1 downto 0);
signal move_servo3: std_logic_vector(1 downto 0);
signal move_servo4: std_logic_vector(1 downto 0);
signal move_servo5: std_logic_vector(1 downto 0);

signal sec_passed: std_logic_vector(29 downto 0);
signal sec_passed_move_servo: std_logic_vector(29 downto 0);

signal servo_new_status: std_logic_vector(4 downto 0);

type states is (default_state, move_servo, move_back);
signal state: states;

signal servo5_move: std_logic_vector(31 downto 0);
signal en_servo5 : std_logic;

begin
   U1: servo1 port map (clk => clk, move => move_servo1, servo_sig => servo_signals(0));
   U2: servo2 port map (clk => clk, move => move_servo2, servo_sig => servo_signals(1));
   U3: servo3 port map (clk => clk, move => move_servo3, servo_sig => servo_signals(2));
   U4: servo4 port map (clk => clk, move => move_servo4, servo_sig => servo_signals(3));
   U5: servo5 port map (clk => clk, move => move_servo5, servo_sig => servo_signals(4));
       
   process(clk, servo_status)
   begin
   if rising_edge(clk) then
    case state is
        when default_state => if servo_status /= "00000" then
                                 state <= move_servo;
                                 servo_new_status <= servo_status;
                                 en_servo5 <= '1';
                              else
                                 state <= default_state;
                                 en_servo5 <= '0';
                              end if;
                              
        when move_servo => if sec_passed_move_servo = 625000000 then --move servos (open doors) for 5 sec
                               state <= move_back;
                               sec_passed_move_servo <= (others => '0');
                               en_servo5 <= '0';
                           else
                                sec_passed_move_servo <= sec_passed_move_servo + 1;
                                state <= move_servo;
                                
                                if en_servo5 = '1' then
                                    if servo5_move = 125000000 then -- move servo5 (open the trapdoor) only for 1 sec
                                        servo5_move <= (others => '0');
                                        en_servo5 <= '0';
                                    else
                                         servo5_move <=  servo5_move + 1;
                                         en_servo5 <= '1';
                                    end if;
                               end if;
                            end if;
                            
        when move_back => if sec_passed = 250000000 then --move servos (close doors) for 2 sec
                                  state <= default_state;
                                  sec_passed <= (others => '0');
                              else
                                sec_passed <= sec_passed + 1;
                                state <= move_back;
                              end if;
       end case;
  end if;
  end process;
    
    
    
process(state, servo_new_status, en_servo5)
begin 
    case state is
        when default_state =>   move_servo1 <= "00";    --servos will no move in the default state
                                move_servo2 <= "00";
                                move_servo3 <= "00";
                                move_servo4 <= "00";
                                move_servo5 <= "00";
                                
       when move_servo =>  if servo_new_status(4) = '1' and en_servo5 = '1' then --servo5 (the trap door) will receive signals for opening, i.e.,
                               move_servo5 <= "10";         --moving to 180 degrees, only for 1 sec
                            else
                               move_servo5 <= "00";
                            end if;
                            
                            case servo_new_status is   --the other servos will receive signals for opening, i.e., moving to 180 degrees, for 5 sec
                               when "10001" => move_servo1 <= "10";
                                               
                               when "10010" => move_servo2 <= "10";
                                                 
                               when "10100" => move_servo3 <= "10";
                                               
                               when "11000" => move_servo4 <= "10"; 
                                                   
                               when others =>  move_servo1 <= "00";
                                               move_servo2 <= "00";
                                               move_servo3 <= "00";
                                               move_servo4 <= "00";
                         end case;
                       
     when move_back => case servo_new_status is      -- servos will come back to their initial state (the doors are closing)
                            when "10001" => move_servo1 <= "01";
                                            move_servo5 <= "01";
                                            
                            when "10010" => move_servo2 <= "01";
                                            move_servo5 <= "01";  
                                             
                            when "10100" => move_servo3 <= "01";
                                            move_servo5 <= "01";
                                            
                            when "11000" => move_servo4 <= "01";
                                            move_servo5 <= "01";  
                                                  
                            when others =>  move_servo1 <= "00";
                                            move_servo2 <= "00";
                                            move_servo3 <= "00";
                                            move_servo4 <= "00";
                                            move_servo5 <= "00";
                      end case;
  end case;
 end process;  
     
end a_main;
