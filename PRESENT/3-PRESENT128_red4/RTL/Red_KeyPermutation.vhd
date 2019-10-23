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

entity Red_KeyPermutation is
	Generic ( 
		LFTable         : STD_LOGIC_VECTOR(63 downto 0);
		LFInvTable      : STD_LOGIC_VECTOR(63 downto 0);
		LF_o_SboxTable  : STD_LOGIC_VECTOR(63 downto 0));
	port(
		data_in	: in  std_logic_vector(127 downto 0);
		data_out : out std_logic_vector(127 downto 0));
end entity Red_KeyPermutation;

architecture behavioral of Red_KeyPermutation is

	type In_ARRAY is array (integer range <>) of std_logic_vector(7 downto 0);
	signal input: In_ARRAY(0 to 31);	
	
begin

	input(31) <= data_in(67  downto  60);
	input(30) <= data_in(63  downto  56);
	input(29) <= data_in(59  downto  52);
	input(28) <= data_in(55  downto  48);
	input(27) <= data_in(51  downto  44);
	input(26) <= data_in(47  downto  40);
	input(25) <= data_in(43  downto  36);
	input(24) <= data_in(39  downto  32);
	input(23) <= data_in(35  downto  28);
	input(22) <= data_in(31  downto  24);
	input(21) <= data_in(27  downto  20);
	input(20) <= data_in(23  downto  16);
	input(19) <= data_in(19  downto  12);
	input(18) <= data_in(15  downto   8);
	input(17) <= data_in(11  downto   4);
	input(16) <= data_in(7   downto   0);
	input(15) <= data_in(3   downto   0) & data_in(127 downto 124);
	input(14) <= data_in(127 downto 120);
	input(13) <= data_in(123 downto 116);
	input(12) <= data_in(119 downto 112);
	input(11) <= data_in(115 downto 108);
	input(10) <= data_in(111 downto 104);
	input(9)  <= data_in(107 downto 100);
	input(8)  <= data_in(103 downto  96);
	input(7)  <= data_in(99  downto  92);
	input(6)  <= data_in(95  downto  88);
	input(5)  <= data_in(91  downto  84);
	input(4)  <= data_in(87  downto  80);
	input(3)  <= data_in(83  downto  76);
	input(2)  <= data_in(79  downto  72);
	input(1)  <= data_in(75  downto  68);
	input(0)  <= data_in(71  downto  64);

	-----
	
	GEN1 :
	FOR j IN 0 TO 29 GENERATE	
		GEN2 :
		FOR i IN 0 TO 3 GENERATE			
			Red_KeyPermInst: ENTITY work.Red_KeyPermutation2
			GENERIC Map (i, LFTable, LFInvTable)
			PORT Map (input(j), data_out(j*4+i));					
		END GENERATE;
	END GENERATE;	
	
	GEN2 :
	FOR j IN 30 TO 31 GENERATE	
		GEN2 :
		FOR i IN 0 TO 3 GENERATE			
			Red_KeyPermInst2: ENTITY work.Red_KeyPermutation2
			GENERIC Map (i, LF_o_SboxTable, LFInvTable)
			PORT Map (input(j), data_out(j*4+i));					
		END GENERATE;
	END GENERATE;	

end architecture behavioral;
