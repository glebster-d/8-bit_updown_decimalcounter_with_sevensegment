library IEEE;
use IEEE.std_logic_1164.all;

entity seven_segment_encoder_x2 is
	port (
		inp0 : in std_logic_vector(3 downto 0);
		inp1 : in std_logic_vector(3 downto 0);
		outp0  : out std_logic_vector(6 downto 0);
		outp1  : out std_logic_vector(6 downto 0)
	);
end seven_segment_encoder_x2;
 
architecture arc_seven_segment_encoder_x2 of seven_segment_encoder_x2 is
	component seven_segment_encoder is 
		port (
			inp  : in std_logic_vector(3 downto 0);
			outp : out std_logic_vector(6 downto 0)
		);
	end component;

begin
	enc0 : seven_segment_encoder port map (inp0, outp0);
	enc1 : seven_segment_encoder port map (inp1, outp1);
	
end arc_seven_segment_encoder_x2;