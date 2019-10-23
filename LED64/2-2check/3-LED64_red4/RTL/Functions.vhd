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

	function MakeInv (
		F : STD_LOGIC_VECTOR (63 DOWNTO 0)) 
		return STD_LOGIC_VECTOR ;

	function MakeFRed (
		F	  	  	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;
		
	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeGF16_MulTable ( 
		c 			 : STD_LOGIC_VECTOR (3 DOWNTO 0);
		BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeSignalAddKeyTable
		return STD_LOGIC_VECTOR ;
		
	function MakeSignaldoneTable
		return STD_LOGIC_VECTOR ;

	-------------

	function MakeGF16_MulRedTable ( 
		c         : STD_LOGIC_VECTOR (3 DOWNTO 0);
		BitNumber : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
	return STD_LOGIC_VECTOR ;

	function MakeStateUpdateRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;

	function MakeSignalAddKeyRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;

	function MakeSignaldoneRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
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
	
	-------------------------------
	
	function MakeStateUpdate (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSMUpdate : STD_LOGIC_VECTOR (5 DOWNTO 0);
		variable en    : STD_LOGIC;
	begin
		if (FSM = "100011") then
			FSMUpdate(0) := FSM(0);
			FSMUpdate(1) := FSM(1);
			FSMUpdate(2) := FSM(2);
			FSMUpdate(3) := FSM(3);
			FSMUpdate(4) := FSM(4);
			FSMUpdate(5) := FSM(5);	  
		else
			FSMUpdate(0) := FSM(4) XNOR FSM(5);
			FSMUpdate(1) := FSM(0);
			FSMUpdate(2) := FSM(1);
			FSMUpdate(3) := FSM(2);
			FSMUpdate(4) := FSM(3);
			FSMUpdate(5) := FSM(4);	  
		end if;
		
		return FSMUpdate;
	end MakeStateUpdate;	
	
	-----

	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable FSMUpdateTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable FSMUpdate      : STD_LOGIC_VECTOR (5  DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 63 loop
			FSMUpdate := MakeStateUpdate(std_logic_vector(to_unsigned(i,6)));
			FSMUpdateTable(63-i) := FSMUpdate(BitNumber);
		end loop;
	  return FSMUpdateTable;
	end MakeStateUpdateTable;	

	-------------------------------
	
	function GF16_Mul (
		x  	  	  : STD_LOGIC_VECTOR (3 DOWNTO 0);
		c          : STD_LOGIC_VECTOR (3 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable y : STD_LOGIC_VECTOR (3 DOWNTO 0);
	begin
		
		y(0) := (c(0) AND x(0)) XOR (c(1) AND x(3)) XOR (c(2) AND x(2)) XOR (c(3) AND x(1));
		y(1) := (c(0) AND x(1)) XOR (c(1) AND x(0)) XOR (c(2) AND x(3)) XOR (c(3) AND x(2)) XOR (c(1) AND x(3)) XOR (c(2) AND x(2)) XOR (c(3) AND x(1));
		y(2) := (c(0) AND x(2)) XOR (c(1) AND x(1)) XOR (c(2) AND x(0)) XOR (c(3) AND x(3)) XOR (c(2) AND x(3)) XOR (c(3) AND x(2));
		y(3) := (c(0) AND x(3)) XOR (c(1) AND x(2)) XOR (c(2) AND x(1)) XOR (c(3) AND x(0)) XOR (c(3) AND x(3));
		
		return y;
	end GF16_Mul;		

	-----
	
	function MakeGF16_MulTable ( 
		c         : STD_LOGIC_VECTOR (3 DOWNTO 0);
		BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable GF16_MulTable  : STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable y              : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 15 loop
			y := GF16_Mul(std_logic_vector(to_unsigned(i,4)), c);
			GF16_MulTable(15-i) := y(BitNumber);
		end loop;
	  return GF16_MulTable;
	end MakeGF16_MulTable;	

	-------------------------------

	function MakeSignalAddKey (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC is
		variable AddKey : STD_LOGIC;
	begin
		IF ((FSM = "000001") OR (FSM = "011111") OR (FSM = "110111") OR 
		    (FSM = "111001") OR (FSM = "011101") OR (FSM = "010110") OR 
			 (FSM = "100001") OR (FSM = "010111") OR (FSM = "110001") OR
			 (FSM = "110001")) THEN
			AddKey := '1';
		ELSE
			AddKey := '0';
		END IF;
		return AddKey;
	end MakeSignalAddKey;	
	
	-----

	function MakeSignaldone (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC is
		variable done : STD_LOGIC;
	begin
		IF (FSM = "110001") THEN
			done := '1';
		ELSE 
			done := '0';
		END IF;	
		return done;
	end MakeSignaldone;	

	----------------
	
	function MakeSignalAddKeyTable
		return STD_LOGIC_VECTOR is
		variable AddKeyTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 63 loop
			AddKeyTable(63-i) := MakeSignalAddKey(std_logic_vector(to_unsigned(i,6)));
		end loop;
	  return AddKeyTable;
	end MakeSignalAddKeyTable;	
	
	------
	
	function MakeSignaldoneTable
		return STD_LOGIC_VECTOR is
		variable doneTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 63 loop
			doneTable(63-i) := MakeSignaldone(std_logic_vector(to_unsigned(i,6)));
		end loop;
	  return doneTable;
	end MakeSignaldoneTable;	
	
	-------------------------------
	
	function MakeGF16_MulRedTable ( 
		c         : STD_LOGIC_VECTOR (3 DOWNTO 0);
		BitNumber : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable GF16_MulRedTable  : STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable FRed              : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable i   				   : NATURAL;
		variable x   				   : NATURAL;
		variable y   				   : NATURAL;
	begin
		for i in 0 to 15 loop
			x    := to_integer(unsigned(LFInvTable((63-i*4) downto (60-i*4))));
			y 	  := to_integer(unsigned(GF16_Mul(std_logic_vector(to_unsigned(x,4)), c)));
			FRed := LFTable((63-y*4) downto (60-y*4));
			GF16_MulRedTable(15-i) := FRed(BitNumber);
		end loop;
	  return GF16_MulRedTable;
	end MakeGF16_MulRedTable;		

	
	function MakeStateUpdateRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Red_FSM            : NATURAL;
		variable Red_FSM_r          : NATURAL;
		variable Red_FSM_l          : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable FSMUpdate          : STD_LOGIC_VECTOR (5 DOWNTO 0);
		variable FSMupdate_l        : NATURAL;
		variable FSMupdate_r        : NATURAL;
		variable Red_FSMUpdate      : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable Red_FSMUpdateTable : STD_LOGIC_VECTOR (255 DOWNTO 0);
	begin
		for Red_FSM in 0 to 255 loop
			Red_FSM_r := Red_FSM mod 16;
			FSM(3 downto 0) := LFInvTable((63-Red_FSM_r*4) downto (60-Red_FSM_r*4));
			
			Red_FSM_l := Red_FSM / 16;
			FSM(7 downto 4) := LFInvTable((63-Red_FSM_l*4) downto (60-Red_FSM_l*4));
			
			FSMUpdate(5 downto 0) := MakeStateUpdate(FSM(6 downto 4) & FSM(2 downto 0));
			FSMupdate_l := to_integer(unsigned(FSMUpdate(5 downto 3)));
			FSMupdate_r := to_integer(unsigned(FSMUpdate(2 downto 0)));
			
			Red_FSMUpdate(3 downto 0) := LFTable((63-FSMupdate_r*4) downto (60-FSMupdate_r*4));
			Red_FSMUpdate(7 downto 4) := LFTable((63-FSMupdate_l*4) downto (60-FSMupdate_l*4));
			
			Red_FSMUpdateTable(255-Red_FSM) := Red_FSMUpdate(BitNumber);
		end loop;
	  return Red_FSMUpdateTable;
	end MakeStateUpdateRedTable;
		
	--------------------------------------

	function MakeSignalAddKeyRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Red_FSM            : NATURAL;
		variable Red_FSM_r          : NATURAL;
		variable Red_FSM_l          : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable AddKey             : NATURAL;
		variable Red_AddKey         : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_AddKeyTable    : STD_LOGIC_VECTOR (255 DOWNTO 0);
	begin
		for Red_FSM in 0 to 255 loop
			Red_FSM_r := Red_FSM mod 16;
			FSM(3 downto 0) := LFInvTable((63-Red_FSM_r*4) downto (60-Red_FSM_r*4));
			
			Red_FSM_l := Red_FSM / 16;
			FSM(7 downto 4) := LFInvTable((63-Red_FSM_l*4) downto (60-Red_FSM_l*4));
			
			AddKey   	:= to_integer( unsigned'( "" & MakeSignalAddKey(FSM(6 downto 4) & FSM(2 downto 0))));
			Red_AddKey  := LFTable((63-AddKey*4) downto (60-AddKey*4));
			
			Red_AddKeyTable(255-Red_FSM) := Red_AddKey(BitNumber);
		end loop;
	  return Red_AddKeyTable;
	end MakeSignalAddKeyRedTable;

	---------

	function MakeSignaldoneRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Red_FSM            : NATURAL;
		variable Red_FSM_r          : NATURAL;
		variable Red_FSM_l          : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable done               : NATURAL;
		variable Red_done           : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_doneTable      : STD_LOGIC_VECTOR (255 DOWNTO 0);
	begin
		for Red_FSM in 0 to 255 loop
			Red_FSM_r := Red_FSM mod 16;
			FSM(3 downto 0) := LFInvTable((63-Red_FSM_r*4) downto (60-Red_FSM_r*4));
			
			Red_FSM_l := Red_FSM / 16;
			FSM(7 downto 4) := LFInvTable((63-Red_FSM_l*4) downto (60-Red_FSM_l*4));
			
			done     := to_integer( unsigned'( "" & MakeSignaldone(FSM(6 downto 4) & FSM(2 downto 0))));
			Red_done := LFTable((63-done*4) downto (60-done*4));
			
			Red_doneTable(255-Red_FSM) := Red_done(BitNumber);
		end loop;
	  return Red_doneTable;
	end MakeSignaldoneRedTable;

	
end functions;

