----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Anita Aghaie, Amir Moradi
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

ENTITY LookUp16 IS
	GENERIC (Table : STD_LOGIC_VECTOR (15 DOWNTO 0));
	PORT ( input:  IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 output: OUT STD_LOGIC);
END LookUp16;

ARCHITECTURE behavioral OF LookUp16 IS
	BEGIN

		WITH input SELECT
			output <= Table(15) WHEN x"0",
						 Table(14) WHEN x"1",
						 Table(13) WHEN x"2",
						 Table(12) WHEN x"3",
						 Table(11) WHEN x"4",
						 Table(10) WHEN x"5",
						 Table(9)  WHEN x"6",
						 Table(8)  WHEN x"7",
						 Table(7)  WHEN x"8",
						 Table(6)  WHEN x"9",
						 Table(5)  WHEN x"A",
						 Table(4)  WHEN x"B",
						 Table(3)  WHEN x"C",
						 Table(2)  WHEN x"D",
						 Table(1)  WHEN x"E",
						 Table(0)  WHEN OTHERS;
			
END behavioral;

