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

entity Red_SboxPermutation4 is
	Generic ( 
		BitNumber       : NATURAL;
		LFTable         : STD_LOGIC_VECTOR(63 downto 0);
		SboxTable       : STD_LOGIC_VECTOR(63 downto 0);
		InputBitIndex	 : NATURAL);
	port(
		data_in	: in  std_logic_vector(15 downto 0);
		data_out : out std_logic);
end entity Red_SboxPermutation4;

architecture behavioral of Red_SboxPermutation4 is

	constant SboxTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		SboxTable(60) & SboxTable(56) & SboxTable(52) & SboxTable(48) & SboxTable(44) & SboxTable(40) & SboxTable(36) & SboxTable(32) &
		SboxTable(28) & SboxTable(24) & SboxTable(20) & SboxTable(16) & SboxTable(12) & SboxTable(8) & SboxTable(4) & SboxTable(0);
	
	constant SboxTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		SboxTable(61) & SboxTable(57) & SboxTable(53) & SboxTable(49) & SboxTable(45) & SboxTable(41) & SboxTable(37) & SboxTable(33) &
		SboxTable(29) & SboxTable(25) & SboxTable(21) & SboxTable(17) & SboxTable(13) & SboxTable(9) & SboxTable(5) & SboxTable(1);

	constant SboxTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		SboxTable(62) & SboxTable(58) & SboxTable(54) & SboxTable(50) & SboxTable(46) & SboxTable(42) & SboxTable(38) & SboxTable(34) &
		SboxTable(30) & SboxTable(26) & SboxTable(22) & SboxTable(18) & SboxTable(14) & SboxTable(10) & SboxTable(6) & SboxTable(2);

	constant SboxTable3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		SboxTable(63) & SboxTable(59) & SboxTable(55) & SboxTable(51) & SboxTable(47) & SboxTable(43) & SboxTable(39) & SboxTable(35) &
		SboxTable(31) & SboxTable(27) & SboxTable(23) & SboxTable(19) & SboxTable(15) & SboxTable(11) & SboxTable(7) & SboxTable(3);

	----

	constant LFTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(60) & LFTable(56) & LFTable(52) & LFTable(48) & LFTable(44) & LFTable(40) & LFTable(36) & LFTable(32) &
		LFTable(28) & LFTable(24) & LFTable(20) & LFTable(16) & LFTable(12) & LFTable(8) & LFTable(4) & LFTable(0);
	
	constant LFTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(61) & LFTable(57) & LFTable(53) & LFTable(49) & LFTable(45) & LFTable(41) & LFTable(37) & LFTable(33) &
		LFTable(29) & LFTable(25) & LFTable(21) & LFTable(17) & LFTable(13) & LFTable(9) & LFTable(5) & LFTable(1);

	constant LFTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(62) & LFTable(58) & LFTable(54) & LFTable(50) & LFTable(46) & LFTable(42) & LFTable(38) & LFTable(34) &
		LFTable(30) & LFTable(26) & LFTable(22) & LFTable(18) & LFTable(14) & LFTable(10) & LFTable(6) & LFTable(2);

	constant LFTable3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(63) & LFTable(59) & LFTable(55) & LFTable(51) & LFTable(47) & LFTable(43) & LFTable(39) & LFTable(35) &
		LFTable(31) & LFTable(27) & LFTable(23) & LFTable(19) & LFTable(15) & LFTable(11) & LFTable(7) & LFTable(3);

	----
	
	signal Perm_out : std_logic_vector(3 downto 0);
		
begin

	GENin0: IF InputBitIndex=0 GENERATE
		Sbox_Process0: Process (data_in)
		begin
			Perm_out(0) <= SboxTable0(15-to_integer(unsigned(data_in(3  downto 0))));
			Perm_out(1) <= SboxTable0(15-to_integer(unsigned(data_in(7  downto 4))));
			Perm_out(2) <= SboxTable0(15-to_integer(unsigned(data_in(11 downto 8))));
			Perm_out(3) <= SboxTable0(15-to_integer(unsigned(data_in(15 downto 12))));
		end process;	
	END GENERATE;
	
	GENin1: IF InputBitIndex=1 GENERATE
		Sbox_Process0: Process (data_in)
		begin
			Perm_out(0) <= SboxTable1(15-to_integer(unsigned(data_in(3  downto 0))));
			Perm_out(1) <= SboxTable1(15-to_integer(unsigned(data_in(7  downto 4))));
			Perm_out(2) <= SboxTable1(15-to_integer(unsigned(data_in(11 downto 8))));
			Perm_out(3) <= SboxTable1(15-to_integer(unsigned(data_in(15 downto 12))));
		end process;	
	END GENERATE;

	GENin2: IF InputBitIndex=2 GENERATE
		Sbox_Process0: Process (data_in)
		begin
			Perm_out(0) <= SboxTable2(15-to_integer(unsigned(data_in(3  downto 0))));
			Perm_out(1) <= SboxTable2(15-to_integer(unsigned(data_in(7  downto 4))));
			Perm_out(2) <= SboxTable2(15-to_integer(unsigned(data_in(11 downto 8))));
			Perm_out(3) <= SboxTable2(15-to_integer(unsigned(data_in(15 downto 12))));
		end process;	
	END GENERATE;

	GENin3: IF InputBitIndex=3 GENERATE
		Sbox_Process0: Process (data_in)
		begin
			Perm_out(0) <= SboxTable3(15-to_integer(unsigned(data_in(3  downto 0))));
			Perm_out(1) <= SboxTable3(15-to_integer(unsigned(data_in(7  downto 4))));
			Perm_out(2) <= SboxTable3(15-to_integer(unsigned(data_in(11 downto 8))));
			Perm_out(3) <= SboxTable3(15-to_integer(unsigned(data_in(15 downto 12))));
		end process;	
	END GENERATE;
	
	----
	
	GEN0: IF BitNumber=0 GENERATE
		LF_Process0: Process (Perm_out)
		begin
			data_out <= LFTable0(15-to_integer(unsigned(Perm_out)));
		end process;	
	END GENERATE;

	GEN1: IF BitNumber=1 GENERATE
		LF_Process1: Process (Perm_out)
		begin
			data_out <= LFTable1(15-to_integer(unsigned(Perm_out)));
		end process;	
	END GENERATE;

	GEN2: IF BitNumber=2 GENERATE
		LF_Process2: Process (Perm_out)
		begin
			data_out <= LFTable2(15-to_integer(unsigned(Perm_out)));
		end process;	
	END GENERATE;

	GEN3: IF BitNumber=3 GENERATE
		LF_Process3: Process (Perm_out)
		begin
			data_out <= LFTable3(15-to_integer(unsigned(Perm_out)));
		end process;	
	END GENERATE;

end architecture behavioral;
