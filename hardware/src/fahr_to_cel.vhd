--Lab 2 Part 2 
--Fahr to Cel vice versa

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity fahr_to_cel is
    Port ( 
           clk : in std_logic;
           is_f : in std_logic; --check convension 
           data_in : in std_logic_vector(7 downto 0);    --8 bit input
           data_out : out std_logic_vector(7 downto 0)  --8 bit output
           );  
           
end fahr_to_cel;

architecture Behavioral of fahr_to_cel is
constant ADDR_WIDTH: integer := 8;
constant DATA_WIDTH: integer := 8;
constant DEPTH: integer := 2**ADDR_WIDTH;

    type rom_type is array (0 to DEPTH-1)
       of std_logic_vector(DATA_WIDTH-1 downto 0);
    impure function init_rom(d_type: std_logic) return rom_type is
        file text_file_C2F: text open read_mode is "../data/c2f.txt"; --Fix 
        file text_file_F2C: text open read_mode is "../data/f2c.txt"; --Fix
        variable text_line : line;
        variable value : std_logic_vector(DATA_WIDTH-1 downto 0);
        variable rom_content: rom_type;
    begin
    
        for i in 0 to DEPTH-1 loop
            if d_type = '0' then
                readline(text_file_C2F, text_line);
            else
                readline(text_file_F2C, text_line);
            end if;
            read(text_line, value);
            rom_content(i) := value;
        end loop;
        
        return rom_content;
    
    end function; 
signal romC2F: rom_type := init_rom('0');
signal romF2C: rom_type := init_rom('1');  

begin
process(clk)
begin
    if rising_edge(clk) then
        if (is_f = '0') then
            data_out <= romC2F(to_integer(unsigned(data_in)));
        else
            data_out <= romF2C(to_integer(unsigned(data_in)));
        end if;
    end if;
end process;
end Behavioral;
