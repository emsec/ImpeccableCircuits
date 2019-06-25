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

entity RedMixOneColumn is
		generic(Red_size : positive;
		        Table : STD_LOGIC_VECTOR (2047 DOWNTO 0));
    Port ( data_in  : in  STD_LOGIC_VECTOR (31 downto 0);
			  Red_in   : in  STD_LOGIC_VECTOR (Red_size*4-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (Red_size*4-1 downto 0));
end RedMixOneColumn;

architecture Behavioral of RedMixOneColumn is

begin

		Inst_RedRow0MixColumn: ENTITY work.RedRow0MixColumn 
		GENERIC Map ( Red_size => Red_size, Table => Table)
		PORT MAP(
			in0 => data_in(1*8-1        downto 0*8),
			in1 => data_in(2*8-1        downto 1*8),
			in2 => Red_in (3*Red_size-1 downto 2*Red_size),
			in3 => Red_in (4*Red_size-1 downto 3*Red_size),
			q   => data_out(Red_size-1  downto 0));
		
		Inst_RedRow1MixColumn: ENTITY work.RedRow1MixColumn 
		GENERIC Map ( Red_size => Red_size, Table => Table)
		PORT MAP(
			in0 => Red_in (1*Red_size-1  downto 0*Red_size),
			in1 => data_in(2*8-1         downto 1*8),
			in2 => data_in(3*8-1         downto 2*8),
			in3 => Red_in (4*Red_size-1  downto 3*Red_size),
			q   => data_out(2*Red_size-1 downto 1*Red_size));

		Inst_RedRow2MixColumn: ENTITY work.RedRow2MixColumn 
		GENERIC Map ( Red_size => Red_size, Table => Table)
		PORT MAP(
			in0 => Red_in (1*Red_size-1  downto 0*Red_size),
			in1 => Red_in (2*Red_size-1  downto 1*Red_size),
			in2 => data_in(3*8-1         downto 2*8),
			in3 => data_in(4*8-1         downto 3*8),
			q   => data_out(3*Red_size-1 downto 2*Red_size));
		
		Inst_RedRow3MixColumn: ENTITY work.RedRow3MixColumn 
		GENERIC Map ( Red_size => Red_size, Table => Table)
		PORT MAP(
			in0 => data_in(1*8-1         downto 0*8),
			in1 => Red_in (2*Red_size-1  downto 1*Red_size),
			in2 => Red_in (3*Red_size-1  downto 2*Red_size),
			in3 => data_in(4*8-1         downto 3*8),
			q   => data_out(4*Red_size-1 downto 3*Red_size));
	
end Behavioral;

