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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Red_FSMSignals_done is
	Generic ( 
		LFSR4doneEnc 	: integer;
		LFSR3doneEnc 	: integer;
		LFSR4doneDec	: integer;
		LFSR3doneDec 	: integer;
		Red_size			: NATURAL;
		LFTable    		: STD_LOGIC_VECTOR (63 DOWNTO 0);
		withDec 			: integer);
   Port ( 
		FSM   			: in   STD_LOGIC_VECTOR (7 downto 0);
      EncDec			: in   STD_LOGIC;
		Red_done  		: out  STD_LOGIC_VECTOR (Red_size-1 downto 0));
end Red_FSMSignals_done;

architecture Behavioral of Red_FSMSignals_done is
begin

	Gen: FOR i in 0 to Red_size-1 GENERATE
		Red_FSMSignals_doneBitInst: ENTITY work.Red_FSMSignals_doneBit
		Generic Map (LFSR4doneEnc, LFSR3doneEnc, LFSR4doneDec, LFSR3doneDec, LFTable, withDec, i)
		Port Map (FSM, EncDec, Red_done(i));
	END GENERATE;	

end Behavioral;

