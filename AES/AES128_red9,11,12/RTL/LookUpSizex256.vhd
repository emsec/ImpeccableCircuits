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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY LookUpSizex256 IS
	GENERIC ( 
		size  : POSITIVE;
		Table : STD_LOGIC_VECTOR (4095 DOWNTO 0));
	PORT ( input:  IN  STD_LOGIC_VECTOR (7      DOWNTO 0);
			 output: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0));
END LookUpSizex256;

ARCHITECTURE behavioral OF LookUpSizex256 IS

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

BEGIN

	LFInst_0: ENTITY work.LookUp
	GENERIC Map (size => 8, Table => Table0)
	PORT Map (input, output(0));
	
	Red_2:
	IF size > 1 GENERATE
		LFInst_1: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table1)
		PORT Map (input, output(1));
	END GENERATE;

	Red_3:
	IF size > 2 GENERATE
		LFInst_2: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table2)
		PORT Map (input, output(2));
	END GENERATE;

	Red_4:
	IF size > 3 GENERATE
		LFInst_3: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table3)
		PORT Map (input, output(3));
	END GENERATE;
	
	Red_5:
	IF size > 4 GENERATE
		LFInst_4: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table4)
		PORT Map (input, output(4));
	END GENERATE;
	
	Red_6:
	IF size > 5 GENERATE
		LFInst_5: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table5)
		PORT Map (input, output(5));
	END GENERATE;
	
	Red_7:
	IF size > 6 GENERATE
		LFInst_6: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table6)
		PORT Map (input, output(6));
	END GENERATE;
	
	Red_8:
	IF size > 7 GENERATE
		LFInst_7: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table7)
		PORT Map (input, output(7));
	END GENERATE;
	
	Red_9:
	IF size > 8 GENERATE
		LFInst_8: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table8)
		PORT Map (input, output(8));
	END GENERATE;

	Red_10:
	IF size > 9 GENERATE
		LFInst_9: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table9)
		PORT Map (input, output(9));
	END GENERATE;

	Red_11:
	IF size > 10 GENERATE
		LFInst_10: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table10)
		PORT Map (input, output(10));
	END GENERATE;

	Red_12:
	IF size > 11 GENERATE
		LFInst_11: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table11)
		PORT Map (input, output(11));
	END GENERATE;

	Red_13:
	IF size > 12 GENERATE
		LFInst_12: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table12)
		PORT Map (input, output(12));
	END GENERATE;

	Red_14:
	IF size > 13 GENERATE
		LFInst_13: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table13)
		PORT Map (input, output(13));
	END GENERATE;

	Red_15:
	IF size > 14 GENERATE
		LFInst_14: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table14)
		PORT Map (input, output(14));
	END GENERATE;

	Red_16:
	IF size > 15 GENERATE
		LFInst_15: ENTITY work.LookUp
		GENERIC Map (size => 8, Table => Table15)
		PORT Map (input, output(15));
	END GENERATE;

END behavioral;

