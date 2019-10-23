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

	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeGF16_MulTable ( 
		c 			 : STD_LOGIC_VECTOR (3 DOWNTO 0);
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

end functions;

package body functions is	

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
	
end functions;

