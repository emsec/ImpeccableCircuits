----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://doi.org/10.13154/tosc.v2019.i1.5-45 
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Christof Beierle, Gregor Leander, Amir Moradi, Shahram Rasoolzadeh 
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

ENTITY LookUp4x16 IS
	GENERIC ( Table : STD_LOGIC_VECTOR(63 DOWNTO 0));
	PORT ( input:  IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 output: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END LookUp4x16;

ARCHITECTURE behavioral OF LookUp4x16 IS
BEGIN

	tableprocess: Process (input)
	begin
		case input is
		  when "0000" =>   output <= Table(63 downto 60);
		  when "0001" =>   output <= Table(59 downto 56);
		  when "0010" =>   output <= Table(55 downto 52);
		  when "0011" =>   output <= Table(51 downto 48);
		  when "0100" =>   output <= Table(47 downto 44);
		  when "0101" =>   output <= Table(43 downto 40);
		  when "0110" =>   output <= Table(39 downto 36);
		  when "0111" =>   output <= Table(35 downto 32);
		  when "1000" =>   output <= Table(31 downto 28);
		  when "1001" =>   output <= Table(27 downto 24);
		  when "1010" =>   output <= Table(23 downto 20);
		  when "1011" =>   output <= Table(19 downto 16);
		  when "1100" =>   output <= Table(15 downto 12);
		  when "1101" =>   output <= Table(11 downto  8);
		  when "1110" =>   output <= Table( 7 downto  4);
		  when others =>   output <= Table( 3 downto  0);
		end case;
	end process;			
			
END behavioral;

