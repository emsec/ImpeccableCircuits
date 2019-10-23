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

ENTITY Red_KeyMUX IS
	GENERIC ( size 	: POSITIVE;
				 LFTable : STD_LOGIC_VECTOR(63 downto 0));
	PORT ( sel0 	: IN  STD_LOGIC_VECTOR (size-1 DOWNTO 0);
			 sel1 	: IN  STD_LOGIC_VECTOR (size-1 DOWNTO 0);
			 D0 	 	: IN  STD_LOGIC_VECTOR ((size*4-1) DOWNTO 0);
			 D1 	 	: IN  STD_LOGIC_VECTOR ((size*4-1) DOWNTO 0);
			 D2 	 	: IN  STD_LOGIC_VECTOR ((size*4-1) DOWNTO 0);
			 D3 	 	: IN  STD_LOGIC_VECTOR ((size*4-1) DOWNTO 0);
			 Q 	 	: OUT STD_LOGIC_VECTOR ((size*4-1) DOWNTO 0));			 
END Red_KeyMUX;

ARCHITECTURE behavioral OF Red_KeyMUX IS

	signal Q1	: STD_LOGIC_VECTOR ((size*4-1) DOWNTO 0);
	signal Q2	: STD_LOGIC_VECTOR ((size*4-1) DOWNTO 0);

BEGIN

	Red_MUX1: ENTITY work.MUX2to1_Redn
	GENERIC Map ( 
		size 		=> size*4,
		LFTable 	=> LFTable)
	PORT Map ( 
		sel	=> sel0,
		D0   	=> D0,
		D1 	=> D1,
		Q 		=> Q1);

	Red_MUX2: ENTITY work.MUX2to1_Redn
	GENERIC Map ( 
		size 		=> size*4,
		LFTable 	=> LFTable)
	PORT Map ( 
		sel	=> sel0,
		D0   	=> D2,
		D1 	=> D3,
		Q 		=> Q2);

	Red_MUX3: ENTITY work.MUX2to1_Redn
	GENERIC Map ( 
		size 		=> size*4,
		LFTable 	=> LFTable)
	PORT Map ( 
		sel	=> sel1,
		D0   	=> Q1,
		D1 	=> Q2,
		Q 		=> Q);
	
END;

