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
				 LFInvTable : STD_LOGIC_VECTOR(63 downto 0);
				 BitNumber  : INTEGER);
	PORT ( 
		Red_Input		: IN  STD_LOGIC_VECTOR (size*16-1 DOWNTO 0);
		Red_IR 	 		: IN  STD_LOGIC_VECTOR (size-1    DOWNTO 0);
		Red_Kba			: IN  STD_LOGIC_VECTOR (size-1    DOWNTO 0);
		Red_OutputBit	: OUT STD_LOGIC);
END Red_RoundFunctionBit;

ARCHITECTURE behavioral OF Red_RoundFunctionBit IS

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

	signal Input	: STD_LOGIC_VECTOR (63 DOWNTO 0);
	signal IR 	 	: STD_LOGIC;
	signal Kba		: STD_LOGIC_VECTOR ( 1 DOWNTO 0);
	signal Output	: STD_LOGIC_VECTOR (63 DOWNTO 0);

	signal Fa, Fb  : std_logic;
	signal v    	: STD_LOGIC_VECTOR (3 downto 0);

	constant index_i 	: integer := integer(floor(real(BitNumber)/4.0)*4.0);
	constant index_j	: integer := BitNumber mod 4;

BEGIN

	GEN: FOR i IN 0 TO 16-1 GENERATE
		LFInv_Process: Process (Red_Input)
		begin
			Input(i*4+0) <= LFInvTable0(15-to_integer(unsigned(Red_Input(i*4+3 downto i*4))));
			Input(i*4+1) <= LFInvTable1(15-to_integer(unsigned(Red_Input(i*4+3 downto i*4))));
			Input(i*4+2) <= LFInvTable2(15-to_integer(unsigned(Red_Input(i*4+3 downto i*4))));
			Input(i*4+3) <= LFInvTable3(15-to_integer(unsigned(Red_Input(i*4+3 downto i*4))));
		end process;	
	END GENERATE;	

	LFInv_Process: Process (Red_IR, Red_Kba)
	begin
		IR 		<= LFInvTable0(15-to_integer(unsigned(Red_IR)));
		Kba(0) 	<= LFInvTable0(15-to_integer(unsigned(Red_Kba)));
		Kba(1) 	<= LFInvTable1(15-to_integer(unsigned(Red_Kba)));		
	end process;	

	----------------------------------

	Fb <= (Input(9) AND Input(14)) XOR (Input(21) AND Input(33)) XOR Input(25) XOR Input(38) XOR Kba(1);
	Fa <= (IR       AND Input(48)) XOR (Input(50) AND Input(59)) XOR Input(54) XOR Input(63) XOR Kba(0);
	
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

	GEN7: IF index_j=3 GENERATE
		LF_Process3: Process (v)
		begin
			Red_OutputBit <= LFTable3(15-to_integer(unsigned(v)));
		end process;	
	END GENERATE;	
		
END;

