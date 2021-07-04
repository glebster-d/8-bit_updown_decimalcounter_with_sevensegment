library IEEE;
use IEEE.std_logic_1164.all;

entity seven_segment_encoder is
	port (
		inp  : in std_logic_vector(3 downto 0);
		outp : out std_logic_vector(6 downto 0)
	);
end seven_segment_encoder;

architecture arc_seven_segment_encoder of seven_segment_encoder is
begin
  process(inp)
  begin
	case inp is
		when x"0" => outp <= "0000001"; 
		when x"1" => outp <= "1001111"; 
		when x"2" => outp <= "0010010"; 
		when x"3" => outp <= "0000110"; 
		when x"4" => outp <= "1001100"; 
		when x"5" => outp <= "0100100"; 
		when x"6" => outp <= "0100000"; 
		when x"7" => outp <= "0001111"; 
		when x"8" => outp <= "0000000"; 
		when x"9" => outp <= "0010000"; 
		when x"A" => outp <= "0001000"; 
		when x"B" => outp <= "1100000"; 
		when x"C" => outp <= "0110001"; 
		when x"D" => outp <= "1000010"; 
		when x"E" => outp <= "0110000"; 
		when x"F" => outp <= "0111000"; 
		when others => null;
	end case;
  end process;
end arc_seven_segment_encoder;