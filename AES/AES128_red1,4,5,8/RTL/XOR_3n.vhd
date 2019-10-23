----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Amir Moradi, Aein Rezaei Shahmirzadi
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

ENTITY XOR_3n IS
	GENERIC ( size  : POSITIVE;
				 count : POSITIVE);
	PORT ( in0 	 : IN  STD_LOGIC_VECTOR ((size*count-1) DOWNTO 0);
			 in1 	 : IN  STD_LOGIC_VECTOR ((size*count-1) DOWNTO 0);
			 in2 	 : IN  STD_LOGIC_VECTOR ((size*count-1) DOWNTO 0);
			 q 	 : OUT STD_LOGIC_VECTOR ((size*count-1) DOWNTO 0));			 
END XOR_3n;

ARCHITECTURE behavioral OF XOR_3n IS
BEGIN

	GEN1:
	FOR j IN 0 TO count-1 GENERATE
		GEN2:
		FOR i IN 0 TO size-1 GENERATE
			XORInst: ENTITY work.XOR_3
			Port Map (
				in0	=> in0(j*size+i),
				in1	=> in1(j*size+i),
				in2	=> in2(j*size+i),
				q		=> q(j*size+i));
		END GENERATE;
	END GENERATE;
	
END;

