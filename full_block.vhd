library IEEE;
use IEEE.std_logic_1164.all;

entity full_block is
	port (
		clk  : in std_logic;
		rsts : in std_logic;
		rsta : in std_logic;
		load : in std_logic;
		cnt  : in std_logic;		
		updn : in std_logic;		
		din  : in std_logic_vector(7 downto 0);
		digit0 : out std_logic_vector(6 downto 0);
		digit1 : out std_logic_vector(6 downto 0)
	);
end full_block;
 
architecture arc_full_block of full_block is
	component updown_counter_x2 is
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
	end component;

	component seven_segment_encoder_x2 is
		port (
			inp0 : in std_logic_vector(3 downto 0);
			inp1 : in std_logic_vector(3 downto 0);
			outp0  : out std_logic_vector(6 downto 0);
			outp1  : out std_logic_vector(6 downto 0)
		);
	end component;
	
	signal bcd : std_logic_vector(7 downto 0);
	
begin

	counter: updown_counter_x2 port map (clk, rsts, rsta, load, cnt, updn, din, bcd);
	encoder: seven_segment_encoder_x2 port map (bcd(3 downto 0), bcd(7 downto 4), digit0, digit1);

end arc_full_block;