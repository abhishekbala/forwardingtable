library verilog;
use verilog.vl_types.all;
entity camTestBench_vlg_check_tst is
    port(
        data_out        : in     vl_logic_vector(2 downto 0);
        read_state      : in     vl_logic;
        start_out       : in     vl_logic;
        test_good       : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end camTestBench_vlg_check_tst;
