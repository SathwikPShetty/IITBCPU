library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity data_path is
	port(
		op_code: out std_logic_vector(3 downto 0);
		condition: out std_logic_vector(1 downto 0);
		clk, reset: in std_logic;
		O: in std_logic_vector(17 downto 0);
		R0_O, R1_O, R2_O, R3_O, R4_O, R5_O, R6_O, R7_O: out std_logic_vector(15 downto 0);
		en: in std_logic_vector(15 downto 0));
		
end entity;
	
architecture rtl of data_path is

	component LS7  is
		port (LS_IN: in std_logic_vector(15 downto 0); LS_OUT: out std_logic_vector(15 downto 0));
	end component;
	
	component MB2  is
		port (MB_IN: in std_logic_vector(15 downto 0); MB_OUT: out std_logic_vector(15 downto 0));
	end component MB2;
	
	component reg_generic is
		generic (data_width : integer);
		port(
			clk, en, reset: in std_logic;
			Din: in std_logic_vector(data_width-1 downto 0);
			init: in std_logic_vector(data_width-1 downto 0);
			Dout: out std_logic_vector(data_width-1 downto 0));
	end component;

	component sign_extend is
		port(
			SE_op: in std_logic;
			inp_6bit: in std_logic_vector(5 downto 0);
			inp_9bit: in std_logic_vector(8 downto 0);
			outp_16bit: out std_logic_vector(15 downto 0));
	end component;

	component register_file is			
		port(
			RF_D3: in std_logic_vector(15 downto 0);
			RF_D1, RF_D2, R0_O, R1_O, R2_O, R3_O, R4_O, R5_O, R6_O, R7_O: out std_logic_vector(15 downto 0);
			RF_A1, RF_A2, RF_A3: in std_logic_vector(2 downto 0);
			clk, RF_WR, reset: in std_logic);
	end component;

	component alu is
		port(
			clk, reset: in std_logic;
			ALU_A, ALU_B: in std_logic_vector(15 downto 0);
			ALU_C: out std_logic_vector(15 downto 0);
			ALU_en: in std_logic;
			ALU_op: in std_logic_vector(2 downto 0);
			ALU_Z, ALU_Carry: out std_logic);
	end component;

	component memory is		
		port(
			MEM_DI: in std_logic_vector(15 downto 0);
			MEM_DO: out std_logic_vector(15 downto 0);
			MEM_A: in std_logic_vector(15 downto 0);
			clk, MEM_WR, MEM_RD, reset: in std_logic); --
	end component;
	
	signal V0: std_logic := 'Z';
	signal V1: std_logic_vector(2 downto 0) := (others => 'Z');
	signal V2: std_logic_vector(7 downto 0) := (others => 'Z');
	signal V3: std_logic_vector(15 downto 0) := (others => 'Z');
	signal RF_A3, RF_A2, RF_A1: std_logic_vector(2 downto 0) := (others => '0');
	signal Z_IN, Z_OUT: std_logic_vector(0 downto 0) := (others => '0');
	signal ALU1_Z, ALU1_Carry: std_logic := '0';
	signal ALU2_Z, ALU2_Carry: std_logic := '0';
	signal IR_IN: std_logic_vector(15 downto 0) := (others => '0');
	signal IR_out, RF_D3, RF_D2, RF_D1, R7_1, outp_16bit: std_logic_vector(15 downto 0) := (others => '0');
	signal ALU1_A, ALU1_B, ALU1_C, ALU2_A, ALU2_B, ALU2_C, IRO, MEM_DO, MEM_DI, MEM_A: std_logic_vector(15 downto 0) := (others => '0');
	signal T1_IN, T1_OUT, T2_IN, T2_OUT, T3_IN, T3_OUT, T4_IN, T4_OUT, T5_IN, T5_OUT, LS_IN, LS_OUT, MB_IN, MB_OUT: std_logic_vector(15 downto 0) := (others => '0');
	signal inp_6bit: std_logic_vector(5 downto 0):= (others => '0');
	signal inp_9bit: std_logic_vector(8 downto 0):= (others => '0');

begin
	
	--Instruction Register
	instruction_register: reg_generic
		generic map(16)
		port map(clk => clk, reset => reset, init => "0000000000000000", Din => IR_IN, Dout => IR_OUT, en => en(3));
	
	--Register File
	rf: register_file
		port map(clk => clk, reset => reset, RF_WR => en(0), RF_D3 => RF_D3, R0_O => R0_O,  R1_O => R1_O, R2_O => R2_O, R3_O => R3_O, R4_O => R4_O, R5_O => R5_O, R6_O => R6_O, R7_O => R7_1,
			RF_D1 => RF_D1, RF_D2 => RF_D2, RF_A3 => RF_A3, RF_A1 => RF_A1, RF_A2 => RF_A2);
			
	--Sign Extend
	sign_extend_1: sign_extend
		port map(SE_op => en(13), inp_6bit => inp_6bit, inp_9bit => inp_9bit, outp_16bit => outp_16bit);
		
	--Arithmetic Logic Unit 1
	alu_instance_1: alu
		port map(clk => clk, reset => reset, ALU_A => ALU1_A, ALU_B => ALU1_B, ALU_C => ALU1_C, ALU_en => en(4), ALU_op => en(7 downto 5),
			ALU_Z => ALU1_Z, ALU_Carry => ALU1_Carry);
			
	--Arithmetic Logic Unit 2
	alu_instance_2: alu
		port map(clk => clk, reset => reset, ALU_A => ALU2_A, ALU_B => ALU2_B, ALU_C => ALU2_C, ALU_en => en(15), ALU_op => "000",
			ALU_Z => ALU2_Z, ALU_Carry => ALU2_Carry);
			
	--Memory
	mem: memory
		port map(MEM_DO => MEM_DO, MEM_DI => MEM_DI, MEM_A => MEM_A, MEM_WR => en(1), MEM_RD => en(2),
			 clk => clk, reset => reset);
	
	--Temporary Register 1
	T1: reg_generic
		generic map(16)
		port map(Din => T1_IN, Dout => T1_OUT, en => en(8), clk => clk, reset => reset, init => "0000000000000000");
		
	--Temporary Register 2
	T2: reg_generic
		generic map(16)
		port map(Din => T2_IN, Dout => T2_OUT, en => en(9), reset => reset, init => "0000000000000000", clk => clk);
	
	--Temporary Register 3
	T3: reg_generic
		generic map(16)
		port map(Din => T3_IN, Dout => T3_OUT, en => en(10), reset => reset, init => "0000000000000000", clk => clk);
	
	--Temporary Register 4
	T4: reg_generic
		generic map(16)
		port map(Din => T4_IN, Dout => T4_OUT, en => en(11), reset => reset, init => "0000000000000000", clk => clk);
	
	--Temporary Register 5
	T5: reg_generic
		generic map(16)
		port map(Din => T5_IN, Dout => T5_OUT, en => en(12), reset => reset, init => "0000000000000000", clk => clk);
	
	--z Register: eq	
	eq: reg_generic
		generic map(1)
		port map(Din => Z_IN, Dout => Z_OUT, en => en(14), reset => reset, init => "0", clk => clk);	
	
	--Left Shift 7
	LS_7: LS7
		port map(LS_IN => LS_IN, LS_OUT => LS_OUT);
		
	R7_O <= R7_1;
		
	--MUX

	--Input 1 of ALU1
	ALU1_A <= R7_1 when (O(1 downto 0)= "00") else
		T1_OUT when (O(1 downto 0)= "01") else
		outp_16bit when (O(1 downto 0)= "10") else
		V3;
		
	--Input 2 of ALU1
	ALU1_B <= "0000000000000001" when (O(3 downto 2)= "00") else
		T2_OUT when (O(3 downto 2)= "01") else
		outp_16bit when (O(3 downto 2)= "10") else
		V3;
   
	--Register File RF_A3
	RF_A3 <= IR_OUT(5 downto 3) when (O(11 downto 10)= "00") else
		IR_OUT(8 downto 6) when (O(11 downto 10)= "01") else
		IR_OUT(11 downto 9) when (O(11 downto 10)= "10") else
		"111" when (O(11 downto 10)= "11") else
		V1;
	
	--Register File RF_D3
	RF_D3 <= T1_OUT when (O(14 downto 12)= "000") else
		T3_OUT when (O(14 downto 12)= "001") else
		ALU1_C when (O(14 downto 12)= "010") else
		ALU2_C when (O(14 downto 12)= "011") else
		LS_OUT when (O(14 downto 12)= "100") else
		outp_16bit when (O(14 downto 12)= "101") else
		V3;
	
	--Register File RF_A1
	RF_A1 <= IR_OUT(11 downto 9) when (O(15)= '0') else
		IR_OUT(8 downto 6) when (O(15)= '1') else
		V1;
		
	--Register File RF_A2
	RF_A2 <= IR_OUT(8 downto 6);

	--Memory Address MEM_A
	MEM_A <= T1_OUT when (O(4)= '0') else
			T4_OUT when (O(4)= '1') else
			V3;
	
	--Memory Address MEM_DI
	MEM_DI <= T5_OUT when (O(5)= '0') else
		T3_OUT when (O(5) = '1') else
		V3;
	
	--Input 1 of ALU2
	ALU2_A <= T4_OUT;
    
	--Input 2 of ALU2
	ALU2_B <= "0000000000000010" when ((O(17 downto 16)= "00") and (Z_OUT(0) = '0')) else
		MB_OUT when ((O(17 downto 16)= "00") and (Z_OUT(0) = '1')) else
		MB_OUT when (O(17 downto 16)= "01") else
		"0000000000000000" when (O(17 downto 16)= "10") else
		V3;

	--Temp Reg T1
	T1_IN <= RF_D1 when (O(7 downto 6)= "00") else
		ALU1_C when (O(7 downto 6)= "01") else
		R7_1 when (O(7 downto 6)= "10") else
		V3;
		
	--Temp Reg T2
	T2_IN <= RF_D2;
	
	--Temp Reg T3
	T3_IN <= RF_D1 when (O(9 downto 8) = "00") else
		MEM_DO when (O(9 downto 8) = "01") else
		("000000000000000" & ALU1_Carry) when (O(9 downto 8) = "10") else
		V3;
		
	--Temp Reg T4
	T4_IN <= R7_1;
		
	--Temp Reg T5
	T5_IN <= RF_D1;
	
	--Info Reg IR
	IR_IN <= MEM_DO;
	
	--SE16, 6 bit input
	inp_6bit <= IR_OUT(5 downto 0);
	
	--SE16, 9 bit input
	inp_9bit <= IR_OUT(8 downto 0);
	
	--Left Shifter
	LS_IN <= outp_16bit;
	
	--Multiply by 2
	MB_IN <= outp_16bit;
	
	--eq_CCR
	Z_IN(0) <= ALU1_Z;
	
	--Send Operation Code to the control path
	process (clk, reset, IR_OUT)
	begin
	if (reset = '1') then
		op_code <= "1110";
	else
		if (clk' event and clk = '0') then
			op_code <= IR_OUT(15 downto 12);
	
	--Send the Conditional Execution Data to control path
			condition <= IR_OUT(1 downto 0);
		end if;
	end if;
	end process;
	
end architecture;