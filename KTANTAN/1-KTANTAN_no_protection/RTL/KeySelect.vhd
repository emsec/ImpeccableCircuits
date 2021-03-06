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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY KeySelect IS
	PORT ( 
		FSM	: IN  STD_LOGIC_VECTOR (7  DOWNTO 0);
		Key	: IN  STD_LOGIC_VECTOR (79 DOWNTO 0);
		Ka		: OUT STD_LOGIC;
		Kb		: OUT STD_LOGIC);			 
END KeySelect;

ARCHITECTURE behavioral OF KeySelect IS

	signal a      		: std_logic_vector(4 downto 0);
	signal FSM10Inv 	: std_logic_vector(1 downto 0);
	signal F1, F2 		: std_logic;

BEGIN

  Proc1 : process (Key, FSM)
  begin
		a(0)	<=	 Key(0  + to_integer(unsigned(FSM(7 downto 4))));
		a(1)	<=	 Key(16 + to_integer(unsigned(FSM(7 downto 4))));
		a(2)	<=	 Key(32 + to_integer(unsigned(FSM(7 downto 4))));
		a(3)	<=	 Key(48 + to_integer(unsigned(FSM(7 downto 4))));
		a(4)	<=	 Key(64 + to_integer(unsigned(FSM(7 downto 4))));
  end process;	

  FSM10Inv <= (NOT (FSM(1))) & (NOT FSM(0));

  Proc2 : process (a, FSM, FSM10Inv)
  begin
		F1		<=	 a(1 + to_integer(unsigned(FSM(1 downto 0))));
		F2		<=	 a(0 + to_integer(unsigned(FSM10Inv)));
  end process;	

	Ka	<= a(0) when FSM(3 downto 2) = "00" else F1;
	Kb <= a(4) when FSM(3 downto 2) = "01" else F2;
	
END;

