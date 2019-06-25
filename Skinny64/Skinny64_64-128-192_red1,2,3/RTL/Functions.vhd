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

package Functions is
	
	function MakeInv (
		F : STD_LOGIC_VECTOR (63 DOWNTO 0)) 
		return STD_LOGIC_VECTOR ;

	function MakeFRed (
		F	  	  	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;	

	function MakeStateUpdateTable (
    	Tweakey    : POSITIVE;
		BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;
  
   function MakeStateUpdateRedTable (
		Tweakey    : POSITIVE;
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;  
	
		
	function MakeSignaldoneTable (	
	   Tweakey    : POSITIVE;
		BitNumber : NATURAL;
		Table     : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;
		
   function MakeLFSRTweakey (Tweakey    : POSITIVE;
		LFSR  	  	  : STD_LOGIC_VECTOR (3 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
   
	function MakeLFSRUpdateTable ( 
		Tweakey    : POSITIVE;
		BitNumber : NATURAL;
		Table     : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
	function MakeSboxGF (
		LFTable	 : STD_LOGIC_VECTOR (63 DOWNTO 0);
		SboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
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

	function MakeInv (
		F	  	: STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Finv	: STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable Fout  : NATURAL;
	begin
		for i in 0 to 15 loop
			Fout := to_integer(unsigned(F((63-i*4) downto (60-i*4))));
			Finv((63-Fout*4) downto (60-Fout*4)) := std_logic_vector(to_unsigned(i,4));
		end loop;
	  return Finv;
	end MakeInv;
	
	-------------------------------

	function MakeFRed (
		F	  	  	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FRed	: STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable Fin   : NATURAL;
		variable Fout  : NATURAL;
	begin
		for i in 0 to 15 loop
			Fin  := to_integer(unsigned(LFInvTable((63-i*4) downto (60-i*4))));
			Fout := to_integer(unsigned(F((63-Fin*4) downto (60-Fin*4))));
			FRed((63-i*4) downto (60-i*4)) := LFTable((63-Fout*4) downto (60-Fout*4));
		end loop;
	  return FRed;
	end MakeFRed;
	
--	-------------------------------
	function MakeSboxGF (
		LFTable	 : STD_LOGIC_VECTOR (63 DOWNTO 0);
		SboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable NLFTable	: STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable Fin   : NATURAL;
	begin
		for i in 0 to 15 loop
		 	Fin  := to_integer(unsigned(SboxTable((63-i*4) downto (60-i*4))));
			NLFTable((63-i*4) downto (60-i*4)) := LFTable((63-Fin*4) downto (60-Fin*4));
		end loop;
	  return NLFTable;
	end MakeSboxGF;
	
--	-------------------------------
	function MakeStateUpdate ( 
	Tweakey    : POSITIVE;
   FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
										
		return STD_LOGIC_VECTOR is
		variable FSMUpdate : STD_LOGIC_VECTOR (5 DOWNTO 0);
			
	begin
	
		if (Tweakey = 1) then
		
		  if (FSM = "100011") then
				FSMUpdate(0) := FSM(0);
				FSMUpdate(1) := FSM(1);
				FSMUpdate(2) := FSM(2);
				FSMUpdate(3) := FSM(3);
				FSMUpdate(4) := FSM(4);
				FSMUpdate(5) := FSM(5);
			else
			   FSMUpdate(0) := FSM(5) XNOR FSM(4);
				FSMUpdate(1) := FSM(0);
				FSMUpdate(2) := FSM(1);
				FSMUpdate(3) := FSM(2);
				FSMUpdate(4) := FSM(3);
				FSMUpdate(5) := FSM(4);
				
			end if;
			
		end if;
			
		if(Tweakey = 2) then
			
			 if (FSM = "110110") then
				FSMUpdate(0) := FSM(0);
				FSMUpdate(1) := FSM(1);
				FSMUpdate(2) := FSM(2);
				FSMUpdate(3) := FSM(3);
				FSMUpdate(4) := FSM(4);
				FSMUpdate(5) := FSM(5);
			else
			   FSMUpdate(0) := FSM(5) XNOR FSM(4);
				FSMUpdate(1) := FSM(0);
				FSMUpdate(2) := FSM(1);
				FSMUpdate(3) := FSM(2);
				FSMUpdate(4) := FSM(3);
				FSMUpdate(5) := FSM(4);
			end if;	
		end if;
		
		if (Tweakey = 3) then
				
			if (FSM = "101001") then
				FSMUpdate(0) := FSM(0);
				FSMUpdate(1) := FSM(1);
				FSMUpdate(2) := FSM(2);
				FSMUpdate(3) := FSM(3);
				FSMUpdate(4) := FSM(4);
				FSMUpdate(5) := FSM(5);
			else
			   FSMUpdate(0) := FSM(5) XNOR FSM(4);
				FSMUpdate(1) := FSM(0);
				FSMUpdate(2) := FSM(1);
				FSMUpdate(3) := FSM(2);
				FSMUpdate(4) := FSM(3);
				FSMUpdate(5) := FSM(4);
			end if;	
		end if;
  
	  return FSMUpdate;
	end MakeStateUpdate;	
	
-------------------------------------------------------------------
	function MakeStateUpdateTable ( Tweakey   : POSITIVE; BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable FSMUpdateTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable FSMUpdate      : STD_LOGIC_VECTOR (5  DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 63 loop
			FSMUpdate := MakeStateUpdate(Tweakey,std_logic_vector(to_unsigned(i,6)));
			FSMUpdateTable(63-i) := FSMUpdate(BitNumber);
		end loop;
	  return FSMUpdateTable;
	end MakeStateUpdateTable;	
-----------------------------------------------------------------------
	
	function MakeStateUpdateRedTable (
		Tweakey    : POSITIVE;
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Red_FSM            : NATURAL;
		variable Red_FSM_r          : NATURAL;
		variable Red_FSM_l          : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (5 DOWNTO 0);
		variable FSMUpdate          : STD_LOGIC_VECTOR (5 DOWNTO 0);
		variable FSMupdate_l        : NATURAL;
		variable FSMupdate_r        : NATURAL;
		variable Red_FSMUpdate      : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable Red_FSMUpdateTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
	begin
		for Red_FSM in 0 to 63 loop
			
			FSMUpdate(5 downto 0) := MakeStateUpdate(Tweakey, std_logic_vector(to_unsigned(Red_FSM,6)));
			FSMupdate_l := to_integer(unsigned(FSMUpdate(5 downto 4)));
			
			FSMupdate_r := to_integer(unsigned(FSMUpdate(3 downto 0)));
			
			Red_FSMUpdate(3 downto 0) := LFTable((63-FSMupdate_r*4) downto (60-FSMupdate_r*4));
			
			Red_FSMUpdate(7 downto 4) := LFTable((63-FSMupdate_l*4) downto (60-FSMupdate_l*4));
			
			Red_FSMUpdateTable(63-Red_FSM) := Red_FSMUpdate(BitNumber);
		end loop;
	  return Red_FSMUpdateTable;
	end MakeStateUpdateRedTable;
	
----------------------------------------

	function MakeSignaldone (
	   Tweakey    : POSITIVE;
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC is
		variable done : STD_LOGIC;
	begin
		
		if(Tweakey = 1) then
			IF (FSM = "110001") THEN
				done := '1';
			ELSE 
				done := '0';
			END IF;	
		end if;
		
		if(Tweakey = 2) then
			IF (FSM = "011011") THEN
				done := '1';
			ELSE 
				done := '0';
			END IF;	
		end if;

		if(Tweakey = 3) then
			IF (FSM = "110100") THEN
				done := '1';
			ELSE 
				done := '0';
			END IF;	
		end if;
		
		return done;
	end MakeSignaldone;	


	----------------
	
	function MakeSignaldoneTable(
	   Tweakey    : POSITIVE;
		BitNumber : NATURAL;
		Table     : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable doneTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable i   			: NATURAL;
		variable j   			: NATURAL;
		variable OutVector	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	begin
		for i in 0 to 63 loop
			j 					 := to_integer( unsigned'( "" & MakeSignaldone(Tweakey,std_logic_vector(to_unsigned(i,6)))));
			OutVector 		 := Table((63-j*4) downto (60-j*4));	
			doneTable(63-i) := OutVector(BitNumber);
		end loop;
	  return doneTable;
	end MakeSignaldoneTable;
	
---------------------------------------------------------------------
	 ------------------------------------------	

	function MakeLFSRTweakey (
	Tweakey    : POSITIVE;
	LFSR  	  : STD_LOGIC_VECTOR (3 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable LFSRUpdate : STD_LOGIC_VECTOR (3 DOWNTO 0);
		
	begin
		
		if(Tweakey = 2) then
			LFSRUpdate(0) := LFSR(3) XOR LFSR(2);
			LFSRUpdate(1) := LFSR(0);
			LFSRUpdate(2) := LFSR(1);
			LFSRUpdate(3) := LFSR(2);
		else
			LFSRUpdate(0) := LFSR(1);
			LFSRUpdate(1) := LFSR(2);
			LFSRUpdate(2) := LFSR(3);
			LFSRUpdate(3) := LFSR(3) XOR LFSR(0);
		end if;
		
	  return LFSRUpdate;
	end MakeLFSRTweakey;	
	
	
	------------------------------------------------------

	function MakeLFSRUpdateTable (
		Tweakey    : POSITIVE; 
		BitNumber  : NATURAL;
		Table     : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable LFSRUpdateTable : STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable LFSRUpdate      : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable i   : NATURAL;
		variable j   : NATURAL;
	begin
		for i in 0 to 15 loop
			j 	:= to_integer( unsigned ( MakeLFSRTweakey(Tweakey,std_logic_vector(to_unsigned(i,4)))));
			LFSRUpdate := Table((63-j*4) downto (60-j*4));
			LFSRUpdateTable(15-i) := LFSRUpdate(BitNumber);
		end loop;
	  return LFSRUpdateTable;
	end MakeLFSRUpdateTable;	
	
	----------------------------------------------------

end Functions;

