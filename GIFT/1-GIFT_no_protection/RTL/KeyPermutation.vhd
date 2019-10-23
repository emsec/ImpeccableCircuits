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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyPermutation is
	port(
		data_in	: in  std_logic_vector(127 downto 0);
		FSM		: in  std_logic_vector(5   downto 0);
		RoundKey	: out std_logic_vector(63  downto 0);
		data_out : out std_logic_vector(127 downto 0));
end entity KeyPermutation;

architecture behavioral of KeyPermutation is

	signal K0  : STD_LOGIC_VECTOR(15  downto 0);
	signal K1  : STD_LOGIC_VECTOR(15  downto 0);
	
begin

	K0 <= data_in (15 downto 0);
	K1 <= data_in (31 downto 16);
	
	RoundKey	<= "10" & K1(15) & K0(15) &
					"00" & K1(14) & K0(14) &
					"00" & K1(13) & K0(13) &
					"00" & K1(12) & K0(12) &
					"00" & K1(11) & K0(11) &
					"00" & K1(10) & K0(10) &
					"00" & K1(9) & K0(9) &
					"00" & K1(8) & K0(8) &
					"00" & K1(7) & K0(7) &
					"00" & K1(6) & K0(6) &
					FSM(5) & '0' & K1(5) & K0(5) &
					FSM(4) & '0' & K1(4) & K0(4) &
					FSM(3) & '0' & K1(3) & K0(3) &
					FSM(2) & '0' & K1(2) & K0(2) &
					FSM(1) & '0' & K1(1) & K0(1) &
					FSM(0) & '0' & K1(0) & K0(0);
					
	data_out <=	 data_in(17 downto 16) & data_in(31 downto 18) & data_in(11 downto 0) & data_in(15 downto 12) & data_in(127 downto 32);
					
end architecture behavioral;
