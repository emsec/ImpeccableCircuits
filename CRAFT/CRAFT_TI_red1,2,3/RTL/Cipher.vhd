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
use work.functions.all;

-- withTweak      : 0/1 (whether 64-bit Tweak is taken into account)
-- withDec        : 0/1 (whether both encryption and decryption should be realzied)
-- withKeyMasking : 0/1 (whether Key should be also masked)

-- Red_size     : 1 => FL: 0110100110010110
-- Red_size     : 2 => FL: 0132231032011023
-- Red_size     : 3 => FL: 0374562165123047

-- MultiVariate : 0 => Univariate   adversary model
-- MultiVariate : 1 => Multivariate adversary model

entity Cipher is
	 Generic ( 
		withTweak 		: integer  := 0;
		withDec   		: integer  := 0;
		Red_size  		: POSITIVE := 1;
		LFC       		: STD_LOGIC_VECTOR (3  DOWNTO 0) := x"0";
	   LF        	 	: STD_LOGIC_VECTOR (63 DOWNTO 0) := x"0110100110010110";
		MultiVariate	: NATURAL := 0;
		withKeyMasking : integer := 0);
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
			  EncDec			: in  STD_LOGIC := '0';  -- 0: encryption  1: decryption
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

	constant LFSR4initEnc 	: integer := 1;
	constant LFSR3initEnc 	: integer := 1;

	constant LFSR4initDec 	: integer := 8;
	constant LFSR3initDec 	: integer := 5;

	--
	
	constant LFSR4EndEnc 	: integer := 8;
	constant LFSR3EndEnc 	: integer := 13;

	constant LFSR4EndDec 	: integer := 1;
	constant LFSR3EndDec 	: integer := 9;

	--

	constant LFTable   : STD_LOGIC_VECTOR (63 DOWNTO 0) := 
		(LF(63 downto 60) XOR LFC) &
		(LF(59 downto 56) XOR LFC) &
		(LF(55 downto 52) XOR LFC) &
		(LF(51 downto 48) XOR LFC) &
		(LF(47 downto 44) XOR LFC) &
		(LF(43 downto 40) XOR LFC) &
		(LF(39 downto 36) XOR LFC) &
		(LF(35 downto 32) XOR LFC) &
		(LF(31 downto 28) XOR LFC) &
		(LF(27 downto 24) XOR LFC) &
		(LF(23 downto 20) XOR LFC) &
		(LF(19 downto 16) XOR LFC) &
		(LF(15 downto 12) XOR LFC) &
		(LF(11 downto  8) XOR LFC) &
		(LF( 7 downto  4) XOR LFC) &
		(LF( 3 downto  0) XOR LFC);

	constant Distance 	  : NATURAL := GetDistance(Red_size, LFTable);

	constant Error_size    : NATURAL := Distance-1+Distance*MultiVariate;
	constant ToCheckCount1 : NATURAL := 5+32+36*MultiVariate;
	constant ToCheckCount2 : NATURAL := 32+32*MultiVariate;
	constant ToCheckCount3 : NATURAL := 32+32*MultiVariate;
	
	-------------------------------

	signal StateRegOutput1						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput1					: STD_LOGIC_VECTOR(63 downto 0);
	signal PermutationOutput1					: STD_LOGIC_VECTOR(63 downto 0);
	signal MCInput1								: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput1								: STD_LOGIC_VECTOR(63 downto 0);
	signal GOutput1								: STD_LOGIC_VECTOR(63 downto 0);
	signal FInput1									: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback1								: STD_LOGIC_VECTOR(63 downto 0);

	signal StateRegOutput2						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput2					: STD_LOGIC_VECTOR(63 downto 0);
	signal PermutationOutput2					: STD_LOGIC_VECTOR(63 downto 0);
	signal MCInput2								: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput2								: STD_LOGIC_VECTOR(63 downto 0);
	signal GOutput2								: STD_LOGIC_VECTOR(63 downto 0);
	signal FInput2									: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback2								: STD_LOGIC_VECTOR(63 downto 0);

	signal StateRegOutput3						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput3					: STD_LOGIC_VECTOR(63 downto 0);
	signal PermutationOutput3					: STD_LOGIC_VECTOR(63 downto 0);
	signal MCInput3								: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput3								: STD_LOGIC_VECTOR(63 downto 0);
	signal GOutput3								: STD_LOGIC_VECTOR(63 downto 0);
	signal FInput3									: STD_LOGIC_VECTOR(63 downto 0);
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
	
	signal FSMInitialEnc							: STD_LOGIC_VECTOR(7  downto 0);
	signal FSMInitialDec							: STD_LOGIC_VECTOR(7  downto 0);
	signal FSM										: STD_LOGIC_VECTOR(7  downto 0);
	signal FSMInitial								: STD_LOGIC_VECTOR(7  downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(7  downto 0);
	signal FSMReg									: STD_LOGIC_VECTOR(7  downto 0);

	-------
	
	signal Red_Input1								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegOutput1					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_AddRoundKeyOutput1				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_PermutationOutput1				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCInput1							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCOutput1							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_GOutput1							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_FInput1							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Feedback1							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);

	signal Red_Input2								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegOutput2					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_AddRoundKeyOutput2				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_PermutationOutput2				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCInput2							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCOutput2							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_GOutput2							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_FInput2							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Feedback2							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);

	signal Red_Input3								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegOutput3					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_AddRoundKeyOutput3				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_PermutationOutput3				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCInput3							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCOutput3							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_GOutput3							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_FInput3							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Feedback3							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);

	signal Red_RoundKey1							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K0_1								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K1_1								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedKey1						: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedTweakKey1				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedTweakKeyMC1			: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);

	signal Red_RoundKey2							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K0_2								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K1_2								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedKey2						: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedKeyMC2					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);

	signal Red_RoundKey3							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K0_3								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K1_3								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedKey3						: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedKeyMC3					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);

	-------
	
	signal Red_RoundConstant					: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_SelectedTweak					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Tweak								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Tweak_Q							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);

	signal Red_FSMInitialEnc					: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_FSMInitialDec					: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_FSM									: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_FSMInitial						: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_FSMUpdate							: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_FSMReg								: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);

	signal selects									: STD_LOGIC_VECTOR(1  downto 0);
	signal selectsReg								: STD_LOGIC_VECTOR(1  downto 0);
	signal selectsInitial						: STD_LOGIC_VECTOR(1  downto 0);
	signal selectsNext							: STD_LOGIC_VECTOR(1  downto 0);
	signal sel_Key									: STD_LOGIC;
	signal sel_Tweak								: STD_LOGIC;
	signal done_internal							: STD_LOGIC;
	
	signal Red_selects							: STD_LOGIC_VECTOR(Red_size*2-1  downto 0);
	signal Red_selectsReg						: STD_LOGIC_VECTOR(Red_size*2-1  downto 0);
	signal Red_selectsInitial					: STD_LOGIC_VECTOR(Red_size*2-1  downto 0);
	signal Red_selectsNext						: STD_LOGIC_VECTOR(Red_size*2-1  downto 0);
	signal Red_sel_Key							: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Red_sel_Tweak							: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Red_done								: STD_LOGIC_VECTOR(Red_size-1 downto 0);

	signal Error1									: STD_LOGIC_VECTOR(Red_size-1   downto 0);
	signal ErrorFree1								: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal ErrorFreeUpdate1						: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal SignaltoCheck1						: STD_LOGIC_VECTOR(ToCheckCount1*4-1 downto 0);
	signal Red_SignaltoCheck1					: STD_LOGIC_VECTOR(ToCheckCount1*Red_size-1 downto 0);
	signal Red_final1								: STD_LOGIC_VECTOR(ToCheckCount1*Red_size-1 downto 0);	

	signal Error2									: STD_LOGIC_VECTOR(Red_size-1   downto 0);
	signal ErrorFree2								: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal ErrorFreeUpdate2						: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal SignaltoCheck2						: STD_LOGIC_VECTOR(ToCheckCount2*4-1 downto 0);
	signal Red_SignaltoCheck2					: STD_LOGIC_VECTOR(ToCheckCount2*Red_size-1 downto 0);
	signal Red_final2								: STD_LOGIC_VECTOR(ToCheckCount2*Red_size-1 downto 0);	

	signal Error3									: STD_LOGIC_VECTOR(Red_size-1   downto 0);
	signal ErrorFree3								: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal ErrorFreeUpdate3						: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal SignaltoCheck3						: STD_LOGIC_VECTOR(ToCheckCount3*4-1 downto 0);
	signal Red_SignaltoCheck3					: STD_LOGIC_VECTOR(ToCheckCount3*Red_size-1 downto 0);
	signal Red_final3								: STD_LOGIC_VECTOR(ToCheckCount3*Red_size-1 downto 0);	

	signal ErrorFreeAll							: STD_LOGIC_VECTOR(Error_size*3-1 downto 0);

	signal OutputRegIn1							: STD_LOGIC_VECTOR(63 downto 0);
	signal OutputRegIn2							: STD_LOGIC_VECTOR(63 downto 0);
	signal OutputRegIn3							: STD_LOGIC_VECTOR(63 downto 0);
	
	signal EncDec01								: STD_LOGIC_VECTOR( 1 downto 0);
	
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

	GInst: ENTITY work.TISubCell1
	GENERIC Map ( count => 16)
	PORT Map (
		input1 	=> PermutationOutput1,
		input2 	=> PermutationOutput2,
		input3 	=> PermutationOutput3,
		output1	=> GOutput1,
		output2	=> GOutput2,
		output3	=> GOutput3);
		
	GReg1: ENTITY work.reg
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		D 		=> GOutput1,
		Q 		=> FInput1);

	GReg2: ENTITY work.reg
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		D 		=> GOutput2,
		Q 		=> FInput2);

	GReg3: ENTITY work.reg
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		D 		=> GOutput3,
		Q 		=> FInput3);
	
	FInst: ENTITY work.TISubCell2
	GENERIC Map ( count => 16)
	PORT Map (
		input1 	=> FInput1,
		input2 	=> FInput2,
		input3 	=> FInput3,
		output1	=> Feedback1,
		output2	=> Feedback2,
		output3	=> Feedback3);

	--===================================================

	Red_InputInst1: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> Input1,
		output	=> Red_Input1);
		
	Red_InputMUX1: ENTITY work.MUX
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		sel	=> rst,
		D0		=> Red_Feedback1,
		D1		=> Red_Input1,
		Q		=> Red_MCInput1);

	Red_MCInst1: ENTITY work.MC
	GENERIC Map ( size => Red_size)
	PORT Map (
		state		=> Red_MCInput1,
		result	=> Red_MCOutput1,
		const    => LFC(Red_size-1 downto 0));
		
	Red_AddKeyXOR1_1: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( Red_MCOutput1(16*Red_size-1 downto 12*Red_size), Red_RoundKey1(16*Red_size-1 downto 12*Red_size), Red_AddRoundKeyOutput1(16*Red_size-1 downto 12*Red_size), LFC(Red_size-1 downto 0));

	Red_AddKeyConstXOR1: ENTITY work.XOR_3n
	GENERIC Map ( size => Red_size, count => 2)
	PORT Map ( Red_MCOutput1(12*Red_size-1 downto 10*Red_size), Red_RoundKey1(12*Red_size-1 downto 10*Red_size), Red_RoundConstant, Red_AddRoundKeyOutput1(12*Red_size-1 downto 10*Red_size));

	Red_AddKeyXOR2_1: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 10)
	PORT Map ( Red_MCOutput1(10*Red_size-1 downto 0), Red_RoundKey1(10*Red_size-1 downto 0), Red_AddRoundKeyOutput1(10*Red_size-1 downto 0), LFC(Red_size-1 downto 0));

	Red_StateReg1: ENTITY work.reg
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_AddRoundKeyOutput1,
		Q 		=> Red_StateRegOutput1);

	--------
	
	Red_InputInst2: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> Input2,
		output	=> Red_Input2);
		
	Red_InputMUX2: ENTITY work.MUX
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		sel	=> rst,
		D0		=> Red_Feedback2,
		D1		=> Red_Input2,
		Q		=> Red_MCInput2);

	Red_MCInst2: ENTITY work.MC
	GENERIC Map ( size => Red_size)
	PORT Map (
		state		=> Red_MCInput2,
		result	=> Red_MCOutput2,
		const    => LFC(Red_size-1 downto 0));

	GenRedAddKeyMasking2: IF withKeyMasking /= 0 GENERATE
		Red_AddKeyXOR2: ENTITY work.XOR_2n
		GENERIC Map ( size => Red_size, count => 16)
		PORT Map ( Red_MCOutput2, Red_RoundKey2, Red_AddRoundKeyOutput2, LFC(Red_size-1 downto 0));
	END GENERATE;
	
	GenRednotAddKeyMasking2: IF withKeyMasking = 0 GENERATE
		Red_AddRoundKeyOutput2 <= Red_MCOutput2;
	END GENERATE;

	Red_StateReg2: ENTITY work.reg
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_AddRoundKeyOutput2,
		Q 		=> Red_StateRegOutput2);
		
	--------
	
	Red_InputInst3: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> Input3,
		output	=> Red_Input3);
		
	Red_InputMUX3: ENTITY work.MUX
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		sel	=> rst,
		D0		=> Red_Feedback3,
		D1		=> Red_Input3,
		Q		=> Red_MCInput3);

	Red_MCInst3: ENTITY work.MC
	GENERIC Map ( size => Red_size)
	PORT Map (
		state		=> Red_MCInput3,
		result	=> Red_MCOutput3,
		const    => LFC(Red_size-1 downto 0));

	GenRedAddKeyMasking3: IF withKeyMasking /= 0 GENERATE
		Red_AddKeyXOR3: ENTITY work.XOR_2n
		GENERIC Map ( size => Red_size, count => 16)
		PORT Map ( Red_MCOutput3, Red_RoundKey3, Red_AddRoundKeyOutput3, LFC(Red_size-1 downto 0));
	END GENERATE;
	
	GenRednotAddKeyMasking3: IF withKeyMasking = 0 GENERATE
		Red_AddRoundKeyOutput3 <= Red_MCOutput3;
	END GENERATE;

	Red_StateReg3: ENTITY work.reg
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_AddRoundKeyOutput3,
		Q 		=> Red_StateRegOutput3);

	--------	
		
	Red_GInst: ENTITY work.TISubCell1
	GENERIC Map ( LFTable, size => Red_size, count => 16)
	PORT Map (
		input1 	=> PermutationOutput1,
		input2 	=> PermutationOutput2,
		input3 	=> PermutationOutput3,
		output1	=> Red_GOutput1,
		output2	=> Red_GOutput2,
		output3	=> Red_GOutput3);
		
	Red_GReg1: ENTITY work.reg
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_GOutput1,
		Q 		=> Red_FInput1);

	Red_GReg2: ENTITY work.reg
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_GOutput2,
		Q 		=> Red_FInput2);

	Red_GReg3: ENTITY work.reg
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_GOutput3,
		Q 		=> Red_FInput3);
	
	Red_FInst: ENTITY work.TISubCell2
	GENERIC Map ( LFTable, size => Red_size, count => 16)
	PORT Map (
		input1 	=> FInput1,
		input2 	=> FInput2,
		input3 	=> FInput3,
		output1	=> Red_Feedback1,
		output2	=> Red_Feedback2,
		output3	=> Red_Feedback3);
		
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
			
		AddTweak: ENTITY work.XOR_2n
		GENERIC Map (size => 4, count => 16)
		PORT Map (SelectedKey1, SelectedTweak, SelectedTweakKey1);		
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
		
	--===================================================

	Red_K0Inst1: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> K0_1,
		output	=> Red_K0_1);
	
	Red_K1Inst1: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> K1_1,
		output	=> Red_K1_1);
	
	Red_KeyMUX1: ENTITY work.MUX2to1_Redn
	GENERIC Map ( 
		size1   => Red_size, 
		size2   => 16*Red_size,
		LFTable => LFTable)
	PORT Map (
		sel	=> Red_sel_Key,
		D0		=> Red_K0_1,
		D1		=> Red_K1_1,
		Q		=> Red_SelectedKey1);	

	GenRedwithoutTweak: IF withTweak = 0 GENERATE
		Red_SelectedTweakKey1 <= Red_SelectedKey1;
	END GENERATE;

	GenRedwithTweak: IF withTweak /= 0 GENERATE
		Red_TweakInst: ENTITY work.FMulti
		GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
		PORT Map (
			input		=> Tweak,
			output	=> Red_Tweak);

		Red_Tweak_QInst: ENTITY work.TweakPermutation 
		GENERIC Map (size => Red_size)
		PORT Map (Red_Tweak, Red_Tweak_Q);

		Red_TweakMUX: ENTITY work.MUX2to1_Redn
		GENERIC Map ( 
			size1   => Red_size, 
			size2   => 16*Red_size,
			LFTable => LFTable)
		PORT Map (
			sel	=> Red_sel_Tweak,
			D0		=> Red_Tweak,
			D1		=> Red_Tweak_Q,
			Q		=> Red_SelectedTweak);	

		Red_AddTweak0: ENTITY work.XOR_2n
		GENERIC Map (size => Red_size, count => 16)
		PORT Map (Red_SelectedKey1, Red_SelectedTweak, Red_SelectedTweakKey1, LFC(Red_size-1 downto 0));
	END GENERATE;

	--------
	
	GenRedKeyMasking: IF withKeyMasking /= 0 GENERATE
		Red_K0Inst2: ENTITY work.FMulti
		GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
		PORT Map (
			input		=> K0_2,
			output	=> Red_K0_2);
		
		Red_K1Inst2: ENTITY work.FMulti
		GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
		PORT Map (
			input		=> K1_2,
			output	=> Red_K1_2);
		
		---

		Red_K0Inst3: ENTITY work.FMulti
		GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
		PORT Map (
			input		=> K0_3,
			output	=> Red_K0_3);
		
		Red_K1Inst3: ENTITY work.FMulti
		GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
		PORT Map (
			input		=> K1_3,
			output	=> Red_K1_3);

		---
		
		Red_KeyMUX2: ENTITY work.MUX2to1_Redn
		GENERIC Map ( 
			size1   => Red_size, 
			size2   => 16*Red_size,
			LFTable => LFTable)
		PORT Map (
			sel	=> Red_sel_Key,
			D0		=> Red_K0_2,
			D1		=> Red_K1_2,
			Q		=> Red_SelectedKey2);	

		Red_KeyMUX3: ENTITY work.MUX2to1_Redn
		GENERIC Map ( 
			size1   => Red_size, 
			size2   => 16*Red_size,
			LFTable => LFTable)
		PORT Map (
			sel	=> Red_sel_Key,
			D0		=> Red_K0_3,
			D1		=> Red_K1_3,
			Q		=> Red_SelectedKey3);	

	END GENERATE;		

	-------
	
	GenRedwithoutDecKey: IF withDec = 0 GENERATE
		Red_RoundKey1	<= Red_SelectedTweakKey1;	

		Red_GenKeyMasking: IF withKeyMasking /= 0 GENERATE
			Red_RoundKey2	<= Red_SelectedKey2;	
			Red_RoundKey3	<= Red_SelectedKey3;	
		END GENERATE;	
	END GENERATE;
	
	GenRedwithDecKey: IF withDec /= 0 GENERATE
		Red_KeyMCInst1: ENTITY work.MC
		GENERIC Map ( size => Red_size)
		PORT Map (
			state		=> Red_SelectedTweakKey1,
			result	=> Red_SelectedTweakKeyMC1,
			const    => LFC(Red_size-1 downto 0));

		Red_EncDecKeyMUX1: ENTITY work.MUX
		GENERIC Map ( size => 8*Red_size)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> Red_SelectedTweakKey1  (16*Red_size-1 downto 8*Red_size),
			D1 	=> Red_SelectedTweakKeyMC1(16*Red_size-1 downto 8*Red_size),
			Q 		=> Red_RoundKey1          (16*Red_size-1 downto 8*Red_size));

		Red_RoundKey1(8*Red_size-1 downto 0) <= Red_SelectedTweakKey1(8*Red_size-1 downto 0);	
		
		--------

		GenRedKeyMasking: IF withKeyMasking /= 0 GENERATE
			Red_KeyMCInst2: ENTITY work.MC
			GENERIC Map ( size => Red_size)
			PORT Map (
				state		=> Red_SelectedKey2,
				result	=> Red_SelectedKeyMC2,
				const    => LFC(Red_size-1 downto 0));

			Red_KeyMCInst3: ENTITY work.MC
			GENERIC Map ( size => Red_size)
			PORT Map (
				state		=> Red_SelectedKey3,
				result	=> Red_SelectedKeyMC3,
				const    => LFC(Red_size-1 downto 0));
			
			----			

			Red_EncDecKeyMUX2: ENTITY work.MUX
			GENERIC Map ( size => 8*Red_size)
			PORT Map ( 
				sel	=> EncDec,
				D0   	=> Red_SelectedKey2  (16*Red_size-1 downto 8*Red_size),
				D1 	=> Red_SelectedKeyMC2(16*Red_size-1 downto 8*Red_size),
				Q 		=> Red_RoundKey2     (16*Red_size-1 downto 8*Red_size));	

			Red_EncDecKeyMUX3: ENTITY work.MUX
			GENERIC Map ( size => 8*Red_size)
			PORT Map ( 
				sel	=> EncDec,
				D0   	=> Red_SelectedKey3  (16*Red_size-1 downto 8*Red_size),
				D1 	=> Red_SelectedKeyMC3(16*Red_size-1 downto 8*Red_size),
				Q 		=> Red_RoundKey3     (16*Red_size-1 downto 8*Red_size));	

			------
		
			Red_RoundKey2(8*Red_size-1 downto 0) <= Red_SelectedKey2(8*Red_size-1 downto 0);	
			Red_RoundKey3(8*Red_size-1 downto 0) <= Red_SelectedKey3(8*Red_size-1 downto 0);	
		END GENERATE;
	END GENERATE;

	--===================================================
	
	RoundConstant	<= FSM;
	
	FSMInitialEnc 	<= std_logic_vector(to_unsigned(LFSR4initEnc,4)) & std_logic_vector(to_unsigned(LFSR3initEnc,4));
	FSMInitialDec	<= std_logic_vector(to_unsigned(LFSR4initDec,4)) & std_logic_vector(to_unsigned(LFSR3initDec,4));
	
	GenwithoutDecFSM: IF withDec = 0 GENERATE
		FSMInitial 	<= FSMInitialEnc;
	END GENERATE;	

	GenwithDecFSM: IF withDec /= 0 GENERATE
		FSMInitialMUX: ENTITY work.MUX
		GENERIC Map ( size => 8)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> FSMInitialEnc,
			D1 	=> FSMInitialDec,
			Q 		=> FSMInitial);	
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
	
	FSMSignals_doneInst: ENTITY work.FSMSignals_done
	GENERIC Map ( LFSR4EndEnc, LFSR3EndEnc, LFSR4EndDec, LFSR3EndDec, withDec)
	PORT Map (FSM, EncDec, done_internal);	

	sel_Key		<= selects(0);
	sel_Tweak	<= selects(1);
	
	GenwithoutDecselects: IF withDec = 0 GENERATE
		selectsInitial <= "00";
	END GENERATE;
	
	GenwithDecselects: IF withDec /= 0 GENERATE
		selectsInitial <= EncDec & EncDec;
	END GENERATE;
	
	selectsMUX: ENTITY work.MUX
	GENERIC Map ( size => 2)
	PORT Map ( 
		sel	=> rst,
		D0   	=> selectsReg,
		D1 	=> selectsInitial,
		Q 		=> selects);

	selectsUpdateInst: ENTITY work.selectsUpdate
	GENERIC Map (withDec)
	PORT Map (selects, FSM(3), EncDec, selectsNext);

	selectsRegInst: ENTITY work.reg
	GENERIC Map ( size => 2)
	PORT Map ( 
		clk	=> clk,
		D 		=> selectsNext,
		Q 		=> selectsReg);

	--===================================================

	Red_RoundConstant		<= Red_FSM;
	
	Red_FSMInitialEnc 	<= LFTable(59+Red_size-LFSR4initEnc*4 downto 60-LFSR4initEnc*4) & LFTable(59+Red_size-LFSR3initEnc*4 downto 60-LFSR3initEnc*4);
	Red_FSMInitialDec		<= LFTable(59+Red_size-LFSR4initDec*4 downto 60-LFSR4initDec*4) & LFTable(59+Red_size-LFSR3initDec*4 downto 60-LFSR3initDec*4);
	
	GenRedwithoutDecFSM: IF withDec = 0 GENERATE
		Red_FSMInitial 	<= Red_FSMInitialEnc;
	END GENERATE;	

	GenRedwithDecFSM: IF withDec /= 0 GENERATE	
		Red_FSMInitialMUX: ENTITY work.MUX
		GENERIC Map ( size => 2*Red_size)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> Red_FSMInitialEnc,
			D1 	=> Red_FSMInitialDec,
			Q 		=> Red_FSMInitial);	
	END GENERATE;	
	
	Red_FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 2*Red_size)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_FSMReg,
		D1 	=> Red_FSMInitial,
		Q 		=> Red_FSM);
		
	Red_FSMUpdateInst: ENTITY work.Red_StateUpdate
	GENERIC Map (Red_size, LFTable , withDec)
	PORT Map (FSM, EncDec, Red_FSMUpdate);
	
	Red_FSMRegInst: ENTITY work.reg
	GENERIC Map ( size => 2*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_FSMUpdate,
		Q 		=> Red_FSMReg);

	Red_FSMSignals_doneInst: ENTITY work.Red_FSMSignals_done
	GENERIC Map (LFSR4EndEnc, LFSR3EndEnc, LFSR4EndDec, LFSR3EndDec, Red_size, LFTable, withDec)
	PORT Map (FSM, EncDec, Red_done);

	----

	Red_sel_Key		<= Red_selects(Red_size-1   downto 0);
	Red_sel_Tweak	<= Red_selects(Red_size*2-1 downto Red_size);

	Red_GenwithoutDecselects: IF withDec = 0 GENERATE
		Red_selectsInitial <= LFTable(60+Red_size-1 downto 60) & LFTable(60+Red_size-1 downto 60);
	END GENERATE;
	
	EncDec01 <= '0' & EncDec;
	
	Red_GenwithDecselects: IF withDec /= 0 GENERATE
		selProcess: Process (EncDec01)
		begin
			Red_selectsInitial <= LFTable(60-to_integer(unsigned(EncDec01))*4+Red_size-1 downto 60-to_integer(unsigned(EncDec01))*4)  &
										 LFTable(60-to_integer(unsigned(EncDec01))*4+Red_size-1 downto 60-to_integer(unsigned(EncDec01))*4);
		end process;	
	END GENERATE;
	
	Red_selectsMUX: ENTITY work.MUX
	GENERIC Map ( size => Red_size*2)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_selectsReg,
		D1 	=> Red_selectsInitial,
		Q 		=> Red_selects);
		
	Red_selectsUpdateInst: ENTITY work.Red_selectsUpdate
	GENERIC Map (Red_size, LFTable, withDec)
	PORT Map (selects, FSM(3), EncDec, Red_selectsNext);

	Red_selectsRegInst: ENTITY work.reg
	GENERIC Map ( size => Red_size*2)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_selectsNext,
		Q 		=> Red_selectsReg);

	--===================================================

	GENMV0:
	IF MultiVariate = 0 GENERATE
		SignaltoCheck1 <= "000" & done_internal & "000" & sel_Key & "000" & sel_Tweak & FSM & StateRegOutput1 & FInput1;
		SignaltoCheck2 <= StateRegOutput2 & FInput2;
		SignaltoCheck3 <= StateRegOutput3 & FInput3;

		Red_final1     <= Red_done & Red_sel_Key & Red_sel_Tweak & Red_FSM & Red_StateRegOutput1 & Red_FInput1;
		Red_final2     <= Red_StateRegOutput2 & Red_FInput2;
		Red_final3     <= Red_StateRegOutput3 & Red_FInput3;
	END GENERATE;
	
	GENMV1:
	IF MultiVariate = 1 GENERATE
		SignaltoCheck1 <= "000" & done_internal & "000" & sel_Key & "000" & sel_Tweak & FSM & StateRegOutput1  & FInput1 &
								"000" & selectsNext(1) & "000" & selectsNext(0) & FSMUpdate & AddRoundKeyOutput1 & GOutput1;
		SignaltoCheck2 <= StateRegOutput2 & FInput2 & AddRoundKeyOutput2 & GOutput2;
		SignaltoCheck3 <= StateRegOutput3 & FInput3 & AddRoundKeyOutput3 & GOutput3;

		Red_final1     <= Red_done & Red_sel_Key & Red_sel_Tweak & Red_FSM & Red_StateRegOutput1 & Red_FInput1 &
				            Red_selectsNext & Red_FSMUpdate & Red_AddRoundKeyOutput1 & Red_GOutput1;
		Red_final2     <= Red_StateRegOutput2 & Red_FInput2 & Red_AddRoundKeyOutput2 & Red_GOutput2;
		Red_final3     <= Red_StateRegOutput3 & Red_FInput3 & Red_AddRoundKeyOutput3 & Red_GOutput3;
	END GENERATE;

	--------
	
	Red_ToCheckInst1: ENTITY work.FMulti
		GENERIC Map ( size  => Red_size, count => ToCheckCount1, Table => LFTable)
		PORT Map (
			input		=> SignaltoCheck1,
			output	=> Red_SignaltoCheck1);
		
	Red_ToCheckInst2: ENTITY work.FMulti
		GENERIC Map ( size  => Red_size, count => ToCheckCount2, Table => LFTable)
		PORT Map (
			input		=> SignaltoCheck2,
			output	=> Red_SignaltoCheck2);

	Red_ToCheckInst3: ENTITY work.FMulti
		GENERIC Map ( size  => Red_size, count => ToCheckCount3, Table => LFTable)
		PORT Map (
			input		=> SignaltoCheck3,
			output	=> Red_SignaltoCheck3);

	-------
		
	Check1: ENTITY work.Checkn
		GENERIC Map ( count => ToCheckCount1, sizecount => 1, size  => Red_size)
		PORT Map ( 
			in1		=> Red_final1,
			in2    	=> Red_SignaltoCheck1,
			result 	=> Error1);
		
	Check2: ENTITY work.Checkn
		GENERIC Map ( count => ToCheckCount2, sizecount => 1, size  => Red_size)
		PORT Map ( 
			in1		=> Red_final2,
			in2    	=> Red_SignaltoCheck2,
			result 	=> Error2);
		
	Check3: ENTITY work.Checkn
		GENERIC Map ( count => ToCheckCount3, sizecount => 1, size  => Red_size)
		PORT Map ( 
			in1		=> Red_final3,
			in2    	=> Red_SignaltoCheck3,
			result 	=> Error3);
		
	--------
	
	GEN1 :
	FOR i IN 0 TO Error_size-1 GENERATE
		ANDInst1: ENTITY work.ANDn
		Generic Map (size1 => Red_size, size2 => Error_size*3)
		Port Map (Error1, ErrorFreeAll, ErrorFreeUpdate1(i));

		ANDInst2: ENTITY work.ANDn
		Generic Map (size1 => Red_size, size2 => Error_size*3)
		Port Map (Error2, ErrorFreeAll, ErrorFreeUpdate2(i));

		ANDInst3: ENTITY work.ANDn
		Generic Map (size1 => Red_size, size2 => Error_size*3)
		Port Map (Error3, ErrorFreeAll, ErrorFreeUpdate3(i));
	END GENERATE;

	ErrorDetectionReg: PROCESS(clk, rst, ErrorFreeUpdate1, ErrorFreeUpdate2, ErrorFreeUpdate3)
	BEGIN
		IF RISING_EDGE(clk) THEN
			IF (rst = '1') THEN
				ErrorFree1	<= (others => '1');
				ErrorFree2	<= (others => '1');
				ErrorFree3	<= (others => '1');
			ELSE
				ErrorFree1	<= ErrorFreeUpdate1;
				ErrorFree2	<= ErrorFreeUpdate2;
				ErrorFree3	<= ErrorFreeUpdate3;
			END IF;
		END IF;
	END PROCESS;		
	
	ErrorFreeAll <= ErrorFree1 & ErrorFree2 & ErrorFree3;
	
	--------------
	
	OutputMUX1: ENTITY work.MUX2to1_Redn_forcheck
	GENERIC Map ( 
		size1   => Error_size,
		size2	  => 64)
	PORT Map (
		sel	=> ErrorFreeUpdate1,
		D0		=> (others => '0'),
		D1		=> StateRegOutput1,
		Q		=> OutputRegIn1);
		
	OutputMUX2: ENTITY work.MUX2to1_Redn_forcheck
	GENERIC Map ( 
		size1   => Error_size,
		size2	  => 64)
	PORT Map (
		sel	=> ErrorFreeUpdate2,
		D0		=> (others => '0'),
		D1		=> StateRegOutput2,
		Q		=> OutputRegIn2);

	OutputMUX3: ENTITY work.MUX2to1_Redn_forcheck
	GENERIC Map ( 
		size1   => Error_size,
		size2	  => 64)
	PORT Map (
		sel	=> ErrorFreeUpdate3,
		D0		=> (others => '0'),
		D1		=> StateRegOutput3,
		Q		=> OutputRegIn3);		

	OutputReg1: ENTITY work.regER
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		rst	=> rst,
		EN		=> done_internal,
		D 		=> OutputRegIn1,
		Q 		=> Output1);

	OutputReg2: ENTITY work.regER
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		rst	=> rst,
		EN		=> done_internal,
		D 		=> OutputRegIn2,
		Q 		=> Output2);

	OutputReg3: ENTITY work.regER
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		rst	=> rst,
		EN		=> done_internal,
		D 		=> OutputRegIn3,
		Q 		=> Output3);

	done		<= done_internal;	

end Behavioral;

