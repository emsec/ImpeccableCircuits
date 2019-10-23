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

entity RedDoneControlLogicBit is
	Generic ( 
		Red_size			: NATURAL;
		Table    		: STD_LOGIC_VECTOR (4095 DOWNTO 0);
		LFInvTable    		: STD_LOGIC_VECTOR (4095 DOWNTO 0);
		BitNumber		: integer);
   Port ( 
		Red_rcon   					: in   STD_LOGIC_VECTOR (Red_size-1 downto 0);
		Red_DoneBit		: out  STD_LOGIC);
end RedDoneControlLogicBit;

architecture Behavioral of RedDoneControlLogicBit is

	constant LFInvTable0 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	LFInvTable(4080) & LFInvTable(4064) & LFInvTable(4048) & LFInvTable(4032) & LFInvTable(4016) & LFInvTable(4000) & LFInvTable(3984) & LFInvTable(3968) & 
	LFInvTable(3952) & LFInvTable(3936) & LFInvTable(3920) & LFInvTable(3904) & LFInvTable(3888) & LFInvTable(3872) & LFInvTable(3856) & LFInvTable(3840) & 
	LFInvTable(3824) & LFInvTable(3808) & LFInvTable(3792) & LFInvTable(3776) & LFInvTable(3760) & LFInvTable(3744) & LFInvTable(3728) & LFInvTable(3712) & 
	LFInvTable(3696) & LFInvTable(3680) & LFInvTable(3664) & LFInvTable(3648) & LFInvTable(3632) & LFInvTable(3616) & LFInvTable(3600) & LFInvTable(3584) & 
	LFInvTable(3568) & LFInvTable(3552) & LFInvTable(3536) & LFInvTable(3520) & LFInvTable(3504) & LFInvTable(3488) & LFInvTable(3472) & LFInvTable(3456) & 
	LFInvTable(3440) & LFInvTable(3424) & LFInvTable(3408) & LFInvTable(3392) & LFInvTable(3376) & LFInvTable(3360) & LFInvTable(3344) & LFInvTable(3328) & 
	LFInvTable(3312) & LFInvTable(3296) & LFInvTable(3280) & LFInvTable(3264) & LFInvTable(3248) & LFInvTable(3232) & LFInvTable(3216) & LFInvTable(3200) & 
	LFInvTable(3184) & LFInvTable(3168) & LFInvTable(3152) & LFInvTable(3136) & LFInvTable(3120) & LFInvTable(3104) & LFInvTable(3088) & LFInvTable(3072) & 
	LFInvTable(3056) & LFInvTable(3040) & LFInvTable(3024) & LFInvTable(3008) & LFInvTable(2992) & LFInvTable(2976) & LFInvTable(2960) & LFInvTable(2944) & 
	LFInvTable(2928) & LFInvTable(2912) & LFInvTable(2896) & LFInvTable(2880) & LFInvTable(2864) & LFInvTable(2848) & LFInvTable(2832) & LFInvTable(2816) & 
	LFInvTable(2800) & LFInvTable(2784) & LFInvTable(2768) & LFInvTable(2752) & LFInvTable(2736) & LFInvTable(2720) & LFInvTable(2704) & LFInvTable(2688) & 
	LFInvTable(2672) & LFInvTable(2656) & LFInvTable(2640) & LFInvTable(2624) & LFInvTable(2608) & LFInvTable(2592) & LFInvTable(2576) & LFInvTable(2560) & 
	LFInvTable(2544) & LFInvTable(2528) & LFInvTable(2512) & LFInvTable(2496) & LFInvTable(2480) & LFInvTable(2464) & LFInvTable(2448) & LFInvTable(2432) & 
	LFInvTable(2416) & LFInvTable(2400) & LFInvTable(2384) & LFInvTable(2368) & LFInvTable(2352) & LFInvTable(2336) & LFInvTable(2320) & LFInvTable(2304) & 
	LFInvTable(2288) & LFInvTable(2272) & LFInvTable(2256) & LFInvTable(2240) & LFInvTable(2224) & LFInvTable(2208) & LFInvTable(2192) & LFInvTable(2176) & 
	LFInvTable(2160) & LFInvTable(2144) & LFInvTable(2128) & LFInvTable(2112) & LFInvTable(2096) & LFInvTable(2080) & LFInvTable(2064) & LFInvTable(2048) & 
	LFInvTable(2032) & LFInvTable(2016) & LFInvTable(2000) & LFInvTable(1984) & LFInvTable(1968) & LFInvTable(1952) & LFInvTable(1936) & LFInvTable(1920) & 
	LFInvTable(1904) & LFInvTable(1888) & LFInvTable(1872) & LFInvTable(1856) & LFInvTable(1840) & LFInvTable(1824) & LFInvTable(1808) & LFInvTable(1792) & 
	LFInvTable(1776) & LFInvTable(1760) & LFInvTable(1744) & LFInvTable(1728) & LFInvTable(1712) & LFInvTable(1696) & LFInvTable(1680) & LFInvTable(1664) & 
	LFInvTable(1648) & LFInvTable(1632) & LFInvTable(1616) & LFInvTable(1600) & LFInvTable(1584) & LFInvTable(1568) & LFInvTable(1552) & LFInvTable(1536) & 
	LFInvTable(1520) & LFInvTable(1504) & LFInvTable(1488) & LFInvTable(1472) & LFInvTable(1456) & LFInvTable(1440) & LFInvTable(1424) & LFInvTable(1408) & 
	LFInvTable(1392) & LFInvTable(1376) & LFInvTable(1360) & LFInvTable(1344) & LFInvTable(1328) & LFInvTable(1312) & LFInvTable(1296) & LFInvTable(1280) & 
	LFInvTable(1264) & LFInvTable(1248) & LFInvTable(1232) & LFInvTable(1216) & LFInvTable(1200) & LFInvTable(1184) & LFInvTable(1168) & LFInvTable(1152) & 
	LFInvTable(1136) & LFInvTable(1120) & LFInvTable(1104) & LFInvTable(1088) & LFInvTable(1072) & LFInvTable(1056) & LFInvTable(1040) & LFInvTable(1024) & 
	LFInvTable(1008) & LFInvTable(992) & LFInvTable(976) & LFInvTable(960) & LFInvTable(944) & LFInvTable(928) & LFInvTable(912) & LFInvTable(896) & 
	LFInvTable(880) & LFInvTable(864) & LFInvTable(848) & LFInvTable(832) & LFInvTable(816) & LFInvTable(800) & LFInvTable(784) & LFInvTable(768) & 
	LFInvTable(752) & LFInvTable(736) & LFInvTable(720) & LFInvTable(704) & LFInvTable(688) & LFInvTable(672) & LFInvTable(656) & LFInvTable(640) & 
	LFInvTable(624) & LFInvTable(608) & LFInvTable(592) & LFInvTable(576) & LFInvTable(560) & LFInvTable(544) & LFInvTable(528) & LFInvTable(512) & 
	LFInvTable(496) & LFInvTable(480) & LFInvTable(464) & LFInvTable(448) & LFInvTable(432) & LFInvTable(416) & LFInvTable(400) & LFInvTable(384) & 
	LFInvTable(368) & LFInvTable(352) & LFInvTable(336) & LFInvTable(320) & LFInvTable(304) & LFInvTable(288) & LFInvTable(272) & LFInvTable(256) & 
	LFInvTable(240) & LFInvTable(224) & LFInvTable(208) & LFInvTable(192) & LFInvTable(176) & LFInvTable(160) & LFInvTable(144) & LFInvTable(128) & 
	LFInvTable(112) & LFInvTable(96) & LFInvTable(80) & LFInvTable(64) & LFInvTable(48) & LFInvTable(32) & LFInvTable(16) & LFInvTable(0) ; 

	constant LFInvTable1 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	LFInvTable(4081) & LFInvTable(4065) & LFInvTable(4049) & LFInvTable(4033) & LFInvTable(4017) & LFInvTable(4001) & LFInvTable(3985) & LFInvTable(3969) & 
	LFInvTable(3953) & LFInvTable(3937) & LFInvTable(3921) & LFInvTable(3905) & LFInvTable(3889) & LFInvTable(3873) & LFInvTable(3857) & LFInvTable(3841) & 
	LFInvTable(3825) & LFInvTable(3809) & LFInvTable(3793) & LFInvTable(3777) & LFInvTable(3761) & LFInvTable(3745) & LFInvTable(3729) & LFInvTable(3713) & 
	LFInvTable(3697) & LFInvTable(3681) & LFInvTable(3665) & LFInvTable(3649) & LFInvTable(3633) & LFInvTable(3617) & LFInvTable(3601) & LFInvTable(3585) & 
	LFInvTable(3569) & LFInvTable(3553) & LFInvTable(3537) & LFInvTable(3521) & LFInvTable(3505) & LFInvTable(3489) & LFInvTable(3473) & LFInvTable(3457) & 
	LFInvTable(3441) & LFInvTable(3425) & LFInvTable(3409) & LFInvTable(3393) & LFInvTable(3377) & LFInvTable(3361) & LFInvTable(3345) & LFInvTable(3329) & 
	LFInvTable(3313) & LFInvTable(3297) & LFInvTable(3281) & LFInvTable(3265) & LFInvTable(3249) & LFInvTable(3233) & LFInvTable(3217) & LFInvTable(3201) & 
	LFInvTable(3185) & LFInvTable(3169) & LFInvTable(3153) & LFInvTable(3137) & LFInvTable(3121) & LFInvTable(3105) & LFInvTable(3089) & LFInvTable(3073) & 
	LFInvTable(3057) & LFInvTable(3041) & LFInvTable(3025) & LFInvTable(3009) & LFInvTable(2993) & LFInvTable(2977) & LFInvTable(2961) & LFInvTable(2945) & 
	LFInvTable(2929) & LFInvTable(2913) & LFInvTable(2897) & LFInvTable(2881) & LFInvTable(2865) & LFInvTable(2849) & LFInvTable(2833) & LFInvTable(2817) & 
	LFInvTable(2801) & LFInvTable(2785) & LFInvTable(2769) & LFInvTable(2753) & LFInvTable(2737) & LFInvTable(2721) & LFInvTable(2705) & LFInvTable(2689) & 
	LFInvTable(2673) & LFInvTable(2657) & LFInvTable(2641) & LFInvTable(2625) & LFInvTable(2609) & LFInvTable(2593) & LFInvTable(2577) & LFInvTable(2561) & 
	LFInvTable(2545) & LFInvTable(2529) & LFInvTable(2513) & LFInvTable(2497) & LFInvTable(2481) & LFInvTable(2465) & LFInvTable(2449) & LFInvTable(2433) & 
	LFInvTable(2417) & LFInvTable(2401) & LFInvTable(2385) & LFInvTable(2369) & LFInvTable(2353) & LFInvTable(2337) & LFInvTable(2321) & LFInvTable(2305) & 
	LFInvTable(2289) & LFInvTable(2273) & LFInvTable(2257) & LFInvTable(2241) & LFInvTable(2225) & LFInvTable(2209) & LFInvTable(2193) & LFInvTable(2177) & 
	LFInvTable(2161) & LFInvTable(2145) & LFInvTable(2129) & LFInvTable(2113) & LFInvTable(2097) & LFInvTable(2081) & LFInvTable(2065) & LFInvTable(2049) & 
	LFInvTable(2033) & LFInvTable(2017) & LFInvTable(2001) & LFInvTable(1985) & LFInvTable(1969) & LFInvTable(1953) & LFInvTable(1937) & LFInvTable(1921) & 
	LFInvTable(1905) & LFInvTable(1889) & LFInvTable(1873) & LFInvTable(1857) & LFInvTable(1841) & LFInvTable(1825) & LFInvTable(1809) & LFInvTable(1793) & 
	LFInvTable(1777) & LFInvTable(1761) & LFInvTable(1745) & LFInvTable(1729) & LFInvTable(1713) & LFInvTable(1697) & LFInvTable(1681) & LFInvTable(1665) & 
	LFInvTable(1649) & LFInvTable(1633) & LFInvTable(1617) & LFInvTable(1601) & LFInvTable(1585) & LFInvTable(1569) & LFInvTable(1553) & LFInvTable(1537) & 
	LFInvTable(1521) & LFInvTable(1505) & LFInvTable(1489) & LFInvTable(1473) & LFInvTable(1457) & LFInvTable(1441) & LFInvTable(1425) & LFInvTable(1409) & 
	LFInvTable(1393) & LFInvTable(1377) & LFInvTable(1361) & LFInvTable(1345) & LFInvTable(1329) & LFInvTable(1313) & LFInvTable(1297) & LFInvTable(1281) & 
	LFInvTable(1265) & LFInvTable(1249) & LFInvTable(1233) & LFInvTable(1217) & LFInvTable(1201) & LFInvTable(1185) & LFInvTable(1169) & LFInvTable(1153) & 
	LFInvTable(1137) & LFInvTable(1121) & LFInvTable(1105) & LFInvTable(1089) & LFInvTable(1073) & LFInvTable(1057) & LFInvTable(1041) & LFInvTable(1025) & 
	LFInvTable(1009) & LFInvTable(993) & LFInvTable(977) & LFInvTable(961) & LFInvTable(945) & LFInvTable(929) & LFInvTable(913) & LFInvTable(897) & 
	LFInvTable(881) & LFInvTable(865) & LFInvTable(849) & LFInvTable(833) & LFInvTable(817) & LFInvTable(801) & LFInvTable(785) & LFInvTable(769) & 
	LFInvTable(753) & LFInvTable(737) & LFInvTable(721) & LFInvTable(705) & LFInvTable(689) & LFInvTable(673) & LFInvTable(657) & LFInvTable(641) & 
	LFInvTable(625) & LFInvTable(609) & LFInvTable(593) & LFInvTable(577) & LFInvTable(561) & LFInvTable(545) & LFInvTable(529) & LFInvTable(513) & 
	LFInvTable(497) & LFInvTable(481) & LFInvTable(465) & LFInvTable(449) & LFInvTable(433) & LFInvTable(417) & LFInvTable(401) & LFInvTable(385) & 
	LFInvTable(369) & LFInvTable(353) & LFInvTable(337) & LFInvTable(321) & LFInvTable(305) & LFInvTable(289) & LFInvTable(273) & LFInvTable(257) & 
	LFInvTable(241) & LFInvTable(225) & LFInvTable(209) & LFInvTable(193) & LFInvTable(177) & LFInvTable(161) & LFInvTable(145) & LFInvTable(129) & 
	LFInvTable(113) & LFInvTable(97) & LFInvTable(81) & LFInvTable(65) & LFInvTable(49) & LFInvTable(33) & LFInvTable(17) & LFInvTable(1) ; 

	constant LFInvTable2 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	LFInvTable(4082) & LFInvTable(4066) & LFInvTable(4050) & LFInvTable(4034) & LFInvTable(4018) & LFInvTable(4002) & LFInvTable(3986) & LFInvTable(3970) & 
	LFInvTable(3954) & LFInvTable(3938) & LFInvTable(3922) & LFInvTable(3906) & LFInvTable(3890) & LFInvTable(3874) & LFInvTable(3858) & LFInvTable(3842) & 
	LFInvTable(3826) & LFInvTable(3810) & LFInvTable(3794) & LFInvTable(3778) & LFInvTable(3762) & LFInvTable(3746) & LFInvTable(3730) & LFInvTable(3714) & 
	LFInvTable(3698) & LFInvTable(3682) & LFInvTable(3666) & LFInvTable(3650) & LFInvTable(3634) & LFInvTable(3618) & LFInvTable(3602) & LFInvTable(3586) & 
	LFInvTable(3570) & LFInvTable(3554) & LFInvTable(3538) & LFInvTable(3522) & LFInvTable(3506) & LFInvTable(3490) & LFInvTable(3474) & LFInvTable(3458) & 
	LFInvTable(3442) & LFInvTable(3426) & LFInvTable(3410) & LFInvTable(3394) & LFInvTable(3378) & LFInvTable(3362) & LFInvTable(3346) & LFInvTable(3330) & 
	LFInvTable(3314) & LFInvTable(3298) & LFInvTable(3282) & LFInvTable(3266) & LFInvTable(3250) & LFInvTable(3234) & LFInvTable(3218) & LFInvTable(3202) & 
	LFInvTable(3186) & LFInvTable(3170) & LFInvTable(3154) & LFInvTable(3138) & LFInvTable(3122) & LFInvTable(3106) & LFInvTable(3090) & LFInvTable(3074) & 
	LFInvTable(3058) & LFInvTable(3042) & LFInvTable(3026) & LFInvTable(3010) & LFInvTable(2994) & LFInvTable(2978) & LFInvTable(2962) & LFInvTable(2946) & 
	LFInvTable(2930) & LFInvTable(2914) & LFInvTable(2898) & LFInvTable(2882) & LFInvTable(2866) & LFInvTable(2850) & LFInvTable(2834) & LFInvTable(2818) & 
	LFInvTable(2802) & LFInvTable(2786) & LFInvTable(2770) & LFInvTable(2754) & LFInvTable(2738) & LFInvTable(2722) & LFInvTable(2706) & LFInvTable(2690) & 
	LFInvTable(2674) & LFInvTable(2658) & LFInvTable(2642) & LFInvTable(2626) & LFInvTable(2610) & LFInvTable(2594) & LFInvTable(2578) & LFInvTable(2562) & 
	LFInvTable(2546) & LFInvTable(2530) & LFInvTable(2514) & LFInvTable(2498) & LFInvTable(2482) & LFInvTable(2466) & LFInvTable(2450) & LFInvTable(2434) & 
	LFInvTable(2418) & LFInvTable(2402) & LFInvTable(2386) & LFInvTable(2370) & LFInvTable(2354) & LFInvTable(2338) & LFInvTable(2322) & LFInvTable(2306) & 
	LFInvTable(2290) & LFInvTable(2274) & LFInvTable(2258) & LFInvTable(2242) & LFInvTable(2226) & LFInvTable(2210) & LFInvTable(2194) & LFInvTable(2178) & 
	LFInvTable(2162) & LFInvTable(2146) & LFInvTable(2130) & LFInvTable(2114) & LFInvTable(2098) & LFInvTable(2082) & LFInvTable(2066) & LFInvTable(2050) & 
	LFInvTable(2034) & LFInvTable(2018) & LFInvTable(2002) & LFInvTable(1986) & LFInvTable(1970) & LFInvTable(1954) & LFInvTable(1938) & LFInvTable(1922) & 
	LFInvTable(1906) & LFInvTable(1890) & LFInvTable(1874) & LFInvTable(1858) & LFInvTable(1842) & LFInvTable(1826) & LFInvTable(1810) & LFInvTable(1794) & 
	LFInvTable(1778) & LFInvTable(1762) & LFInvTable(1746) & LFInvTable(1730) & LFInvTable(1714) & LFInvTable(1698) & LFInvTable(1682) & LFInvTable(1666) & 
	LFInvTable(1650) & LFInvTable(1634) & LFInvTable(1618) & LFInvTable(1602) & LFInvTable(1586) & LFInvTable(1570) & LFInvTable(1554) & LFInvTable(1538) & 
	LFInvTable(1522) & LFInvTable(1506) & LFInvTable(1490) & LFInvTable(1474) & LFInvTable(1458) & LFInvTable(1442) & LFInvTable(1426) & LFInvTable(1410) & 
	LFInvTable(1394) & LFInvTable(1378) & LFInvTable(1362) & LFInvTable(1346) & LFInvTable(1330) & LFInvTable(1314) & LFInvTable(1298) & LFInvTable(1282) & 
	LFInvTable(1266) & LFInvTable(1250) & LFInvTable(1234) & LFInvTable(1218) & LFInvTable(1202) & LFInvTable(1186) & LFInvTable(1170) & LFInvTable(1154) & 
	LFInvTable(1138) & LFInvTable(1122) & LFInvTable(1106) & LFInvTable(1090) & LFInvTable(1074) & LFInvTable(1058) & LFInvTable(1042) & LFInvTable(1026) & 
	LFInvTable(1010) & LFInvTable(994) & LFInvTable(978) & LFInvTable(962) & LFInvTable(946) & LFInvTable(930) & LFInvTable(914) & LFInvTable(898) & 
	LFInvTable(882) & LFInvTable(866) & LFInvTable(850) & LFInvTable(834) & LFInvTable(818) & LFInvTable(802) & LFInvTable(786) & LFInvTable(770) & 
	LFInvTable(754) & LFInvTable(738) & LFInvTable(722) & LFInvTable(706) & LFInvTable(690) & LFInvTable(674) & LFInvTable(658) & LFInvTable(642) & 
	LFInvTable(626) & LFInvTable(610) & LFInvTable(594) & LFInvTable(578) & LFInvTable(562) & LFInvTable(546) & LFInvTable(530) & LFInvTable(514) & 
	LFInvTable(498) & LFInvTable(482) & LFInvTable(466) & LFInvTable(450) & LFInvTable(434) & LFInvTable(418) & LFInvTable(402) & LFInvTable(386) & 
	LFInvTable(370) & LFInvTable(354) & LFInvTable(338) & LFInvTable(322) & LFInvTable(306) & LFInvTable(290) & LFInvTable(274) & LFInvTable(258) & 
	LFInvTable(242) & LFInvTable(226) & LFInvTable(210) & LFInvTable(194) & LFInvTable(178) & LFInvTable(162) & LFInvTable(146) & LFInvTable(130) & 
	LFInvTable(114) & LFInvTable(98) & LFInvTable(82) & LFInvTable(66) & LFInvTable(50) & LFInvTable(34) & LFInvTable(18) & LFInvTable(2) ; 

	constant LFInvTable3 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	LFInvTable(4083) & LFInvTable(4067) & LFInvTable(4051) & LFInvTable(4035) & LFInvTable(4019) & LFInvTable(4003) & LFInvTable(3987) & LFInvTable(3971) & 
	LFInvTable(3955) & LFInvTable(3939) & LFInvTable(3923) & LFInvTable(3907) & LFInvTable(3891) & LFInvTable(3875) & LFInvTable(3859) & LFInvTable(3843) & 
	LFInvTable(3827) & LFInvTable(3811) & LFInvTable(3795) & LFInvTable(3779) & LFInvTable(3763) & LFInvTable(3747) & LFInvTable(3731) & LFInvTable(3715) & 
	LFInvTable(3699) & LFInvTable(3683) & LFInvTable(3667) & LFInvTable(3651) & LFInvTable(3635) & LFInvTable(3619) & LFInvTable(3603) & LFInvTable(3587) & 
	LFInvTable(3571) & LFInvTable(3555) & LFInvTable(3539) & LFInvTable(3523) & LFInvTable(3507) & LFInvTable(3491) & LFInvTable(3475) & LFInvTable(3459) & 
	LFInvTable(3443) & LFInvTable(3427) & LFInvTable(3411) & LFInvTable(3395) & LFInvTable(3379) & LFInvTable(3363) & LFInvTable(3347) & LFInvTable(3331) & 
	LFInvTable(3315) & LFInvTable(3299) & LFInvTable(3283) & LFInvTable(3267) & LFInvTable(3251) & LFInvTable(3235) & LFInvTable(3219) & LFInvTable(3203) & 
	LFInvTable(3187) & LFInvTable(3171) & LFInvTable(3155) & LFInvTable(3139) & LFInvTable(3123) & LFInvTable(3107) & LFInvTable(3091) & LFInvTable(3075) & 
	LFInvTable(3059) & LFInvTable(3043) & LFInvTable(3027) & LFInvTable(3011) & LFInvTable(2995) & LFInvTable(2979) & LFInvTable(2963) & LFInvTable(2947) & 
	LFInvTable(2931) & LFInvTable(2915) & LFInvTable(2899) & LFInvTable(2883) & LFInvTable(2867) & LFInvTable(2851) & LFInvTable(2835) & LFInvTable(2819) & 
	LFInvTable(2803) & LFInvTable(2787) & LFInvTable(2771) & LFInvTable(2755) & LFInvTable(2739) & LFInvTable(2723) & LFInvTable(2707) & LFInvTable(2691) & 
	LFInvTable(2675) & LFInvTable(2659) & LFInvTable(2643) & LFInvTable(2627) & LFInvTable(2611) & LFInvTable(2595) & LFInvTable(2579) & LFInvTable(2563) & 
	LFInvTable(2547) & LFInvTable(2531) & LFInvTable(2515) & LFInvTable(2499) & LFInvTable(2483) & LFInvTable(2467) & LFInvTable(2451) & LFInvTable(2435) & 
	LFInvTable(2419) & LFInvTable(2403) & LFInvTable(2387) & LFInvTable(2371) & LFInvTable(2355) & LFInvTable(2339) & LFInvTable(2323) & LFInvTable(2307) & 
	LFInvTable(2291) & LFInvTable(2275) & LFInvTable(2259) & LFInvTable(2243) & LFInvTable(2227) & LFInvTable(2211) & LFInvTable(2195) & LFInvTable(2179) & 
	LFInvTable(2163) & LFInvTable(2147) & LFInvTable(2131) & LFInvTable(2115) & LFInvTable(2099) & LFInvTable(2083) & LFInvTable(2067) & LFInvTable(2051) & 
	LFInvTable(2035) & LFInvTable(2019) & LFInvTable(2003) & LFInvTable(1987) & LFInvTable(1971) & LFInvTable(1955) & LFInvTable(1939) & LFInvTable(1923) & 
	LFInvTable(1907) & LFInvTable(1891) & LFInvTable(1875) & LFInvTable(1859) & LFInvTable(1843) & LFInvTable(1827) & LFInvTable(1811) & LFInvTable(1795) & 
	LFInvTable(1779) & LFInvTable(1763) & LFInvTable(1747) & LFInvTable(1731) & LFInvTable(1715) & LFInvTable(1699) & LFInvTable(1683) & LFInvTable(1667) & 
	LFInvTable(1651) & LFInvTable(1635) & LFInvTable(1619) & LFInvTable(1603) & LFInvTable(1587) & LFInvTable(1571) & LFInvTable(1555) & LFInvTable(1539) & 
	LFInvTable(1523) & LFInvTable(1507) & LFInvTable(1491) & LFInvTable(1475) & LFInvTable(1459) & LFInvTable(1443) & LFInvTable(1427) & LFInvTable(1411) & 
	LFInvTable(1395) & LFInvTable(1379) & LFInvTable(1363) & LFInvTable(1347) & LFInvTable(1331) & LFInvTable(1315) & LFInvTable(1299) & LFInvTable(1283) & 
	LFInvTable(1267) & LFInvTable(1251) & LFInvTable(1235) & LFInvTable(1219) & LFInvTable(1203) & LFInvTable(1187) & LFInvTable(1171) & LFInvTable(1155) & 
	LFInvTable(1139) & LFInvTable(1123) & LFInvTable(1107) & LFInvTable(1091) & LFInvTable(1075) & LFInvTable(1059) & LFInvTable(1043) & LFInvTable(1027) & 
	LFInvTable(1011) & LFInvTable(995) & LFInvTable(979) & LFInvTable(963) & LFInvTable(947) & LFInvTable(931) & LFInvTable(915) & LFInvTable(899) & 
	LFInvTable(883) & LFInvTable(867) & LFInvTable(851) & LFInvTable(835) & LFInvTable(819) & LFInvTable(803) & LFInvTable(787) & LFInvTable(771) & 
	LFInvTable(755) & LFInvTable(739) & LFInvTable(723) & LFInvTable(707) & LFInvTable(691) & LFInvTable(675) & LFInvTable(659) & LFInvTable(643) & 
	LFInvTable(627) & LFInvTable(611) & LFInvTable(595) & LFInvTable(579) & LFInvTable(563) & LFInvTable(547) & LFInvTable(531) & LFInvTable(515) & 
	LFInvTable(499) & LFInvTable(483) & LFInvTable(467) & LFInvTable(451) & LFInvTable(435) & LFInvTable(419) & LFInvTable(403) & LFInvTable(387) & 
	LFInvTable(371) & LFInvTable(355) & LFInvTable(339) & LFInvTable(323) & LFInvTable(307) & LFInvTable(291) & LFInvTable(275) & LFInvTable(259) & 
	LFInvTable(243) & LFInvTable(227) & LFInvTable(211) & LFInvTable(195) & LFInvTable(179) & LFInvTable(163) & LFInvTable(147) & LFInvTable(131) & 
	LFInvTable(115) & LFInvTable(99) & LFInvTable(83) & LFInvTable(67) & LFInvTable(51) & LFInvTable(35) & LFInvTable(19) & LFInvTable(3) ; 

	constant LFInvTable4 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	LFInvTable(4084) & LFInvTable(4068) & LFInvTable(4052) & LFInvTable(4036) & LFInvTable(4020) & LFInvTable(4004) & LFInvTable(3988) & LFInvTable(3972) & 
	LFInvTable(3956) & LFInvTable(3940) & LFInvTable(3924) & LFInvTable(3908) & LFInvTable(3892) & LFInvTable(3876) & LFInvTable(3860) & LFInvTable(3844) & 
	LFInvTable(3828) & LFInvTable(3812) & LFInvTable(3796) & LFInvTable(3780) & LFInvTable(3764) & LFInvTable(3748) & LFInvTable(3732) & LFInvTable(3716) & 
	LFInvTable(3700) & LFInvTable(3684) & LFInvTable(3668) & LFInvTable(3652) & LFInvTable(3636) & LFInvTable(3620) & LFInvTable(3604) & LFInvTable(3588) & 
	LFInvTable(3572) & LFInvTable(3556) & LFInvTable(3540) & LFInvTable(3524) & LFInvTable(3508) & LFInvTable(3492) & LFInvTable(3476) & LFInvTable(3460) & 
	LFInvTable(3444) & LFInvTable(3428) & LFInvTable(3412) & LFInvTable(3396) & LFInvTable(3380) & LFInvTable(3364) & LFInvTable(3348) & LFInvTable(3332) & 
	LFInvTable(3316) & LFInvTable(3300) & LFInvTable(3284) & LFInvTable(3268) & LFInvTable(3252) & LFInvTable(3236) & LFInvTable(3220) & LFInvTable(3204) & 
	LFInvTable(3188) & LFInvTable(3172) & LFInvTable(3156) & LFInvTable(3140) & LFInvTable(3124) & LFInvTable(3108) & LFInvTable(3092) & LFInvTable(3076) & 
	LFInvTable(3060) & LFInvTable(3044) & LFInvTable(3028) & LFInvTable(3012) & LFInvTable(2996) & LFInvTable(2980) & LFInvTable(2964) & LFInvTable(2948) & 
	LFInvTable(2932) & LFInvTable(2916) & LFInvTable(2900) & LFInvTable(2884) & LFInvTable(2868) & LFInvTable(2852) & LFInvTable(2836) & LFInvTable(2820) & 
	LFInvTable(2804) & LFInvTable(2788) & LFInvTable(2772) & LFInvTable(2756) & LFInvTable(2740) & LFInvTable(2724) & LFInvTable(2708) & LFInvTable(2692) & 
	LFInvTable(2676) & LFInvTable(2660) & LFInvTable(2644) & LFInvTable(2628) & LFInvTable(2612) & LFInvTable(2596) & LFInvTable(2580) & LFInvTable(2564) & 
	LFInvTable(2548) & LFInvTable(2532) & LFInvTable(2516) & LFInvTable(2500) & LFInvTable(2484) & LFInvTable(2468) & LFInvTable(2452) & LFInvTable(2436) & 
	LFInvTable(2420) & LFInvTable(2404) & LFInvTable(2388) & LFInvTable(2372) & LFInvTable(2356) & LFInvTable(2340) & LFInvTable(2324) & LFInvTable(2308) & 
	LFInvTable(2292) & LFInvTable(2276) & LFInvTable(2260) & LFInvTable(2244) & LFInvTable(2228) & LFInvTable(2212) & LFInvTable(2196) & LFInvTable(2180) & 
	LFInvTable(2164) & LFInvTable(2148) & LFInvTable(2132) & LFInvTable(2116) & LFInvTable(2100) & LFInvTable(2084) & LFInvTable(2068) & LFInvTable(2052) & 
	LFInvTable(2036) & LFInvTable(2020) & LFInvTable(2004) & LFInvTable(1988) & LFInvTable(1972) & LFInvTable(1956) & LFInvTable(1940) & LFInvTable(1924) & 
	LFInvTable(1908) & LFInvTable(1892) & LFInvTable(1876) & LFInvTable(1860) & LFInvTable(1844) & LFInvTable(1828) & LFInvTable(1812) & LFInvTable(1796) & 
	LFInvTable(1780) & LFInvTable(1764) & LFInvTable(1748) & LFInvTable(1732) & LFInvTable(1716) & LFInvTable(1700) & LFInvTable(1684) & LFInvTable(1668) & 
	LFInvTable(1652) & LFInvTable(1636) & LFInvTable(1620) & LFInvTable(1604) & LFInvTable(1588) & LFInvTable(1572) & LFInvTable(1556) & LFInvTable(1540) & 
	LFInvTable(1524) & LFInvTable(1508) & LFInvTable(1492) & LFInvTable(1476) & LFInvTable(1460) & LFInvTable(1444) & LFInvTable(1428) & LFInvTable(1412) & 
	LFInvTable(1396) & LFInvTable(1380) & LFInvTable(1364) & LFInvTable(1348) & LFInvTable(1332) & LFInvTable(1316) & LFInvTable(1300) & LFInvTable(1284) & 
	LFInvTable(1268) & LFInvTable(1252) & LFInvTable(1236) & LFInvTable(1220) & LFInvTable(1204) & LFInvTable(1188) & LFInvTable(1172) & LFInvTable(1156) & 
	LFInvTable(1140) & LFInvTable(1124) & LFInvTable(1108) & LFInvTable(1092) & LFInvTable(1076) & LFInvTable(1060) & LFInvTable(1044) & LFInvTable(1028) & 
	LFInvTable(1012) & LFInvTable(996) & LFInvTable(980) & LFInvTable(964) & LFInvTable(948) & LFInvTable(932) & LFInvTable(916) & LFInvTable(900) & 
	LFInvTable(884) & LFInvTable(868) & LFInvTable(852) & LFInvTable(836) & LFInvTable(820) & LFInvTable(804) & LFInvTable(788) & LFInvTable(772) & 
	LFInvTable(756) & LFInvTable(740) & LFInvTable(724) & LFInvTable(708) & LFInvTable(692) & LFInvTable(676) & LFInvTable(660) & LFInvTable(644) & 
	LFInvTable(628) & LFInvTable(612) & LFInvTable(596) & LFInvTable(580) & LFInvTable(564) & LFInvTable(548) & LFInvTable(532) & LFInvTable(516) & 
	LFInvTable(500) & LFInvTable(484) & LFInvTable(468) & LFInvTable(452) & LFInvTable(436) & LFInvTable(420) & LFInvTable(404) & LFInvTable(388) & 
	LFInvTable(372) & LFInvTable(356) & LFInvTable(340) & LFInvTable(324) & LFInvTable(308) & LFInvTable(292) & LFInvTable(276) & LFInvTable(260) & 
	LFInvTable(244) & LFInvTable(228) & LFInvTable(212) & LFInvTable(196) & LFInvTable(180) & LFInvTable(164) & LFInvTable(148) & LFInvTable(132) & 
	LFInvTable(116) & LFInvTable(100) & LFInvTable(84) & LFInvTable(68) & LFInvTable(52) & LFInvTable(36) & LFInvTable(20) & LFInvTable(4) ; 

	constant LFInvTable5 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	LFInvTable(4085) & LFInvTable(4069) & LFInvTable(4053) & LFInvTable(4037) & LFInvTable(4021) & LFInvTable(4005) & LFInvTable(3989) & LFInvTable(3973) & 
	LFInvTable(3957) & LFInvTable(3941) & LFInvTable(3925) & LFInvTable(3909) & LFInvTable(3893) & LFInvTable(3877) & LFInvTable(3861) & LFInvTable(3845) & 
	LFInvTable(3829) & LFInvTable(3813) & LFInvTable(3797) & LFInvTable(3781) & LFInvTable(3765) & LFInvTable(3749) & LFInvTable(3733) & LFInvTable(3717) & 
	LFInvTable(3701) & LFInvTable(3685) & LFInvTable(3669) & LFInvTable(3653) & LFInvTable(3637) & LFInvTable(3621) & LFInvTable(3605) & LFInvTable(3589) & 
	LFInvTable(3573) & LFInvTable(3557) & LFInvTable(3541) & LFInvTable(3525) & LFInvTable(3509) & LFInvTable(3493) & LFInvTable(3477) & LFInvTable(3461) & 
	LFInvTable(3445) & LFInvTable(3429) & LFInvTable(3413) & LFInvTable(3397) & LFInvTable(3381) & LFInvTable(3365) & LFInvTable(3349) & LFInvTable(3333) & 
	LFInvTable(3317) & LFInvTable(3301) & LFInvTable(3285) & LFInvTable(3269) & LFInvTable(3253) & LFInvTable(3237) & LFInvTable(3221) & LFInvTable(3205) & 
	LFInvTable(3189) & LFInvTable(3173) & LFInvTable(3157) & LFInvTable(3141) & LFInvTable(3125) & LFInvTable(3109) & LFInvTable(3093) & LFInvTable(3077) & 
	LFInvTable(3061) & LFInvTable(3045) & LFInvTable(3029) & LFInvTable(3013) & LFInvTable(2997) & LFInvTable(2981) & LFInvTable(2965) & LFInvTable(2949) & 
	LFInvTable(2933) & LFInvTable(2917) & LFInvTable(2901) & LFInvTable(2885) & LFInvTable(2869) & LFInvTable(2853) & LFInvTable(2837) & LFInvTable(2821) & 
	LFInvTable(2805) & LFInvTable(2789) & LFInvTable(2773) & LFInvTable(2757) & LFInvTable(2741) & LFInvTable(2725) & LFInvTable(2709) & LFInvTable(2693) & 
	LFInvTable(2677) & LFInvTable(2661) & LFInvTable(2645) & LFInvTable(2629) & LFInvTable(2613) & LFInvTable(2597) & LFInvTable(2581) & LFInvTable(2565) & 
	LFInvTable(2549) & LFInvTable(2533) & LFInvTable(2517) & LFInvTable(2501) & LFInvTable(2485) & LFInvTable(2469) & LFInvTable(2453) & LFInvTable(2437) & 
	LFInvTable(2421) & LFInvTable(2405) & LFInvTable(2389) & LFInvTable(2373) & LFInvTable(2357) & LFInvTable(2341) & LFInvTable(2325) & LFInvTable(2309) & 
	LFInvTable(2293) & LFInvTable(2277) & LFInvTable(2261) & LFInvTable(2245) & LFInvTable(2229) & LFInvTable(2213) & LFInvTable(2197) & LFInvTable(2181) & 
	LFInvTable(2165) & LFInvTable(2149) & LFInvTable(2133) & LFInvTable(2117) & LFInvTable(2101) & LFInvTable(2085) & LFInvTable(2069) & LFInvTable(2053) & 
	LFInvTable(2037) & LFInvTable(2021) & LFInvTable(2005) & LFInvTable(1989) & LFInvTable(1973) & LFInvTable(1957) & LFInvTable(1941) & LFInvTable(1925) & 
	LFInvTable(1909) & LFInvTable(1893) & LFInvTable(1877) & LFInvTable(1861) & LFInvTable(1845) & LFInvTable(1829) & LFInvTable(1813) & LFInvTable(1797) & 
	LFInvTable(1781) & LFInvTable(1765) & LFInvTable(1749) & LFInvTable(1733) & LFInvTable(1717) & LFInvTable(1701) & LFInvTable(1685) & LFInvTable(1669) & 
	LFInvTable(1653) & LFInvTable(1637) & LFInvTable(1621) & LFInvTable(1605) & LFInvTable(1589) & LFInvTable(1573) & LFInvTable(1557) & LFInvTable(1541) & 
	LFInvTable(1525) & LFInvTable(1509) & LFInvTable(1493) & LFInvTable(1477) & LFInvTable(1461) & LFInvTable(1445) & LFInvTable(1429) & LFInvTable(1413) & 
	LFInvTable(1397) & LFInvTable(1381) & LFInvTable(1365) & LFInvTable(1349) & LFInvTable(1333) & LFInvTable(1317) & LFInvTable(1301) & LFInvTable(1285) & 
	LFInvTable(1269) & LFInvTable(1253) & LFInvTable(1237) & LFInvTable(1221) & LFInvTable(1205) & LFInvTable(1189) & LFInvTable(1173) & LFInvTable(1157) & 
	LFInvTable(1141) & LFInvTable(1125) & LFInvTable(1109) & LFInvTable(1093) & LFInvTable(1077) & LFInvTable(1061) & LFInvTable(1045) & LFInvTable(1029) & 
	LFInvTable(1013) & LFInvTable(997) & LFInvTable(981) & LFInvTable(965) & LFInvTable(949) & LFInvTable(933) & LFInvTable(917) & LFInvTable(901) & 
	LFInvTable(885) & LFInvTable(869) & LFInvTable(853) & LFInvTable(837) & LFInvTable(821) & LFInvTable(805) & LFInvTable(789) & LFInvTable(773) & 
	LFInvTable(757) & LFInvTable(741) & LFInvTable(725) & LFInvTable(709) & LFInvTable(693) & LFInvTable(677) & LFInvTable(661) & LFInvTable(645) & 
	LFInvTable(629) & LFInvTable(613) & LFInvTable(597) & LFInvTable(581) & LFInvTable(565) & LFInvTable(549) & LFInvTable(533) & LFInvTable(517) & 
	LFInvTable(501) & LFInvTable(485) & LFInvTable(469) & LFInvTable(453) & LFInvTable(437) & LFInvTable(421) & LFInvTable(405) & LFInvTable(389) & 
	LFInvTable(373) & LFInvTable(357) & LFInvTable(341) & LFInvTable(325) & LFInvTable(309) & LFInvTable(293) & LFInvTable(277) & LFInvTable(261) & 
	LFInvTable(245) & LFInvTable(229) & LFInvTable(213) & LFInvTable(197) & LFInvTable(181) & LFInvTable(165) & LFInvTable(149) & LFInvTable(133) & 
	LFInvTable(117) & LFInvTable(101) & LFInvTable(85) & LFInvTable(69) & LFInvTable(53) & LFInvTable(37) & LFInvTable(21) & LFInvTable(5) ; 

	constant LFInvTable6 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	LFInvTable(4086) & LFInvTable(4070) & LFInvTable(4054) & LFInvTable(4038) & LFInvTable(4022) & LFInvTable(4006) & LFInvTable(3990) & LFInvTable(3974) & 
	LFInvTable(3958) & LFInvTable(3942) & LFInvTable(3926) & LFInvTable(3910) & LFInvTable(3894) & LFInvTable(3878) & LFInvTable(3862) & LFInvTable(3846) & 
	LFInvTable(3830) & LFInvTable(3814) & LFInvTable(3798) & LFInvTable(3782) & LFInvTable(3766) & LFInvTable(3750) & LFInvTable(3734) & LFInvTable(3718) & 
	LFInvTable(3702) & LFInvTable(3686) & LFInvTable(3670) & LFInvTable(3654) & LFInvTable(3638) & LFInvTable(3622) & LFInvTable(3606) & LFInvTable(3590) & 
	LFInvTable(3574) & LFInvTable(3558) & LFInvTable(3542) & LFInvTable(3526) & LFInvTable(3510) & LFInvTable(3494) & LFInvTable(3478) & LFInvTable(3462) & 
	LFInvTable(3446) & LFInvTable(3430) & LFInvTable(3414) & LFInvTable(3398) & LFInvTable(3382) & LFInvTable(3366) & LFInvTable(3350) & LFInvTable(3334) & 
	LFInvTable(3318) & LFInvTable(3302) & LFInvTable(3286) & LFInvTable(3270) & LFInvTable(3254) & LFInvTable(3238) & LFInvTable(3222) & LFInvTable(3206) & 
	LFInvTable(3190) & LFInvTable(3174) & LFInvTable(3158) & LFInvTable(3142) & LFInvTable(3126) & LFInvTable(3110) & LFInvTable(3094) & LFInvTable(3078) & 
	LFInvTable(3062) & LFInvTable(3046) & LFInvTable(3030) & LFInvTable(3014) & LFInvTable(2998) & LFInvTable(2982) & LFInvTable(2966) & LFInvTable(2950) & 
	LFInvTable(2934) & LFInvTable(2918) & LFInvTable(2902) & LFInvTable(2886) & LFInvTable(2870) & LFInvTable(2854) & LFInvTable(2838) & LFInvTable(2822) & 
	LFInvTable(2806) & LFInvTable(2790) & LFInvTable(2774) & LFInvTable(2758) & LFInvTable(2742) & LFInvTable(2726) & LFInvTable(2710) & LFInvTable(2694) & 
	LFInvTable(2678) & LFInvTable(2662) & LFInvTable(2646) & LFInvTable(2630) & LFInvTable(2614) & LFInvTable(2598) & LFInvTable(2582) & LFInvTable(2566) & 
	LFInvTable(2550) & LFInvTable(2534) & LFInvTable(2518) & LFInvTable(2502) & LFInvTable(2486) & LFInvTable(2470) & LFInvTable(2454) & LFInvTable(2438) & 
	LFInvTable(2422) & LFInvTable(2406) & LFInvTable(2390) & LFInvTable(2374) & LFInvTable(2358) & LFInvTable(2342) & LFInvTable(2326) & LFInvTable(2310) & 
	LFInvTable(2294) & LFInvTable(2278) & LFInvTable(2262) & LFInvTable(2246) & LFInvTable(2230) & LFInvTable(2214) & LFInvTable(2198) & LFInvTable(2182) & 
	LFInvTable(2166) & LFInvTable(2150) & LFInvTable(2134) & LFInvTable(2118) & LFInvTable(2102) & LFInvTable(2086) & LFInvTable(2070) & LFInvTable(2054) & 
	LFInvTable(2038) & LFInvTable(2022) & LFInvTable(2006) & LFInvTable(1990) & LFInvTable(1974) & LFInvTable(1958) & LFInvTable(1942) & LFInvTable(1926) & 
	LFInvTable(1910) & LFInvTable(1894) & LFInvTable(1878) & LFInvTable(1862) & LFInvTable(1846) & LFInvTable(1830) & LFInvTable(1814) & LFInvTable(1798) & 
	LFInvTable(1782) & LFInvTable(1766) & LFInvTable(1750) & LFInvTable(1734) & LFInvTable(1718) & LFInvTable(1702) & LFInvTable(1686) & LFInvTable(1670) & 
	LFInvTable(1654) & LFInvTable(1638) & LFInvTable(1622) & LFInvTable(1606) & LFInvTable(1590) & LFInvTable(1574) & LFInvTable(1558) & LFInvTable(1542) & 
	LFInvTable(1526) & LFInvTable(1510) & LFInvTable(1494) & LFInvTable(1478) & LFInvTable(1462) & LFInvTable(1446) & LFInvTable(1430) & LFInvTable(1414) & 
	LFInvTable(1398) & LFInvTable(1382) & LFInvTable(1366) & LFInvTable(1350) & LFInvTable(1334) & LFInvTable(1318) & LFInvTable(1302) & LFInvTable(1286) & 
	LFInvTable(1270) & LFInvTable(1254) & LFInvTable(1238) & LFInvTable(1222) & LFInvTable(1206) & LFInvTable(1190) & LFInvTable(1174) & LFInvTable(1158) & 
	LFInvTable(1142) & LFInvTable(1126) & LFInvTable(1110) & LFInvTable(1094) & LFInvTable(1078) & LFInvTable(1062) & LFInvTable(1046) & LFInvTable(1030) & 
	LFInvTable(1014) & LFInvTable(998) & LFInvTable(982) & LFInvTable(966) & LFInvTable(950) & LFInvTable(934) & LFInvTable(918) & LFInvTable(902) & 
	LFInvTable(886) & LFInvTable(870) & LFInvTable(854) & LFInvTable(838) & LFInvTable(822) & LFInvTable(806) & LFInvTable(790) & LFInvTable(774) & 
	LFInvTable(758) & LFInvTable(742) & LFInvTable(726) & LFInvTable(710) & LFInvTable(694) & LFInvTable(678) & LFInvTable(662) & LFInvTable(646) & 
	LFInvTable(630) & LFInvTable(614) & LFInvTable(598) & LFInvTable(582) & LFInvTable(566) & LFInvTable(550) & LFInvTable(534) & LFInvTable(518) & 
	LFInvTable(502) & LFInvTable(486) & LFInvTable(470) & LFInvTable(454) & LFInvTable(438) & LFInvTable(422) & LFInvTable(406) & LFInvTable(390) & 
	LFInvTable(374) & LFInvTable(358) & LFInvTable(342) & LFInvTable(326) & LFInvTable(310) & LFInvTable(294) & LFInvTable(278) & LFInvTable(262) & 
	LFInvTable(246) & LFInvTable(230) & LFInvTable(214) & LFInvTable(198) & LFInvTable(182) & LFInvTable(166) & LFInvTable(150) & LFInvTable(134) & 
	LFInvTable(118) & LFInvTable(102) & LFInvTable(86) & LFInvTable(70) & LFInvTable(54) & LFInvTable(38) & LFInvTable(22) & LFInvTable(6) ; 

	constant LFInvTable7 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	LFInvTable(4087) & LFInvTable(4071) & LFInvTable(4055) & LFInvTable(4039) & LFInvTable(4023) & LFInvTable(4007) & LFInvTable(3991) & LFInvTable(3975) & 
	LFInvTable(3959) & LFInvTable(3943) & LFInvTable(3927) & LFInvTable(3911) & LFInvTable(3895) & LFInvTable(3879) & LFInvTable(3863) & LFInvTable(3847) & 
	LFInvTable(3831) & LFInvTable(3815) & LFInvTable(3799) & LFInvTable(3783) & LFInvTable(3767) & LFInvTable(3751) & LFInvTable(3735) & LFInvTable(3719) & 
	LFInvTable(3703) & LFInvTable(3687) & LFInvTable(3671) & LFInvTable(3655) & LFInvTable(3639) & LFInvTable(3623) & LFInvTable(3607) & LFInvTable(3591) & 
	LFInvTable(3575) & LFInvTable(3559) & LFInvTable(3543) & LFInvTable(3527) & LFInvTable(3511) & LFInvTable(3495) & LFInvTable(3479) & LFInvTable(3463) & 
	LFInvTable(3447) & LFInvTable(3431) & LFInvTable(3415) & LFInvTable(3399) & LFInvTable(3383) & LFInvTable(3367) & LFInvTable(3351) & LFInvTable(3335) & 
	LFInvTable(3319) & LFInvTable(3303) & LFInvTable(3287) & LFInvTable(3271) & LFInvTable(3255) & LFInvTable(3239) & LFInvTable(3223) & LFInvTable(3207) & 
	LFInvTable(3191) & LFInvTable(3175) & LFInvTable(3159) & LFInvTable(3143) & LFInvTable(3127) & LFInvTable(3111) & LFInvTable(3095) & LFInvTable(3079) & 
	LFInvTable(3063) & LFInvTable(3047) & LFInvTable(3031) & LFInvTable(3015) & LFInvTable(2999) & LFInvTable(2983) & LFInvTable(2967) & LFInvTable(2951) & 
	LFInvTable(2935) & LFInvTable(2919) & LFInvTable(2903) & LFInvTable(2887) & LFInvTable(2871) & LFInvTable(2855) & LFInvTable(2839) & LFInvTable(2823) & 
	LFInvTable(2807) & LFInvTable(2791) & LFInvTable(2775) & LFInvTable(2759) & LFInvTable(2743) & LFInvTable(2727) & LFInvTable(2711) & LFInvTable(2695) & 
	LFInvTable(2679) & LFInvTable(2663) & LFInvTable(2647) & LFInvTable(2631) & LFInvTable(2615) & LFInvTable(2599) & LFInvTable(2583) & LFInvTable(2567) & 
	LFInvTable(2551) & LFInvTable(2535) & LFInvTable(2519) & LFInvTable(2503) & LFInvTable(2487) & LFInvTable(2471) & LFInvTable(2455) & LFInvTable(2439) & 
	LFInvTable(2423) & LFInvTable(2407) & LFInvTable(2391) & LFInvTable(2375) & LFInvTable(2359) & LFInvTable(2343) & LFInvTable(2327) & LFInvTable(2311) & 
	LFInvTable(2295) & LFInvTable(2279) & LFInvTable(2263) & LFInvTable(2247) & LFInvTable(2231) & LFInvTable(2215) & LFInvTable(2199) & LFInvTable(2183) & 
	LFInvTable(2167) & LFInvTable(2151) & LFInvTable(2135) & LFInvTable(2119) & LFInvTable(2103) & LFInvTable(2087) & LFInvTable(2071) & LFInvTable(2055) & 
	LFInvTable(2039) & LFInvTable(2023) & LFInvTable(2007) & LFInvTable(1991) & LFInvTable(1975) & LFInvTable(1959) & LFInvTable(1943) & LFInvTable(1927) & 
	LFInvTable(1911) & LFInvTable(1895) & LFInvTable(1879) & LFInvTable(1863) & LFInvTable(1847) & LFInvTable(1831) & LFInvTable(1815) & LFInvTable(1799) & 
	LFInvTable(1783) & LFInvTable(1767) & LFInvTable(1751) & LFInvTable(1735) & LFInvTable(1719) & LFInvTable(1703) & LFInvTable(1687) & LFInvTable(1671) & 
	LFInvTable(1655) & LFInvTable(1639) & LFInvTable(1623) & LFInvTable(1607) & LFInvTable(1591) & LFInvTable(1575) & LFInvTable(1559) & LFInvTable(1543) & 
	LFInvTable(1527) & LFInvTable(1511) & LFInvTable(1495) & LFInvTable(1479) & LFInvTable(1463) & LFInvTable(1447) & LFInvTable(1431) & LFInvTable(1415) & 
	LFInvTable(1399) & LFInvTable(1383) & LFInvTable(1367) & LFInvTable(1351) & LFInvTable(1335) & LFInvTable(1319) & LFInvTable(1303) & LFInvTable(1287) & 
	LFInvTable(1271) & LFInvTable(1255) & LFInvTable(1239) & LFInvTable(1223) & LFInvTable(1207) & LFInvTable(1191) & LFInvTable(1175) & LFInvTable(1159) & 
	LFInvTable(1143) & LFInvTable(1127) & LFInvTable(1111) & LFInvTable(1095) & LFInvTable(1079) & LFInvTable(1063) & LFInvTable(1047) & LFInvTable(1031) & 
	LFInvTable(1015) & LFInvTable(999) & LFInvTable(983) & LFInvTable(967) & LFInvTable(951) & LFInvTable(935) & LFInvTable(919) & LFInvTable(903) & 
	LFInvTable(887) & LFInvTable(871) & LFInvTable(855) & LFInvTable(839) & LFInvTable(823) & LFInvTable(807) & LFInvTable(791) & LFInvTable(775) & 
	LFInvTable(759) & LFInvTable(743) & LFInvTable(727) & LFInvTable(711) & LFInvTable(695) & LFInvTable(679) & LFInvTable(663) & LFInvTable(647) & 
	LFInvTable(631) & LFInvTable(615) & LFInvTable(599) & LFInvTable(583) & LFInvTable(567) & LFInvTable(551) & LFInvTable(535) & LFInvTable(519) & 
	LFInvTable(503) & LFInvTable(487) & LFInvTable(471) & LFInvTable(455) & LFInvTable(439) & LFInvTable(423) & LFInvTable(407) & LFInvTable(391) & 
	LFInvTable(375) & LFInvTable(359) & LFInvTable(343) & LFInvTable(327) & LFInvTable(311) & LFInvTable(295) & LFInvTable(279) & LFInvTable(263) & 
	LFInvTable(247) & LFInvTable(231) & LFInvTable(215) & LFInvTable(199) & LFInvTable(183) & LFInvTable(167) & LFInvTable(151) & LFInvTable(135) & 
	LFInvTable(119) & LFInvTable(103) & LFInvTable(87) & LFInvTable(71) & LFInvTable(55) & LFInvTable(39) & LFInvTable(23) & LFInvTable(7) ; 

	----------------------------
	constant Table0 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4080) & Table(4064) & Table(4048) & Table(4032) & Table(4016) & Table(4000) & Table(3984) & Table(3968) & 
	Table(3952) & Table(3936) & Table(3920) & Table(3904) & Table(3888) & Table(3872) & Table(3856) & Table(3840) & 
	Table(3824) & Table(3808) & Table(3792) & Table(3776) & Table(3760) & Table(3744) & Table(3728) & Table(3712) & 
	Table(3696) & Table(3680) & Table(3664) & Table(3648) & Table(3632) & Table(3616) & Table(3600) & Table(3584) & 
	Table(3568) & Table(3552) & Table(3536) & Table(3520) & Table(3504) & Table(3488) & Table(3472) & Table(3456) & 
	Table(3440) & Table(3424) & Table(3408) & Table(3392) & Table(3376) & Table(3360) & Table(3344) & Table(3328) & 
	Table(3312) & Table(3296) & Table(3280) & Table(3264) & Table(3248) & Table(3232) & Table(3216) & Table(3200) & 
	Table(3184) & Table(3168) & Table(3152) & Table(3136) & Table(3120) & Table(3104) & Table(3088) & Table(3072) & 
	Table(3056) & Table(3040) & Table(3024) & Table(3008) & Table(2992) & Table(2976) & Table(2960) & Table(2944) & 
	Table(2928) & Table(2912) & Table(2896) & Table(2880) & Table(2864) & Table(2848) & Table(2832) & Table(2816) & 
	Table(2800) & Table(2784) & Table(2768) & Table(2752) & Table(2736) & Table(2720) & Table(2704) & Table(2688) & 
	Table(2672) & Table(2656) & Table(2640) & Table(2624) & Table(2608) & Table(2592) & Table(2576) & Table(2560) & 
	Table(2544) & Table(2528) & Table(2512) & Table(2496) & Table(2480) & Table(2464) & Table(2448) & Table(2432) & 
	Table(2416) & Table(2400) & Table(2384) & Table(2368) & Table(2352) & Table(2336) & Table(2320) & Table(2304) & 
	Table(2288) & Table(2272) & Table(2256) & Table(2240) & Table(2224) & Table(2208) & Table(2192) & Table(2176) & 
	Table(2160) & Table(2144) & Table(2128) & Table(2112) & Table(2096) & Table(2080) & Table(2064) & Table(2048) & 
	Table(2032) & Table(2016) & Table(2000) & Table(1984) & Table(1968) & Table(1952) & Table(1936) & Table(1920) & 
	Table(1904) & Table(1888) & Table(1872) & Table(1856) & Table(1840) & Table(1824) & Table(1808) & Table(1792) & 
	Table(1776) & Table(1760) & Table(1744) & Table(1728) & Table(1712) & Table(1696) & Table(1680) & Table(1664) & 
	Table(1648) & Table(1632) & Table(1616) & Table(1600) & Table(1584) & Table(1568) & Table(1552) & Table(1536) & 
	Table(1520) & Table(1504) & Table(1488) & Table(1472) & Table(1456) & Table(1440) & Table(1424) & Table(1408) & 
	Table(1392) & Table(1376) & Table(1360) & Table(1344) & Table(1328) & Table(1312) & Table(1296) & Table(1280) & 
	Table(1264) & Table(1248) & Table(1232) & Table(1216) & Table(1200) & Table(1184) & Table(1168) & Table(1152) & 
	Table(1136) & Table(1120) & Table(1104) & Table(1088) & Table(1072) & Table(1056) & Table(1040) & Table(1024) & 
	Table(1008) & Table(992) & Table(976) & Table(960) & Table(944) & Table(928) & Table(912) & Table(896) & 
	Table(880) & Table(864) & Table(848) & Table(832) & Table(816) & Table(800) & Table(784) & Table(768) & 
	Table(752) & Table(736) & Table(720) & Table(704) & Table(688) & Table(672) & Table(656) & Table(640) & 
	Table(624) & Table(608) & Table(592) & Table(576) & Table(560) & Table(544) & Table(528) & Table(512) & 
	Table(496) & Table(480) & Table(464) & Table(448) & Table(432) & Table(416) & Table(400) & Table(384) & 
	Table(368) & Table(352) & Table(336) & Table(320) & Table(304) & Table(288) & Table(272) & Table(256) & 
	Table(240) & Table(224) & Table(208) & Table(192) & Table(176) & Table(160) & Table(144) & Table(128) & 
	Table(112) & Table(96) & Table(80) & Table(64) & Table(48) & Table(32) & Table(16) & Table(0) ; 

	constant Table1 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4081) & Table(4065) & Table(4049) & Table(4033) & Table(4017) & Table(4001) & Table(3985) & Table(3969) & 
	Table(3953) & Table(3937) & Table(3921) & Table(3905) & Table(3889) & Table(3873) & Table(3857) & Table(3841) & 
	Table(3825) & Table(3809) & Table(3793) & Table(3777) & Table(3761) & Table(3745) & Table(3729) & Table(3713) & 
	Table(3697) & Table(3681) & Table(3665) & Table(3649) & Table(3633) & Table(3617) & Table(3601) & Table(3585) & 
	Table(3569) & Table(3553) & Table(3537) & Table(3521) & Table(3505) & Table(3489) & Table(3473) & Table(3457) & 
	Table(3441) & Table(3425) & Table(3409) & Table(3393) & Table(3377) & Table(3361) & Table(3345) & Table(3329) & 
	Table(3313) & Table(3297) & Table(3281) & Table(3265) & Table(3249) & Table(3233) & Table(3217) & Table(3201) & 
	Table(3185) & Table(3169) & Table(3153) & Table(3137) & Table(3121) & Table(3105) & Table(3089) & Table(3073) & 
	Table(3057) & Table(3041) & Table(3025) & Table(3009) & Table(2993) & Table(2977) & Table(2961) & Table(2945) & 
	Table(2929) & Table(2913) & Table(2897) & Table(2881) & Table(2865) & Table(2849) & Table(2833) & Table(2817) & 
	Table(2801) & Table(2785) & Table(2769) & Table(2753) & Table(2737) & Table(2721) & Table(2705) & Table(2689) & 
	Table(2673) & Table(2657) & Table(2641) & Table(2625) & Table(2609) & Table(2593) & Table(2577) & Table(2561) & 
	Table(2545) & Table(2529) & Table(2513) & Table(2497) & Table(2481) & Table(2465) & Table(2449) & Table(2433) & 
	Table(2417) & Table(2401) & Table(2385) & Table(2369) & Table(2353) & Table(2337) & Table(2321) & Table(2305) & 
	Table(2289) & Table(2273) & Table(2257) & Table(2241) & Table(2225) & Table(2209) & Table(2193) & Table(2177) & 
	Table(2161) & Table(2145) & Table(2129) & Table(2113) & Table(2097) & Table(2081) & Table(2065) & Table(2049) & 
	Table(2033) & Table(2017) & Table(2001) & Table(1985) & Table(1969) & Table(1953) & Table(1937) & Table(1921) & 
	Table(1905) & Table(1889) & Table(1873) & Table(1857) & Table(1841) & Table(1825) & Table(1809) & Table(1793) & 
	Table(1777) & Table(1761) & Table(1745) & Table(1729) & Table(1713) & Table(1697) & Table(1681) & Table(1665) & 
	Table(1649) & Table(1633) & Table(1617) & Table(1601) & Table(1585) & Table(1569) & Table(1553) & Table(1537) & 
	Table(1521) & Table(1505) & Table(1489) & Table(1473) & Table(1457) & Table(1441) & Table(1425) & Table(1409) & 
	Table(1393) & Table(1377) & Table(1361) & Table(1345) & Table(1329) & Table(1313) & Table(1297) & Table(1281) & 
	Table(1265) & Table(1249) & Table(1233) & Table(1217) & Table(1201) & Table(1185) & Table(1169) & Table(1153) & 
	Table(1137) & Table(1121) & Table(1105) & Table(1089) & Table(1073) & Table(1057) & Table(1041) & Table(1025) & 
	Table(1009) & Table(993) & Table(977) & Table(961) & Table(945) & Table(929) & Table(913) & Table(897) & 
	Table(881) & Table(865) & Table(849) & Table(833) & Table(817) & Table(801) & Table(785) & Table(769) & 
	Table(753) & Table(737) & Table(721) & Table(705) & Table(689) & Table(673) & Table(657) & Table(641) & 
	Table(625) & Table(609) & Table(593) & Table(577) & Table(561) & Table(545) & Table(529) & Table(513) & 
	Table(497) & Table(481) & Table(465) & Table(449) & Table(433) & Table(417) & Table(401) & Table(385) & 
	Table(369) & Table(353) & Table(337) & Table(321) & Table(305) & Table(289) & Table(273) & Table(257) & 
	Table(241) & Table(225) & Table(209) & Table(193) & Table(177) & Table(161) & Table(145) & Table(129) & 
	Table(113) & Table(97) & Table(81) & Table(65) & Table(49) & Table(33) & Table(17) & Table(1) ; 

	constant Table2 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4082) & Table(4066) & Table(4050) & Table(4034) & Table(4018) & Table(4002) & Table(3986) & Table(3970) & 
	Table(3954) & Table(3938) & Table(3922) & Table(3906) & Table(3890) & Table(3874) & Table(3858) & Table(3842) & 
	Table(3826) & Table(3810) & Table(3794) & Table(3778) & Table(3762) & Table(3746) & Table(3730) & Table(3714) & 
	Table(3698) & Table(3682) & Table(3666) & Table(3650) & Table(3634) & Table(3618) & Table(3602) & Table(3586) & 
	Table(3570) & Table(3554) & Table(3538) & Table(3522) & Table(3506) & Table(3490) & Table(3474) & Table(3458) & 
	Table(3442) & Table(3426) & Table(3410) & Table(3394) & Table(3378) & Table(3362) & Table(3346) & Table(3330) & 
	Table(3314) & Table(3298) & Table(3282) & Table(3266) & Table(3250) & Table(3234) & Table(3218) & Table(3202) & 
	Table(3186) & Table(3170) & Table(3154) & Table(3138) & Table(3122) & Table(3106) & Table(3090) & Table(3074) & 
	Table(3058) & Table(3042) & Table(3026) & Table(3010) & Table(2994) & Table(2978) & Table(2962) & Table(2946) & 
	Table(2930) & Table(2914) & Table(2898) & Table(2882) & Table(2866) & Table(2850) & Table(2834) & Table(2818) & 
	Table(2802) & Table(2786) & Table(2770) & Table(2754) & Table(2738) & Table(2722) & Table(2706) & Table(2690) & 
	Table(2674) & Table(2658) & Table(2642) & Table(2626) & Table(2610) & Table(2594) & Table(2578) & Table(2562) & 
	Table(2546) & Table(2530) & Table(2514) & Table(2498) & Table(2482) & Table(2466) & Table(2450) & Table(2434) & 
	Table(2418) & Table(2402) & Table(2386) & Table(2370) & Table(2354) & Table(2338) & Table(2322) & Table(2306) & 
	Table(2290) & Table(2274) & Table(2258) & Table(2242) & Table(2226) & Table(2210) & Table(2194) & Table(2178) & 
	Table(2162) & Table(2146) & Table(2130) & Table(2114) & Table(2098) & Table(2082) & Table(2066) & Table(2050) & 
	Table(2034) & Table(2018) & Table(2002) & Table(1986) & Table(1970) & Table(1954) & Table(1938) & Table(1922) & 
	Table(1906) & Table(1890) & Table(1874) & Table(1858) & Table(1842) & Table(1826) & Table(1810) & Table(1794) & 
	Table(1778) & Table(1762) & Table(1746) & Table(1730) & Table(1714) & Table(1698) & Table(1682) & Table(1666) & 
	Table(1650) & Table(1634) & Table(1618) & Table(1602) & Table(1586) & Table(1570) & Table(1554) & Table(1538) & 
	Table(1522) & Table(1506) & Table(1490) & Table(1474) & Table(1458) & Table(1442) & Table(1426) & Table(1410) & 
	Table(1394) & Table(1378) & Table(1362) & Table(1346) & Table(1330) & Table(1314) & Table(1298) & Table(1282) & 
	Table(1266) & Table(1250) & Table(1234) & Table(1218) & Table(1202) & Table(1186) & Table(1170) & Table(1154) & 
	Table(1138) & Table(1122) & Table(1106) & Table(1090) & Table(1074) & Table(1058) & Table(1042) & Table(1026) & 
	Table(1010) & Table(994) & Table(978) & Table(962) & Table(946) & Table(930) & Table(914) & Table(898) & 
	Table(882) & Table(866) & Table(850) & Table(834) & Table(818) & Table(802) & Table(786) & Table(770) & 
	Table(754) & Table(738) & Table(722) & Table(706) & Table(690) & Table(674) & Table(658) & Table(642) & 
	Table(626) & Table(610) & Table(594) & Table(578) & Table(562) & Table(546) & Table(530) & Table(514) & 
	Table(498) & Table(482) & Table(466) & Table(450) & Table(434) & Table(418) & Table(402) & Table(386) & 
	Table(370) & Table(354) & Table(338) & Table(322) & Table(306) & Table(290) & Table(274) & Table(258) & 
	Table(242) & Table(226) & Table(210) & Table(194) & Table(178) & Table(162) & Table(146) & Table(130) & 
	Table(114) & Table(98) & Table(82) & Table(66) & Table(50) & Table(34) & Table(18) & Table(2) ; 

	constant Table3 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4083) & Table(4067) & Table(4051) & Table(4035) & Table(4019) & Table(4003) & Table(3987) & Table(3971) & 
	Table(3955) & Table(3939) & Table(3923) & Table(3907) & Table(3891) & Table(3875) & Table(3859) & Table(3843) & 
	Table(3827) & Table(3811) & Table(3795) & Table(3779) & Table(3763) & Table(3747) & Table(3731) & Table(3715) & 
	Table(3699) & Table(3683) & Table(3667) & Table(3651) & Table(3635) & Table(3619) & Table(3603) & Table(3587) & 
	Table(3571) & Table(3555) & Table(3539) & Table(3523) & Table(3507) & Table(3491) & Table(3475) & Table(3459) & 
	Table(3443) & Table(3427) & Table(3411) & Table(3395) & Table(3379) & Table(3363) & Table(3347) & Table(3331) & 
	Table(3315) & Table(3299) & Table(3283) & Table(3267) & Table(3251) & Table(3235) & Table(3219) & Table(3203) & 
	Table(3187) & Table(3171) & Table(3155) & Table(3139) & Table(3123) & Table(3107) & Table(3091) & Table(3075) & 
	Table(3059) & Table(3043) & Table(3027) & Table(3011) & Table(2995) & Table(2979) & Table(2963) & Table(2947) & 
	Table(2931) & Table(2915) & Table(2899) & Table(2883) & Table(2867) & Table(2851) & Table(2835) & Table(2819) & 
	Table(2803) & Table(2787) & Table(2771) & Table(2755) & Table(2739) & Table(2723) & Table(2707) & Table(2691) & 
	Table(2675) & Table(2659) & Table(2643) & Table(2627) & Table(2611) & Table(2595) & Table(2579) & Table(2563) & 
	Table(2547) & Table(2531) & Table(2515) & Table(2499) & Table(2483) & Table(2467) & Table(2451) & Table(2435) & 
	Table(2419) & Table(2403) & Table(2387) & Table(2371) & Table(2355) & Table(2339) & Table(2323) & Table(2307) & 
	Table(2291) & Table(2275) & Table(2259) & Table(2243) & Table(2227) & Table(2211) & Table(2195) & Table(2179) & 
	Table(2163) & Table(2147) & Table(2131) & Table(2115) & Table(2099) & Table(2083) & Table(2067) & Table(2051) & 
	Table(2035) & Table(2019) & Table(2003) & Table(1987) & Table(1971) & Table(1955) & Table(1939) & Table(1923) & 
	Table(1907) & Table(1891) & Table(1875) & Table(1859) & Table(1843) & Table(1827) & Table(1811) & Table(1795) & 
	Table(1779) & Table(1763) & Table(1747) & Table(1731) & Table(1715) & Table(1699) & Table(1683) & Table(1667) & 
	Table(1651) & Table(1635) & Table(1619) & Table(1603) & Table(1587) & Table(1571) & Table(1555) & Table(1539) & 
	Table(1523) & Table(1507) & Table(1491) & Table(1475) & Table(1459) & Table(1443) & Table(1427) & Table(1411) & 
	Table(1395) & Table(1379) & Table(1363) & Table(1347) & Table(1331) & Table(1315) & Table(1299) & Table(1283) & 
	Table(1267) & Table(1251) & Table(1235) & Table(1219) & Table(1203) & Table(1187) & Table(1171) & Table(1155) & 
	Table(1139) & Table(1123) & Table(1107) & Table(1091) & Table(1075) & Table(1059) & Table(1043) & Table(1027) & 
	Table(1011) & Table(995) & Table(979) & Table(963) & Table(947) & Table(931) & Table(915) & Table(899) & 
	Table(883) & Table(867) & Table(851) & Table(835) & Table(819) & Table(803) & Table(787) & Table(771) & 
	Table(755) & Table(739) & Table(723) & Table(707) & Table(691) & Table(675) & Table(659) & Table(643) & 
	Table(627) & Table(611) & Table(595) & Table(579) & Table(563) & Table(547) & Table(531) & Table(515) & 
	Table(499) & Table(483) & Table(467) & Table(451) & Table(435) & Table(419) & Table(403) & Table(387) & 
	Table(371) & Table(355) & Table(339) & Table(323) & Table(307) & Table(291) & Table(275) & Table(259) & 
	Table(243) & Table(227) & Table(211) & Table(195) & Table(179) & Table(163) & Table(147) & Table(131) & 
	Table(115) & Table(99) & Table(83) & Table(67) & Table(51) & Table(35) & Table(19) & Table(3) ; 

	constant Table4 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4084) & Table(4068) & Table(4052) & Table(4036) & Table(4020) & Table(4004) & Table(3988) & Table(3972) & 
	Table(3956) & Table(3940) & Table(3924) & Table(3908) & Table(3892) & Table(3876) & Table(3860) & Table(3844) & 
	Table(3828) & Table(3812) & Table(3796) & Table(3780) & Table(3764) & Table(3748) & Table(3732) & Table(3716) & 
	Table(3700) & Table(3684) & Table(3668) & Table(3652) & Table(3636) & Table(3620) & Table(3604) & Table(3588) & 
	Table(3572) & Table(3556) & Table(3540) & Table(3524) & Table(3508) & Table(3492) & Table(3476) & Table(3460) & 
	Table(3444) & Table(3428) & Table(3412) & Table(3396) & Table(3380) & Table(3364) & Table(3348) & Table(3332) & 
	Table(3316) & Table(3300) & Table(3284) & Table(3268) & Table(3252) & Table(3236) & Table(3220) & Table(3204) & 
	Table(3188) & Table(3172) & Table(3156) & Table(3140) & Table(3124) & Table(3108) & Table(3092) & Table(3076) & 
	Table(3060) & Table(3044) & Table(3028) & Table(3012) & Table(2996) & Table(2980) & Table(2964) & Table(2948) & 
	Table(2932) & Table(2916) & Table(2900) & Table(2884) & Table(2868) & Table(2852) & Table(2836) & Table(2820) & 
	Table(2804) & Table(2788) & Table(2772) & Table(2756) & Table(2740) & Table(2724) & Table(2708) & Table(2692) & 
	Table(2676) & Table(2660) & Table(2644) & Table(2628) & Table(2612) & Table(2596) & Table(2580) & Table(2564) & 
	Table(2548) & Table(2532) & Table(2516) & Table(2500) & Table(2484) & Table(2468) & Table(2452) & Table(2436) & 
	Table(2420) & Table(2404) & Table(2388) & Table(2372) & Table(2356) & Table(2340) & Table(2324) & Table(2308) & 
	Table(2292) & Table(2276) & Table(2260) & Table(2244) & Table(2228) & Table(2212) & Table(2196) & Table(2180) & 
	Table(2164) & Table(2148) & Table(2132) & Table(2116) & Table(2100) & Table(2084) & Table(2068) & Table(2052) & 
	Table(2036) & Table(2020) & Table(2004) & Table(1988) & Table(1972) & Table(1956) & Table(1940) & Table(1924) & 
	Table(1908) & Table(1892) & Table(1876) & Table(1860) & Table(1844) & Table(1828) & Table(1812) & Table(1796) & 
	Table(1780) & Table(1764) & Table(1748) & Table(1732) & Table(1716) & Table(1700) & Table(1684) & Table(1668) & 
	Table(1652) & Table(1636) & Table(1620) & Table(1604) & Table(1588) & Table(1572) & Table(1556) & Table(1540) & 
	Table(1524) & Table(1508) & Table(1492) & Table(1476) & Table(1460) & Table(1444) & Table(1428) & Table(1412) & 
	Table(1396) & Table(1380) & Table(1364) & Table(1348) & Table(1332) & Table(1316) & Table(1300) & Table(1284) & 
	Table(1268) & Table(1252) & Table(1236) & Table(1220) & Table(1204) & Table(1188) & Table(1172) & Table(1156) & 
	Table(1140) & Table(1124) & Table(1108) & Table(1092) & Table(1076) & Table(1060) & Table(1044) & Table(1028) & 
	Table(1012) & Table(996) & Table(980) & Table(964) & Table(948) & Table(932) & Table(916) & Table(900) & 
	Table(884) & Table(868) & Table(852) & Table(836) & Table(820) & Table(804) & Table(788) & Table(772) & 
	Table(756) & Table(740) & Table(724) & Table(708) & Table(692) & Table(676) & Table(660) & Table(644) & 
	Table(628) & Table(612) & Table(596) & Table(580) & Table(564) & Table(548) & Table(532) & Table(516) & 
	Table(500) & Table(484) & Table(468) & Table(452) & Table(436) & Table(420) & Table(404) & Table(388) & 
	Table(372) & Table(356) & Table(340) & Table(324) & Table(308) & Table(292) & Table(276) & Table(260) & 
	Table(244) & Table(228) & Table(212) & Table(196) & Table(180) & Table(164) & Table(148) & Table(132) & 
	Table(116) & Table(100) & Table(84) & Table(68) & Table(52) & Table(36) & Table(20) & Table(4) ; 

	constant Table5 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4085) & Table(4069) & Table(4053) & Table(4037) & Table(4021) & Table(4005) & Table(3989) & Table(3973) & 
	Table(3957) & Table(3941) & Table(3925) & Table(3909) & Table(3893) & Table(3877) & Table(3861) & Table(3845) & 
	Table(3829) & Table(3813) & Table(3797) & Table(3781) & Table(3765) & Table(3749) & Table(3733) & Table(3717) & 
	Table(3701) & Table(3685) & Table(3669) & Table(3653) & Table(3637) & Table(3621) & Table(3605) & Table(3589) & 
	Table(3573) & Table(3557) & Table(3541) & Table(3525) & Table(3509) & Table(3493) & Table(3477) & Table(3461) & 
	Table(3445) & Table(3429) & Table(3413) & Table(3397) & Table(3381) & Table(3365) & Table(3349) & Table(3333) & 
	Table(3317) & Table(3301) & Table(3285) & Table(3269) & Table(3253) & Table(3237) & Table(3221) & Table(3205) & 
	Table(3189) & Table(3173) & Table(3157) & Table(3141) & Table(3125) & Table(3109) & Table(3093) & Table(3077) & 
	Table(3061) & Table(3045) & Table(3029) & Table(3013) & Table(2997) & Table(2981) & Table(2965) & Table(2949) & 
	Table(2933) & Table(2917) & Table(2901) & Table(2885) & Table(2869) & Table(2853) & Table(2837) & Table(2821) & 
	Table(2805) & Table(2789) & Table(2773) & Table(2757) & Table(2741) & Table(2725) & Table(2709) & Table(2693) & 
	Table(2677) & Table(2661) & Table(2645) & Table(2629) & Table(2613) & Table(2597) & Table(2581) & Table(2565) & 
	Table(2549) & Table(2533) & Table(2517) & Table(2501) & Table(2485) & Table(2469) & Table(2453) & Table(2437) & 
	Table(2421) & Table(2405) & Table(2389) & Table(2373) & Table(2357) & Table(2341) & Table(2325) & Table(2309) & 
	Table(2293) & Table(2277) & Table(2261) & Table(2245) & Table(2229) & Table(2213) & Table(2197) & Table(2181) & 
	Table(2165) & Table(2149) & Table(2133) & Table(2117) & Table(2101) & Table(2085) & Table(2069) & Table(2053) & 
	Table(2037) & Table(2021) & Table(2005) & Table(1989) & Table(1973) & Table(1957) & Table(1941) & Table(1925) & 
	Table(1909) & Table(1893) & Table(1877) & Table(1861) & Table(1845) & Table(1829) & Table(1813) & Table(1797) & 
	Table(1781) & Table(1765) & Table(1749) & Table(1733) & Table(1717) & Table(1701) & Table(1685) & Table(1669) & 
	Table(1653) & Table(1637) & Table(1621) & Table(1605) & Table(1589) & Table(1573) & Table(1557) & Table(1541) & 
	Table(1525) & Table(1509) & Table(1493) & Table(1477) & Table(1461) & Table(1445) & Table(1429) & Table(1413) & 
	Table(1397) & Table(1381) & Table(1365) & Table(1349) & Table(1333) & Table(1317) & Table(1301) & Table(1285) & 
	Table(1269) & Table(1253) & Table(1237) & Table(1221) & Table(1205) & Table(1189) & Table(1173) & Table(1157) & 
	Table(1141) & Table(1125) & Table(1109) & Table(1093) & Table(1077) & Table(1061) & Table(1045) & Table(1029) & 
	Table(1013) & Table(997) & Table(981) & Table(965) & Table(949) & Table(933) & Table(917) & Table(901) & 
	Table(885) & Table(869) & Table(853) & Table(837) & Table(821) & Table(805) & Table(789) & Table(773) & 
	Table(757) & Table(741) & Table(725) & Table(709) & Table(693) & Table(677) & Table(661) & Table(645) & 
	Table(629) & Table(613) & Table(597) & Table(581) & Table(565) & Table(549) & Table(533) & Table(517) & 
	Table(501) & Table(485) & Table(469) & Table(453) & Table(437) & Table(421) & Table(405) & Table(389) & 
	Table(373) & Table(357) & Table(341) & Table(325) & Table(309) & Table(293) & Table(277) & Table(261) & 
	Table(245) & Table(229) & Table(213) & Table(197) & Table(181) & Table(165) & Table(149) & Table(133) & 
	Table(117) & Table(101) & Table(85) & Table(69) & Table(53) & Table(37) & Table(21) & Table(5) ; 

	constant Table6 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4086) & Table(4070) & Table(4054) & Table(4038) & Table(4022) & Table(4006) & Table(3990) & Table(3974) & 
	Table(3958) & Table(3942) & Table(3926) & Table(3910) & Table(3894) & Table(3878) & Table(3862) & Table(3846) & 
	Table(3830) & Table(3814) & Table(3798) & Table(3782) & Table(3766) & Table(3750) & Table(3734) & Table(3718) & 
	Table(3702) & Table(3686) & Table(3670) & Table(3654) & Table(3638) & Table(3622) & Table(3606) & Table(3590) & 
	Table(3574) & Table(3558) & Table(3542) & Table(3526) & Table(3510) & Table(3494) & Table(3478) & Table(3462) & 
	Table(3446) & Table(3430) & Table(3414) & Table(3398) & Table(3382) & Table(3366) & Table(3350) & Table(3334) & 
	Table(3318) & Table(3302) & Table(3286) & Table(3270) & Table(3254) & Table(3238) & Table(3222) & Table(3206) & 
	Table(3190) & Table(3174) & Table(3158) & Table(3142) & Table(3126) & Table(3110) & Table(3094) & Table(3078) & 
	Table(3062) & Table(3046) & Table(3030) & Table(3014) & Table(2998) & Table(2982) & Table(2966) & Table(2950) & 
	Table(2934) & Table(2918) & Table(2902) & Table(2886) & Table(2870) & Table(2854) & Table(2838) & Table(2822) & 
	Table(2806) & Table(2790) & Table(2774) & Table(2758) & Table(2742) & Table(2726) & Table(2710) & Table(2694) & 
	Table(2678) & Table(2662) & Table(2646) & Table(2630) & Table(2614) & Table(2598) & Table(2582) & Table(2566) & 
	Table(2550) & Table(2534) & Table(2518) & Table(2502) & Table(2486) & Table(2470) & Table(2454) & Table(2438) & 
	Table(2422) & Table(2406) & Table(2390) & Table(2374) & Table(2358) & Table(2342) & Table(2326) & Table(2310) & 
	Table(2294) & Table(2278) & Table(2262) & Table(2246) & Table(2230) & Table(2214) & Table(2198) & Table(2182) & 
	Table(2166) & Table(2150) & Table(2134) & Table(2118) & Table(2102) & Table(2086) & Table(2070) & Table(2054) & 
	Table(2038) & Table(2022) & Table(2006) & Table(1990) & Table(1974) & Table(1958) & Table(1942) & Table(1926) & 
	Table(1910) & Table(1894) & Table(1878) & Table(1862) & Table(1846) & Table(1830) & Table(1814) & Table(1798) & 
	Table(1782) & Table(1766) & Table(1750) & Table(1734) & Table(1718) & Table(1702) & Table(1686) & Table(1670) & 
	Table(1654) & Table(1638) & Table(1622) & Table(1606) & Table(1590) & Table(1574) & Table(1558) & Table(1542) & 
	Table(1526) & Table(1510) & Table(1494) & Table(1478) & Table(1462) & Table(1446) & Table(1430) & Table(1414) & 
	Table(1398) & Table(1382) & Table(1366) & Table(1350) & Table(1334) & Table(1318) & Table(1302) & Table(1286) & 
	Table(1270) & Table(1254) & Table(1238) & Table(1222) & Table(1206) & Table(1190) & Table(1174) & Table(1158) & 
	Table(1142) & Table(1126) & Table(1110) & Table(1094) & Table(1078) & Table(1062) & Table(1046) & Table(1030) & 
	Table(1014) & Table(998) & Table(982) & Table(966) & Table(950) & Table(934) & Table(918) & Table(902) & 
	Table(886) & Table(870) & Table(854) & Table(838) & Table(822) & Table(806) & Table(790) & Table(774) & 
	Table(758) & Table(742) & Table(726) & Table(710) & Table(694) & Table(678) & Table(662) & Table(646) & 
	Table(630) & Table(614) & Table(598) & Table(582) & Table(566) & Table(550) & Table(534) & Table(518) & 
	Table(502) & Table(486) & Table(470) & Table(454) & Table(438) & Table(422) & Table(406) & Table(390) & 
	Table(374) & Table(358) & Table(342) & Table(326) & Table(310) & Table(294) & Table(278) & Table(262) & 
	Table(246) & Table(230) & Table(214) & Table(198) & Table(182) & Table(166) & Table(150) & Table(134) & 
	Table(118) & Table(102) & Table(86) & Table(70) & Table(54) & Table(38) & Table(22) & Table(6) ; 

	constant Table7 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4087) & Table(4071) & Table(4055) & Table(4039) & Table(4023) & Table(4007) & Table(3991) & Table(3975) & 
	Table(3959) & Table(3943) & Table(3927) & Table(3911) & Table(3895) & Table(3879) & Table(3863) & Table(3847) & 
	Table(3831) & Table(3815) & Table(3799) & Table(3783) & Table(3767) & Table(3751) & Table(3735) & Table(3719) & 
	Table(3703) & Table(3687) & Table(3671) & Table(3655) & Table(3639) & Table(3623) & Table(3607) & Table(3591) & 
	Table(3575) & Table(3559) & Table(3543) & Table(3527) & Table(3511) & Table(3495) & Table(3479) & Table(3463) & 
	Table(3447) & Table(3431) & Table(3415) & Table(3399) & Table(3383) & Table(3367) & Table(3351) & Table(3335) & 
	Table(3319) & Table(3303) & Table(3287) & Table(3271) & Table(3255) & Table(3239) & Table(3223) & Table(3207) & 
	Table(3191) & Table(3175) & Table(3159) & Table(3143) & Table(3127) & Table(3111) & Table(3095) & Table(3079) & 
	Table(3063) & Table(3047) & Table(3031) & Table(3015) & Table(2999) & Table(2983) & Table(2967) & Table(2951) & 
	Table(2935) & Table(2919) & Table(2903) & Table(2887) & Table(2871) & Table(2855) & Table(2839) & Table(2823) & 
	Table(2807) & Table(2791) & Table(2775) & Table(2759) & Table(2743) & Table(2727) & Table(2711) & Table(2695) & 
	Table(2679) & Table(2663) & Table(2647) & Table(2631) & Table(2615) & Table(2599) & Table(2583) & Table(2567) & 
	Table(2551) & Table(2535) & Table(2519) & Table(2503) & Table(2487) & Table(2471) & Table(2455) & Table(2439) & 
	Table(2423) & Table(2407) & Table(2391) & Table(2375) & Table(2359) & Table(2343) & Table(2327) & Table(2311) & 
	Table(2295) & Table(2279) & Table(2263) & Table(2247) & Table(2231) & Table(2215) & Table(2199) & Table(2183) & 
	Table(2167) & Table(2151) & Table(2135) & Table(2119) & Table(2103) & Table(2087) & Table(2071) & Table(2055) & 
	Table(2039) & Table(2023) & Table(2007) & Table(1991) & Table(1975) & Table(1959) & Table(1943) & Table(1927) & 
	Table(1911) & Table(1895) & Table(1879) & Table(1863) & Table(1847) & Table(1831) & Table(1815) & Table(1799) & 
	Table(1783) & Table(1767) & Table(1751) & Table(1735) & Table(1719) & Table(1703) & Table(1687) & Table(1671) & 
	Table(1655) & Table(1639) & Table(1623) & Table(1607) & Table(1591) & Table(1575) & Table(1559) & Table(1543) & 
	Table(1527) & Table(1511) & Table(1495) & Table(1479) & Table(1463) & Table(1447) & Table(1431) & Table(1415) & 
	Table(1399) & Table(1383) & Table(1367) & Table(1351) & Table(1335) & Table(1319) & Table(1303) & Table(1287) & 
	Table(1271) & Table(1255) & Table(1239) & Table(1223) & Table(1207) & Table(1191) & Table(1175) & Table(1159) & 
	Table(1143) & Table(1127) & Table(1111) & Table(1095) & Table(1079) & Table(1063) & Table(1047) & Table(1031) & 
	Table(1015) & Table(999) & Table(983) & Table(967) & Table(951) & Table(935) & Table(919) & Table(903) & 
	Table(887) & Table(871) & Table(855) & Table(839) & Table(823) & Table(807) & Table(791) & Table(775) & 
	Table(759) & Table(743) & Table(727) & Table(711) & Table(695) & Table(679) & Table(663) & Table(647) & 
	Table(631) & Table(615) & Table(599) & Table(583) & Table(567) & Table(551) & Table(535) & Table(519) & 
	Table(503) & Table(487) & Table(471) & Table(455) & Table(439) & Table(423) & Table(407) & Table(391) & 
	Table(375) & Table(359) & Table(343) & Table(327) & Table(311) & Table(295) & Table(279) & Table(263) & 
	Table(247) & Table(231) & Table(215) & Table(199) & Table(183) & Table(167) & Table(151) & Table(135) & 
	Table(119) & Table(103) & Table(87) & Table(71) & Table(55) & Table(39) & Table(23) & Table(7) ; 

	constant Table8 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4088) & Table(4072) & Table(4056) & Table(4040) & Table(4024) & Table(4008) & Table(3992) & Table(3976) & 
	Table(3960) & Table(3944) & Table(3928) & Table(3912) & Table(3896) & Table(3880) & Table(3864) & Table(3848) & 
	Table(3832) & Table(3816) & Table(3800) & Table(3784) & Table(3768) & Table(3752) & Table(3736) & Table(3720) & 
	Table(3704) & Table(3688) & Table(3672) & Table(3656) & Table(3640) & Table(3624) & Table(3608) & Table(3592) & 
	Table(3576) & Table(3560) & Table(3544) & Table(3528) & Table(3512) & Table(3496) & Table(3480) & Table(3464) & 
	Table(3448) & Table(3432) & Table(3416) & Table(3400) & Table(3384) & Table(3368) & Table(3352) & Table(3336) & 
	Table(3320) & Table(3304) & Table(3288) & Table(3272) & Table(3256) & Table(3240) & Table(3224) & Table(3208) & 
	Table(3192) & Table(3176) & Table(3160) & Table(3144) & Table(3128) & Table(3112) & Table(3096) & Table(3080) & 
	Table(3064) & Table(3048) & Table(3032) & Table(3016) & Table(3000) & Table(2984) & Table(2968) & Table(2952) & 
	Table(2936) & Table(2920) & Table(2904) & Table(2888) & Table(2872) & Table(2856) & Table(2840) & Table(2824) & 
	Table(2808) & Table(2792) & Table(2776) & Table(2760) & Table(2744) & Table(2728) & Table(2712) & Table(2696) & 
	Table(2680) & Table(2664) & Table(2648) & Table(2632) & Table(2616) & Table(2600) & Table(2584) & Table(2568) & 
	Table(2552) & Table(2536) & Table(2520) & Table(2504) & Table(2488) & Table(2472) & Table(2456) & Table(2440) & 
	Table(2424) & Table(2408) & Table(2392) & Table(2376) & Table(2360) & Table(2344) & Table(2328) & Table(2312) & 
	Table(2296) & Table(2280) & Table(2264) & Table(2248) & Table(2232) & Table(2216) & Table(2200) & Table(2184) & 
	Table(2168) & Table(2152) & Table(2136) & Table(2120) & Table(2104) & Table(2088) & Table(2072) & Table(2056) & 
	Table(2040) & Table(2024) & Table(2008) & Table(1992) & Table(1976) & Table(1960) & Table(1944) & Table(1928) & 
	Table(1912) & Table(1896) & Table(1880) & Table(1864) & Table(1848) & Table(1832) & Table(1816) & Table(1800) & 
	Table(1784) & Table(1768) & Table(1752) & Table(1736) & Table(1720) & Table(1704) & Table(1688) & Table(1672) & 
	Table(1656) & Table(1640) & Table(1624) & Table(1608) & Table(1592) & Table(1576) & Table(1560) & Table(1544) & 
	Table(1528) & Table(1512) & Table(1496) & Table(1480) & Table(1464) & Table(1448) & Table(1432) & Table(1416) & 
	Table(1400) & Table(1384) & Table(1368) & Table(1352) & Table(1336) & Table(1320) & Table(1304) & Table(1288) & 
	Table(1272) & Table(1256) & Table(1240) & Table(1224) & Table(1208) & Table(1192) & Table(1176) & Table(1160) & 
	Table(1144) & Table(1128) & Table(1112) & Table(1096) & Table(1080) & Table(1064) & Table(1048) & Table(1032) & 
	Table(1016) & Table(1000) & Table(984) & Table(968) & Table(952) & Table(936) & Table(920) & Table(904) & 
	Table(888) & Table(872) & Table(856) & Table(840) & Table(824) & Table(808) & Table(792) & Table(776) & 
	Table(760) & Table(744) & Table(728) & Table(712) & Table(696) & Table(680) & Table(664) & Table(648) & 
	Table(632) & Table(616) & Table(600) & Table(584) & Table(568) & Table(552) & Table(536) & Table(520) & 
	Table(504) & Table(488) & Table(472) & Table(456) & Table(440) & Table(424) & Table(408) & Table(392) & 
	Table(376) & Table(360) & Table(344) & Table(328) & Table(312) & Table(296) & Table(280) & Table(264) & 
	Table(248) & Table(232) & Table(216) & Table(200) & Table(184) & Table(168) & Table(152) & Table(136) & 
	Table(120) & Table(104) & Table(88) & Table(72) & Table(56) & Table(40) & Table(24) & Table(8) ; 

	constant Table9 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4089) & Table(4073) & Table(4057) & Table(4041) & Table(4025) & Table(4009) & Table(3993) & Table(3977) & 
	Table(3961) & Table(3945) & Table(3929) & Table(3913) & Table(3897) & Table(3881) & Table(3865) & Table(3849) & 
	Table(3833) & Table(3817) & Table(3801) & Table(3785) & Table(3769) & Table(3753) & Table(3737) & Table(3721) & 
	Table(3705) & Table(3689) & Table(3673) & Table(3657) & Table(3641) & Table(3625) & Table(3609) & Table(3593) & 
	Table(3577) & Table(3561) & Table(3545) & Table(3529) & Table(3513) & Table(3497) & Table(3481) & Table(3465) & 
	Table(3449) & Table(3433) & Table(3417) & Table(3401) & Table(3385) & Table(3369) & Table(3353) & Table(3337) & 
	Table(3321) & Table(3305) & Table(3289) & Table(3273) & Table(3257) & Table(3241) & Table(3225) & Table(3209) & 
	Table(3193) & Table(3177) & Table(3161) & Table(3145) & Table(3129) & Table(3113) & Table(3097) & Table(3081) & 
	Table(3065) & Table(3049) & Table(3033) & Table(3017) & Table(3001) & Table(2985) & Table(2969) & Table(2953) & 
	Table(2937) & Table(2921) & Table(2905) & Table(2889) & Table(2873) & Table(2857) & Table(2841) & Table(2825) & 
	Table(2809) & Table(2793) & Table(2777) & Table(2761) & Table(2745) & Table(2729) & Table(2713) & Table(2697) & 
	Table(2681) & Table(2665) & Table(2649) & Table(2633) & Table(2617) & Table(2601) & Table(2585) & Table(2569) & 
	Table(2553) & Table(2537) & Table(2521) & Table(2505) & Table(2489) & Table(2473) & Table(2457) & Table(2441) & 
	Table(2425) & Table(2409) & Table(2393) & Table(2377) & Table(2361) & Table(2345) & Table(2329) & Table(2313) & 
	Table(2297) & Table(2281) & Table(2265) & Table(2249) & Table(2233) & Table(2217) & Table(2201) & Table(2185) & 
	Table(2169) & Table(2153) & Table(2137) & Table(2121) & Table(2105) & Table(2089) & Table(2073) & Table(2057) & 
	Table(2041) & Table(2025) & Table(2009) & Table(1993) & Table(1977) & Table(1961) & Table(1945) & Table(1929) & 
	Table(1913) & Table(1897) & Table(1881) & Table(1865) & Table(1849) & Table(1833) & Table(1817) & Table(1801) & 
	Table(1785) & Table(1769) & Table(1753) & Table(1737) & Table(1721) & Table(1705) & Table(1689) & Table(1673) & 
	Table(1657) & Table(1641) & Table(1625) & Table(1609) & Table(1593) & Table(1577) & Table(1561) & Table(1545) & 
	Table(1529) & Table(1513) & Table(1497) & Table(1481) & Table(1465) & Table(1449) & Table(1433) & Table(1417) & 
	Table(1401) & Table(1385) & Table(1369) & Table(1353) & Table(1337) & Table(1321) & Table(1305) & Table(1289) & 
	Table(1273) & Table(1257) & Table(1241) & Table(1225) & Table(1209) & Table(1193) & Table(1177) & Table(1161) & 
	Table(1145) & Table(1129) & Table(1113) & Table(1097) & Table(1081) & Table(1065) & Table(1049) & Table(1033) & 
	Table(1017) & Table(1001) & Table(985) & Table(969) & Table(953) & Table(937) & Table(921) & Table(905) & 
	Table(889) & Table(873) & Table(857) & Table(841) & Table(825) & Table(809) & Table(793) & Table(777) & 
	Table(761) & Table(745) & Table(729) & Table(713) & Table(697) & Table(681) & Table(665) & Table(649) & 
	Table(633) & Table(617) & Table(601) & Table(585) & Table(569) & Table(553) & Table(537) & Table(521) & 
	Table(505) & Table(489) & Table(473) & Table(457) & Table(441) & Table(425) & Table(409) & Table(393) & 
	Table(377) & Table(361) & Table(345) & Table(329) & Table(313) & Table(297) & Table(281) & Table(265) & 
	Table(249) & Table(233) & Table(217) & Table(201) & Table(185) & Table(169) & Table(153) & Table(137) & 
	Table(121) & Table(105) & Table(89) & Table(73) & Table(57) & Table(41) & Table(25) & Table(9) ; 

	constant Table10 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4090) & Table(4074) & Table(4058) & Table(4042) & Table(4026) & Table(4010) & Table(3994) & Table(3978) & 
	Table(3962) & Table(3946) & Table(3930) & Table(3914) & Table(3898) & Table(3882) & Table(3866) & Table(3850) & 
	Table(3834) & Table(3818) & Table(3802) & Table(3786) & Table(3770) & Table(3754) & Table(3738) & Table(3722) & 
	Table(3706) & Table(3690) & Table(3674) & Table(3658) & Table(3642) & Table(3626) & Table(3610) & Table(3594) & 
	Table(3578) & Table(3562) & Table(3546) & Table(3530) & Table(3514) & Table(3498) & Table(3482) & Table(3466) & 
	Table(3450) & Table(3434) & Table(3418) & Table(3402) & Table(3386) & Table(3370) & Table(3354) & Table(3338) & 
	Table(3322) & Table(3306) & Table(3290) & Table(3274) & Table(3258) & Table(3242) & Table(3226) & Table(3210) & 
	Table(3194) & Table(3178) & Table(3162) & Table(3146) & Table(3130) & Table(3114) & Table(3098) & Table(3082) & 
	Table(3066) & Table(3050) & Table(3034) & Table(3018) & Table(3002) & Table(2986) & Table(2970) & Table(2954) & 
	Table(2938) & Table(2922) & Table(2906) & Table(2890) & Table(2874) & Table(2858) & Table(2842) & Table(2826) & 
	Table(2810) & Table(2794) & Table(2778) & Table(2762) & Table(2746) & Table(2730) & Table(2714) & Table(2698) & 
	Table(2682) & Table(2666) & Table(2650) & Table(2634) & Table(2618) & Table(2602) & Table(2586) & Table(2570) & 
	Table(2554) & Table(2538) & Table(2522) & Table(2506) & Table(2490) & Table(2474) & Table(2458) & Table(2442) & 
	Table(2426) & Table(2410) & Table(2394) & Table(2378) & Table(2362) & Table(2346) & Table(2330) & Table(2314) & 
	Table(2298) & Table(2282) & Table(2266) & Table(2250) & Table(2234) & Table(2218) & Table(2202) & Table(2186) & 
	Table(2170) & Table(2154) & Table(2138) & Table(2122) & Table(2106) & Table(2090) & Table(2074) & Table(2058) & 
	Table(2042) & Table(2026) & Table(2010) & Table(1994) & Table(1978) & Table(1962) & Table(1946) & Table(1930) & 
	Table(1914) & Table(1898) & Table(1882) & Table(1866) & Table(1850) & Table(1834) & Table(1818) & Table(1802) & 
	Table(1786) & Table(1770) & Table(1754) & Table(1738) & Table(1722) & Table(1706) & Table(1690) & Table(1674) & 
	Table(1658) & Table(1642) & Table(1626) & Table(1610) & Table(1594) & Table(1578) & Table(1562) & Table(1546) & 
	Table(1530) & Table(1514) & Table(1498) & Table(1482) & Table(1466) & Table(1450) & Table(1434) & Table(1418) & 
	Table(1402) & Table(1386) & Table(1370) & Table(1354) & Table(1338) & Table(1322) & Table(1306) & Table(1290) & 
	Table(1274) & Table(1258) & Table(1242) & Table(1226) & Table(1210) & Table(1194) & Table(1178) & Table(1162) & 
	Table(1146) & Table(1130) & Table(1114) & Table(1098) & Table(1082) & Table(1066) & Table(1050) & Table(1034) & 
	Table(1018) & Table(1002) & Table(986) & Table(970) & Table(954) & Table(938) & Table(922) & Table(906) & 
	Table(890) & Table(874) & Table(858) & Table(842) & Table(826) & Table(810) & Table(794) & Table(778) & 
	Table(762) & Table(746) & Table(730) & Table(714) & Table(698) & Table(682) & Table(666) & Table(650) & 
	Table(634) & Table(618) & Table(602) & Table(586) & Table(570) & Table(554) & Table(538) & Table(522) & 
	Table(506) & Table(490) & Table(474) & Table(458) & Table(442) & Table(426) & Table(410) & Table(394) & 
	Table(378) & Table(362) & Table(346) & Table(330) & Table(314) & Table(298) & Table(282) & Table(266) & 
	Table(250) & Table(234) & Table(218) & Table(202) & Table(186) & Table(170) & Table(154) & Table(138) & 
	Table(122) & Table(106) & Table(90) & Table(74) & Table(58) & Table(42) & Table(26) & Table(10) ; 

	constant Table11 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4091) & Table(4075) & Table(4059) & Table(4043) & Table(4027) & Table(4011) & Table(3995) & Table(3979) & 
	Table(3963) & Table(3947) & Table(3931) & Table(3915) & Table(3899) & Table(3883) & Table(3867) & Table(3851) & 
	Table(3835) & Table(3819) & Table(3803) & Table(3787) & Table(3771) & Table(3755) & Table(3739) & Table(3723) & 
	Table(3707) & Table(3691) & Table(3675) & Table(3659) & Table(3643) & Table(3627) & Table(3611) & Table(3595) & 
	Table(3579) & Table(3563) & Table(3547) & Table(3531) & Table(3515) & Table(3499) & Table(3483) & Table(3467) & 
	Table(3451) & Table(3435) & Table(3419) & Table(3403) & Table(3387) & Table(3371) & Table(3355) & Table(3339) & 
	Table(3323) & Table(3307) & Table(3291) & Table(3275) & Table(3259) & Table(3243) & Table(3227) & Table(3211) & 
	Table(3195) & Table(3179) & Table(3163) & Table(3147) & Table(3131) & Table(3115) & Table(3099) & Table(3083) & 
	Table(3067) & Table(3051) & Table(3035) & Table(3019) & Table(3003) & Table(2987) & Table(2971) & Table(2955) & 
	Table(2939) & Table(2923) & Table(2907) & Table(2891) & Table(2875) & Table(2859) & Table(2843) & Table(2827) & 
	Table(2811) & Table(2795) & Table(2779) & Table(2763) & Table(2747) & Table(2731) & Table(2715) & Table(2699) & 
	Table(2683) & Table(2667) & Table(2651) & Table(2635) & Table(2619) & Table(2603) & Table(2587) & Table(2571) & 
	Table(2555) & Table(2539) & Table(2523) & Table(2507) & Table(2491) & Table(2475) & Table(2459) & Table(2443) & 
	Table(2427) & Table(2411) & Table(2395) & Table(2379) & Table(2363) & Table(2347) & Table(2331) & Table(2315) & 
	Table(2299) & Table(2283) & Table(2267) & Table(2251) & Table(2235) & Table(2219) & Table(2203) & Table(2187) & 
	Table(2171) & Table(2155) & Table(2139) & Table(2123) & Table(2107) & Table(2091) & Table(2075) & Table(2059) & 
	Table(2043) & Table(2027) & Table(2011) & Table(1995) & Table(1979) & Table(1963) & Table(1947) & Table(1931) & 
	Table(1915) & Table(1899) & Table(1883) & Table(1867) & Table(1851) & Table(1835) & Table(1819) & Table(1803) & 
	Table(1787) & Table(1771) & Table(1755) & Table(1739) & Table(1723) & Table(1707) & Table(1691) & Table(1675) & 
	Table(1659) & Table(1643) & Table(1627) & Table(1611) & Table(1595) & Table(1579) & Table(1563) & Table(1547) & 
	Table(1531) & Table(1515) & Table(1499) & Table(1483) & Table(1467) & Table(1451) & Table(1435) & Table(1419) & 
	Table(1403) & Table(1387) & Table(1371) & Table(1355) & Table(1339) & Table(1323) & Table(1307) & Table(1291) & 
	Table(1275) & Table(1259) & Table(1243) & Table(1227) & Table(1211) & Table(1195) & Table(1179) & Table(1163) & 
	Table(1147) & Table(1131) & Table(1115) & Table(1099) & Table(1083) & Table(1067) & Table(1051) & Table(1035) & 
	Table(1019) & Table(1003) & Table(987) & Table(971) & Table(955) & Table(939) & Table(923) & Table(907) & 
	Table(891) & Table(875) & Table(859) & Table(843) & Table(827) & Table(811) & Table(795) & Table(779) & 
	Table(763) & Table(747) & Table(731) & Table(715) & Table(699) & Table(683) & Table(667) & Table(651) & 
	Table(635) & Table(619) & Table(603) & Table(587) & Table(571) & Table(555) & Table(539) & Table(523) & 
	Table(507) & Table(491) & Table(475) & Table(459) & Table(443) & Table(427) & Table(411) & Table(395) & 
	Table(379) & Table(363) & Table(347) & Table(331) & Table(315) & Table(299) & Table(283) & Table(267) & 
	Table(251) & Table(235) & Table(219) & Table(203) & Table(187) & Table(171) & Table(155) & Table(139) & 
	Table(123) & Table(107) & Table(91) & Table(75) & Table(59) & Table(43) & Table(27) & Table(11) ; 

	constant Table12 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4092) & Table(4076) & Table(4060) & Table(4044) & Table(4028) & Table(4012) & Table(3996) & Table(3980) & 
	Table(3964) & Table(3948) & Table(3932) & Table(3916) & Table(3900) & Table(3884) & Table(3868) & Table(3852) & 
	Table(3836) & Table(3820) & Table(3804) & Table(3788) & Table(3772) & Table(3756) & Table(3740) & Table(3724) & 
	Table(3708) & Table(3692) & Table(3676) & Table(3660) & Table(3644) & Table(3628) & Table(3612) & Table(3596) & 
	Table(3580) & Table(3564) & Table(3548) & Table(3532) & Table(3516) & Table(3500) & Table(3484) & Table(3468) & 
	Table(3452) & Table(3436) & Table(3420) & Table(3404) & Table(3388) & Table(3372) & Table(3356) & Table(3340) & 
	Table(3324) & Table(3308) & Table(3292) & Table(3276) & Table(3260) & Table(3244) & Table(3228) & Table(3212) & 
	Table(3196) & Table(3180) & Table(3164) & Table(3148) & Table(3132) & Table(3116) & Table(3100) & Table(3084) & 
	Table(3068) & Table(3052) & Table(3036) & Table(3020) & Table(3004) & Table(2988) & Table(2972) & Table(2956) & 
	Table(2940) & Table(2924) & Table(2908) & Table(2892) & Table(2876) & Table(2860) & Table(2844) & Table(2828) & 
	Table(2812) & Table(2796) & Table(2780) & Table(2764) & Table(2748) & Table(2732) & Table(2716) & Table(2700) & 
	Table(2684) & Table(2668) & Table(2652) & Table(2636) & Table(2620) & Table(2604) & Table(2588) & Table(2572) & 
	Table(2556) & Table(2540) & Table(2524) & Table(2508) & Table(2492) & Table(2476) & Table(2460) & Table(2444) & 
	Table(2428) & Table(2412) & Table(2396) & Table(2380) & Table(2364) & Table(2348) & Table(2332) & Table(2316) & 
	Table(2300) & Table(2284) & Table(2268) & Table(2252) & Table(2236) & Table(2220) & Table(2204) & Table(2188) & 
	Table(2172) & Table(2156) & Table(2140) & Table(2124) & Table(2108) & Table(2092) & Table(2076) & Table(2060) & 
	Table(2044) & Table(2028) & Table(2012) & Table(1996) & Table(1980) & Table(1964) & Table(1948) & Table(1932) & 
	Table(1916) & Table(1900) & Table(1884) & Table(1868) & Table(1852) & Table(1836) & Table(1820) & Table(1804) & 
	Table(1788) & Table(1772) & Table(1756) & Table(1740) & Table(1724) & Table(1708) & Table(1692) & Table(1676) & 
	Table(1660) & Table(1644) & Table(1628) & Table(1612) & Table(1596) & Table(1580) & Table(1564) & Table(1548) & 
	Table(1532) & Table(1516) & Table(1500) & Table(1484) & Table(1468) & Table(1452) & Table(1436) & Table(1420) & 
	Table(1404) & Table(1388) & Table(1372) & Table(1356) & Table(1340) & Table(1324) & Table(1308) & Table(1292) & 
	Table(1276) & Table(1260) & Table(1244) & Table(1228) & Table(1212) & Table(1196) & Table(1180) & Table(1164) & 
	Table(1148) & Table(1132) & Table(1116) & Table(1100) & Table(1084) & Table(1068) & Table(1052) & Table(1036) & 
	Table(1020) & Table(1004) & Table(988) & Table(972) & Table(956) & Table(940) & Table(924) & Table(908) & 
	Table(892) & Table(876) & Table(860) & Table(844) & Table(828) & Table(812) & Table(796) & Table(780) & 
	Table(764) & Table(748) & Table(732) & Table(716) & Table(700) & Table(684) & Table(668) & Table(652) & 
	Table(636) & Table(620) & Table(604) & Table(588) & Table(572) & Table(556) & Table(540) & Table(524) & 
	Table(508) & Table(492) & Table(476) & Table(460) & Table(444) & Table(428) & Table(412) & Table(396) & 
	Table(380) & Table(364) & Table(348) & Table(332) & Table(316) & Table(300) & Table(284) & Table(268) & 
	Table(252) & Table(236) & Table(220) & Table(204) & Table(188) & Table(172) & Table(156) & Table(140) & 
	Table(124) & Table(108) & Table(92) & Table(76) & Table(60) & Table(44) & Table(28) & Table(12) ; 

	constant Table13 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4093) & Table(4077) & Table(4061) & Table(4045) & Table(4029) & Table(4013) & Table(3997) & Table(3981) & 
	Table(3965) & Table(3949) & Table(3933) & Table(3917) & Table(3901) & Table(3885) & Table(3869) & Table(3853) & 
	Table(3837) & Table(3821) & Table(3805) & Table(3789) & Table(3773) & Table(3757) & Table(3741) & Table(3725) & 
	Table(3709) & Table(3693) & Table(3677) & Table(3661) & Table(3645) & Table(3629) & Table(3613) & Table(3597) & 
	Table(3581) & Table(3565) & Table(3549) & Table(3533) & Table(3517) & Table(3501) & Table(3485) & Table(3469) & 
	Table(3453) & Table(3437) & Table(3421) & Table(3405) & Table(3389) & Table(3373) & Table(3357) & Table(3341) & 
	Table(3325) & Table(3309) & Table(3293) & Table(3277) & Table(3261) & Table(3245) & Table(3229) & Table(3213) & 
	Table(3197) & Table(3181) & Table(3165) & Table(3149) & Table(3133) & Table(3117) & Table(3101) & Table(3085) & 
	Table(3069) & Table(3053) & Table(3037) & Table(3021) & Table(3005) & Table(2989) & Table(2973) & Table(2957) & 
	Table(2941) & Table(2925) & Table(2909) & Table(2893) & Table(2877) & Table(2861) & Table(2845) & Table(2829) & 
	Table(2813) & Table(2797) & Table(2781) & Table(2765) & Table(2749) & Table(2733) & Table(2717) & Table(2701) & 
	Table(2685) & Table(2669) & Table(2653) & Table(2637) & Table(2621) & Table(2605) & Table(2589) & Table(2573) & 
	Table(2557) & Table(2541) & Table(2525) & Table(2509) & Table(2493) & Table(2477) & Table(2461) & Table(2445) & 
	Table(2429) & Table(2413) & Table(2397) & Table(2381) & Table(2365) & Table(2349) & Table(2333) & Table(2317) & 
	Table(2301) & Table(2285) & Table(2269) & Table(2253) & Table(2237) & Table(2221) & Table(2205) & Table(2189) & 
	Table(2173) & Table(2157) & Table(2141) & Table(2125) & Table(2109) & Table(2093) & Table(2077) & Table(2061) & 
	Table(2045) & Table(2029) & Table(2013) & Table(1997) & Table(1981) & Table(1965) & Table(1949) & Table(1933) & 
	Table(1917) & Table(1901) & Table(1885) & Table(1869) & Table(1853) & Table(1837) & Table(1821) & Table(1805) & 
	Table(1789) & Table(1773) & Table(1757) & Table(1741) & Table(1725) & Table(1709) & Table(1693) & Table(1677) & 
	Table(1661) & Table(1645) & Table(1629) & Table(1613) & Table(1597) & Table(1581) & Table(1565) & Table(1549) & 
	Table(1533) & Table(1517) & Table(1501) & Table(1485) & Table(1469) & Table(1453) & Table(1437) & Table(1421) & 
	Table(1405) & Table(1389) & Table(1373) & Table(1357) & Table(1341) & Table(1325) & Table(1309) & Table(1293) & 
	Table(1277) & Table(1261) & Table(1245) & Table(1229) & Table(1213) & Table(1197) & Table(1181) & Table(1165) & 
	Table(1149) & Table(1133) & Table(1117) & Table(1101) & Table(1085) & Table(1069) & Table(1053) & Table(1037) & 
	Table(1021) & Table(1005) & Table(989) & Table(973) & Table(957) & Table(941) & Table(925) & Table(909) & 
	Table(893) & Table(877) & Table(861) & Table(845) & Table(829) & Table(813) & Table(797) & Table(781) & 
	Table(765) & Table(749) & Table(733) & Table(717) & Table(701) & Table(685) & Table(669) & Table(653) & 
	Table(637) & Table(621) & Table(605) & Table(589) & Table(573) & Table(557) & Table(541) & Table(525) & 
	Table(509) & Table(493) & Table(477) & Table(461) & Table(445) & Table(429) & Table(413) & Table(397) & 
	Table(381) & Table(365) & Table(349) & Table(333) & Table(317) & Table(301) & Table(285) & Table(269) & 
	Table(253) & Table(237) & Table(221) & Table(205) & Table(189) & Table(173) & Table(157) & Table(141) & 
	Table(125) & Table(109) & Table(93) & Table(77) & Table(61) & Table(45) & Table(29) & Table(13) ; 

	constant Table14 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4094) & Table(4078) & Table(4062) & Table(4046) & Table(4030) & Table(4014) & Table(3998) & Table(3982) & 
	Table(3966) & Table(3950) & Table(3934) & Table(3918) & Table(3902) & Table(3886) & Table(3870) & Table(3854) & 
	Table(3838) & Table(3822) & Table(3806) & Table(3790) & Table(3774) & Table(3758) & Table(3742) & Table(3726) & 
	Table(3710) & Table(3694) & Table(3678) & Table(3662) & Table(3646) & Table(3630) & Table(3614) & Table(3598) & 
	Table(3582) & Table(3566) & Table(3550) & Table(3534) & Table(3518) & Table(3502) & Table(3486) & Table(3470) & 
	Table(3454) & Table(3438) & Table(3422) & Table(3406) & Table(3390) & Table(3374) & Table(3358) & Table(3342) & 
	Table(3326) & Table(3310) & Table(3294) & Table(3278) & Table(3262) & Table(3246) & Table(3230) & Table(3214) & 
	Table(3198) & Table(3182) & Table(3166) & Table(3150) & Table(3134) & Table(3118) & Table(3102) & Table(3086) & 
	Table(3070) & Table(3054) & Table(3038) & Table(3022) & Table(3006) & Table(2990) & Table(2974) & Table(2958) & 
	Table(2942) & Table(2926) & Table(2910) & Table(2894) & Table(2878) & Table(2862) & Table(2846) & Table(2830) & 
	Table(2814) & Table(2798) & Table(2782) & Table(2766) & Table(2750) & Table(2734) & Table(2718) & Table(2702) & 
	Table(2686) & Table(2670) & Table(2654) & Table(2638) & Table(2622) & Table(2606) & Table(2590) & Table(2574) & 
	Table(2558) & Table(2542) & Table(2526) & Table(2510) & Table(2494) & Table(2478) & Table(2462) & Table(2446) & 
	Table(2430) & Table(2414) & Table(2398) & Table(2382) & Table(2366) & Table(2350) & Table(2334) & Table(2318) & 
	Table(2302) & Table(2286) & Table(2270) & Table(2254) & Table(2238) & Table(2222) & Table(2206) & Table(2190) & 
	Table(2174) & Table(2158) & Table(2142) & Table(2126) & Table(2110) & Table(2094) & Table(2078) & Table(2062) & 
	Table(2046) & Table(2030) & Table(2014) & Table(1998) & Table(1982) & Table(1966) & Table(1950) & Table(1934) & 
	Table(1918) & Table(1902) & Table(1886) & Table(1870) & Table(1854) & Table(1838) & Table(1822) & Table(1806) & 
	Table(1790) & Table(1774) & Table(1758) & Table(1742) & Table(1726) & Table(1710) & Table(1694) & Table(1678) & 
	Table(1662) & Table(1646) & Table(1630) & Table(1614) & Table(1598) & Table(1582) & Table(1566) & Table(1550) & 
	Table(1534) & Table(1518) & Table(1502) & Table(1486) & Table(1470) & Table(1454) & Table(1438) & Table(1422) & 
	Table(1406) & Table(1390) & Table(1374) & Table(1358) & Table(1342) & Table(1326) & Table(1310) & Table(1294) & 
	Table(1278) & Table(1262) & Table(1246) & Table(1230) & Table(1214) & Table(1198) & Table(1182) & Table(1166) & 
	Table(1150) & Table(1134) & Table(1118) & Table(1102) & Table(1086) & Table(1070) & Table(1054) & Table(1038) & 
	Table(1022) & Table(1006) & Table(990) & Table(974) & Table(958) & Table(942) & Table(926) & Table(910) & 
	Table(894) & Table(878) & Table(862) & Table(846) & Table(830) & Table(814) & Table(798) & Table(782) & 
	Table(766) & Table(750) & Table(734) & Table(718) & Table(702) & Table(686) & Table(670) & Table(654) & 
	Table(638) & Table(622) & Table(606) & Table(590) & Table(574) & Table(558) & Table(542) & Table(526) & 
	Table(510) & Table(494) & Table(478) & Table(462) & Table(446) & Table(430) & Table(414) & Table(398) & 
	Table(382) & Table(366) & Table(350) & Table(334) & Table(318) & Table(302) & Table(286) & Table(270) & 
	Table(254) & Table(238) & Table(222) & Table(206) & Table(190) & Table(174) & Table(158) & Table(142) & 
	Table(126) & Table(110) & Table(94) & Table(78) & Table(62) & Table(46) & Table(30) & Table(14) ; 

	constant Table15 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
	Table(4095) & Table(4079) & Table(4063) & Table(4047) & Table(4031) & Table(4015) & Table(3999) & Table(3983) & 
	Table(3967) & Table(3951) & Table(3935) & Table(3919) & Table(3903) & Table(3887) & Table(3871) & Table(3855) & 
	Table(3839) & Table(3823) & Table(3807) & Table(3791) & Table(3775) & Table(3759) & Table(3743) & Table(3727) & 
	Table(3711) & Table(3695) & Table(3679) & Table(3663) & Table(3647) & Table(3631) & Table(3615) & Table(3599) & 
	Table(3583) & Table(3567) & Table(3551) & Table(3535) & Table(3519) & Table(3503) & Table(3487) & Table(3471) & 
	Table(3455) & Table(3439) & Table(3423) & Table(3407) & Table(3391) & Table(3375) & Table(3359) & Table(3343) & 
	Table(3327) & Table(3311) & Table(3295) & Table(3279) & Table(3263) & Table(3247) & Table(3231) & Table(3215) & 
	Table(3199) & Table(3183) & Table(3167) & Table(3151) & Table(3135) & Table(3119) & Table(3103) & Table(3087) & 
	Table(3071) & Table(3055) & Table(3039) & Table(3023) & Table(3007) & Table(2991) & Table(2975) & Table(2959) & 
	Table(2943) & Table(2927) & Table(2911) & Table(2895) & Table(2879) & Table(2863) & Table(2847) & Table(2831) & 
	Table(2815) & Table(2799) & Table(2783) & Table(2767) & Table(2751) & Table(2735) & Table(2719) & Table(2703) & 
	Table(2687) & Table(2671) & Table(2655) & Table(2639) & Table(2623) & Table(2607) & Table(2591) & Table(2575) & 
	Table(2559) & Table(2543) & Table(2527) & Table(2511) & Table(2495) & Table(2479) & Table(2463) & Table(2447) & 
	Table(2431) & Table(2415) & Table(2399) & Table(2383) & Table(2367) & Table(2351) & Table(2335) & Table(2319) & 
	Table(2303) & Table(2287) & Table(2271) & Table(2255) & Table(2239) & Table(2223) & Table(2207) & Table(2191) & 
	Table(2175) & Table(2159) & Table(2143) & Table(2127) & Table(2111) & Table(2095) & Table(2079) & Table(2063) & 
	Table(2047) & Table(2031) & Table(2015) & Table(1999) & Table(1983) & Table(1967) & Table(1951) & Table(1935) & 
	Table(1919) & Table(1903) & Table(1887) & Table(1871) & Table(1855) & Table(1839) & Table(1823) & Table(1807) & 
	Table(1791) & Table(1775) & Table(1759) & Table(1743) & Table(1727) & Table(1711) & Table(1695) & Table(1679) & 
	Table(1663) & Table(1647) & Table(1631) & Table(1615) & Table(1599) & Table(1583) & Table(1567) & Table(1551) & 
	Table(1535) & Table(1519) & Table(1503) & Table(1487) & Table(1471) & Table(1455) & Table(1439) & Table(1423) & 
	Table(1407) & Table(1391) & Table(1375) & Table(1359) & Table(1343) & Table(1327) & Table(1311) & Table(1295) & 
	Table(1279) & Table(1263) & Table(1247) & Table(1231) & Table(1215) & Table(1199) & Table(1183) & Table(1167) & 
	Table(1151) & Table(1135) & Table(1119) & Table(1103) & Table(1087) & Table(1071) & Table(1055) & Table(1039) & 
	Table(1023) & Table(1007) & Table(991) & Table(975) & Table(959) & Table(943) & Table(927) & Table(911) & 
	Table(895) & Table(879) & Table(863) & Table(847) & Table(831) & Table(815) & Table(799) & Table(783) & 
	Table(767) & Table(751) & Table(735) & Table(719) & Table(703) & Table(687) & Table(671) & Table(655) & 
	Table(639) & Table(623) & Table(607) & Table(591) & Table(575) & Table(559) & Table(543) & Table(527) & 
	Table(511) & Table(495) & Table(479) & Table(463) & Table(447) & Table(431) & Table(415) & Table(399) & 
	Table(383) & Table(367) & Table(351) & Table(335) & Table(319) & Table(303) & Table(287) & Table(271) & 
	Table(255) & Table(239) & Table(223) & Table(207) & Table(191) & Table(175) & Table(159) & Table(143) & 
	Table(127) & Table(111) & Table(95) & Table(79) & Table(63) & Table(47) & Table(31) & Table(15) ; 

	----
	
	signal rcon		: STD_LOGIC_VECTOR (7 downto 0);
	signal Compressed_Red_rcon			: STD_LOGIC_VECTOR (7 downto 0);
	signal done_vec	: STD_LOGIC_VECTOR (7 downto 0);

begin

	Compressed_Red_rcon <= Red_rcon(Red_size-1) & Red_rcon(6 downto 0);

	LFInv_Process: Process (Compressed_Red_rcon)
	begin
		rcon(0) 	<= LFInvTable0(255-to_integer(unsigned(Compressed_Red_rcon)));
		rcon(1) 	<= LFInvTable1(255-to_integer(unsigned(Compressed_Red_rcon)));
		rcon(2) 	<= LFInvTable2(255-to_integer(unsigned(Compressed_Red_rcon)));
		rcon(3) 	<= LFInvTable3(255-to_integer(unsigned(Compressed_Red_rcon)));
		rcon(4) 	<= LFInvTable4(255-to_integer(unsigned(Compressed_Red_rcon)));
		rcon(5) 	<= LFInvTable5(255-to_integer(unsigned(Compressed_Red_rcon)));
		rcon(6) 	<= LFInvTable6(255-to_integer(unsigned(Compressed_Red_rcon)));
		rcon(7) 	<= LFInvTable7(255-to_integer(unsigned(Compressed_Red_rcon)));

	end process;
		

	done_vec(0)	<= '1' WHEN (rcon = x"6c") ELSE '0';
	done_vec(1) <= '0';
	done_vec(2) <= '0';
	done_vec(3) <= '0';
	done_vec(4) <= '0';
	done_vec(5) <= '0';
	done_vec(6) <= '0';
	done_vec(7) <= '0';

	-------------------
	
	GEN0: IF BitNumber=0 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table0(255-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;

	GEN1: IF BitNumber=1 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table1(255-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;

	GEN2: IF BitNumber=2 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table2(255-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;
	
	GEN3: IF BitNumber=3 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table3(255-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;

	GEN4: IF BitNumber=4 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table4(255-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;

	GEN5: IF BitNumber=5 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table5(255-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;
	
	GEN6: IF BitNumber=6 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table6(255-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;
	
	GEN7: IF BitNumber=7 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table7(255-to_integer(unsigned(done_vec)));
		end process;	
	END GENERATE;

	GEN8: IF BitNumber=8 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table8(255-to_integer(unsigned(done_vec)));
		end process;
	END GENERATE;

	GEN9: IF BitNumber=9 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table9(255-to_integer(unsigned(done_vec)));
		end process;
	END GENERATE;

	GEN10: IF BitNumber=10 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table10(255-to_integer(unsigned(done_vec)));
		end process;
	END GENERATE;

	GEN11: IF BitNumber=11 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table11(255-to_integer(unsigned(done_vec)));
		end process;
	END GENERATE;

	GEN12: IF BitNumber=12 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table12(255-to_integer(unsigned(done_vec)));
		end process;
	END GENERATE;

	GEN13: IF BitNumber=13 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table13(255-to_integer(unsigned(done_vec)));
		end process;
	END GENERATE;

	GEN14: IF BitNumber=14 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table14(255-to_integer(unsigned(done_vec)));
		end process;
	END GENERATE;

	GEN15: IF BitNumber=15 GENERATE
		LF_Process: Process (done_vec)
		begin
			Red_DoneBit <= Table15(255-to_integer(unsigned(done_vec)));
		end process;
		
	END GENERATE;

end Behavioral;

