----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:31:46 04/20/2017 
-- Design Name: 
-- Module Name:    seven_seg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven_seg is
	port(seg3, seg2, seg1, seg0: in std_logic_vector(3 downto 0);
			clk: in std_logic;
			an: out std_logic_vector(3 downto 0);
			cat: out std_logic_vector(6 downto 0));
end seven_seg;


architecture a_seg of seven_seg is

signal new_clk: std_logic;
signal counter: std_logic_vector(15 downto 0) := (others => '0');
begin
	
	clk_divider: process(clk, counter)
		variable cnt: std_logic_vector(15 downto 0) := (others => '0');
		
		begin
			if rising_edge(clk) then
				cnt := counter;
				cnt := cnt + 1;
			end if;
			
			counter <= cnt;
			new_clk <= cnt(15);
	end process clk_divider;
	
	
	sevSeg: process(new_clk, seg3, seg2, seg1, seg0)
	
	variable input_dcd: std_logic_vector(3 downto 0);
	variable sel: std_logic_vector(1 downto 0) := "00";
	
	begin
		if rising_edge(new_clk) then
			case sel is									-- which 7 seg is on
				when "00" => an <= "0111";
								 input_dcd := seg3;
				when "01" => an <= "1011";
								 input_dcd := seg2;
				when "10" => an <= "1101";
								 input_dcd := seg1;
				when others => an <= "1110";
								 input_dcd := seg0;
			end case;
			
			sel := sel + 1;
			
			case input_dcd is							-- which nr is shown on 7 seg
				when "0000" => cat <= "0000001";
				when "0001" => cat <= "1001111";
				when "0010" => cat <= "0010010";
				when "0011" => cat <= "0000110";
				when "0100" => cat <= "1001100";
				when "0101" => cat <= "0100100";
				when "0110" => cat <= "0100000";
				when "0111" => cat <= "0001111";
				when "1000" => cat <= "0000000";
				when "1001" => cat <= "0000100";
				when "1010" => cat <= "0001000";
				when "1011" => cat <= "1100000";
				when "1100" => cat <= "0110001";
				when "1101" => cat <= "1000010";
				when "1110" => cat <= "0110000";
				when others => cat <= "0111000";  
			end case;
		end if;
		
	end process sevSeg;
	
	
end a_seg;


