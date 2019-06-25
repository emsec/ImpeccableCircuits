----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://doi.org/10.13154/tosc.v2019.i1.5-45 
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Christof Beierle, Gregor Leander, Amir Moradi, Shahram Rasoolzadeh 
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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY F IS
	GENERIC (
		LFTable    	: STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable 	: STD_LOGIC_VECTOR (63 DOWNTO 0);
		BitNumber	: integer);
	PORT ( input1 : IN  STD_LOGIC_VECTOR (3 downto 0);
			 input2 : IN  STD_LOGIC_VECTOR (3 downto 0);
			 output : OUT STD_LOGIC);
END F;

ARCHITECTURE behavioral OF F IS

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

	-------------------------

	signal in1, in2, out_vec				  : std_logic_vector(3 downto 0);
	signal x0, x1, x2, x3, x4, x5, x6, x7 : std_logic;
	signal y0, y1, y2, y3				     : std_logic;

BEGIN
	
	in1(0) 	<= LFInvTable0(15-to_integer(unsigned(input1)));
	in1(1) 	<= LFInvTable1(15-to_integer(unsigned(input1)));
	in1(2) 	<= LFInvTable2(15-to_integer(unsigned(input1)));
	in1(3) 	<= LFInvTable3(15-to_integer(unsigned(input1)));
	
	in2(0) 	<= LFInvTable0(15-to_integer(unsigned(input2)));
	in2(1) 	<= LFInvTable1(15-to_integer(unsigned(input2)));
	in2(2) 	<= LFInvTable2(15-to_integer(unsigned(input2)));
	in2(3) 	<= LFInvTable3(15-to_integer(unsigned(input2)));
	
	---------------------------

	x0 <= in1(0);
	x1 <= in1(1);
	x2 <= in1(2);
	x3 <= in1(3);	

	x4 <= in2(0);
	x5 <= in2(1);
	x6 <= in2(2);
	x7 <= in2(3);	
	
	y0 <= x4;
	y1 <= x5 xor (x1 AND x3) xor (x1 AND x7) xor (x3 AND x5) xor (x2 AND x3) xor (x2 AND x7) xor (x3 AND x6);
	y2 <= x6 xor (x1 AND x3) xor (x1 AND x7) xor (x3 AND x5) ;
	y3 <= x7;
	
	out_vec(0) <= y2;
	out_vec(1) <= y0;
	out_vec(2) <= y2 xor y3;
	out_vec(3) <= not y1;	
	
	-----------------------------
	
	GEN0: IF BitNumber=0 GENERATE
		LF_Process: Process (out_vec)
		begin
			output <= LFTable0(15-to_integer(unsigned(out_vec)));
		end process;	
	END GENERATE;

	GEN1: IF BitNumber=1 GENERATE
		LF_Process: Process (out_vec)
		begin
			output <= LFTable1(15-to_integer(unsigned(out_vec)));
		end process;	
	END GENERATE;

	GEN2: IF BitNumber=2 GENERATE
		LF_Process: Process (out_vec)
		begin
			output <= LFTable2(15-to_integer(unsigned(out_vec)));
		end process;	
	END GENERATE;

	GEN3: IF BitNumber=3 GENERATE
		LF_Process: Process (out_vec)
		begin
			output <= LFTable3(15-to_integer(unsigned(out_vec)));
		end process;	
	END GENERATE;	
	
END behavioral;
