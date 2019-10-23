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

-- MultiVariate : 0 => Univariate   adversary model
-- MultiVariate : 1 => Multivariate adversary model

entity Piccolo128Enc is
	 Generic ( LFC       	: STD_LOGIC_VECTOR (3  DOWNTO 0) := x"0";
	           LF        	: STD_LOGIC_VECTOR (63 DOWNTO 0) := x"0ED3B56879A4C21F";
		   MultiVariate : NATURAL  := 0);
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           Plaintext 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
           Ciphertext 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);
end Piccolo128Enc;

architecture Behavioral of Piccolo128Enc is

	constant SboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"e4b238091a7f6c5d";

	constant ConstLeft : STD_LOGIC_VECTOR (15 DOWNTO 0) := x"6547";
	constant ConstRight: STD_LOGIC_VECTOR (15 DOWNTO 0) := x"a98b";
	
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
	
	constant LFInvTable   : STD_LOGIC_VECTOR (63 DOWNTO 0) := MakeInv(LFTable);
	constant RedSboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0) := MakeFRed(SboxTable, LFTable, LFInvTable);
	
	constant Red_size : NATURAL := 4;
	
	constant ToCheckCount : NATURAL := 9+16+8+18*MultiVariate;

	constant Distance 	 : NATURAL := GetDistance(Red_size, LFTable);
	constant Error_size   : NATURAL := Distance-1+Distance*MultiVariate;

	constant Red_ConstLeft : STD_LOGIC_VECTOR (4*Red_size-1 DOWNTO 0) := LFTable((15-6)*4+Red_size-1 downto (15-6)*4) & 
																								LFTable((15-5)*4+Red_size-1 downto (15-5)*4) & 
																								LFTable((15-4)*4+Red_size-1 downto (15-4)*4) & 
																								LFTable((15-7)*4+Red_size-1 downto (15-7)*4);
	
	constant Red_ConstRight: STD_LOGIC_VECTOR (4*Red_size-1 DOWNTO 0) := LFTable((15-10)*4+Red_size-1 downto (15-10)*4) & 
																								LFTable((15-9)*4+Red_size-1  downto (15-9)*4)  & 
																								LFTable((15-8)*4+Red_size-1  downto (15-8)*4)  & 
																								LFTable((15-11)*4+Red_size-1 downto (15-11)*4);
	
	-------------------------------

	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddWhiteningKeyOutput				: STD_LOGIC_VECTOR(63 downto 0);
	signal MixColumnsLeftOutput				: STD_LOGIC_VECTOR(15 downto 0);
	signal SubCellLeft2Output					: STD_LOGIC_VECTOR(15 downto 0);
	signal MixColumnsRightOutput				: STD_LOGIC_VECTOR(15 downto 0);
	signal SubCellRight2Output					: STD_LOGIC_VECTOR(15 downto 0);
	signal AddRoundKeyOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal PermutationOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);

	signal WhiteningKey0							: STD_LOGIC_VECTOR(31 downto 0);
	signal WhiteningKey1							: STD_LOGIC_VECTOR(31 downto 0);
	signal WhiteningKey							: STD_LOGIC_VECTOR(31 downto 0);
	signal WhiteningKeyLeft						: STD_LOGIC_VECTOR(15 downto 0);
	signal WhiteningKeyRight					: STD_LOGIC_VECTOR(15 downto 0);
	signal RoundConstLeft						: STD_LOGIC_VECTOR(15 downto 0);
	signal RoundConstRight						: STD_LOGIC_VECTOR(15 downto 0);
	signal K0										: STD_LOGIC_VECTOR(15 downto 0);
	signal K1										: STD_LOGIC_VECTOR(15 downto 0);
	signal K2										: STD_LOGIC_VECTOR(15 downto 0);
	signal K3										: STD_LOGIC_VECTOR(15 downto 0);
	signal K4										: STD_LOGIC_VECTOR(15 downto 0);
	signal K5										: STD_LOGIC_VECTOR(15 downto 0);
	signal K6										: STD_LOGIC_VECTOR(15 downto 0);
	signal K7										: STD_LOGIC_VECTOR(15 downto 0);
	signal RoundKeyLeft							: STD_LOGIC_VECTOR(15 downto 0);
	signal RoundKeyRight							: STD_LOGIC_VECTOR(15 downto 0);
	
	signal FSM										: STD_LOGIC_VECTOR(4   downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(4   downto 0);
	signal FSMSelected							: STD_LOGIC_VECTOR(4   downto 0);
	signal WhiteningKeySel0						: STD_LOGIC;
	signal WhiteningKeySel1						: STD_LOGIC;
	signal KeySelLeft0							: STD_LOGIC;
	signal KeySelLeft1							: STD_LOGIC;
	signal KeySelRight0							: STD_LOGIC;
	signal KeySelRight1							: STD_LOGIC;
	signal last										: STD_LOGIC;
	signal done_internal							: STD_LOGIC;

	-------
	
	signal Red_Plaintext							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegInput 					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegOutput					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_AddWhiteningKeyOutput			: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MixColumnsLeftOutput			: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_SubCellLeft2Output				: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_MixColumnsRightOutput			: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_SubCellRight2Output			: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_AddRoundKeyOutput				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_PermutationOutput				: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Feedback							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	
	signal Red_Key									: STD_LOGIC_VECTOR(32*Red_size-1 downto 0);
	signal Red_WhiteningKey0					: STD_LOGIC_VECTOR( 8*Red_size-1 downto 0);
	signal Red_WhiteningKey1					: STD_LOGIC_VECTOR( 8*Red_size-1 downto 0);
	signal Red_WhiteningKey						: STD_LOGIC_VECTOR( 8*Red_size-1 downto 0);
	signal Red_WhiteningKeyLeft				: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_WhiteningKeyRight				: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_RoundConstLeft					: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_RoundConstRight					: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_K0									: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_K1									: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_K2									: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_K3									: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_K4									: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_K5									: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_K6									: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_K7									: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_RoundKeyLeft						: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);
	signal Red_RoundKeyRight					: STD_LOGIC_VECTOR( 4*Red_size-1 downto 0);	

	signal Red_FSM									: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_FSMStart							: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_FSMUpdate							: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_FSMSelected						: STD_LOGIC_VECTOR( 2*Red_size-1 downto 0);
	signal Red_WhiteningKeySel0				: STD_LOGIC_VECTOR(   Red_size-1 downto 0);
	signal Red_WhiteningKeySel1				: STD_LOGIC_VECTOR(   Red_size-1 downto 0);
	signal Red_KeySelLeft0						: STD_LOGIC_VECTOR(   Red_size-1 downto 0);
	signal Red_KeySelLeft1						: STD_LOGIC_VECTOR(   Red_size-1 downto 0);
	signal Red_KeySelRight0						: STD_LOGIC_VECTOR(   Red_size-1 downto 0);
	signal Red_KeySelRight1						: STD_LOGIC_VECTOR(   Red_size-1 downto 0);
	signal Red_last								: STD_LOGIC_VECTOR(   Red_size-1 downto 0);
	signal Red_done								: STD_LOGIC_VECTOR(   Red_size-1 downto 0);

	signal Error									: STD_LOGIC_VECTOR(Red_size-1   downto 0);
	signal ErrorFree								: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal ErrorFreeUpdate						: STD_LOGIC_VECTOR(Error_size-1 downto 0);

	signal SignaltoCheck							: STD_LOGIC_VECTOR(ToCheckCount*4-1        downto 0);
	signal Red_SignaltoCheck					: STD_LOGIC_VECTOR(ToCheckCount*Red_size-1 downto 0);
	signal Red_final								: STD_LOGIC_VECTOR(ToCheckCount*Red_size-1 downto 0);

	signal CiphertextRegIn						: STD_LOGIC_VECTOR(63 downto 0);

begin

	PlaintextMUX: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Feedback,
		D1 	=> Plaintext,
		Q 		=> StateRegInput);

	StateReg: ENTITY work.reg
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		D 		=> StateRegInput,
		Q 		=> StateRegOutput);

	------

	AddWhiteningKeyLeftXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 4)
	PORT Map ( StateRegOutput(16*4-1 downto 12*4), WhiteningKeyLeft, AddWhiteningKeyOutput(16*4-1 downto 12*4));

	AddWhiteningKeyOutput(12*4-1 downto 8*4) 	<= StateRegOutput(12*4-1 downto 8*4);
	
	AddWhiteningKeyRightXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 4)
	PORT Map ( StateRegOutput(8*4-1 downto 4*4), WhiteningKeyRight, AddWhiteningKeyOutput(8*4-1 downto 4*4));

	AddWhiteningKeyOutput(4*4-1 downto 0) 	<= StateRegOutput(4*4-1 downto 0);

	------

	MCLeftInst: ENTITY work.MC
	GENERIC Map (Table => SboxTable)
	PORT Map (
		state		=> AddWhiteningKeyOutput(16*4-1 downto 12*4),
		result	=> MixColumnsLeftOutput);

	SubCellLeft2Inst: ENTITY work.FMulti
	GENERIC Map ( count => 4, Table => SboxTable)
	PORT Map (
		input 	=> MixColumnsLeftOutput,
		output	=> SubCellLeft2Output);

	--
	
	MCRightInst: ENTITY work.MC
	GENERIC Map (Table => SboxTable)
	PORT Map (
		state		=> AddWhiteningKeyOutput(8*4-1 downto 4*4),
		result	=> MixColumnsRightOutput);

	SubCellRight2Inst: ENTITY work.FMulti
	GENERIC Map ( count => 4, Table => SboxTable)
	PORT Map (
		input 	=> MixColumnsRightOutput,
		output	=> SubCellRight2Output);	

	------

	AddRoundKeyOutput(16*4-1 downto 12*4)	<= AddWhiteningKeyOutput(16*4-1 downto 12*4);

	AddKeyLeftXOR: ENTITY work.XOR_5n
	GENERIC Map ( size => 4, count => 4)
	PORT Map ( SubCellLeft2Output, AddWhiteningKeyOutput(12*4-1 downto 8*4), RoundKeyLeft, RoundConstLeft, ConstLeft, AddRoundKeyOutput(12*4-1 downto 8*4));

	AddRoundKeyOutput(8*4-1 downto 4*4)	<= AddWhiteningKeyOutput(8*4-1 downto 4*4);

	AddKeyRightXOR: ENTITY work.XOR_5n
	GENERIC Map ( size => 4, count => 4)
	PORT Map ( SubCellRight2Output, AddWhiteningKeyOutput(4*4-1 downto 0), RoundKeyRight, RoundConstRight, ConstRight, AddRoundKeyOutput(4*4-1 downto 0));

	PermInst: ENTITY work.Permutation
	GENERIC Map (size => 4)
	PORT Map (
		data_in	=> AddRoundKeyOutput,
		data_out	=> PermutationOutput);
		
	PermutationMUX: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> last,
		D0   	=> PermutationOutput,
		D1 	=> AddRoundKeyOutput,
		Q 		=> Feedback);		
				
	-----------------------------------------------------

	WhiteningKey0		<= Key(32*4-1 downto 30*4) & 
								Key(26*4-1 downto 24*4) &
								Key(28*4-1 downto 26*4) & 
								Key(30*4-1 downto 28*4);
	
	WhiteningKey1		<= Key(16*4-1 downto 14*4) & 
								Key( 2*4-1 downto    0) &
								Key( 4*4-1 downto  2*4) & 
								Key(14*4-1 downto 12*4);

	WhiteningKey1MUXInst: ENTITY work.WhiteningKeyMUX
	GENERIC Map ( size => 4)
	PORT Map ( 
		sel0	=> WhiteningKeySel0,
		sel1	=> WhiteningKeySel1,
		D0   	=> WhiteningKey0,
		D1   	=> WhiteningKey1,
		Q 		=> WhiteningKey);

	WhiteningKeyLeft 	<= WhiteningKey(8*4-1 downto 4*4);
	WhiteningKeyRight <= WhiteningKey(4*4-1 downto   0);

	---

	K0	<= Key(32*4-1 downto 28*4);
	K1	<= Key(28*4-1 downto 24*4);
	K2	<= Key(24*4-1 downto 20*4);
	K3	<= Key(20*4-1 downto 16*4);
	K4	<= Key(16*4-1 downto 12*4);
	K5	<= Key(12*4-1 downto  8*4);
	K6	<= Key( 8*4-1 downto  4*4);
	K7	<= Key( 4*4-1 downto    0);

	KeyMUXLeftInst: ENTITY work.KeyMUX
	GENERIC Map ( size => 4)
	PORT Map ( 
		sel0	=> KeySelLeft0,
		sel1	=> KeySelLeft1,
		D0   	=> K0,
		D1   	=> K2,
		D2   	=> K4,
		D3   	=> K6,
		Q 		=> RoundKeyLeft);

	KeyMUXRightInst: ENTITY work.KeyMUX
	GENERIC Map ( size => 4)
	PORT Map ( 
		sel0	=> KeySelRight0,
		sel1	=> KeySelRight1,
		D0   	=> K1,
		D1   	=> K3,
		D2   	=> K5,
		D3   	=> K7,
		Q 		=> RoundKeyRight);

	-------------------------------------
	
	FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 5)
	PORT Map ( 
		sel	=> rst,
		D0   	=> FSMUpdate,
		D1 	=> "00001",
		Q 		=> FSMSelected);
		
	FSMReg: ENTITY work.reg
	GENERIC Map ( size => 5)
	PORT Map ( 
		clk	=> clk,
		D 		=> FSMSelected,
		Q 		=> FSM);
		
	FSMUpdateInst: ENTITY work.StateUpdate
	PORT Map (FSM, FSMUpdate);
	
	FSMSignalsInst: ENTITY work.FSMSignals
	PORT Map (FSM, last, done_internal, WhiteningKeySel0, WhiteningKeySel1, KeySelLeft0, KeySelLeft1, KeySelRight0, KeySelRight1);

	RoundConstLeft		<=       FSM(4 downto 0) & "00000" & FSM(4 downto 0) & '0';
	RoundConstRight	<= '0' & FSM(4 downto 0) & "00000" & FSM(4 downto 0);

	--====================================================================================================

	Red_PlaintextInst: ENTITY work.FMulti
	GENERIC Map ( count => 16, Table => LFTable)
	PORT Map (
		input		=> Plaintext,
		output	=> Red_Plaintext);

	Red_PlaintextMUX: ENTITY work.MUX
	GENERIC Map ( size => Red_size*16)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_Feedback,
		D1 	=> Red_Plaintext,
		Q 		=> Red_StateRegInput);

	Red_StateReg: ENTITY work.reg
	GENERIC Map ( size => Red_size*16)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_StateRegInput,
		Q 		=> Red_StateRegOutput);

	------

	Red_AddWhiteningKeyLeftXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( Red_StateRegOutput(16*Red_size-1 downto 12*Red_size), Red_WhiteningKeyLeft, Red_AddWhiteningKeyOutput(16*Red_size-1 downto 12*Red_size), LFC(Red_size-1 downto 0));

	Red_AddWhiteningKeyOutput(12*Red_size-1 downto 8*Red_size) 	<= Red_StateRegOutput(12*Red_size-1 downto 8*Red_size);
	
	Red_AddWhiteningKeyRightXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( Red_StateRegOutput(8*Red_size-1 downto 4*4), Red_WhiteningKeyRight, Red_AddWhiteningKeyOutput(8*Red_size-1 downto 4*4), LFC(Red_size-1 downto 0));

	Red_AddWhiteningKeyOutput(4*Red_size-1 downto 0) 	<= Red_StateRegOutput(4*Red_size-1 downto 0);

	------

	Red_MCLeftInst: ENTITY work.Red_MC
	GENERIC Map ( Red_size, RedSboxTable, LFTable, LFInvTable, LFC)
	PORT Map (
		state		=> Red_AddWhiteningKeyOutput(16*Red_size-1 downto 12*Red_size),
		result	=> Red_MixColumnsLeftOutput);

	Red_SubCellLeft2Inst: ENTITY work.FMulti
	GENERIC Map ( count => 4, Table => RedSboxTable)
	PORT Map (
		input 	=> Red_MixColumnsLeftOutput,
		output	=> Red_SubCellLeft2Output);

	--
	
	Red_MCRightInst: ENTITY work.Red_MC
	GENERIC Map ( Red_size, RedSboxTable, LFTable, LFInvTable, LFC)
	PORT Map (
		state		=> Red_AddWhiteningKeyOutput(8*Red_size-1 downto 4*Red_size),
		result	=> Red_MixColumnsRightOutput);

	Red_SubCellRight2Inst: ENTITY work.FMulti
	GENERIC Map ( count => 4, Table => RedSboxTable)
	PORT Map (
		input 	=> Red_MixColumnsRightOutput,
		output	=> Red_SubCellRight2Output);	

	------

	Red_AddRoundKeyOutput(16*Red_size-1 downto 12*Red_size)	<= Red_AddWhiteningKeyOutput(16*Red_size-1 downto 12*Red_size);

	Red_AddKeyLeftXOR: ENTITY work.XOR_5n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( Red_SubCellLeft2Output, Red_AddWhiteningKeyOutput(12*Red_size-1 downto 8*Red_size), Red_RoundKeyLeft, Red_RoundConstLeft, Red_ConstLeft, Red_AddRoundKeyOutput(12*Red_size-1 downto 8*Red_size));

	Red_AddRoundKeyOutput(8*Red_size-1 downto 4*Red_size)	<= Red_AddWhiteningKeyOutput(8*Red_size-1 downto 4*Red_size);

	Red_AddKeyRightXOR: ENTITY work.XOR_5n
	GENERIC Map ( size => Red_size, count => 4)
	PORT Map ( Red_SubCellRight2Output, Red_AddWhiteningKeyOutput(4*Red_size-1 downto 0), Red_RoundKeyRight, Red_RoundConstRight, Red_ConstRight, Red_AddRoundKeyOutput(4*Red_size-1 downto 0));

	Red_PermInst: ENTITY work.Permutation
	GENERIC Map (size => Red_size)
	PORT Map (
		data_in	=> Red_AddRoundKeyOutput,
		data_out	=> Red_PermutationOutput);
		
	Red_PermutationMUX: ENTITY work.MUX2to1_Redn
	GENERIC Map (
		size    => 16*Red_size,
		LFTable => LFTable)
	PORT Map (
		sel	=> Red_last,
		D0		=> Red_PermutationOutput,
		D1		=> Red_AddRoundKeyOutput,
		Q		=> Red_Feedback);

	-----------------------------------------------------

	Red_KeyInst: ENTITY work.FMulti
	GENERIC Map ( count => 32, Table => LFTable)
	PORT Map (
		input		=> Key,
		output	=> Red_Key);

	Red_WhiteningKey0	<= Red_Key(32*Red_size-1 downto 30*Red_size) & 
								Red_Key(26*Red_size-1 downto 24*Red_size) &
								Red_Key(28*Red_size-1 downto 26*Red_size) & 
								Red_Key(30*Red_size-1 downto 28*Red_size);
	
	Red_WhiteningKey1	<= Red_Key(16*Red_size-1 downto 14*Red_size) & 
								Red_Key( 2*Red_size-1 downto    0) &
								Red_Key( 4*Red_size-1 downto  2*Red_size) & 
								Red_Key(14*Red_size-1 downto 12*Red_size);

	Red_WhiteningKey1MUXInst: ENTITY work.Red_WhiteningKeyMUX
	GENERIC Map ( Red_size, LFTable)
	PORT Map ( 
		sel0	=> Red_WhiteningKeySel0,
		sel1	=> Red_WhiteningKeySel1,
		D0   	=> Red_WhiteningKey0,
		D1   	=> Red_WhiteningKey1,
		Q 		=> Red_WhiteningKey);

	Red_WhiteningKeyLeft 	<= Red_WhiteningKey(8*Red_size-1 downto 4*Red_size);
	Red_WhiteningKeyRight 	<= Red_WhiteningKey(4*Red_size-1 downto   0);

	---

	Red_K0	<= Red_Key(32*Red_size-1 downto 28*Red_size);
	Red_K1	<= Red_Key(28*Red_size-1 downto 24*Red_size);
	Red_K2	<= Red_Key(24*Red_size-1 downto 20*Red_size);
	Red_K3	<= Red_Key(20*Red_size-1 downto 16*Red_size);
	Red_K4	<= Red_Key(16*Red_size-1 downto 12*Red_size);
	Red_K5	<= Red_Key(12*Red_size-1 downto  8*Red_size);
	Red_K6	<= Red_Key( 8*Red_size-1 downto  4*Red_size);
	Red_K7	<= Red_Key( 4*Red_size-1 downto    0);

	Red_KeyMUXLeftInst: ENTITY work.Red_KeyMUX
	GENERIC Map ( Red_size, LFTable)
	PORT Map ( 
		sel0	=> Red_KeySelLeft0,
		sel1	=> Red_KeySelLeft1,
		D0   	=> Red_K0,
		D1   	=> Red_K2,
		D2   	=> Red_K4,
		D3   	=> Red_K6,
		Q 		=> Red_RoundKeyLeft);

	Red_KeyMUXRightInst: ENTITY work.Red_KeyMUX
	GENERIC Map ( Red_size, LFTable)
	PORT Map ( 
		sel0	=> Red_KeySelRight0,
		sel1	=> Red_KeySelRight1,
		D0   	=> Red_K1,
		D1   	=> Red_K3,
		D2   	=> Red_K5,
		D3   	=> Red_K7,
		Q 		=> Red_RoundKeyRight);

	-------------------------------------
	
	Red_FSMStart	<= LFTable((15-0)*4+Red_size-1 downto (15-0)*4) & LFTable((15-1)*4+Red_size-1 downto (15-1)*4);
	
	Red_FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => Red_size*2)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_FSMUpdate,
		D1 	=> Red_FSMStart,
		Q 		=> Red_FSMSelected);
		
	Red_FSMReg: ENTITY work.reg
	GENERIC Map ( size => Red_size*2)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_FSMSelected,
		Q 		=> Red_FSM);
		
	Red_FSMUpdateInst: ENTITY work.Red_StateUpdate
	GENERIC Map( LFTable, LFInvTable)
	PORT Map (Red_FSM, Red_FSMUpdate);
	
	Red_FSMSignalsInst: ENTITY work.Red_FSMSignals
	GENERIC Map( LFTable, LFInvTable)
	PORT Map (Red_FSM, Red_last, Red_done, Red_WhiteningKeySel0, Red_WhiteningKeySel1, Red_KeySelLeft0, Red_KeySelLeft1, Red_KeySelRight0, Red_KeySelRight1);

	Red_MakeRoundConstInst: ENTITY work.Red_MakeRoundConst
	GENERIC Map( LFTable, LFInvTable)
	PORT Map (Red_FSM, Red_RoundConstLeft, Red_RoundConstRight);

	--======================================================================================
	
	GENMV0:
	IF MultiVariate = 0 GENERATE
		SignaltoCheck <= "000" & done_internal & "000" & WhiteningKeySel0 & "000" & WhiteningKeySel1 & 
		                 "000" & KeySelLeft0 & "000" & KeySelLeft1 & "000" & KeySelRight0 & "000" & KeySelRight1 & "000" & FSM & 
							  AddWhiteningKeyOutput & MixColumnsLeftOutput & MixColumnsRightOutput;
		Red_final 	  <= Red_done & Red_WhiteningKeySel0 & Red_WhiteningKeySel1 & 
		                 Red_KeySelLeft0 & Red_KeySelLeft1 & Red_KeySelRight0 & Red_KeySelRight1 & Red_FSM & 
							  Red_AddWhiteningKeyOutput & Red_MixColumnsLeftOutput & Red_MixColumnsRightOutput;
	END GENERATE;
	
	GENMV1:
	IF MultiVariate = 1 GENERATE
		SignaltoCheck <= "000" & done_internal & "000" & WhiteningKeySel0 & "000" & WhiteningKeySel1 & 
		                 "000" & KeySelLeft0 & "000" & KeySelLeft1 & "000" & KeySelRight0 & "000" & KeySelRight1 & "000" & FSM & 
							  AddWhiteningKeyOutput & MixColumnsLeftOutput & MixColumnsRightOutput & 
							  "000" & FSMSelected & StateRegInput;
		Red_final 	  <= Red_done & Red_WhiteningKeySel0 & Red_WhiteningKeySel1 & 
		                 Red_KeySelLeft0 & Red_KeySelLeft1 & Red_KeySelRight0 & Red_KeySelRight1 & Red_FSM & 
							  Red_AddWhiteningKeyOutput & Red_MixColumnsLeftOutput & Red_MixColumnsRightOutput & 
							  Red_FSMSelected & Red_StateRegInput;
	END GENERATE;

	--------
	
	Red_ToCheckInst: ENTITY work.FMulti
		GENERIC Map ( count => ToCheckCount, Table => LFTable)
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
		D1		=> AddWhiteningKeyOutput,
		Q		=> CiphertextRegIn);
		
	CiphertextReg: ENTITY work.regER
	GENERIC Map ( size => 64)
	PORT Map ( 
		clk	=> clk,
		rst	=> rst,
		EN		=> done_internal,
		D 		=> CiphertextRegIn,
		Q 		=> Ciphertext);

	done			<= done_internal;	

end Behavioral;

