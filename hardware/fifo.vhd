library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo is
    generic (
        ADDR_WIDTH : integer := 8;
        DATA_WIDTH : integer := 8
        );
    Port(
        clk, rst : in std_logic;
        rd, wr : in std_logic;
        w_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
        empty : out std_logic;
        full : out std_logic;
        r_data : out std_logic_vector (DATA_WIDTH-1 downto 0);
        
        word_count : out unsigned(DATA_WIDTH-1 downto 0);
        almost_empty : out std_logic;
        almost_full : out std_logic
        );
end fifo;

architecture Behavioral of fifo is
    signal full_tmp : std_logic;
    signal wr_en : std_logic;
    signal w_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal r_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
    
begin

wr_en <= wr and (not full_tmp);
full <= full_tmp;

ctrl_unit : entity work.fifo_ctrl(Behavioral)
    generic map(ADDR_WIDTH => ADDR_WIDTH)
    port map(
        clk => clk,
        rst => rst,
        rd => rd,
        wr => wr,
        empty => empty,
        full => full_tmp,
        w_addr => w_addr,
        r_addr => r_addr,
        word_count => word_count,
        almost_empty => almost_empty,
        almost_full => almost_full
        );
 reg_file : entity work.reg_file(Behavioral)
    generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH)
    port map(
        clk => clk,
        w_addr => w_addr,
        r_addr => r_addr,
        w_data => w_data,
        r_data => r_data,
        wr_en => wr_en);
        
end Behavioral;






