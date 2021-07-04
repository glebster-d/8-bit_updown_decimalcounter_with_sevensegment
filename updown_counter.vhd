library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity updown_counter is
	port (
		clk  : in std_logic;
		rsts : in std_logic;
		rsta : in std_logic;
		load : in std_logic;
		cnt  : in std_logic;		-- 0: do nothing, 1: inc/dec
		updn : in std_logic;		-- 0: up, 1: down
		din  : in std_logic_vector(3 downto 0);
		dout : out std_logic_vector(3 downto 0)
--		ovf  : out std_logic;		-- overflow
	);
end updown_counter;

architecture arc_updown_counter of updown_counter is
begin
  process(rsta, clk)
  variable digit : integer range 0 to 9;
  begin
	if rsta = '1' then
		digit := 0;
	elsif rising_edge(clk) then
		if rsts = '1' then
			digit := 0;
		elsif load = '1' then
			digit := to_integer(unsigned(din));
		elsif cnt = '1' then
			if updn = '0' then
				if digit = 9 then 
					digit := 0; 
				else 
					digit := digit + 1; 
				end if;
			else
				if digit = 0 then 
					digit := 9; 
				else 
					digit := digit - 1; 
				end if;
			end if;
		end if;
	end if;
	dout <= std_logic_vector(to_unsigned(digit, 4));
  end process;
end arc_updown_counter;
