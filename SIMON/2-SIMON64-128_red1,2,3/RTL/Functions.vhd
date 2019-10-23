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

package functions is

	function MakeStateUpdateTable (
		BitNumber  	: NATURAL;
		Table	  		: STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;

	function MakeSignaldoneTable (
		BitNumber  	: NATURAL;
		Table	  		: STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;

	function MakeSignalRoundConstTable (
		BitNumber  	: NATURAL;
		Table	  		: STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;

	function MakeKeyRoundFunctionRedTable1 (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;
		
	function MakeKeyRoundFunctionRedTable2 (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;		
		
	function GetDistance (
		Red_size	 : NATURAL;
		LFTable 	 : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return NATURAL;
				
end Functions;

package body Functions is	

	function HammingWeight (
		input   : STD_LOGIC_VECTOR (7 DOWNTO 0))
		return NATURAL is
		variable res	: NATURAL;
		variable i     : NATURAL;
	begin

		res := 0;
		
		for i in 0 to 7 loop		
			res := res + to_integer( unsigned'( "" & input(i) ));
		end loop;

		return res;
	end HammingWeight;

	function GetDistance (
		Red_size	 : NATURAL;
		LFTable 	 : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return NATURAL is
		variable i,j  		: NATURAL;
		variable Distance	: NATURAL;
		variable tmp		: NATURAL;
		variable vec1		: STD_LOGIC_VECTOR(7 downto 0);
		variable vec2		: STD_LOGIC_VECTOR(7 downto 0);
		variable res		: STD_LOGIC_VECTOR(7 downto 0);
	begin
	
		Distance := 100;
		
		for i in 0 to 14 loop
			vec1 := std_logic_vector(to_unsigned(i,4)) & LFTable((63-i*4) downto (60-i*4));
			for j in i+1 to 15 loop
				vec2 := std_logic_vector(to_unsigned(j,4)) & LFTable((63-j*4) downto (60-j*4));
				
				res := vec1 XOR vec2;
				tmp := HammingWeight(res);
				if (tmp < Distance) then
					Distance := tmp;
				end if;	
			end loop;
		end loop;
			
		return Distance;	
	end GetDistance;


	-------------------
	

	function MakeStateUpdate (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSMUpdate : STD_LOGIC_VECTOR (5 DOWNTO 0);
		variable en        : STD_LOGIC;
	begin
		if FSM = "111010" then
			en := '0';
		else
			en := '1';
		end if;	
		
		if en = '1' then
			FSMUpdate(0) := FSM(1);
			FSMUpdate(1) := FSM(2);
			FSMUpdate(2) := FSM(3) XOR FSM(4);
			FSMUpdate(3) := FSM(4);
			FSMUpdate(4) := FSM(0) XOR FSM(2);
			FSMUpdate(5) := NOT FSM(5);
		else
			FSMUpdate(0) := FSM(0);
			FSMUpdate(1) := FSM(1);
			FSMUpdate(2) := FSM(2);
			FSMUpdate(3) := FSM(3);
			FSMUpdate(4) := FSM(4);
			FSMUpdate(5) := FSM(5);
		end if;	
		
		return FSMUpdate;
	end MakeStateUpdate;	
	
	-----

	function MakeStateUpdateTable (
		BitNumber  	: NATURAL;
		Table	  		: STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable i          			 : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (5  DOWNTO 0);
		variable FSMUpdate          : STD_LOGIC_VECTOR (5  DOWNTO 0);
		variable FSMupdate_l        : NATURAL;
		variable FSMupdate_r        : NATURAL;
		variable FSMUpdateVector    : STD_LOGIC_VECTOR (7  DOWNTO 0);
		variable FSMUpdateTable 	 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	begin
		for i in 0 to 63 loop
			FSM       := std_logic_vector(to_unsigned(i,6));
			
			FSMUpdate := MakeStateUpdate(FSM);
			FSMupdate_l := to_integer(unsigned(FSMUpdate(5 downto 4)));
			FSMupdate_r := to_integer(unsigned(FSMUpdate(3 downto 0)));
			
			FSMUpdateVector(3 downto 0) := Table((63-FSMupdate_r*4) downto (60-FSMupdate_r*4));
			FSMUpdateVector(7 downto 4) := Table((63-FSMupdate_l*4) downto (60-FSMupdate_l*4));
			
			FSMUpdateTable(63-i) := FSMUpdateVector(BitNumber);
		end loop;
	  return FSMUpdateTable;
	end MakeStateUpdateTable;

	-------------------------------

	function MakeSignaldone (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC is
		variable done : STD_LOGIC;
	begin
		IF FSM = "011100" THEN
			done := '1';
		ELSE 
			done := '0';
		END IF;	
		return done;
	end MakeSignaldone;	

	----------------
	
	function MakeSignaldoneTable (
		BitNumber  : NATURAL;
		Table	  	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable i              : NATURAL;
		variable FSM    	      : STD_LOGIC_VECTOR (5  DOWNTO 0);
		variable done           : NATURAL;
		variable doneVector     : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable doneTable      : STD_LOGIC_VECTOR (63 DOWNTO 0);
	begin
		for i in 0 to 63 loop
			FSM        := std_logic_vector(to_unsigned(i,6));

			done       := to_integer( unsigned'( "" & MakeSignaldone(FSM)));
			doneVector := Table((63-done*4) downto (60-done*4));
			
			doneTable(63-i) := doneVector(BitNumber);
		end loop;
	  return doneTable;
	end MakeSignaldoneTable;
	
	-------------------------------

	function MakeSignalRoundConstTable (
		BitNumber  : NATURAL;
		Table	  	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable i         			: NATURAL;
		variable FSM0, FSM5        : STD_LOGIC_VECTOR (0  DOWNTO 0);
		variable RoundConstVec     : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable RoundConst        : NATURAL;
		variable OutVector         : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable RoundConstTable	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	begin
		for i in 0 to 3 loop
			FSM0 := std_logic_vector(to_unsigned(i mod 2,1));
			FSM5 := std_logic_vector(to_unsigned(i / 2  ,1));
			
			RoundConstVec  := "110" & (FSM5 XOR FSM0); -- "110" for the constant (c) in ffff..fc
			RoundConst		:= to_integer( unsigned( RoundConstVec )); 
			OutVector 	   := Table((63-RoundConst*4) downto (60-RoundConst*4));
			
			RoundConstTable(3-i) := OutVector(BitNumber);
		end loop;
	  return RoundConstTable;
	end MakeSignalRoundConstTable;	
	
	-------------------------------------
	
	function MakeKeyRoundFunction1 (
		input 	: STD_LOGIC_VECTOR (7 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable output : STD_LOGIC_VECTOR (3 DOWNTO 0);
	begin
		
		output := input(3 downto 0) XOR input(4 downto 1);
		
		return output;
	end MakeKeyRoundFunction1;		
	
	-----
	
	function MakeKeyRoundFunction2 (
		input 	: STD_LOGIC_VECTOR (7 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable output : STD_LOGIC_VECTOR (3 DOWNTO 0);
	begin
		
		output := input(6 downto 3) XOR input(7 downto 4);
		
		return output;
	end MakeKeyRoundFunction2;		
	
	-----	
	
	function MakeKeyRoundFunctionRedTable1 (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable i            					: NATURAL;
		variable input   	          			: STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable output        					: NATURAL;
		variable OutVector      				: STD_LOGIC_VECTOR (3   DOWNTO 0);
		variable Red_KeyRoundFunctionTable 	: STD_LOGIC_VECTOR (255 DOWNTO 0);
	begin
		for i in 0 to 255 loop
			input  := std_logic_vector(to_unsigned(i,8));
		
			output := to_integer(unsigned(MakeKeyRoundFunction1(input)));
			OutVector := LFTable((63-output*4) downto (60-output*4));
	
			Red_KeyRoundFunctionTable(255-i) := OutVector(BitNumber);
		end loop;
	  return Red_KeyRoundFunctionTable;
	end MakeKeyRoundFunctionRedTable1;		
	
	-----	
	
	function MakeKeyRoundFunctionRedTable2 (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable i            					: NATURAL;
		variable input   	          			: STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable output        					: NATURAL;
		variable OutVector      				: STD_LOGIC_VECTOR (3   DOWNTO 0);
		variable Red_KeyRoundFunctionTable 	: STD_LOGIC_VECTOR (255 DOWNTO 0);
	begin
		for i in 0 to 255 loop
			input  := std_logic_vector(to_unsigned(i,8));
		
			output := to_integer(unsigned(MakeKeyRoundFunction2(input)));
			OutVector := LFTable((63-output*4) downto (60-output*4));
	
			Red_KeyRoundFunctionTable(255-i) := OutVector(BitNumber);
		end loop;
	  return Red_KeyRoundFunctionTable;
	end MakeKeyRoundFunctionRedTable2;		
	
end functions;

