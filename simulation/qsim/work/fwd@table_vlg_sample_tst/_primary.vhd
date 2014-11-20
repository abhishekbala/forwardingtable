library verilog;
use verilog.vl_types.all;
entity fwdTable_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic_vector(2 downto 0);
        rd_b            : in     vl_logic;
        rst             : in     vl_logic;
        tagin           : in     vl_logic_vector(47 downto 0);
        wr_b            : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end fwdTable_vlg_sample_tst;
