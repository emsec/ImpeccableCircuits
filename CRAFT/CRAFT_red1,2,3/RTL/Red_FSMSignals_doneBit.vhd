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

entity Red_FSMSignals_doneBit is
	Generic ( 
		LFSR4doneEnc 	: integer;
		LFSR3doneEnc 	: integer;
		LFSR4doneDec	: integer;
		LFSR3doneDec 	: integer;
		LFTable    		: STD_LOGIC_VECTOR (63 DOWNTO 0);
		withDec 			: integer;
		BitNumber		: integer);
   Port ( 
		FSM   			: in   STD_LOGIC_VECTOR (6 downto 0);
      EncDec			: in   STD_LOGIC;
		Red_doneBit		: out  STD_LOGIC);
end Red_FSMSignals_doneBit;

architecture Behavioral of Red_FSMSignals_doneBit is

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

	signal FSMdoneEnc : STD_LOGIC_VECTOR (6 downto 0);
	signal FSMdoneDec : STD_LOGIC_VECTOR (6 downto 0);
	signal FSMdone    : STD_LOGIC_VECTOR (6 downto 0);
	
	signal done_vec	: STD_LOGIC_VECTOR (3 downto 0);

begin

	GenwithoutDec: IF withDec = 0 GENERATE
		FSMdone 		<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
	END GENERATE;

	GenwithDec: IF withDec /= 0 GENERATE
		FSMdoneEnc 	<=	std_logic_vector(to_unsigned(LFSR4doneEnc,4)) & std_logic_vector(to_unsigned(LFSR3doneEnc,3));
		FSMdoneDec	<= std_logic_vector(to_unsigned(LFSR4doneDec,4)) & std_logic_vector(to_unsigned(LFSR3doneDec,3));

		FSMdone		<= FSMdoneEnc WHEN EncDec = '0' ELSE FSMdoneDec;
	END GENERATE;

	done_vec(0)	<= '1' WHEN (FSM = FSMdone) ELSE '0';
	done_vec(1) <= '0';
	done_vec(2) <= '0';
	done_vec(3) <= '0';

	-------------------
	
	GEN0: IF BitNumber=0 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_doneBit <= LFTable0(15-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;

	GEN1: IF BitNumber=1 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_doneBit <= LFTable1(15-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;

	GEN2: IF BitNumber=2 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_doneBit <= LFTable2(15-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;

end Behavioral;

