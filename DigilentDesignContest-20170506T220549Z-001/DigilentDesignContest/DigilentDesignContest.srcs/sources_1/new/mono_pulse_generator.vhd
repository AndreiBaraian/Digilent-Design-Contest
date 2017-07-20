----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:47:51 03/22/2016 
-- Design Name: 
-- Module Name:    mpg - Behavioral 
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

entity mpg is
    Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC_VECTOR (3 downto 0);
           enable : out  STD_LOGIC_VECTOR (3 downto 0));
end mpg;

architecture Behavioral of mpg is

signal c 			: std_logic_vector (15 downto 0) := (others => '0');
signal q2,q1,q0 	: std_logic_vector(3 downto 0);

begin
	-- the counter
	counter: process(clk)
	begin
		if rising_edge(clk) then
			c <= c + 1;
		end if;
	end process counter;
	
	dff2 : process(clk,c)
	begin
		if rising_edge(clk) then
			if c = x"FFFF" then
				q2 <= btn;
			end if;
		end if;
	end process dff2;
	
	process(clk)
	begin
		if rising_edge(clk) then
			q1 <= q2;
			q0 <= q1;
		end if;
	end process;
	
	enable <= q1 and not q0;
	
end Behavioral;
