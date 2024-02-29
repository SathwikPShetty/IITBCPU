library ieee;
use ieee.std_logic_1164.all;


entity MB2 is
  port (MB_IN: in std_logic_vector(15 downto 0); MB_OUT: out std_logic_vector(15 downto 0));
end entity MB2;

architecture bhv of MB2 is
begin
  MB_OUT(15 downto 0) <= MB_IN(14 downto 0) & '0';
end architecture;