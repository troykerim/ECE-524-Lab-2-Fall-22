--Part 1 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity reg_file_4x8 is
    Port ( clk : in STD_LOGIC;
           wr_en : in STD_LOGIC;
           w_addr : in STD_LOGIC_VECTOR (1 downto 0);
           r_addr : in STD_LOGIC_VECTOR (1 downto 0);
           w_data : in STD_LOGIC_VECTOR (7 downto 0);
           r_data : out STD_LOGIC_VECTOR (7 downto 0));
end reg_file_4x8;

architecture Behavioral of reg_file_4x8 is
    constant ADDR_WIDTH : natural := 2;
    constant DATA_WIDTH : natural := 8;
    type mem_2d_type is array (0 to 2 ** ADDR_WIDTH - 1 ) of
        std_logic_vector(DATA_WIDTH - 1 downto 0);
    
signal array_reg : mem_2d_type;
signal en        : std_logic_vector(2 ** ADDR_WIDTH - 1 downto 0);

begin

--Read the Data file for 2^8 


--creating 4 registers 
process (clk)
begin
    if(rising_edge(clk)) then
        if en(3) = '1' then
            array_reg(3) <= w_data;
        end if;
        if en(2) = '1' then
            array_reg(2) <= w_data;
        end if;
        if en(1) = '1' then
            array_reg(1) <= w_data;
        end if;
        if en(0) = '1' then
            array_reg(0) <= w_data;
        end if;
    end if;
end process;

--decoding logic for write address
process (wr_en, w_addr)
begin
    if(wr_en = '0') then
        en <= (others => '0');
    else
        case w_addr is 
            when "00" => en <= "0001";
            when "01" => en <= "0010";
            when "10" => en <= "0100";
            when others => en <= "1000";
        end case;
   end if;
end process;

--Read Multiplexing 
with r_addr select r_data <= 
    array_reg(0) when "00",
    array_reg(1) when "01",
    array_reg(2) when "10",
    array_reg(3) when others;
end Behavioral;
