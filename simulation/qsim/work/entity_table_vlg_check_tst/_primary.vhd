library verilog;
use verilog.vl_types.all;
entity entity_table_vlg_check_tst is
    port(
        dst_port_data   : in     vl_logic_vector(2 downto 0);
        tbl_data_valid  : in     vl_logic;
        tbl_ready       : in     vl_logic;
        test_dataout    : in     vl_logic_vector(2 downto 0);
        test_fsmReadSA  : in     vl_logic;
        test_portComp   : in     vl_logic;
        test_readCAM    : in     vl_logic;
        test_srcPort    : in     vl_logic_vector(2 downto 0);
        test_tristateOut: in     vl_logic_vector(47 downto 0);
        test_writeCAM   : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end entity_table_vlg_check_tst;
