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

	function MakeStateUpdate (
		FSM  	  	  : STD_LOGIC_VECTOR (4 DOWNTO 0))
		return STD_LOGIC_VECTOR ;		

	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeSignallastTable
		return STD_LOGIC_VECTOR ;
		
	function MakeSignaldoneTable
		return STD_LOGIC_VECTOR ;

	function MakeSignalsel_K_WKTable
		return STD_LOGIC_VECTOR ;

	function MakeSignalsel_K0_1Table
		return STD_LOGIC_VECTOR ;
		
end functions;

package body functions is	

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
	
end functions;

