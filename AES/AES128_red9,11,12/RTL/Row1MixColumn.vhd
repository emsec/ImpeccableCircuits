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

entity Row1MixColumn is
    generic(size : positive := 8;
	        Mult2Table : STD_LOGIC_VECTOR (4095 DOWNTO 0);
			  Mult3Table : STD_LOGIC_VECTOR (4095 DOWNTO 0));
    Port ( in0 : in  STD_LOGIC_VECTOR (size-1 downto 0);
           in1 : in  STD_LOGIC_VECTOR (size-1 downto 0);
           in2 : in  STD_LOGIC_VECTOR (size-1 downto 0);
           in3 : in  STD_LOGIC_VECTOR (size-1 downto 0);
           q : out  STD_LOGIC_VECTOR (size-1 downto 0));
end Row1MixColumn;

architecture Behavioral of Row1MixColumn is
	signal Mult2Output : STD_LOGIC_VECTOR(size-1 downto 0);
	signal Mult3Output : STD_LOGIC_VECTOR(size-1 downto 0);
begin

	Mult3: ENTITY work.F8 
	GENERIC Map ( size => size, count => 1, Table => Mult3Table)
	PORT MAP(
		data_in  => in2,
		data_out => Mult3Output);
		
	Mult2: ENTITY work.F8 
	GENERIC Map ( size => size, count => 1, Table => Mult2Table)
	PORT MAP(
		data_in  => in1,
		data_out => Mult2Output);
		
		
	FinalXOR4: ENTITY work.XOR_4n
	GENERIC Map ( size => size, count => 1)
	PORT Map ( Mult2Output, Mult3Output, in0, in3, q);

	
end Behavioral;

