LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY camTestBench IS
	PORT (	Clock			: IN STD_LOGIC;
				Reset			: IN	STD_LOGIC;
            test_good	: OUT	STD_LOGIC;
--				data_in_v	: OUT STD_LOGIC_VECTOR(2 downto 0);
	         data_out    : OUT STD_LOGIC_VECTOR(2 downto 0);
            start_out	: OUT	STD_LOGIC;
				read_state	: OUT STD_LOGIC
			);
END camTestBench;

ARCHITECTURE test_bench OF camTestBench IS

COMPONENT tbrom48
	PORT
	(
      aclr     : IN STD_LOGIC;
      address	: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		clock		: IN STD_LOGIC;
		q			: OUT STD_LOGIC_VECTOR (47 DOWNTO 0)
	);
END COMPONENT;

COMPONENT fwdTable IS
	PORT
	(
		clk              : IN STD_LOGIC;                   --   Clock
      rst              : IN STD_LOGIC;                   --   Reset
      rd_b             : IN STD_LOGIC;                   --   Read
      wr_b             : IN STD_LOGIC;                   --   Write
      datain           : IN STD_LOGIC_VECTOR(2 DOWNTO 0);  -- data in during write.
      tagin            : IN STD_LOGIC_VECTOR(47 DOWNTO 0); -- Tag Data
      data_out         : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Data out
      hit              : OUT STD_LOGIC                     -- Found Match  
	);
END COMPONENT;

COMPONENT counter12
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		cnt_en	: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END COMPONENT;

	TYPE State_type IS (resetState,writeState,readState,checkState,doneState);
	SIGNAL y_current, y_next		: State_type;
	SIGNAL cam_read					: STD_LOGIC;
   SIGNAL cam_write					: STD_LOGIC;
	SIGNAL read_Control				: STD_LOGIC;
	SIGNAL write_Control				: STD_LOGIC;
	SIGNAL data_in						: STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL tag_in						
		: STD_LOGIC_VECTOR(47 DOWNTO 0) := "000000000000000000000000000000000000000000000000";
	SIGNAL CAM_hit						: STD_LOGIC;
	SIGNAL count_enable				: STD_LOGIC;
	SIGNAL mem_out						: STD_LOGIC_VECTOR(47 DOWNTO 0);
	SIGNAL count_val					: STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL cam_output 				: STD_LOGIC_VECTOR(2 DOWNTO 0);
	CONSTANT check_val				: STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
	CONSTANT tag_val
		: STD_LOGIC_VECTOR(47 DOWNTO 0) := "000000000000000000000000000000000000000000000001";
   CONSTANT count_len
		: STD_LOGIC_VECTOR(11 downto 0) := "000000010000";

BEGIN

CAM: fwdTable PORT MAP (
		clk	 	=> Clock,
      rst    	=> reset,
      rd_b   	=> read_Control,
      wr_b   	=> write_Control,
      datain 	=> data_in,
      tagin  	=> tag_in,
      data_out => data_out,
      hit 		=> CAM_hit
	);

cam_test_mem : tbrom48 PORT MAP (
		address	=> count_val,
      aclr 		=> Reset,
		clock	 	=> Clock,
		q	 		=> mem_out
	);

Counter12Bit: counter12 PORT MAP (
		aclr	 => Reset,
		clock	 => Clock,
		cnt_en => count_enable,
		q	 => count_val
	);
	
	PROCESS(Reset,Clock)
	BEGIN
		IF Reset = '1' THEN
			y_current <= resetState;
		ELSIF Clock'EVENT AND Clock = '1' THEN
			y_current <= y_next;
		END IF;
	END PROCESS;

	PROCESS(y_current,count_val, tag_in, data_in)
	BEGIN
		count_enable <= '0';
		test_good <= '0';
		start_out <= '0';
		CASE y_current IS
			WHEN resetState =>
				read_state <= '0';
				write_Control <= '0';
				read_Control <= '0';
				y_next <= writeState;
				count_enable <= '1';
				start_out <= '1';
			WHEN writeState =>
				IF count_val = count_len THEN	
					y_next <= readState;
					read_state <= '1';
					count_enable <= '0';
				ELSE
					read_state <= '0';
					y_next <= writeState;
					write_Control <= '1';
					read_Control <= '0';
					count_enable <= '1';
					data_in <= mem_out(2 DOWNTO 0);
					tag_in <= mem_out;
				END IF;
			WHEN readState =>
				read_state <= '1';
				write_Control <= '0';
				read_Control <= '1';
				tag_in <= tag_val;
				y_next <= checkState;
			WHEN checkState =>
				y_next <= doneState;
            IF cam_output = check_val THEN
					test_good <= '1';
				ELSE
					test_good <= '0';
				END IF;
			WHEN doneState	=>
				y_next <= doneState;
				start_out <= '1';
				test_good <= '1';
		END CASE;
	END PROCESS;
END test_bench;