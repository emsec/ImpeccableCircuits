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

-- Red_size     : 1 => LF: 0110100110010110
-- Red_size     : 2 => LF: 0132231032011023
-- Red_size     : 3 => LF: 0374562165123047

-- MultiVariate : 0 => Univariate   adversary model
-- MultiVariate : 1 => Multivariate adversary model

entity KTANTAN64Enc is
	 Generic ( Red_size  	: POSITIVE := 1;
		   LFC       	: STD_LOGIC_VECTOR (3  DOWNTO 0) := x"0";
	           LF        	: STD_LOGIC_VECTOR (63 DOWNTO 0) := x"0110100110010110";
		   MultiVariate : NATURAL  := 0);
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           Plaintext 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key 			: in  STD_LOGIC_VECTOR ( 79 downto 0);
           Ciphertext 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);
end KTANTAN64Enc;

architecture Behavioral of KTANTAN64Enc is

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
	
	constant ToCheckCount : NATURAL := 1+3+16+(3+16)*MultiVariate;

	constant Distance 	 : NATURAL := GetDistance(Red_size, LFTable);
	constant Error_size   : NATURAL := Distance-1+Distance*MultiVariate;

	-------------------------------

	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);

	signal FSM										: STD_LOGIC_VECTOR(9   downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(9   downto 0);
	signal FSMSelected							: STD_LOGIC_VECTOR(9   downto 0);
	signal done_internal							: STD_LOGIC;

	----
	
	signal Red_Plaintext		 					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegInput 					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegOutput					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Feedback							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);

	signal Red_FSM									: STD_LOGIC_VECTOR( 3*Red_size-1 downto 0);
	signal Red_FSMStart							: STD_LOGIC_VECTOR( 3*Red_size-1 downto 0);
	signal Red_FSMUpdate							: STD_LOGIC_VECTOR( 3*Red_size-1 downto 0);
	signal Red_FSMSelected						: STD_LOGIC_VECTOR( 3*Red_size-1 downto 0);
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
   
	RoundFunctionInst: ENTITY work.RoundFunction
	PORT Map (
		Input	 	=> StateRegOutput,
		FSM		=> FSM(7 downto 0),
		Key		=> Key,
		Output 	=> Feedback);
 
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
	PORT Map (FSM, done_internal);

	--**************************************************
	--**************************************************
	
	Red_PlaintextInst: ENTITY work.FMulti
	GENERIC Map ( size => Red_size, count => 16, Table => LFTable)
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
   
	Red_RoundFunctionInst: ENTITY work.Red_RoundFunction
	GENERIC Map ( Red_size, LFTable)
	PORT Map (
		Input 		=> StateRegOutput,
		FSM 			=> FSM(7 downto 0),
		Key			=> Key,
		Red_Output 	=> Red_Feedback);

	--===================================================

	Red_FSMStart	<= LFTable((15-0)*4+Red_size-1  downto (15-0)*4) & 
	                  LFTable((15-7)*4+Red_size-1  downto (15-7)*4) & 
							LFTable((15-15)*4+Red_size-1 downto (15-15)*4);
	
	Red_FSMMUX: ENTITY work.MUX
	GENERIC Map ( size => Red_size*3)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_FSMUpdate,
		D1 	=> Red_FSMStart,
		Q 		=> Red_FSMSelected);
		
	Red_FSMReg: ENTITY work.reg
	GENERIC Map ( size => Red_size*3)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_FSMSelected,
		Q 		=> Red_FSM);
		
	Red_FSMUpdateInst: ENTITY work.Red_StateUpdate
	GENERIC Map ( Red_size, LFTable)
	PORT Map (FSM, Red_FSMUpdate);
	
	Red_FSMSignalsInst: ENTITY work.Red_FSMSignals
	GENERIC Map ( Red_size, LFTable)
	PORT Map (FSM, Red_done);

	--======================================================================================
	
	GENMV0:
	IF MultiVariate = 0 GENERATE
		SignaltoCheck <= "000" & done_internal & "00" & FSM & StateRegOutput;
		Red_final 	  <= Red_done & Red_FSM & Red_StateRegOutput;
	END GENERATE;
	
	GENMV1:
	IF MultiVariate = 1 GENERATE
		SignaltoCheck <= "000" & done_internal & "00" & FSM & StateRegOutput &
							  "00" & FSMSelected & StateRegInput;
		Red_final 	  <= Red_done & Red_FSM & Red_StateRegOutput &
							  Red_FSMSelected & Red_StateRegInput;
	END GENERATE;

	--------
	
	Red_ToCheckInst: ENTITY work.FMulti
		GENERIC Map ( size => Red_size, count => ToCheckCount, Table => LFTable)
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

