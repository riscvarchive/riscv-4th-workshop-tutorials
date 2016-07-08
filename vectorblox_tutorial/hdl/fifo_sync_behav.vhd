-- fifo_sync_lattice.vhd
-- Copyright (C) 2015 VectorBlox Computing, Inc.

-- synthesis library vbx_lib
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.util_pkg.all;
use work.architecture_pkg.all;
use work.component_pkg.all;

entity fifo_sync is
  generic (
    CFG_FAM : config_family_type;
    C_IMPL_STYLE : integer := 0;
    WIDTH : positive := 32;
    DEPTH : positive := 4
    );
  port (
    reset : in std_logic;
    clk   : in std_logic;

    we       : in  std_logic;
    data_in  : in  std_logic_vector(WIDTH-1 downto 0);
    full     : out std_logic;
    rd       : in  std_logic;
    data_out : out std_logic_vector(WIDTH-1 downto 0);
    empty    : out std_logic
    );
end fifo_sync;

architecture rtl of fifo_sync is
  type    data_array is array (natural range <>) of std_logic_vector(WIDTH-1 downto 0);
  signal  data_ram           : data_array(DEPTH-1 downto 0);
  subtype ram_address is unsigned(log2(DEPTH)-1 downto 0);
  signal  read_pointer       : ram_address;
  signal  write_pointer      : ram_address;
  signal  read_pointer_p1    : ram_address;
  signal  write_pointer_p1   : ram_address;
  signal  next_read_pointer  : ram_address;
  signal  next_write_pointer : ram_address;
  signal  next_empty         : std_logic;
  signal  next_full          : std_logic;
  signal  usedw              : unsigned(log2(DEPTH) downto 0);
  signal  next_usedw         : unsigned(log2(DEPTH) downto 0);
  signal  we_rd              : std_logic_vector(1 downto 0);
begin
  read_pointer_p1  <= read_pointer + to_unsigned(1, read_pointer'length);
  write_pointer_p1 <= write_pointer + to_unsigned(1, write_pointer'length);
  power_of_two_depth_gen : if 2**log2(DEPTH) = DEPTH generate
    next_read_pointer  <= read_pointer_p1;
    next_write_pointer <= write_pointer_p1;
  end generate power_of_two_depth_gen;
  non_power_of_two_gen : if 2**log2(DEPTH) /= DEPTH generate
    next_read_pointer <=
      to_unsigned(0, next_read_pointer'length) when read_pointer_p1 = to_unsigned(DEPTH, read_pointer_p1'length)
      else read_pointer_p1;
    next_write_pointer <=
      to_unsigned(0, next_write_pointer'length) when write_pointer_p1 = to_unsigned(DEPTH, write_pointer_p1'length)
      else write_pointer_p1;
  end generate non_power_of_two_gen;

  we_rd <= we & rd;
  with we_rd select
    next_usedw <=
    usedw + to_unsigned(1, usedw'length) when "10",
    usedw - to_unsigned(1, usedw'length) when "01",
    usedw                                when others;
  next_empty <= '1' when next_usedw = to_unsigned(0, usedw'length)     else '0';
  next_full  <= '1' when next_usedw = to_unsigned(DEPTH, usedw'length) else '0';

  process (clk)
  begin  -- process
    if clk'event and clk = '1' then     -- rising clock edge
      usedw <= next_usedw;
      empty <= next_empty;
      full  <= next_full;

      if rd = '1' then
        data_out     <= data_ram(to_integer(next_read_pointer));
        read_pointer <= next_read_pointer;
      end if;

      if we = '1' then
        data_ram(to_integer(write_pointer)) <= data_in;
        write_pointer                       <= next_write_pointer;
        if next_usedw = to_unsigned(1, next_usedw'length) then
          data_out <= data_in;
        end if;
      end if;

      if reset = '1' then               -- synchronous reset (active high)
        empty         <= '1';
        full          <= '1';
        usedw         <= to_unsigned(0, usedw'length);
        read_pointer  <= to_unsigned(0, read_pointer'length);
        write_pointer <= to_unsigned(0, write_pointer'length);
      end if;
    end if;
  end process;

end rtl;
