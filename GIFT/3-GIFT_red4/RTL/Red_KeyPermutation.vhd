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

entity Red_KeyPermutation is
	Generic ( 
		LFTable         : STD_LOGIC_VECTOR(63 downto 0);
		LFInvTable      : STD_LOGIC_VECTOR(63 downto 0));
	port(
		data_in			: in  std_logic_vector(127 downto 0);
		Red_FSM			: in  std_logic_vector(7   downto 0);
		Red_RoundKey	: out std_logic_vector(63  downto 0);		
		data_out 		: out std_logic_vector(127 downto 0));
end entity Red_KeyPermutation;

architecture behavioral of Red_KeyPermutation is

	signal Input4				: STD_LOGIC_VECTOR(7  downto 0);
	signal Input3				: STD_LOGIC_VECTOR(7  downto 0);
	signal Input2				: STD_LOGIC_VECTOR(7  downto 0);
	signal Input1				: STD_LOGIC_VECTOR(11 downto 0);
	signal Input0				: STD_LOGIC_VECTOR(11 downto 0);	
	
	signal PermIn3				: STD_LOGIC_VECTOR(7 downto 0);
	signal PermIn2				: STD_LOGIC_VECTOR(7 downto 0);
	signal PermIn1				: STD_LOGIC_VECTOR(7 downto 0);
	signal PermIn0				: STD_LOGIC_VECTOR(7 downto 0);
			
begin

	Input4 <= data_in(31 downto 28) & data_in(15 downto 12);
	Input3 <= data_in(27 downto 24) & data_in(11 downto 8);
	Input2 <= data_in(23 downto 20) & data_in(7  downto 4);

	Input1 <= Red_FSM(7 downto 4) & data_in(23 downto 20) & data_in(7 downto 4);
	Input0 <= Red_FSM(3 downto 0) & data_in(19 downto 16) & data_in(3 downto 0);

	GENRoundKey :
	FOR i IN 0 TO 3 GENERATE
		Red_KeyInst15: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 3, "10")
		Port Map ( input4, Red_RoundKey(60+i));

		Red_KeyInst14: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 2, "00")
		Port Map ( input4, Red_RoundKey(56+i));
		
		Red_KeyInst13: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 1, "00")
		Port Map ( input4, Red_RoundKey(52+i));
		
		Red_KeyInst12: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 0, "00")
		Port Map ( input4, Red_RoundKey(48+i));
		
		-----
		
		Red_KeyInst11: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 3, "00")
		Port Map ( input3, Red_RoundKey(44+i));
		
		Red_KeyInst10: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 2, "00")
		Port Map ( input3, Red_RoundKey(40+i));
		
		Red_KeyInst9: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 1, "00")
		Port Map ( input3, Red_RoundKey(36+i));
		
		Red_KeyInst8: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 0, "00")
		Port Map ( input3, Red_RoundKey(32+i));
		
		-----
		
		Red_KeyInst7: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 3, "00")
		Port Map ( input2, Red_RoundKey(28+i));
		
		Red_KeyInst6: ENTITY work.Red_RoundKey2
		Generic Map (i, LFTable, LFInvTable, 2, "00")
		Port Map ( input2, Red_RoundKey(24+i));
		
		Red_KeyInst5: ENTITY work.Red_RoundKey3
		Generic Map (i, LFTable, LFInvTable, 1, '0')
		Port Map ( input1, Red_RoundKey(20+i));

		Red_KeyInst4: ENTITY work.Red_RoundKey3
		Generic Map (i, LFTable, LFInvTable, 0, '0')
		Port Map ( input1, Red_RoundKey(16+i));		
		
		-----

		Red_KeyInst3: ENTITY work.Red_RoundKey3
		Generic Map (i, LFTable, LFInvTable, 3, '0')
		Port Map ( input0, Red_RoundKey(12+i));

		Red_KeyInst2: ENTITY work.Red_RoundKey3
		Generic Map (i, LFTable, LFInvTable, 2, '0')
		Port Map ( input0, Red_RoundKey(8+i));

		Red_KeyInst1: ENTITY work.Red_RoundKey3
		Generic Map (i, LFTable, LFInvTable, 1, '0')
		Port Map ( input0, Red_RoundKey(4+i));

		Red_KeyInst0: ENTITY work.Red_RoundKey3
		Generic Map (i, LFTable, LFInvTable, 0, '0')
		Port Map ( input0, Red_RoundKey(0+i));		

	END GENERATE;

	-----
	
	PermIn0 <= data_in(23 downto 16);
	PermIn1 <= data_in(27 downto 20);
	PermIn2 <= data_in(31 downto 24);
	PermIn3 <= data_in(19 downto 16) & data_in(31 downto 28);
	
	GENPerm :
	FOR i IN 0 TO 3 GENERATE	
		PermInst0: ENTITY work.LookUp
		Generic Map (size => 8, Table => MakePermKeyRedTable(i, LFTable, LFInvTable))
		Port Map ( PermIn0, data_out(112+i));	
	
		PermInst1: ENTITY work.LookUp
		Generic Map (size => 8, Table => MakePermKeyRedTable(i, LFTable, LFInvTable))
		Port Map ( PermIn1, data_out(116+i));	

		PermInst2: ENTITY work.LookUp
		Generic Map (size => 8, Table => MakePermKeyRedTable(i, LFTable, LFInvTable))
		Port Map ( PermIn2, data_out(120+i));	

		PermInst3: ENTITY work.LookUp
		Generic Map (size => 8, Table => MakePermKeyRedTable(i, LFTable, LFInvTable))
		Port Map ( PermIn3, data_out(124+i));	
		
	END GENERATE;
	
	data_out(111 downto 0) <= data_in(11 downto 0) & data_in(15 downto 12) & data_in(127 downto 32);

end architecture behavioral;
