----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://doi.org/10.13154/tosc.v2019.i1.5-45 
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Christof Beierle, Gregor Leander, Amir Moradi, Shahram Rasoolzadeh 
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

ENTITY TISbox IS
	PORT (input1	:  IN  STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			input2	:  IN  STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			input3	:  IN  STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			clk		:  IN  STD_LOGIC;
			output1	: OUT STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			output2	: OUT STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			output3	: OUT STD_LOGIC_VECTOR (4-1 DOWNTO 0));
END TISbox;

ARCHITECTURE behavioral OF TISbox IS

	signal Reg1in_s1,
			 Reg1in_s2,
			 Reg1in_s3,
			 
			 Reg1out_s1,
			 Reg1out_s2,
			 Reg1out_s3  : STD_LOGIC_VECTOR (3 DOWNTO 0);
	
BEGIN

	G1: ENTITY work.G
	Port Map (
		input1	=> input2,
		input2	=> input3,
		output	=> Reg1in_s1);
		
	G2: ENTITY work.G
	Port Map (
		input1	=> input3,
		input2	=> input1,
		output	=> Reg1in_s2);

	G3: ENTITY work.G
	Port Map (
		input1	=> input1,
		input2	=> input2,
		output	=> Reg1in_s3);

	--------------------------------------------------

	reg1_s1: ENTITY work.reg
	GENERIC map ( size => 4)
	PORT map ( 
		clk 	=> clk,
		D 		=> Reg1in_s1,
		Q 		=> Reg1out_s1);

	reg1_s2: ENTITY work.reg
	GENERIC map ( size => 4)
	PORT map ( 
		clk 	=> clk,
		D 		=> Reg1in_s2,
		Q 		=> Reg1out_s2);

	reg1_s3: ENTITY work.reg
	GENERIC map ( size => 4)
	PORT map ( 
		clk 	=> clk,
		D 		=> Reg1in_s3,
		Q 		=> Reg1out_s3);

	--------------------------------------------------

	F1: ENTITY work.F
	Port Map (
		input1	=> Reg1out_s2,
		input2	=> Reg1out_s3,
		output	=> output1);
		
	F2: ENTITY work.F
	Port Map (
		input1	=> Reg1out_s3,
		input2	=> Reg1out_s1,
		output	=> output2);

	F3: ENTITY work.F
	Port Map (
		input1	=> Reg1out_s1,
		input2	=> Reg1out_s2,
		output	=> output3);

			
END behavioral;

