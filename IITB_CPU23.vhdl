library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity IITB_CPU23 is
    port(
		reset, clk: in std_logic);
end entity;

architecture ov of IITB_CPU23 is
	 
	component control_path is
		port(
			reset, clk: in std_logic; 
			op_code: in std_logic_vector(3 downto 0);
			condition: in std_logic_vector(1 downto 0);
			O: out std_logic_vector(17 downto 0);				--MUX Control Signals
			en: out std_logic_vector(15 downto 0));				--Enables and Operation for ALUs
	end component;
	 
	component data_path is
		port(
			op_code: out std_logic_vector(3 downto 0);
			condition: out std_logic_vector(1 downto 0);
			clk, reset: in std_logic;
			O: in std_logic_vector(17 downto 0);
			en: in std_logic_vector(15 downto 0));
	end component;
	
    
   signal op_code: std_logic_vector(3 downto 0) := (others => '0');
   signal condition: std_logic_vector(1 downto 0)  := (others => '0');
   signal O: std_logic_vector(17 downto 0) := (others => '0');
	signal en: std_logic_vector(15 downto 0) := (others => '0'); 
   --signal C, Z, PE_0, eq: std_logic;
   --signal X: std_logic_vector(3 downto 0);

begin
	
	data: data_path
	port map(op_code => op_code, condition => condition,
       clk => clk, reset => reset, O => O, en => en);
		
	control: control_path
	port map(reset => reset, clk => clk, op_code => op_code, condition => condition,
		O => O, en => en);
    
	--C <= X(0);
	--Z <= X(1);
	--PE_0 <= X(2);
	--eq <= X(3);
	
end architecture;