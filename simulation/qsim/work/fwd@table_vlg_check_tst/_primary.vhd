library verilog;
use verilog.vl_types.all;
entity fwdTable_vlg_check_tst is
    port(
        data_out        : in     vl_logic_vector(2 downto 0);
        hit             : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end fwdTable_vlg_check_tst;
