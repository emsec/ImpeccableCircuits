----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://doi.org/10.13154/tosc.v2019.i1.5-45 
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

-- withTweak      : 0/1 (whether 64-bit Tweak is taken into account)
-- withDec        : 0/1 (whether both encryption and decryption should be realzied)
-- withKeyMasking : 0/1 (whether Key should be also masked)

entity Cipher is
	 Generic ( 
		withTweak 		: integer := 0;
		withDec   		: integer := 0;
		withKeyMasking : integer := 0);
    Port ( 
		clk 			: in  STD_LOGIC;
      rst 			: in  STD_LOGIC;
		EncDec		: in  STD_LOGIC := '0';  -- 0: encryption  1: decryption
      Input1		: in  STD_LOGIC_VECTOR ( 63 downto 0);
      Input2		: in  STD_LOGIC_VECTOR ( 63 downto 0);
      Input3		: in  STD_LOGIC_VECTOR ( 63 downto 0);
      Key1 			: in  STD_LOGIC_VECTOR (127 downto 0);
      Key2 			: in  STD_LOGIC_VECTOR (127 downto 0);
      Key3 			: in  STD_LOGIC_VECTOR (127 downto 0);
		Tweak       : in  STD_LOGIC_VECTOR ( 63 downto 0) := (others => '0');
      Output1 		: out STD_LOGIC_VECTOR ( 63 downto 0);
      Output2 		: out STD_LOGIC_VECTOR ( 63 downto 0);
      Output3 		: out STD_LOGIC_VECTOR ( 63 downto 0);
      done 			: out STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is

	signal StateRegOutput1						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput1					: STD_LOGIC_VECTOR(63 downto 0);
	signal PermutationOutput1					: STD_LOGIC_VECTOR(63 downto 0);
	signal MCInput1								: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput1								: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback1								: STD_LOGIC_VECTOR(63 downto 0);

	signal StateRegOutput2						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput2					: STD_LOGIC_VECTOR(63 downto 0);
	signal PermutationOutput2					: STD_LOGIC_VECTOR(63 downto 0);
	signal MCInput2								: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput2								: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback2								: STD_LOGIC_VECTOR(63 downto 0);

	signal StateRegOutput3						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput3					: STD_LOGIC_VECTOR(63 downto 0);
	signal PermutationOutput3					: STD_LOGIC_VECTOR(63 downto 0);
	signal MCInput3								: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput3								: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback3								: STD_LOGIC_VECTOR(63 downto 0);

	signal RoundKey1								: STD_LOGIC_VECTOR(63 downto 0);
	signal K0_1										: STD_LOGIC_VECTOR(63 downto 0);
	signal K1_1										: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedKey1							: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedTweakKey1					: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedTweakKeyMC1					: STD_LOGIC_VECTOR(63 downto 0);

	signal RoundKey2								: STD_LOGIC_VECTOR(63 downto 0);
	signal K0_2										: STD_LOGIC_VECTOR(63 downto 0);
	signal K1_2										: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedKey2							: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedKeyMC2						: STD_LOGIC_VECTOR(63 downto 0);

	signal RoundKey3								: STD_LOGIC_VECTOR(63 downto 0);
	signal K0_3										: STD_LOGIC_VECTOR(63 downto 0);
	signal K1_3										: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedKey3							: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedKeyMC3						: STD_LOGIC_VECTOR(63 downto 0);
	
	signal RoundConstant							: STD_LOGIC_VECTOR(7  downto 0);
	signal SelectedTweak							: STD_LOGIC_VECTOR(63 downto 0);
	signal Tweak_Q									: STD_LOGIC_VECTOR(63 downto 0);

	signal FSM										: STD_LOGIC_VECTOR(7  downto 0);
	signal FSMInitial								: STD_LOGIC_VECTOR(7  downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(7  downto 0);
	signal FSMReg									: STD_LOGIC_VECTOR(7  downto 0);

	signal notEncDec								: STD_LOGIC;
	signal selects									: STD_LOGIC_VECTOR(1  downto 0);
	signal selectsReg								: STD_LOGIC_VECTOR(1  downto 0);
	signal selectsInitial						: STD_LOGIC_VECTOR(1  downto 0);
	signal selectsNext							: STD_LOGIC_VECTOR(1  downto 0);
	signal sel_Key									: STD_LOGIC;
	signal sel_Tweak								: STD_LOGIC;
	signal done_internal							: STD_LOGIC;
	
begin

	InputMUX1: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Feedback1,
		D1 	=> Input1,
		Q 		=> MCInput1);

	MCInst1: ENTITY work.MC
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> MCInput1,
		result	=> MCOutput1);
	
	AddKeyXOR1_1: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 4)
	PORT Map ( MCOutput1(63 downto 48), RoundKey1(63 downto 48), AddRoundKeyOutput1(63 downto 48));

	AddKeyConstXOR1: ENTITY work.XOR_3n
	GENERIC Map ( size => 4, count => 2)
	PORT Map ( MCOutput1(47 downto 40), RoundKey1(47 downto 40), RoundConstant, AddRoundKeyOutput1(47 downto 40));

	AddKeyXOR2_1: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 10)
	PORT Map ( MCOutput1(39 downto 0), RoundKey1(39 downto 0), AddRoundKeyOutput1(39 downto 0));

	StateReg1: ENTITY work.reg
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		D 		=> AddRoundKeyOutput1,
		Q 		=> StateRegOutput1);

	PermutationInst1: ENTITY work.Permutation
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> StateRegOutput1,
		result	=> PermutationOutput1);

	--------
	
	InputMUX2: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Feedback2,
		D1 	=> Input2,
		Q 		=> MCInput2);

	MCInst2: ENTITY work.MC
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> MCInput2,
		result	=> MCOutput2);

	GenAddKeyMasking2: IF withKeyMasking /= 0 GENERATE
		AddKeyXOR2: ENTITY work.XOR_2n
		GENERIC Map ( size => 4, count => 16)
		PORT Map ( MCOutput2, RoundKey2, AddRoundKeyOutput2);
	END GENERATE;

	GennotAddKeyMasking2: IF withKeyMasking = 0 GENERATE
		AddRoundKeyOutput2 <= MCOutput2;
	END GENERATE;
	
	StateReg2: ENTITY work.reg
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		D 		=> AddRoundKeyOutput2,
		Q 		=> StateRegOutput2);
		
	PermutationInst2: ENTITY work.Permutation
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> StateRegOutput2,
		result	=> PermutationOutput2);

	--------	
	
	InputMUX3: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Feedback3,
		D1 	=> Input3,
		Q 		=> MCInput3);

	MCInst3: ENTITY work.MC
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> MCInput3,
		result	=> MCOutput3);

	GenAddKeyMasking3: IF withKeyMasking /= 0 GENERATE
		AddKeyXOR2: ENTITY work.XOR_2n
		GENERIC Map ( size => 4, count => 16)
		PORT Map ( MCOutput3, RoundKey3, AddRoundKeyOutput3);
	END GENERATE;

	GennotAddKeyMasking3: IF withKeyMasking = 0 GENERATE
		AddRoundKeyOutput3 <= MCOutput3;
	END GENERATE;

	StateReg3: ENTITY work.reg
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		D 		=> AddRoundKeyOutput3,
		Q 		=> StateRegOutput3);

	PermutationInst3: ENTITY work.Permutation
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> StateRegOutput3,
		result	=> PermutationOutput3);

	--------	

	SubCellInst: ENTITY work.TISubCell
	GENERIC Map ( count => 16)
	PORT Map (
		input1 	=> PermutationOutput1,
		input2 	=> PermutationOutput2,
		input3 	=> PermutationOutput3,
		clk		=> clk,
		output1	=> Feedback1,
		output2	=> Feedback2,
		output3	=> Feedback3);

	--===================================================

	K0_1 	<= Key1 (127 DOWNTO 64);
	K1_1 	<= Key1 (63  DOWNTO 0);

	KeyMUX1: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> sel_Key,
		D0   	=> K0_1,
		D1 	=> K1_1,
		Q 		=> SelectedKey1);

	GenwithoutTweak: IF withTweak = 0 GENERATE
		SelectedTweakKey1 <= SelectedKey1;
	END GENERATE;

	GenwithTweak: IF withTweak /= 0 GENERATE
		Tweak_QInst: ENTITY work.TweakPermutation 
		GENERIC Map (size => 4)
		PORT Map (Tweak, Tweak_Q);

		TweakMUX: ENTITY work.MUX
		GENERIC Map ( size => 64)
		PORT Map ( 
			sel	=> sel_Tweak,
			D0   	=> Tweak,
			D1 	=> Tweak_Q,
			Q 		=> SelectedTweak);
			
		SelectedTweakKey1 <= SelectedKey1 XOR SelectedTweak;
	END GENERATE;

	
	GenKeyMasking: IF withKeyMasking /= 0 GENERATE
		K0_2 	<= Key2 (127 DOWNTO 64);
		K1_2 	<= Key2 (63  DOWNTO 0);

		K0_3 	<= Key3 (127 DOWNTO 64);
		K1_3 	<= Key3 (63  DOWNTO 0);

		KeyMUX2: ENTITY work.MUX
		GENERIC Map ( size => 64)
		PORT Map ( 
			sel	=> sel_Key,
			D0   	=> K0_2,
			D1 	=> K1_2,
			Q 		=> SelectedKey2);
		
		KeyMUX3: ENTITY work.MUX
		GENERIC Map ( size => 64)
		PORT Map ( 
			sel	=> sel_Key,
			D0   	=> K0_3,
			D1 	=> K1_3,
			Q 		=> SelectedKey3);
	END GENERATE;		
	
	-------

	GenwithoutDecKey: IF withDec = 0 GENERATE
		RoundKey1	<= SelectedTweakKey1;	

		GenKeyMasking: IF withKeyMasking /= 0 GENERATE
			RoundKey2	<= SelectedKey2;	
			RoundKey3	<= SelectedKey3;	
		END GENERATE;	
	END GENERATE;
	
	GenwithDecKey: IF withDec /= 0 GENERATE
		KeyMCInst1: ENTITY work.MC
		GENERIC Map ( size => 4)
		PORT Map (
			state		=> SelectedTweakKey1,
			result	=> SelectedTweakKeyMC1);

		EncDecKeyMUX1: ENTITY work.MUX
		GENERIC Map ( size => 32)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> SelectedTweakKey1  (63 downto 32),
			D1 	=> SelectedTweakKeyMC1(63 downto 32),
			Q 		=> RoundKey1          (63 downto 32));	

		RoundKey1(31 downto 0) <= SelectedTweakKey1(31 downto 0);	
		
		--------

		GenKeyMasking: IF withKeyMasking /= 0 GENERATE
			KeyMCInst2: ENTITY work.MC
			GENERIC Map ( size => 4)
			PORT Map (
				state		=> SelectedKey2,
				result	=> SelectedKeyMC2);

			KeyMCInst3: ENTITY work.MC
			GENERIC Map ( size => 4)
			PORT Map (
				state		=> SelectedKey3,
				result	=> SelectedKeyMC3);
			
			----			

			EncDecKeyMUX2: ENTITY work.MUX
			GENERIC Map ( size => 32)
			PORT Map ( 
				sel	=> EncDec,
				D0   	=> SelectedKey2  (63 downto 32),
				D1 	=> SelectedKeyMC2(63 downto 32),
				Q 		=> RoundKey2     (63 downto 32));	

			EncDecKeyMUX3: ENTITY work.MUX
			GENERIC Map ( size => 32)
			PORT Map ( 
				sel	=> EncDec,
				D0   	=> SelectedKey3  (63 downto 32),
				D1 	=> SelectedKeyMC3(63 downto 32),
				Q 		=> RoundKey3     (63 downto 32));	

			------
		
			RoundKey2(31 downto 0) <= SelectedKey2(31 downto 0);	
			RoundKey3(31 downto 0) <= SelectedKey3(31 downto 0);	
		END GENERATE;
	END GENERATE;
	
	-------------------------------------
	
	RoundConstant	<= FSM(7 downto 4) & '0' & FSM(2 downto 0);
	
	GenwithoutDecFSM: IF withDec = 0 GENERATE
		FSMInitial 		<= "00010001";
	END GENERATE;	

	GenwithDecFSM: IF withDec /= 0 GENERATE
		notEncDec		<= not EncDec;
		FSMInitial 		<= EncDec & "00" & notEncDec & '0' & EncDec & "01";
	END GENERATE;
	
	FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 8)
	PORT Map ( 
		sel	=> rst,
		D0   	=> FSMReg,
		D1 	=> FSMInitial,
		Q 		=> FSM);
		
	FSMUpdateInst: ENTITY work.StateUpdate
	GENERIC Map (withDec)
	PORT Map (FSM, EncDec, FSMUpdate);
			
	FSMRegInst: ENTITY work.reg
	GENERIC Map ( size => 8)
	PORT Map ( 
		clk	=> clk,
		D 		=> FSMUpdate,
		Q 		=> FSMReg);	
	
	FSMSignalsInst: ENTITY work.FSMSignals
	GENERIC Map (withDec)
	PORT Map (FSM, EncDec, notEncDec, done_internal);

	----
	
	sel_Key		<= selects(0);
	sel_Tweak	<= selects(1);
	
	selectsInitial <= EncDec & EncDec;
	
	selectsMUX: ENTITY work.MUX
	GENERIC Map ( size => 2)
	PORT Map ( 
		sel	=> rst,
		D0   	=> selectsReg,
		D1 	=> selectsInitial,
		Q 		=> selects);
		
	selectsUpdateInst: ENTITY work.selectsUpdate
	PORT Map (selects, FSM(3), EncDec, selectsNext);

	selectsRegInst: ENTITY work.reg
	GENERIC Map ( size => 2)
	PORT Map ( 
		clk	=> clk,
		D 		=> selectsNext,
		Q 		=> selectsReg);

	----------------

	Output1	<= StateRegOutput1;
	Output2	<= StateRegOutput2;
	Output3	<= StateRegOutput3;
	done		<= done_internal;	

end Behavioral;

