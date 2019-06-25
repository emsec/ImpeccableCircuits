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

entity ShiftRow is
	 generic ( size: positive := 8);
    Port ( in0 : in  STD_LOGIC_VECTOR (size*16-1 downto 0);
           q0 : out  STD_LOGIC_VECTOR (size*16-1 downto 0));
end ShiftRow;

architecture Behavioral of ShiftRow is

	signal s0, s1, s2, s3     : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	signal s4, s5, s6, s7     : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	signal s8, s9, s10, s11   : STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	signal s12, s13, s14, s15 : STD_LOGIC_VECTOR (size-1 DOWNTO 0);

begin
	
	s15	 	<= in0(size*16-1  downto  size*15);
	s14	 	<= in0(size*15-1  downto  size*14);
	s13	 	<= in0(size*14-1  downto  size*13);
	s12	 	<= in0(size*13-1  downto  size*12);
	s11	 	<= in0(size*12-1  downto  size*11);
	s10	 	<= in0(size*11-1  downto  size*10);
	s9	 		<= in0(size*10-1  downto  size*9);
	s8	 		<= in0(size*9-1   downto  size*8);
	s7	 		<= in0(size*8-1   downto  size*7);
	s6	 		<= in0(size*7-1   downto  size*6);
	s5 		<= in0(size*6-1   downto  size*5);
	s4 		<= in0(size*5-1   downto  size*4);
	s3 		<= in0(size*4-1   downto  size*3);
	s2 		<= in0(size*3-1   downto  size*2);
	s1 		<= in0(size*2-1   downto  size*1);
	s0 		<= in0(size*1-1   downto  size*0); 
	
	q0 <= s11 & s6 & s1 & s12 & s7 & s2 & s13 & s8 & s3 & s14 & s9 & s4 & s15 & s10 & s5 & s0; 

end Behavioral;

