--Part 1 16 bit version

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity sync_rom_16 is
    Port ( clk : in STD_LOGIC;
           addr_r : in STD_LOGIC_VECTOR (8 downto 0);
           data : out STD_LOGIC_VECTOR (15 downto 0));
end sync_rom_16;

architecture Behavioral of sync_rom_16 is
    constant ADDR_WIDTH : integer := 7;
    constant DATA_WIDTH : integer := 15;
    type rom_type is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);

--Read Text File

begin

process (clk)
begin
    if(rising_edge(clk))then 
        data <= rom(to_integer(usigned(addr_r)));
    end if;
    
end process;

end Behavioral;
