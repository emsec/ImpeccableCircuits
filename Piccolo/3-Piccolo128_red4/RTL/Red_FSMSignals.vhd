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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.functions.all;

entity Red_FSMSignals is
	GENERIC ( LFTable 	: STD_LOGIC_VECTOR(63 downto 0);
				 LFInvTable : STD_LOGIC_VECTOR(63 downto 0));
    Port ( Red_FSM   				: in   STD_LOGIC_VECTOR (7 downto 0);
			  Red_last  				: out  STD_LOGIC_VECTOR (3 downto 0);
			  Red_done  				: out  STD_LOGIC_VECTOR (3 downto 0);
  			  Red_WhiteningKeySel0	: out  STD_LOGIC_VECTOR (3 downto 0);
			  Red_WhiteningKeySel1	: out  STD_LOGIC_VECTOR (3 downto 0);
			  Red_KeySelLeft0			: out  STD_LOGIC_VECTOR (3 downto 0);
			  Red_KeySelLeft1			: out  STD_LOGIC_VECTOR (3 downto 0);
			  Red_KeySelRight0		: out  STD_LOGIC_VECTOR (3 downto 0);
			  Red_KeySelRight1		: out  STD_LOGIC_VECTOR (3 downto 0));
end Red_FSMSignals;

architecture Behavioral of Red_FSMSignals is
begin

	GEN :
	FOR i IN 0 TO 3 GENERATE
		Red_lastInst: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeSignallastRedTable(i, LFTable, LFInvTable))
		PORT Map (Red_FSM, Red_last(i));

		Red_doneInst: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeSignaldoneRedTable(i, LFTable, LFInvTable))
		PORT Map (Red_FSM, Red_done(i));

		Red_WhiteningKeySel0Inst: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeSignalWhiteningKeySelRedTable(i, LFTable, LFInvTable))
		PORT Map (Red_FSM, Red_WhiteningKeySel0(i));

		Red_WhiteningKeySel1Inst: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeSignalWhiteningKeySelRedTable(4+i, LFTable, LFInvTable))
		PORT Map (Red_FSM, Red_WhiteningKeySel1(i));

		Red_KeySelLeft0Inst: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeSignalKeySelLeftRedTable(i, LFTable, LFInvTable))
		PORT Map (Red_FSM, Red_KeySelLeft0(i));

		Red_KeySelLeft1Inst: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeSignalKeySelLeftRedTable(4+i, LFTable, LFInvTable))
		PORT Map (Red_FSM, Red_KeySelLeft1(i));

		Red_KeySelRight0Inst: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeSignalKeySelRightRedTable(i, LFTable, LFInvTable))
		PORT Map (Red_FSM, Red_KeySelRight0(i));

		Red_KeySelRight1Inst: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => MakeSignalKeySelRightRedTable(4+i, LFTable, LFInvTable))
		PORT Map (Red_FSM, Red_KeySelRight1(i));
	END GENERATE;
	
end Behavioral;

