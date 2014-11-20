LIBRARY IEEE, STD;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_misc.all;
USE IEEE.std_logic_unsigned.all;


ENTITY entity_table IS 
	PORT (
			clk					: IN	STD_LOGIC;
			reset					: IN	STD_LOGIC;
			src_port_data		: IN	STD_LOGIC_VECTOR(2 downto 0);
			src_mac_data		: IN 	STD_LOGIC_VECTOR(47 downto 0);
			dst_mac_data		: IN	STD_LOGIC_VECTOR(47 downto 0);
			fwd_ready 			: IN 	STD_LOGIC;

			tbl_ready			: OUT	STD_LOGIC;
			tbl_data_valid		: OUT	STD_LOGIC;
			dst_port_data		: OUT	STD_LOGIC_VECTOR(2 downto 0);
			test_writeCAM		: OUT STD_LOGIC;
			test_readCAM		: OUT STD_LOGIC;
			test_tristateOut 	: OUT STD_LOGIC_VECTOR(47 downto 0);
			test_fsmReadSA		: OUT STD_LOGIC;
			test_portComp		: OUT STD_LOGIC;
			test_srcPort		: OUT STD_LOGIC_VECTOR(2 downto 0);
			test_dataout		: OUT STD_LOGIC_VECTOR(2 downto 0)
			);
END entity_table;


architecture module_interface of entity_table is

	COMPONENT tristate3
		PORT (data_in : IN STD_LOGIC_VECTOR(2 downto 0);
			En : IN STD_LOGIC ;
			data_out :	OUT STD_LOGIC_VECTOR(2 downto 0));
	END COMPONENT ;

	COMPONENT tristate48
		PORT (data_in : IN STD_LOGIC_VECTOR(47 downto 0);
			En : IN STD_LOGIC ;
			data_out :	OUT STD_LOGIC_VECTOR(47 downto 0));
	END COMPONENT ;
	

	COMPONENT CAM_FSM
		port (clk, reset:	in STD_LOGIC;
			port_comparator : in STD_LOGIC;
			fwd_ready : in STD_LOGIC;
			tbl_ready : out STD_LOGIC;
			read_SA, read_DA, write_SP : out STD_LOGIC;
			clk_enable_SA, clk_enable_DA, clk_enable_SP : out STD_LOGIC);
	END COMPONENT;
	
	COMPONENT fwdTable
		PORT (clk              : IN   STD_LOGIC;                   --   Clock
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
	END COMPONENT;
	
	COMPONENT compare
		port (
			cam_data_out : in STD_LOGIC_VECTOR(2 downto 0);
			sp_reg : in STD_LOGIC_VECTOR(2 downto 0);
			port_comparator : out STD_LOGIC  );
	end COMPONENT;
	
	COMPONENT register3bits
		port (
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			enable	: IN STD_LOGIC ;
			load		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
	end COMPONENT;
	
	COMPONENT register48bits
		port (
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (47 DOWNTO 0);
			enable	: IN STD_LOGIC ;
			load		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (47 DOWNTO 0)
	);
	end COMPONENT;
	
	signal tristate_out : STD_LOGIC_VECTOR(47 downto 0);
	signal FSM_read_SA : STD_LOGIC;
	signal FSM_read_DA : STD_LOGIC;
	signal FSM_write_SP : STD_LOGIC;
	signal dataout : STD_LOGIC_VECTOR(2 downto 0);
	signal port_comparator_signal : STD_LOGIC;
	signal clk_enable_DA : STD_LOGIC;
	signal clk_enable_SA : STD_LOGIC;
	signal clk_enable_SP : STD_LOGIC;
	signal reg48_DA_out	: STD_LOGIC_VECTOR(47 downto 0);
	signal reg48_SA_out	: STD_LOGIC_VECTOR(47 downto 0);
	signal reg3_SP_out	: STD_LOGIC_VECTOR(2 downto 0);
	
	-- START
	begin
		test_writeCAM <= FSM_write_SP;
		test_readCAM <= FSM_read_DA OR FSM_read_SA;
		test_portComp <= port_comparator_signal;
		test_tristateOut <= tristate_out;
		test_fsmReadSA <= fsm_read_SA;
		test_srcPort <= reg3_SP_out;
		test_dataout <= dataout;
		
		CAM: fwdTable PORT MAP (
			clk => clk,
			rst => reset,
			rd_b => FSM_read_DA OR FSM_read_SA,
			wr_b => FSM_write_SP,
			datain => reg3_SP_out,
			tagin => tristate_out,
			data_out => dataout,
			hit => tbl_data_valid
		);
		
		COMPARE_PORTS: compare PORT MAP(
			cam_data_out => dataout,
			sp_reg => reg3_SP_out,
			port_comparator => port_comparator_signal
		);
		
		Finite_State_Machine: CAM_FSM PORT MAP(
			clk => clk,
			reset => reset,
			port_comparator => port_comparator_signal,
			fwd_ready => fwd_ready,
			tbl_ready => tbl_ready,
			read_SA => fsm_read_SA,
			read_DA => fsm_read_DA,
			write_SP => fsm_write_SP,
			clk_enable_DA => clk_enable_DA,
			clk_enable_SA => clk_enable_SA,
			clk_enable_SP => clk_enable_SP
		);
		
		src_tristate: tristate48 PORT MAP(
			data_in => reg48_SA_out,
			En => fsm_read_SA,
			data_out => tristate_out
		);
		
		dst_tristate: tristate48 PORT MAP(
			data_in => reg48_DA_out,
			En => fsm_read_DA,
			data_out => tristate_out
		);
		
		data_out_tristate: tristate3 PORT MAP(
			data_in => dataout,
			En => fsm_read_SA,
			data_out => dst_port_data
		);
			
		-- STORING INPUTS IN REGISTERS
		dst_reg: register48bits PORT MAP(
			aclr => '0',
			clock => clk,
			data => dst_mac_data,
			enable => clk_enable_DA,
			load => '1',
			q => reg48_DA_out
		);
		
		src_reg: register48bits PORT MAP(
			aclr => '0',
			clock => clk,
			data => src_mac_data,
			enable => clk_enable_SA,
			load => '1',
			q => reg48_SA_out
		);
		
		sp_reg: register3bits PORT MAP(
			aclr => '0',
			clock => clk,
			data => src_port_data,
			enable => clk_enable_SP,
			load => '1',
			q => reg3_SP_out
		);

end module_interface;
