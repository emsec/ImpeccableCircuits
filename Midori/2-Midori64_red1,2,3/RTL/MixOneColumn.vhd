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

ENTITY MixOneColumn IS
	GENERIC ( size: POSITIVE);
	PORT ( state  : IN  STD_LOGIC_VECTOR (size*4-1 DOWNTO 0);
			 result : OUT  STD_LOGIC_VECTOR (size*4-1 DOWNTO 0));
END MixOneColumn;

ARCHITECTURE behavioral OF MixOneColumn IS	
	signal s0, s1, s2, s3 : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	signal r0, r1, r2, r3 : STD_LOGIC_VECTOR (size-1 DOWNTO 0);

BEGIN

	s0 <= state(size*4-1   downto  size*3);
	s1 <= state(size*3-1   downto  size*2);
	s2 <= state(size*2-1   downto  size*1);
	s3 <= state(size*1-1   downto  size*0);

	------------------------------------------

	GEN :
	FOR i IN 0 TO size-1 GENERATE
		XOR_r0_Inst: ENTITY work.XOR_3
		PORT Map (s1(i), s2(i), s3(i), r0(i));
		
		XOR_r1_Inst: ENTITY work.XOR_3
		PORT Map (s0(i), s2(i), s3(i), r1(i));

		XOR_r2_Inst: ENTITY work.XOR_3
		PORT Map (s0(i), s1(i), s3(i), r2(i));

		XOR_r3_Inst: ENTITY work.XOR_3
		PORT Map (s0(i), s1(i), s2(i), r3(i));
		
	END GENERATE;
	
	------------------------------------------
	
	result <= r0 & r1 & r2 & r3;

END behavioral;

