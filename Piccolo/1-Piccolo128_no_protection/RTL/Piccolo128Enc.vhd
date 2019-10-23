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

entity Piccolo128Enc is
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
	
	-------------------------------

	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddWhiteningKeyOutput				: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellLeftOutput					: STD_LOGIC_VECTOR(15 downto 0);
	signal MixColumnsLeftOutput				: STD_LOGIC_VECTOR(15 downto 0);
	signal SubCellLeft2Output					: STD_LOGIC_VECTOR(15 downto 0);
	signal SubCellRightOutput					: STD_LOGIC_VECTOR(15 downto 0);
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
	GENERIC Map ( size => 16, count => 1)
	PORT Map ( StateRegOutput(16*4-1 downto 12*4), WhiteningKeyLeft, AddWhiteningKeyOutput(16*4-1 downto 12*4));

	AddWhiteningKeyOutput(12*4-1 downto 8*4) 	<= StateRegOutput(12*4-1 downto 8*4);
	
	AddWhiteningKeyRightXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 4)
	PORT Map ( StateRegOutput(8*4-1 downto 4*4), WhiteningKeyRight, AddWhiteningKeyOutput(8*4-1 downto 4*4));

	AddWhiteningKeyOutput(4*4-1 downto 0) 	<= StateRegOutput(4*4-1 downto 0);

	------

	SubCellLeftInst: ENTITY work.FMulti
	GENERIC Map ( count => 4, Table => SboxTable)
	PORT Map (
		input 	=> AddWhiteningKeyOutput(16*4-1 downto 12*4),
		output	=> SubCellLeftOutput);

	MCLeftInst: ENTITY work.MC
	PORT Map (
		state		=> SubCellLeftOutput,
		result	=> MixColumnsLeftOutput);

	SubCellLeft2Inst: ENTITY work.FMulti
	GENERIC Map ( count => 4, Table => SboxTable)
	PORT Map (
		input 	=> MixColumnsLeftOutput,
		output	=> SubCellLeft2Output);

	--
	
	SubCellRightInst: ENTITY work.FMulti
	GENERIC Map ( count => 4, Table => SboxTable)
	PORT Map (
		input 	=> AddWhiteningKeyOutput(8*4-1 downto 4*4),
		output	=> SubCellRightOutput);

	MCRightInst: ENTITY work.MC
	PORT Map (
		state		=> SubCellRightOutput,
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
				
	--===================================================

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

	----------------

	Ciphertext 	<= AddWhiteningKeyOutput;
	done			<= done_internal;	

end Behavioral;

