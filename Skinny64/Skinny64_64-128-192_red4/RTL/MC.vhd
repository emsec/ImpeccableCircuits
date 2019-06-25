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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY MC IS
	GENERIC ( size  : POSITIVE;
				 const : STD_LOGIC_VECTOR (3 DOWNTO 0) := (others => '0'));
	PORT ( state    : IN  STD_LOGIC_VECTOR (size*16-1 DOWNTO 0);
			 result   : OUT STD_LOGIC_VECTOR (size*16-1 DOWNTO 0));
END MC;

ARCHITECTURE behavioral OF MC IS	
	signal row0, row1, row2, row3 : STD_LOGIC_VECTOR (size*4-1 DOWNTO 0);
	signal r0, r1, r2, r3         : STD_LOGIC_VECTOR (size*4-1 DOWNTO 0);

BEGIN

	row0 <= state(size*16-1  downto  size*12);
	row1 <= state(size*12-1  downto  size*8);
	row2 <= state(size*8-1   downto  size*4);
	row3 <= state(size*4-1   downto  size*0);

	------------------------------------------
	
	MCR0: entity work.XOR_3n
	GENERIC Map ( size => size, count=> 4)
	PORT Map( row0, row2, row3, r0);

	--MCR1: 
	r1<= row0;

	MCR2: entity work.XOR_2n
	GENERIC Map ( size => size, count=> 4)
	PORT Map( row1, row2, r2, const);

	MCR3: entity work.XOR_2n
	GENERIC Map ( size => size, count=> 4)
	PORT Map( row0, row2, r3, const);

	------------------------------------------
	
	result <= r0 & r1 & r2 & r3;

END behavioral;

