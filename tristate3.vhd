LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tristate3 IS
PORT ( data_in 	: IN STD_LOGIC_VECTOR(2 downto 0);
	En			: IN STD_LOGIC;
	data_out	: OUT STD_LOGIC_VECTOR(2 downto 0));
END tristate3;

ARCHITECTURE behavior OF tristate3 IS
begin
	process(data_in, En)
	begin
		if En = '1' then
			data_out <= data_in;
		else
			for i in 0 to 2 loop
				data_out(i) <= 'Z';
			end loop;
		end if;
	end process;
end behavior;