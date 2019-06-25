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

ENTITY F IS
	PORT ( input1 : IN  STD_LOGIC_VECTOR (3 downto 0);
			 input2 : IN  STD_LOGIC_VECTOR (3 downto 0);
			 output : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END F;

ARCHITECTURE behavioral OF F IS

	signal x0, x1, x2, x3, x4, x5, x6, x7 : std_logic;
	signal y0, y1, y2, y3				     : std_logic;

BEGIN
	
	x0 <= input1(0);
	x1 <= input1(1);
	x2 <= input1(2);
	x3 <= input1(3);	

	x4 <= input2(0);
	x5 <= input2(1);
	x6 <= input2(2);
	x7 <= input2(3);	
	
	y0 <= x4;
	y1 <= x5 xor (x1 AND x3) xor (x1 AND x7) xor (x3 AND x5) xor (x2 AND x3) xor (x2 AND x7) xor (x3 AND x6);
	y2 <= x6 xor (x1 AND x3) xor (x1 AND x7) xor (x3 AND x5) ;
	y3 <= x7;
	
	output(0) <= y2;
	output(1) <= y0;
	output(2) <= y2 xor y3;
	output(3) <= not y1;	
	
END behavioral;
