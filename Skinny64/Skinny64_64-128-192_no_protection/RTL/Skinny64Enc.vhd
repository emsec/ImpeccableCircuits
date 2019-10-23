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
use work.Functions.all;

-- TweakeySize : 1 =>  64-bit key
-- TweakeySize : 2 => 128-bit key
-- TweakeySize : 3 => 192-bit key

entity Skinny64Enc is
    Generic (TweakeySize: POSITIVE := 1);
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           Plaintext 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (TweakeySize*64-1 downto 0);
           Ciphertext 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);

end Skinny64Enc;

architecture Behavioral of Skinny64Enc is

	constant SboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"c6901a2b385d4e7f";

	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellOutput							: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundConstantOutput				: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundTweakeyOutput				: STD_LOGIC_VECTOR(63 downto 0);	
	signal ShiftRowsOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput								: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundTweakey							: STD_LOGIC_VECTOR(31 downto 0);
	signal done_internal							: STD_LOGIC;
	signal FSM										: STD_LOGIC_VECTOR(5 downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(5 downto 0);
	signal FSMSelected							: STD_LOGIC_VECTOR(5 downto 0);

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
			
		SubCellInst: ENTITY work.FMulti
			GENERIC Map ( count => 16, Table => SboxTable)
			PORT Map (
				input 	=> StateRegOutput,
				output	=> SubCellOutput);
			
		AddConstXOR: ENTITY work.RoundConstXOR 
			GENERIC Map ( size => 4)
			PORT Map ( 
			R_in0 =>SubCellOutput ,
			R_in1 =>FSM, 
			R_q => AddRoundConstantOutput);	

 
		AddRoundTweakeyXOR: ENTITY work.XOR_2n  
			GENERIC Map ( size => 4, count => 8)
			PORT Map ( 
			 AddRoundConstantOutput (63 downto 32),
			 RoundTweakey, 
			  AddRoundTweakeyOutput (63 downto 32));
		
		AddRoundTweakeyOutput (31 downto 0) <= AddRoundConstantOutput (31 downto 0);

	  	  
	   ShiftRowsInst: ENTITY work.ShiftRows
			GENERIC Map ( size => 4)
			PORT Map (
				state		=> AddRoundTweakeyOutput,
				result	=> ShiftRowsOutput);
			
		MCInst: ENTITY work.MC
			GENERIC Map ( size => 4)
			PORT Map (
				state		=> ShiftRowsOutput,
				result	=> MCOutput);	
      Feedback <= MCOutput;
	-------------------------------------------------
		
		TweakeyGeneration: ENTITY work.TweakeySchedule
		GENERIC Map ( size => 4, Tweakey => TweakeySize)
		PORT Map ( 
			Key					=> Key,
			clk					=> clk,
			rst	            => rst,
			TweakeyOutput 		=> RoundTweakey);


	-------------------------------------------------
	
	Ciphertext	<= StateRegOutput;

	------------------------------------------------
	
	FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 6)
	PORT Map ( 
		sel	=> rst,
		D0   	=> FSMUpdate,
		D1 	=>  "000001",
		Q 		=> FSMSelected);
		
	FSMReg: ENTITY work.reg
	GENERIC Map ( size => 6)
	PORT Map ( 
		clk	=> clk,
		D 		=> FSMSelected,
		Q 		=> FSM);
		
	FSMUpdateInst: ENTITY work.StateUpdate
	GENERIC Map ( Tweakey => TweakeySize)
	PORT Map (FSM, FSMUpdate);
	
	FSMSignalsInst: ENTITY work.FSMSignals
	GENERIC Map ( Tweakey => TweakeySize)
	PORT Map (FSM, done_internal);

	----------------
	
	done		<= done_internal;	
		

end Behavioral;

