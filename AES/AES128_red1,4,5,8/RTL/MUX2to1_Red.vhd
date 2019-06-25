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
USE IEEE.NUMERIC_STD.ALL;

ENTITY MUX2to1_Red IS
	GENERIC (size    : POSITIVE;
	         LFTable : STD_LOGIC_VECTOR(2047 downto 0));
	PORT ( sel 	: IN  STD_LOGIC_VECTOR(size-1 downto 0);
			 D0   : IN  STD_LOGIC;
			 D1 	: IN  STD_LOGIC;
			 Q 	: OUT STD_LOGIC);
END MUX2to1_Red;

ARCHITECTURE behavioral OF MUX2to1_Red IS

	type S_Array is array (0 to size, 0 to (2**size)-1) of STD_LOGIC;
	signal S : S_Array;	
	
	constant LF0			 : NATURAL := to_integer(unsigned(LFTable(2047 downto 2040)));
	constant LF1			 : NATURAL := to_integer(unsigned(LFTable(2039 downto 2039-7)));

BEGIN

	GEN_input:
	FOR i IN 0 TO (2**size)-1 GENERATE
		GEN_0: 
		IF i=LF0 GENERATE
			S(0,i) <= D0;
		END GENERATE;

		GEN_1: 
		IF i=LF1 GENERATE
			S(0,i) <= D1;
		END GENERATE;

		GEN_else:
		IF (i /= LF0) and (i /= LF1) GENERATE
			S(0,i) <= '0';
		END GENERATE;
	END GENERATE;	

	---------------------
	
	GEN_Main:
	FOR j IN 0 TO size-1 GENERATE
		GEN_Inside:
		FOR i IN 0 TO 2**(size-1-j)-1 GENERATE
			GEN_1: IF (i = LF0/(2**(j+1))) or (i = LF1/(2**(j+1))) GENERATE
				MUXInst: ENTITY work.MUX2to1
				PORT Map (sel(j), S(j,2*i), S(j,2*i+1), S(j+1,i));	
			END GENERATE;

			GEN_0: IF (i /= LF0/(2**(j+1))) and (i /= LF1/(2**(j+1))) GENERATE
				S(j+1,i)	<= '0';	
			END GENERATE;			
		END GENERATE;
	END GENERATE;
	
	---------------------
	
	Q	<= S(size,0);
	
END;

