library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
  port(
   SE_op: in std_logic;
   inp_6bit : in std_logic_vector(5 downto 0);
	inp_9bit : in std_logic_vector(8 downto 0);
	outp_16bit : out std_logic_vector(15 downto 0)
  ) ;
end entity ; 

architecture SE of sign_extend is

begin
	SE:process(SE_op,inp_6bit,inp_9bit)
	begin 
		if(SE_op='1') then --sign extender 9
			outp_16bit(8 downto 0) <= inp_9bit(8 downto 0);
			outp_16bit(9)  <= '0';
			outp_16bit(10) <= '0';
			outp_16bit(11) <= '0';
			outp_16bit(12) <= '0';
			outp_16bit(13) <= '0';
			outp_16bit(14) <= '0';
			outp_16bit(15) <= '0';
		else --sign extender 6
			outp_16bit(5 downto 0) <= inp_6bit(5 downto 0);
			outp_16bit(6) <= '0';
			outp_16bit(7) <= '0';
			outp_16bit(8) <= '0';
			outp_16bit(9) <= '0';
			outp_16bit(10) <= '0';
			outp_16bit(11) <= '0';
			outp_16bit(12) <= '0';
			outp_16bit(13) <= '0';
			outp_16bit(14) <= '0';
			outp_16bit(15) <= '0';
	   end if;
	end process;
end SE;
