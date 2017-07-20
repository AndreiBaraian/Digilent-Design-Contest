----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2017 01:51:49 AM
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
    Port ( clk           : in STD_LOGIC;
           btn           : in STD_LOGIC_VECTOR(3 downto 0);
		   trig          : inout STD_LOGIC_VECTOR(3 downto 0);
           echo          : in STD_LOGIC_VECTOR(3 downto 0);
           servo_signals : out std_logic_vector(4 downto 0);
		   DOUT          : in STD_LOGIC; --data from the hx711 module
		   sck           : out STD_LOGIC; --clock generated by us with a frequency of 500kHz (T=2us)
		   isMetal       : in STD_LOGIC; --signal stating if we have a metal or not (from Arduino)
		   isTransparent : in STD_LOGIC;
		   resetMetal    : out STD_LOGIC;
		   sig_idle      : out STD_LOGIC;
		   sig_scanning  : out STD_LOGIC;
		   led           : out STD_LOGIC_VECTOR(3 downto 0);
		   binFull       : out STD_LOGIC_VECTOR(3 downto 0)); 
end main;

architecture Behavioral of main is

component mpg is
    Port ( clk    : in  STD_LOGIC;
           btn    : in  STD_LOGIC_VECTOR (3 downto 0);
           enable : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component hx711 is
	port( clk          : in std_logic;
			DOUT       : in std_logic;			--data from the hx711 module(24 bits, one by one starting with the MSB)
			SCK        : out std_logic;
			final_data :out std_logic_vector(11 downto 0));		--clock generated by us with a frequency of 500KHz (T = 2 us)
end component;

component servoControl is
    port (clk          : in std_logic;
          servo_status : in std_logic_vector(4 downto 0); --each bit represents a servo, i.e., if it is 0 ==> do not move, else move the servo
          servo_signals: out std_logic_vector(4 downto 0));
end component;

component ultrasonic is
    Port ( clk           : in STD_LOGIC;
           trig          : inout STD_LOGIC;
           echo          : in STD_LOGIC;
           less_than_16cm: out STD_LOGIC);
end component;

type state_t is (set_up,idle,start_scan,metal_detect,open_door1,open_door2,open_door3,open_door4, check_infra, check_weight, wait_after_doors, check_full);
signal state:state_t;

signal buttons          :std_logic_vector(3 downto 0);
signal half_second_metal: std_logic_vector(27 downto 0) := (others=>'0');
signal weightedData     : std_logic_vector(11 downto 0);
signal servoStart       : std_logic_vector(4 downto 0);
signal seconds9         : std_logic_vector(30 downto 0);
signal wait_start_scan  : std_logic_vector(27 downto 0);
signal less_than_16cm   : std_logic_vector(3 downto 0); --for bins 4, 3, 2, 1 (in this order): checks if they are full or not

begin

MPG_U:                  mpg port map(clk => clk, btn => btn, enable => buttons);
WEIGHT_U:               hx711 port map(clk => clk, DOUT => DOUT, SCK => sck,  final_data => weightedData);
SERVOS_U:               servoControl port map(clk => clk, servo_status => servoStart, servo_signals => servo_signals);
CHECK_METAL_BIN_FULL:   ultrasonic port map(clk => clk, trig => trig(0), echo => echo(0), less_than_16cm => less_than_16cm(0));
CHECK_GLASS_BIN_FULL:   ultrasonic port map(clk => clk, trig => trig(1), echo => echo(1), less_than_16cm => less_than_16cm(1));
CHECK_WASTE_BIN_FULL:   ultrasonic port map(clk => clk, trig => trig(2), echo => echo(2), less_than_16cm => less_than_16cm(2));
CHECK_PLASTIC_BIN_FULL: ultrasonic port map(clk => clk, trig => trig(3), echo => echo(3), less_than_16cm => less_than_16cm(3));

fsm:process(clk, weightedData, buttons(0), less_than_16cm)
begin
    if rising_edge(clk) then
        
        case state is
            when set_up => if half_second_metal = 62500000 then --stay here half a second and reset the frequency of the metal detector
                                state <= idle;
                                half_second_metal <= (others => '0');
                            else
                                state <= set_up;
                                half_second_metal <= half_second_metal + 1;
                            end if;
                            
            when idle => if buttons(0) = '0' then
                            state <= idle;
                         else                       --the user pressed the button ==> he/she has introduced an object in the system
                            state <= start_scan;
                         end if;
                         
            when start_scan => if wait_start_scan = 75000000 then --we stay here 0.6s to send signals to the arduino
                                 wait_start_scan <= (others => '0');
                                 state <= metal_detect;
                               else
                                 state <= start_scan;
                                 wait_start_scan <= wait_start_scan + 1;                               
                               end if;
            
            when metal_detect => if isMetal = '1' then
                                    state <= open_door1;    --metal detected
                                 else
                                    state <= check_infra;
                                 end if;
                                 
            when check_infra => if isTransparent = '1' then
                                    state <= check_weight;
                                else
                                    state <= open_door3;    --waste detected
                                end if;
                                
            when check_weight => if weightedData < X"071" then -- 0x071 = 100g
                                    state <= open_door4;    --plastic detected
                                 else
                                    state <= open_door2;    --glass detected
                                end if;
                                
            when open_door1 => state <= wait_after_doors;
            when open_door2 => state <= wait_after_doors;
            when open_door3 => state <= wait_after_doors;
            when open_door4 => state <= wait_after_doors;
            
            when wait_after_doors => if seconds9 = 1125000000 then --9 seconds passed 
                                        state <= check_full;
                                        seconds9 <= (others => '0');
                                    else
                                        state <= wait_after_doors;
                                        seconds9 <= seconds9 + 1;
                                    end if;
            when check_full => if less_than_16cm /= "0000" then
                                   state <= check_full;
                               else
                                   state <= set_up;
                               end if;
                            
        end case; 
    end if;
end process;


process(state, btn(0), isTransparent, isMetal, less_than_16cm)
begin
	resetMetal <= '0';
	binFull <= (others => '0');
	
	sig_idle <= '0';
	sig_scanning <= '0';
	
	case state is 
		when set_up => resetMetal <= '1';
		               sig_idle <= '1';
		               servoStart <= "00000";
		               led <= "1111";
                                              
		when idle => sig_idle <= '1';
		             servoStart <= "00000";
                   
                     led(3) <= isTransparent;
                     led(2) <= isMetal;
                     led(1 downto 0) <= "11";
		            
		when start_scan =>  sig_scanning <= '1';
		                    servoStart <= "00000";
		                    		                    
		when metal_detect => sig_scanning <= '1';
		                     servoStart <= "00000";
		                     
		when check_infra => sig_scanning <= '1';
		                    servoStart <= "00000";
		                    
		when check_weight =>  sig_scanning <= '1';
		                      servoStart <= "00000";
		                      
		when open_door1 => servoStart <= "10001";
		                   led <= "0001";
		                   
        when open_door2 => servoStart <= "10010";
                           led <= "0010";
                           
        when open_door3 => servoStart <= "10100";
                           led <= "0011";
                            
        when open_door4 => servoStart <= "11000";
                           led <= "0100";
                            
        when wait_after_doors => servoStart <= "00000"; 
        
        when check_full => servoStart <= "00000"; 
                           binFull <= less_than_16cm;
                           led <= less_than_16cm;
	end case;
end process;


end Behavioral;
