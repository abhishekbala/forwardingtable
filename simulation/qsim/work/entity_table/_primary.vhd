library verilog;
use verilog.vl_types.all;
entity entity_table is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        src_port_data   : in     vl_logic_vector(2 downto 0);
        src_mac_data    : in     vl_logic_vector(47 downto 0);
        dst_mac_data    : in     vl_logic_vector(47 downto 0);
        fwd_ready       : in     vl_logic;
        tbl_ready       : out    vl_logic;
        tbl_data_valid  : out    vl_logic;
        dst_port_data   : out    vl_logic_vector(2 downto 0);
        test_writeCAM   : out    vl_logic;
        test_readCAM    : out    vl_logic;
        test_tristateOut: out    vl_logic_vector(47 downto 0);
        test_fsmReadSA  : out    vl_logic;
        test_portComp   : out    vl_logic;
        test_srcPort    : out    vl_logic_vector(2 downto 0);
        test_dataout    : out    vl_logic_vector(2 downto 0)
    );
end entity_table;
