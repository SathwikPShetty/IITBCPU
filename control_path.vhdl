library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity control_path is
	port(
		reset, clk: in std_logic; 
		op_code: in std_logic_vector(3 downto 0);
		condition: in std_logic_vector(1 downto 0);
		O: out std_logic_vector(17 downto 0);				--MUX Control Signals
		en: out std_logic_vector(15 downto 0));			--Enables and Operation for ALUs
end entity;

architecture fsm of control_path is
	type fsm_state is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
	signal Q, nQ: fsm_state := S0;
begin

	clocked:
	process(clk, nQ)
	begin
		if (clk'event and clk = '1') then
			Q <= nQ;
		end if;
	end process;
	
	outputs:
	process(op_code, Q)
	begin
		O <= (others => '0');
		case Q is
		   when S0 => 
				O <= (others => '0');
				en <= (others => '0');
			when S1 =>
				O(4 downto 0) <= "10000";
				O(7 downto 6) <= "10";
				O(14 downto 10) <= "01011";
				en(0) <= (not op_code(3) and not op_code(2)) or (not op_code(3) and not op_code(1)) or (not op_code(3) and not op_code(0)) or (not op_code(2) and not op_code(1)) or (not op_code(2) and not op_code(0));
				en(3 downto 1) <= "110";
				en(4) <= (not op_code(2)) or (not op_code(3) and not op_code(1)) or (not op_code(3) and not op_code(0));
				en(7 downto 5) <= "000";
				en(8) <= '1'; --(op_code(3) and op_code(2) and op_code(0));
				en(15 downto 9) <= "0000100";
				
			when S2 =>
				O(7 downto 6) <= "00";
				O(4) <= '1';
				O(15) <= '0';
				en(4 downto 0) <= "00000";
				en(8) <= '1';
				en(9) <= (not op_code(3) and not op_code(0)) or (not op_code(2) and op_code(1)) or (not op_code(3) and op_code(2) and not op_code(1)) or (op_code(2) and not op_code(1) and not op_code(0));
				en(15 downto 10) <= "000100";
				
			when S3 =>
				en(3 downto 0) <= "0000";
				en(4) <= '1';
				en(5) <= (not op_code(3) and op_code(1) and not op_code(0)) or (op_code(2) and not op_code(1) and not op_code(0));
				en(6) <= (not op_code(3) and not op_code(2) and op_code(1) and op_code(0)) or (not op_code(3) and op_code(2) and not op_code(1) and not op_code(0));
				en(7) <= (not op_code(3) and op_code(2) and not op_code(1) and op_code(0)) or (not op_code(3) and op_code(2) and op_code(1) and not op_code(0));
				en(12 downto 8) <= "00101";
				en(13) <= (not op_code(3) and not op_code(2) and not op_code(1) and op_code(0)) or (op_code(3) and not op_code(2) and op_code(1));
				en(15 DOWNTO 14) <= "01";
				O(0) <= (not op_code(1)) or (not op_code(3) and op_code(0)) or (op_code(2));
				O(1) <= (op_code(3) and not op_code(2) and op_code(1));
				O(2) <= (not op_code(0)) or (op_code(1)) or (op_code(2));
				O(3) <= (not op_code(3) and not op_code(2) and not op_code(1) and op_code(0));
				O(4) <= '1';
				O(9 downto 6) <= "1001";
				
			when S4 =>
				O(4) <= '1';
				O(10) <= (not op_code(3) and not op_code(2) and not op_code(1) and op_code(0)) or (op_code(3) and op_code(2) and not op_code(1));
				O(11) <= (op_code(3) and not op_code(1)) or (op_code(3) and not op_code(2) and not op_code(0)) or (op_code(3) and op_code(2) and op_code(0));
				O(12) <= (op_code(3) and not op_code(1) and op_code(0)) or (op_code(3) and not op_code(2) and op_code(1) and not op_code(0)) or (op_code(3) and op_code(2) and not op_code(1)) or (op_code(3) and op_code(2) and op_code(0));
				O(13) <= (op_code(3) and op_code(2) and not op_code(1)) or (op_code(3) and op_code(2) and op_code(0)); 
				O(14) <= (op_code(3) and not op_code(2) and not op_code(1));
				en(4 downto 0) <= "00001";
				en(15 downto 8) <= "00100000";
				
			when S5 =>
				O(4) <= '1';
				O(7 downto 6) <= "00";
				O(15) <= '1';
				en(4 downto 0) <= "00000";
				en(15 downto 8) <= "00000001";
				
	
			when S6 =>
				O(5 downto 4) <= "00";
				O(13) <= ((not op_code(3)) and op_code(2) and (not op_code(1)) and op_code(0));
				O(14) <= ((not op_code(3)) and op_code(2) and op_code(1) and op_code(0));
				en(4 downto 0) <= "00010";
				en(15 downto 8) <= "00000000";
			when S7 =>
				O(4) <= '0';
				O(9 downto 8) <= "01";
				en(4 downto 0) <= "00100";
				en(15 downto 8) <= "00000100";
			when S8 =>
				O(4) <= '1';
				O(16) <= (op_code(3) and op_code(2) and (not op_code(1)) and op_code(0));
            O(17) <= (op_code(3) and op_code(2) and op_code(1) and op_code(0));

				en(4 downto 0) <= "00000";
				en(12 downto 8) <= "00000";
				en(13) <= (op_code(3) and op_code(2) and not op_code(1) and op_code(0));
            en(15 downto 14) <= "10";
			when S9 =>
				O(4) <= '1';
				O(10) <= (op_code(3) and op_code(2) and op_code(1) and op_code(0));
				O(11) <= (op_code(3) and op_code(2) and op_code(0));
				O(14 downto 12) <= "000";
				en(4 downto 0) <= "00001";
				en(15 downto 8) <= "00000000";

			when others =>
				O <= (others => 'Z');
				en <= (others => 'Z');
		end case;
	end process;
	
	
	next_state:
	process(op_code, condition, reset, Q)
	begin
		nQ <= Q;
		case Q is
			when S0 => nQ <= S1;
			when S1 =>
				case op_code is
					when "1000" => nQ <= S4;	--LHI
					when "1001" => nQ <= S4;	--LLI
					when "1111" => nQ <= S5;	--JLR
					when "1101" => nQ <= S9;	--JAL
					when others =>	nQ <= S2;
				end case;
			when S2 => nQ <= S3;
			when S3 =>
				case op_code is
					when "1010" => nQ <= S7;	--LW
					when "1011" => nQ <= S6;	--SW
					when "1100" => nQ <= S8; 	--BEQ
					when others =>	nQ <= S4;   
				end case;
			when S4 => nQ <= S1;
			
			when S5 => nQ <= S9;

			when S6 => nQ <= S1;
				
			when S7 => nQ <= S4;
				
			when S8 => nQ <= S4;
			
			when S9 => nQ <= S8;
				
			when others => 
				nQ <= S0;
		end case;
		
		if (reset = '1') then
			nQ <= S0;
		end if;
	end process;
		
end architecture;