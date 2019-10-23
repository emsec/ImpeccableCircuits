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

ENTITY Red_AddConst IS
	GENERIC (
		LFTable 		: STD_LOGIC_VECTOR(63 downto 0);
		LFC        	: STD_LOGIC_VECTOR (3  DOWNTO 0));
	PORT ( input 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 Red_FSM	: IN  STD_LOGIC_VECTOR (7  DOWNTO 0);
			 output	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));			 
END Red_AddConst;

ARCHITECTURE behavioral OF Red_AddConst IS
	
	signal input2 : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN

	input2 <= 	LFTable(31 downto 28) & Red_FSM(7 downto 4) & 
					LFTable(27 downto 24) & Red_FSM(3 downto 0) & 
					LFTable(55 downto 52) & Red_FSM(7 downto 4) & 
					LFTable(51 downto 48) & Red_FSM(3 downto 0);

	XORInst : ENTITY work.XOR_2n
	GENERIC Map (size => 4, count => 8)
	Port Map (input, input2, output, LFC);

END;

