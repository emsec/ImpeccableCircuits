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

ENTITY AddConst IS
	GENERIC (
		size        : POSITIVE;
		Table 		: STD_LOGIC_VECTOR (63 DOWNTO 0);
		Const    	: STD_LOGIC_VECTOR (3  DOWNTO 0));
	PORT ( input 	: IN  STD_LOGIC_VECTOR (size*8-1 DOWNTO 0);
			 FSM		: IN  STD_LOGIC_VECTOR (size*2-1 DOWNTO 0);
			 output	: OUT STD_LOGIC_VECTOR (size*8-1 DOWNTO 0));			 
END AddConst;

ARCHITECTURE behavioral OF AddConst IS
	
	signal input2 : STD_LOGIC_VECTOR (size*8-1 DOWNTO 0);

BEGIN

	input2 <= 	Table(44+size-1 downto 44) & FSM(size*2-1 downto size) & 
					Table(40+size-1 downto 40) & FSM(size-1   downto 0) & 
					Table(52+size-1 downto 52) & FSM(size*2-1 downto size) & 
					Table(48+size-1 downto 48) & FSM(size-1   downto 0);

	XORInst : ENTITY work.XOR_2n
	GENERIC Map (size => size, count => 8)
	Port Map (input, input2, output, Const(size-1 downto 0));

END;

