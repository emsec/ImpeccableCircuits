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

entity Red_StateUpdateBit is
	Generic ( 
		Red_size				: POSITIVE;
		LFTable    			: STD_LOGIC_VECTOR (63 DOWNTO 0);
		withDec 				: integer;
		BitNumber 			: integer);
   Port ( 
		FSM       			: in  STD_LOGIC_VECTOR (7 downto 0);
		EncDec				: in  STD_LOGIC;
      Red_FSMUpdateBit 	: out STD_LOGIC);
end Red_StateUpdateBit;

architecture Behavioral of Red_StateUpdateBit is

	constant LFTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(60) & LFTable(56) & LFTable(52) & LFTable(48) & LFTable(44) & LFTable(40) & LFTable(36) & LFTable(32) &
		LFTable(28) & LFTable(24) & LFTable(20) & LFTable(16) & LFTable(12) & LFTable(8) & LFTable(4) & LFTable(0);
	
	constant LFTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(61) & LFTable(57) & LFTable(53) & LFTable(49) & LFTable(45) & LFTable(41) & LFTable(37) & LFTable(33) &
		LFTable(29) & LFTable(25) & LFTable(21) & LFTable(17) & LFTable(13) & LFTable(9) & LFTable(5) & LFTable(1);

	constant LFTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(62) & LFTable(58) & LFTable(54) & LFTable(50) & LFTable(46) & LFTable(42) & LFTable(38) & LFTable(34) &
		LFTable(30) & LFTable(26) & LFTable(22) & LFTable(18) & LFTable(14) & LFTable(10) & LFTable(6) & LFTable(2);

	----

	signal FSMUpdate		: STD_LOGIC_VECTOR(7 downto 0);
	
begin

	Gen0_to_3: IF BitNumber < Red_size GENERATE
		FSMUpdate(3) <= NOT FSM(3);

		GenwithoutDec: IF withDec = 0 GENERATE
			FSMUpdate(0) <= FSM(1) WHEN FSM(3) = '1' ELSE FSM(0);
			FSMUpdate(1) <= FSM(2) WHEN FSM(3) = '1' ELSE FSM(1);
			FSMUpdate(2) <= (FSM(0) XOR FSM(1)) WHEN FSM(3) = '1' ELSE FSM(2);
		END GENERATE;	

		GenwithDec: IF withDec /= 0 GENERATE
			FSMUpdate(0) <= FSM(0) WHEN FSM(3) = '0' ELSE FSM(1) WHEN EncDec = '0' ELSE (FSM(0) XOR FSM(2));
			FSMUpdate(1) <= FSM(1) WHEN FSM(3) = '0' ELSE FSM(2) WHEN EncDec = '0' ELSE FSM(0);
			FSMUpdate(2) <= FSM(2) WHEN FSM(3) = '0' ELSE (FSM(0) XOR FSM(1)) WHEN EncDec = '0' ELSE FSM(1);
		END GENERATE;	

		GEN0: IF BitNumber=0 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable0(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;

		GEN1: IF BitNumber=1 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable1(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;

		GEN2: IF BitNumber=2 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable2(15-to_integer(unsigned(FSMUpdate(3 downto 0))));
			end process;	
		END GENERATE;
	END GENERATE;	
	
	---
	
	Gen4_to_7: IF BitNumber >= Red_size GENERATE
		GenwithoutDec: IF withDec = 0 GENERATE
			FSMUpdate(4) <= FSM(5) WHEN FSM(3) = '1' ELSE FSM(4);
			FSMUpdate(5) <= FSM(6) WHEN FSM(3) = '1' ELSE FSM(5);
			FSMUpdate(6) <= FSM(7) WHEN FSM(3) = '1' ELSE FSM(6);
			FSMUpdate(7) <= (FSM(4) XOR FSM(5)) WHEN FSM(3) = '1' ELSE FSM(7);
		END GENERATE;	

		GenwithDec: IF withDec /= 0 GENERATE
			FSMUpdate(4) <= FSM(4) WHEN FSM(3) = '0' ELSE FSM(5) WHEN EncDec = '0' ELSE (FSM(4) XOR FSM(7));
			FSMUpdate(5) <= FSM(5) WHEN FSM(3) = '0' ELSE FSM(6) WHEN EncDec = '0' ELSE FSM(4);
			FSMUpdate(6) <= FSM(6) WHEN FSM(3) = '0' ELSE FSM(7) WHEN EncDec = '0' ELSE FSM(5);
			FSMUpdate(7) <= FSM(7) WHEN FSM(3) = '0' ELSE (FSM(4) XOR FSM(5)) WHEN EncDec = '0' ELSE FSM(6);
		END GENERATE;	
		
		GEN4: IF BitNumber-Red_size=0 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable0(15-to_integer(unsigned(FSMUpdate(7 downto 4))));
			end process;	
		END GENERATE;

		GEN5: IF BitNumber-Red_size=1 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable1(15-to_integer(unsigned(FSMUpdate(7 downto 4))));
			end process;	
		END GENERATE;

		GEN6: IF BitNumber-Red_size=2 GENERATE
			LF_Process: Process (FSMUpdate)
			begin
				Red_FSMUpdateBit <= LFTable2(15-to_integer(unsigned(FSMUpdate(7 downto 4))));
			end process;	
		END GENERATE;		
	END GENERATE;	
	
end Behavioral;

