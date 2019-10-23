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

ENTITY RoundConstantBit IS
	GENERIC ( NibbleNumber : NATURAL);
	PORT ( Round  : IN  STD_LOGIC_VECTOR (3  DOWNTO 0);
			 RCLSB  : OUT STD_LOGIC);
END RoundConstantBit;

ARCHITECTURE behavioral OF RoundConstantBit IS
BEGIN

	Bit15:
	IF NibbleNumber = 15 GENERATE
		Table15Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0001001001000011")
		PORT Map (Round, RCLSB);
	END GENERATE;
	
	Bit14:
	IF NibbleNumber = 14 GENERATE
		Table14Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0010101000110111")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit13:
	IF NibbleNumber = 13 GENERATE
		Table13Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0011100000011010")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit12:
	IF NibbleNumber = 12 GENERATE
		Table12Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0110011001010111")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit11:
	IF NibbleNumber = 11 GENERATE
		Table11Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0010000010000011")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit10:
	IF NibbleNumber = 10 GENERATE
		Table10Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0101000001000001")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit9:
	IF NibbleNumber = 9 GENERATE
		Table9Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0000100110001001")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit8:
	IF NibbleNumber = 8 GENERATE
		Table8Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0100001010010101")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit7:
	IF NibbleNumber = 7 GENERATE
		Table7Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0110000011111011")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit6:
	IF NibbleNumber = 6 GENERATE
		Table6Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0010011110000010")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit5:
	IF NibbleNumber = 5 GENERATE
		Table5Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0101001100100100")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit4:
	IF NibbleNumber = 4 GENERATE
		Table4Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0101101000110101")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit3:
	IF NibbleNumber = 3 GENERATE
		Table3Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0000010010101010")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit2:
	IF NibbleNumber = 2 GENERATE
		Table2Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0001010110011000")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit1:
	IF NibbleNumber = 1 GENERATE
		Table1Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0100110100011010")
		PORT Map (Round, RCLSB);
	END GENERATE;

	Bit0:
	IF NibbleNumber = 0 GENERATE
		Table0Inst: ENTITY work.LookUp16
		GENERIC Map (Table => "0101110001010000")
		PORT Map (Round, RCLSB);
	END GENERATE;

END behavioral;

