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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Red_RoundConstantBit IS
	Generic ( LFTable      : STD_LOGIC_VECTOR (63 DOWNTO 0);
			    NibbleNumber : NATURAL;
				 BitNumber    : NATURAL);
	PORT ( Round  : IN  STD_LOGIC_VECTOR (3  DOWNTO 0);
			 RCLSB  : OUT STD_LOGIC);
END Red_RoundConstantBit;

ARCHITECTURE behavioral OF Red_RoundConstantBit IS
	
	constant LFTable0 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(60) & LFTable(56) & LFTable(52) & LFTable(48) & LFTable(44) & LFTable(40) & LFTable(36) & LFTable(32) &
		LFTable(28) & LFTable(24) & LFTable(20) & LFTable(16) & LFTable(12) & LFTable(8) & LFTable(4) & LFTable(0);
	
	constant LFTable1 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(61) & LFTable(57) & LFTable(53) & LFTable(49) & LFTable(45) & LFTable(41) & LFTable(37) & LFTable(33) &
		LFTable(29) & LFTable(25) & LFTable(21) & LFTable(17) & LFTable(13) & LFTable(9) & LFTable(5) & LFTable(1);

	constant LFTable2 : STD_LOGIC_VECTOR (15 DOWNTO 0) :=
		LFTable(62) & LFTable(58) & LFTable(54) & LFTable(50) & LFTable(46) & LFTable(42) & LFTable(38) & LFTable(34) &
		LFTable(30) & LFTable(26) & LFTable(22) & LFTable(18) & LFTable(14) & LFTable(10) & LFTable(6) & LFTable(2);

	signal RCBit : STD_LOGIC;

BEGIN

	RCInst: ENTITY work.RoundConstantBit
	GENERIC Map ( NibbleNumber => NibbleNumber)
	PORT Map( 
		Round  => Round,
		RCLSB  => RCBit);
	
	Bit_0:
	IF BitNumber = 0 GENERATE
		RCLSB <= LFTable0(15) WHEN RCBit = '0' ELSE LFTable0(14);
	END GENERATE;

	-------------------
	
	Bit_1:
	IF BitNumber = 1 GENERATE
		RCLSB <= LFTable1(15) WHEN RCBit = '0' ELSE LFTable1(14);
	END GENERATE;
		
	-------------------

	Bit_2:
	IF BitNumber = 2 GENERATE
		RCLSB <= LFTable2(15) WHEN RCBit = '0' ELSE LFTable2(14);
	END GENERATE;	
	
END behavioral;

