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
use IEEE.NUMERIC_STD.ALL;
use work.functions.all;

entity Midori64Enc is
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           Plaintext 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
           Ciphertext 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);
end Midori64Enc;

architecture Behavioral of Midori64Enc is

	constant SboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"cad3ebf789150246";

	-------------------------------

	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundConstant							: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellOutput							: STD_LOGIC_VECTOR(63 downto 0);
	signal ShiftRowsOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput								: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundKey								: STD_LOGIC_VECTOR(63 downto 0);
	signal K0										: STD_LOGIC_VECTOR(63 downto 0);
	signal K1										: STD_LOGIC_VECTOR(63 downto 0);
	signal WK										: STD_LOGIC_VECTOR(63 downto 0);
	signal K0_1										: STD_LOGIC_VECTOR(63 downto 0);
	signal CiphertextRegIn						: STD_LOGIC_VECTOR(63 downto 0);
	
	signal FSM										: STD_LOGIC_VECTOR(4  downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(4  downto 0);
	signal FSMSelected							: STD_LOGIC_VECTOR(4  downto 0);

	signal last										: STD_LOGIC;
	signal done_internal							: STD_LOGIC;
	signal sel_K0_1								: STD_LOGIC;
	signal sel_K_WK								: STD_LOGIC;

	signal Round									: STD_LOGIC_VECTOR(3 downto 0);

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

	RoundConstantMUXInst: ENTITY work.RoundConstant_MUX
	PORT Map ( 
		Round				=> Round,
		RoundConstant 	=> RoundConstant);
		
	AddKeyConstXOR: ENTITY work.XOR_3n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( StateRegOutput,RoundKey, RoundConstant, AddRoundKeyOutput);

	SubCellInst: ENTITY work.FMulti
	GENERIC Map ( count => 16, Table => SboxTable)
	PORT Map (
		input 	=> AddRoundKeyOutput,
		output	=> SubCellOutput);
		
	ShiftRowsInst: ENTITY work.ShiftRows
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> SubCellOutput,
		result	=> ShiftRowsOutput);
		
	MCInst: ENTITY work.MC
	GENERIC Map ( size => 4)
	PORT Map (
		state		=> ShiftRowsOutput,
		result	=> MCOutput);
		
	LastRoundMUX: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> last,
		D0   	=> MCOutput,
		D1 	=> SubCellOutput,
		Q 		=> Feedback);

	--===================================================

	K0 	<= Key (127 DOWNTO 64);
	K1 	<= Key (63  DOWNTO 0);
	
	WKXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( K0, K1, WK);

	-----------
	
	KeyMUX1: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> sel_K0_1,
		D0   	=> K1,
		D1 	=> K0,
		Q 		=> K0_1);
	
	KeyMUX2: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> sel_K_WK,
		D0   	=> K0_1,
		D1 	=> WK,
		Q 		=> RoundKey);
		
	-------------------------------------
	
	Round	<= FSM(3 downto 0);
	
	FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 5)
	PORT Map ( 
		sel	=> rst,
		D0   	=> FSMUpdate,
		D1 	=> (others => '0'),
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
	PORT Map (FSM, last, done_internal, sel_K0_1, sel_K_WK);

	----------------

	Ciphertext	<= AddRoundKeyOutput;
	done			<= done_internal;	

end Behavioral;

