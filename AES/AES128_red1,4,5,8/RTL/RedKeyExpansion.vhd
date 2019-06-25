----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Anita Aghaie, Amir Moradi, Aein Rezaei Shahmirzadi
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RedKeyExpansion is
	generic ( 
		Red_size  : POSITIVE;
		Table : STD_LOGIC_VECTOR (2047 downto 0));
    Port ( Key : in  STD_LOGIC_VECTOR (127 downto 0);
			  Red_Key : in  STD_LOGIC_VECTOR (Red_size*16-1 downto 0);
			  Red_rcon : in  STD_LOGIC_VECTOR (Red_size-1 downto 0);
           Red_ExpandedKey : out  STD_LOGIC_VECTOR (Red_size*16-1 downto 0));
end RedKeyExpansion;

architecture Behavioral of RedKeyExpansion is

		signal SBKey : STD_LOGIC_VECTOR (Red_size*4-1 DOWNTO 0);
		signal ShiftedSBKey : STD_LOGIC_VECTOR (Red_size*4-1 DOWNTO 0);
		signal w1, w2, w3, w0 : STD_LOGIC_VECTOR (Red_size*4-1 DOWNTO 0);
		
begin

	GEN0 :
	FOR i IN 12 TO 15 GENERATE
		LookUpSizex256_Inst0: ENTITY work.LookUpSizex256
		Generic Map ( Red_size, Table)
		Port Map (
			input		=> Key ((i+1)*8-1    downto i*8),
			output	=> SBKey((i+1-12)*Red_size-1 downto (i-12)*Red_size)
			);
			
	END GENERATE;
	
	ShiftedSBKey 	<= SBKey(Red_size-1 downto 0) & SBKey(Red_size*4-1 downto Red_size*1);
	
	w0_XOR3: ENTITY work.XOR_3n
	GENERIC Map ( size => Red_size, count => 1)
	PORT Map ( ShiftedSBKey(Red_size-1 downto 0), Red_rcon, Red_Key(Red_size-1 downto 0), w0(Red_size-1 downto 0));
	
	w0_XOR2: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 3)
	PORT Map ( ShiftedSBKey(Red_size*4-1 downto Red_size*1), Red_Key(Red_size*4-1 downto Red_size*1), w0(Red_size*4-1 downto Red_size*1));
	
	w1_XOR2: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( w0, Red_Key(Red_size*8-1 downto Red_size*4), w1);
	
	w2_XOR2: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( w1, Red_Key(Red_size*12-1 downto Red_size*8), w2);
	
	w3_XOR2: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( w2, Red_Key(Red_size*16-1 downto Red_size*12), w3);
	
	Red_ExpandedKey 	<= w3 & w2 & w1 & w0;
		
end Behavioral;

