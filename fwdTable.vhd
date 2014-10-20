library IEEE, STD;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_components.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;

-- http://www.oocities.org/deepakgeorge2000/cam.htm
-- Basic set up of a table, configured for 48 bit tag (address), 

entity fwdTable is
  port     (clk              : in   std_logic;                   --   Clock
            rst              : in   std_logic;                   --   Reset
            rd_b             : in   std_logic;                   --   Read
            wr_b             : in   std_logic;                   --   Write
            datain           : in   std_logic_vector(2 downto 0);-- data in
                                                                 -- during write.
            tagin            : in   std_logic_vector(47 downto 0);-- Tag Data
            data_out         : out  std_logic_vector(2 downto 0);-- Data out
            full             : out  std_logic;                   -- Stack Full  
            hit              : out  std_logic                    -- Found Match  
           );
end cam256;
 
 
architecture cam256_A of cam256 is
type ram_array is array (0 to 31) of std_logic_vector(2 downto 0);
signal tag              : ram_array;
signal data             : ram_array;
signal count            : integer range 0 to 31;
begin
 
main : process(clk,rst)
 
begin
  if (rst = '1') then
    tag<=(others=>'0');
    data<=(others=>'0');
    count<= 0;
    full <= '0';
 -----------------------------------------------------------------------
 --  Stack Write Operation
 -----------------------------------------------------------------------
  elsif ( clk'evevt and clk='1') then
    if (wr_b = '0' and rd_b = '1') then
      if ( count = 31 ) then
        full <= '1';
      else
        tag (conv_integer (count))<= tin;
        data(conv_integer (count))<= datain;
        count <= count +1;
      end if;
---------------------------------------------------------------------------
--  Stack CAM Read  Operation
---------------------------------------------------------------------------
    elsif (wr_b = '1' and rd_b = '0') then
      for addr 0 to 31 loop             --   Check for data
        if ( tagin = tag(conv_integer (addr)) then
          Hit <= '1';                    --   Found Match
          data_out <= data ( conv_integer (addr));
        else
          hit <= '0';                    --   No match found
        end if;
      end loop;
    end if 
  end if;
end process; 
 
end cam256_A;
