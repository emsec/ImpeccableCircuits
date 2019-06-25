----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Anita Aghaie, Amir Moradi, Aein Rezaei Shahmirzadi
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

ENTITY LookUp4x16 IS
	GENERIC ( Table : STD_LOGIC_VECTOR (63 DOWNTO 0));
	PORT ( input:  IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 output: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END LookUp4x16;

ARCHITECTURE behavioral OF LookUp4x16 IS

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

BEGIN

	LFInst_3: ENTITY work.LookUp
	GENERIC Map (size => 4, Table => Table3)
	PORT Map (input, output(3));

	LFInst_2: ENTITY work.LookUp
	GENERIC Map (size => 4, Table => Table2)
	PORT Map (input, output(2));

	LFInst_1: ENTITY work.LookUp
	GENERIC Map (size => 4, Table => Table1)
	PORT Map (input, output(1));

	LFInst_0: ENTITY work.LookUp
	GENERIC Map (size => 4, Table => Table0)
	PORT Map (input, output(0));
			
END behavioral;

