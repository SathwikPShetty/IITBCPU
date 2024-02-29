 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end entity;

architecture bhv of testbench is
   component IITB_CPU is
    port(
		reset, clk: in std_logic;
		Sw: in std_logic_vector(3 downto 0);
		L: out std_logic_vector(7 downto 0));
	end component;
	
   signal clock: std_logic := '1';
	signal reset: std_logic := '1';
	signal Sw: std_logic_vector(3 downto 0) := "0000";
	signal L: std_logic_vector(7 downto 0);
	
begin
	process
	begin
		--First positive edge
		wait for 500 ns;
		reset<='0';
		clock <= '0';
		wait for 500 ns;
		clock <='1';
		wait for 500 ns;
		clock <= '0';
	    wait for 500 ns;
		clock <= '1';
		
			
    -- Additional logic or waiting can be added if needed
    -- Optionally, wait forever to stop the process
		wait;
	 end process;
    
   
    CPU1: IITB_CPU port map(reset => reset, clk => clock, Sw => Sw, L => L);
    
end architecture;