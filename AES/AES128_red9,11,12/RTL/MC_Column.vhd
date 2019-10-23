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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MC_Column is
	 generic(size : positive := 8;
	        Mult2Table : STD_LOGIC_VECTOR (4095 DOWNTO 0);
			  Mult3Table : STD_LOGIC_VECTOR (4095 DOWNTO 0));
    Port ( in0 : in  STD_LOGIC_VECTOR (size*4-1 downto 0);
           q0 : out  STD_LOGIC_VECTOR (size*4-1 downto 0));
end MC_Column;

architecture Behavioral of MC_Column is

begin

	Inst_Row0MixColumn: ENTITY work.Row0MixColumn 
	generic map(size => size, Mult2Table => Mult2Table, Mult3Table => Mult3Table)
	PORT MAP(
		in0 => in0(size*1-1 downto size*0),
		in1 => in0(size*2-1 downto size*1),
		in2 => in0(size*3-1 downto size*2),
		in3 => in0(size*4-1 downto size*3),
		q => q0(size*1-1 downto 0)
	);
	
	Inst_Row1MixColumn: ENTITY work.Row1MixColumn 
	generic map(size => size, Mult2Table => Mult2Table, Mult3Table => Mult3Table)
	PORT MAP(
		in0 => in0(size*1-1 downto size*0),
		in1 => in0(size*2-1 downto size*1),
		in2 => in0(size*3-1 downto size*2),
		in3 => in0(size*4-1 downto size*3),
		q => q0(size*2-1 downto size*1)
	);

	Inst_Row2MixColumn: ENTITY work.Row2MixColumn 
	generic map(size => size, Mult2Table => Mult2Table, Mult3Table => Mult3Table)
	PORT MAP(
		in0 => in0(size*1-1 downto size*0),
		in1 => in0(size*2-1 downto size*1),
		in2 => in0(size*3-1 downto size*2),
		in3 => in0(size*4-1 downto size*3),
		q => q0(size*3-1 downto size*2)
	);
	
	Inst_Row3MixColumn: ENTITY work.Row3MixColumn 
	generic map(size => size, Mult2Table => Mult2Table, Mult3Table => Mult3Table)
	PORT MAP(
		in0 => in0(size*1-1 downto size*0),
		in1 => in0(size*2-1 downto size*1),
		in2 => in0(size*3-1 downto size*2),
		in3 => in0(size*4-1 downto size*3),
		q => q0(size*4-1 downto size*3)
	);
	
end Behavioral;

