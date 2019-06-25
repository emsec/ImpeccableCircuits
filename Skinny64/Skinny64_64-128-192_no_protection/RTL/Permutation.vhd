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

entity Permutation is
GENERIC ( size  : POSITIVE);
Port (
       input_key 			   : in  STD_LOGIC_VECTOR (16*size-1 downto 0);
		 permuted_key 	      : out STD_LOGIC_VECTOR (16*size-1 downto 0));

end Permutation;

architecture Behavioral of Permutation is

begin

	-- ROW 1 ----------------------------------------------------------------------
	permuted_key((16 * size - 1) DOWNTO (15 * size)) <= input_key(( 7 * size - 1) DOWNTO ( 6 * size));
	permuted_key((15 * size - 1) DOWNTO (14 * size)) <= input_key(( 1 * size - 1) DOWNTO ( 0 * size));
	permuted_key((14 * size - 1) DOWNTO (13 * size)) <= input_key(( 8 * size - 1) DOWNTO ( 7 * size));
	permuted_key((13 * size - 1) DOWNTO (12 * size)) <= input_key(( 3 * size - 1) DOWNTO ( 2 * size));
	

	-- ROW 2 ----------------------------------------------------------------------	
	permuted_key((12 * size - 1) DOWNTO (11 * size)) <= input_key(( 6 * size - 1) DOWNTO ( 5 * size));
	permuted_key((11 * size - 1) DOWNTO (10 * size)) <= input_key(( 2 * size - 1) DOWNTO ( 1 * size));
	permuted_key((10 * size - 1) DOWNTO ( 9 * size)) <= input_key(( 4 * size - 1) DOWNTO ( 3 * size));
	permuted_key(( 9 * size - 1) DOWNTO ( 8 * size)) <= input_key(( 5 * size - 1) DOWNTO ( 4 * size));
	

	-- ROW 3 ----------------------------------------------------------------------	
	permuted_key(( 8 * size - 1) DOWNTO ( 7 * size)) <= input_key((16 * size - 1) DOWNTO (15 * size));
	permuted_key(( 7 * size - 1) DOWNTO ( 6 * size)) <= input_key((15 * size - 1) DOWNTO (14 * size));
	permuted_key(( 6 * size - 1) DOWNTO ( 5 * size)) <= input_key((14 * size - 1) DOWNTO (13 * size));
	permuted_key(( 5 * size - 1) DOWNTO ( 4 * size)) <= input_key((13 * size - 1) DOWNTO (12 * size));
	

	-- ROW 4 ----------------------------------------------------------------------	
	permuted_key(( 4 * size - 1) DOWNTO ( 3 * size)) <= input_key((12 * size - 1) DOWNTO (11 * size));
	permuted_key(( 3 * size - 1) DOWNTO ( 2 * size)) <= input_key((11 * size - 1) DOWNTO (10 * size));
	permuted_key(( 2 * size - 1) DOWNTO ( 1 * size)) <= input_key((10 * size - 1) DOWNTO ( 9 * size));
	permuted_key(( 1 * size - 1) DOWNTO ( 0 * size)) <= input_key(( 9 * size - 1) DOWNTO ( 8 * size));
	
	
end Behavioral;

