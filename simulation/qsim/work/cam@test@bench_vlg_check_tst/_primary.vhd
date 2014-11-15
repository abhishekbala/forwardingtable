library verilog;
use verilog.vl_types.all;
entity camTestBench_vlg_check_tst is
    port(
        count_enable_d  : in     vl_logic;
        count_val_d     : in     vl_logic_vector(11 downto 0);
        data_out        : in     vl_logic_vector(2 downto 0);
        read_state      : in     vl_logic;
        start_out       : in     vl_logic;
        test_good       : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end camTestBench_vlg_check_tst;
