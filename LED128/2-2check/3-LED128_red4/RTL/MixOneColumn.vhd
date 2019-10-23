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
use work.functions.all;

ENTITY MixOneColumn IS
	PORT ( s0  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 s1  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 s2  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 s3  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 r0  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			 r1  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			 r2  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			 r3  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END MixOneColumn;

ARCHITECTURE behavioral OF MixOneColumn IS	
	signal v0_0, v0_1, v0_2, v0_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal v1_0, v1_1, v1_2, v1_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal v2_0, v2_1, v2_2, v2_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal v3_0, v3_1, v3_2, v3_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);

BEGIN


	GEN :
	FOR BitNumber IN 0 TO 3 GENERATE
		v0_0Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"4", BitNumber))
		PORT Map (s0, v0_0(BitNumber));

		v0_1Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"8", BitNumber))
		PORT Map (s0, v0_1(BitNumber));

		v0_2Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"B", BitNumber))
		PORT Map (s0, v0_2(BitNumber));

		v0_3Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"2", BitNumber))
		PORT Map (s0, v0_3(BitNumber));
		
		------
		
		v1_0(BitNumber) <= s1(BitNumber); -- MUL by 1

		v1_1Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"6", BitNumber))
		PORT Map (s1, v1_1(BitNumber));

		v1_2Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"E", BitNumber))
		PORT Map (s1, v1_2(BitNumber));

		v1_3Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"2", BitNumber))
		PORT Map (s1, v1_3(BitNumber));
		
		------

		v2_0Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"2", BitNumber))
		PORT Map (s2, v2_0(BitNumber));

		v2_1Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"5", BitNumber))
		PORT Map (s2, v2_1(BitNumber));

		v2_2Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"A", BitNumber))
		PORT Map (s2, v2_2(BitNumber));

		v2_3Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"F", BitNumber))
		PORT Map (s2, v2_3(BitNumber));
		
		------

		v3_0Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"2", BitNumber))
		PORT Map (s3, v3_0(BitNumber));

		v3_1Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"6", BitNumber))
		PORT Map (s3, v3_1(BitNumber));

		v3_2Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"9", BitNumber))
		PORT Map (s3, v3_2(BitNumber));

		v3_3Inst: ENTITY work.LookUp
		GENERIC Map (size => 4, Table => MakeGF16_MulTable( x"B", BitNumber))
		PORT Map (s3, v3_3(BitNumber));
			
	END GENERATE;
	
	------------------------------------------
	
	r0Inst: ENTITY work.XOR_4n
	GENERIC Map (size => 4, count => 1)
	PORT Map (v0_0, v1_0, v2_0, v3_0, r0);
	
	r1Inst: ENTITY work.XOR_4n
	GENERIC Map (size => 4, count => 1)
	PORT Map (v0_1, v1_1, v2_1, v3_1, r1);

	r2Inst: ENTITY work.XOR_4n
	GENERIC Map (size => 4, count => 1)
	PORT Map (v0_2, v1_2, v2_2, v3_2, r2);

	r3Inst: ENTITY work.XOR_4n
	GENERIC Map (size => 4, count => 1)
	PORT Map (v0_3, v1_3, v2_3, v3_3, r3);
	
END behavioral;

