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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ShiftRows IS
	GENERIC ( size: POSITIVE);
	PORT ( state  : IN  STD_LOGIC_VECTOR (size*16-1 DOWNTO 0);
			 result : OUT STD_LOGIC_VECTOR (size*16-1 DOWNTO 0));
END ShiftRows;

ARCHITECTURE behavioral OF ShiftRows IS

BEGIN


   -- ROW 1 ----------------------------------------------------------------------
	result((16 * size - 1) DOWNTO (12 * size)) <= state((16 * size - 1) DOWNTO (12 * size));
	
	-- ROW 2 ----------------------------------------------------------------------
	result((12 * size - 1) DOWNTO ( 8 * size)) <= state(( 9 * size - 1) DOWNTO ( 8 * size)) & state((12 * size - 1) DOWNTO ( 9 * size));
	
	-- ROW 3 ----------------------------------------------------------------------	
	result(( 8 * size - 1) DOWNTO ( 4 * size)) <= state(( 6 * size - 1) DOWNTO ( 4 * size)) & state(( 8 * size - 1) DOWNTO ( 6 * size));

	-- ROW 4 ----------------------------------------------------------------------
	result(( 4 * size - 1) DOWNTO ( 0 * size)) <= state(( 3 * size - 1) DOWNTO ( 0 * size)) & state(( 4 * size - 1) DOWNTO ( 3 * size));
	


END behavioral;

