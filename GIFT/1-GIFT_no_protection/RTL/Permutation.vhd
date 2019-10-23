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

entity Permutation is
	port(
		data_in	: in  std_logic_vector(63 downto 0);
		data_out : out std_logic_vector(63 downto 0));
end entity Permutation;

architecture behavioral of Permutation is

begin

	data_out <=	data_in(51) & data_in(62) & data_in(57) & data_in(52) & 
					data_in(35) & data_in(46) & data_in(41) & data_in(36) & 
					data_in(19) & data_in(30) & data_in(25) & data_in(20) & 
					data_in(3)  & data_in(14) & data_in(9)  & data_in(4)  & 
					data_in(55) & data_in(50) & data_in(61) & data_in(56) & 
					data_in(39) & data_in(34) & data_in(45) & data_in(40) & 
					data_in(23) & data_in(18) & data_in(29) & data_in(24) & 
					data_in(7)  & data_in(2)  & data_in(13) & data_in(8)  & 
					data_in(59) & data_in(54) & data_in(49) & data_in(60) & 
					data_in(43) & data_in(38) & data_in(33) & data_in(44) & 
					data_in(27) & data_in(22) & data_in(17) & data_in(28) & 
					data_in(11) & data_in(6)  & data_in(1)  & data_in(12) & 
					data_in(63) & data_in(58) & data_in(53) & data_in(48) & 
					data_in(47) & data_in(42) & data_in(37) & data_in(32) & 
					data_in(31) & data_in(26) & data_in(21) & data_in(16) & 
					data_in(15) & data_in(10) & data_in(5)  & data_in(0);
					
end architecture behavioral;
