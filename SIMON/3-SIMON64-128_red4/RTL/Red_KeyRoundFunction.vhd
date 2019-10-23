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

entity Red_KeyRoundFunction is
	Generic (
		LFTable         : STD_LOGIC_VECTOR(63 downto 0);
		LFInvTable      : STD_LOGIC_VECTOR(63 downto 0);
		LFC				 : STD_LOGIC_VECTOR(3  downto 0));
	port(
		data_in1	: in  std_logic_vector(31 downto 0);
		data_in2	: in  std_logic_vector(31 downto 0);
		data_out : out std_logic_vector(31 downto 0));
end entity Red_KeyRoundFunction;

architecture behavioral of Red_KeyRoundFunction is

	signal data_out1 	: STD_LOGIC_VECTOR(31 downto 0);
	signal data_out2 	: STD_LOGIC_VECTOR(31 downto 0);
	
	signal input8_1 : STD_LOGIC_VECTOR(7 downto 0);
	signal input8_2 : STD_LOGIC_VECTOR(7 downto 0);	
	
begin

	input8_1 <= data_in1(3 downto 0) & data_in1(31 downto 28);
	input8_2 <= data_in2(3 downto 0) & data_in2(31 downto 28);

	GEN :
	FOR i IN 0 TO 3 GENERATE
	
		Red_RoundFunction1Inst1: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable1(i, LFTable, LFInvTable))
		PORT Map (data_in1(7 downto 0), data_out1(i));

		Red_RoundFunction2Inst1: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable2(i, LFTable, LFInvTable))
		PORT Map (data_in2(7 downto 0), data_out2(i));
		
		--

		Red_RoundFunction1Inst2: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable1(i, LFTable, LFInvTable))
		PORT Map (data_in1(11 downto 4), data_out1(4+i));

		Red_RoundFunction2Inst2: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable2(i, LFTable, LFInvTable))
		PORT Map (data_in2(11 downto 4), data_out2(4+i));
		
		--

		Red_RoundFunction1Inst3: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable1(i, LFTable, LFInvTable))
		PORT Map (data_in1(15 downto 8), data_out1(8+i));

		Red_RoundFunction2Inst3: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable2(i, LFTable, LFInvTable))
		PORT Map (data_in2(15 downto 8), data_out2(8+i));
		
		--

		Red_RoundFunction1Inst4: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable1(i, LFTable, LFInvTable))
		PORT Map (data_in1(19 downto 12), data_out1(12+i));

		Red_RoundFunction2Inst4: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable2(i, LFTable, LFInvTable))
		PORT Map (data_in2(19 downto 12), data_out2(12+i));
		
		--

		Red_RoundFunction1Inst5: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable1(i, LFTable, LFInvTable))
		PORT Map (data_in1(23 downto 16), data_out1(16+i));

		Red_RoundFunction2Inst5: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable2(i, LFTable, LFInvTable))
		PORT Map (data_in2(23 downto 16), data_out2(16+i));
		
		--

		Red_RoundFunction1Inst6: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable1(i, LFTable, LFInvTable))
		PORT Map (data_in1(27 downto 20), data_out1(20+i));

		Red_RoundFunction2Inst6: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable2(i, LFTable, LFInvTable))
		PORT Map (data_in2(27 downto 20), data_out2(20+i));
		
		--

		Red_RoundFunction1Inst7: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable1(i, LFTable, LFInvTable))
		PORT Map (data_in1(31 downto 24), data_out1(24+i));

		Red_RoundFunction2Inst7: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable2(i, LFTable, LFInvTable))
		PORT Map (data_in2(31 downto 24), data_out2(24+i));
		
		--

		Red_RoundFunction1Inst8: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable1(i, LFTable, LFInvTable))
		PORT Map (input8_1, data_out1(28+i));

		Red_RoundFunction2Inst8: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeKeyRoundFunctionRedTable2(i, LFTable, LFInvTable))
		PORT Map (input8_2, data_out2(28+i));
			
	END GENERATE;	
						
	FinalXOR: ENTITY work.XOR_2n
	GENERIC Map (size => 4, count => 8)
	PORT Map (data_out1, data_out2, data_out, LFC);
	

						
end architecture behavioral;
