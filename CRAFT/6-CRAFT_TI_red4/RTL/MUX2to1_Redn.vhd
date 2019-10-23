----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://doi.org/10.13154/tosc.v2019.i1.5-45 
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

ENTITY MUX2to1_Redn IS
	GENERIC (size    : POSITIVE;
				LFTable : STD_LOGIC_VECTOR(63 downto 0);
				sel0_1  : integer := 0;
				sel0_2  : integer := 0;
				sel1_1  : integer := 1;
				sel1_2  : integer := 1);
	PORT ( sel 	: IN  STD_LOGIC_VECTOR(3 downto 0);
			 D0   : IN  STD_LOGIC_VECTOR(size-1 downto 0);
			 D1 	: IN  STD_LOGIC_VECTOR(size-1 downto 0);
			 Q 	: OUT STD_LOGIC_VECTOR(size-1 downto 0));
END MUX2to1_Redn;

ARCHITECTURE behavioral OF MUX2to1_Redn IS
BEGIN

	GEN :
	FOR i IN 0 TO size-1 GENERATE
		MUX2to1Inst: ENTITY work.MUX2to1_Red
		GENERIC Map (LFTable, sel0_1, sel0_2, sel1_1, sel1_2)
		PORT Map (
			sel	=> sel,
			D0		=> D0(i),
			D1		=> D1(i),
			Q		=> Q(i));
	END GENERATE;

END;

