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
use IEEE.NUMERIC_STD.ALL;
use work.functions.all;

-- Red_size : 1 (distance 2)
-- LFTable  : x"00010100010000010100000100010100010000010001010000010100010000010100000100010100000101000100000100010100010000010100000100010100010000010001010000010100010000010001010001000001010000010001010000010100010000010100000100010100010000010001010000010100010000010100000100010100000101000100000100010100010000010100000100010100000101000100000101000001000101000100000100010100000101000100000100010100010000010100000100010100010000010001010000010100010000010100000100010100000101000100000100010100010000010100000100010100";

-- Red_size : 4 (distance 3)
-- LFTable  : x"0003050606050300090A0C0F0F0C0A090A090F0C0C0F090A03000605050600030C0F090A0A090F0C050600030300060506050300000305060F0C0A09090A0C0F07040201010204070E0D0B08080B0D0E0D0E080B0B080E0D04070102020107040B080E0D0D0E080B02010704040701020102040707040201080B0D0E0E0D0B080B080E0D0D0E080B02010704040701020102040707040201080B0D0E0E0D0B0807040201010204070E0D0B08080B0D0E0D0E080B0B080E0D04070102020107040C0F090A0A090F0C050600030300060506050300000305060F0C0A09090A0C0F0003050606050300090A0C0F0F0C0A090A090F0C0C0F090A0300060505060003";

-- Red_size : 5 (distance 4)
-- LFTable  : x"00070B0C0D0A06010E0905020304080F1314181F1E1915121D1A161110171B1C15121E19181F13141B1C101716111D1A06010D0A0B0C0007080F030405020E091A1D111617101C1B14131F18191E1215090E020504030F0807000C0B0A0D01060F0804030205090E01060A0D0C0B07001C1B171011161A1D1215191E1F1814131C1B171011161A1D1215191E1F1814130F0804030205090E01060A0D0C0B0700090E020504030F0807000C0B0A0D01061A1D111617101C1B14131F18191E121506010D0A0B0C0007080F030405020E0915121E19181F13141B1C101716111D1A1314181F1E1915121D1A161110171B1C00070B0C0D0A06010E0905020304080F";

-- Red_size : 8 (distance 5)
-- LFTable  : x"000F333C555A66696A6559563F300C039699A5AAC3CCF0FFFCF3CFC0A9A69A95ACA39F90F9F6CAC5C6C9F5FA939CA0AF3A3509066F605C53505F636C050A3639D8D7EBE48D82BEB1B2BD818EE7E8D4DB4E417D721B142827242B1718717E424D747B4748212E121D1E112D224B447877E2EDD1DEB7B8848B8887BBB4DDD2EEE1E1EED2DDB4BB87888B84B8B7DED1EDE27778444B222D111E1D122E2148477B744D427E7118172B242728141B727D414EDBD4E8E78E81BDB2B1BE828DE4EBD7D839360A056C635F50535C606F0609353AAFA09C93FAF5C9C6C5CAF6F9909FA3AC959AA6A9C0CFF3FCFFF0CCC3AAA59996030C303F5659656A69665A553C330F00";

-- MultiVariate : 0 => Univariate   adversary model
-- MultiVariate : 1 => Multivariate adversary model

entity Cipher is
	 generic (  Red_size     : positive := 8;
		    LFTable	 : STD_LOGIC_VECTOR (2047 DOWNTO 0) := x"000F333C555A66696A6559563F300C039699A5AAC3CCF0FFFCF3CFC0A9A69A95ACA39F90F9F6CAC5C6C9F5FA939CA0AF3A3509066F605C53505F636C050A3639D8D7EBE48D82BEB1B2BD818EE7E8D4DB4E417D721B142827242B1718717E424D747B4748212E121D1E112D224B447877E2EDD1DEB7B8848B8887BBB4DDD2EEE1E1EED2DDB4BB87888B84B8B7DED1EDE27778444B222D111E1D122E2148477B744D427E7118172B242728141B727D414EDBD4E8E78E81BDB2B1BE828DE4EBD7D839360A056C635F50535C606F0609353AAFA09C93FAF5C9C6C5CAF6F9909FA3AC959AA6A9C0CFF3FCFFF0CCC3AAA59996030C303F5659656A69665A553C330F00";
		    MultiVariate : NATURAL  := 0);
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           InputData 	: in  STD_LOGIC_VECTOR (127 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
           OutputData 	: out  STD_LOGIC_VECTOR (127 downto 0);
           done 			: out  STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
		
	constant SboxTable    : STD_LOGIC_VECTOR (2047 DOWNTO 0) := x"637c777bf26b6fc53001672bfed7ab76ca82c97dfa5947f0add4a2af9ca472c0b7fd9326363ff7cc34a5e5f171d8311504c723c31896059a071280e2eb27b27509832c1a1b6e5aa0523bd6b329e32f8453d100ed20fcb15b6acbbe394a4c58cfd0efaafb434d338545f9027f503c9fa851a3408f929d38f5bcb6da2110fff3d2cd0c13ec5f974417c4a77e3d645d197360814fdc222a908846eeb814de5e0bdbe0323a0a4906245cc2d3ac629195e479e7c8376d8dd54ea96c56f4ea657aae08ba78252e1ca6b4c6e8dd741f4bbd8b8a703eb5664803f60e613557b986c11d9ee1f8981169d98e949b1e87e9ce5528df8ca1890dbfe6426841992d0fb054bb16";
	constant Mult2Table   : STD_LOGIC_VECTOR (2047 DOWNTO 0) := x"00020406080a0c0e10121416181a1c1e20222426282a2c2e30323436383a3c3e40424446484a4c4e50525456585a5c5e60626466686a6c6e70727476787a7c7e80828486888a8c8e90929496989a9c9ea0a2a4a6a8aaacaeb0b2b4b6b8babcbec0c2c4c6c8caccced0d2d4d6d8dadcdee0e2e4e6e8eaeceef0f2f4f6f8fafcfe1b191f1d131117150b090f0d030107053b393f3d333137352b292f2d232127255b595f5d535157554b494f4d434147457b797f7d737177756b696f6d636167659b999f9d939197958b898f8d83818785bbb9bfbdb3b1b7b5aba9afada3a1a7a5dbd9dfddd3d1d7d5cbc9cfcdc3c1c7c5fbf9fffdf3f1f7f5ebe9efede3e1e7e5";
	
	constant Distance 	 : NATURAL := GetDistance(Red_size, LFTable);
	constant Error_size   : NATURAL := Distance-1+Distance*MultiVariate;
	constant ToCheckCount : NATURAL := 16*3 + 1*3 + MultiVariate*(16*2+1);
	
	---------------------------- Encryption Process
	signal InputFeedback						: STD_LOGIC_VECTOR(127 downto 0);
	signal MuxOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal SBoxOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal ShiftRowOutput					: STD_LOGIC_VECTOR(127 downto 0);
	signal MCOutput							: STD_LOGIC_VECTOR(127 downto 0);
	signal AddRoundKeyOutput				: STD_LOGIC_VECTOR(127 downto 0);
	signal InputDataStateRegOutput		: STD_LOGIC_VECTOR(127 downto 0);
	signal MixColumnMUXOutput				: STD_LOGIC_VECTOR(127 downto 0);
	
	---------------------------- Encryption Process Redundancy
	signal Red_InputData						: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_InputFeedback				: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_MuxOutput						: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_InputDataStateRegOutput	: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_AddRoundKeyOutput			: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_SBoxOutput					: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_ShiftRowOutput				: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_MCOutput						: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	
	---------------------------- Key Schedule
	signal KeyFeedback						: STD_LOGIC_VECTOR(127 downto 0);
	signal ExpandedKey						: STD_LOGIC_VECTOR(127 downto 0);
	signal KeyMUXOutput						: STD_LOGIC_VECTOR(127 downto 0);
	signal KeyStateRegOutput				: STD_LOGIC_VECTOR(127 downto 0);
	
	---------------------------- Key Schedule Redundancy
	signal Red_KeyStateRegOutput			: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_Key   							: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_KeyFeedback					: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	signal Red_KeyMUXOutput					: STD_LOGIC_VECTOR(Red_size*16-1 downto 0);
	
	---------------------------- Control Logic
	signal FinalRound							: STD_LOGIC;
	signal done_internal						: STD_LOGIC;
	signal rcon									: STD_LOGIC_VECTOR(7 downto 0);
	signal RconFeedback						: STD_LOGIC_VECTOR(7 downto 0);
	signal RconMUXOutput						: STD_LOGIC_VECTOR(7 downto 0);
	signal RconStateRegOutput				: STD_LOGIC_VECTOR(7 downto 0);
	
	---------------------------- Control Logic Redundancy
	signal Red_FinalRoundGenInput			: STD_LOGIC_VECTOR(7 downto 0);
	signal Red_FinalRound					: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Red_RconFeedback  				: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Red_RconMUXOutput				: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Red_RconStateRegOutput			: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Red_Init							: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	signal Red_Done_internal				: STD_LOGIC_VECTOR(Red_size-1 downto 0);
	
	--------------------------- Consistency Check 
	signal Error								: STD_LOGIC_VECTOR(Red_size-1   downto 0);
	signal ErrorFree							: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal ErrorFreeUpdate					: STD_LOGIC_VECTOR(Error_size-1 downto 0);
	signal SignaltoCheck						: STD_LOGIC_VECTOR(ToCheckCount*8-1 downto 0);
	signal Red_SignaltoCheck				: STD_LOGIC_VECTOR(ToCheckCount*Red_size-1 downto 0);
	signal Red_final							: STD_LOGIC_VECTOR(ToCheckCount*Red_size-1 downto 0);	
	signal OutputRegIn						: STD_LOGIC_VECTOR(127 downto 0);	
		
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
		
	
	--OutputData <= AddRoundKeyOutput;

	Inst_SBox: ENTITY work.F8 
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
	
	---------------------------- Encryption Process Redundancy
	Red_InData: ENTITY work.F8
	GENERIC Map ( size => Red_size, count => 16, Table => LFTable)
	PORT Map ( 
		data_in	=> InputData,
		data_out => Red_InputData); 
	
	Red_InputMUX: ENTITY work.MUX
	GENERIC Map ( size => Red_size*16)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_InputFeedback,
		D1 	=> Red_InputData,
		Q 		=> Red_MuxOutput);
	
	Red_InputDataStateReg: ENTITY work.reg
	GENERIC Map ( size => Red_size*16)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_MuxOutput,
		Q 		=> Red_InputDataStateRegOutput);
		
	Red_AddKeyXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 16)
	PORT Map ( Red_InputDataStateRegOutput, Red_KeyStateRegOutput, Red_AddRoundKeyOutput);
	
	Red_SBox: ENTITY work.F8
	GENERIC Map ( size => Red_size, count => 16, Table => GoF_8bit(LFTable, SboxTable))
	PORT MAP(
		data_in  => AddRoundKeyOutput,
		data_out => Red_SBoxOutput);
		
	Red_ShiftRow: ENTITY work.ShiftRow 
	GENERIC Map ( size => Red_size)
	PORT MAP(
		in0 => Red_SBoxOutput,
		q0 => Red_ShiftRowOutput);
		
	Inst_RedMC: ENTITY work.RedMC 
	GENERIC Map ( Red_size => Red_size, Table => LFTable)
	PORT MAP(
		data_in  => ShiftRowOutput,
		Red_in   => Red_ShiftRowOutput,
		data_out => Red_MCOutput);
		
	Red_MixColumnMUX: ENTITY work.MUX2to1_Redn
	GENERIC Map ( 
		size1   => Red_size, 
		size2   => 16*Red_size,
		LFTable => LFTable)
	PORT Map (
		sel	=> Red_FinalRound,
		D0		=> Red_MCOutput,
		D1		=> Red_ShiftRowOutput,
		Q		=> Red_InputFeedback);

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
	
	---------------------------- Key Schedule Redundancy
	Red_key_Inst: ENTITY work.F8
	GENERIC Map ( size => Red_size, count => 16, Table => LFTable)
	PORT Map ( 
		data_in	=> Key,
		data_out => Red_Key);
		
	RedKeyMUX: ENTITY work.MUX
	GENERIC Map ( size => Red_size*16) 
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_KeyFeedback,
		D1 	=> Red_Key,
		Q 		=> Red_KeyMUXOutput);
		
	RedKeyStateReg: ENTITY work.reg
	GENERIC Map (size => Red_size*16)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_KeyMUXOutput,
		Q 		=> Red_KeyStateRegOutput);
		
	RedKeyExpansionInst: ENTITY work.RedKeyExpansion 
	GENERIC Map ( Red_size => Red_size, Table => GoF_8bit(LFTable, SboxTable))
	PORT MAP(
		Key => KeyStateRegOutput,
		Red_Key => Red_KeyStateRegOutput,
		Red_rcon => Red_RconStateRegOutput,
		Red_ExpandedKey => Red_KeyFeedback);
	
	---------------------------- Control Logic 
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
	
	X2inGFInst: ENTITY work.F8 
	GENERIC Map ( size => 8, count => 1, Table => Mult2Table)
	PORT MAP(
		data_in  => RconStateRegOutput,
		data_out => RconFeedback);
		
	FinalRoundGen: ENTITY work.FinalRoundControlLogic 
	PORT MAP(
		InputData 	=> RconStateRegOutput,
		FinalRound 	=> FinalRound);
		
	DoneGen: ENTITY work.DoneControlLogic 
	PORT MAP(
		InputData 	=> RconStateRegOutput,
		done 			=> done_internal);
		
	---------------------------- Control Logic Redundancy
	Red_Init 		<= LFTable(2032+Red_size-1 downto 2032);
	
	Red_RconMUX: ENTITY work.MUX
	GENERIC Map ( size => Red_size)
	PORT Map ( 
		sel	=> rst,
		D0   	=> Red_RconFeedback,
		D1 	=> Red_Init,
		Q 		=> Red_RconMUXOutput); 
		
	Red_RconStateReg: ENTITY work.reg
	GENERIC Map ( size => Red_size)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_RconMUXOutput,
		Q 		=> Red_RconStateRegOutput);
		
	RedX2inGFInst: ENTITY work.F8 
	GENERIC Map ( size => Red_size, count => 1, Table => GoF_8bit(LFTable, Mult2Table))
	PORT MAP(
		data_in  => RconStateRegOutput,
		data_out => Red_RconFeedback);
		
	RedFinalRoundControlLogicInst: ENTITY work.RedFinalRoundControlLogic 
	GENERIC Map ( Red_size => Red_size, Table => LFTable)
	PORT MAP(
		rcon => RconStateRegOutput,
		Red_FinalRoundBit => Red_FinalRound);
		
	RedDoneControlLogicInst: ENTITY work.RedDoneControlLogic 
	GENERIC Map ( Red_size => Red_size, Table => LFTable)
	PORT MAP(RconStateRegOutput, Red_Done_internal);
		
	---------------------------- Consistency Check
	GENMV0:
	IF MultiVariate = 0 GENERATE
		SignaltoCheck <= AddRoundKeyOutput 		& ShiftRowOutput 		& KeyStateRegOutput 		& RconStateRegOutput 		& "0000000" & FinalRound	& "0000000" & done_internal;
		Red_final     <= Red_AddRoundKeyOutput & Red_ShiftRowOutput & Red_KeyStateRegOutput & Red_RconStateRegOutput 	& Red_FinalRound				& Red_Done_internal;
	END GENERATE;
	
	GENMV1:
	IF MultiVariate /= 0 GENERATE
		SignaltoCheck <= AddRoundKeyOutput 		& ShiftRowOutput 		& KeyStateRegOutput 		& RconStateRegOutput 		& "0000000" & FinalRound	& "0000000" & done_internal &
		                 MuxOutput             & KeyMuxOutput       & RconMUXOutput;
		Red_final     <= Red_AddRoundKeyOutput & Red_ShiftRowOutput & Red_KeyStateRegOutput & Red_RconStateRegOutput 	& Red_FinalRound				& Red_Done_internal &
		                 Red_MuxOutput         & Red_KeyMuxOutput   & Red_RconMUXOutput;
	END GENERATE;
	
	--------
	
	Red_ToCheckInst: ENTITY work.F8
	GENERIC Map ( size => Red_size, count => ToCheckCount, Table => LFTable)
	PORT Map (
		data_in  => SignaltoCheck,
		data_out => Red_SignaltoCheck); -- c''
		
	-- check
	Check1: ENTITY work.Checkn 
	GENERIC Map ( count => ToCheckCount, sizecount => 1, size  => Red_size)
	PORT Map ( 
		in1		=> Red_final,
		in2    	=> Red_SignaltoCheck,
		result 	=> Error);
		
	-------------------------------------
	
	GEN1 :
	FOR i IN 0 TO Error_size-1 GENERATE
		ANDInst: ENTITY work.ANDn
		Generic Map (size1 => Red_size, size2 => Error_size)
		Port Map (Error, ErrorFree, ErrorFreeUpdate(i));
	END GENERATE;

	ErrorDetectionReg: PROCESS(clk, rst, ErrorFreeUpdate) -- e` 
	BEGIN
		IF RISING_EDGE(clk) THEN
			IF (rst = '1') THEN
				ErrorFree	<= (others => '1');
			ELSE
				ErrorFree 	<= ErrorFreeUpdate;
			END IF;
		END IF;
	END PROCESS;		
		
	--------------
	
	OutputMUX: ENTITY work.MUX2to1_Redn_forcheck
	GENERIC Map ( 
		size1   => Error_size,
		size2	  => 128)
	PORT Map (
		sel	=> ErrorFreeUpdate,
		D0		=> (others => '0'),
		D1		=> AddRoundKeyOutput,
		Q		=> OutputRegIn);
		
	OutputReg: ENTITY work.regER 
	GENERIC Map ( size => 128)
	PORT Map ( 
		clk	=> clk,
		rst	=> rst,
		EN		=> done_internal,
		D 		=> OutputRegIn,
		Q 		=> OutputData);

	done_reg_gen: PROCESS(clk, done_internal)
	BEGIN
		IF RISING_EDGE(clk) THEN
			done <= done_internal;
		END IF;
	END PROCESS;	
	
end Behavioral;

