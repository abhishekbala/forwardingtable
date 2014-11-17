LIBRARY IEEE, STD;
USE IEEE.std_logic_1164.all;
--USE IEEE.std_logic_components.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_misc.all;
USE IEEE.std_logic_unsigned.all;

-- http://www.oocities.org/deepakgeorge2000/cam.htm
-- Basic set up of a table, configured for 48 bit tag (address), 

ENTITY fwdTable IS
  PORT     (clk              : IN   STD_LOGIC;                   --   Clock
            rst              : IN   STD_LOGIC;                   --   Reset
            rd_b             : in   STD_LOGIC;                   --   Read
            wr_b             : in   STD_LOGIC;                   --   Write
            datain           : in   STD_LOGIC_VECTOR(2 downto 0);-- data in
                                                                 -- during write.
            tagin            : in   STD_LOGIC_VECTOR(47 downto 0);-- Tag Data
            data_out         : out  STD_LOGIC_VECTOR(2 downto 0);-- Data out
            --full             : out  STD_LOGIC;                   -- Stack Full  
            hit              : out  STD_LOGIC                    -- Found Match  
           );
END fwdTable;
 
 
ARCHITECTURE cam256_A OF fwdTable IS
TYPE tag_array IS ARRAY (0 to 31) of STD_LOGIC_VECTOR(47 downto 0);
TYPE data_array IS ARRAY (0 to 31) of STD_LOGIC_VECTOR(2 downto 0);
SIGNAL tag              : tag_array;
SIGNAL data             : data_array;
SIGNAL count            : INTEGER RANGE 0 TO 31;
BEGIN
 
PROCESS(clk,rst)
BEGIN
	IF (rst = '1') THEN
    --tag<=(OTHERS=>"0");
		tag(0)	<= ("000000000000000000000000000000000000000000000000");
		tag(1)	<= ("000000000000000000000000000000000000000000000000");
		tag(2)	<= ("000000000000000000000000000000000000000000000000");
		tag(3)	<= ("000000000000000000000000000000000000000000000000");
		tag(4)	<= ("000000000000000000000000000000000000000000000000");
		tag(5)	<= ("000000000000000000000000000000000000000000000000");
		tag(6)	<= ("000000000000000000000000000000000000000000000000");
		tag(7)	<= ("000000000000000000000000000000000000000000000000");
		tag(8)	<= ("000000000000000000000000000000000000000000000000");
		tag(9)	<= ("000000000000000000000000000000000000000000000000");
		tag(10)	<= ("000000000000000000000000000000000000000000000000");
		tag(11)	<= ("000000000000000000000000000000000000000000000000");
		tag(12)	<= ("000000000000000000000000000000000000000000000000");
		tag(13)	<= ("000000000000000000000000000000000000000000000000");
		tag(14)	<= ("000000000000000000000000000000000000000000000000");
		tag(15)	<= ("000000000000000000000000000000000000000000000000");
		tag(16)	<= ("000000000000000000000000000000000000000000000000");
		tag(17)	<= ("000000000000000000000000000000000000000000000000");
		tag(18)	<= ("000000000000000000000000000000000000000000000000");
		tag(19)	<= ("000000000000000000000000000000000000000000000000");
		tag(20)	<= ("000000000000000000000000000000000000000000000000");
		tag(21)	<= ("000000000000000000000000000000000000000000000000");
		tag(22)	<= ("000000000000000000000000000000000000000000000000");
		tag(23)	<= ("000000000000000000000000000000000000000000000000");
		tag(24)	<= ("000000000000000000000000000000000000000000000000");
		tag(25)	<= ("000000000000000000000000000000000000000000000000");
		tag(26)	<= ("000000000000000000000000000000000000000000000000");
		tag(27)	<= ("000000000000000000000000000000000000000000000000");
		tag(28)	<= ("000000000000000000000000000000000000000000000000");
		tag(29)	<= ("000000000000000000000000000000000000000000000000");
		tag(30)	<= ("000000000000000000000000000000000000000000000000");
		tag(31)	<= ("000000000000000000000000000000000000000000000000");
    --data<=(OTHERS=>"0");
		data(0)	<= ("000");
		data(1)	<= ("000");
		data(2)	<= ("000");
		data(3)	<= ("000");
		data(4)	<= ("000");
		data(5)	<= ("000");
		data(6)	<= ("000");
		data(7)	<= ("000");
		data(8)	<= ("000");
		data(9)	<= ("000");
		data(10)	<= ("000");
		data(11)	<= ("000");
		data(12)	<= ("000");
		data(13)	<= ("000");
		data(14)	<= ("000");
		data(15)	<= ("000");
		data(16)	<= ("000");
		data(17)	<= ("000");
		data(18)	<= ("000");
		data(19)	<= ("000");
		data(20)	<= ("000");
		data(21)	<= ("000");
		data(22)	<= ("000");
		data(23)	<= ("000");
		data(24)	<= ("000");
		data(25)	<= ("000");
		data(26)	<= ("000");
		data(27)	<= ("000");
		data(28)	<= ("000");
		data(29)	<= ("000");
		data(30)	<= ("000");
		data(31)	<= ("000");
		
    count<= 0;
    --full <= '0';
 -----------------------------------------------------------------------
 --  Stack Write Operation
 -----------------------------------------------------------------------
  ELSIF ( clk'EVENT and clk='1') THEN
    IF (wr_b = '1' and rd_b = '0') THEN
		hit <= '0';
      IF ( count = 31 ) THEN
		  --count <= 0;
		  tag (conv_integer (count))<= tagin;
        data(conv_integer (count))<= datain;
        count <= 0;  
      ELSE
        tag (conv_integer (count))<= tagin;
        data(conv_integer (count))<= datain;
        count <= count +1;
      END IF;
	 ELSIF (wr_b = '1' and rd_b = '1') THEN
		hit <= '0';
	 ELSIF (wr_b = '0' and rd_b = '0') THEN
		hit <= '0';
---------------------------------------------------------------------------
--  Stack CAM Read  Operation
---------------------------------------------------------------------------
    ELSIF (wr_b = '0' and rd_b = '1') THEN
      FOR addr IN 0 TO 31 LOOP             --   Check for data
        IF ( tagin = tag(conv_integer (addr))) THEN
          hit <= '1';                    --   Found Match
          data_out <= data ( conv_integer (addr));
        ELSE
          --hit <= 0;			 --   No match found
			 data_out <= "111";
        END IF;
      END LOOP;
    END IF; 
  END IF;
END PROCESS; 
 
END cam256_A;
