# CS:GO Benchmark Script
[![ver][]](https://github.com/samisalreadytaken/csgo-benchmark)

Run benchmark on any map.

By default, map data available for:  
\- `de_dust2` <sup>(44 seconds)</sup>  
\- `de_cache` <sup>(50 seconds)</sup>  


[ver]: https://img.shields.io/badge/csgo--benchmark-v1.4.7-informational

![](../assets/image.jpg)

## How it works
This is a script for Source Engine's scripting system to playback saved camera paths and grenade setups consistently in listen servers. This can be used to test or compare the general performance of the game in the tested maps.

This script cannot access any benchmark details due to the limitations of the system.

## Installation
Manually download the repository ([`Code > Download ZIP`](https://github.com/samisalreadytaken/csgo-benchmark/archive/master.zip)), then extract and merge the `/csgo/` folder with your `/steamapps/common/Counter-Strike Global Offensive/csgo/` folder.

Alternatively run the installation script of your choice:

- [Batch](https://raw.githubusercontent.com/samisalreadytaken/csgo-benchmark/master/install.bat) <sub>NOTE: `curl` and `tar` are included in Windows 10 since 17063.</sub>
```
curl -s https://raw.githubusercontent.com/samisalreadytaken/csgo-benchmark/master/install.bat > install_csgo-benchmark.bat && cmd /C install_csgo-benchmark.bat && del install_csgo-benchmark.bat
```

- [Shell](https://raw.githubusercontent.com/samisalreadytaken/csgo-benchmark/master/install.sh)
```
sh <(curl -s https://raw.githubusercontent.com/samisalreadytaken/csgo-benchmark/master/install.sh)
```

This does not overwrite any game files, and it does not interfere with the game in any way. It can only be used on your own local server.

## Usage
Use the console commands to load and control the script. It needs to be loaded it each time the map is changed.

Command             | Description
------------------- | -------------------
`exec benchmark`    | Load the script
`benchmark`         | Run benchmark
`bm_start`          | Run benchmark (path only)
`bm_stop`           | Force stop ongoing benchmark

Setup commands used for creating map data:

Command             | Description
------------------- | -------------------
`bm_setup`          | Print setup commands
---                 | ---
`bm_timer`          | Toggle counter
`bm_list`           | Print saved setup data
`bm_clear`          | Clear saved setup data
`bm_remove`         | Remove the last added setup data
---                 | ---
`bm_mdl`            | Print and add to list SpawnMDL
`bm_flash`          | Print and add to list SpawnFlash
`bm_he`             | Print and add to list SpawnHE
`bm_molo`           | Print and add to list SpawnMolotov
`bm_smoke`          | Print and add to list SpawnSmoke
`bm_expl`           | Print and add to list SpawnExplosion
---                 | ---
`bm_mdl1`           | Spawn a playermodel
`bm_flash1`         | Spawn a flashbang
`bm_he1`            | Spawn an HE
`bm_molo1`          | Spawn a molotov
`bm_smoke1`         | Spawn smoke
`bm_expl1`          | Spawn a C4 explosion

## Creating new map data

1. Record and export your path using the [keyframes](https://github.com/samisalreadytaken/keyframes) script.
2. Rename the exported file extension to `bm_<mapname>.nut`.
3. Optionally spawn player models or grenades:
   1. Use the `bm_` commands to print and save grenade spawn functions.
   2. Use `bm_list` to print all saved points to copy easily.
   3. Create the Setup function in the file `bm_<mapname>.nut`.
   4. To find out when to spawn the grenades, use `benchmark;bm_timer` command to start the timer along with the playback.
   5. See existing setup functions for examples.
4. Reload the script to load your changes. (`exec benchmark`)

Done! Starting the benchmark will run the new path.

## Licence
You are free to use, modify and share this script under the terms of the GNU GPLv2.0 licence. In short, you must keep the copyright notice, and make your modifications public under the same licence if you distribute it.

This script uses [vs_library](https://github.com/samisalreadytaken/vs_library).

[![](http://hits.dwyl.com/samisalreadytaken/csgo-benchmark.svg)](http://hits.dwyl.com/samisalreadytaken/csgo-benchmark)
