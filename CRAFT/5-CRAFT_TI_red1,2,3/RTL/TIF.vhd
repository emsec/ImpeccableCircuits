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

ENTITY TIF IS
	GENERIC ( 
		LFTable    	: STD_LOGIC_VECTOR (63 DOWNTO 0);
		size			: NATURAL);
	PORT (input1	: IN  STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			input2	: IN  STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			input3	: IN  STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			output1	: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0);
			output2	: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0);
			output3	: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0));
END TIF;

ARCHITECTURE behavioral OF TIF IS
BEGIN

	Gen: FOR i in 0 to size-1 GENERATE
		F1: ENTITY work.F
		Generic Map (LFTable, i)
		Port Map (
			input1	=> input2,
			input2	=> input3,
			output	=> output1(i));
			
		F2: ENTITY work.F
		Generic Map (LFTable, i)
		Port Map (
			input1	=> input3,
			input2	=> input1,
			output	=> output2(i));

		F3: ENTITY work.F
		Generic Map (LFTable, i)
		Port Map (
			input1	=> input1,
			input2	=> input2,
			output	=> output3(i));
	END GENERATE;		
			
END behavioral;

