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
		S_o_LFInvTable  : STD_LOGIC_VECTOR(63 downto 0);
		InputBitIndex	 : NATURAL);
	port(
		data_in	: in  std_logic_vector(15 downto 0);
		data_out : out std_logic);
end entity Red_SboxPermutation4;

architecture behavioral of Red_SboxPermutation4 is

	constant S_o_LFInvTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		S_o_LFInvTable(60) & S_o_LFInvTable(56) & S_o_LFInvTable(52) & S_o_LFInvTable(48) & S_o_LFInvTable(44) & S_o_LFInvTable(40) & S_o_LFInvTable(36) & S_o_LFInvTable(32) &
		S_o_LFInvTable(28) & S_o_LFInvTable(24) & S_o_LFInvTable(20) & S_o_LFInvTable(16) & S_o_LFInvTable(12) & S_o_LFInvTable(8) & S_o_LFInvTable(4) & S_o_LFInvTable(0);
	
	constant S_o_LFInvTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		S_o_LFInvTable(61) & S_o_LFInvTable(57) & S_o_LFInvTable(53) & S_o_LFInvTable(49) & S_o_LFInvTable(45) & S_o_LFInvTable(41) & S_o_LFInvTable(37) & S_o_LFInvTable(33) &
		S_o_LFInvTable(29) & S_o_LFInvTable(25) & S_o_LFInvTable(21) & S_o_LFInvTable(17) & S_o_LFInvTable(13) & S_o_LFInvTable(9) & S_o_LFInvTable(5) & S_o_LFInvTable(1);

	constant S_o_LFInvTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		S_o_LFInvTable(62) & S_o_LFInvTable(58) & S_o_LFInvTable(54) & S_o_LFInvTable(50) & S_o_LFInvTable(46) & S_o_LFInvTable(42) & S_o_LFInvTable(38) & S_o_LFInvTable(34) &
		S_o_LFInvTable(30) & S_o_LFInvTable(26) & S_o_LFInvTable(22) & S_o_LFInvTable(18) & S_o_LFInvTable(14) & S_o_LFInvTable(10) & S_o_LFInvTable(6) & S_o_LFInvTable(2);

	constant S_o_LFInvTable3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		S_o_LFInvTable(63) & S_o_LFInvTable(59) & S_o_LFInvTable(55) & S_o_LFInvTable(51) & S_o_LFInvTable(47) & S_o_LFInvTable(43) & S_o_LFInvTable(39) & S_o_LFInvTable(35) &
		S_o_LFInvTable(31) & S_o_LFInvTable(27) & S_o_LFInvTable(23) & S_o_LFInvTable(19) & S_o_LFInvTable(15) & S_o_LFInvTable(11) & S_o_LFInvTable(7) & S_o_LFInvTable(3);

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
		S_o_LFInv_Process0: Process (data_in)
		begin
			Perm_out(0) <= S_o_LFInvTable0(15-to_integer(unsigned(data_in(3  downto 0))));
			Perm_out(1) <= S_o_LFInvTable0(15-to_integer(unsigned(data_in(7  downto 4))));
			Perm_out(2) <= S_o_LFInvTable0(15-to_integer(unsigned(data_in(11 downto 8))));
			Perm_out(3) <= S_o_LFInvTable0(15-to_integer(unsigned(data_in(15 downto 12))));
		end process;	
	END GENERATE;
	
	GENin1: IF InputBitIndex=1 GENERATE
		S_o_LFInv_Process0: Process (data_in)
		begin
			Perm_out(0) <= S_o_LFInvTable1(15-to_integer(unsigned(data_in(3  downto 0))));
			Perm_out(1) <= S_o_LFInvTable1(15-to_integer(unsigned(data_in(7  downto 4))));
			Perm_out(2) <= S_o_LFInvTable1(15-to_integer(unsigned(data_in(11 downto 8))));
			Perm_out(3) <= S_o_LFInvTable1(15-to_integer(unsigned(data_in(15 downto 12))));
		end process;	
	END GENERATE;

	GENin2: IF InputBitIndex=2 GENERATE
		S_o_LFInv_Process0: Process (data_in)
		begin
			Perm_out(0) <= S_o_LFInvTable2(15-to_integer(unsigned(data_in(3  downto 0))));
			Perm_out(1) <= S_o_LFInvTable2(15-to_integer(unsigned(data_in(7  downto 4))));
			Perm_out(2) <= S_o_LFInvTable2(15-to_integer(unsigned(data_in(11 downto 8))));
			Perm_out(3) <= S_o_LFInvTable2(15-to_integer(unsigned(data_in(15 downto 12))));
		end process;	
	END GENERATE;

	GENin3: IF InputBitIndex=3 GENERATE
		S_o_LFInv_Process0: Process (data_in)
		begin
			Perm_out(0) <= S_o_LFInvTable3(15-to_integer(unsigned(data_in(3  downto 0))));
			Perm_out(1) <= S_o_LFInvTable3(15-to_integer(unsigned(data_in(7  downto 4))));
			Perm_out(2) <= S_o_LFInvTable3(15-to_integer(unsigned(data_in(11 downto 8))));
			Perm_out(3) <= S_o_LFInvTable3(15-to_integer(unsigned(data_in(15 downto 12))));
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
