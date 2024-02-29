library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port (
        MEM_DI: in std_logic_vector(15 downto 0);
        MEM_DO: out std_logic_vector(15 downto 0);
        MEM_A: in std_logic_vector(15 downto 0);
        clk, MEM_WR, MEM_RD, reset: in std_logic
    );
end entity;

architecture struct of memory is
    type ram_type is array(100 downto 0) of std_logic_vector(15 downto 0);
    signal Mem_data : ram_type := (
        "1011000001010011",
        "0101001100000111",
        "0000011100101000",
        "0010100000000011",
        "0000001110000000",
        "1000000000000000",
        others => (others => '0')
    );
begin
    Memory_read : process (Mem_A)
    begin
        if MEM_RD = '1' then
            MEM_DO <= Mem_data(to_integer(unsigned(Mem_A)));
        else
            MEM_DO <= (others => '0');
        end if;
    end process;

    Memory_write : process (clk, Mem_A, MEM_WR, MEM_DI, reset)
    begin
        if reset = '1' then
            Mem_data <= (
                "0000001010011011",
                "0010100101110100",
                "0011000100101000",
                "0010100000000011",
                "0000001110000000",
                "1000000000000000",
                others => (others => '0')
            );
        elsif rising_edge(clk) and MEM_WR = '1' then
            Mem_data(to_integer(unsigned(Mem_A))) <= MEM_DI(15 downto 8);
            Mem_data(to_integer(unsigned(Mem_A)) + 1) <= MEM_DI(7 downto 0);
        end if;
    end process;
end struct;