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
            datain           : in   STD_LOGIC_VECTOR(1 downto 0);-- data in
                                                                 -- during write.
            tagin            : in   STD_LOGIC_VECTOR(47 downto 0);-- Tag Data
            data_out         : out  STD_LOGIC_VECTOR(1 downto 0);-- Data out
            full             : out  STD_LOGIC;                   -- Stack Full  
            hit              : out  STD_LOGIC                    -- Found Match  
           );
END fwdTable;
 
 
ARCHITECTURE cam256_A OF fwdTable IS
TYPE tag_array IS ARRAY (0 to 31) of STD_LOGIC_VECTOR(47 downto 0);
TYPE data_array IS ARRAY (0 to 31) of STD_LOGIC_VECTOR(1 downto 0);
SIGNAL tag              : tag_array;
SIGNAL data             : data_array;
SIGNAL count            : INTEGER RANGE 0 TO 31;
BEGIN
 
PROCESS(clk,rst)
BEGIN
	IF (rst = '1') THEN
    tag<=(OTHERS=>'0');
	 --tag(0)<= ('000000000000000000000000000000000000000000000000');
    data<=(OTHERS=>'0');
	 --data(0)<= ('00');
    count<= 0;
    full <= '0';
 -----------------------------------------------------------------------
 --  Stack Write Operation
 -----------------------------------------------------------------------
  ELSIF ( clk'EVENT and clk='1') THEN
    IF (wr_b = '1' and rd_b = '0') THEN
      IF ( count = 31 ) THEN
        full <= '1';
		  -- With this code, it does not write if CAM is full.
		  -- We need to handle that case.
      ELSE
        tag (conv_integer (count))<= tagin;
        data(conv_integer (count))<= datain;
        count <= count +1;
      END IF;
---------------------------------------------------------------------------
--  Stack CAM Read  Operation
---------------------------------------------------------------------------
    ELSIF (wr_b = '0' and rd_b = '1') THEN
      FOR addr IN 0 TO 31 LOOP             --   Check for data
        IF ( tagin = tag(conv_integer (addr))) THEN
          Hit <= '1';                    --   Found Match
          data_out <= data ( conv_integer (addr));
        ELSE
          hit <= '0';                    --   No match found
        END IF;
      END LOOP;
    END IF; 
  END IF;
END PROCESS; 
 
END cam256_A;
