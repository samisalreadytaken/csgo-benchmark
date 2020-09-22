//-----------------------------------------------------------------------
//------------------- Copyright (c) samisalreadytaken -------------------
//                       github.com/samisalreadytaken
//- v1.4.3 --------------------------------------------------------------
IncludeScript("vs_library");

if(!("_BM_"in getroottable()))
	::_BM_ <- { _VER_ = "1.4.3" };;

local __init__ = function(){

V <- ::Vector;

try(IncludeScript("benchmark_res",this))
catch(e)
{
	return Msg("ERROR: Could not find the benchmark resource file.\n");
}

// aliases
SendToConsole("alias benchmark\"script _BM_.Start()\";alias bm_start\"script _BM_.Start(1)\";alias bm_stop\"script _BM_.Stop()\";alias bm_rec\"script _BM_.Record()\";alias bm_timer\"script _BM_.ToggleCounter()\";alias bm_setup\"script _BM_.PrintSetupCmd()\";alias bm_list\"script _BM_.ListSetupData()\";alias bm_clear\"script _BM_.ClearSetupData()\";alias bm_remove\"script _BM_.RemoveSetupData()\"");

SendToConsole("alias bm_mdl\"script _BM_.PrintMDL()\";alias bm_mdl1\"script _BM_.PrintMDL(1)\";alias bm_flash\"script _BM_.PrintFlash()\";alias bm_flash1\"script _BM_.PrintFlash(1)\";alias bm_he\"script _BM_.PrintHE()\";alias bm_he1\"script _BM_.PrintHE(1)\";alias bm_molo\"script _BM_.PrintMolo()\";alias bm_molo1\"script _BM_.PrintMolo(1)\";alias bm_smoke\"script _BM_.PrintSmoke()\";alias bm_smoke1\"script _BM_.PrintSmoke(1)\";alias bm_expl\"script _BM_.PrintExpl()\";alias bm_expl1\"script _BM_.PrintExpl(1)\"\"");

//--------------------------------------------------------------

SendToConsole("clear;script _BM_.PostSpawn()");

VS.GetLocalPlayer();

if( !("bStarted" in this) )
{
	FTIME <- 0.015625;
	Msg <- printl;
	sMapName <- split(GetMapName(),"/").top();
	bStartedPending <- false;
	bStarted <- false;
	flTimeStart <- 0.0;
	iDev <- 0;
	iRecLast <- 0;
	nCounterCount <- 0;
	list_models <- [];
	list_nades <- [];
};;

if( !("hThink" in this) )
{
	hStrip <- VS.CreateEntity("game_player_equip",{ spawnflags = 1<<1 },1).weakref();
	hHudHint <- VS.CreateEntity("env_hudhint",null,1).weakref();
	hCam <- VS.CreateEntity("point_viewcontrol",{ spawnflags = 1<<3 }).weakref();
	hThink <- VS.Timer(1,FTIME,null,null,1,1).weakref();
	hCounter <- VS.Timer(1,1,null,null,0,1).weakref();

	// init vars
	local sc = hThink.GetScriptScope();
	sc.cam <- hCam.weakref();
	sc.pos <- null;
	sc.ang <- null;
	sc.lim <- null;
	sc.idx <- 0;
};;

//--------------------------------------------------------------

function __LoadData()
{
	local c1 = "l_" + sMapName;

	if( !(c1 in this) )
		return __LoadData_clf();

	local data = this[c1];

	if( !("pos" in data) || !("ang" in data) || !data.pos.len() || !data.ang.len() )
		return __LoadData_clf();

	__LoadData_load(data);
}

function __LoadData_load(data)
{
	// this can be done here because this script will only play the benchmark data,
	// which can only be loaded by reloading the whole script
	local sc = hThink.GetScriptScope();
	sc.pos = data.pos;
	sc.ang = data.ang;
	sc.lim = data.pos.len();
}

// clear functions
function __LoadData_clf()
{
	delete __LoadData;
	delete __LoadData_clf;
	delete __LoadData_load;
}

//--------------------------------------------------------------

function PlaySound(s)
{
	return::HPlayer.EmitSound(s);
}

function Hint(s)
{
	return::VS.ShowHudHint(hHudHint,::HPlayer,s);
}

function ToggleCounter(i = null)
{
	// toggle
	if( i == null )
		i = !hCounter.GetTeam();

	hCounter.SetTeam(i.tointeger());
	nCounterCount = 0;

	::EntFireByHandle(hCounter, i ? "enable" : "disable");
}

VS.OnTimer(hCounter, function()
{
	Hint(++nCounterCount);
	PlaySound("UIPanorama.container_countdown");
},this);

VS.OnTimer(hThink,function()
{
	cam.SetOrigin(pos[idx]);
	local a = ang[idx];
	cam.SetAngles(a.x,a.y,a.z);
	if( ++idx >= lim )
		::_BM_.Stop(1);
},null,true);

function Record()
{
	Msg("Recording is not available in the benchmark script.");
	Msg("Use the keyframes script to create smooth paths:");
	Msg("                github.com/samisalreadytaken/keyframes");
}

function CheckData()
{
	local c1 = "l_" + sMapName;

	if( !(c1 in this) )
		return Msg("[!] Could not find map data for '" + sMapName + "'");

	local data = this[c1];

	if( !("pos" in data) || !("ang" in data) )
		return Msg("[!] Invalid map data!");

	if( !data.pos.len() || !data.ang.len() )
		return Msg("[!] Corrupted map data!");

	return data;
}

function Start(bPathOnly = 0)
{
	if( bStartedPending )
		return Msg("Benchmark has not started yet.");

	if( bStarted )
		return Msg("Benchmark is already running!\nTo stop it: bm_stop");

	if( !CheckData() )
		return;

	// -------------------------------------------------------

	::EntFireByHandle(hThink, "disable");

	hThink.GetScriptScope().idx = 0;

	//--------------------------------------------------------------

	::EntFireByHandle(hStrip, "use", "", 0, ::HPlayer);
	::HPlayer.SetHealth(1337);

	if( !bPathOnly )
		if( "Setup_" + sMapName in this )
			this["Setup_" + sMapName]();;

	bStartedPending = true;
	iDev = ::GetDeveloperLevel();

	//--------------------------------------------------------------

	local _1 = "SendToConsole(\"+quickinv\")",_0 = "SendToConsole(\"-quickinv\")";
	::delay( _1, 0.0 );::delay( _0, 0.1 );
	::delay( _1, 0.2 );::delay( _0, 0.3 );
	::delay( _1, 0.4 );::delay( _0, 0.5 );

	::delay("::_BM_.Hint(\"Starting in 3...\");::_BM_.PlaySound(\"Alert.WarmupTimeoutBeep\")", 0.5);
	::delay("::_BM_.Hint(\"Starting in 2...\");::_BM_.PlaySound(\"Alert.WarmupTimeoutBeep\")", 1.5);
	::delay("::_BM_.Hint(\"Starting in 1...\");::_BM_.PlaySound(\"Alert.WarmupTimeoutBeep\")", 2.5);
	::VS.HideHudHint(hHudHint,::HPlayer,3.5);

	::delay("::_BM_.PlaySound(\"Weapon_AWP.BoltForward\")", 0.5);
	PlaySound("Weapon_AWP.BoltBack");

	//--------------------------------------------------------------

	::SendToConsole("r_cleardecals;clear;echo;echo;echo;echo\"   Starting in 3 seconds...\";echo;echo\"   Keep the console closed for higher FPS\";echo;echo;echo;developer 0;toggleconsole;fadeout");

	::delay("::_BM_._Start()", 3.5);
}

function _Start()
{
	bStartedPending = false;
	bStarted = true;
	flTimeStart = ::Time();
	::EntFireByHandle(hCam, "enable", "", 0, ::HPlayer);
	::EntFireByHandle(hThink, "enable");
	::SendToConsole("fadein;fps_max 0;bench_start;bench_end;host_framerate 0;host_timescale 1;clear;echo;echo;echo;echo\"   Benchmark has started\";echo;echo\"   Keep the console closed for higher FPS\";echo;echo");
}

// i == 0 : force stopped
// i == 1 : path completed
function Stop(i = 0)
{
	if( !bStarted )
		return Msg("Benchmark is not running.");

	if( bStartedPending )
		return Msg("Benchmark is about to start.");

	bStarted = false;

	::EntFireByHandle(hCam, "disable", "", 0, ::HPlayer);
	::EntFireByHandle(hThink, "disable");
	ToggleCounter(0);

	::SendToConsole("host_framerate 0;host_timescale 1;clear;echo;echo;echo;echo\"----------------------------\";echo;echo " +

		( i ? "Benchmark finished." :
		"Stopped benchmark.;mp_restartgame 1;toggleconsole" )

	+";echo;echo\"Map: " + sMapName + "\";echo\"Tickrate: "+ VS.GetTickrate() + "\";echo;toggleconsole" + ";echo\"Time: " + (::Time()-flTimeStart) + " seconds\";echo;bench_end;echo;echo\"----------------------------\";echo;echo;developer " + iDev);

	if(i) PlaySound("Buttons.snd9");
	PlaySound("UIPanorama.gameover_show");

	::Chat(txt.orange + "● "+txt.grey + "Results are printed in the console.");
	Hint("Results are printed in the console.");
}

function PostSpawn()
{
	__LoadData();

	if( ::HPlayer.GetTeam() != 2 && ::HPlayer.GetTeam() != 3 )
		::HPlayer.SetTeam(2);

	PlaySound("Player.DrownStart");

	::ClearChat();
	::ClearChat();
	::Chat(::txt.blue+" --------------------------------");
	::Chat("");
	::Chat(::txt.lightgreen + "[Benchmark Script v"+_VER_+"]");
	::Chat(::txt.orange + "● " + ::txt.grey +"Server tickrate: " + ::txt.yellow + VS.GetTickrate());
	::Chat("");
	::Chat(::txt.blue+" --------------------------------");

	// print after Steamworks Msg
	if( ::GetDeveloperLevel() > 0 )
		::delay("SendToConsole(\"clear;script _BM_.WelcomeMsg()\")", 0.75);
	else WelcomeMsg();

	delete PostSpawn;
}

function WelcomeMsg()
{
//Msg(@"
//
//                github.com/samisalreadytaken/csgo-benchmark
//
//Console commands:
//
//benchmark  : Run benchmark
//           :
//bm_start   : Run benchmark (path only)
//bm_stop    : Force stop ongoing benchmark
//           :
//bm_setup   : Print setup related commands
//
//----------
//
//Commands to display FPS:
//
//cl_showfps 1
//net_graph 1
//
//----------
//
//[i] The benchmark sets your fps_max to 0
//")

	Msg("\n\n\n   [v"+_VER_+"]     github.com/samisalreadytaken/csgo-benchmark\n\nConsole commands:\n\nbenchmark  : Run benchmark\n           :\nbm_start   : Run benchmark (path only)\nbm_stop    : Force stop ongoing benchmark\n           :\nbm_setup   : Print setup related commands\n\n----------\n\nCommands to display FPS:\n\ncl_showfps 1\nnet_graph 1\n\n----------\n\n[i] The benchmark sets your fps_max to 0\n");

	Msg("[i] Map: " + sMapName);
	Msg("[i] Server tickrate: " + VS.GetTickrate() + "\n\n");

	if( !VS.IsInteger(128.0/VS.GetTickrate()) )
	{
		Msg(format("[!] Invalid tickrate (%.1f)! Only 128 and 64 tickrates are supported.",VS.GetTickrate()));
		Chat(format("%s[!] %sInvalid tickrate ( %s%.1f%s )! Only 128 and 64 tickrates are supported.", txt.red, txt.white, txt.yellow, VS.GetTickrate(), txt.white));
	};

	if( !CheckData() )
		Msg("\n");

	delete WelcomeMsg;
}

// bm_setup
function PrintSetupCmd()
{
//Msg(@"
//
//   [v"+_VER_+"]     github.com/samisalreadytaken/csgo-benchmark
//
//bm_timer   : Toggle counter
//           :
//bm_list    : Print saved setup data
//bm_clear   : Clear saved setup data
//bm_remove  : Remove the last added setup data
//           :
//bm_mdl     : Print and add to list SpawnMDL
//bm_flash   : Print and add to list SpawnFlash
//bm_he      : Print and add to list SpawnHE
//bm_molo    : Print and add to list SpawnMolotov
//bm_smoke   : Print and add to list SpawnSmoke
//bm_expl    : Print and add to list SpawnExplosion
//           :
//bm_mdl1    : Spawn a playermodel
//bm_flash1  : Spawn a flashbang
//bm_he1     : Spawn an HE
//bm_molo1   : Spawn a molotov
//bm_smoke1  : Spawn smoke
//bm_expl1   : Spawn a C4 explosion
//
//For creating paths, use the keyframes script.
//                github.com/samisalreadytaken/keyframes
//
//")

	Msg("\n   [v"+_VER_+"]     github.com/samisalreadytaken/csgo-benchmark\n\nbm_timer   : Toggle counter\n           :\nbm_list    : Print saved setup data\nbm_clear   : Clear saved setup data\nbm_remove  : Remove the last added setup data\n           :\nbm_mdl     : Print and add to list SpawnMDL\nbm_flash   : Print and add to list SpawnFlash\nbm_he      : Print and add to list SpawnHE\nbm_molo    : Print and add to list SpawnMolotov\nbm_smoke   : Print and add to list SpawnSmoke\nbm_expl    : Print and add to list SpawnExplosion\n           :\nbm_mdl1    : Spawn a playermodel\nbm_flash1  : Spawn a flashbang\nbm_he1     : Spawn an HE\nbm_molo1   : Spawn a molotov\nbm_smoke1  : Spawn smoke\nbm_expl1   : Spawn a C4 explosion\n\nFor creating paths, use the keyframes script.\n                github.com/samisalreadytaken/keyframes\n\n");
}

// bm_clear
function ClearSetupData()
{
	PlaySound("UIPanorama.XP.Ticker");
	list_models.clear();
	list_nades.clear();
	Msg("Cleared saved setup data.");
}

// bm_remove
function RemoveSetupData()
{
	PlaySound("UIPanorama.XP.Ticker");
	if( !iRecLast )
	{
		if( !list_models.len() )
			return Msg("No saved data found.");
		list_models.pop();
		Msg("Removed the last added setup data. (model)");
	}
	else
	{
		if( !list_nades.len() )
			return Msg("No saved data found.");
		list_nades.pop();
		Msg("Removed the last added setup data. (nade)");
	};
}

// bm_list
function ListSetupData()
{
	PlaySound("UIPanorama.XP.Ticker");

	if( !list_nades.len() && !list_models.len() )
		return Msg("No saved data found.");

	Msg("//------------------------\n// Copy the lines below:\n\n");
	Msg("function Setup_"+sMapName+"()\n{");
	foreach(k in list_models)Msg("\t"+k);
	Msg("");
	foreach(k in list_nades)Msg("\t"+k);
	Msg("}\n");
	Msg("\n//------------------------");
}

// bm_mdl
function PrintMDL( i = 0 )
{
	PlaySound("UIPanorama.XP.Ticker");
	local a = "SpawnMDL( "+VecToString(HPlayer.GetOrigin())+","+HPlayer.GetAngles().y+", MDL.ST6k )";

	if(i)
	{
		local p = HPlayer.GetOrigin();
		p.z += 72;
		HPlayer.SetOrigin(p);
		return compilestring(a)();
	};

	list_models.append(a);
	Msg("\n"+a);
	iRecLast = 0;
}

// bm_flash
function PrintFlash( i = 0 )
{
	PlaySound("UIPanorama.XP.Ticker");
	local a = "SpawnFlash( "+VecToString(HPlayer.GetOrigin())+", 0.0 )";

	if(i)
	{
		local p = HPlayer.GetOrigin();
		if( !HPlayer.IsNoclipping() ) p.z += 32;
		HPlayer.SetOrigin(p);
		return compilestring(a)();
	};

	list_nades.append(a);
	Msg("\n"+a);
	iRecLast = 1;
}

// bm_he
function PrintHE( i = 0 )
{
	PlaySound("UIPanorama.XP.Ticker");
	local a = "SpawnHE( "+VecToString(HPlayer.GetOrigin())+", 0.0 )";

	if(i)
	{
		local p = HPlayer.GetOrigin();
		if( !HPlayer.IsNoclipping() ) p.z += 32;
		HPlayer.SetOrigin(p);
		return compilestring(a)();
	};

	list_nades.append(a);
	Msg("\n"+a);
	iRecLast = 1;
}

// bm_molo
function PrintMolo( i = 0 )
{
	PlaySound("UIPanorama.XP.Ticker");
	local a = "SpawnMolotov( "+VecToString(HPlayer.GetOrigin())+", 0.0 )";

	if(i)
	{
		local p = HPlayer.GetOrigin();
		if( !HPlayer.IsNoclipping() ) p.z += 32;
		HPlayer.SetOrigin(p);
		return compilestring(a)();
	};

	list_nades.append(a);
	Msg("\n"+a);
	iRecLast = 1;
}

// bm_smoke
function PrintSmoke( i = 0 )
{
	PlaySound("UIPanorama.XP.Ticker");
	local a = "SpawnSmoke( "+VecToString(HPlayer.GetOrigin())+", 0.0 )";

	if(i) return compilestring(a)();

	list_nades.append(a);
	Msg("\n"+a);
	iRecLast = 1;
}

// bm_expl
function PrintExpl( i = 0 )
{
	PlaySound("UIPanorama.XP.Ticker");
	local a = "SpawnExplosion( "+VecToString(HPlayer.GetOrigin())+", 0.0 )";

	if(i) return compilestring(a)();

	list_nades.append(a);
	Msg("\n"+a);
	iRecLast = 1;
}

function __Spawn( v, t )
{
	for( local e; e = Entities.FindByClassname(e,t+"_projectile"); )
	{
		e.SetOrigin(v);
		EntFireByHandle(e,"initializespawnfromworld");
	}
}

function SpawnFlash( v, d )
{
	delay("SendToConsole(\"ent_create flashbang_projectile;script _BM_.__Spawn("+VecToString(v)+",\\\"flashbang\\\")\")", d);
}

function SpawnHE( v, d )
{
	delay("SendToConsole(\"ent_create hegrenade_projectile;script _BM_.__Spawn("+VecToString(v)+",\\\"hegrenade\\\")\")", d);
}

function SpawnMolotov( v, d )
{
	delay("SendToConsole(\"ent_create molotov_projectile;script _BM_.__Spawn("+VecToString(v)+",\\\"molotov\\\")\")", d);
}

function SpawnSmoke( v, d )
{
	delay("local v=" + VecToString(v) + ";DispatchParticleEffect(\"explosion_smokegrenade\",v,Vector(1,0,0));_BM_.hHudHint.SetOrigin(v);_BM_.hHudHint.EmitSound(\"BaseSmokeEffect.Sound\")", d);
}

function SpawnExplosion( v, d )
{
	delay("local v=" + VecToString(v) + ";DispatchParticleEffect(\"explosion_c4_500\",v,Vector());_BM_.hHudHint.SetOrigin(v);_BM_.hHudHint.EmitSound(\"c4.explode\")", d);
}

function SpawnMDL( v, a, m, p = 0 )
{
	if( !Entities.FindByClassnameNearest( "prop_dynamic_override", v, 1 ) )
	{
		PrecacheModel( m );
		local h = CreateProp( "prop_dynamic_override", v, m, 0 );
		h.SetAngles( 0, a, 0 );
		h.__KeyValueFromInt( "solid", 2 );
		h.__KeyValueFromInt( "disablebonefollowers", 1 );
		h.__KeyValueFromInt( "holdanimation", 1 );
		h.__KeyValueFromString( "defaultanim", "grenade_deploy_03" );

		switch( p )
		{
			case POSE.ROM:
				EntFireByHandle( h, "setanimation", "rom" );
				break;
			case POSE.A:
				h.SetAngles( 0, a + 90, 90 );
				EntFireByHandle( h, "setanimation", "additive_posebreaker" );
				break;
			case POSE.PISTOL:
				EntFireByHandle( h, "setanimation", "pistol_deploy_02" );
				break;
			case POSE.RIFLE:
				EntFireByHandle( h, "setanimation", "rifle_deploy" );
				break;
			default:
				EntFireByHandle( h, "setanimation", "grenade_deploy_03" );
				EntFireByHandle( h, "setplaybackrate", "0" );
		};
	};
}

}.call(_BM_);
