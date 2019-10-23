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

entity KATAN64Enc is
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           Plaintext 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key 			: in  STD_LOGIC_VECTOR ( 79 downto 0);
           Ciphertext 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);
end KATAN64Enc;

architecture Behavioral of KATAN64Enc is

	-------------------------------

	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);

	signal KeyRegInput 							: STD_LOGIC_VECTOR(79 downto 0);
	signal KeyRegOutput							: STD_LOGIC_VECTOR(79 downto 0);
	signal KeyScheduleOutput					: STD_LOGIC_VECTOR(79 downto 0);
	signal KeyFeedback							: STD_LOGIC_VECTOR(79 downto 0);

	signal FSM										: STD_LOGIC_VECTOR(9   downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(9   downto 0);
	signal FSMSelected							: STD_LOGIC_VECTOR(9   downto 0);
	signal IR										: STD_LOGIC;
	signal KeyUpdate								: STD_LOGIC;
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
   
	RoundFunctionInst: ENTITY work.RoundFunction
	PORT Map (
		Input	 	=> StateRegOutput,
		IR		 	=> IR,
		Ka			=> KeyRegOutput(0),
		Kb			=> KeyRegOutput(1),
		Output 	=> Feedback);
 
	--===================================================

	KeyMUX: ENTITY work.MUX
	GENERIC Map ( size => 80)
	PORT Map ( 
		sel	=> rst,
		D0   	=> KeyFeedback,
		D1 	=> Key,
		Q 		=> KeyRegInput);

	KeyReg: ENTITY work.reg
	GENERIC Map ( size => 80)
	PORT Map ( 
		clk	=> clk,
		D 		=> KeyRegInput,
		Q 		=> KeyRegOutput);

	------

	KeyScheduleInst: ENTITY work.KeySchedule
	PORT Map (
		Input	 	=> KeyRegOutput,
		Output 	=> KeyScheduleOutput);

	KeyUpdateMUX: ENTITY work.MUX
	GENERIC Map ( size => 80)
	PORT Map ( 
		sel	=> KeyUpdate,
		D0   	=> KeyRegOutput,
		D1 	=> KeyScheduleOutput,
		Q 		=> KeyFeedback);

	--===================================================
	
	FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => 10)
	PORT Map ( 
		sel	=> rst,
		D0   	=> FSMUpdate,
		D1 	=> "0001111111",
		Q 		=> FSMSelected);
		
	FSMReg: ENTITY work.reg
	GENERIC Map ( size => 10)
	PORT Map ( 
		clk	=> clk,
		D 		=> FSMSelected,
		Q 		=> FSM);
		
	FSMUpdateInst: ENTITY work.StateUpdate
	PORT Map (FSM, FSMUpdate);
	
	FSMSignalsInst: ENTITY work.FSMSignals
	PORT Map (FSM, done_internal, KeyUpdate);

	IR 			<= FSM(0);

	----------------

	Ciphertext 	<= StateRegOutput;
	done			<= done_internal;	

end Behavioral;

