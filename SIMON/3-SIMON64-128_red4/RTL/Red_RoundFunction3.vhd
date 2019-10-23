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
use ieee.numeric_std.all;
use work.functions.all;

entity Red_RoundFunction3 is
	Generic ( 
		BitNumber       : NATURAL;
		LFTable         : STD_LOGIC_VECTOR(63 downto 0);
		LFInvTable      : STD_LOGIC_VECTOR(63 downto 0));
	port(
		data_in	: in  std_logic_vector(11 downto 0);
		data_out : out std_logic);
end entity Red_RoundFunction3;

architecture behavioral of Red_RoundFunction3 is
	
	constant LFInvTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFInvTable(60) & LFInvTable(56) & LFInvTable(52) & LFInvTable(48) & LFInvTable(44) & LFInvTable(40) & LFInvTable(36) & LFInvTable(32) &
		LFInvTable(28) & LFInvTable(24) & LFInvTable(20) & LFInvTable(16) & LFInvTable(12) & LFInvTable(8) & LFInvTable(4) & LFInvTable(0);
	
	constant LFInvTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFInvTable(61) & LFInvTable(57) & LFInvTable(53) & LFInvTable(49) & LFInvTable(45) & LFInvTable(41) & LFInvTable(37) & LFInvTable(33) &
		LFInvTable(29) & LFInvTable(25) & LFInvTable(21) & LFInvTable(17) & LFInvTable(13) & LFInvTable(9) & LFInvTable(5) & LFInvTable(1);

	constant LFInvTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFInvTable(62) & LFInvTable(58) & LFInvTable(54) & LFInvTable(50) & LFInvTable(46) & LFInvTable(42) & LFInvTable(38) & LFInvTable(34) &
		LFInvTable(30) & LFInvTable(26) & LFInvTable(22) & LFInvTable(18) & LFInvTable(14) & LFInvTable(10) & LFInvTable(6) & LFInvTable(2);

	constant LFInvTable3 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFInvTable(63) & LFInvTable(59) & LFInvTable(55) & LFInvTable(51) & LFInvTable(47) & LFInvTable(43) & LFInvTable(39) & LFInvTable(35) &
		LFInvTable(31) & LFInvTable(27) & LFInvTable(23) & LFInvTable(19) & LFInvTable(15) & LFInvTable(11) & LFInvTable(7) & LFInvTable(3);

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
	
	signal input0 : STD_LOGIC_VECTOR(3 downto 0);
	signal input1 : STD_LOGIC_VECTOR(3 downto 0);	
	signal input2 : STD_LOGIC_VECTOR(3 downto 0);
	signal output : STD_LOGIC_VECTOR(3 downto 0);
	
begin

	LFInv_Process: Process (data_in)
	begin
		input0(0) <= LFInvTable0(15-to_integer(unsigned(data_in(3  downto 0))));
		input0(1) <= LFInvTable1(15-to_integer(unsigned(data_in(3  downto 0))));
		input0(2) <= LFInvTable2(15-to_integer(unsigned(data_in(3  downto 0))));
		input0(3) <= LFInvTable3(15-to_integer(unsigned(data_in(3  downto 0))));
		
		input1(0) <= LFInvTable3(15-to_integer(unsigned(data_in(7  downto 4))));
		input1(1) <= LFInvTable0(15-to_integer(unsigned(data_in(11 downto 8))));
		input1(2) <= LFInvTable1(15-to_integer(unsigned(data_in(11 downto 8))));
		input1(3) <= LFInvTable2(15-to_integer(unsigned(data_in(11 downto 8))));
		
		input2(0) <= LFInvTable2(15-to_integer(unsigned(data_in(7  downto 4))));
	end process;

	input2(1) <= input1(0);
	input2(2) <= input1(1);
	input2(3) <= input1(2);

	------

	output <= (input0 AND input1) XOR input2;

	------
	
	GEN0: IF BitNumber=0 GENERATE
		LF_Process0: Process (output)
		begin
			data_out <= LFTable0(15-to_integer(unsigned(output)));
		end process;	
	END GENERATE;

	GEN1: IF BitNumber=1 GENERATE
		LF_Process1: Process (output)
		begin
			data_out <= LFTable1(15-to_integer(unsigned(output)));
		end process;	
	END GENERATE;

	GEN2: IF BitNumber=2 GENERATE
		LF_Process2: Process (output)
		begin
			data_out <= LFTable2(15-to_integer(unsigned(output)));
		end process;	
	END GENERATE;

	GEN3: IF BitNumber=3 GENERATE
		LF_Process3: Process (output)
		begin
			data_out <= LFTable3(15-to_integer(unsigned(output)));
		end process;	
	END GENERATE;
											
end architecture behavioral;
