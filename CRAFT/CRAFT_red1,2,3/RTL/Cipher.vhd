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

-- withTweak : 0/1 (whether 64-bit Tweak is taken into account)
-- withDec   : 0/1 (whether both encryption and decryption should be realzied)

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
		MultiVariate 	: NATURAL  := 0);
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
			  EncDec			: in  STD_LOGIC := '0';  -- 0: encryption  1: decryption
           Input 			: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
			  Tweak        : in  STD_LOGIC_VECTOR ( 63 downto 0) := (others => '0');
           Output 		: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is

	constant SboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"cad3ebf789150246";

	constant LFSR4initEnc 	: integer := 1;
	constant LFSR3initEnc 	: integer := 1;

	constant LFSR4initDec 	: integer := 8;
	constant LFSR3initDec 	: integer := 5;

	--
	
	constant LFSR4EndEnc 	: integer := 4;
	constant LFSR3EndEnc 	: integer := 6;

	constant LFSR4EndDec 	: integer := 3;
	constant LFSR3EndDec 	: integer := 3;
	
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
	
	constant Distance 	 : NATURAL := GetDistance(Red_size, LFTable);

	constant Error_size   : NATURAL := Distance-1+Distance*MultiVariate;
	constant ToCheckCount : NATURAL := 5+16+20*MultiVariate;
	
	-------------------------------

	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundConstant							: STD_LOGIC_VECTOR(7  downto 0);
	signal AddRoundKeyOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal PermutationOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal MCInput 								: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput								: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundKey								: STD_LOGIC_VECTOR(63 downto 0);
	signal K0										: STD_LOGIC_VECTOR(63 downto 0);
	signal K1										: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedKey							: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedTweak							: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedTweakKey						: STD_LOGIC_VECTOR(63 downto 0);
	signal SelectedTweakKeyMC					: STD_LOGIC_VECTOR(63 downto 0);
	signal Tweak_Q									: STD_LOGIC_VECTOR(63 downto 0);
	
	signal FSMInitialEnc							: STD_LOGIC_VECTOR(6  downto 0);
	signal FSMInitialDec							: STD_LOGIC_VECTOR(6  downto 0);
	signal FSM										: STD_LOGIC_VECTOR(6  downto 0);
	signal FSMInitial								: STD_LOGIC_VECTOR(6  downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(6  downto 0);
	signal FSMReg									: STD_LOGIC_VECTOR(6  downto 0);

	-------
	
	signal Red_Input								: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegOutput					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_RoundConstant					: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_AddRoundKeyOutput				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_PermutationOutput				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCInput							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCOutput							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Feedback							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_RoundKey							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K0									: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_K1									: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedKey						: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedTweak					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedTweakKey				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SelectedTweakKeyMC				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
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
	
	signal Red_selects							: STD_LOGIC_VECTOR(Red_size*2-1 downto 0);
	signal Red_selectsReg						: STD_LOGIC_VECTOR(Red_size*2-1 downto 0);
	signal Red_selectsInitial					: STD_LOGIC_VECTOR(Red_size*2-1 downto 0);
	signal Red_selectsNext						: STD_LOGIC_VECTOR(Red_size*2-1 downto 0);
	signal Red_sel_Key							: STD_LOGIC_VECTOR(Red_size-1   downto 0);
	signal Red_sel_Tweak							: STD_LOGIC_VECTOR(Red_size-1   downto 0);
	signal Red_done								: STD_LOGIC_VECTOR(Red_size-1 downto 0);

	signal EnableSaveCiphertext				: STD_LOGIC;

	signal Error									: STD_LOGIC_VECTOR(Red_size-1   downto 0);
	signal ErrorFree								: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal ErrorFreeUpdate						: STD_LOGIC_VECTOR(Error_size-1 downto 0);

	signal SignaltoCheck							: STD_LOGIC_VECTOR(ToCheckCount*4-1 downto 0);
	signal Red_SignaltoCheck					: STD_LOGIC_VECTOR(ToCheckCount*Red_size-1 downto 0);
	signal Red_final								: STD_LOGIC_VECTOR(ToCheckCount*Red_size-1 downto 0);	

	signal OutputRegIn							: STD_LOGIC_VECTOR(63 downto 0);

	signal EncDec01								: STD_LOGIC_VECTOR( 1 downto 0);
	
begin

	InputMUX: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Feedback,
		D1 	=> Input,
		Q 		=> MCInput);

	MCInst: ENTITY work.MC
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> MCInput,
		result	=> MCOutput);
	
	AddKeyXOR1: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 4)
	PORT Map ( MCOutput(63 downto 48), RoundKey(63 downto 48), AddRoundKeyOutput(63 downto 48));

	AddKeyConstXOR: ENTITY work.XOR_3n
	GENERIC Map ( size => 4, count => 2)
	PORT Map ( MCOutput(47 downto 40), RoundKey(47 downto 40), RoundConstant, AddRoundKeyOutput(47 downto 40));

	AddKeyXOR2: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 10)
	PORT Map ( MCOutput(39 downto 0), RoundKey(39 downto 0), AddRoundKeyOutput(39 downto 0));

	StateReg: ENTITY work.reg
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		D 		=> AddRoundKeyOutput,
		Q 		=> StateRegOutput);

	PermutationInst: ENTITY work.Permutation
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> StateRegOutput,
		result	=> PermutationOutput);

	SubCellInst: ENTITY work.FMulti
	GENERIC Map ( size => 4, count => 16, Table => SboxTable)
	PORT Map (
		input 	=> PermutationOutput,
		output	=> Feedback);

	--===================================================

	Red_PlaintextInst: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> Input,
		output	=> Red_Input);
		
	Red_InputMUX: ENTITY work.MUX
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		sel	=> rst,
		D0		=> Red_Feedback,
		D1		=> Red_Input,
		Q		=> Red_MCInput);

	Red_MCInst: ENTITY work.MC
	GENERIC Map ( size => Red_size)
	PORT Map (
		state		=> Red_MCInput,
		result	=> Red_MCOutput,
		const    => LFC(Red_size-1 downto 0));

	Red_AddKeyXOR1: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( Red_MCOutput(16*Red_size-1 downto 12*Red_size), Red_RoundKey(16*Red_size-1 downto 12*Red_size), Red_AddRoundKeyOutput(16*Red_size-1 downto 12*Red_size), LFC(Red_size-1 downto 0));

	Red_AddKeyConstXOR: ENTITY work.XOR_3n
	GENERIC Map ( size => Red_size, count => 2)
	PORT Map ( Red_MCOutput(12*Red_size-1 downto 10*Red_size), Red_RoundKey(12*Red_size-1 downto 10*Red_size), Red_RoundConstant, Red_AddRoundKeyOutput(12*Red_size-1 downto 10*Red_size));

	Red_AddKeyXOR2: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 10)
	PORT Map ( Red_MCOutput(10*Red_size-1 downto 0), Red_RoundKey(10*Red_size-1 downto 0), Red_AddRoundKeyOutput(10*Red_size-1 downto 0), LFC(Red_size-1 downto 0));

	Red_StateReg: ENTITY work.reg
	GENERIC Map ( size => 16*Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_AddRoundKeyOutput,
		Q 		=> Red_StateRegOutput);

	Red_PermutationInst: ENTITY work.Permutation
	GENERIC Map ( size => Red_size)
	PORT Map (
		state		=> Red_StateRegOutput,
		result	=> Red_PermutationOutput);

	Red_SubCellInst: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => GoF(LFTable, SboxTable))
	PORT Map (
		input 	=> PermutationOutput,
		output	=> Red_Feedback);

	--===================================================

	K0 	<= Key (127 DOWNTO 64);
	K1 	<= Key (63  DOWNTO 0);

	KeyMUX: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> sel_Key,
		D0   	=> K0,
		D1 	=> K1,
		Q 		=> SelectedKey);

	GenwithoutTweak: IF withTweak = 0 GENERATE
		SelectedTweakKey <= SelectedKey;
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
			
		SelectedTweakKey <= SelectedKey XOR SelectedTweak;
	END GENERATE;
	
	-------

	GenwithoutDecKey: IF withDec = 0 GENERATE
		RoundKey		<= SelectedTweakKey;	
	END GENERATE;
	
	GenwithDecKey: IF withDec /= 0 GENERATE
		KeyMCInst: ENTITY work.MC
		GENERIC Map ( size => 4)
		PORT Map (
			state		=> SelectedTweakKey,
			result	=> SelectedTweakKeyMC);

		EncDecKeyMUX: ENTITY work.MUX
		GENERIC Map ( size => 32)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> SelectedTweakKey  (63 downto 32),
			D1 	=> SelectedTweakKeyMC(63 downto 32),
			Q 		=> RoundKey     (63 downto 32));	

		RoundKey(31 downto 0) <= SelectedTweakKey(31 downto 0);	
	END GENERATE;
		
	--===================================================

	Red_K0Inst: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> K0,
		output	=> Red_K0);
	
	Red_K1Inst: ENTITY work.FMulti
	GENERIC Map ( count => 16, size	=> Red_size, Table => LFTable)
	PORT Map (
		input		=> K1,
		output	=> Red_K1);
	
	Red_KeyMUX: ENTITY work.MUX2to1_Redn
	GENERIC Map ( 
		size1   => Red_size, 
		size2   => 16*Red_size,
		LFTable => LFTable)
	PORT Map (
		sel	=> Red_sel_Key,
		D0		=> Red_K0,
		D1		=> Red_K1,
		Q		=> Red_SelectedKey);	

	GenRedwithoutTweak: IF withTweak = 0 GENERATE
		Red_SelectedTweakKey <= Red_SelectedKey;
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
		PORT Map (Red_SelectedKey, Red_SelectedTweak, Red_SelectedTweakKey, LFC(Red_size-1 downto 0));
	END GENERATE;	
	
	--------
	
	GenRedwithoutDecKey: IF withDec = 0 GENERATE
		Red_RoundKey		<= Red_SelectedTweakKey;	
	END GENERATE;
	
	GenRedwithDecKey: IF withDec /= 0 GENERATE
		Red_KeyMCInst: ENTITY work.MC
		GENERIC Map ( size => Red_size)
		PORT Map (
			state		=> Red_SelectedTweakKey,
			result	=> Red_SelectedTweakKeyMC,
			const    => LFC(Red_size-1 downto 0));
		
		Red_EncDecKeyMUX: ENTITY work.MUX
		GENERIC Map ( size => 8*Red_size)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> Red_SelectedTweakKey  (16*Red_size-1 downto 8*Red_size),
			D1 	=> Red_SelectedTweakKeyMC(16*Red_size-1 downto 8*Red_size),
			Q 		=> Red_RoundKey          (16*Red_size-1 downto 8*Red_size));	

		Red_RoundKey(8*Red_size-1 downto 0) <= Red_SelectedTweakKey(8*Red_size-1 downto 0);
	END GENERATE;

	--===================================================
	
	RoundConstant	<= FSM(6 downto 3) & '0' & FSM(2 downto 0);
	
	FSMInitialEnc 	<= std_logic_vector(to_unsigned(LFSR4initEnc,4)) & std_logic_vector(to_unsigned(LFSR3initEnc,3));
	FSMInitialDec	<= std_logic_vector(to_unsigned(LFSR4initDec,4)) & std_logic_vector(to_unsigned(LFSR3initDec,3));
	
	GenwithoutDecFSM: IF withDec = 0 GENERATE
		FSMInitial 	<= FSMInitialEnc;
	END GENERATE;	

	GenwithDecFSM: IF withDec /= 0 GENERATE
		FSMInitialMUX: ENTITY work.MUX
		GENERIC Map ( size => 7)
		PORT Map ( 
			sel	=> EncDec,
			D0   	=> FSMInitialEnc,
			D1 	=> FSMInitialDec,
			Q 		=> FSMInitial);	
	END GENERATE;		
	
	FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 7)
	PORT Map ( 
		sel	=> rst,
		D0   	=> FSMReg,
		D1 	=> FSMInitial,
		Q 		=> FSM);
		
	FSMUpdateInst: ENTITY work.StateUpdate
	GENERIC Map (withDec)
	PORT Map (FSM, EncDec, FSMUpdate);

	FSMRegInst: ENTITY work.reg
	GENERIC Map ( size => 7)
	PORT Map ( 
		clk	=> clk,
		D 		=> FSMUpdate,
		Q 		=> FSMReg);
	
	FSMSignals_doneInst: ENTITY work.FSMSignals_done
	GENERIC Map ( LFSR4EndEnc, LFSR3EndEnc, LFSR4EndDec, LFSR3EndDec, withDec)
	PORT Map (FSM, EncDec, done_internal);	

	----

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
	PORT Map (selects, EncDec, selectsNext);

	selectsRegInst: ENTITY work.reg
	GENERIC Map ( size => 2)
	PORT Map ( 
		clk	=> clk,
		D 		=> selectsNext,
		Q 		=> selectsReg);

	--===================================================

	Red_RoundConstant	<= Red_FSM;
	
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
	PORT Map (selects, EncDec, Red_selectsNext);

	Red_selectsRegInst: ENTITY work.reg
	GENERIC Map ( size => Red_size*2)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_selectsNext,
		Q 		=> Red_selectsReg);

	--===================================================

	GENMV0:
	IF MultiVariate = 0 GENERATE
		SignaltoCheck <= "000" & done_internal & "000" & sel_Key & "000" & sel_Tweak & FSM(6 downto 3) & '0' & FSM(2 downto 0) & StateRegOutput;
		Red_final     <= Red_done & Red_sel_Key & Red_sel_Tweak & Red_FSM & Red_StateRegOutput;
	END GENERATE;
	
	GENMV1:
	IF MultiVariate = 1 GENERATE
		SignaltoCheck <= "000" & done_internal & "000" & sel_Key & "000" & sel_Tweak & FSM(6 downto 3) & '0' & FSM(2 downto 0) & StateRegOutput &
		                 "000" & selectsNext(1) & "000" & selectsNext(0) & FSMUpdate(6 downto 3) & '0' & FSMUpdate(2 downto 0) & AddRoundKeyOutput;
		Red_final     <= Red_done & Red_sel_Key & Red_sel_Tweak & Red_FSM & Red_StateRegOutput &
				           Red_selectsNext & Red_FSMUpdate & Red_AddRoundKeyOutput;
	END GENERATE;

	--------
	
	Red_ToCheckInst: ENTITY work.FMulti
	GENERIC Map ( size  => Red_size, count => ToCheckCount, Table => LFTable)
	PORT Map (
		input		=> SignaltoCheck,
		output	=> Red_SignaltoCheck);
		
	Check1: ENTITY work.Checkn
	GENERIC Map ( count => ToCheckCount, sizecount => 1, size  => Red_size)
	PORT Map ( 
		in1		=> Red_final,
		in2    	=> Red_SignaltoCheck,
		result 	=> Error);
		
	-------------------------------------
	
	GEN1 :
	FOR i IN 0 TO Error_size-1 GENERATE
		ANDInst: ENTITY work.ANDn
		Generic Map (size1 => Red_size, size2 => Error_size)
		Port Map (Error, ErrorFree, ErrorFreeUpdate(i));
	END GENERATE;

	ErrorDetectionReg: PROCESS(clk, rst, ErrorFreeUpdate)
	BEGIN
		IF RISING_EDGE(clk) THEN
			IF (rst = '1') THEN
				ErrorFree	<= (others => '1');
			ELSE
				ErrorFree 	<= ErrorFreeUpdate;
			END IF;
		END IF;
	END PROCESS;		
		
	--------------
	
	OutputMUX: ENTITY work.MUX2to1_Redn_forcheck
	GENERIC Map ( 
		size1   => Error_size,
		size2	  => 64)
	PORT Map (
		sel	=> ErrorFreeUpdate,
		D0		=> (others => '0'),
		D1		=> StateRegOutput,
		Q		=> OutputRegIn);
		
	OutputReg: ENTITY work.regER
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		rst	=> rst,
		EN		=> done_internal,
		D 		=> OutputRegIn,
		Q 		=> Output);

	done		<= done_internal;	

end Behavioral;

