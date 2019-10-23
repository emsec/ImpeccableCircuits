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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY RoundFunction IS
	PORT ( 
		Input	 	: IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
		IR 	 	: IN  STD_LOGIC;
		Kba		: IN  STD_LOGIC_VECTOR ( 1 DOWNTO 0);
		Output	: OUT STD_LOGIC_VECTOR (63 DOWNTO 0));			 
END RoundFunction;

ARCHITECTURE behavioral OF RoundFunction IS

	signal Fa, Fb : std_logic;

BEGIN

	Fb <= (Input(9) AND Input(14)) XOR (Input(21) AND Input(33)) XOR Input(25) XOR Input(38) XOR Kba(1);
	Fa <= (IR       AND Input(48)) XOR (Input(50) AND Input(59)) XOR Input(54) XOR Input(63) XOR Kba(0);
	
	Output(63 downto 40) <= Input(62 downto 39);
	Output(39)				<= Fb;
	Output(38 downto 1)  <= Input(37 downto 0);
	Output(0)				<= Fa;
	
END;

