LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity CAM_FSM is
  port (clk, reset:	in STD_LOGIC;
			port_comparator : in STD_LOGIC;
			fwd_ready : in STD_LOGIC;
			tbl_ready : out STD_LOGIC;
			read_SA, read_DA, write_SP : out STD_LOGIC );
end CAM_FSM;

architecture mult_seg_arch of CAM_FSM is
	type state_type is
	(s0, sWait, s1, s2, s3, s4);
	signal state_reg, state_next: state_type;

begin                                     -- begin the architecture definition
	
	process (clk, reset) -- state register definition
	begin
		if (reset = '1')then
			state_reg <= s0;
		elsif (clk'event and clk = '1') then
			state_reg <= state_next;
		end if;
	end process;
	
	process (state_reg, port_comparator) -- next state logic
	begin
		case state_reg is
			when s0 =>
				if (fwd_ready = '1') then
					state_next <= sWait;
				else
					state_next <= s0;
				end if;
			when sWait =>
				state_next <= s1;
			when s1 =>
				state_next <= s2;
			when s2 =>
				state_next <= s3;
			when s3 =>
				if (port_comparator = '1') then
					
					state_next <= s0;
				else
					state_next <= s4;
				end if;
			when s4 =>
				state_next <= s0;
		end case;
	 end process;

	process (state_reg)
	begin
		case state_reg is
			when s0 =>
				tbl_ready <= '1';
				read_DA <= '0';
				read_SA <= '0';
				write_SP <= '0';
			when sWait =>
				tbl_ready <= '1';
				read_DA <= '0';
				read_SA <= '0';
				write_SP <= '0';
			when s1 =>
				tbl_ready <= '0';
				read_DA <= '1';
				read_SA <= '0';
				write_SP <= '0';
			when s2 =>
				tbl_ready <= '0';
				read_DA <= '0';
				read_SA <= '1';
				write_SP <= '0';
			when s3 =>
				tbl_ready <= '0';
				read_DA <= '0';
				read_SA <= '0';
				write_SP <= '0';
			when s4 =>
				tbl_ready <= '0';
				read_DA <= '0';
				read_SA <= '0';
				write_SP <= '1';
			end case;
	end process;
end mult_seg_arch;