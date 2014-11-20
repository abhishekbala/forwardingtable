library verilog;
use verilog.vl_types.all;
entity fwdTable is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rd_b            : in     vl_logic;
        wr_b            : in     vl_logic;
        datain          : in     vl_logic_vector(2 downto 0);
        tagin           : in     vl_logic_vector(47 downto 0);
        data_out        : out    vl_logic_vector(2 downto 0);
        hit             : out    vl_logic
    );
end fwdTable;
