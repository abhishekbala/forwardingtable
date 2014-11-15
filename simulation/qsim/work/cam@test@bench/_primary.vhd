library verilog;
use verilog.vl_types.all;
entity camTestBench is
    port(
        Clock           : in     vl_logic;
        Reset           : in     vl_logic;
        Trigger         : in     vl_logic;
        test_good       : out    vl_logic;
        data_out        : out    vl_logic_vector(2 downto 0);
        start_out       : out    vl_logic;
        read_state      : out    vl_logic;
        count_enable_d  : out    vl_logic;
        count_val_d     : out    vl_logic_vector(11 downto 0)
    );
end camTestBench;
