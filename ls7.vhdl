library ieee;
use ieee.std_logic_1164.all;


entity LS7  is
  port (LS_IN: in std_logic_vector(15 downto 0); LS_OUT: out std_logic_vector(15 downto 0));
end entity LS7;

architecture bhv of LS7 is
begin
  LS_OUT(15 downto 0) <= LS_IN(8 downto 0) & ('0','0','0','0','0','0','0');
end architecture;