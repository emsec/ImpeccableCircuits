----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Amir Moradi
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Permutation is
	GENERIC ( size: POSITIVE);
	port(
		data_in	: in  std_logic_vector(16*size-1 downto 0);
		data_out : out std_logic_vector(16*size-1 downto 0));
end entity Permutation;

architecture behavioral of Permutation is
	signal s0, s1, s2, s3     : STD_LOGIC_VECTOR (2*size-1 DOWNTO 0);
	signal s4, s5, s6, s7     : STD_LOGIC_VECTOR (2*size-1 DOWNTO 0);

BEGIN

	s0	 <= data_in(size*16-1  downto  size*14);
	s1	 <= data_in(size*14-1  downto  size*12);
	s2	 <= data_in(size*12-1  downto  size*10);
	s3	 <= data_in(size*10-1  downto   size*8);
	s4	 <= data_in( size*8-1  downto   size*6);
	s5	 <= data_in( size*6-1  downto   size*4);
	s6	 <= data_in( size*4-1  downto   size*2);
	s7	 <= data_in( size*2-1  downto       0);

	data_out <= s2 & s7 & s4 & s1 & s6 & s3 & s0 & s5;
					
end architecture behavioral;
