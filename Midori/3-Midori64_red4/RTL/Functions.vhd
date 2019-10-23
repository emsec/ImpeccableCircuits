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
		
	function MakeStateUpdate (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC_VECTOR ;		

	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeStateUpdateRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR;

	function MakeSignallastTable
		return STD_LOGIC_VECTOR ;
		
	function MakeSignaldoneTable
		return STD_LOGIC_VECTOR ;

	function MakeSignalsel_K_WKTable
		return STD_LOGIC_VECTOR ;

	function MakeSignalsel_K0_1Table
		return STD_LOGIC_VECTOR ;
		
	function MakeSignallastRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;

	function MakeSignaldoneRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;

	function MakeSignalsel_K_WKRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR ;

	function MakeSignalsel_K0_1RedTable (
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
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSMUpdate : STD_LOGIC_VECTOR (4 DOWNTO 0);
		variable en   : STD_LOGIC;
	begin
		en := FSM(4) NAND FSM(0);

		IF (en = '1') THEN
			FSMUpdate(0) := NOT FSM(0);
			FSMUpdate(1) := FSM(1) XOR FSM(0);
			FSMUpdate(2) := FSM(2) XOR (FSM(0) AND FSM(1));
			FSMUpdate(3) := FSM(3) XOR (FSM(0) AND FSM(1) AND FSM(2));
			FSMUpdate(4) := FSM(4) XOR (FSM(0) AND FSM(1) AND FSM(2) AND FSM(3));
		ELSE
			FSMUpdate(0) := FSM(0);
			FSMUpdate(1) := FSM(1);
			FSMUpdate(2) := FSM(2);
			FSMUpdate(3) := FSM(3);
			FSMUpdate(4) := FSM(4);
		END IF;
	  return FSMUpdate;
	end MakeStateUpdate;	
	
	-----

	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable FSMUpdateTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable FSMUpdate      : STD_LOGIC_VECTOR (4  DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			FSMUpdate := MakeStateUpdate(std_logic_vector(to_unsigned(i,5)));
			FSMUpdateTable(31-i) := FSMUpdate(BitNumber);
		end loop;
	  return FSMUpdateTable;
	end MakeStateUpdateTable;	

	-------------------------------
	
	function MakeStateUpdateRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Red_FSM            : NATURAL;
		variable Red_FSM_r          : NATURAL;
		variable Red_FSM_l          : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable FSMUpdate          : STD_LOGIC_VECTOR (4 DOWNTO 0);
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
			
			FSMUpdate(4 downto 0) := MakeStateUpdate(FSM(4 downto 0));
			FSMupdate_l := to_integer(unsigned'("" & FSMUpdate(4)));
			FSMupdate_r := to_integer(unsigned(FSMUpdate(3 downto 0)));
			
			Red_FSMUpdate(3 downto 0) := LFTable((63-FSMupdate_r*4) downto (60-FSMupdate_r*4));
			Red_FSMUpdate(7 downto 4) := LFTable((63-FSMupdate_l*4) downto (60-FSMupdate_l*4));
			
			Red_FSMUpdateTable(255-Red_FSM) := Red_FSMUpdate(BitNumber);
		end loop;
	  return Red_FSMUpdateTable;
	end MakeStateUpdateRedTable;
	
	-------------------------------

	function MakeSignallast (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC is
		variable last : STD_LOGIC;
	begin
		IF (FSM(3 downto 0) = "1111") THEN
			last := '1';
		ELSE
			last := '0';
		END IF;
		return last;
	end MakeSignallast;	
	
	-----

	function MakeSignaldone (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC is
		variable done : STD_LOGIC;
	begin
		IF ((FSM(4) = '1') AND (FSM(0) = '0')) THEN
			done := '1';
		ELSE 
			done := '0';
		END IF;	
		return done;
	end MakeSignaldone;	

	-----

	function MakeSignalsel_K_WK (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC is
		variable sel_K_WK : STD_LOGIC;
	begin
		IF (FSM(3 downto 0) = "0000") THEN
			sel_K_WK	:= '1';
		ELSE
			sel_K_WK	:= '0';
		END IF;	
		return sel_K_WK;
	end MakeSignalsel_K_WK;	

	-----
	
	function MakeSignalsel_K0_1 (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC is
		variable sel_K0_1 : STD_LOGIC;
	begin
		sel_K0_1 := FSM(0);
		return sel_K0_1;
	end MakeSignalsel_K0_1;	

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
	
	------
	
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
	
	------
	
	function MakeSignalsel_K_WKTable
		return STD_LOGIC_VECTOR is
		variable sel_K_WKTable : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			sel_K_WKTable(31-i) := MakeSignalsel_K_WK(std_logic_vector(to_unsigned(i,5)));
		end loop;
	  return sel_K_WKTable;
	end MakeSignalsel_K_WKTable;	

	------
	
	function MakeSignalsel_K0_1Table
		return STD_LOGIC_VECTOR is
		variable sel_K0_1Table : STD_LOGIC_VECTOR (31 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 31 loop
			sel_K0_1Table(31-i) := MakeSignalsel_K0_1(std_logic_vector(to_unsigned(i,5)));
		end loop;
	  return sel_K0_1Table;
	end MakeSignalsel_K0_1Table;	
	
	--------------------------------------

	function MakeSignallastRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Red_FSM            : NATURAL;
		variable Red_FSM_r          : NATURAL;
		variable Red_FSM_l          : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable last               : NATURAL;
		variable Red_last           : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_lastTable      : STD_LOGIC_VECTOR (255 DOWNTO 0);
	begin
		for Red_FSM in 0 to 255 loop
			Red_FSM_r := Red_FSM mod 16;
			FSM(3 downto 0) := LFInvTable((63-Red_FSM_r*4) downto (60-Red_FSM_r*4));
			
			Red_FSM_l := Red_FSM / 16;
			FSM(7 downto 4) := LFInvTable((63-Red_FSM_l*4) downto (60-Red_FSM_l*4));
			
			last     := to_integer( unsigned'( "" & MakeSignallast(FSM(4 downto 0))));
			Red_last := LFTable((63-last*4) downto (60-last*4));
			
			Red_lastTable(255-Red_FSM) := Red_last(BitNumber);
		end loop;
	  return Red_lastTable;
	end MakeSignallastRedTable;

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
			
			done     := to_integer( unsigned'( "" & MakeSignaldone(FSM(4 downto 0))));
			Red_done := LFTable((63-done*4) downto (60-done*4));
			
			Red_doneTable(255-Red_FSM) := Red_done(BitNumber);
		end loop;
	  return Red_doneTable;
	end MakeSignaldoneRedTable;

	---------
	
	function MakeSignalsel_K_WKRedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Red_FSM            : NATURAL;
		variable Red_FSM_r          : NATURAL;
		variable Red_FSM_l          : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable sel_K_WK           : NATURAL;
		variable Red_sel_K_WK       : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_sel_K_WKTable  : STD_LOGIC_VECTOR (255 DOWNTO 0);
	begin
		for Red_FSM in 0 to 255 loop
			Red_FSM_r := Red_FSM mod 16;
			FSM(3 downto 0) := LFInvTable((63-Red_FSM_r*4) downto (60-Red_FSM_r*4));
			
			Red_FSM_l := Red_FSM / 16;
			FSM(7 downto 4) := LFInvTable((63-Red_FSM_l*4) downto (60-Red_FSM_l*4));
			
			sel_K_WK     := to_integer( unsigned'( "" & MakeSignalsel_K_WK(FSM(4 downto 0))));
			Red_sel_K_WK := LFTable((63-sel_K_WK*4) downto (60-sel_K_WK*4));
			
			Red_sel_K_WKTable(255-Red_FSM) := Red_sel_K_WK(BitNumber);
		end loop;
	  return Red_sel_K_WKTable;
	end MakeSignalsel_K_WKRedTable;

	---------	
	
	function MakeSignalsel_K0_1RedTable (
		BitNumber  : NATURAL;
		LFTable	  : STD_LOGIC_VECTOR (63 DOWNTO 0);
		LFInvTable : STD_LOGIC_VECTOR (63 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable Red_FSM            : NATURAL;
		variable Red_FSM_r          : NATURAL;
		variable Red_FSM_l          : NATURAL;
		variable FSM    	          : STD_LOGIC_VECTOR (7 DOWNTO 0);
		variable sel_K0_1           : NATURAL;
		variable Red_sel_K0_1       : STD_LOGIC_VECTOR (3 DOWNTO 0);
		variable Red_sel_K0_1Table  : STD_LOGIC_VECTOR (255 DOWNTO 0);
	begin
		for Red_FSM in 0 to 255 loop
			Red_FSM_r := Red_FSM mod 16;
			FSM(3 downto 0) := LFInvTable((63-Red_FSM_r*4) downto (60-Red_FSM_r*4));
			
			Red_FSM_l := Red_FSM / 16;
			FSM(7 downto 4) := LFInvTable((63-Red_FSM_l*4) downto (60-Red_FSM_l*4));
			
			sel_K0_1     := to_integer( unsigned'( "" & MakeSignalsel_K0_1(FSM(4 downto 0))));
			Red_sel_K0_1 := LFTable((63-sel_K0_1*4) downto (60-sel_K0_1*4));
			
			Red_sel_K0_1Table(255-Red_FSM) := Red_sel_K0_1(BitNumber);
		end loop;
	  return Red_sel_K0_1Table;
	end MakeSignalsel_K0_1RedTable;

	---------	

end functions;

