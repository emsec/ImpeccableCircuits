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
		size				 : NATURAL;
		LFTable         : STD_LOGIC_VECTOR(63 downto 0);
		LF_o_SboxTable  : STD_LOGIC_VECTOR(63 downto 0));
	port(
		data_in	: in  std_logic_vector(127       downto 0);
		data_out : out std_logic_vector(32*size-1 downto 0));
end entity Red_KeyPermutation;

architecture behavioral of Red_KeyPermutation is

	type In_ARRAY is array (integer range <>) of std_logic_vector(3 downto 0);
	signal input: In_ARRAY(0 to 31);	
	
begin

	input(31) <= data_in(66  downto  63);
	input(30) <= data_in(62  downto  59);
	input(29) <= data_in(58  downto  55);
	input(28) <= data_in(54  downto  51);
	input(27) <= data_in(50  downto  47);
	input(26) <= data_in(46  downto  43);
	input(25) <= data_in(42  downto  39);
	input(24) <= data_in(38  downto  35);
	input(23) <= data_in(34  downto  31);
	input(22) <= data_in(30  downto  27);
	input(21) <= data_in(26  downto  23);
	input(20) <= data_in(22  downto  19);
	input(19) <= data_in(18  downto  15);
	input(18) <= data_in(14  downto  11);
	input(17) <= data_in(10  downto   7);
	input(16) <= data_in(6   downto   3);
	input(15) <= data_in(2   downto   0) & data_in(127);
	input(14) <= data_in(126 downto 123);
	input(13) <= data_in(122 downto 119);
	input(12) <= data_in(118 downto 115);
	input(11) <= data_in(114 downto 111);
	input(10) <= data_in(110 downto 107);
	input(9)  <= data_in(106 downto 103);
	input(8)  <= data_in(102 downto  99);
	input(7)  <= data_in(98  downto  95);
	input(6)  <= data_in(94  downto  91);
	input(5)  <= data_in(90  downto  87);
	input(4)  <= data_in(86  downto  83);
	input(3)  <= data_in(82  downto  79);
	input(2)  <= data_in(78  downto  75);
	input(1)  <= data_in(74  downto  71);
	input(0)  <= data_in(70  downto  67);

	-----
	
	GEN1 :
	FOR j IN 0 TO 29 GENERATE	
		GEN2 :
		FOR i IN 0 TO size-1 GENERATE			
			Red_KeyPermInst: ENTITY work.Red_KeyPermutation2
			GENERIC Map (i, LFTable)
			PORT Map (input(j), data_out(j*size+i));					
		END GENERATE;
	END GENERATE;	
	
	GEN2 :
	FOR j IN 30 TO 31 GENERATE	
		GEN2 :
		FOR i IN 0 TO size-1 GENERATE			
			Red_KeyPermInst2: ENTITY work.Red_KeyPermutation2
			GENERIC Map (i, LF_o_SboxTable)
			PORT Map (input(j), data_out(j*size+i));					
		END GENERATE;
	END GENERATE;	

end architecture behavioral;
