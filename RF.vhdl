library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity register_file is		
	port(
		RF_D3: in std_logic_vector(15 downto 0);
		RF_D1, RF_D2, R0_O, R1_O, R2_O, R3_O, R4_O, R5_O, R6_O, R7_O: out std_logic_vector(15 downto 0);
		RF_A1, RF_A2, RF_A3: in std_logic_vector(2 downto 0);
		clk, RF_WR, reset: in std_logic);
end entity;

architecture trial of register_file is
	type rf_type is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal en: std_logic_vector(7 downto 0) := (others => '0');
	
	signal rf_data : rf_type := 
        ("0000000000000000",
		   "0000000000000111",
			"0000000000000110",
			"0000000000000101",
			"0000000000000100",
			"0000000000000011",
			"0000000000000010",
			"0000000000000010");
	signal init_data : rf_type := 
        ("0000000000000000",
		   "0000000000000111",
			"0000000000000110",
			"0000000000000101",
			"0000000000000100",
			"0000000000000011",
			"0000000000000010",
			"0000000000000010");
	
	component reg_generic is
		generic (data_width : integer);
		port(
			clk, en, reset: in std_logic;
			Din: in std_logic_vector(data_width-1 downto 0);
			init: in std_logic_vector(data_width-1 downto 0);
			Dout: out std_logic_vector(data_width-1 downto 0));
	end component;
	
begin 
	
	REG:
	for i in 0 to 7 generate
		REG: reg_generic
			generic map(16)
			port map(clk => clk, en => en(i), init => init_data(i),
				Din => RF_D3, Dout => rf_data(i), reset => reset);
	end generate REG;
	
	process(RF_A3, RF_WR)
	begin
		en <= (others => '0');
		en(to_integer(unsigned(RF_A3))) <= RF_WR;	
	end process;
		
	RF_D1 <= rf_data(to_integer(unsigned(RF_A1)));
	RF_D2 <= rf_data(to_integer(unsigned(RF_A2)));
	R1_O <= rf_data(1);
	R2_O <= rf_data(2);
	R3_O <= rf_data(3);
	R4_O <= rf_data(4);
	R5_O <= rf_data(5);
	R6_O <= rf_data(6);
	R0_O <= rf_data(0);
	R7_O <= rf_data(7);
	
end architecture;