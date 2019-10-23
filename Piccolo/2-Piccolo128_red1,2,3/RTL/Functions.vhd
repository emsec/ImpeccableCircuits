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

package functions is

	function GoF (
		GTable  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		FTable  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;

	function GetDistance (
		Red_size	 : NATURAL;
		LFTable 	 : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return NATURAL;

	-------

	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeGF16_MulTable ( 
		Table	    : STD_LOGIC_VECTOR (63 DOWNTO 0);
		c 			 : STD_LOGIC_VECTOR ( 3 DOWNTO 0);
		BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeSignallastTable
		return STD_LOGIC_VECTOR ;

	function MakeSignaldoneTable
		return STD_LOGIC_VECTOR ;

	function MakeSignalWhiteningKeySelTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeSignalKeySelLeftTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeSignalKeySelRightTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	-------
	
	function MakeGF16_MulRedTable ( 
		Table	  	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		c          : STD_LOGIC_VECTOR ( 3 DOWNTO 0);
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
	
	function MakeStateUpdateRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
	

	function MakeSignallastRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
	function MakeSignaldoneRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
	function MakeSignalWhiteningKeySelRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
	function MakeSignalKeySelLeftRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
	function MakeSignalKeySelRightRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
	function MakeRedRoundConstLeftTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
	function MakeRedRoundConstRightTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;
		
end functions;

package body functions is	

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
		
	--------

	function MakeStateUpdate (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSMUpdate : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable en        : STD_LOGIC;
	begin
		if (FSM(4) OR FSM(3) OR FSM(2) OR FSM(1) OR FSM(0)) = '0' then
			en := '0';
		else
			en := '1';
		end if;	
		
		FSMUpdate(0) := FSM(0) XOR  en;
		FSMUpdate(1) := FSM(1) XOR  FSM(0);
		FSMUpdate(2) := FSM(2) XOR (FSM(0) AND FSM(1));
		FSMUpdate(3) := FSM(3) XOR (FSM(0) AND FSM(1) AND FSM(2));
		FSMUpdate(4) := FSM(4) XOR (FSM(0) AND FSM(1) AND FSM(2) AND FSM(3));
		
		return FSMUpdate;
	end MakeStateUpdate;	
	
	-----

	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable FSMUpdateTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable FSMUpdate      : STD_LOGIC_VECTOR (4  DOWNTO 0);
		variable i              : NATURAL;
	begin
		for i in 0 to 31 loop
			FSMUpdate := MakeStateUpdate(std_logic_vector(to_unsigned(i,5)));
			FSMUpdateTable(31-i) := FSMUpdate(BitNumber);
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
		Table	    : STD_LOGIC_VECTOR (63 DOWNTO 0);
		c         : STD_LOGIC_VECTOR ( 3 DOWNTO 0);
		BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable MulInput       : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable GF16_MulTable  : STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable y              : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 15 loop
			MulInput := Table((63-i*4) downto (60-i*4));
			y := GF16_Mul(MulInput, c);
			GF16_MulTable(15-i) := y(BitNumber);
		end loop;
	  return GF16_MulTable;
	end MakeGF16_MulTable;	

	-------------------------------

	function MakeSignallast (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC is
		variable last : STD_LOGIC;
	begin
		IF (FSM(4) AND FSM(3) AND FSM(2) AND FSM(1) AND FSM(0)) = '1' THEN
			last := '1';
		ELSE 
			last := '0';
		END IF;	
		return last;
	end MakeSignallast;	

	----------------
	
	function MakeSignallastTable
		return STD_LOGIC_VECTOR is
		variable lastTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			lastTable(31-i) := MakeSignallast(std_logic_vector(to_unsigned(i,5)));
		end loop;
	  return lastTable;
	end MakeSignallastTable;	
	
	-------------------------------

	function MakeSignaldone (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC is
		variable done : STD_LOGIC;
	begin
		IF (FSM(4) OR FSM(3) OR FSM(2) OR FSM(1) OR FSM(0)) = '0' THEN
			done := '1';
		ELSE 
			done := '0';
		END IF;	
		return done;
	end MakeSignaldone;	

	----------------
	
	function MakeSignaldoneTable
		return STD_LOGIC_VECTOR is
		variable doneTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			doneTable(31-i) := MakeSignaldone(std_logic_vector(to_unsigned(i,5)));
		end loop;
	  return doneTable;
	end MakeSignaldoneTable;	
	
	-------------------------------

	function MakeSignalWhiteningKeySel (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable WhiteningKey : STD_LOGIC_VECTOR(1 DOWNTO 0);
	begin

		WhiteningKey(0) := NOT FSM(0);
		
		if (FSM = "00001" OR FSM = "00000") then
			WhiteningKey(1) := '0';
		else
			WhiteningKey(1) := '1';
		end if;	
		
		return WhiteningKey;
	end MakeSignalWhiteningKeySel;	

	----------------
	
	function MakeSignalWhiteningKeySelTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable WhiteningKeySelTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable WhiteningKeySel      : STD_LOGIC_VECTOR ( 1 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			WhiteningKeySel 				:= MakeSignalWhiteningKeySel(std_logic_vector(to_unsigned(i,5)));
			WhiteningKeySelTable(31-i) := WhiteningKeySel(BitNumber);
		end loop;
	  return WhiteningKeySelTable;
	end MakeSignalWhiteningKeySelTable;		
	
	
	-------------------------------

	function MakeSignalKeySelLeft (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable KeySelLeft : STD_LOGIC_VECTOR(1 DOWNTO 0);
	begin

		if FSM = "00001"then
			KeySelLeft := "01";
		elsif	FSM = "00010"then
			KeySelLeft := "10";
		elsif	FSM = "00011"then
			KeySelLeft := "11";
		elsif	FSM = "00100"then
			KeySelLeft := "01";
		elsif	FSM = "00101"then
			KeySelLeft := "11";
		elsif	FSM = "00110"then
			KeySelLeft := "00";
		elsif	FSM = "00111"then
			KeySelLeft := "10";  
		elsif	FSM = "01000"then
			KeySelLeft := "11"; 
		elsif	FSM = "01001"then
			KeySelLeft := "10"; 
		elsif	FSM = "01010"then
			KeySelLeft := "01"; 
		elsif	FSM = "01011"then
			KeySelLeft := "00"; 
		elsif	FSM = "01100"then
			KeySelLeft := "10"; 
		elsif	FSM = "01101"then
			KeySelLeft := "00"; 
		elsif	FSM = "01110"then
			KeySelLeft := "11"; 
		elsif	FSM = "01111"then
			KeySelLeft := "01"; 
		elsif	FSM = "10000"then
			KeySelLeft := "00"; 
		elsif	FSM = "10001"then
			KeySelLeft := "01"; 
		elsif	FSM = "10010"then
			KeySelLeft := "10"; 
		elsif	FSM = "10011"then
			KeySelLeft := "11"; 
		elsif	FSM = "10100"then
			KeySelLeft := "01"; 
		elsif	FSM = "10101"then
			KeySelLeft := "11"; 
		elsif	FSM = "10110"then
			KeySelLeft := "00"; 
		elsif	FSM = "10111"then
			KeySelLeft := "10"; 
		elsif	FSM = "11000"then
			KeySelLeft := "11"; 
		elsif	FSM = "11001"then
			KeySelLeft := "10"; 
		elsif	FSM = "11010"then
			KeySelLeft := "01"; 
		elsif	FSM = "11011"then
			KeySelLeft := "00"; 
		elsif	FSM = "11100"then
			KeySelLeft := "10"; 
		elsif	FSM = "11101"then
			KeySelLeft := "00"; 
		elsif	FSM = "11110"then
			KeySelLeft := "11"; 
		else
			KeySelLeft := "01";
		end if;
		
		return KeySelLeft;
	end MakeSignalKeySelLeft;	

	----------------
	
	function MakeSignalKeySelLeftTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable KeySelLeftTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable KeySelLeft      : STD_LOGIC_VECTOR ( 1 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			KeySelLeft 				 := MakeSignalKeySelLeft(std_logic_vector(to_unsigned(i,5)));
			KeySelLeftTable(31-i) := KeySelLeft(BitNumber);
		end loop;
	  return KeySelLeftTable;
	end MakeSignalKeySelLeftTable;			
	
	-------------------------------

	function MakeSignalKeySelRight (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable KeySelRight : STD_LOGIC_VECTOR(1 DOWNTO 0);
	begin

		if FSM = "00001"then
			KeySelRight := "01";
		elsif	FSM = "00010"then
			KeySelRight := "10";
		elsif	FSM = "00011"then
			KeySelRight := "11";
		elsif	FSM = "00100"then
			KeySelRight := "00";
		elsif	FSM = "00101"then
			KeySelRight := "11";
		elsif	FSM = "00110"then
			KeySelRight := "01";
		elsif	FSM = "00111"then
			KeySelRight := "10";  
		elsif	FSM = "01000"then
			KeySelRight := "00"; 
		elsif	FSM = "01001"then
			KeySelRight := "10"; 
		elsif	FSM = "01010"then
			KeySelRight := "11"; 
		elsif	FSM = "01011"then
			KeySelRight := "01"; 
		elsif	FSM = "01100"then
			KeySelRight := "00"; 
		elsif	FSM = "01101"then
			KeySelRight := "01"; 
		elsif	FSM = "01110"then
			KeySelRight := "10"; 
		elsif	FSM = "01111"then
			KeySelRight := "11"; 
		elsif	FSM = "10000"then
			KeySelRight := "00"; 
		elsif	FSM = "10001"then
			KeySelRight := "11"; 
		elsif	FSM = "10010"then
			KeySelRight := "01"; 
		elsif	FSM = "10011"then
			KeySelRight := "10"; 
		elsif	FSM = "10100"then
			KeySelRight := "00"; 
		elsif	FSM = "10101"then
			KeySelRight := "10"; 
		elsif	FSM = "10110"then
			KeySelRight := "11"; 
		elsif	FSM = "10111"then
			KeySelRight := "01"; 
		elsif	FSM = "11000"then
			KeySelRight := "00"; 
		elsif	FSM = "11001"then
			KeySelRight := "01"; 
		elsif	FSM = "11010"then
			KeySelRight := "10"; 
		elsif	FSM = "11011"then
			KeySelRight := "11"; 
		elsif	FSM = "11100"then
			KeySelRight := "00"; 
		elsif	FSM = "11101"then
			KeySelRight := "11"; 
		elsif	FSM = "11110"then
			KeySelRight := "01"; 
		else
			KeySelRight := "10";
		end if;
		
		return KeySelRight;
	end MakeSignalKeySelRight;	

	----------------
	
	function MakeSignalKeySelRightTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable KeySelRightTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable KeySelRight      : STD_LOGIC_VECTOR ( 1 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			KeySelRight 			 	:= MakeSignalKeySelRight(std_logic_vector(to_unsigned(i,5)));
			KeySelRightTable(31-i) 	:= KeySelRight(BitNumber);
		end loop;
	  return KeySelRightTable;
	end MakeSignalKeySelRightTable;		
	
	-----==========================================================================
	
	function MakeGF16_MulRedTable ( 
		Table	  	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		c          : STD_LOGIC_VECTOR ( 3 DOWNTO 0);
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable GF16_MulRedTable   : STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable Fin                : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable y                  : NATURAL;
		variable FRed               : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable i                  : NATURAL;
	begin
		for i in 0 to 15 loop
			Fin  := Table((63-i*4) downto (60-i*4));
			y    := to_integer(unsigned(GF16_Mul(Fin, c)));
			FRed := LFTable((63-y*4) downto (60-y*4));
			
			GF16_MulRedTable(15-i) := FRed(BitNumber);
		end loop;
	  return GF16_MulRedTable;
	end MakeGF16_MulRedTable;	
	
	----------
	
	function MakeStateUpdateRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable i                  : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable FSMUpdate          : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable FSMupdate_l        : NATURAL;
		variable FSMupdate_r        : NATURAL;
		variable Red_FSMUpdate      : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable Red_FSMUpdateTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
	begin
		for i in 0 to 31 loop
			FSM := std_logic_vector(to_unsigned(i, 5));
			
			FSMUpdate(4 downto 0) := MakeStateUpdate(FSM(4 downto 0));
			FSMupdate_l := to_integer(unsigned("000" & FSMUpdate(4 downto 4)));
			FSMupdate_r := to_integer(unsigned(FSMUpdate(3 downto 0)));
			
			Red_FSMUpdate(3 downto 0) := LFTable((63-FSMupdate_r*4) downto (60-FSMupdate_r*4));
			Red_FSMUpdate(7 downto 4) := LFTable((63-FSMupdate_l*4) downto (60-FSMupdate_l*4));
			
			Red_FSMUpdateTable(31-i) := Red_FSMUpdate(BitNumber);
		end loop;
	  return Red_FSMUpdateTable;
	end MakeStateUpdateRedTable;
	
	-----
	
	function MakeSignallastRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSM    	     : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable last			  : NATURAL;
		variable Red_last      : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_lastTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			FSM := std_logic_vector(to_unsigned(i, 5));
			
			last		:= to_integer(unsigned'("" & MakeSignallast(FSM(4 DOWNTO 0))));
			Red_last := LFTable((63-last*4) downto (60-last*4));

			Red_lastTable(31-i) := Red_last(BitNumber);
		end loop;
	  return Red_lastTable;
	end MakeSignallastRedTable;	
	
	----

	function MakeSignaldoneRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSM    	     : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable done			  : NATURAL;
		variable Red_done      : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_doneTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			FSM := std_logic_vector(to_unsigned(i, 5));
			
			done		:= to_integer(unsigned'("" & MakeSignaldone(FSM(4 DOWNTO 0))));
			Red_done := LFTable((63-done*4) downto (60-done*4));

			Red_doneTable(31-i) := Red_done(BitNumber);
		end loop;
	  return Red_doneTable;
	end MakeSignaldoneRedTable;	

	----
	
	function MakeSignalWhiteningKeySelRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSM    	     : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable WhiteningKeySel		 	 : STD_LOGIC_VECTOR (1 DOWNTO 0);
		variable WhiteningKeySelInt		 : NATURAL;
		variable Red_WhiteningKeySel      : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_WhiteningKeySelTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			FSM := std_logic_vector(to_unsigned(i, 5));
			
			WhiteningKeySel		:= MakeSignalWhiteningKeySel(FSM(4 DOWNTO 0));

			if (BitNumber < 4) then
				WhiteningKeySelInt  := to_integer(unsigned'("" & WhiteningKeySel(0)));
				Red_WhiteningKeySel := LFTable((63-WhiteningKeySelInt*4) downto (60-WhiteningKeySelInt*4));
				Red_WhiteningKeySelTable(31-i) := Red_WhiteningKeySel(BitNumber);
			else
				WhiteningKeySelInt  := to_integer(unsigned'("" & WhiteningKeySel(1)));
				Red_WhiteningKeySel := LFTable((63-WhiteningKeySelInt*4) downto (60-WhiteningKeySelInt*4));
				Red_WhiteningKeySelTable(31-i) := Red_WhiteningKeySel(BitNumber-4);
			end if;
		end loop;
	  return Red_WhiteningKeySelTable;
	end MakeSignalWhiteningKeySelRedTable;	

	----

	function MakeSignalKeySelLeftRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSM    	     : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable KeySelLeft   		 : STD_LOGIC_VECTOR (1 DOWNTO 0);
		variable KeySelLeftInt		 : NATURAL;
		variable Red_KeySelLeft      : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_KeySelLeftTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			FSM := std_logic_vector(to_unsigned(i, 5));
			
			KeySelLeft		:= MakeSignalKeySelLeft(FSM(4 DOWNTO 0));

			if (BitNumber < 4) then
				KeySelLeftInt  := to_integer(unsigned'("" & KeySelLeft(0)));
				Red_KeySelLeft := LFTable((63-KeySelLeftInt*4) downto (60-KeySelLeftInt*4));
				Red_KeySelLeftTable(31-i) := Red_KeySelLeft(BitNumber);
			else
				KeySelLeftInt  := to_integer(unsigned'("" & KeySelLeft(1)));
				Red_KeySelLeft := LFTable((63-KeySelLeftInt*4) downto (60-KeySelLeftInt*4));
				Red_KeySelLeftTable(31-i) := Red_KeySelLeft(BitNumber-4);
			end if;
		end loop;
	  return Red_KeySelLeftTable;
	end MakeSignalKeySelLeftRedTable;	
	
	----
	
	function MakeSignalKeySelRightRedTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSM    	     : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable KeySelRight 		 : STD_LOGIC_VECTOR (1 DOWNTO 0);
		variable KeySelRightInt		 : NATURAL;
		variable Red_KeySelRight      : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_KeySelRightTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			FSM := std_logic_vector(to_unsigned(i, 5));
			
			KeySelRight		:= MakeSignalKeySelRight(FSM(4 DOWNTO 0));

			if (BitNumber < 4) then
				KeySelRightInt  := to_integer(unsigned'("" & KeySelRight(0)));
				Red_KeySelRight := LFTable((63-KeySelRightInt*4) downto (60-KeySelRightInt*4));
				Red_KeySelRightTable(31-i) := Red_KeySelRight(BitNumber);
			else
				KeySelRightInt  := to_integer(unsigned'("" & KeySelRight(1)));
				Red_KeySelRight := LFTable((63-KeySelRightInt*4) downto (60-KeySelRightInt*4));
				Red_KeySelRightTable(31-i) := Red_KeySelRight(BitNumber-4);
			end if;
		end loop;
	  return Red_KeySelRightTable;
	end MakeSignalKeySelRightRedTable;		
	
	----
	
	function MakeRedRoundConstLeftTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSM    	     : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable RedRoundConstLeft 		: STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable RedRoundConstLeftTable 	: STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i,j   : NATURAL;
	begin
		for i in 0 to 31 loop
			FSM := std_logic_vector(to_unsigned(i, 5));
			
			j := to_integer(unsigned(FSM(2 downto 0) & "0"));
			RedRoundConstLeft(3 downto 0) := LFTable((63-j*4) downto (60-j*4));

			j := to_integer(unsigned("00" & FSM(4 downto 3)));
			RedRoundConstLeft(7 downto 4) := LFTable((63-j*4) downto (60-j*4));

			j := to_integer(unsigned(FSM(0 downto 0) & "000"));
			RedRoundConstLeft(11 downto 8) := LFTable((63-j*4) downto (60-j*4));

			j := to_integer(unsigned(FSM(4 downto 1)));
			RedRoundConstLeft(15 downto 12) := LFTable((63-j*4) downto (60-j*4));

			RedRoundConstLeftTable(31-i) := RedRoundConstLeft(BitNumber);
		end loop;
	  return RedRoundConstLeftTable;
	end MakeRedRoundConstLeftTable;			
	
	----
	
	function MakeRedRoundConstRightTable(
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Red_FSM_r     : NATURAL;
		variable Red_FSM_l     : NATURAL;
		variable FSM    	     : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable RedRoundConstRight 		: STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable RedRoundConstRightTable	: STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i,j   : NATURAL;
	begin
		for i in 0 to 31 loop
			FSM := std_logic_vector(to_unsigned(i, 5));
			
			j := to_integer(unsigned(FSM(1 downto 0) & "00"));
			RedRoundConstRight(11 downto 8) := LFTable((63-j*4) downto (60-j*4));

			j := to_integer(unsigned("0" & FSM(4 downto 2)));
			RedRoundConstRight(15 downto 12) := LFTable((63-j*4) downto (60-j*4));

			RedRoundConstRightTable(31-i) := RedRoundConstRight(BitNumber);
		end loop;
	  return RedRoundConstRightTable;
	end MakeRedRoundConstRightTable;			
	
end functions;



