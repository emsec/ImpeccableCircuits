----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Anita Aghaie, Amir Moradi, Aein Rezaei Shahmirzadi
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

-- Red_size     : 1 => FL: 0110100110010110
-- Red_size     : 2 => FL: 0132231032011023
-- Red_size     : 3 => FL: 0374562165123047

-- TweakeySize  : 1 =>  64-bit key
-- TweakeySize  : 2 => 128-bit key
-- TweakeySize  : 3 => 192-bit key

-- MultiVariate : 0 => Univariate   adversary model
-- MultiVariate : 1 => Multivariate adversary model

entity Skinny64Enc is

	Generic ( Red_size     : POSITIVE := 1;
	          TweakeySize  : POSITIVE := 1;
	          LFC          : STD_LOGIC_VECTOR (3  DOWNTO 0) := x"0";
	          LF           : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"0110100110010110";
		  MultiVariate : NATURAL  := 0);

    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           Plaintext 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (TweakeySize*64-1 downto 0);
           Ciphertext 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);

end Skinny64Enc;

architecture Behavioral of Skinny64Enc is

constant SboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"c6901a2b385d4e7f";


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
	
	
   constant NLFTable : STD_LOGIC_VECTOR (63 DOWNTO 0) := MakeSboxGF(LFTable,SboxTable);
	constant Identity : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"0123456789ABCDEF";
	
	constant ToCheckCount : NATURAL := 1+(18+TweakeySize*16)*(MultiVariate+1);
	
	constant Distance 	 : NATURAL := GetDistance(Red_size, LFTable);
	constant Error_size   : NATURAL := Distance-1+Distance*MultiVariate;
	
-------------------------------------------------------------------------------------------

	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellOutput							: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundConstantOutput				: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundTweakeyOutput				: STD_LOGIC_VECTOR(63 downto 0);	
	signal ShiftRowsOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal MCOutput								: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundTweakey							: STD_LOGIC_VECTOR(31 downto 0);
	signal Const									: STD_LOGIC_VECTOR(11 downto 0);

	signal done_internal							: STD_LOGIC_VECTOR(0  downto 0);
	signal FSM										: STD_LOGIC_VECTOR(5 downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(5 downto 0);
	signal FSMSelected							: STD_LOGIC_VECTOR(5 downto 0);
	signal CiphertextRegIn						: STD_LOGIC_VECTOR(63 downto 0);
	signal KeyRegInput                 		: STD_LOGIC_VECTOR(TweakeySize*16*4-1 downto 0);
	signal KeyReg                     		: STD_LOGIC_VECTOR(TweakeySize*16*4-1 downto 0);

	------------
	
	signal LFSRIn                          : STD_LOGIC_VECTOR(8*TweakeySize*4-1 DOWNTO 8*4);

	signal Red_Plaintext                   : STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Key                         : STD_LOGIC_VECTOR(TweakeySize*16*Red_size-1 downto 0);
	signal Red_StateRegInput 				   : STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_StateRegOutput					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_SubCellOutput					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_AddRoundConstantOutput		: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_AddRoundTweakeyOutput			: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);	
	signal Red_ShiftRowsOutput					: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_MCOutput							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_Feedback							: STD_LOGIC_VECTOR(16*Red_size-1 downto 0);
	signal Red_RoundTweakey						: STD_LOGIC_VECTOR((16*Red_size)/2-1 downto 0);
	signal Red_Const								: STD_LOGIC_VECTOR(3*Red_size-1  downto 0);

	signal Red_done  							   : STD_LOGIC_VECTOR(Red_size-1  downto 0);

	signal Red_FSM									: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal Red_FSMUpdate							: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal Red_FSMSelected						: STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal Red_FSMStart						   : STD_LOGIC_VECTOR(2*Red_size-1 downto 0);
	signal Red_KeyRegInput                 : STD_LOGIC_VECTOR(TweakeySize*16*Red_size-1 downto 0);
	signal Red_KeyReg		                  : STD_LOGIC_VECTOR(TweakeySize*16*Red_size-1 downto 0);

	signal Error									: STD_LOGIC_VECTOR(Red_size-1   downto 0);
	signal ErrorFree								: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal ErrorFreeUpdate						: STD_LOGIC_VECTOR(Error_size-1 downto 0);

	signal SignaltoCheck							: STD_LOGIC_VECTOR(ToCheckCount*4-1 downto 0);
	signal Red_SignaltoCheck					: STD_LOGIC_VECTOR(ToCheckCount*Red_size-1 downto 0);
	signal Red_final								: STD_LOGIC_VECTOR(ToCheckCount*Red_size-1 downto 0);

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
			GENERIC Map ( size  => 4, count => 16, Table => SboxTable)
			PORT Map (
				input 	=> StateRegOutput,
				output	=> SubCellOutput);
		
		
		Const	 <= "001000" & FSM;
		
		AddConstXOR: ENTITY work.RoundConstXOR 
			GENERIC Map ( size => 4)
			PORT Map ( 
			R_in0 => SubCellOutput ,
			R_in1 => Const, 
			R_q   => AddRoundConstantOutput);	

 
		AddRoundTweakeyXOR: ENTITY work.XOR_2n  
			GENERIC Map ( size => 4, count => 8)
			PORT Map ( AddRoundConstantOutput (63 downto 32), RoundTweakey, AddRoundTweakeyOutput (63 downto 32));
		
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

		Red_PlaintextInst: ENTITY work.FMulti
			GENERIC Map ( size  => Red_size, count => 16, Table => LFTable)
			PORT Map (
				input		=> Plaintext,
				output	=> Red_Plaintext);
			
		Red_PlaintextMUX: ENTITY work.MUX
			GENERIC Map ( size => 16*Red_size)
			PORT Map ( 
				sel	=> rst,
				D0		=> Red_Feedback,
				D1		=> Red_Plaintext,
				Q		=> Red_StateRegInput);

		Red_StateReg: ENTITY work.reg
			GENERIC Map ( size => Red_size*16)
			PORT Map ( 
				clk	=> clk,
				D 		=> Red_StateRegInput,
				Q 		=> Red_StateRegOutput);

				
		Red_SubCellInst: ENTITY work.FMulti
			GENERIC Map ( size  => Red_size, count => 16, Table => NLFTable)
			PORT Map (
				input 	=> StateRegOutput,
				output	=> Red_SubCellOutput);	
		
		Red_Const	<= LFTable(52+Red_size-1 downto 52) & Red_FSM; --LF (0010)
		
		Red_AddConstXOR: ENTITY work.RoundConstXOR 
			GENERIC Map ( size => Red_size, LFC => LFC)
			PORT Map ( 
			R_in0 => Red_SubCellOutput,
			R_in1 => Red_Const,
			R_q   => Red_AddRoundConstantOutput);	

 
		Red_AddRoundTweakeyXOR: ENTITY work.XOR_2n  
			GENERIC Map ( size => Red_size, count => 8)
			PORT Map ( 
				Red_AddRoundConstantOutput (16*Red_size-1 downto (16*Red_size)/2),
			   Red_RoundTweakey, 
				Red_AddRoundTweakeyOutput (16* Red_size-1 downto (16*Red_size)/2),
				LFC(Red_size-1 downto 0));
		
	Red_AddRoundTweakeyOutput ((16*Red_size)/2 -1 downto 0) <= Red_AddRoundConstantOutput ((16*Red_size)/2 -1 downto 0);
		
						
		Red_ShiftRowsInst: ENTITY work.ShiftRows
			GENERIC Map ( size => Red_size)
			PORT Map (
				state		=> Red_AddRoundTweakeyOutput,
				result	=> Red_ShiftRowsOutput);
		
		Red_MCInst: ENTITY work.MC
			GENERIC Map ( size => Red_size, LFC => LFC)
			PORT Map (
				state		=> Red_ShiftRowsOutput,
				result	=> Red_MCOutput);		
		
   Red_Feedback <= Red_MCOutput;	
	
--------------------------------------------------------	

		TweakeyGeneration: ENTITY work.TweakeySchedule
		GENERIC Map ( size => 4, Tweakey => TweakeySize, Table => Identity)
		PORT Map ( 
			Key					=> Key,
			clk					=> clk,
			rst	            => rst,
			LFSRIn				=> LFSRIn,
			TweakeyOutput 		=> RoundTweakey,
			KeyRegIn				=> KeyRegInput,
			KeyReg       		=> KeyReg);
--------------------------------------------------------	
 	
	Red_KeyInst: ENTITY work.FMulti
		GENERIC Map (  size  => Red_size,
			            count => TweakeySize*16, 
						   Table => LFTable)
		PORT Map (
			input		=> Key,
			output	=> Red_Key);


	Red_TweakeyGeneration: ENTITY work.Red_TweakeySchedule
		GENERIC Map ( 
			Tweakey     => TweakeySize,
			size        => Red_size,
			LFTable     => LFTable,
			LFC			=> LFC)
		PORT Map ( 
			Key					=> Red_Key,
			clk					=> clk,
			rst	            => rst,
			LFSRIn				=> LFSRIn,
			TweakeyOutput 		=> Red_RoundTweakey,
			KeyRegIn				=> Red_KeyRegInput,
			KeyReg            => Red_KeyReg);

--------------------------------------------------------

	GENMV0:
	IF MultiVariate = 0 GENERATE
		SignaltoCheck <= "000" & done_internal & "00" & FSM & StateRegOutput & KeyReg;
		Red_final     <= Red_done & Red_FSM & Red_StateRegOutput & Red_KeyReg;
	END GENERATE;
	
	GENMV1:
	IF MultiVariate = 1 GENERATE
		SignaltoCheck <= "000" & done_internal & "00" & FSM & StateRegOutput & KeyReg &
		                 "00" & FSMSelected & StateRegInput & KeyRegInput;
		Red_final 	  <=  Red_done & Red_FSM & Red_StateRegOutput & Red_KeyReg & 
				            Red_FSMSelected & Red_StateRegInput & Red_KeyRegInput;
	END GENERATE;

	--------
	
	Red_MCOutputInst: ENTITY work.FMulti
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
		Q		=> CiphertextRegIn);
	
	
	CiphertextReg: ENTITY work.regER
		GENERIC Map ( size => 64)
		PORT Map ( 
			clk	=> clk,
			rst	=> rst,
			EN		=> done_internal(0),
			D 		=> CiphertextRegIn,
			Q 		=> Ciphertext);
			
-----------------------------------------------------
	
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
		GENERIC Map (TweakeySize)
		PORT Map (FSM, FSMUpdate);
		
		FSMSignalsInst: ENTITY work.FSMSignals
		GENERIC Map (TweakeySize, 1, Identity)
		PORT Map (FSM, done_internal);
		
------------------------------------------------------
	
	Red_FSMStart <= LFTable(60+Red_size-1 downto 60) & LFTable(56+Red_size-1 downto 56); -- LF( 0000) & LF(0001)
	
	Red_FSMMUX: ENTITY work.MUX
			GENERIC Map ( size => 2*Red_size)
			PORT Map ( 
			sel	=> rst,
			D0		=> Red_FSMUpdate,
			D1		=> Red_FSMStart,
			Q		=> Red_FSMSelected);		
		
	Red_FSMReg: ENTITY work.reg
		GENERIC Map ( size => 2*Red_size)
		PORT Map ( 
			clk	=> clk,
			D 		=> Red_FSMSelected,
			Q 		=> Red_FSM);
	
	Red_FSMUpdateInst: ENTITY work.Red_StateUpdate
		GENERIC Map( TweakeySize, Red_size, LFTable)
		PORT Map (FSM, Red_FSMUpdate);
	
	Red_FSMUSignalsInst: ENTITY work.FSMSignals
		GENERIC Map(TweakeySize,  Red_size, LFTable)
		PORT Map (FSM, Red_done);

	----------------
	
	done		<= done_internal(0);	
		

end Behavioral;

