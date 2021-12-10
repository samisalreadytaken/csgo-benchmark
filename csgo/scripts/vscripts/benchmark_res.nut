//-----------------------------------------------------------------------
//             github.com/samisalreadytaken/csgo-benchmark
//-----------------------------------------------------------------------
/*
enum MDL
{
	FBIa, FBIb, FBIc, FBId, FBIe, FBIf, FBIg, FBIh,
	GIGNa, GIGNb, GIGNc, GIGNd,
	GSG9a, GSG9b, GSG9c, GSG9d,
	IDFb, IDFc, IDFd, IDFe, IDFf,
	SASa, SASb, SASc, SASd, SASe, SASf,
	ST6a, ST6b, ST6c, ST6d, ST6e, ST6g, ST6i, ST6k, ST6m,
	SWATa, SWATb, SWATc, SWATd,
	ANARa, ANARb, ANARc, ANARd,
	BALKa, BALKb, BALKc, BALKd, BALKe, BALKf, BALKg, BALKh, BALKi, BALKj,
	LEETa, LEETb, LEETc, LEETd, LEETe, LEETf, LEETg, LEETh, LEETi,
	PHXa, PHXb, PHXc, PHXd, PHXf, PHXg, PHXh,
	PRTa, PRTb, PRTc, PRTd,
	PROa, PROb, PROc, PROd,
	SEPa, SEPb, SEPc, SEPd,
	H_CT, H_T
}

enum POSE
{
	DEFAULT,
	ROM,
	A,
	PISTOL,
	RIFLE
}
*/

//---------------
//
// While testing the timings, execute `benchmark;bm_timer` in the console to start the timer.
//
// Use the commands to get setup lines
//    bm_mdl
//    bm_flash
//    bm_he
//    bm_molo
//    bm_smoke
//    bm_expl
//
// Use bm_list to print every saved line
//
// Restarting the round (mp_restartgame 1) will remove spawned models
//
//---------------
function Setup_de_dust2()
{
	player.SetHealth(1337)
	player.SetOrigin( Vector(-812.37, -685.58, 129.03) )

	SpawnMDL( Vector(168.642,2373.5,-119.983),286.441, MDL.IDFb, POSE.PISTOL )
	SpawnMDL( Vector(402.468,2357.7,-120.229),238.777, MDL.IDFc, POSE.PISTOL )
	SpawnMDL( Vector(-351.116,2317.97,-112.421),264.529, MDL.ST6i, POSE.RIFLE )
	SpawnMDL( Vector(-1635.46,1636.61,2.3138),63.8306, MDL.IDFc, POSE.RIFLE )
	SpawnMDL( Vector(-1195.08,2070.03,13.1172),119.273, MDL.IDFf )
	SpawnMDL( Vector(-2077.38,2948.96,34.094),275.444, MDL.IDFe )
	SpawnMDL( Vector(-2182.97,2098.03,4.18304),356.276, MDL.ST6k )
	SpawnMDL( Vector(-1710.68,1202.97,31.1073),137.867, MDL.BALKj, POSE.PISTOL )
	SpawnMDL( Vector(-1106.99,1120.07,-34.516),179.302, MDL.LEETc, POSE.PISTOL )
	SpawnMDL( Vector(-502.835,-1008.04,128.878),87.4292, MDL.BALKh, POSE.PISTOL )
	SpawnMDL( Vector(-621.997,621.692,8.18201),10.871, MDL.LEETb, POSE.PISTOL )
	SpawnMDL( Vector(-276.369,1334.28,-122.848),160.032, MDL.LEETi, POSE.RIFLE )
	SpawnMDL( Vector(1004.97,2379.98,27.4667),257.849, MDL.IDFe )
	SpawnMDL( Vector(1004.97,2379.98,91.4667),6.849, MDL.IDFf, POSE.PISTOL )
	SpawnMDL( Vector(1787.97,1812.01,1.8617),175.913, MDL.IDFb, POSE.PISTOL )
	SpawnMDL( Vector(1294.97,561.526,-69.8376),88.374, MDL.ST6g )
	SpawnMDL( Vector(541.78,383.019,9.15092),340.988, MDL.IDFe, POSE.PISTOL )
	SpawnMDL( Vector(682.147,-228.247,0.188534),95.2679, MDL.BALKi, POSE.RIFLE )
	SpawnMDL( Vector(17.9202,-903.189,-3.58168),66.0553, MDL.BALKf, POSE.ROM )
	SpawnMDL( Vector(-179.923,499.939,-0.619185),108.545, MDL.LEETd, POSE.RIFLE )
	SpawnMDL( Vector(438.334,1743.31,4.10457),238.876, MDL.ST6m )
	SpawnMDL( Vector(1199.89,2584.11,96.6777),234.448, MDL.LEETa )
	SpawnMDL( Vector(1566.59,1451.91,1.03125),120.196, MDL.LEETf, POSE.RIFLE )
	SpawnMDL( Vector(1454.79,1314.72,-11.5588),64.6765, MDL.LEETg, POSE.RIFLE )
	SpawnMDL( Vector(-833.463,-907.052,120.389),89.7638, MDL.LEETa )
	SpawnMDL( Vector(-1468.13,-223.567,128.573),109.44, MDL.LEETb )

	SpawnSmoke( Vector(-413.54,1978.95,-126.646), 5.0 )
	SpawnSmoke( Vector(-1319,2206,2.35542), 7.0 )
	SpawnFlash( Vector(-479.02,1811.62,210.029), 7.7 )
	SpawnFlash( Vector(-479.02,1811.62,210.029), 8.1 )
	SpawnMolotov( Vector(-1980.83,1673.5,31.7268), 8.0 )
	SpawnHE( Vector(-1795.77,2601.52,32.588), 8.5 )
	SpawnFlash( Vector(-1991.25,1483.67,31.2241), 11.5 )
	SpawnHE( Vector(-1314.23,1091.73,35.1617), 12.5 )
	SpawnFlash( Vector(-1598.3,230.135,94.8647), 14.5 )
	SpawnFlash( Vector(-1986.13,2080,111.87), 15.9 )
	SpawnMolotov( Vector(-1429.05,1117.13,74.1049), 15.3 )
	SpawnHE( Vector(-1429.05,1117.13,74.1049), 17.7 )
	SpawnFlash( Vector(-1429.05,1117.13,74.1049), 20.6 )
	SpawnSmoke( Vector(-443.232,1622.24,-125.284), 23.0 )
	SpawnSmoke( Vector(-332.3,1452.94,-27.9688), 23.3 )
	SpawnFlash( Vector(-426.141,1343.47,184.729), 25.6 )
	SpawnFlash( Vector(-496.146,1853.22,90.318), 26.0 )
	SpawnFlash( Vector(-451.023,1662.04,-95.8446), 27.2 )
	SpawnMolotov( Vector(388.008,2065.53,95.881), 27.0 )
	SpawnSmoke( Vector(982.986,2079.39,-6.65838), 28.4 )
	SpawnFlash( Vector(426.786,2111.67,416.845), 30.1 )
	SpawnHE( Vector(1108.6,2498.11,96.0313), 33.0 )
	SpawnMolotov( Vector(1776.12,2054.35,1.94888), 29.0 )
	SpawnFlash( Vector(1122.4,2366.67,423.457), 37.7 )
	SpawnSmoke( Vector(1191.27,2155.33,2.09766), 34.9 )
	SpawnSmoke( Vector(1226.43,1129.47,-0.222878), 35.1 )
	SpawnMolotov( Vector(621.483,720.776,0.702869), 36.4 )
	SpawnFlash( Vector(1047.44,464.837,349.514), 39.6 )
	SpawnFlash( Vector(1127.71,433.61,596.71), 40.4 )
	SpawnExplosion( Vector(-1436.84,2565.86,5.18142), 42.6 )
}

function Setup_de_cache()
{
	SpawnMDL( Vector(-398.338,277.517,1757.53),323.251, MDL.GIGNa, POSE.PISTOL ) // connector window
	SpawnMDL( Vector(-913.031,1065.37,1687.03),28.3447, MDL.ST6m ) // truck
	SpawnMDL( Vector(85.4497,2235.7,1688.23),270.945, MDL.FBIh ) // nbk
	SpawnMDL( Vector(-220.153,1849.13,1687.03),348.772, MDL.SASf ) // a site
	SpawnMDL( Vector(187.636,1346.81,1688.85),45.8624, MDL.GIGNd ) // fork
	SpawnMDL( Vector(746.324,1107.07,1702.03),115.104, MDL.PHXc ) // a main
	SpawnMDL( Vector(524.873,1286.15,1719.82),85.5341, MDL.PHXg, POSE.PISTOL ) // a main box
	SpawnMDL( Vector(1740.16,308.969,1613.02),179.879, MDL.LEETi ) // garage T entry
	SpawnMDL( Vector(1124.09,-656.471,1614.03),230.614, MDL.LEETf ) // b main
	SpawnMDL( Vector(559,-596.969,1614.03),179.39, MDL.FBIg, POSE.PISTOL ) // b main box
	SpawnMDL( Vector(234.969,-255.011,1614.03),300.624, MDL.GIGNb, POSE.PISTOL ) // checkers
	SpawnMDL( Vector(-378.47,-1155.29,1613.03),47.0654, MDL.GIGNc, POSE.RIFLE ) // headshot
	SpawnMDL( Vector(551.926,-232.524,1749.03),119.663, MDL.GIGNa, POSE.PISTOL ) // vents
	SpawnMDL( Vector(-111.827,-470.012,1820.4),321.812, MDL.ST6k, POSE.RIFLE ) // lamp

	SpawnSmoke( Vector(-325.108,-14.3659,1663.82), 6.5 ) // connector
	SpawnFlash( Vector(-293.225,1046.83,1910.02), 9.9 ) // highway
	SpawnSmoke( Vector(42.6098,1422.19,1687.03), 9.4 ) // fork
	SpawnMolotov( Vector(-163.926,2201.09,1712.35), 9.5 ) // quad
	SpawnFlash( Vector(483.451,1729.46,1739.75), 11.4 ) // a main
	SpawnSmoke( Vector(52.7543,1976.8,1687.03), 10.0 ) // nbk
	SpawnMolotov( Vector(401.721,1763.58,1688.03), 10.2 ) // a main
	SpawnHE( Vector(888.024,1453.13,1702.03), 11.0 ) // a main
	SpawnFlash( Vector(537.29,1763.65,1806.15), 16.0 ) // a main
	EntFire("a door", "open", "", 14.2) // squeaky
	EntFire("a door", "close", "", 14.6) // squeaky
	EntFire("a door", "open", "", 15.0) // squeaky
	SpawnFlash( Vector(592.852,501.665,1853.25), 19.5 ) // boost
	SpawnMolotov( Vector(911.336,610.594,1821.3), 19.0 ) // boost
	SpawnMolotov( Vector(747.48,-1141.38,1614.03), 29.0 ) // b main sunroom
	SpawnHE( Vector(202.954,-300.298,1614.03), 31.0 ) // checkers

	// sunroom windows
	EntFireByHandle( EntityAt( "func_breakable", Vector(231.5,-1370,1902) ), "break", "", 31.5 )
	EntFireByHandle( EntityAt( "func_breakable", Vector(231.5,-1249,1902) ), "break", "", 31.9 )
	EntFireByHandle( EntityAt( "func_breakable", Vector(231.5,-1309,1902) ), "break", "", 32.3 )
	EntFireByHandle( EntityAt( "func_breakable", Vector(231.5,-1430,1902) ), "break", "", 33.1 )
	// vents
	EntFireByHandle( EntityAt( "prop_dynamic", Vector(544.33,-168.28,1748.87) ), "break", "", 32.1 )
	EntFireByHandle( EntityAt( "prop_dynamic", Vector(373.59,-275.61,1748.83) ), "break", "", 34.1 )

	SpawnFlash( Vector(309.056,-1311.62,1893.4), 33.5 ) // sunroom
	SpawnFlash( Vector(309.056,-1311.62,1893.4), 34.7 ) // sunroom
	SpawnMolotov( Vector(-213.427,-1282.92,1659.03), 34.0 ) // b site
	SpawnSmoke( Vector(-545.601,-965.548,1613.63), 34.1 ) // ct
	SpawnHE( Vector(68.1981,-1416.21,1659.03), 35.0 ) // b site triple
	SpawnSmoke( Vector(305.664,173.053,1614.03), 46.0 ) // mid
	SpawnSmoke( Vector(299.938,379.479,1613.03), 46.5 ) // mid
	SpawnMolotov( Vector(893.321,262.666,1613.03), 47.0 ) // garage
	SpawnFlash( Vector(-180.797,471.651,1877.37), 49.6 ) // highway
}
