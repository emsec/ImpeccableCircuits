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
use IEEE.NUMERIC_STD.ALL;
use work.functions.all;

-- Red_size : 9  (distance 6)
-- LFTable  : x"0000001F0067007800AB00B400CC00D300D500CA00B200AD007E006100190006012E0131014901560185019A01E201FD01FB01E4019C01830150014F01370128015C0143013B012401F701E80190018F0189019601EE01F10122013D0145015A0072006D0015000A00D900C600BE00A100A700B800C000DF000C0013006B007401B801A701DF01C00113010C0174016B016D0172010A011501C601D901A101BE0096008900F100EE003D0022005A00450043005C0024003B00E800F7008F009000E400FB0083009C004F0050002800370031002E00560049009A008500FD00E201CA01D501AD01B20161017E01060119011F01000178016701B401AB01D301CC01D201CD01B501AA01790166011E0101010701180160017F01AC01B301CB01D400FC00E3009B0084005700480030002F00290036004E00510082009D00E500FA008E009100E900F60025003A0042005D005B0044003C002300F000EF0097008801A001BF01C701D8010B0114016C01730175016A0112010D01DE01C101B901A6006A0075000D001200C100DE00A600B900BF00A000D800C70014000B0073006C0144015B0123013C01EF01F0018801970191018E01F601E9013A0125015D0142013601290151014E019D018201FA01E501E301FC0184019B01480157012F013000180007007F006000B300AC00D400CB00CD00D200AA00B5006600790001001E";

-- Red_size : 11 (distance 7)
-- LFTable  : x"0000003F01C701F802D902E6031E0321036A035502AD029201B3018C0074004B03B4038B0273024C016D015200AA009500DE00E1011901260207023803C003FF04EC04D3052B05140635060A07F207CD078607B90641067E055F0560049804A707580767069F06A0058105BE044604790432040D05F505CA06EB06D4072C07130571054E04B6048907A80797066F0650061B062407DC07E304C204FD0505053A06C506FA0702073D041C042305DB05E405AF0590046804570776074906B1068E019D01A2005A00650344037B028302BC02F702C80330030F002E001101E901D60229021603EE03D100F000CF013701080143017C008400BB039A03A5025D0262059A05A5045D04620743077C068406BB06F006CF073707080429041605EE05D1062E061107E907D604F704C80530050F0544057B048304BC079D07A2065A06650176014900B1008E03AF039002680257021C022303DB03E400C500FA0102013D02C202FD0305033A001B002401DC01E301A80197006F00500371034E02B6028900EB00D4012C01130232020D03F503CA038103BE0246027901580167009F00A0035F0360029802A7018601B90041007E0035000A01F201CD02EC02D3032B03140407043805C005FF06DE06E107190726076D075206AA069505B4058B0473044C07B3078C0674064B056A055504AD049204D904E6051E05210600063F07C707F8";

-- Red_size : 12 (distance 8)
-- LFTable  : x"0000007F038F03F005B305CC063C064306D506AA055A05250366031900E9009609EA09950A650A1A0C590C260FD60FA90F3F0F400CB00CCF0A8C0AF30903097C0B5C0B2308D308AC0EEF0E900D600D1F0D890DF60E060E79083A08450BB50BCA02B602C9013901460705077A048A04F50463041C07EC079301D001AF025F02200E720E0D0DFD0D820BC10BBE084E083108A708D80B280B570D140D6B0E9B0EE4079807E704170468022B025401A401DB014D013202C202BD04FE04810771070E052E055106A106DE009D00E20312036D03FB03840074000B0648063705C705B80CC40CBB0F4B0F34097709080AF80A870A110A6E099E09E10FA20FDD0C2D0C520FA40FDB0C2B0C540A170A68099809E70971090E0AFE0A810CC20CBD0F4D0F32064E063105C105BE03FD03820072000D009B00E40314036B0528055706A706D804F8048707770708014B013402C402BB022D025201A201DD079E07E10411046E0D120D6D0E9D0EE208A108DE0B2E0B510BC70BB8084808370E740E0B0DFB0D8401D601A9025902260465041A07EA07950703077C048C04F302B002CF013F0140083C08430BB30BCC0D8F0DF00E000E7F0EE90E960D660D190B5A0B2508D508AA0A8A0AF50905097A0F390F460CB60CC90C5F0C200FD00FAF09EC09930A630A1C0360031F00EF009006D306AC055C052305B505CA063A064500060079038903F6";

-- MultiVariate : 0 => Univariate   adversary model
-- MultiVariate : 1 => Multivariate adversary model

entity Cipher is
	 generic (  Red_size : positive := 12;
	LFTable	: STD_LOGIC_VECTOR (4095 DOWNTO 0) := x"0000007F038F03F005B305CC063C064306D506AA055A05250366031900E9009609EA09950A650A1A0C590C260FD60FA90F3F0F400CB00CCF0A8C0AF30903097C0B5C0B2308D308AC0EEF0E900D600D1F0D890DF60E060E79083A08450BB50BCA02B602C9013901460705077A048A04F50463041C07EC079301D001AF025F02200E720E0D0DFD0D820BC10BBE084E083108A708D80B280B570D140D6B0E9B0EE4079807E704170468022B025401A401DB014D013202C202BD04FE04810771070E052E055106A106DE009D00E20312036D03FB03840074000B0648063705C705B80CC40CBB0F4B0F34097709080AF80A870A110A6E099E09E10FA20FDD0C2D0C520FA40FDB0C2B0C540A170A68099809E70971090E0AFE0A810CC20CBD0F4D0F32064E063105C105BE03FD03820072000D009B00E40314036B0528055706A706D804F8048707770708014B013402C402BB022D025201A201DD079E07E10411046E0D120D6D0E9D0EE208A108DE0B2E0B510BC70BB8084808370E740E0B0DFB0D8401D601A9025902260465041A07EA07950703077C048C04F302B002CF013F0140083C08430BB30BCC0D8F0DF00E000E7F0EE90E960D660D190B5A0B2508D508AA0A8A0AF50905097A0F390F460CB60CC90C5F0C200FD00FAF09EC09930A630A1C0360031F00EF009006D306AC055C052305B505CA063A064500060079038903F6";
	MultiVariate 	: NATURAL  := 0);
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           InputData 	: in  STD_LOGIC_VECTOR (127 downto 0);
           Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
           OutputData 	: out  STD_LOGIC_VECTOR (127 downto 0);
           done 			: out  STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is

	constant SboxTable    	: STD_LOGIC_VECTOR (4095 DOWNTO 0) := x"0063007c0077007b00f2006b006f00c5003000010067002b00fe00d700ab007600ca008200c9007d00fa0059004700f000ad00d400a200af009c00a4007200c000b700fd009300260036003f00f700cc003400a500e500f1007100d800310015000400c7002300c3001800960005009a00070012008000e200eb002700b2007500090083002c001a001b006e005a00a00052003b00d600b3002900e3002f0084005300d1000000ed002000fc00b1005b006a00cb00be0039004a004c005800cf00d000ef00aa00fb0043004d00330085004500f90002007f0050003c009f00a8005100a30040008f0092009d003800f500bc00b600da0021001000ff00f300d200cd000c001300ec005f00970044001700c400a7007e003d0064005d0019007300600081004f00dc0022002a00900088004600ee00b8001400de005e000b00db00e00032003a000a004900060024005c00c200d300ac00620091009500e4007900e700c80037006d008d00d5004e00a9006c005600f400ea0065007a00ae000800ba00780025002e001c00a600b400c600e800dd0074001f004b00bd008b008a0070003e00b500660048000300f6000e00610035005700b9008600c1001d009e00e100f800980011006900d9008e0094009b001e008700e900ce0055002800df008c00a10089000d00bf00e60042006800410099002d000f00b0005400bb0016";
	constant Mult2Table   	: STD_LOGIC_VECTOR (4095 DOWNTO 0) := x"00000002000400060008000a000c000e00100012001400160018001a001c001e00200022002400260028002a002c002e00300032003400360038003a003c003e00400042004400460048004a004c004e00500052005400560058005a005c005e00600062006400660068006a006c006e00700072007400760078007a007c007e00800082008400860088008a008c008e00900092009400960098009a009c009e00a000a200a400a600a800aa00ac00ae00b000b200b400b600b800ba00bc00be00c000c200c400c600c800ca00cc00ce00d000d200d400d600d800da00dc00de00e000e200e400e600e800ea00ec00ee00f000f200f400f600f800fa00fc00fe001b0019001f001d0013001100170015000b0009000f000d0003000100070005003b0039003f003d0033003100370035002b0029002f002d0023002100270025005b0059005f005d0053005100570055004b0049004f004d0043004100470045007b0079007f007d0073007100770075006b0069006f006d0063006100670065009b0099009f009d0093009100970095008b0089008f008d008300810087008500bb00b900bf00bd00b300b100b700b500ab00a900af00ad00a300a100a700a500db00d900df00dd00d300d100d700d500cb00c900cf00cd00c300c100c700c500fb00f900ff00fd00f300f100f700f500eb00e900ef00ed00e300e100e700e5";
	constant Mult3Table   	: STD_LOGIC_VECTOR (4095 DOWNTO 0) := x"0000000300060005000c000f000a00090018001b001e001d00140017001200110030003300360035003c003f003a00390028002b002e002d00240027002200210060006300660065006c006f006a00690078007b007e007d00740077007200710050005300560055005c005f005a00590048004b004e004d004400470042004100c000c300c600c500cc00cf00ca00c900d800db00de00dd00d400d700d200d100f000f300f600f500fc00ff00fa00f900e800eb00ee00ed00e400e700e200e100a000a300a600a500ac00af00aa00a900b800bb00be00bd00b400b700b200b10090009300960095009c009f009a00990088008b008e008d0084008700820081009b0098009d009e00970094009100920083008000850086008f008c0089008a00ab00a800ad00ae00a700a400a100a200b300b000b500b600bf00bc00b900ba00fb00f800fd00fe00f700f400f100f200e300e000e500e600ef00ec00e900ea00cb00c800cd00ce00c700c400c100c200d300d000d500d600df00dc00d900da005b0058005d005e00570054005100520043004000450046004f004c0049004a006b0068006d006e00670064006100620073007000750076007f007c0079007a003b0038003d003e00370034003100320023002000250026002f002c0029002a000b0008000d000e00070004000100020013001000150016001f001c0019001a";
	
	constant LFInvTable    	: STD_LOGIC_VECTOR (4095 DOWNTO 0) := MakeInv(Red_size,LFTable);
	constant RedSboxTable  	: STD_LOGIC_VECTOR (4095 DOWNTO 0) := MakeFRed(SboxTable, LFTable, LFInvTable);
	constant RedMult2Table 	: STD_LOGIC_VECTOR (4095 DOWNTO 0) := MakeFRed(Mult2Table, LFTable, LFInvTable);
	constant RedMult3Table 	: STD_LOGIC_VECTOR (4095 DOWNTO 0) := MakeFRed(Mult3Table, LFTable, LFInvTable);
	
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
		
	MC_Inst: ENTITY work.MC 
	GENERIC Map (size => 8, Mult2Table => Mult2Table, Mult3Table => Mult3Table)
	PORT MAP(
		in0 => ShiftRowOutput,
		q0 => MCOutput);
	
	MixColumnMUX: ENTITY work.MUX
	GENERIC Map (size => 128)
	PORT Map ( 
		sel	=> FinalRound,
		D0   	=> MCOutput,
		D1 	=> ShiftRowOutput,
		Q 		=> MixColumnMUXOutput);
		
	InputFeedback <= MixColumnMUXOutput;
	
	---------------------------- Encryption Process Redundancy
	Red_InData: ENTITY work.F
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
	GENERIC Map (size => Red_size*16)
	PORT Map ( 
		clk	=> clk,
		D 		=> Red_MuxOutput,
		Q 		=> Red_InputDataStateRegOutput);
		
	Red_AddKeyXOR: ENTITY work.XOR_2n
	GENERIC Map ( size => Red_size, count => 16)
	PORT Map ( Red_InputDataStateRegOutput, Red_KeyStateRegOutput, Red_AddRoundKeyOutput);
	
	Red_SBox: ENTITY work.F8
	GENERIC Map ( size => Red_size, count => 16, Table => RedSboxTable)
	PORT MAP(
		data_in  => Red_AddRoundKeyOutput,
		data_out => Red_SBoxOutput);
		
	Red_ShiftRow: ENTITY work.ShiftRow 
	GENERIC Map ( size => Red_size)
	PORT MAP(
		in0 => Red_SBoxOutput,
		q0 => Red_ShiftRowOutput);
		
	RedMC_Inst: ENTITY work.MC 
	GENERIC Map (size => Red_size, Mult2Table => RedMult2Table, Mult3Table => RedMult3Table)
	PORT MAP(
		in0 => Red_ShiftRowOutput,
		q0 => Red_MCOutput);
		
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
	
	Red_key_Inst: ENTITY work.F
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
	GENERIC Map ( Red_size => Red_size, Table => RedSboxTable)
	PORT MAP(
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
		
		--done <= done_internal;
		
	---------------------------- Control Logic Redundancy
		
	Red_Init 		<= LFTable(4064+Red_size-1 downto 4064);
	
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
	GENERIC Map ( size => Red_size, count => 1, Table => RedMult2Table)
	PORT MAP(
		data_in  => Red_RconStateRegOutput,
		data_out => Red_RconFeedback);
		
	RedFinalRoundControlLogicInst: ENTITY work.RedFinalRoundControlLogic 
	GENERIC Map ( Red_size => Red_size, LFTable => LFTable, LFInvTable => LFInvTable)
	PORT MAP(Red_RconStateRegOutput, Red_FinalRound);
		
	RedDoneControlLogicInst: ENTITY work.RedDoneControlLogic 
	GENERIC Map ( Red_size => Red_size, LFTable => LFTable, LFInvTable => LFInvTable)
	PORT MAP(Red_RconStateRegOutput, Red_Done_internal);
		
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
	
	Red_ToCheckInst: ENTITY work.F
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

