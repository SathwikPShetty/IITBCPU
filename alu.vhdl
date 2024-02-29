library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity FA is
 Port ( A : in STD_LOGIC;
    B : in STD_LOGIC;
    Cin : in STD_LOGIC;
    S : out STD_LOGIC;
    Cout : out STD_LOGIC);
end FA;

architecture gate_level of FA is

begin

 S <= A XOR B XOR Cin ;
 Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B) ;

end gate_level;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Ripple_Adder is
Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
B : in STD_LOGIC_VECTOR (3 downto 0);
Cin : in STD_LOGIC;
S : out STD_LOGIC_VECTOR (3 downto 0);
Cout : out STD_LOGIC);
end Ripple_Adder;

architecture Behavioral of Ripple_Adder is

-- Full Adder VHDL Code Component Decalaration
component FA
Port (  A : in STD_LOGIC;
    B : in STD_LOGIC;
    Cin : in STD_LOGIC;
    S : out STD_LOGIC;
    Cout : out STD_LOGIC);
end component;

-- Intermediate Carry declaration
signal c1,c2,c3: STD_LOGIC;

begin

-- Port Mapping Full Adder 4 times
FA1: FA port map( A(0), B(0), Cin, S(0), c1);
FA2: FA port map( A(1), B(1), c1, S(1), c2);
FA3: FA port map( A(2), B(2), c2, S(2), c3);
FA4: FA port map( A(3), B(3), c3, S(3), Cout);

end Behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Multiplier is 
    port (
        x: in  std_logic_vector (3 downto 0);
        y: in  std_logic_vector (3 downto 0);
        p: out std_logic_vector (7 downto 0)
    );
end entity;

architecture rtl of Multiplier is
    component Ripple_Adder
        port ( 
            A:      in  std_logic_vector (3 downto 0);
            B:      in  std_logic_vector (3 downto 0);
            Cin:    in  std_logic;
            S:      out std_logic_vector (3 downto 0);
           Cout:    out std_logic
        );
    end component;
-- AND Product terms:
    signal G0, G1, G2:  std_logic_vector (3 downto 0);
-- B Inputs (B0 has three bits of AND product)
    signal B0, B1, B2:  std_logic_vector (3 downto 0);

begin

    -- y(1) thru y (3) AND products, assigned aggregates:
    G0 <= (x(3) and y(1), x(2) and y(1), x(1) and y(1), x(0) and y(1));
    G1 <= (x(3) and y(2), x(2) and y(2), x(1) and y(2), x(0) and y(2));
    G2 <= (x(3) and y(3), x(2) and y(3), x(1) and y(3), x(0) and y(3));
    -- y(0) AND products (and y0(3) '0'):
    B0 <=  ('0',          x(3) and y(0), x(2) and y(0), x(1) and y(0));

-- named association:
cell_1: 
    Ripple_Adder 
        port map (
            a => G0,
            b => B0,
            cin => '0',
            cout => B1(3), -- named association can be in any order
            S(3) => B1(2), -- individual elements of S, all are associated
            S(2) => B1(1), -- all formal members must be provide contiguously
            S(1) => B1(0),
            S(0) => p(1)
        );
cell_2: 
    Ripple_Adder 
        port map (
            a => G1,
            b => B1,
            cin => '0',
            cout => B2(3),
            S(3) => B2(2),
            S(2) => B2(1),
            S(1) => B2(0),
            S(0) => p(2)
        );
cell_3: 
    Ripple_Adder 
        port map (
            a => G2,
            b => B2,
            cin => '0',
            cout => p(7),
            S => p(6 downto 3)  -- matching elements for formal
        );
    p(0) <= x(0) and y(0); 
end architecture rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder is
	port(
		a, b, cin: in std_logic;
		s, p, g: out std_logic);
end entity;

architecture basic of full_adder is
begin
	
	g <= a and b;
	p <= a or b;
	s <= a xor b xor cin;
	
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity carry_generate is
	port(
		P, G: in std_logic_vector(3 downto 0);
		cin: in std_logic;
		Cout: out std_logic_vector(3 downto 0));
end entity;

architecture basic of carry_generate is
	signal C: std_logic_vector(4 downto 0);
begin
	C(0) <= cin;
	logic:
	for i in 1 to 4 generate
		C(i) <= G(i-1) or (P(i-1) and C(i-1)); 
	end generate;

	Cout <= C(4 downto 1);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity adder is
	port(
		A, B: in std_logic_vector(15 downto 0);
		S: out std_logic_vector(15 downto 0);
		cin: in std_logic;
		Cout: out std_logic_vector(15 downto 0));
end entity;

architecture look_ahead of adder is
	signal C: std_logic_vector(16 downto 0) := (others => '0');
	signal P, G: std_logic_vector(15 downto 0) := (others => '0');
	
	component full_adder is
		port(
			a, b, cin: in std_logic;
			s, p, g: out std_logic);
	end component;
	
	component carry_generate is
		port(
			P, G: in std_logic_vector(3 downto 0);
			cin: in std_logic;
			Cout: out std_logic_vector(3 downto 0));
	end component;
	
begin

	C(0) <= cin;
	
	ADDER:
	for i in 0 to 15 generate
		ADDX: full_adder
			port map(a => A(i), b => B(i), cin => C(i),
				s => S(i), p => P(i), g => G(i));
	end generate ADDER;
	
	CARRIER:
	for i in 0 to 3 generate
		CARRYX: carry_generate
			port map(P => P((i+1)*4-1 downto i*4),
				G => G((i+1)*4-1 downto i*4),
				cin => C(i*4), Cout => C((i+1)*4 downto i*4+1));
	end generate CARRIER;
	
	Cout <= C(16 downto 1);
	
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port(
		clk, reset: in std_logic; 
		ALU_A, ALU_B: in std_logic_vector(15 downto 0);
		ALU_C: out std_logic_vector(15 downto 0);
		ALU_en: in std_logic;
		ALU_op: in std_logic_vector(2 downto 0);
		ALU_Z, ALU_Carry: out std_logic);
end entity;

architecture behave of alu is
	signal output_temp: std_logic_vector(15 downto 0) := (others => '0');
	signal output_add: std_logic_vector(15 downto 0) := (others => '0');
	signal output_sub: std_logic_vector(15 downto 0) := (others => '0');
	signal output_mul: std_logic_vector(7 downto 0) := (others => '0');
	signal C, Bbar: std_logic_vector(15 downto 0) := (others => '0');
	signal Borrow: std_logic_vector(15 downto 0) := (others => '0');
	signal carry : std_logic := '0';
	
	component adder is
		port(
			A, B: in std_logic_vector(15 downto 0);
			S: out std_logic_vector(15 downto 0);
			cin: in std_logic;
			Cout: out std_logic_vector(15 downto 0));
	end component;
	
	component Multiplier is
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
           y : in  STD_LOGIC_VECTOR (3 downto 0);
           p : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
begin
	
	Bbar <= not ALU_B;
	
	adder1: adder
		port map(
			A => ALU_A, B => ALU_B,
			cin =>'0', S => output_add, Cout => C);
	
	subtract1: adder
		port map(
			A => ALU_A, B => Bbar,
			cin =>'1', S => output_sub, Cout => Borrow);
	
	multiplier1 : Multiplier
		port map (
			x => ALU_A(3 downto 0), y => ALU_B(3 downto 0),
			p => output_mul);
	
	process(ALU_A, ALU_B, output_add, output_sub, output_mul, ALU_op)
	begin
		if (ALU_op = "000") then
			output_temp <= output_add;
			carry <= C(15);
		elsif (ALU_op = "001") then
			output_temp <= output_sub;
			carry <= Borrow(15);
		elsif (ALU_op = "010") then
			output_temp <= ("00000000" & output_mul);
			carry <= '0';
		elsif (ALU_op = "011") then
			output_temp <= ALU_A and ALU_B;
			carry <= '0';
		elsif (ALU_op = "100") then
			output_temp <= ALU_A or ALU_B;
			carry <= '0';
		else
			output_temp <= (not ALU_A) or ALU_B;
			carry <= '0';
		end if;
	end process;
	
	process (ALU_en, output_temp, carry, clk)
	begin
	if (reset = '0') then
		if (ALU_en='1') then
			if (to_integer(unsigned(output_temp)) = 0) then
				ALU_Z <= '1';
			else
				ALU_Z <= '0';
			end if;
			ALU_C <= output_temp;
			ALU_Carry <= carry;
		elsif (ALU_en='0') then	
			ALU_Z <= '0';
			ALU_C <= (others => '0');
			ALU_Carry <= '0';
		end if;
	elsif (reset = '1') then
		ALU_Z <= '0';
		ALU_C <= (others => '0');
		ALU_Carry <= '0';
	end if;
	end process;

end architecture;
	