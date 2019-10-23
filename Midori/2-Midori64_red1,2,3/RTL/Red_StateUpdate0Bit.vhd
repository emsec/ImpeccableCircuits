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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Red_StateUpdate0Bit is
	 Generic ( LFTable    : STD_LOGIC_VECTOR (63 DOWNTO 0);
				  BitNumber  : NATURAL);
    Port ( FSM           : in  STD_LOGIC_VECTOR (4 downto 0);
           Red_FSMUpdate : out  STD_LOGIC);
end Red_StateUpdate0Bit;

architecture Behavioral of Red_StateUpdate0Bit is

	constant LFTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(60) & LFTable(56) & LFTable(52) & LFTable(48) & LFTable(44) & LFTable(40) & LFTable(36) & LFTable(32) &
		LFTable(28) & LFTable(24) & LFTable(20) & LFTable(16) & LFTable(12) & LFTable(8) & LFTable(4) & LFTable(0);
	
	constant LFTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(61) & LFTable(57) & LFTable(53) & LFTable(49) & LFTable(45) & LFTable(41) & LFTable(37) & LFTable(33) &
		LFTable(29) & LFTable(25) & LFTable(21) & LFTable(17) & LFTable(13) & LFTable(9) & LFTable(5) & LFTable(1);

	constant LFTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(62) & LFTable(58) & LFTable(54) & LFTable(50) & LFTable(46) & LFTable(42) & LFTable(38) & LFTable(34) &
		LFTable(30) & LFTable(26) & LFTable(22) & LFTable(18) & LFTable(14) & LFTable(10) & LFTable(6) & LFTable(2);

	signal FSMUpdate : STD_LOGIC_VECTOR(3 downto 0);
	signal en		  : STD_LOGIC;
	
begin

	en	<= '0' WHEN ((FSM(4) = '1') AND (FSM(0) = '1')) ELSE '1';
	FSMUpdate(0) <= FSM(0) XOR en;
	FSMUpdate(1) <= FSM(1) XOR (FSM(0) AND en);
	FSMUpdate(2) <= FSM(2) XOR (FSM(0) AND FSM(1));
	FSMUpdate(3) <= FSM(3) XOR (FSM(0) AND FSM(1) AND FSM(2));

	Bit_0:
	IF BitNumber = 0 GENERATE
		WITH FSMUpdate SELECT
			Red_FSMUpdate <= 
				LFTable0(15) WHEN x"0",
				LFTable0(14) WHEN x"1",
				LFTable0(13) WHEN x"2",
				LFTable0(12) WHEN x"3",
				LFTable0(11) WHEN x"4",
				LFTable0(10) WHEN x"5",
				LFTable0(9)  WHEN x"6",
				LFTable0(8)  WHEN x"7",
				LFTable0(7)  WHEN x"8",
				LFTable0(6)  WHEN x"9",
				LFTable0(5)  WHEN x"A",
				LFTable0(4)  WHEN x"B",
				LFTable0(3)  WHEN x"C",
				LFTable0(2)  WHEN x"D",
				LFTable0(1)  WHEN x"E",
				LFTable0(0)  WHEN OTHERS;
	END GENERATE;

	-------------------
	
	Bit_1:
	IF BitNumber = 1 GENERATE
		WITH FSMUpdate SELECT
			Red_FSMUpdate <= 
				LFTable1(15) WHEN x"0",
				LFTable1(14) WHEN x"1",
				LFTable1(13) WHEN x"2",
				LFTable1(12) WHEN x"3",
				LFTable1(11) WHEN x"4",
				LFTable1(10) WHEN x"5",
				LFTable1(9)  WHEN x"6",
				LFTable1(8)  WHEN x"7",
				LFTable1(7)  WHEN x"8",
				LFTable1(6)  WHEN x"9",
				LFTable1(5)  WHEN x"A",
				LFTable1(4)  WHEN x"B",
				LFTable1(3)  WHEN x"C",
				LFTable1(2)  WHEN x"D",
				LFTable1(1)  WHEN x"E",
				LFTable1(0)  WHEN OTHERS;
	END GENERATE;
		
	-------------------

	Bit_2:
	IF BitNumber = 2 GENERATE
		WITH FSMUpdate SELECT
			Red_FSMUpdate <= 
				LFTable2(15) WHEN x"0",
				LFTable2(14) WHEN x"1",
				LFTable2(13) WHEN x"2",
				LFTable2(12) WHEN x"3",
				LFTable2(11) WHEN x"4",
				LFTable2(10) WHEN x"5",
				LFTable2(9)  WHEN x"6",
				LFTable2(8)  WHEN x"7",
				LFTable2(7)  WHEN x"8",
				LFTable2(6)  WHEN x"9",
				LFTable2(5)  WHEN x"A",
				LFTable2(4)  WHEN x"B",
				LFTable2(3)  WHEN x"C",
				LFTable2(2)  WHEN x"D",
				LFTable2(1)  WHEN x"E",
				LFTable2(0)  WHEN OTHERS;
	END GENERATE;

end Behavioral;

