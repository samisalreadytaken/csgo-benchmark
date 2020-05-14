# CS:GO Benchmark Script
[![ver][]](https://github.com/samisalreadytaken/csgo-benchmark)

Run benchmark on any map.

By default, map data available for:  
\- `de_dust2` <sup>(44 seconds)</sup>  
\- `de_cache` <sup>(50 seconds)</sup>  
\- `dz_sirocco` <sup>(81.25 seconds)</sup>  

[ver]: https://img.shields.io/badge/csgo--benchmark-v1.4.1-informational

## Installation
Merge the `/csgo/` folder with your `/steamapps/common/Counter-Strike Global Offensive/csgo/` folder.

This only adds 4 files to your /csgo/ folder. It does not overwrite any game files, and it does not interfere with the game in any way. It is VAC safe, and you can only use this script on your own server.

### Downloading
**Method 1.**
Manually download the repo by clicking [**HERE**](https://github.com/samisalreadytaken/csgo-benchmark/archive/master.zip). Then extract the folder.

**Method 2.**
On Windows 10 17063 or later, run the [`install_csgo-benchmark.bat`](https://raw.githubusercontent.com/samisalreadytaken/csgo-benchmark/master/install_csgo-benchmark.bat) file to automatically download the script into your game files. It can also be used to update the script.

**Method 3.**
In bash, after changing the directory below to your Steam game library directory, use the following commands to install the script into your game files.
```
cd "C:/Program Files/Steam/steamapps/common/Counter-Strike Global Offensive/" && 
curl https://codeload.github.com/samisalreadytaken/csgo-benchmark/tar.gz/master | tar -xz --strip=1 csgo-benchmark-master/csgo
```

## Usage
Use the console commands to load and control the script. You need to load it each time you change the map.

Command             | Description
------------------- | -------------------
`exec benchmark`    | Load the script
`benchmark`         | Run benchmark
`bm_stop`           | Force stop the ongoing benchmark
---                 | ---
`bm_setup`          | Print setup related commands
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
[![viddemo][]](https://www.youtube.com/watch?v=i_WziPbjNjY&t=1m7s)

1. Record and export your path using the [keyframes](https://github.com/samisalreadytaken/keyframes) script.
2. Copy and paste the data in `/csgo/scripts/vscripts/benchmark_res.nut`.
3. If there is existing data for the map you've recorded for, delete the old line.
4. Spawn playermodels and grenades for your liking:
   1. You can get the data by using commands to print the Spawn functions; then use `bm_list` to print all the data you've saved to copy easily.
   2. Paste the Setup function in `benchmark_res.nut`.
   3. To find out when to spawn the grenades, use `benchmark;bm_timer` to start the timer along with the benchmark.
   4. See `benchmark_res.nut` for examples and further details.
5. Reload the script to load your changes. (`exec benchmark`)

Done! You can run your new path by running the benchmark.

## License
You are free to use, modify and share this script under the terms of the GNU GPLv2.0 license. In short, you must keep the copyright notice, and make your modifications public under the same license if you distribute it.

This script uses [vs_library](https://github.com/samisalreadytaken/vs_library).

[![](http://hits.dwyl.com/samisalreadytaken/csgo-benchmark.svg)](http://hits.dwyl.com/samisalreadytaken/csgo-benchmark)

[viddemo]: https://img.shields.io/badge/Video_demonstration-red?logo=youtube
