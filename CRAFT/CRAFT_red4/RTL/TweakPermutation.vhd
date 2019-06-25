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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TweakPermutation IS
	GENERIC ( size: POSITIVE);
	PORT ( state  : IN  STD_LOGIC_VECTOR (size*16-1 DOWNTO 0);
			 result : OUT STD_LOGIC_VECTOR (size*16-1 DOWNTO 0));
END TweakPermutation;

ARCHITECTURE behavioral OF TweakPermutation IS

	signal s0, s1, s2, s3     : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	signal s4, s5, s6, s7     : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	signal s8, s9, s10, s11   : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	signal s12, s13, s14, s15 : STD_LOGIC_VECTOR (size-1 DOWNTO 0);

BEGIN

	s0	 <= state(size*16-1  downto  size*15);
	s1	 <= state(size*15-1  downto  size*14);
	s2	 <= state(size*14-1  downto  size*13);
	s3	 <= state(size*13-1  downto  size*12);
	s4	 <= state(size*12-1  downto  size*11);
	s5	 <= state(size*11-1  downto  size*10);
	s6	 <= state(size*10-1  downto  size*9);
	s7	 <= state(size*9-1   downto  size*8);
	s8	 <= state(size*8-1   downto  size*7);
	s9	 <= state(size*7-1   downto  size*6);
	s10 <= state(size*6-1   downto  size*5);
	s11 <= state(size*5-1   downto  size*4);
	s12 <= state(size*4-1   downto  size*3);
	s13 <= state(size*3-1   downto  size*2);
	s14 <= state(size*2-1   downto  size*1);
	s15 <= state(size*1-1   downto  size*0);

	result <= s12 & s10 & s15 & s5 & s14 & s8 & s9 & s2 & s11 & s3 & s7 & s4 & s6 & s0 & s1 & s13;
	
END behavioral;

