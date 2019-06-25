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
		Table : STD_LOGIC_VECTOR (2047 DOWNTO 0));
	PORT ( input:  IN  STD_LOGIC_VECTOR (7      DOWNTO 0);
			 output: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0));
END LookUpSizex256;

ARCHITECTURE behavioral OF LookUpSizex256 IS

constant Table0 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
Table(2040) & Table(2032) & Table(2024) & Table(2016) & Table(2008) & Table(2000) & Table(1992) & Table(1984) & 
Table(1976) & Table(1968) & Table(1960) & Table(1952) & Table(1944) & Table(1936) & Table(1928) & Table(1920) & 
Table(1912) & Table(1904) & Table(1896) & Table(1888) & Table(1880) & Table(1872) & Table(1864) & Table(1856) & 
Table(1848) & Table(1840) & Table(1832) & Table(1824) & Table(1816) & Table(1808) & Table(1800) & Table(1792) & 
Table(1784) & Table(1776) & Table(1768) & Table(1760) & Table(1752) & Table(1744) & Table(1736) & Table(1728) & 
Table(1720) & Table(1712) & Table(1704) & Table(1696) & Table(1688) & Table(1680) & Table(1672) & Table(1664) & 
Table(1656) & Table(1648) & Table(1640) & Table(1632) & Table(1624) & Table(1616) & Table(1608) & Table(1600) & 
Table(1592) & Table(1584) & Table(1576) & Table(1568) & Table(1560) & Table(1552) & Table(1544) & Table(1536) & 
Table(1528) & Table(1520) & Table(1512) & Table(1504) & Table(1496) & Table(1488) & Table(1480) & Table(1472) & 
Table(1464) & Table(1456) & Table(1448) & Table(1440) & Table(1432) & Table(1424) & Table(1416) & Table(1408) & 
Table(1400) & Table(1392) & Table(1384) & Table(1376) & Table(1368) & Table(1360) & Table(1352) & Table(1344) & 
Table(1336) & Table(1328) & Table(1320) & Table(1312) & Table(1304) & Table(1296) & Table(1288) & Table(1280) & 
Table(1272) & Table(1264) & Table(1256) & Table(1248) & Table(1240) & Table(1232) & Table(1224) & Table(1216) & 
Table(1208) & Table(1200) & Table(1192) & Table(1184) & Table(1176) & Table(1168) & Table(1160) & Table(1152) & 
Table(1144) & Table(1136) & Table(1128) & Table(1120) & Table(1112) & Table(1104) & Table(1096) & Table(1088) & 
Table(1080) & Table(1072) & Table(1064) & Table(1056) & Table(1048) & Table(1040) & Table(1032) & Table(1024) & 
Table(1016) & Table(1008) & Table(1000) & Table(992) & Table(984) & Table(976) & Table(968) & Table(960) & 
Table(952) & Table(944) & Table(936) & Table(928) & Table(920) & Table(912) & Table(904) & Table(896) & 
Table(888) & Table(880) & Table(872) & Table(864) & Table(856) & Table(848) & Table(840) & Table(832) & 
Table(824) & Table(816) & Table(808) & Table(800) & Table(792) & Table(784) & Table(776) & Table(768) & 
Table(760) & Table(752) & Table(744) & Table(736) & Table(728) & Table(720) & Table(712) & Table(704) & 
Table(696) & Table(688) & Table(680) & Table(672) & Table(664) & Table(656) & Table(648) & Table(640) & 
Table(632) & Table(624) & Table(616) & Table(608) & Table(600) & Table(592) & Table(584) & Table(576) & 
Table(568) & Table(560) & Table(552) & Table(544) & Table(536) & Table(528) & Table(520) & Table(512) & 
Table(504) & Table(496) & Table(488) & Table(480) & Table(472) & Table(464) & Table(456) & Table(448) & 
Table(440) & Table(432) & Table(424) & Table(416) & Table(408) & Table(400) & Table(392) & Table(384) & 
Table(376) & Table(368) & Table(360) & Table(352) & Table(344) & Table(336) & Table(328) & Table(320) & 
Table(312) & Table(304) & Table(296) & Table(288) & Table(280) & Table(272) & Table(264) & Table(256) & 
Table(248) & Table(240) & Table(232) & Table(224) & Table(216) & Table(208) & Table(200) & Table(192) & 
Table(184) & Table(176) & Table(168) & Table(160) & Table(152) & Table(144) & Table(136) & Table(128) & 
Table(120) & Table(112) & Table(104) & Table(96) & Table(88) & Table(80) & Table(72) & Table(64) & 
Table(56) & Table(48) & Table(40) & Table(32) & Table(24) & Table(16) & Table(8) & Table(0) ; 

constant Table1 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
Table(2041) & Table(2033) & Table(2025) & Table(2017) & Table(2009) & Table(2001) & Table(1993) & Table(1985) & 
Table(1977) & Table(1969) & Table(1961) & Table(1953) & Table(1945) & Table(1937) & Table(1929) & Table(1921) & 
Table(1913) & Table(1905) & Table(1897) & Table(1889) & Table(1881) & Table(1873) & Table(1865) & Table(1857) & 
Table(1849) & Table(1841) & Table(1833) & Table(1825) & Table(1817) & Table(1809) & Table(1801) & Table(1793) & 
Table(1785) & Table(1777) & Table(1769) & Table(1761) & Table(1753) & Table(1745) & Table(1737) & Table(1729) & 
Table(1721) & Table(1713) & Table(1705) & Table(1697) & Table(1689) & Table(1681) & Table(1673) & Table(1665) & 
Table(1657) & Table(1649) & Table(1641) & Table(1633) & Table(1625) & Table(1617) & Table(1609) & Table(1601) & 
Table(1593) & Table(1585) & Table(1577) & Table(1569) & Table(1561) & Table(1553) & Table(1545) & Table(1537) & 
Table(1529) & Table(1521) & Table(1513) & Table(1505) & Table(1497) & Table(1489) & Table(1481) & Table(1473) & 
Table(1465) & Table(1457) & Table(1449) & Table(1441) & Table(1433) & Table(1425) & Table(1417) & Table(1409) & 
Table(1401) & Table(1393) & Table(1385) & Table(1377) & Table(1369) & Table(1361) & Table(1353) & Table(1345) & 
Table(1337) & Table(1329) & Table(1321) & Table(1313) & Table(1305) & Table(1297) & Table(1289) & Table(1281) & 
Table(1273) & Table(1265) & Table(1257) & Table(1249) & Table(1241) & Table(1233) & Table(1225) & Table(1217) & 
Table(1209) & Table(1201) & Table(1193) & Table(1185) & Table(1177) & Table(1169) & Table(1161) & Table(1153) & 
Table(1145) & Table(1137) & Table(1129) & Table(1121) & Table(1113) & Table(1105) & Table(1097) & Table(1089) & 
Table(1081) & Table(1073) & Table(1065) & Table(1057) & Table(1049) & Table(1041) & Table(1033) & Table(1025) & 
Table(1017) & Table(1009) & Table(1001) & Table(993) & Table(985) & Table(977) & Table(969) & Table(961) & 
Table(953) & Table(945) & Table(937) & Table(929) & Table(921) & Table(913) & Table(905) & Table(897) & 
Table(889) & Table(881) & Table(873) & Table(865) & Table(857) & Table(849) & Table(841) & Table(833) & 
Table(825) & Table(817) & Table(809) & Table(801) & Table(793) & Table(785) & Table(777) & Table(769) & 
Table(761) & Table(753) & Table(745) & Table(737) & Table(729) & Table(721) & Table(713) & Table(705) & 
Table(697) & Table(689) & Table(681) & Table(673) & Table(665) & Table(657) & Table(649) & Table(641) & 
Table(633) & Table(625) & Table(617) & Table(609) & Table(601) & Table(593) & Table(585) & Table(577) & 
Table(569) & Table(561) & Table(553) & Table(545) & Table(537) & Table(529) & Table(521) & Table(513) & 
Table(505) & Table(497) & Table(489) & Table(481) & Table(473) & Table(465) & Table(457) & Table(449) & 
Table(441) & Table(433) & Table(425) & Table(417) & Table(409) & Table(401) & Table(393) & Table(385) & 
Table(377) & Table(369) & Table(361) & Table(353) & Table(345) & Table(337) & Table(329) & Table(321) & 
Table(313) & Table(305) & Table(297) & Table(289) & Table(281) & Table(273) & Table(265) & Table(257) & 
Table(249) & Table(241) & Table(233) & Table(225) & Table(217) & Table(209) & Table(201) & Table(193) & 
Table(185) & Table(177) & Table(169) & Table(161) & Table(153) & Table(145) & Table(137) & Table(129) & 
Table(121) & Table(113) & Table(105) & Table(97) & Table(89) & Table(81) & Table(73) & Table(65) & 
Table(57) & Table(49) & Table(41) & Table(33) & Table(25) & Table(17) & Table(9) & Table(1) ; 

constant Table2 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
Table(2042) & Table(2034) & Table(2026) & Table(2018) & Table(2010) & Table(2002) & Table(1994) & Table(1986) & 
Table(1978) & Table(1970) & Table(1962) & Table(1954) & Table(1946) & Table(1938) & Table(1930) & Table(1922) & 
Table(1914) & Table(1906) & Table(1898) & Table(1890) & Table(1882) & Table(1874) & Table(1866) & Table(1858) & 
Table(1850) & Table(1842) & Table(1834) & Table(1826) & Table(1818) & Table(1810) & Table(1802) & Table(1794) & 
Table(1786) & Table(1778) & Table(1770) & Table(1762) & Table(1754) & Table(1746) & Table(1738) & Table(1730) & 
Table(1722) & Table(1714) & Table(1706) & Table(1698) & Table(1690) & Table(1682) & Table(1674) & Table(1666) & 
Table(1658) & Table(1650) & Table(1642) & Table(1634) & Table(1626) & Table(1618) & Table(1610) & Table(1602) & 
Table(1594) & Table(1586) & Table(1578) & Table(1570) & Table(1562) & Table(1554) & Table(1546) & Table(1538) & 
Table(1530) & Table(1522) & Table(1514) & Table(1506) & Table(1498) & Table(1490) & Table(1482) & Table(1474) & 
Table(1466) & Table(1458) & Table(1450) & Table(1442) & Table(1434) & Table(1426) & Table(1418) & Table(1410) & 
Table(1402) & Table(1394) & Table(1386) & Table(1378) & Table(1370) & Table(1362) & Table(1354) & Table(1346) & 
Table(1338) & Table(1330) & Table(1322) & Table(1314) & Table(1306) & Table(1298) & Table(1290) & Table(1282) & 
Table(1274) & Table(1266) & Table(1258) & Table(1250) & Table(1242) & Table(1234) & Table(1226) & Table(1218) & 
Table(1210) & Table(1202) & Table(1194) & Table(1186) & Table(1178) & Table(1170) & Table(1162) & Table(1154) & 
Table(1146) & Table(1138) & Table(1130) & Table(1122) & Table(1114) & Table(1106) & Table(1098) & Table(1090) & 
Table(1082) & Table(1074) & Table(1066) & Table(1058) & Table(1050) & Table(1042) & Table(1034) & Table(1026) & 
Table(1018) & Table(1010) & Table(1002) & Table(994) & Table(986) & Table(978) & Table(970) & Table(962) & 
Table(954) & Table(946) & Table(938) & Table(930) & Table(922) & Table(914) & Table(906) & Table(898) & 
Table(890) & Table(882) & Table(874) & Table(866) & Table(858) & Table(850) & Table(842) & Table(834) & 
Table(826) & Table(818) & Table(810) & Table(802) & Table(794) & Table(786) & Table(778) & Table(770) & 
Table(762) & Table(754) & Table(746) & Table(738) & Table(730) & Table(722) & Table(714) & Table(706) & 
Table(698) & Table(690) & Table(682) & Table(674) & Table(666) & Table(658) & Table(650) & Table(642) & 
Table(634) & Table(626) & Table(618) & Table(610) & Table(602) & Table(594) & Table(586) & Table(578) & 
Table(570) & Table(562) & Table(554) & Table(546) & Table(538) & Table(530) & Table(522) & Table(514) & 
Table(506) & Table(498) & Table(490) & Table(482) & Table(474) & Table(466) & Table(458) & Table(450) & 
Table(442) & Table(434) & Table(426) & Table(418) & Table(410) & Table(402) & Table(394) & Table(386) & 
Table(378) & Table(370) & Table(362) & Table(354) & Table(346) & Table(338) & Table(330) & Table(322) & 
Table(314) & Table(306) & Table(298) & Table(290) & Table(282) & Table(274) & Table(266) & Table(258) & 
Table(250) & Table(242) & Table(234) & Table(226) & Table(218) & Table(210) & Table(202) & Table(194) & 
Table(186) & Table(178) & Table(170) & Table(162) & Table(154) & Table(146) & Table(138) & Table(130) & 
Table(122) & Table(114) & Table(106) & Table(98) & Table(90) & Table(82) & Table(74) & Table(66) & 
Table(58) & Table(50) & Table(42) & Table(34) & Table(26) & Table(18) & Table(10) & Table(2) ; 

constant Table3 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
Table(2043) & Table(2035) & Table(2027) & Table(2019) & Table(2011) & Table(2003) & Table(1995) & Table(1987) & 
Table(1979) & Table(1971) & Table(1963) & Table(1955) & Table(1947) & Table(1939) & Table(1931) & Table(1923) & 
Table(1915) & Table(1907) & Table(1899) & Table(1891) & Table(1883) & Table(1875) & Table(1867) & Table(1859) & 
Table(1851) & Table(1843) & Table(1835) & Table(1827) & Table(1819) & Table(1811) & Table(1803) & Table(1795) & 
Table(1787) & Table(1779) & Table(1771) & Table(1763) & Table(1755) & Table(1747) & Table(1739) & Table(1731) & 
Table(1723) & Table(1715) & Table(1707) & Table(1699) & Table(1691) & Table(1683) & Table(1675) & Table(1667) & 
Table(1659) & Table(1651) & Table(1643) & Table(1635) & Table(1627) & Table(1619) & Table(1611) & Table(1603) & 
Table(1595) & Table(1587) & Table(1579) & Table(1571) & Table(1563) & Table(1555) & Table(1547) & Table(1539) & 
Table(1531) & Table(1523) & Table(1515) & Table(1507) & Table(1499) & Table(1491) & Table(1483) & Table(1475) & 
Table(1467) & Table(1459) & Table(1451) & Table(1443) & Table(1435) & Table(1427) & Table(1419) & Table(1411) & 
Table(1403) & Table(1395) & Table(1387) & Table(1379) & Table(1371) & Table(1363) & Table(1355) & Table(1347) & 
Table(1339) & Table(1331) & Table(1323) & Table(1315) & Table(1307) & Table(1299) & Table(1291) & Table(1283) & 
Table(1275) & Table(1267) & Table(1259) & Table(1251) & Table(1243) & Table(1235) & Table(1227) & Table(1219) & 
Table(1211) & Table(1203) & Table(1195) & Table(1187) & Table(1179) & Table(1171) & Table(1163) & Table(1155) & 
Table(1147) & Table(1139) & Table(1131) & Table(1123) & Table(1115) & Table(1107) & Table(1099) & Table(1091) & 
Table(1083) & Table(1075) & Table(1067) & Table(1059) & Table(1051) & Table(1043) & Table(1035) & Table(1027) & 
Table(1019) & Table(1011) & Table(1003) & Table(995) & Table(987) & Table(979) & Table(971) & Table(963) & 
Table(955) & Table(947) & Table(939) & Table(931) & Table(923) & Table(915) & Table(907) & Table(899) & 
Table(891) & Table(883) & Table(875) & Table(867) & Table(859) & Table(851) & Table(843) & Table(835) & 
Table(827) & Table(819) & Table(811) & Table(803) & Table(795) & Table(787) & Table(779) & Table(771) & 
Table(763) & Table(755) & Table(747) & Table(739) & Table(731) & Table(723) & Table(715) & Table(707) & 
Table(699) & Table(691) & Table(683) & Table(675) & Table(667) & Table(659) & Table(651) & Table(643) & 
Table(635) & Table(627) & Table(619) & Table(611) & Table(603) & Table(595) & Table(587) & Table(579) & 
Table(571) & Table(563) & Table(555) & Table(547) & Table(539) & Table(531) & Table(523) & Table(515) & 
Table(507) & Table(499) & Table(491) & Table(483) & Table(475) & Table(467) & Table(459) & Table(451) & 
Table(443) & Table(435) & Table(427) & Table(419) & Table(411) & Table(403) & Table(395) & Table(387) & 
Table(379) & Table(371) & Table(363) & Table(355) & Table(347) & Table(339) & Table(331) & Table(323) & 
Table(315) & Table(307) & Table(299) & Table(291) & Table(283) & Table(275) & Table(267) & Table(259) & 
Table(251) & Table(243) & Table(235) & Table(227) & Table(219) & Table(211) & Table(203) & Table(195) & 
Table(187) & Table(179) & Table(171) & Table(163) & Table(155) & Table(147) & Table(139) & Table(131) & 
Table(123) & Table(115) & Table(107) & Table(99) & Table(91) & Table(83) & Table(75) & Table(67) & 
Table(59) & Table(51) & Table(43) & Table(35) & Table(27) & Table(19) & Table(11) & Table(3) ; 

constant Table4 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
Table(2044) & Table(2036) & Table(2028) & Table(2020) & Table(2012) & Table(2004) & Table(1996) & Table(1988) & 
Table(1980) & Table(1972) & Table(1964) & Table(1956) & Table(1948) & Table(1940) & Table(1932) & Table(1924) & 
Table(1916) & Table(1908) & Table(1900) & Table(1892) & Table(1884) & Table(1876) & Table(1868) & Table(1860) & 
Table(1852) & Table(1844) & Table(1836) & Table(1828) & Table(1820) & Table(1812) & Table(1804) & Table(1796) & 
Table(1788) & Table(1780) & Table(1772) & Table(1764) & Table(1756) & Table(1748) & Table(1740) & Table(1732) & 
Table(1724) & Table(1716) & Table(1708) & Table(1700) & Table(1692) & Table(1684) & Table(1676) & Table(1668) & 
Table(1660) & Table(1652) & Table(1644) & Table(1636) & Table(1628) & Table(1620) & Table(1612) & Table(1604) & 
Table(1596) & Table(1588) & Table(1580) & Table(1572) & Table(1564) & Table(1556) & Table(1548) & Table(1540) & 
Table(1532) & Table(1524) & Table(1516) & Table(1508) & Table(1500) & Table(1492) & Table(1484) & Table(1476) & 
Table(1468) & Table(1460) & Table(1452) & Table(1444) & Table(1436) & Table(1428) & Table(1420) & Table(1412) & 
Table(1404) & Table(1396) & Table(1388) & Table(1380) & Table(1372) & Table(1364) & Table(1356) & Table(1348) & 
Table(1340) & Table(1332) & Table(1324) & Table(1316) & Table(1308) & Table(1300) & Table(1292) & Table(1284) & 
Table(1276) & Table(1268) & Table(1260) & Table(1252) & Table(1244) & Table(1236) & Table(1228) & Table(1220) & 
Table(1212) & Table(1204) & Table(1196) & Table(1188) & Table(1180) & Table(1172) & Table(1164) & Table(1156) & 
Table(1148) & Table(1140) & Table(1132) & Table(1124) & Table(1116) & Table(1108) & Table(1100) & Table(1092) & 
Table(1084) & Table(1076) & Table(1068) & Table(1060) & Table(1052) & Table(1044) & Table(1036) & Table(1028) & 
Table(1020) & Table(1012) & Table(1004) & Table(996) & Table(988) & Table(980) & Table(972) & Table(964) & 
Table(956) & Table(948) & Table(940) & Table(932) & Table(924) & Table(916) & Table(908) & Table(900) & 
Table(892) & Table(884) & Table(876) & Table(868) & Table(860) & Table(852) & Table(844) & Table(836) & 
Table(828) & Table(820) & Table(812) & Table(804) & Table(796) & Table(788) & Table(780) & Table(772) & 
Table(764) & Table(756) & Table(748) & Table(740) & Table(732) & Table(724) & Table(716) & Table(708) & 
Table(700) & Table(692) & Table(684) & Table(676) & Table(668) & Table(660) & Table(652) & Table(644) & 
Table(636) & Table(628) & Table(620) & Table(612) & Table(604) & Table(596) & Table(588) & Table(580) & 
Table(572) & Table(564) & Table(556) & Table(548) & Table(540) & Table(532) & Table(524) & Table(516) & 
Table(508) & Table(500) & Table(492) & Table(484) & Table(476) & Table(468) & Table(460) & Table(452) & 
Table(444) & Table(436) & Table(428) & Table(420) & Table(412) & Table(404) & Table(396) & Table(388) & 
Table(380) & Table(372) & Table(364) & Table(356) & Table(348) & Table(340) & Table(332) & Table(324) & 
Table(316) & Table(308) & Table(300) & Table(292) & Table(284) & Table(276) & Table(268) & Table(260) & 
Table(252) & Table(244) & Table(236) & Table(228) & Table(220) & Table(212) & Table(204) & Table(196) & 
Table(188) & Table(180) & Table(172) & Table(164) & Table(156) & Table(148) & Table(140) & Table(132) & 
Table(124) & Table(116) & Table(108) & Table(100) & Table(92) & Table(84) & Table(76) & Table(68) & 
Table(60) & Table(52) & Table(44) & Table(36) & Table(28) & Table(20) & Table(12) & Table(4) ; 

constant Table5 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
Table(2045) & Table(2037) & Table(2029) & Table(2021) & Table(2013) & Table(2005) & Table(1997) & Table(1989) & 
Table(1981) & Table(1973) & Table(1965) & Table(1957) & Table(1949) & Table(1941) & Table(1933) & Table(1925) & 
Table(1917) & Table(1909) & Table(1901) & Table(1893) & Table(1885) & Table(1877) & Table(1869) & Table(1861) & 
Table(1853) & Table(1845) & Table(1837) & Table(1829) & Table(1821) & Table(1813) & Table(1805) & Table(1797) & 
Table(1789) & Table(1781) & Table(1773) & Table(1765) & Table(1757) & Table(1749) & Table(1741) & Table(1733) & 
Table(1725) & Table(1717) & Table(1709) & Table(1701) & Table(1693) & Table(1685) & Table(1677) & Table(1669) & 
Table(1661) & Table(1653) & Table(1645) & Table(1637) & Table(1629) & Table(1621) & Table(1613) & Table(1605) & 
Table(1597) & Table(1589) & Table(1581) & Table(1573) & Table(1565) & Table(1557) & Table(1549) & Table(1541) & 
Table(1533) & Table(1525) & Table(1517) & Table(1509) & Table(1501) & Table(1493) & Table(1485) & Table(1477) & 
Table(1469) & Table(1461) & Table(1453) & Table(1445) & Table(1437) & Table(1429) & Table(1421) & Table(1413) & 
Table(1405) & Table(1397) & Table(1389) & Table(1381) & Table(1373) & Table(1365) & Table(1357) & Table(1349) & 
Table(1341) & Table(1333) & Table(1325) & Table(1317) & Table(1309) & Table(1301) & Table(1293) & Table(1285) & 
Table(1277) & Table(1269) & Table(1261) & Table(1253) & Table(1245) & Table(1237) & Table(1229) & Table(1221) & 
Table(1213) & Table(1205) & Table(1197) & Table(1189) & Table(1181) & Table(1173) & Table(1165) & Table(1157) & 
Table(1149) & Table(1141) & Table(1133) & Table(1125) & Table(1117) & Table(1109) & Table(1101) & Table(1093) & 
Table(1085) & Table(1077) & Table(1069) & Table(1061) & Table(1053) & Table(1045) & Table(1037) & Table(1029) & 
Table(1021) & Table(1013) & Table(1005) & Table(997) & Table(989) & Table(981) & Table(973) & Table(965) & 
Table(957) & Table(949) & Table(941) & Table(933) & Table(925) & Table(917) & Table(909) & Table(901) & 
Table(893) & Table(885) & Table(877) & Table(869) & Table(861) & Table(853) & Table(845) & Table(837) & 
Table(829) & Table(821) & Table(813) & Table(805) & Table(797) & Table(789) & Table(781) & Table(773) & 
Table(765) & Table(757) & Table(749) & Table(741) & Table(733) & Table(725) & Table(717) & Table(709) & 
Table(701) & Table(693) & Table(685) & Table(677) & Table(669) & Table(661) & Table(653) & Table(645) & 
Table(637) & Table(629) & Table(621) & Table(613) & Table(605) & Table(597) & Table(589) & Table(581) & 
Table(573) & Table(565) & Table(557) & Table(549) & Table(541) & Table(533) & Table(525) & Table(517) & 
Table(509) & Table(501) & Table(493) & Table(485) & Table(477) & Table(469) & Table(461) & Table(453) & 
Table(445) & Table(437) & Table(429) & Table(421) & Table(413) & Table(405) & Table(397) & Table(389) & 
Table(381) & Table(373) & Table(365) & Table(357) & Table(349) & Table(341) & Table(333) & Table(325) & 
Table(317) & Table(309) & Table(301) & Table(293) & Table(285) & Table(277) & Table(269) & Table(261) & 
Table(253) & Table(245) & Table(237) & Table(229) & Table(221) & Table(213) & Table(205) & Table(197) & 
Table(189) & Table(181) & Table(173) & Table(165) & Table(157) & Table(149) & Table(141) & Table(133) & 
Table(125) & Table(117) & Table(109) & Table(101) & Table(93) & Table(85) & Table(77) & Table(69) & 
Table(61) & Table(53) & Table(45) & Table(37) & Table(29) & Table(21) & Table(13) & Table(5) ; 

constant Table6 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
Table(2046) & Table(2038) & Table(2030) & Table(2022) & Table(2014) & Table(2006) & Table(1998) & Table(1990) & 
Table(1982) & Table(1974) & Table(1966) & Table(1958) & Table(1950) & Table(1942) & Table(1934) & Table(1926) & 
Table(1918) & Table(1910) & Table(1902) & Table(1894) & Table(1886) & Table(1878) & Table(1870) & Table(1862) & 
Table(1854) & Table(1846) & Table(1838) & Table(1830) & Table(1822) & Table(1814) & Table(1806) & Table(1798) & 
Table(1790) & Table(1782) & Table(1774) & Table(1766) & Table(1758) & Table(1750) & Table(1742) & Table(1734) & 
Table(1726) & Table(1718) & Table(1710) & Table(1702) & Table(1694) & Table(1686) & Table(1678) & Table(1670) & 
Table(1662) & Table(1654) & Table(1646) & Table(1638) & Table(1630) & Table(1622) & Table(1614) & Table(1606) & 
Table(1598) & Table(1590) & Table(1582) & Table(1574) & Table(1566) & Table(1558) & Table(1550) & Table(1542) & 
Table(1534) & Table(1526) & Table(1518) & Table(1510) & Table(1502) & Table(1494) & Table(1486) & Table(1478) & 
Table(1470) & Table(1462) & Table(1454) & Table(1446) & Table(1438) & Table(1430) & Table(1422) & Table(1414) & 
Table(1406) & Table(1398) & Table(1390) & Table(1382) & Table(1374) & Table(1366) & Table(1358) & Table(1350) & 
Table(1342) & Table(1334) & Table(1326) & Table(1318) & Table(1310) & Table(1302) & Table(1294) & Table(1286) & 
Table(1278) & Table(1270) & Table(1262) & Table(1254) & Table(1246) & Table(1238) & Table(1230) & Table(1222) & 
Table(1214) & Table(1206) & Table(1198) & Table(1190) & Table(1182) & Table(1174) & Table(1166) & Table(1158) & 
Table(1150) & Table(1142) & Table(1134) & Table(1126) & Table(1118) & Table(1110) & Table(1102) & Table(1094) & 
Table(1086) & Table(1078) & Table(1070) & Table(1062) & Table(1054) & Table(1046) & Table(1038) & Table(1030) & 
Table(1022) & Table(1014) & Table(1006) & Table(998) & Table(990) & Table(982) & Table(974) & Table(966) & 
Table(958) & Table(950) & Table(942) & Table(934) & Table(926) & Table(918) & Table(910) & Table(902) & 
Table(894) & Table(886) & Table(878) & Table(870) & Table(862) & Table(854) & Table(846) & Table(838) & 
Table(830) & Table(822) & Table(814) & Table(806) & Table(798) & Table(790) & Table(782) & Table(774) & 
Table(766) & Table(758) & Table(750) & Table(742) & Table(734) & Table(726) & Table(718) & Table(710) & 
Table(702) & Table(694) & Table(686) & Table(678) & Table(670) & Table(662) & Table(654) & Table(646) & 
Table(638) & Table(630) & Table(622) & Table(614) & Table(606) & Table(598) & Table(590) & Table(582) & 
Table(574) & Table(566) & Table(558) & Table(550) & Table(542) & Table(534) & Table(526) & Table(518) & 
Table(510) & Table(502) & Table(494) & Table(486) & Table(478) & Table(470) & Table(462) & Table(454) & 
Table(446) & Table(438) & Table(430) & Table(422) & Table(414) & Table(406) & Table(398) & Table(390) & 
Table(382) & Table(374) & Table(366) & Table(358) & Table(350) & Table(342) & Table(334) & Table(326) & 
Table(318) & Table(310) & Table(302) & Table(294) & Table(286) & Table(278) & Table(270) & Table(262) & 
Table(254) & Table(246) & Table(238) & Table(230) & Table(222) & Table(214) & Table(206) & Table(198) & 
Table(190) & Table(182) & Table(174) & Table(166) & Table(158) & Table(150) & Table(142) & Table(134) & 
Table(126) & Table(118) & Table(110) & Table(102) & Table(94) & Table(86) & Table(78) & Table(70) & 
Table(62) & Table(54) & Table(46) & Table(38) & Table(30) & Table(22) & Table(14) & Table(6) ; 

constant Table7 : STD_LOGIC_VECTOR (255 DOWNTO 0) := 
Table(2047) & Table(2039) & Table(2031) & Table(2023) & Table(2015) & Table(2007) & Table(1999) & Table(1991) & 
Table(1983) & Table(1975) & Table(1967) & Table(1959) & Table(1951) & Table(1943) & Table(1935) & Table(1927) & 
Table(1919) & Table(1911) & Table(1903) & Table(1895) & Table(1887) & Table(1879) & Table(1871) & Table(1863) & 
Table(1855) & Table(1847) & Table(1839) & Table(1831) & Table(1823) & Table(1815) & Table(1807) & Table(1799) & 
Table(1791) & Table(1783) & Table(1775) & Table(1767) & Table(1759) & Table(1751) & Table(1743) & Table(1735) & 
Table(1727) & Table(1719) & Table(1711) & Table(1703) & Table(1695) & Table(1687) & Table(1679) & Table(1671) & 
Table(1663) & Table(1655) & Table(1647) & Table(1639) & Table(1631) & Table(1623) & Table(1615) & Table(1607) & 
Table(1599) & Table(1591) & Table(1583) & Table(1575) & Table(1567) & Table(1559) & Table(1551) & Table(1543) & 
Table(1535) & Table(1527) & Table(1519) & Table(1511) & Table(1503) & Table(1495) & Table(1487) & Table(1479) & 
Table(1471) & Table(1463) & Table(1455) & Table(1447) & Table(1439) & Table(1431) & Table(1423) & Table(1415) & 
Table(1407) & Table(1399) & Table(1391) & Table(1383) & Table(1375) & Table(1367) & Table(1359) & Table(1351) & 
Table(1343) & Table(1335) & Table(1327) & Table(1319) & Table(1311) & Table(1303) & Table(1295) & Table(1287) & 
Table(1279) & Table(1271) & Table(1263) & Table(1255) & Table(1247) & Table(1239) & Table(1231) & Table(1223) & 
Table(1215) & Table(1207) & Table(1199) & Table(1191) & Table(1183) & Table(1175) & Table(1167) & Table(1159) & 
Table(1151) & Table(1143) & Table(1135) & Table(1127) & Table(1119) & Table(1111) & Table(1103) & Table(1095) & 
Table(1087) & Table(1079) & Table(1071) & Table(1063) & Table(1055) & Table(1047) & Table(1039) & Table(1031) & 
Table(1023) & Table(1015) & Table(1007) & Table(999) & Table(991) & Table(983) & Table(975) & Table(967) & 
Table(959) & Table(951) & Table(943) & Table(935) & Table(927) & Table(919) & Table(911) & Table(903) & 
Table(895) & Table(887) & Table(879) & Table(871) & Table(863) & Table(855) & Table(847) & Table(839) & 
Table(831) & Table(823) & Table(815) & Table(807) & Table(799) & Table(791) & Table(783) & Table(775) & 
Table(767) & Table(759) & Table(751) & Table(743) & Table(735) & Table(727) & Table(719) & Table(711) & 
Table(703) & Table(695) & Table(687) & Table(679) & Table(671) & Table(663) & Table(655) & Table(647) & 
Table(639) & Table(631) & Table(623) & Table(615) & Table(607) & Table(599) & Table(591) & Table(583) & 
Table(575) & Table(567) & Table(559) & Table(551) & Table(543) & Table(535) & Table(527) & Table(519) & 
Table(511) & Table(503) & Table(495) & Table(487) & Table(479) & Table(471) & Table(463) & Table(455) & 
Table(447) & Table(439) & Table(431) & Table(423) & Table(415) & Table(407) & Table(399) & Table(391) & 
Table(383) & Table(375) & Table(367) & Table(359) & Table(351) & Table(343) & Table(335) & Table(327) & 
Table(319) & Table(311) & Table(303) & Table(295) & Table(287) & Table(279) & Table(271) & Table(263) & 
Table(255) & Table(247) & Table(239) & Table(231) & Table(223) & Table(215) & Table(207) & Table(199) & 
Table(191) & Table(183) & Table(175) & Table(167) & Table(159) & Table(151) & Table(143) & Table(135) & 
Table(127) & Table(119) & Table(111) & Table(103) & Table(95) & Table(87) & Table(79) & Table(71) & 
Table(63) & Table(55) & Table(47) & Table(39) & Table(31) & Table(23) & Table(15) & Table(7) ; 



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
			
END behavioral;

