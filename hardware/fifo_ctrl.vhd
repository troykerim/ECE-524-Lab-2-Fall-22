--Part 5
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fifo_ctrl is
    generic(ADDR_WIDTH : natural := 8);
    Port ( clk,rst : in STD_LOGIC;
           rd, wr : in STD_LOGIC;
           empty, full : out STD_LOGIC;
           w_addr : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           r_addr : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           word_count : out unsigned (ADDR_WIDTH-1 downto 0);
           almost_empty : out std_logic;
           almost_full : out std_logic
           );
end fifo_ctrl;

architecture Behavioral of fifo_ctrl is
    signal w_ptr_reg : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal w_ptr_next : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal w_ptr_succ : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal r_ptr_reg : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal r_ptr_next : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal r_ptr_succ : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal full_reg : std_logic;
    signal full_next : std_logic;
    signal empty_reg : std_logic;
    signal empty_next : std_logic;
    signal wr_op : std_logic_vector (1 downto 0);
    
    signal counter: unsigned (ADDR_WIDTH-1 downto 0);
    --signal is_almost_empty_reg : std_logic;
    signal is_almost_full : std_logic;
    signal is_almost_empty: std_logic;
    --signal is_almost_full_next : std_logic;
    
begin
--register for read and write pointers
process (clk, rst)
begin
    if(rst = '1')then
        w_ptr_reg <= (others => '0');
        r_ptr_reg <= (others => '0');
        full_reg <= '0';
        --counter <= "0";
        
        --is_almost_full_reg <= '0';
       -- is_almost_empty_reg <= '0';
        empty_reg <= '1'; 
        
    elsif(rising_edge(clk)) then
        w_ptr_reg <= w_ptr_next;
        r_ptr_reg <= r_ptr_next;
        full_reg <= full_next;
        empty_reg <= empty_next;
        --is_almost_full_reg <= is_almost_full_next;
        --is_almost_empty_reg <= is_almost_empty_next;
        
    end if;
end process;
--successive pointer values
w_ptr_succ <= std_logic_vector(unsigned(w_ptr_reg) + 1);
r_ptr_succ <= std_logic_vector(unsigned(r_ptr_reg) + 1);

--next state logic for read and write pointers
wr_op <= wr & rd;

process(w_ptr_reg, w_ptr_succ, r_ptr_reg, r_ptr_succ, wr_op, empty_reg,full_reg, empty_next, full_next, is_almost_full,is_almost_empty, counter)
begin
    w_ptr_next <= w_ptr_reg;
    r_ptr_next <= r_ptr_reg;
    empty_next <= empty_reg;
    full_next <= full_reg;
    
    --is_almost_full_next <= is_almost_full_reg;
    --is_almost_empty_next <= is_almost_empty_reg;
    --counter <= counter;
    
    case wr_op is
        when "00" =>
        when "01" =>            --Read Operation
            if(empty_reg /= '1')then
                r_ptr_next <= r_ptr_succ;
                full_next <= '0';
                counter <= counter-1;
                if(counter <= "01000000") then
                is_almost_empty <= '1';
                end if;
                
                if(r_ptr_succ = w_ptr_reg)then
                    empty_next <= '1';
                end if;
                
            end if;
        when "10" =>            --Write Operation
            if(full_reg /= '1') then
                w_ptr_next <= w_ptr_succ;
                empty_next <= '0';
                counter <= counter+1;
                
                if(counter = "11000110") then
                    is_almost_full <= '1';
                    end if;
                if(w_ptr_succ = r_ptr_reg)then
                    full_next <= '1';
                end if;
                --counter <= counter+1;
            end if;
        when others =>
            w_ptr_next <= w_ptr_succ;
            r_ptr_next <= r_ptr_succ;
        end case;    
end process;


--Output
w_addr <= w_ptr_reg;
r_addr <= r_ptr_reg;
full <= full_reg;
empty <= empty_reg;
word_count <= counter;
almost_empty <= is_almost_empty;
almost_full <= is_almost_full;
end Behavioral;
