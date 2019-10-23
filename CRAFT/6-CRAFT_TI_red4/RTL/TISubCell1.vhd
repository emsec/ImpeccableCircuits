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

ENTITY TISubCell1 IS
	GENERIC ( 
		LFTable    	: STD_LOGIC_VECTOR (63 DOWNTO 0) := x"0123456789abcdef";
		LFInvTable 	: STD_LOGIC_VECTOR (63 DOWNTO 0) := x"0123456789abcdef";
		count 		: POSITIVE);
	PORT (input1	: IN  STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			input2	: IN  STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			input3	: IN  STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			output1	: OUT STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			output2	: OUT STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			output3	: OUT STD_LOGIC_VECTOR (4*count-1 DOWNTO 0));
END TISubCell1;

ARCHITECTURE behavioral OF TISubCell1 IS
BEGIN

	GEN :
	FOR i IN 0 TO count-1 GENERATE
		FInst: ENTITY work.TIG
		Generic Map (LFTable, LFInvTable)
		Port Map (
			input1	=> input1((i+1)*4-1 downto i*4),
			input2	=> input2((i+1)*4-1 downto i*4),
			input3	=> input3((i+1)*4-1 downto i*4),
			output1	=> output1((i+1)*4-1 downto i*4),
			output2	=> output2((i+1)*4-1 downto i*4),
			output3	=> output3((i+1)*4-1 downto i*4));
	END GENERATE;
			
END behavioral;

