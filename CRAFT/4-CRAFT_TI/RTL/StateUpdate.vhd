----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://doi.org/10.13154/tosc.v2019.i1.5-45 
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

entity StateUpdate is
	Generic (withDec : integer);
	Port ( FSM       : in  STD_LOGIC_VECTOR (7 downto 0);
			 EncDec	  : in  STD_LOGIC;
          FSMUpdate : out STD_LOGIC_VECTOR (7 downto 0));
end StateUpdate;

architecture Behavioral of StateUpdate is
begin

	GenwithoutDec: IF withDec = 0 GENERATE
		proc: process (FSM)
		begin
			IF FSM(3) = '0'  THEN
				FSMUpdate(0) <= FSM(0);
				FSMUpdate(1) <= FSM(1);
				FSMUpdate(2) <= FSM(2);
				FSMUpdate(3) <= '1';
				FSMUpdate(4) <= FSM(4);
				FSMUpdate(5) <= FSM(5);
				FSMUpdate(6) <= FSM(6);
				FSMUpdate(7) <= FSM(7);
			ELSE
				FSMUpdate(0) <= FSM(1);
				FSMUpdate(1) <= FSM(2);
				FSMUpdate(2) <= FSM(0) XOR FSM(1);
				FSMUpdate(3) <= '0';
				
				FSMUpdate(4) <= FSM(5);
				FSMUpdate(5) <= FSM(6);
				FSMUpdate(6) <= FSM(7);
				FSMUpdate(7) <= FSM(4) XOR FSM(5);
			END IF;	
		end process;
	END GENERATE;

	------------

	GenwithDec: IF withDec /= 0 GENERATE
		proc: process (EncDec, FSM)
		begin
			IF (EncDec = '0') THEN  --- Encryption
				IF FSM(3) = '0'  THEN
					FSMUpdate(0) <= FSM(0);
					FSMUpdate(1) <= FSM(1);
					FSMUpdate(2) <= FSM(2);
					FSMUpdate(3) <= '1';
					FSMUpdate(4) <= FSM(4);
					FSMUpdate(5) <= FSM(5);
					FSMUpdate(6) <= FSM(6);
					FSMUpdate(7) <= FSM(7);
				ELSE
					FSMUpdate(0) <= FSM(1);
					FSMUpdate(1) <= FSM(2);
					FSMUpdate(2) <= FSM(0) XOR FSM(1);
					FSMUpdate(3) <= '0';
					
					FSMUpdate(4) <= FSM(5);
					FSMUpdate(5) <= FSM(6);
					FSMUpdate(6) <= FSM(7);
					FSMUpdate(7) <= FSM(4) XOR FSM(5);
				END IF;	
			ELSE	--- Decryption
				IF FSM(3) = '0'  THEN
					FSMUpdate(0) <= FSM(0);
					FSMUpdate(1) <= FSM(1);
					FSMUpdate(2) <= FSM(2);
					FSMUpdate(3) <= '1';
					FSMUpdate(4) <= FSM(4);
					FSMUpdate(5) <= FSM(5);
					FSMUpdate(6) <= FSM(6);
					FSMUpdate(7) <= FSM(7);
				ELSE
					FSMUpdate(0) <= FSM(0) XOR FSM(2);
					FSMUpdate(1) <= FSM(0);
					FSMUpdate(2) <= FSM(1);
					FSMUpdate(3) <= '0';

					FSMUpdate(4) <= FSM(4) XOR FSM(7);
					FSMUpdate(5) <= FSM(4);
					FSMUpdate(6) <= FSM(5);
					FSMUpdate(7) <= FSM(6);
				END IF;	
			END IF;
		end process;	
	END GENERATE;

end Behavioral;

