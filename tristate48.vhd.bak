LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tristate IS
PORT ( data_in 	: IN STD_LOGIC_VECTOR(31 downto 0);
	En			: IN STD_LOGIC;
	data_out	: OUT STD_LOGIC_VECTOR(31 downto 0));
END tristate;

ARCHITECTURE behavior OF tristate IS
begin
	process(data_in, En)
	begin
		if En = '1' then
			data_out <= data_in;
		else
			for i in 0 to 31 loop
				data_out(i) <= 'Z';
			end loop;
		end if;
	end process;
end behavior;