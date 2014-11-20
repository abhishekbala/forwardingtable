library verilog;
use verilog.vl_types.all;
entity entity_table_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        dst_mac_data    : in     vl_logic_vector(47 downto 0);
        fwd_ready       : in     vl_logic;
        reset           : in     vl_logic;
        src_mac_data    : in     vl_logic_vector(47 downto 0);
        src_port_data   : in     vl_logic_vector(2 downto 0);
        sampler_tx      : out    vl_logic
    );
end entity_table_vlg_sample_tst;
