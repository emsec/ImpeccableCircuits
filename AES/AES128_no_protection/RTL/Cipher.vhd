----------------------------------------------------------------------------------
-- COMPANY:		Ruhr University Bochum, Embedded Security
-- AUTHOR:		https://eprint.iacr.org/2018/203
----------------------------------------------------------------------------------
-- Copyright (c) 2019, Amir Moradi, Aein Rezaei Shahmirzadi
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

entity Cipher is
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           InputData 	: in  STD_LOGIC_VECTOR (127 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
           OutputData 	: out  STD_LOGIC_VECTOR (127 downto 0);
           done 			: out  STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
		
	constant SboxTable : STD_LOGIC_VECTOR (2047 DOWNTO 0) := x"637c777bf26b6fc53001672bfed7ab76ca82c97dfa5947f0add4a2af9ca472c0b7fd9326363ff7cc34a5e5f171d8311504c723c31896059a071280e2eb27b27509832c1a1b6e5aa0523bd6b329e32f8453d100ed20fcb15b6acbbe394a4c58cfd0efaafb434d338545f9027f503c9fa851a3408f929d38f5bcb6da2110fff3d2cd0c13ec5f974417c4a77e3d645d197360814fdc222a908846eeb814de5e0bdbe0323a0a4906245cc2d3ac629195e479e7c8376d8dd54ea96c56f4ea657aae08ba78252e1ca6b4c6e8dd741f4bbd8b8a703eb5664803f60e613557b986c11d9ee1f8981169d98e949b1e87e9ce5528df8ca1890dbfe6426841992d0fb054bb16";
	
	---------------------------- Encryption Process
	signal InputFeedback						: STD_LOGIC_VECTOR(127 downto 0);
	signal MuxOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal SBoxOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal ShiftRowOutput					: STD_LOGIC_VECTOR(127 downto 0);
	signal MCOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal AddRoundKeyOutput				: STD_LOGIC_VECTOR(127 downto 0);
	signal InputDataStateRegOutput		: STD_LOGIC_VECTOR(127 downto 0);
	signal MixColumnMUXOutput				: STD_LOGIC_VECTOR(127 downto 0);
	
	---------------------------- Key Schedule
	signal KeyFeedback						: STD_LOGIC_VECTOR(127 downto 0);
	signal ExpandedKey						: STD_LOGIC_VECTOR(127 downto 0);
	signal KeyMUXOutput						: STD_LOGIC_VECTOR(127 downto 0);
	signal KeyStateRegOutput				: STD_LOGIC_VECTOR(127 downto 0);
	
	---------------------------- Control Logic
	signal InitialRound						: STD_LOGIC;
	signal FinalRound							: STD_LOGIC;
	signal rcon									: STD_LOGIC_VECTOR(7 downto 0);
	signal RconFeedback						: STD_LOGIC_VECTOR(7 downto 0);
	signal RconMUXOutput						: STD_LOGIC_VECTOR(7 downto 0);
	signal RconStateRegOutput				: STD_LOGIC_VECTOR(7 downto 0);
	  
		
begin
	
	---------------------------- Encryption Process
	InputMUX: ENTITY work.MUX
	GENERIC Map ( size => 128)
	PORT Map ( 
		sel	=> rst,
		D0   	=> InputFeedback,
		D1 	=> InputData,
		Q 		=> MuxOutput);
	
	InputDataStateReg: ENTITY work.reg
	GENERIC Map ( size => 128)
	PORT Map ( 
		clk	=> clk,
		D 		=> MuxOutput,
		Q 		=> InputDataStateRegOutput);
		
	AddKeyXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => 8, count => 16)
	PORT Map ( InputDataStateRegOutput, KeyStateRegOutput, AddRoundKeyOutput);	
		
	
	OutputData <= AddRoundKeyOutput;

	Inst_SBox: ENTITY work.SBox 
	GENERIC Map ( size => 8, count => 16, Table => SboxTable)
	PORT MAP(
		data_in => AddRoundKeyOutput,
		data_out => SBoxOutput);

	Inst_ShiftRow: ENTITY work.ShiftRow 
	PORT MAP(
		in0 => SBoxOutput,
		q0 => ShiftRowOutput);
		
	Inst_MC: ENTITY work.MC 
	PORT MAP(
		in0 => ShiftRowOutput,
		q0 => MCOutput);
	
	MixColumnMUX: ENTITY work.MUX
	GENERIC Map ( size => 128)
	PORT Map ( 
		sel	=> FinalRound,
		D0   	=> MCOutput,
		D1 	=> ShiftRowOutput,
		Q 		=> MixColumnMUXOutput);
		
	InputFeedback <= MixColumnMUXOutput;
	
	---------------------------- Key Schedule
	KeyMUX: ENTITY work.MUX
	GENERIC Map ( size => 128)
	PORT Map ( 
		sel	=> rst,
		D0   	=> KeyFeedback,
		D1 	=> Key,
		Q 		=> KeyMUXOutput);
		
	KeyStateReg: ENTITY work.reg
	GENERIC Map ( size => 128)
	PORT Map ( 
		clk	=> clk,
		D 		=> KeyMUXOutput,
		Q 		=> KeyStateRegOutput);
		
	Inst_KeyExpansion: ENTITY work.KeyExpansion 
	GENERIC Map ( size => 128, Table => SboxTable)
	PORT MAP(
		Key => KeyStateRegOutput,
		rcon => rcon,
		ExpandedKey => KeyFeedback);
	
	---------------------------- FSM 
	
	RconMUX: ENTITY work.MUX
	GENERIC Map ( size => 8)
	PORT Map ( 
		sel	=> rst,
		D0   	=> RconFeedback,
		D1 	=> x"01",
		Q 		=> RconMUXOutput);
		
	RconStateReg: ENTITY work.reg
	GENERIC Map ( size => 8)
	PORT Map ( 
		clk	=> clk,
		D 		=> RconMUXOutput,
		Q 		=> RconStateRegOutput);
	
	rcon <= RconStateRegOutput;
	
	Inst_X2inGF: ENTITY work.X2inGF 
	PORT MAP(
		x => RconStateRegOutput,
		y => RconFeedback);
		
	FinalRoundGen: ENTITY work.FinalRoundControlLogic 
	PORT MAP(
		InputData 	=> RconStateRegOutput,
		FinalRound 	=> FinalRound);
		
	DoneGen: ENTITY work.DoneControlLogic 
	PORT MAP(
		InputData 	=> RconStateRegOutput,
		done 			=> done);
	
end Behavioral;

