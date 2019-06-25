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

entity RoundConstXOR is
	GENERIC ( size  : POSITIVE;
				 LFC   : STD_LOGIC_VECTOR(3 downto 0) := (others => '0'));
	PORT ( R_in0 	 : IN  STD_LOGIC_VECTOR ((size*16-1)  DOWNTO 0);
			 R_in1 	 : IN  STD_LOGIC_VECTOR ((size*3-1)  DOWNTO 0);
			 R_q 	    : OUT STD_LOGIC_VECTOR ((size*16-1)  DOWNTO 0));

end RoundConstXOR;

	architecture Behavioral of RoundConstXOR is

	SIGNAL tmp1: STD_LOGIC_VECTOR ((size*3-1) DOWNTO 0);
	SIGNAL tmp2: STD_LOGIC_VECTOR ((size*3-1) DOWNTO 0);
	SIGNAL tmp3: STD_LOGIC_VECTOR ((size*3-1) DOWNTO 0);

		begin

		--tmp1 <= R_in0(31 downto 28) & R_in0(47 downto 44) & R_in0(63 downto 60);
		tmp1 <= R_in0((size*8-1) downto (size*7)) & R_in0((size*12-1) downto (size*11)) & R_in0((size*16-1) downto (size*15));
		tmp2 <= R_in1;


			AddConstXOR: ENTITY work.XOR_2n 
					GENERIC Map ( size => size, count => 3)
						PORT Map ( tmp1,tmp2,tmp3, LFC(size-1 downto 0));
------------------------------------------------------------------------------------------------
					
			R_q((size*16-1) DOWNTO (size*15)) <= tmp3(size-1 DOWNTO 0);
			R_q((size*15-1) DOWNTO (size*12)) <= R_in0((size*15-1) DOWNTO (size*12));
			R_q((size*12-1) downto (size*11)) <= tmp3((size*2-1) DOWNTO size);
			R_q((size*11-1) DOWNTO (size*8))  <= R_in0((size*11-1) DOWNTO (size*8));
			R_q((size*8-1) downto (size*7))   <= tmp3((size*3-1) DOWNTO (size*2));			
			R_q((size*7-1) DOWNTO  0)         <= R_in0((size*7-1) DOWNTO  0);
			
			

end Behavioral;

