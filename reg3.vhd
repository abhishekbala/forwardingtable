LIBRARY ieee;
LIBRARY altera;
USE ieee.std_logic_1164.all;
USE altera.altera_primitives_components.all;

ENTITY reg3 IS
PORT (clock, ctrl_reset, ctrl_writeReg, ctrl_readReg : IN STD_LOGIC;
   data_writeReg    : IN STD_LOGIC_VECTOR(2 downto 0);
   data_readReg    : OUT STD_LOGIC_VECTOR(2 downto 0));
END reg3;

ARCHITECTURE structure OF reg3 IS
	
 	COMPONENT DFFE
	   PORT (d   : IN STD_LOGIC;
			clk  : IN STD_LOGIC;
			clrn : IN STD_LOGIC;
			prn  : IN STD_LOGIC;
			ena  : IN STD_LOGIC;
			q    : OUT STD_LOGIC );
		END COMPONENT;
		
	COMPONENT tristate3
		PORT (data_in : IN STD_LOGIC_VECTOR(2 downto 0);
			En : IN STD_LOGIC ;
			data_out :	OUT STD_LOGIC_VECTOR(2 downto 0));
	END COMPONENT ;
	
	signal triData : STD_LOGIC_VECTOR(2 downto 0) ;

BEGIN
	G1: FOR i IN 0 to 2 GENERATE	
		Flips: DFFE PORT MAP (data_writeReg(i), clock, NOT(ctrl_reset), '1', ctrl_writeReg, triData(i));
	END GENERATE;
	
	T281: tristate3 port map(triData, ctrl_readReg, data_readReg);
	
END structure;