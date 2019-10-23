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

entity PRESENT128Enc is
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           Plaintext 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
           Ciphertext 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);
end PRESENT128Enc;

architecture Behavioral of PRESENT128Enc is

	constant SboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"C56B90AD3EF84712";

	-------------------------------

	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellOutput							: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundConst								: STD_LOGIC_VECTOR(7  downto 0);
	signal RoundKey								: STD_LOGIC_VECTOR(63 downto 0);
	signal CiphertextRegIn						: STD_LOGIC_VECTOR(63 downto 0);
	
	signal KeyRegInput 							: STD_LOGIC_VECTOR(127 downto 0);
	signal KeyRegOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal KeyPermOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal KeySubCellInput						: STD_LOGIC_VECTOR(7   downto 0);
	signal KeySubCellOutput						: STD_LOGIC_VECTOR(7   downto 0);
	signal KeyFeedback							: STD_LOGIC_VECTOR(127 downto 0);
		
	signal FSM										: STD_LOGIC_VECTOR(5   downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(5   downto 0);
	signal FSMSelected							: STD_LOGIC_VECTOR(5   downto 0);
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

	AddKeyXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( StateRegOutput, RoundKey, AddRoundKeyOutput);

	SubCellInst: ENTITY work.FMulti
	GENERIC Map ( count => 16, Table => SboxTable)
	PORT Map (
		input 	=> AddRoundKeyOutput,
		output	=> SubCellOutput);
		
	PermInst: ENTITY work.Permutation
	PORT Map (
		data_in	=> SubCellOutput,
		data_out	=> Feedback);
		
	--===================================================

	KeyMUX: ENTITY work.MUX
	GENERIC Map ( size => 128)
	PORT Map ( 
		sel	=> rst,
		D0   	=> KeyFeedback,
		D1 	=> Key,
		Q 		=> KeyRegInput);

	KeyReg: ENTITY work.reg
	GENERIC Map ( size => 128)
	PORT Map ( 
		clk	=> clk,
		D 		=> KeyRegInput,
		Q 		=> KeyRegOutput);

	RoundKey	<= KeyRegOutput(127 downto 64);

	KeyPermInst: ENTITY work.KeyPermutation
	PORT Map (
		data_in	=> KeyRegOutput,
		data_out	=> KeyPermOutput);

	KeySubCellInput <= KeyPermOutput(127 downto 120);

	KeySubCellInst: ENTITY work.FMulti
	GENERIC Map ( count => 2, Table => SboxTable)
	PORT Map (
		input 	=> KeySubCellInput,
		output	=> KeySubCellOutput);
	
	KeyFeedback(127 downto 120) <= KeySubCellOutput;
	KeyFeedback(119 downto 68)  <= KeyPermOutput(119 downto 68);
	
	RoundConst	<= FSM & "00";
	
	KeyRoundConstXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 2)
	PORT Map ( KeyPermOutput(67  downto 60), RoundConst, KeyFeedback(67  downto 60));	
	
	KeyFeedback(59  downto 0)   <= KeyPermOutput(59  downto 0);	

	-------------------------------------
	
	FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 6)
	PORT Map ( 
		sel	=> rst,
		D0   	=> FSMUpdate,
		D1 	=> "000001",
		Q 		=> FSMSelected);
		
	FSMReg: ENTITY work.reg
	GENERIC Map ( size => 6)
	PORT Map ( 
		clk	=> clk,
		D 		=> FSMSelected,
		Q 		=> FSM);
		
	FSMUpdateInst: ENTITY work.StateUpdate
	PORT Map (FSM, FSMUpdate);
	
	FSMSignalsInst: ENTITY work.FSMSignals
	PORT Map (FSM, done_internal);

	----------------

	Ciphertext 	<= AddRoundKeyOutput;
	done			<= done_internal;	

end Behavioral;

