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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Red_SB_MC IS
	 Generic ( 
		LFTable    : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFC        : STD_LOGIC_VECTOR (3  DOWNTO 0);
		SboxTable  : STD_LOGIC_VECTOR (63 DOWNTO 0));
	PORT ( state  : IN  STD_LOGIC_VECTOR (4*16-1 DOWNTO 0);
			 result : OUT STD_LOGIC_VECTOR (4*16-1 DOWNTO 0));
END Red_SB_MC;

ARCHITECTURE behavioral OF Red_SB_MC IS	
	signal s0, s1, s2, s3     : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	signal s4, s5, s6, s7     : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	signal s8, s9, s10, s11   : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	signal s12, s13, s14, s15 : STD_LOGIC_VECTOR (4-1 DOWNTO 0);

	signal r0, r1, r2, r3     : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	signal r4, r5, r6, r7     : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	signal r8, r9, r10, r11   : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	signal r12, r13, r14, r15 : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	
BEGIN

	s0	 <= state(4*16-1  downto  4*15);
	s1	 <= state(4*15-1  downto  4*14);
	s2	 <= state(4*14-1  downto  4*13);
	s3	 <= state(4*13-1  downto  4*12);
	s4	 <= state(4*12-1  downto  4*11);
	s5	 <= state(4*11-1  downto  4*10);
	s6	 <= state(4*10-1  downto  4*9);
	s7	 <= state(4*9-1   downto  4*8);
	s8	 <= state(4*8-1   downto  4*7);
	s9	 <= state(4*7-1   downto  4*6);
	s10 <= state(4*6-1   downto  4*5);
	s11 <= state(4*5-1   downto  4*4);
	s12 <= state(4*4-1   downto  4*3);
	s13 <= state(4*3-1   downto  4*2);
	s14 <= state(4*2-1   downto  4*1);
	s15 <= state(4*1-1   downto  4*0);

	------------------------------------------
	
	MC0: entity work.Red_SB_MixOneColumn
	GENERIC Map (LFTable, LFInvTable, LFC, SboxTable)
	PORT Map( s0, s4, s8, s12, r0, r4, r8, r12);

	MC1: entity work.Red_SB_MixOneColumn
	GENERIC Map (LFTable, LFInvTable, LFC, SboxTable)
	PORT Map( s1, s5, s9, s13, r1, r5, r9, r13);

	MC2: entity work.Red_SB_MixOneColumn
	GENERIC Map (LFTable, LFInvTable, LFC, SboxTable)
	PORT Map( s2, s6, s10, s14, r2, r6, r10, r14);

	MC3: entity work.Red_SB_MixOneColumn
	GENERIC Map (LFTable, LFInvTable, LFC, SboxTable)
	PORT Map( s3, s7, s11, s15, r3, r7, r11, r15);


	------------------------------------------
	
	result <= r0 & r1 & r2 & r3 & r4 & r5 & r6 & r7 & r8 & r9 & r10 & r11 & r12 & r13 & r14 & r15;

END behavioral;

