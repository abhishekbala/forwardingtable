LIBRARY IEEE, STD;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_misc.all;
USE IEEE.std_logic_unsigned.all;


ENTITY entity_table IS 
	PORT (
			-- input
			clk				: IN	STD_LOGIC;
			reset				: IN	STD_LOGIC;
			src_port_data	: IN	STD_LOGIC_VECTOR(2 downto 0);
			src_mac_data	: IN 	STD_LOGIC_VECTOR(47 downto 0);
			dst_mac_data	: IN	STD_LOGIC_VECTOR(47 downto 0);
			fwd_ready 		: IN STD_LOGIC;
			-- output
			tbl_ready		: OUT 	STD_LOGIC;
			tbl_data_valid	: OUT	STD_LOGIC;
			dst_port_data	: OUT	STD_LOGIC_VECTOR(2 downto 0);
			test_writeCAM	: OUT STD_LOGIC;
			test_readCAM	: OUT STD_LOGIC;
			test_tristateOut :	OUT STD_LOGIC_VECTOR(47 downto 0);
			test_fsmReadSA	: OUT STD_LOGIC;
			test_portComp	: OUT STD_LOGIC;
			test_SPdata0	: OUT STD_LOGIC_VECTOR(2 downto 0);
			test_SPdata1	: OUT STD_LOGIC_VECTOR(2 downto 0);
			test_SPdata2	: OUT STD_LOGIC_VECTOR(2 downto 0);
			test_SPdata3	: OUT STD_LOGIC_VECTOR(2 downto 0);
			test_SPdata4	: OUT STD_LOGIC_VECTOR(2 downto 0)
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
	
	COMPONENT reg3
		PORT (clock, ctrl_reset, ctrl_writeReg, ctrl_readReg : IN STD_LOGIC;
			data_writeReg    : IN STD_LOGIC_VECTOR(2 downto 0);
			data_readReg    : OUT STD_LOGIC_VECTOR(2 downto 0));
	END COMPONENT;
	
	COMPONENT reg48
		PORT (clock, ctrl_reset, ctrl_writeReg, ctrl_readReg : IN STD_LOGIC;
			data_writeReg    : IN STD_LOGIC_VECTOR(47 downto 0);
			data_readReg    : OUT STD_LOGIC_VECTOR(47 downto 0));
	END COMPONENT;

	COMPONENT CAM_FSM
		port (clk, reset:	in STD_LOGIC;
			port_comparator : in STD_LOGIC;
			fwd_ready : in STD_LOGIC;
			tbl_ready : out STD_LOGIC;
			read_SA, read_DA, write_SP : out STD_LOGIC );
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
	
	signal tristate_out : STD_LOGIC_VECTOR(47 downto 0);
	signal FSM_read_SA : STD_LOGIC;
	signal FSM_read_DA : STD_LOGIC;
	signal FSM_write_SP : STD_LOGIC;
	signal dataout : STD_LOGIC_VECTOR(2 downto 0);
	signal port_comparator_signal : STD_LOGIC;
	
	signal data_reg3_SP_1 : STD_LOGIC_VECTOR(2 downto 0);
	signal data_reg3_SP_2 : STD_LOGIC_VECTOR(2 downto 0);
	signal data_reg3_SP_3 : STD_LOGIC_VECTOR(2 downto 0);
	signal data_reg3_SP_4 : STD_LOGIC_VECTOR(2 downto 0);
	
	signal data_reg48_SA_1 : STD_LOGIC_VECTOR(47 downto 0);
	signal data_reg48_SA_2: STD_LOGIC_VECTOR(47 downto 0);
	signal data_reg48_SA_3: STD_LOGIC_VECTOR(47 downto 0);
	signal data_reg48_SA_4: STD_LOGIC_VECTOR(47 downto 0);
	
	signal data_reg48_DA : STD_LOGIC_VECTOR(47 downto 0);
	
	
	-- START
	begin
		test_writeCAM <= FSM_write_SP;
		test_readCAM <= FSM_read_DA OR FSM_read_SA;
		test_portComp <= port_comparator_signal;
		test_tristateOut <= tristate_out;
		test_fsmReadSA <= fsm_read_SA;
		test_SPdata0 <= src_port_data;
		test_SPdata1 <= data_reg3_SP_1 ;
		test_SPdata2 <= data_reg3_SP_2 ;
		test_SPdata3 <= data_reg3_SP_3 ;
		test_SPdata4 <= data_reg3_SP_4 ;
		
		CAM: fwdTable PORT MAP (
			clk => clk,
			rst => reset,
			rd_b => FSM_read_DA OR FSM_read_SA,
			wr_b => FSM_write_SP,
			datain => data_reg3_SP_4,
			tagin => tristate_out,
			data_out => dataout,
			hit => tbl_data_valid
		);
		
		COMPARE_PORTS: compare PORT MAP(
			cam_data_out => dataout,
			sp_reg => data_reg3_SP_3,
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
			write_SP => fsm_write_SP
		);
		
		src_tristate: tristate48 PORT MAP(
			data_in => data_reg48_SA_2,
			En => fsm_read_SA,
			data_out => tristate_out
		);
		
		src_tristate_rewrite: tristate48 PORT MAP(
			data_in => data_reg48_SA_4,
			En => fsm_write_SP,
			data_out => tristate_out
		);
		
		dst_tristate: tristate48 PORT MAP(
			data_in => data_reg48_DA,
			En => fsm_read_DA,
			data_out => tristate_out
		);
		
		data_out_tristate: tristate3 PORT MAP(
			data_in => dataout,
			En => fsm_read_SA,
			data_out => dst_port_data
		);
		
		
		
		-- STORING INPUTS IN REGISTERS
		
		dst_reg48: reg48 PORT MAP(
			clock => clk,
			ctrl_reset => reset,
			ctrl_writeReg => '1',
			ctrl_readReg => '1',
			
			data_writeReg => dst_mac_data,
			data_readReg => data_reg48_DA
		);
		
		
		src_reg48_1: reg48 PORT MAP(
			clock => clk,
			ctrl_reset => reset,
			ctrl_writeReg => '1',
			ctrl_readReg => '1',
			
			data_writeReg => src_mac_data,
			data_readReg => data_reg48_SA_1
		);
		
		src_reg48_2: reg48 PORT MAP(
			clock => clk,
			ctrl_reset => reset,
			ctrl_writeReg => '1',
			ctrl_readReg => '1',
			
			data_writeReg => data_reg48_SA_1,
			data_readReg => data_reg48_SA_2
		);
		
		src_reg48_3: reg48 PORT MAP(
			clock => clk,
			ctrl_reset => reset,
			ctrl_writeReg => '1',
			ctrl_readReg => '1',
			
			data_writeReg => data_reg48_SA_2,
			data_readReg => data_reg48_SA_3
		);
		
		src_reg48_4: reg48 PORT MAP(
			clock => clk,
			ctrl_reset => reset,
			ctrl_writeReg => '1',
			ctrl_readReg => '1',
			
			data_writeReg => data_reg48_SA_3,
			data_readReg => data_reg48_SA_4
		);
		-- DONE WITH MAC ADDRESSES
		
		-- PORT DATA INPUTS
		src_reg3_1: reg3 PORT MAP(
			clock => clk,
			ctrl_reset => reset,
			ctrl_writeReg => '1',
			ctrl_readReg => '1',
			data_writeReg => src_port_data ,
			data_readReg => data_reg3_SP_1
		);
		
		src_reg3_2: reg3 PORT MAP(
			clock => clk,
			ctrl_reset => reset,
			ctrl_writeReg => '1',
			ctrl_readReg => '1',
			data_writeReg => data_reg3_SP_1,
			data_readReg => data_reg3_SP_2
		);
		
		src_reg3_3: reg3 PORT MAP(
			clock => clk,
			ctrl_reset => reset,
			ctrl_writeReg => '1',
			ctrl_readReg => '1',
			data_writeReg => data_reg3_SP_2,  
			data_readReg => data_reg3_SP_3  
		);
		
		src_reg3_4: reg3 PORT MAP(
			clock => clk,
			ctrl_reset => reset,
			ctrl_writeReg => '1',
			ctrl_readReg => '1',
			data_writeReg => data_reg3_SP_3,  
			data_readReg => data_reg3_SP_4  
		);
		
end module_interface;
