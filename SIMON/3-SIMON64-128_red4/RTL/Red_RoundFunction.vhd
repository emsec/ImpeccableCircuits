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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.functions.all;

entity Red_RoundFunction is
	Generic ( 
		LFTable         : STD_LOGIC_VECTOR(63 downto 0);
		LFInvTable      : STD_LOGIC_VECTOR(63 downto 0));
	port(
		data_in	: in  std_logic_vector(31 downto 0);
		data_out : out std_logic_vector(31 downto 0));
end entity Red_RoundFunction;

architecture behavioral of Red_RoundFunction is
	
	signal input1 : STD_LOGIC_VECTOR(11 downto 0);
	signal input2 : STD_LOGIC_VECTOR(11 downto 0);
	signal input3 : STD_LOGIC_VECTOR(11 downto 0);
	signal input4 : STD_LOGIC_VECTOR(11 downto 0);
	signal input5 : STD_LOGIC_VECTOR(11 downto 0);
	signal input6 : STD_LOGIC_VECTOR(11 downto 0);
	signal input7 : STD_LOGIC_VECTOR(11 downto 0);
	signal input8 : STD_LOGIC_VECTOR(11 downto 0);

begin

	input1 <= data_in(3 downto 0) & data_in(31 downto 24);
	input2 <= data_in(7 downto 0) & data_in(31 downto 28);
	input3 <= data_in(11 downto 0);
	input4 <= data_in(15 downto 4);
	input5 <= data_in(19 downto 8);
	input6 <= data_in(23 downto 12);
	input7 <= data_in(27 downto 16);
	input8 <= data_in(31 downto 20);

	GEN :
	FOR i IN 0 TO 3 GENERATE
	
		Red_RoundFunctionInst1: ENTITY work.Red_RoundFunction3
		GENERIC Map (i, LFTable, LFInvTable)
		PORT Map (input1, data_out(i));
		
		Red_RoundFunctionInst2: ENTITY work.Red_RoundFunction3
		GENERIC Map (i, LFTable, LFInvTable)
		PORT Map (input2, data_out(4+i));

		Red_RoundFunctionInst3: ENTITY work.Red_RoundFunction3
		GENERIC Map (i, LFTable, LFInvTable)
		PORT Map (input3, data_out(8+i));

		Red_RoundFunctionInst4: ENTITY work.Red_RoundFunction3
		GENERIC Map (i, LFTable, LFInvTable)
		PORT Map (input4, data_out(12+i));
		
		Red_RoundFunctionInst5: ENTITY work.Red_RoundFunction3
		GENERIC Map (i, LFTable, LFInvTable)
		PORT Map (input5, data_out(16+i));
		
		Red_RoundFunctionInst6: ENTITY work.Red_RoundFunction3
		GENERIC Map (i, LFTable, LFInvTable)
		PORT Map (input6, data_out(20+i));
		
		Red_RoundFunctionInst7: ENTITY work.Red_RoundFunction3
		GENERIC Map (i, LFTable, LFInvTable)
		PORT Map (input7, data_out(24+i));
		
		Red_RoundFunctionInst8: ENTITY work.Red_RoundFunction3
		GENERIC Map (i, LFTable, LFInvTable)
		PORT Map (input8, data_out(28+i));
		
	END GENERATE;	
										
end architecture behavioral;
