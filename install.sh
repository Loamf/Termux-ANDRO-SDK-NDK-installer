#!/data/data/com.termux/files/usr/bin/bash
PWd="${PWD}"
szf="File Size of"
lb="${TMPDIR}/LB"
sdkm="${PREFIX}/bin/sdkmanager"
A1="Android-SDK"
A2="Android-NDK"
A3="SDK-Tools"
ndk_ver="24.0.8215888"
sdk_link="https://github.com/Lzhiyong/termux-ndk/releases/download/android-sdk/android-sdk-aarch64.zip"
sdk_tool_link="https://github.com/Lzhiyong/android-sdk-tools/releases/download/33.0.3/android-sdk-tools-static-aarch64.zip"
ndk_link="https://github.com/Lzhiyong/termux-ndk/releases/download/ndk-r24/android-ndk-r24-aarch64.zip"

progress() {
local pid=$!
local delay=0.25
while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do

        for i in "$(if test -e ${PWd}/${1}.zip; then cd ${PWd}/;du -h ${1}.zip | awk '{print $1}';else echo -e "\e[94m  \e[0m";fi)"
do
        tput civis
        echo -ne "\033[34m\r[*] Downloading \e[1;33m${1}\e[34m	: \e[33m[\033[36m\033[32m$i\033[33m]\033[0m   ";
        sleep $delay
        printf "\b\b\b\b\b\b\b\b";
done
done
printf "   \b\b\b\b"
tput cnorm
printf "\e[32m [\e[32m Done \e[32m]\e[0m";
echo "";
}
spin22 () {
NORM(){ echo -en "\033[?12l\033[?25h";}
local pid=$!
local delay=0.25
local spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )

while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do

for i in "${spinner[@]}"
do
        echo -ne "\033[34m\r[*] "${3}" \e[1;33m${1}\e[34m 	: \e[33m[\033[32m$i\033[33m]\033[0m   ";
        sleep $delay
        printf "\b\b\b\b\b\b\b\b";
done
done
printf "   \b\b\b\b\b\b"
NORM
printf "\e[32m [${2}]\e[0m";
echo "";
}
usage () {
printf "
Usage: bash android-sdk.sh [option]

	\033[4moption\033[0m			\033[4mDescription\033[0m

	download		For download Android SDK and 
				NDK
	install			For install Android SDK and 
				NDK
	size			For watch Download file
				size.
	help			For see instructions

hint: bash install.sh download && bash install.sh install
"
}
d_size () {
stl3=$(curl -sIL "${sdk_link}" | awk -F: '/content-length:/{sub("\r", "", $2); print $2}' | numfmt --to iec --format "%8.1f" | tail -1)
(sleep 3) &> /dev/null & spin22 "${A1}" ${stl3} "${szf}"
stl2=$(curl -sIL "${ndk_link}" | awk -F: '/content-length:/{sub("\r", "", $2); print $2}' | numfmt --to iec --format "%8.1f" | tail -1)
(sleep 3) &> /dev/null & spin22 "${A2}" ${stl2} "${szf}"
stl=$(curl -sIL "${sdk_tool_link}" | awk -F: '/content-length:/{sub("\r", "", $2); print $2}' | numfmt --to iec --format "%8.1f" | tail -1)
(sleep 3) &> /dev/null & spin22 "${A3} \e[34mis" ${stl} "${szf}"
}
install_package () {
#echo
(apt install wget ncurses-utils coreutils figlet grep unzip curl openjdk-17 gradle -y) &> /dev/null & spin22 "Packages" " Done " "Installing"
}
dowload_zip () {
#yes | cp x* ${PWd}
if [[ -f ${PWd}/${A1}.zip ]] && [[ $(stat --format=%s "${PWd}/${A1}.zip") == ${size_A1} ]]; then
	(sleep 1) &> /dev/null & spin22 "${A1}" " Done " "Downloading"
else
(wget --tries=3 --continue --quiet -O ${PWd}/${A1}.zip "${sdk_link}") & progress ${A1};
fi
if [[ -f ${PWd}/${A2}.zip ]] && [[ $(stat --format=%s "${PWd}/${A2}.zip") == ${size_A2} ]]; then
	(sleep 1) &> /dev/null & spin22 "${A2}" " Done " "Downloading"
else
(wget --tries=3 --continue --quiet -O ${PWd}/${A2}.zip "${ndk_link}") & progress ${A2};
fi
if [[ -f ${PWd}/${A3}.zip ]] && [[ $(stat --format=%s "${PWd}/${A3}.zip") == ${size_A3} ]]; then
	(sleep 1) &> /dev/null & spin22 "${A3}" " Done " "Downloading"
else
(wget --tries=3 --continue --quiet -O ${PWd}/${A3}.zip "${sdk_tool_link}") & progress ${A3}
fi
sleep 2
if [[ $(stat --format=%s "${PWd}/${A1}.zip") == ${size_A1} ]] && [[ $(stat --format=%s "${PWd}/${A2}.zip") == ${size_A2} ]] && [[ $(stat --format=%s "${PWd}/${A3}.zip") == ${size_A3} ]]; then
	echo -e "\e[31mSuccessful download...\e[0m"
else
	echo -e "Download Failed. You need to run command : \e[4;32mbash android-sdk.sh dwonload\e[0m"
	exit 0
fi
}
sdk_setup () {
#echo
(yes | unzip ${PWd}/${A1}.zip -d ${PREFIX}/share
mkdir -p ${PREFIX}/share/android-sdk/ndk
rm -rf ${sdkm}
cat >> ${sdkm} << EOF
#!/data/data/com.termux/files/usr/bin/bash
/data/data/com.termux/files/usr/share/android-sdk/tools/bin/sdkmanager \
     --sdk_root=/data/data/com.termux/files/usr/share/android-sdk "$@"
EOF
chmod 700 ${sdkm}
) &> /dev/null & spin22 "${A1}" " Done " "Unzipping"
(yes | unzip ${PWd}/${A2}.zip -d ${TMPDIR}/
mv ${TMPDIR}/android-ndk* ${PREFIX}/share/android-sdk/ndk/${ndk_ver}) &> /dev/null & spin22 "${A2}" " Done " "Unzipping"
(yes | unzip ${PWd}/${A3}.zip -d ${TMPDIR}/
yes | cp ${TMPDIR}/aarch64*/* -r ${PREFIX}/share/android-sdk/
) &> /dev/null & spin22 "${A3}" " Done " "Unzipping"
}

if [[ "$1" == "download" ]]; then
	dowload_zip
fi
if [[ "$1" == "install" ]]; then
	sdk_setup
fi
if [[ "$1" == "size" ]]; then
        d_size
fi 
if [[ "$1" == "help" ]]; then
        usage
fi
if [[ "$1" == "" ]]; then
	usage
fi
