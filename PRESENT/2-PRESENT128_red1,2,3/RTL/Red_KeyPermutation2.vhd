----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Anita Aghaie, Amir Moradi
-- All rights reserved.

-- BSD-3-Clause License
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of the copyright holder, their organization nor the
--       names of its contributors may be used to endorse or promote products
--       derived from this software without specific prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Red_KeyPermutation2 is
	Generic ( 
		BitNumber     : NATURAL;
		Table         : STD_LOGIC_VECTOR(63 downto 0));
	port(
		data_in	: in  std_logic_vector(3 downto 0);
		data_out : out std_logic);
end entity Red_KeyPermutation2;

architecture behavioral of Red_KeyPermutation2 is

	constant Table0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(60) & Table(56) & Table(52) & Table(48) & Table(44) & Table(40) & Table(36) & Table(32) &
		Table(28) & Table(24) & Table(20) & Table(16) & Table(12) & Table(8) & Table(4) & Table(0);
	
	constant Table1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(61) & Table(57) & Table(53) & Table(49) & Table(45) & Table(41) & Table(37) & Table(33) &
		Table(29) & Table(25) & Table(21) & Table(17) & Table(13) & Table(9) & Table(5) & Table(1);

	constant Table2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(62) & Table(58) & Table(54) & Table(50) & Table(46) & Table(42) & Table(38) & Table(34) &
		Table(30) & Table(26) & Table(22) & Table(18) & Table(14) & Table(10) & Table(6) & Table(2);

	constant Table3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		Table(63) & Table(59) & Table(55) & Table(51) & Table(47) & Table(43) & Table(39) & Table(35) &
		Table(31) & Table(27) & Table(23) & Table(19) & Table(15) & Table(11) & Table(7) & Table(3);
	
begin

	GEN0: IF BitNumber=0 GENERATE
		LF_Process0: Process (data_in)
		begin
			data_out <= Table0(15-to_integer(unsigned(data_in)));
		end process;	
	END GENERATE;

	GEN1: IF BitNumber=1 GENERATE
		LF_Process1: Process (data_in)
		begin
			data_out <= Table1(15-to_integer(unsigned(data_in)));
		end process;	
	END GENERATE;

	GEN2: IF BitNumber=2 GENERATE
		LF_Process2: Process (data_in)
		begin
			data_out <= Table2(15-to_integer(unsigned(data_in)));
		end process;	
	END GENERATE;

	GEN3: IF BitNumber=3 GENERATE
		LF_Process3: Process (data_in)
		begin
			data_out <= Table3(15-to_integer(unsigned(data_in)));
		end process;	
	END GENERATE;

end architecture behavioral;
