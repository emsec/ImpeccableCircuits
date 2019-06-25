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

entity MC_Column is
    Port ( in0 : in  STD_LOGIC_VECTOR (31 downto 0);
           q0 : out  STD_LOGIC_VECTOR (31 downto 0));
end MC_Column;

architecture Behavioral of MC_Column is

begin

	Inst_Row0MixColumn: ENTITY work.Row0MixColumn 
	PORT MAP(
		in0 => in0(7 downto 0),
		in1 => in0(15 downto 8),
		in2 => in0(23 downto 16),
		in3 => in0(31 downto 24),
		q => q0(7 downto 0)
	);
	
	Inst_Row1MixColumn: ENTITY work.Row1MixColumn 
	PORT MAP(
		in0 => in0(7 downto 0),
		in1 => in0(15 downto 8),
		in2 => in0(23 downto 16),
		in3 => in0(31 downto 24),
		q => q0(15 downto 8)
	);

	Inst_Row2MixColumn: ENTITY work.Row2MixColumn 
	PORT MAP(
		in0 => in0(7 downto 0),
		in1 => in0(15 downto 8),
		in2 => in0(23 downto 16),
		in3 => in0(31 downto 24),
		q => q0(23 downto 16)
	);
	
	Inst_Row3MixColumn: ENTITY work.Row3MixColumn 
	PORT MAP(
		in0 => in0(7 downto 0),
		in1 => in0(15 downto 8),
		in2 => in0(23 downto 16),
		in3 => in0(31 downto 24),
		q => q0(31 downto 24)
	);
	
end Behavioral;

