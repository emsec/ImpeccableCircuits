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
use work.functions.all;

entity RedRow0MixColumn is
	generic(Red_size : positive;
	        Table : STD_LOGIC_VECTOR (2047 DOWNTO 0));
    Port ( in0 : in  STD_LOGIC_VECTOR (7 downto 0);
           in1 : in  STD_LOGIC_VECTOR (7 downto 0);
           in2 : in  STD_LOGIC_VECTOR (Red_size-1 downto 0);
           in3 : in  STD_LOGIC_VECTOR (Red_size-1 downto 0);
           q   : out STD_LOGIC_VECTOR (Red_size-1 downto 0));
end RedRow0MixColumn;

architecture Behavioral of RedRow0MixColumn is
	constant Mult2Table  : STD_LOGIC_VECTOR (2047 DOWNTO 0) := x"00020406080a0c0e10121416181a1c1e20222426282a2c2e30323436383a3c3e40424446484a4c4e50525456585a5c5e60626466686a6c6e70727476787a7c7e80828486888a8c8e90929496989a9c9ea0a2a4a6a8aaacaeb0b2b4b6b8babcbec0c2c4c6c8caccced0d2d4d6d8dadcdee0e2e4e6e8eaeceef0f2f4f6f8fafcfe1b191f1d131117150b090f0d030107053b393f3d333137352b292f2d232127255b595f5d535157554b494f4d434147457b797f7d737177756b696f6d636167659b999f9d939197958b898f8d83818785bbb9bfbdb3b1b7b5aba9afada3a1a7a5dbd9dfddd3d1d7d5cbc9cfcdc3c1c7c5fbf9fffdf3f1f7f5ebe9efede3e1e7e5";
	constant Mult3Table  : STD_LOGIC_VECTOR (2047 DOWNTO 0) := x"000306050c0f0a09181b1e1d14171211303336353c3f3a39282b2e2d24272221606366656c6f6a69787b7e7d74777271505356555c5f5a59484b4e4d44474241c0c3c6c5cccfcac9d8dbdeddd4d7d2d1f0f3f6f5fcfffaf9e8ebeeede4e7e2e1a0a3a6a5acafaaa9b8bbbebdb4b7b2b1909396959c9f9a99888b8e8d848782819b989d9e97949192838085868f8c898aaba8adaea7a4a1a2b3b0b5b6bfbcb9bafbf8fdfef7f4f1f2e3e0e5e6efece9eacbc8cdcec7c4c1c2d3d0d5d6dfdcd9da5b585d5e57545152434045464f4c494a6b686d6e67646162737075767f7c797a3b383d3e37343132232025262f2c292a0b080d0e07040102131015161f1c191a";
	
	signal Mult2Output 	: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Mult3Output 	: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	
begin

	Mult2: ENTITY work.F8 
	GENERIC Map ( size => Red_size, count => 1, Table => GoF_8bit(Table, Mult2Table))
	PORT MAP(
		data_in => in0,
		data_out => Mult2Output);
		
	Mult3: ENTITY work.F8 
	GENERIC Map ( size => Red_size, count => 1, Table => GoF_8bit(Table, Mult3Table))
	PORT MAP(
		data_in => in1,
		data_out => Mult3Output);

	-----------------------------	
		
	FinalXOR4: ENTITY work.XOR_4n
	GENERIC Map ( size => Red_size, count => 1)
	PORT Map ( Mult2Output, Mult3Output, in2, in3, q);

	
end Behavioral;

