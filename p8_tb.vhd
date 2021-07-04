library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity p8_tb is 
end p8_tb;

architecture arc_p8_tb of p8_tb is

	type sample_array is array (natural range <>) of std_logic_vector(6 downto 0);

	constant seven_seg : sample_array := (
		"0000001",	--- 0
		"1001111",	--- 1
		"0010010",	--- 2
		"0000110",	--- 3
		"1001100",	--- 4
		"0100100",	--- 5
		"0100000",	--- 6
		"0001111",	--- 7
		"0000000",	--- 8
		"0010000",	--- 9 
		"0001000",	--- A 
		"1100000",	--- B
		"0110001",	--- C
		"1000010",	--- D
		"0110000",	--- E
		"0111000");	--- F

	component full_block is
		port (
			clk    : in std_logic;
			rsts   : in std_logic;
			rsta   : in std_logic;
			load   : in std_logic;
			cnt    : in std_logic;		
			updn   : in std_logic;		
			din    : in std_logic_vector(7 downto 0);
			digit0 : out std_logic_vector(6 downto 0);
			digit1 : out std_logic_vector(6 downto 0)
		);
	end component;
	
	signal clk    : std_logic;
	signal rsts   : std_logic;
	signal rsta   : std_logic;
	signal load   : std_logic;
	signal cnt    : std_logic;
	signal updn   : std_logic;
	signal din    : std_logic_vector(7 downto 0);
	signal digit0 : std_logic_vector(6 downto 0);
	signal digit1 : std_logic_vector(6 downto 0);
	
	procedure wave_gen (signal clk: out std_logic) is
	begin
		clk <= '0';			
			wait for 10 ns;			
		clk <= '1';			
			wait for 10 ns;
	end wave_gen;
	
begin
  
	design: full_block port map (clk, rsts, rsta, load, cnt, updn, din, digit0, digit1);
	
	process begin
		-- Reset
		rsta <= '1';
		wait for 10 ns;
		rsta <= '0';
		wait for 10 ns;
		assert (digit0 = seven_seg(0)) and (digit1 = seven_seg(0)) 
		report "Error in rsta" 
		severity error;
		
		-- Test seven segments: sequentially load values from 9 to 0
		load <= '1';
		for i in 9 downto 0 loop
			din <= std_logic_vector(to_unsigned(17 * i, 8));
			wave_gen(clk);
			assert digit0 = seven_seg(i) 
			report "Error in digit0" 
			severity error;
			assert digit1 = seven_seg(i) 
			report "Error in digit1" 
			severity error;
		end loop;
		
		-- Test 'load' signal: no data loaded if load = 0
		load <= '0';
		din <= x"88";
		wave_gen(clk);
		assert (digit0 = seven_seg(0)) and (digit1 = seven_seg(0)) 
		report "Error in load" 
		severity error;

		-- Test counting: up, down, overflow, underflow
		cnt <= '1';
		
		-- Test counting up 1 to 99
		updn <= '0';
		for i in 1 to 99 loop
			wave_gen(clk);
			assert digit0 = seven_seg(i mod 10) 
			report "Error in digit0" 
			severity error;
			assert digit1 = seven_seg(i  /  10) 
			report "Error in digit1" 
			severity error;
		end loop;

		-- Test overflow 99 -> 00
		wave_gen(clk);
		assert digit0 = seven_seg(0) 
		report "Error in digit0" 
		severity error;
		assert digit1 = seven_seg(0) 
		report "Error in digit1" 
		severity error;

		-- Test underflow 00 -> 99
		updn <= '1';
		wave_gen(clk);
		assert digit0 = seven_seg(9) 
		report "Error in digit0" 
		severity error;
		assert digit1 = seven_seg(9) 
		report "Error in digit1" 
		severity error;

		-- Test counting down 98 to 0
		cnt <= '1';
		for i in 98 downto 0 loop
			wave_gen(clk);
			assert digit0 = seven_seg(i mod 10) 
			report "Error in digit0" 
			severity error;
			assert digit1 = seven_seg(i  /  10) 
			report "Error in digit1" 
			severity error;
		end loop;

		-- Test 'cnt' signal: no counting when cnt = 0
		cnt <= '0';
		wave_gen(clk);	
		assert (digit0 = seven_seg(0)) and (digit1 = seven_seg(0))
		report "Error in cnt" 
		severity error;
		updn <= '0';
		wave_gen(clk);	
		assert (digit0 = seven_seg(0)) and (digit1 = seven_seg(0)) 
		report "Error in cnt" 
		severity error;

		-- Test 'rsts' signal: load value, activate rsts, check output
		load <= '1';
		din <= x"88";
		wave_gen(clk);
		rsts <= '1';
		wave_gen(clk);
		assert (digit0 = seven_seg(0)) and (digit1 = seven_seg(0)) 
		report "Error in rsts" 
		severity error;

		report "All Done!";
		wait;
	end process;
end arc_p8_tb;