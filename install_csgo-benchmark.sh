#!/bin/sh

projectname="csgo-benchmark"

echo&&echo
echo -e "                    \x1B[1mgithub.com/samisalreadytaken/$projectname\x1B[0m"
echo&&echo

cd ~
csgodir="${HOME%/}/.steam/steam"

checkdir()
{
	csgodir="$1/steamapps/common/Counter-Strike Global Offensive/"
	[ -d "$csgodir" ]
}

while true; do

	checkdir "$csgodir"

	if [ $? -ne 0 ]; then
		echo -e "\x1B[91mERROR:\x1B[0m Could not find game directory at:"
		echo "       $csgodir"
		echo
		echo -e "Enter your Steam directory:"
		echo -ne "\x1B[7m>:\x1B[0m "
		read -r csgodir
		echo

		if [ -z "$csgodir" ]; then
			break
		fi
	else
		echo "Found game directory:"
		echo "       $csgodir"
		echo
		cd "$csgodir"

		if [ -f "csgo/scripts/vscripts/benchmark.nut" ]; then
			echo -e "\x1B[1mUpdating...\x1B[0m"
		else
			echo -e "\x1B[1mInstalling...\x1B[0m"
		fi

		echo -e "\x1B[90m==============================================================================="

		curl -L -o "$projectname.tar.gz" "https://codeload.github.com/samisalreadytaken/$projectname/tar.gz/master"
		tar -xzf "$projectname.tar.gz" --strip=1 "$projectname-master/csgo" && rm "$projectname.tar.gz"

		if [ $? -ne 0 ]; then
			echo
			echo -e "\x1B[91mERROR\x1B[0m: Download failed."
			break
		fi
		echo -e "===============================================================================\x1B[0m"

		echo -e "\x1B[92mSuccess!\x1B[0m"
		echo

		break
	fi

done
