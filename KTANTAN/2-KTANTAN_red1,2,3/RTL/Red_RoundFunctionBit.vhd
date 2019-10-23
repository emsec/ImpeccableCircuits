----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Amir Moradi
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
use IEEE.MATH_REAL.ALL;

ENTITY Red_RoundFunctionBit IS
	GENERIC ( size 		: POSITIVE;
				 LFTable 	: STD_LOGIC_VECTOR(63 downto 0);
				 BitNumber  : INTEGER);
	PORT ( 
		Input				: IN  STD_LOGIC_VECTOR (63        DOWNTO 0);
		FSM 	 			: IN  STD_LOGIC_VECTOR ( 7        DOWNTO 0);
		Key				: IN  STD_LOGIC_VECTOR (79        DOWNTO 0);
		Red_OutputBit	: OUT STD_LOGIC);
END Red_RoundFunctionBit;

ARCHITECTURE behavioral OF Red_RoundFunctionBit IS

	constant LFTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(60) & LFTable(56) & LFTable(52) & LFTable(48) & LFTable(44) & LFTable(40) & LFTable(36) & LFTable(32) &
		LFTable(28) & LFTable(24) & LFTable(20) & LFTable(16) & LFTable(12) & LFTable(8) & LFTable(4) & LFTable(0);
	
	constant LFTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(61) & LFTable(57) & LFTable(53) & LFTable(49) & LFTable(45) & LFTable(41) & LFTable(37) & LFTable(33) &
		LFTable(29) & LFTable(25) & LFTable(21) & LFTable(17) & LFTable(13) & LFTable(9) & LFTable(5) & LFTable(1);

	constant LFTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(62) & LFTable(58) & LFTable(54) & LFTable(50) & LFTable(46) & LFTable(42) & LFTable(38) & LFTable(34) &
		LFTable(30) & LFTable(26) & LFTable(22) & LFTable(18) & LFTable(14) & LFTable(10) & LFTable(6) & LFTable(2);

	signal Ka,Kb	: STD_LOGIC;
	signal Output	: STD_LOGIC_VECTOR (63 DOWNTO 0);

	signal a      		: std_logic_vector(4 downto 0);
	signal FSM10Inv 	: std_logic_vector(1 downto 0);
	signal F1, F2 		: std_logic;

	signal Fa, Fb  : std_logic;
	signal v    	: STD_LOGIC_VECTOR (3 downto 0);

	constant index_i 	: integer := integer(floor(real(BitNumber)/real(size))*4.0);
	constant index_j	: integer := BitNumber mod size;

BEGIN

	GENIF: IF (index_i = 0) OR (index_i = 36) GENERATE
		Proc1 : process (Key, FSM)
		begin
			a(0)	<=	 Key(0  + to_integer(unsigned(FSM(7 downto 4))));
			a(1)	<=	 Key(16 + to_integer(unsigned(FSM(7 downto 4))));
			a(2)	<=	 Key(32 + to_integer(unsigned(FSM(7 downto 4))));
			a(3)	<=	 Key(48 + to_integer(unsigned(FSM(7 downto 4))));
			a(4)	<=	 Key(64 + to_integer(unsigned(FSM(7 downto 4))));
		end process;	

		FSM10Inv <= (NOT (FSM(1))) & (NOT FSM(0));

		Proc2 : process (a, FSM, FSM10Inv)
		begin
			F1		<=	 a(1 + to_integer(unsigned(FSM(1 downto 0))));
			F2		<=	 a(0 + to_integer(unsigned(FSM10Inv)));
		end process;	

		Ka	<= a(0) when FSM(3 downto 2) = "00" else F1;
		Kb <= a(4) when FSM(3 downto 2) = "01" else F2;


		Fb <= (Input(9) AND Input(14)) XOR (Input(21) AND Input(33)) XOR Input(25) XOR Input(38) XOR Kb;
		Fa <= (FSM(0)   AND Input(48)) XOR (Input(50) AND Input(59)) XOR Input(54) XOR Input(63) XOR Ka;
	END GENERATE;
	
	Output(63 downto 40) <= Input(62 downto 39);
	Output(39)				<= Fb;
	Output(38 downto 1)  <= Input(37 downto 0);
	Output(0)				<= Fa;
	
	v	<= Output(index_i+3 downto index_i);
	
	-----------------------------------
	
	GEN4: IF index_j=0 GENERATE
		LF_Process0: Process (v)
		begin
			Red_OutputBit <= LFTable0(15-to_integer(unsigned(v)));
		end process;	
	END GENERATE;

	GEN5: IF index_j=1 GENERATE
		LF_Process1: Process (v)
		begin
			Red_OutputBit <= LFTable1(15-to_integer(unsigned(v)));
		end process;	
	END GENERATE;

	GEN6: IF index_j=2 GENERATE
		LF_Process2: Process (v)
		begin
			Red_OutputBit <= LFTable2(15-to_integer(unsigned(v)));
		end process;	
	END GENERATE;

END;

