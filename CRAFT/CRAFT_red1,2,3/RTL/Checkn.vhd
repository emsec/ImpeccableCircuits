----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://doi.org/10.13154/tosc.v2019.i1.5-45 
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Christof Beierle, Gregor Leander, Amir Moradi, Shahram Rasoolzadeh 
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

ENTITY Checkn IS
	GENERIC ( count      : POSITIVE := 16;
	          sizecount  : POSITIVE := 2;
	          size       : POSITIVE := 4);
	PORT ( in1    : IN  STD_LOGIC_VECTOR (size*count*sizecount-1 DOWNTO 0);
	       in2    : IN  STD_LOGIC_VECTOR (size*count*sizecount-1 DOWNTO 0);
	       result : OUT STD_LOGIC_VECTOR (size*sizecount-1       DOWNTO 0));
END Checkn;

ARCHITECTURE behavioral OF Checkn IS	

	type STD_ARRAY is array (integer range <>) of STD_LOGIC_VECTOR(count-1 downto 0);
	signal inSignal1 : STD_ARRAY(sizecount*size-1 downto 0);
	signal inSignal2 : STD_ARRAY(sizecount*size-1 downto 0);

BEGIN

	GEN0 :
	FOR k IN 0 TO sizecount-1 GENERATE
		GEN1 :
		FOR j IN 0 TO size-1 GENERATE
			GEN2 :
			FOR i IN 0 TO count-1 GENERATE
				inSignal1(k*size + j)(i) <= in1(k*size*count + j + i*size);
				inSignal2(k*size + j)(i) <= in2(k*size*count + j + i*size);
			END GENERATE;
		END GENERATE;
	END GENERATE;


	GEN3 :
	FOR i IN 0 TO sizecount*size-1 GENERATE
		CheckInst: ENTITY work.Check
		Generic Map ( size => count)
		Port Map (
			in1	=> inSignal1(i),
			in2	=> inSignal2(i),
			result	=> result(i));
	END GENERATE;

END behavioral;

