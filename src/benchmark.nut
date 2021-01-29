//-----------------------------------------------------------------------
//------------------- Copyright (c) samisalreadytaken -------------------
//                       github.com/samisalreadytaken
//- v1.4.4 --------------------------------------------------------------
IncludeScript("vs_library");

if ( !("_BM_"in getroottable()) )
	::_BM_ <- { _VER_ = "1.4.4" };;

local _ = function(){

V <- ::Vector;

try( DoIncludeScript("benchmark_res",this) )
catch(e)
{
	return Msg("ERROR: Could not find the benchmark resource file.\n");
}

SendToConsole("alias benchmark\"script _BM_.Start()\"");
SendToConsole("alias bm_start\"script _BM_.Start(1)\"");
SendToConsole("alias bm_stop\"script _BM_.Stop()\"");
SendToConsole("alias bm_rec\"script _BM_.Record()\"");
SendToConsole("alias bm_timer\"script _BM_.ToggleCounter()\"");
SendToConsole("alias bm_setup\"script _BM_.PrintSetupCmd()\"");
SendToConsole("alias bm_list\"script _BM_.ListSetupData()\"");
SendToConsole("alias bm_clear\"script _BM_.ClearSetupData()\"");
SendToConsole("alias bm_remove\"script _BM_.RemoveSetupData()\"");

SendToConsole("alias bm_mdl\"script _BM_.PrintMDL()\"");
SendToConsole("alias bm_mdl1\"script _BM_.PrintMDL(1)\"");
SendToConsole("alias bm_flash\"script _BM_.PrintFlash()\"");
SendToConsole("alias bm_flash1\"script _BM_.PrintFlash(1)\"");
SendToConsole("alias bm_he\"script _BM_.PrintHE()\"");
SendToConsole("alias bm_he1\"script _BM_.PrintHE(1)\"");
SendToConsole("alias bm_molo\"script _BM_.PrintMolo()\"");
SendToConsole("alias bm_molo1\"script _BM_.PrintMolo(1)\"");
SendToConsole("alias bm_smoke\"script _BM_.PrintSmoke()\"");
SendToConsole("alias bm_smoke1\"script _BM_.PrintSmoke(1)\"");
SendToConsole("alias bm_expl\"script _BM_.PrintExpl()\"");
SendToConsole("alias bm_expl1\"script _BM_.PrintExpl(1)\"");

//--------------------------------------------------------------

SendToConsole("clear;script _BM_.PostSpawn()");

VS.GetLocalPlayer();

local FRAMETIME = 0.015625;
local szMapName = split(GetMapName(),"/").top();

SND_BUTTON <- "UIPanorama.XP.Ticker";

if ( !("m_bStarted" in this) )
{
	Fmt <- ::format;
	Msg <- ::print;
	m_bStartedPending <- false;
	m_bStarted <- false;
	m_flTimeStart <- 0.0;
	m_iDev <- 0;
	m_iRecLast <- 0;
	m_nCounterCount <- 0;
	m_flTargetLength <- 0.0;
	m_list_models <- [];
	m_list_nades <- [];
};

if ( !("m_hThink" in this) )
{
	m_hStrip <- VS.CreateEntity( "game_player_equip",{ spawnflags = 1<<1 }, 1 ).weakref();
	m_hHudHint <- VS.CreateEntity( "env_hudhint", null, 1 ).weakref();
	m_hCam <- VS.CreateEntity( "point_viewcontrol",{ spawnflags = 1<<3 } ).weakref();
	m_hThink <- VS.Timer( 1, FRAMETIME, null, null, 1, 1 ).weakref();
	m_hCounter <- null;

	local sc = m_hThink.GetScriptScope();
	sc.cam <- m_hCam.weakref();
	sc.pos <- null;
	sc.ang <- null;
	sc.lim <- null;
	sc.idx <- 0;
};

//--------------------------------------------------------------

function __LoadData():( FRAMETIME, szMapName )
{
	local c1 = "l_" + szMapName;

	if ( !(c1 in this) )
	{
		delete __LoadData;
		return;
	};

	local data = this[c1];

	if ( !("pos" in data) || !("ang" in data) || !data.pos.len() || !data.ang.len() )
	{
		delete __LoadData;
		return;
	};

	// this can be done here because this script will only play the benchmark data,
	// which can only be loaded by reloading the whole script
	local sc = m_hThink.GetScriptScope();
	sc.pos = data.pos;
	sc.ang = data.ang;
	sc.lim = data.pos.len();

	m_flTargetLength = data.pos.len() * FRAMETIME;

	delete __LoadData;
}

//--------------------------------------------------------------

function PlaySound(s)
{
	return ::HPlayer.EmitSound(s);
}

function Hint(s)
{
	return ::VS.ShowHudHint( m_hHudHint, ::HPlayer, s );
}

function ToggleCounter( i = null )
{
	if ( !m_hCounter )
	{
		if ( i != null && !i )
			return;

		m_hCounter = ::VS.Timer( 1, 1, function()
		{
			Hint( ++m_nCounterCount );
			PlaySound("UIPanorama.container_countdown");
		}, this, 0, 1 ).weakref();
	};

	// toggle
	if ( i == null )
		i = !m_hCounter.GetTeam();

	m_hCounter.SetTeam( i.tointeger() );
	m_nCounterCount = 0;

	::EntFireByHandle( m_hCounter, i ? "Enable" : "Disable" );
}

VS.OnTimer( m_hThink, function()
{
	cam.SetOrigin(pos[idx]);
	local a = ang[idx];
	cam.SetAngles(a.x,a.y,a.z);
	if ( lim <=++ idx )
		::_BM_.Stop(1);
},null,true );

function Record()
{
	Msg("Recording is not available in the benchmark script.\n");
	Msg("Use the keyframes script to create smooth paths:\n");
	Msg("                github.com/samisalreadytaken/keyframes\n");
}

function CheckData():(szMapName)
{
	local c1 = "l_" + szMapName;

	if ( !(c1 in this) )
		return Msg(Fmt( "[!] Could not find map data for '%s'\n", szMapName ));

	local data = this[c1];

	if ( !("pos" in data) || !("ang" in data) )
		return Msg("[!] Invalid map data!\n");

	if ( !data.pos.len() || !data.ang.len() )
		return Msg("[!] Corrupted map data!\n");

	return data;
}

function Start( bPathOnly = 0 ):( szMapName )
{
	if ( m_bStartedPending )
		return Msg("Benchmark has not started yet.\n");

	if ( m_bStarted )
		return Msg("Benchmark is already running!\nTo stop it: bm_stop\n");

	if ( !CheckData() )
		return;

	//--------------------------------------------------------------

	::EntFireByHandle( m_hThink, "Disable" );

	m_hThink.GetScriptScope().idx = 0;

	//--------------------------------------------------------------

	::EntFireByHandle( m_hStrip, "Use", "", 0, ::HPlayer );
	::HPlayer.SetHealth(1337);

	if ( !bPathOnly )
		if ( "Setup_" + szMapName in this )
			this["Setup_" + szMapName]();;

	m_bStartedPending = true;
	m_iDev = ::GetDeveloperLevel();

	//--------------------------------------------------------------

	local _1 = [null,"+quickinv"],_0 = [null,"-quickinv"];
	::VS.EventQueue.AddEvent( SendToConsole, 0.0, _1 );::VS.EventQueue.AddEvent( SendToConsole, 0.1, _0 );
	::VS.EventQueue.AddEvent( SendToConsole, 0.2, _1 );::VS.EventQueue.AddEvent( SendToConsole, 0.3, _0 );
	::VS.EventQueue.AddEvent( SendToConsole, 0.4, _1 );::VS.EventQueue.AddEvent( SendToConsole, 0.5, _0 );

	local param_snd = [this, "Alert.WarmupTimeoutBeep"];

	::VS.EventQueue.AddEvent( Hint, 0.5, [this, "Starting in 3..."] );
	::VS.EventQueue.AddEvent( PlaySound, 0.5, param_snd );

	::VS.EventQueue.AddEvent( Hint, 1.5, [this, "Starting in 2..."] );
	::VS.EventQueue.AddEvent( PlaySound, 1.5, param_snd );

	::VS.EventQueue.AddEvent( Hint, 2.5, [this, "Starting in 1..."] );
	::VS.EventQueue.AddEvent( PlaySound, 2.5, param_snd );

	::VS.HideHudHint( m_hHudHint, ::HPlayer, 3.5 );

	::VS.EventQueue.AddEvent( PlaySound, 0.5, [this, "Weapon_AWP.BoltForward"] );
	PlaySound("Weapon_AWP.BoltBack");

	//--------------------------------------------------------------

	::SendToConsole("r_cleardecals;clear;echo;echo;echo;echo\"   Starting in 3 seconds...\";echo;echo\"   Keep the console closed for higher FPS\";echo;echo;echo;developer 0;toggleconsole;fadeout");

	::VS.EventQueue.AddEvent( _Start, 3.5, this );
}

function _Start()
{
	m_bStartedPending = false;
	m_bStarted = true;
	m_flTimeStart = ::Time();
	::EntFireByHandle( m_hCam, "Enable", "", 0, ::HPlayer );
	::EntFireByHandle( m_hThink, "Enable" );
	::SendToConsole("fadein;fps_max 0;bench_start;bench_end;host_framerate 0;host_timescale 1;clear;echo;echo;echo;echo\"   Benchmark has started\";echo;echo\"   Keep the console closed for higher FPS\";echo;echo");
}

// 0 : force stopped
// 1 : path completed
function Stop( i = 0 ):( szMapName )
{
	if ( !m_bStarted )
		return Msg("Benchmark is not running.\n");

	if ( m_bStartedPending )
		return Msg("Benchmark is about to start.\n");

	m_bStarted = false;

	::VS.EventQueue.CancelEventsByInput( Dispatch );
	::SendToConsole( "ent_cancelpendingentfires" );

	::EntFireByHandle( m_hCam, "Disable", "", 0, ::HPlayer );
	::EntFireByHandle( m_hThink, "Disable" );
	ToggleCounter(0);

	local szOutTime;
	local flDiff = ::Time() - m_flTimeStart;

	if ( flDiff == m_flTargetLength )
	{
		szOutTime = flDiff + " seconds";
	}
	else
	{
		szOutTime = Fmt( "%g seconds (expected: %g)", flDiff, m_flTargetLength );
	};

	::SendToConsole("host_framerate 0;host_timescale 1");
	::SendToConsole(Fmt( "clear;echo;echo;echo;echo\"----------------------------\";echo;echo %s;echo;echo\"Map: %s\";echo\"Tickrate: %g\";echo;toggleconsole;echo\"Time: %s\";echo;bench_end;echo;echo\"----------------------------\";echo;echo",
		( i ? "Benchmark finished." :
		"Stopped benchmark.;toggleconsole" ),
		szMapName,
		VS.GetTickrate(),
		szOutTime ));
	::SendToConsole("developer " + m_iDev);

	if (i) PlaySound("Buttons.snd9");
	PlaySound("UIPanorama.gameover_show");

	::Chat(Fmt( "%s● %sBenchmark results are printed in the console.", txt.orange, txt.grey ));
}

function PostSpawn()
{
	__LoadData();

	if ( ::HPlayer.GetTeam() != 2 && ::HPlayer.GetTeam() != 3 )
		::HPlayer.SetTeam(2);

	PlaySound("Player.DrownStart");

	for ( local i = 18; i--; ) ::Chat(" ");
	::Chat(::txt.blue+" --------------------------------");
	::Chat("");
	::Chat(Fmt( "%s[Benchmark Script v%s]", txt.lightgreen, _VER_ ));
	::Chat(Fmt( "%s● %sServer tickrate: %s%g", txt.orange, txt.grey, txt.yellow, VS.GetTickrate() ));
	::Chat("");
	::Chat(::txt.blue+" --------------------------------");

	// print after Steamworks Msg
	if ( ::GetDeveloperLevel() > 0 )
	{
		::VS.EventQueue.AddEvent( SendToConsole, 0.75, [this, "clear;script _BM_.WelcomeMsg()"] );
	}
	else
	{
		WelcomeMsg();
	};

	delete PostSpawn;
}

function WelcomeMsg():(szMapName)
{
	Msg("\n\n\n");
	Msg(Fmt( "   [v%s]     github.com/samisalreadytaken/csgo-benchmark\n", _VER_ ));
	Msg("\n");
	Msg("Console commands:\n");
	Msg("\n");
	Msg("benchmark  : Run benchmark\n");
	Msg("           :\n");
	Msg("bm_start   : Run benchmark (path only)\n");
	Msg("bm_stop    : Force stop ongoing benchmark\n");
	Msg("           :\n");
	Msg("bm_setup   : Print setup related commands\n");
	Msg("\n");
	Msg("----------\n");
	Msg("\n");
	Msg("Commands to display FPS:\n");
	Msg("\n");
	Msg("cl_showfps 1\n");
	Msg("net_graph 1\n");
	Msg("\n----------\n");
	Msg("\n");
	Msg("[i] The benchmark sets your fps_max to 0\n");
	Msg("\n");
	Msg(Fmt( "[i] Map: %s\n", szMapName ));
	Msg(Fmt( "[i] Server tickrate: %g\n\n\n", VS.GetTickrate() ));

	if ( !VS.IsInteger( 128.0 / VS.GetTickrate() ) )
	{
		Msg(Fmt( "[!] Invalid tickrate (%g)! Only 128 and 64 tickrates are supported.\n", VS.GetTickrate() ));
		Chat(Fmt( "%s[!] %sInvalid tickrate ( %s%g%s )! Only 128 and 64 tickrates are supported.",
			txt.red, txt.white, txt.yellow, VS.GetTickrate(), txt.white ));
	};

	if ( !CheckData() )
		Msg("\n\n");

	delete WelcomeMsg;
}

// bm_setup
function PrintSetupCmd()
{
	Msg("\n");
	Msg(Fmt( "   [v%s]     github.com/samisalreadytaken/csgo-benchmark\n", _VER_ ));
	Msg("\n");
	Msg("bm_timer   : Toggle counter\n");
	Msg("           :\n");
	Msg("bm_list    : Print saved setup data\n");
	Msg("bm_clear   : Clear saved setup data\n");
	Msg("bm_remove  : Remove the last added setup data\n");
	Msg("           :\n");
	Msg("bm_mdl     : Print and add to list SpawnMDL\n");
	Msg("bm_flash   : Print and add to list SpawnFlash\n");
	Msg("bm_he      : Print and add to list SpawnHE\n");
	Msg("bm_molo    : Print and add to list SpawnMolotov\n");
	Msg("bm_smoke   : Print and add to list SpawnSmoke\n");
	Msg("bm_expl    : Print and add to list SpawnExplosion\n");
	Msg("           :\n");
	Msg("bm_mdl1    : Spawn a playermodel\n");
	Msg("bm_flash1  : Spawn a flashbang\n");
	Msg("bm_he1     : Spawn an HE\n");
	Msg("bm_molo1   : Spawn a molotov\n");
	Msg("bm_smoke1  : Spawn smoke\n");
	Msg("bm_expl1   : Spawn a C4 explosion\n");
	Msg("\n");
	Msg("For creating paths, use the keyframes script.\n");
	Msg("                github.com/samisalreadytaken/keyframes\n\n\n");
}

// bm_clear
function ClearSetupData()
{
	PlaySound(SND_BUTTON);
	m_list_models.clear();
	m_list_nades.clear();
	Msg("Cleared saved setup data.\n");
}

// bm_remove
function RemoveSetupData()
{
	PlaySound(SND_BUTTON);
	if ( !m_iRecLast )
	{
		if ( !m_list_models.len() )
			return Msg("No saved data found.\n");
		m_list_models.pop();
		Msg("Removed the last added setup data. (model)\n");
	}
	else
	{
		if ( !m_list_nades.len() )
			return Msg("No saved data found.\n");
		m_list_nades.pop();
		Msg("Removed the last added setup data. (nade)\n");
	};
}

// bm_list
function ListSetupData():(szMapName)
{
	PlaySound(SND_BUTTON);

	if ( !m_list_nades.len() && !m_list_models.len() )
		return Msg("No saved data found.\n");

	Msg( "//------------------------\n// Copy the lines below:\n\n\n" );
	Msg(Fmt( "function Setup_%s()\n{\n", szMapName ));
	foreach( k in m_list_models ) Msg(Fmt( "\t%s\n", k ));
	Msg("");
	foreach( k in m_list_nades ) Msg(Fmt( "\t%s\n", k ));
	Msg( "}\n\n" );
	Msg( "\n//------------------------\n" );
}

// bm_mdl
function PrintMDL( i = 0 )
{
	local vecOrigin = HPlayer.GetOrigin();

	PlaySound(SND_BUTTON);
	local out = Fmt( "SpawnMDL( %s,%g, MDL.ST6k )", VecToString( vecOrigin ), HPlayer.GetAngles().y );

	if (i)
	{
		vecOrigin.z += 72;
		HPlayer.SetOrigin(vecOrigin);
		return compilestring(out)();
	};

	m_list_models.append(out);
	Msg(Fmt( "\n%s\n", out ));
	m_iRecLast = 0;
}


local kSmoke     = 0;
local kFlash     = 1;
local kHE        = 2;
local kMolotov   = 3;
local kExplosion = 4;


// bm_flash
function PrintFlash( i = 0 ) : ( kFlash )
{
	PlaySound(SND_BUTTON);

	local vecOrigin = HPlayer.GetOrigin();
	vecOrigin.z += 4.0;

	if (i)
	{
		if ( !HPlayer.IsNoclipping() )
		{
			local t = Vector();
			VS.VectorCopy( vecOrigin, t );
			t.z += 32;
			HPlayer.SetOrigin(t);
		};
		return Dispatch( vecOrigin, kFlash );
	};

	local out = Fmt( "SpawnFlash( %s, 0.0 )", VecToString( vecOrigin ) );

	m_list_nades.append(out);
	Msg(Fmt( "\n%s\n", out ));
	m_iRecLast = 1;
}

// bm_he
function PrintHE( i = 0 ) : ( kHE )
{
	PlaySound(SND_BUTTON);

	local vecOrigin = HPlayer.GetOrigin();
	vecOrigin.z += 4.0;

	if (i)
	{
		if ( !HPlayer.IsNoclipping() )
		{
			local t = Vector();
			VS.VectorCopy( vecOrigin, t );
			t.z += 32;
			HPlayer.SetOrigin(t);
		};
		return Dispatch( vecOrigin, kHE );
	};

	local out = Fmt( "SpawnHE( %s, 0.0 )", VecToString( vecOrigin ) );

	m_list_nades.append(out);
	Msg(Fmt( "\n%s\n", out ));
	m_iRecLast = 1;
}

// bm_molo
function PrintMolo( i = 0 ) : ( kMolotov )
{
	PlaySound(SND_BUTTON);

	local vecOrigin = HPlayer.GetOrigin();
	vecOrigin.z += 4.0;

	if (i)
	{
		if ( !HPlayer.IsNoclipping() )
		{
			local t = Vector();
			VS.VectorCopy( vecOrigin, t );
			t.z += 32;
			HPlayer.SetOrigin(t);
		};
		return Dispatch( vecOrigin, kMolotov );
	};

	local out = Fmt( "SpawnMolotov( %s, 0.0 )", VecToString( vecOrigin ) );

	m_list_nades.append(out);
	Msg(Fmt( "\n%s\n", out ));
	m_iRecLast = 1;
}

// bm_smoke
function PrintSmoke( i = 0 ) : ( kSmoke )
{
	local vecOrigin = HPlayer.GetOrigin();

	PlaySound(SND_BUTTON);

	if (i)
		return Dispatch( vecOrigin, kSmoke );

	local out = Fmt( "SpawnSmoke( %s, 0.0 )", VecToString( vecOrigin ) );

	m_list_nades.append(out);
	Msg(Fmt( "\n%s\n", out ));
	m_iRecLast = 1;
}

// bm_expl
function PrintExpl( i = 0 ) : ( kExplosion )
{
	local vecOrigin = HPlayer.GetOrigin();

	PlaySound(SND_BUTTON);

	if (i)
		return Dispatch( vecOrigin, kExplosion );

	local out = Fmt( "SpawnExplosion( %s, 0.0 )", VecToString( vecOrigin ) );

	m_list_nades.append(out);
	Msg(Fmt( "\n%s\n", out ));
	m_iRecLast = 1;
}

local Entities = ::Entities;
local EntFireByHandle = ::EntFireByHandle;
local DispatchParticleEffect = ::DispatchParticleEffect;
local SendToConsole = ::SendToConsole;
local VecToString = ::VecToString;

function __Spawn( v, t ) : (Entities, EntFireByHandle)
{
	for ( local e; e = Entities.FindByClassname( e, t + "_projectile" ); )
	{
		e.SetOrigin( v );
		EntFireByHandle( e, "InitializeSpawnFromWorld" );
	}
}

function Dispatch( v, i ) :
( kSmoke, kFlash, kHE, kMolotov, kExplosion, SendToConsole, DispatchParticleEffect, VecToString )
{
	switch ( i )
	{
	case kSmoke:
		DispatchParticleEffect( "explosion_smokegrenade", v, V(1,0,0) );
		m_hHudHint.SetOrigin( v );
		m_hHudHint.EmitSound( "BaseSmokeEffect.Sound" );
		return;

	case kFlash:
		SendToConsole(Fmt( "ent_create flashbang_projectile\nscript _BM_.__Spawn(%s,\"flashbang\")", VecToString(v) ));
		return;

	case kHE:
		SendToConsole(Fmt( "ent_create hegrenade_projectile\nscript _BM_.__Spawn(%s,\"hegrenade\")", VecToString(v) ));
		return;

	case kMolotov:
		SendToConsole(Fmt( "ent_create molotov_projectile\nscript _BM_.__Spawn(%s,\"molotov\")", VecToString(v) ));
		return;

	case kExplosion:
		DispatchParticleEffect( "explosion_c4_500", v, V() );
		m_hHudHint.SetOrigin( v );
		m_hHudHint.EmitSound( "c4.explode" );
		return;
	}
}

function SpawnFlash( v, d ) : ( kFlash )
{
	VS.EventQueue.AddEvent( Dispatch, d, [this,v,kFlash], null, HPlayer );
}

function SpawnHE( v, d ) : ( kHE )
{
	VS.EventQueue.AddEvent( Dispatch, d, [this,v,kHE], null, HPlayer );
}

function SpawnMolotov( v, d ) : ( kMolotov )
{
	VS.EventQueue.AddEvent( Dispatch, d, [this,v,kMolotov], null, HPlayer );
}

function SpawnSmoke( v, d ) : ( kSmoke )
{
	VS.EventQueue.AddEvent( Dispatch, d, [this,v,kSmoke], null, HPlayer );
}

function SpawnExplosion( v, d ) : ( kExplosion )
{
	VS.EventQueue.AddEvent( Dispatch, d, [this,v,kExplosion], null, HPlayer );
}

function SpawnMDL( v, a, m, p = 0 )
{
	if ( !Entities.FindByClassnameNearest( "prop_dynamic_override", v, 1 ) )
	{
		PrecacheModel( m );
		local h = CreateProp( "prop_dynamic_override", v, m, 0 );
		h.SetAngles( 0, a, 0 );
		h.__KeyValueFromInt( "solid", 2 );
		h.__KeyValueFromInt( "disablebonefollowers", 1 );
		h.__KeyValueFromInt( "holdanimation", 1 );
		h.__KeyValueFromString( "defaultanim", "grenade_deploy_03" );

		switch ( p )
		{
			case POSE.ROM:
				EntFireByHandle( h, "SetAnimation", "rom" );
				break;
			case POSE.A:
				h.SetAngles( 0, a + 90, 90 );
				EntFireByHandle( h, "SetAnimation", "additive_posebreaker" );
				break;
			case POSE.PISTOL:
				EntFireByHandle( h, "SetAnimation", "pistol_deploy_02" );
				break;
			case POSE.RIFLE:
				EntFireByHandle( h, "SetAnimation", "rifle_deploy" );
				break;
			default:
				EntFireByHandle( h, "SetAnimation", "grenade_deploy_03" );
				EntFireByHandle( h, "SetPlaybackRate", "0" );
		};
	};
}

}.call(_BM_);
