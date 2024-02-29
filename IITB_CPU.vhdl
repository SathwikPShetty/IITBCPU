library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity IITB_CPU is
    port(
		reset, clk: in std_logic;
		Sw: in std_logic_vector(3 downto 0);
		L: out std_logic_vector(7 downto 0));
end entity;

architecture ov of IITB_CPU is
	 
	component control_path is
		port(
			reset, clk: in std_logic; 
			op_code: in std_logic_vector(3 downto 0);
			condition: in std_logic_vector(1 downto 0);
			O: out std_logic_vector(17 downto 0);				--MUX Control Signals
			en: out std_logic_vector(15 downto 0));			--Enables and Operation for ALUs
	end component;
	 
	component data_path is
		port(
			op_code: out std_logic_vector(3 downto 0);
			condition: out std_logic_vector(1 downto 0);
			clk, reset: in std_logic;
			O: in std_logic_vector(17 downto 0);
			R0_O, R1_O, R2_O, R3_O, R4_O, R5_O, R6_O, R7_O: out std_logic_vector(15 downto 0);
			en: in std_logic_vector(15 downto 0));
	end component;
	
    
   signal op_code: std_logic_vector(3 downto 0) := (others => '0');
   signal condition: std_logic_vector(1 downto 0)  := (others => '0');
   signal O: std_logic_vector(17 downto 0) := (others => '0');
	signal R0_O, R1_O, R2_O, R3_O, R4_O, R5_O, R6_O, R7_O: std_logic_vector(15 downto 0);
	signal en: std_logic_vector(15 downto 0) := (others => '0'); 

begin
	
	data: data_path
	port map(op_code => op_code, condition => condition, R0_O => R0_O,  R1_O => R1_O, R2_O => R2_O, R3_O => R3_O, R4_O => R4_O, R5_O => R5_O, R6_O => R6_O, R7_O => R7_O,
       clk => clk, reset => reset, O => O, en => en);
		
	control: control_path
	port map(reset => reset, clk => clk, op_code => op_code, condition => condition,
		O => O, en => en);
	
	process (clk, reset, Sw)
	begin
	if (Sw = "0000") then
		L <= R0_O(7 downto 0);
		
	elsif (Sw = "0001") then
		L <= R0_O(15 downto 8);
		
	elsif (Sw = "0010") then
		L <= R1_O(7 downto 0);
		
	elsif (Sw = "0011") then
		L <= R1_O(15 downto 8);
		
	elsif (Sw = "0100") then
		L <= R2_O(7 downto 0);
		
	elsif (Sw = "0101") then
		L <= R2_O(15 downto 8);
		
	elsif (Sw = "0110") then
		L <= R3_O(7 downto 0);
		
	elsif (Sw = "0111") then
		L <= R3_O(15 downto 8);
		
	elsif (Sw = "1000") then
		L <= R4_O(7 downto 0);
		
	elsif (Sw = "1001") then
		L <= R4_O(15 downto 8);
		
	elsif (Sw = "1010") then
		L <= R5_O(7 downto 0);
		
	elsif (Sw = "1011") then
		L <= R5_O(15 downto 8);
		
	elsif (Sw = "1100") then
		L <= R6_O(7 downto 0);
		
	elsif (Sw = "1101") then
		L <= R6_O(15 downto 8);
		
	elsif (Sw = "1110") then
		L <= R7_O(7 downto 0);
		
	elsif (Sw = "1111") then
		L <= R7_O(15 downto 8);
		
	end if;
	end process;
	
end architecture;