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

ENTITY MC IS
	GENERIC ( size: POSITIVE);
	PORT ( state  : IN  STD_LOGIC_VECTOR (size*16-1 DOWNTO 0);
			 result : OUT STD_LOGIC_VECTOR (size*16-1 DOWNTO 0);
			 const  : IN  STD_LOGIC_VECTOR ((size-1)  DOWNTO 0) := (others => '0'));		
END MC;

ARCHITECTURE behavioral OF MC IS	

	signal r0, r1, r2, r3 : STD_LOGIC_VECTOR (size*4-1 DOWNTO 0); -- input  rows
	signal o0, o1, o2, o3 : STD_LOGIC_VECTOR (size*4-1 DOWNTO 0); -- output rows

BEGIN

	r0	 <= state(size*16-1  downto  size*12);
	r1	 <= state(size*12-1  downto  size*8);
	r2	 <= state(size*8-1   downto  size*4);
	r3	 <= state(size*4-1   downto  size*0);

	------------------------------------------
	
	GEN :
	FOR i IN 0 TO size*4-1 GENERATE
		XOR_r0_Inst: ENTITY work.XOR_3
		PORT Map (r0(i), r2(i), r3(i), o0(i));
		
		XOR_r1_Inst: ENTITY work.XOR_2
		PORT Map (r1(i), r3(i), o1(i), const(i mod size));

		o2(i) <= r2(i);
		o3(i) <= r3(i);
	END GENERATE;

	result <= o0 & o1 & o2 & o3;

END behavioral;

