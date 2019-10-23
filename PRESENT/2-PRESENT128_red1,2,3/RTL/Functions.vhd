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

	function GoF (
		GTable  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		FTable  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;

	function MakeStateUpdateTable (
		BitNumber : NATURAL;
		Table     : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;

	function MakeSignaldoneTable (
		BitNumber : NATURAL;
		Table     : STD_LOGIC_VECTOR (63 DOWNTO 0))	
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
	function GoF (
		GTable  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		FTable  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable ResTable	: STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable Gin   : NATURAL;
	begin
		for i in 0 to 15 loop
			Gin := to_integer(unsigned(FTable((63-i*4)   downto (60-i*4))));
			ResTable((63-i*4) downto (60-i*4)) := GTable((63-Gin*4) downto (60-Gin*4));
		end loop;
	  return ResTable;
	end Gof;
	
	-------------------------------
	
	function MakeStateUpdate (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSMUpdate : STD_LOGIC_VECTOR (5 DOWNTO 0);
		variable en        : STD_LOGIC;
	begin
		if (FSM(5) AND FSM(0)) = '1' then
			en := '0';
		else
			en := '1';
		end if;	
		
		FSMUpdate(0) := FSM(0) XOR  en;
		FSMUpdate(1) := FSM(1) XOR  FSM(0);
		FSMUpdate(2) := FSM(2) XOR (FSM(0) AND FSM(1));
		FSMUpdate(3) := FSM(3) XOR (FSM(0) AND FSM(1) AND FSM(2));
		FSMUpdate(4) := FSM(4) XOR (FSM(0) AND FSM(1) AND FSM(2) AND FSM(3));
		FSMUpdate(5) := FSM(5) XOR (FSM(0) AND FSM(1) AND FSM(2) AND FSM(3) AND FSM(4));
		
		return FSMUpdate;
	end MakeStateUpdate;	
	
	-----

	function MakeStateUpdateTable ( 
		BitNumber : NATURAL;
		Table     : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSMUpdateTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable Temp				: STD_LOGIC_VECTOR (5  DOWNTO 0);
		variable FSMUpdate      : STD_LOGIC_VECTOR (7  DOWNTO 0);
		variable i   : NATURAL;
		variable j   : NATURAL;
	begin
		for i in 0 to 63 loop
			Temp 	:= MakeStateUpdate(std_logic_vector(to_unsigned(i,6)));
			j 		:= to_integer(unsigned(Temp(1 downto 0) & "00"));
			FSMUpdate(3 downto 0) := Table((63-j*4) downto (60-j*4));				
			j 		:= to_integer(unsigned(Temp(5 downto 2)));
			FSMUpdate(7 downto 4) := Table((63-j*4) downto (60-j*4));				
			
			FSMUpdateTable(63-i) := FSMUpdate(BitNumber);
		end loop;
	  return FSMUpdateTable;
	end MakeStateUpdateTable;	
	
	-------------------------------

	function MakeSignaldone (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC is
		variable done : STD_LOGIC;
	begin
		IF (FSM(5) AND (NOT FSM(0))) = '1' THEN
			done := '1';
		ELSE 
			done := '0';
		END IF;	
		return done;
	end MakeSignaldone;	

	----------------
	
	function MakeSignaldoneTable(
		BitNumber : NATURAL;
		Table     : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable doneTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable i   			: NATURAL;
		variable j   			: NATURAL;
		variable OutVector	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	begin
		for i in 0 to 63 loop
			j 					 := to_integer( unsigned'( "" & MakeSignaldone(std_logic_vector(to_unsigned(i,6)))));
			OutVector 		 := Table((63-j*4) downto (60-j*4));	
			doneTable(63-i) := OutVector(BitNumber);
		end loop;
	  return doneTable;
	end MakeSignaldoneTable;	
	
end functions;

