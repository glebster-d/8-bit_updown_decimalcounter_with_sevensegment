library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity updown_counter_x2 is
	port (
		clk  : in std_logic;
		rsts : in std_logic;
		rsta : in std_logic;
		load : in std_logic;
		cnt  : in std_logic;		
		updn : in std_logic;		
		din  : in std_logic_vector(7 downto 0);
		dout : out std_logic_vector(7 downto 0)
	);
end updown_counter_x2;
 
architecture arc_updown_counter_x2 of updown_counter_x2 is
	
	component updown_counter is
		port (
			clk  : in std_logic;
			rsts : in std_logic;
			rsta : in std_logic;
			load : in std_logic;
			cnt  : in std_logic;		
			updn : in std_logic;		
			din  : in std_logic_vector(3 downto 0);
			dout : out std_logic_vector(3 downto 0)
		);
	end component;

	signal dc0_out : std_logic_vector(3 downto 0);
	signal dc0_over  : std_logic;
	signal dc0_under : std_logic;
	signal dc1_count : std_logic;

begin
	dc0 : updown_counter port map (clk, rsts, rsta, load, cnt,       updn, din(3 downto 0), dc0_out);
	dc1 : updown_counter port map (clk, rsts, rsta, load, dc1_count, updn, din(7 downto 4), dout(7 downto 4));
	dout(3 downto 0) <= dc0_out;
	dc0_over  <= '1' when (cnt = '1' and unsigned(dc0_out) = x"9") else '0';
	dc0_under <= '1' when (cnt = '1' and unsigned(dc0_out) = x"0") else '0';
	dc1_count <= '1' when (updn = '0' and dc0_over = '1') or (updn = '1' and dc0_under = '1') else '0';
end arc_updown_counter_x2;