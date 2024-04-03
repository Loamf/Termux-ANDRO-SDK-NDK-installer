#!/data/data/com.termux/files/usr/bin/bash
PWd="${HOME}/ANDRO-SNDK"
szf="File Size of"
lb="${TMPDIR}/LB"
sdkm="${PREFIX}/bin/sdkmanager"
NTP="/sdcard/Android/data/com.tyron.code/files/templates"
A1="Android-SDK"
A2="Android-NDK"
A3="SDK-Tools"
ndk_ver="24.0.8215888"
sdk_link="https://github.com/Lzhiyong/termux-ndk/releases/download/android-sdk/android-sdk-aarch64.zip"
sdk_tool_link="https://github.com/Lzhiyong/android-sdk-tools/releases/download/33.0.3/android-sdk-tools-static-aarch64.zip"
ndk_link="https://github.com/Lzhiyong/termux-ndk/releases/download/ndk-r24/android-ndk-r24-aarch64.zip"
logo () {
var=$(echo $(( ${1} - 2)))
var2=$(seq -s─ ${var}|tr -d '[:digit:]')
var3=$(seq -s\  ${var}|tr -d '[:digit:]')
var4=$(echo $(( ${1} - 20)))
cat >> ${lb} << EOF
#!/usr/bin/bash
PUT(){ echo -en "\033[\${1};\${2}H";}
DRAW(){ echo -en "\033%";echo -en "\033(0";}
WRITE(){ echo -en "\033(B";}
HIDECURSOR(){ echo -en "\033[?25l";}
NORM(){ echo -en "\033[?12l\033[?25h";}
HIDECURSOR
clear
echo -e "\033[35;1m"
#tput setaf 5
echo "┌${var2}┐"
for ((i=1; i<=8; i++)); do
echo "│${var3}│"
done
echo "└${var2}┘"
PUT 3 0 && echo -e "\e[32m"
figlet -c -f smslant -w ${1} "${2}"
PUT 2 0
echo -e "\033[35;1m"
#tput setaf 5
for ((i=1; i<=8; i++)); do
echo "│"
done
PUT 9 $((${var4} - 20))
echo -e "\e[32m \e[1;34mInstallation setup \e[32mBy Remo773 \e[33mTBag\e[0m"
PUT 12 0
echo
NORM
EOF
bash ${lb}
rm -rf ${lb}
}
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
HIDECURSOR(){ echo -en "\033[?25l";}
NORM(){ echo -en "\033[?12l\033[?25h";}
local pid=$!
local delay=0.25
local spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )

while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do

for i in "${spinner[@]}"
do
HIDECURSOR
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
check_internet () {
	(ping -c 3 google.com) &> /dev/null 2>&1
if [[ "$?" != 0 ]];then
	echo -ne "\033[31m\r[*] \033[4;32mPlease Check Your Internet Connection... \e[0m"; 
	sleep 1
	exit 0
fi
}
d_size () {
stl4=$(curl -s -N https://apksos.com/app/com.tyron.code | grep -o "File size: [0-9\.]*M"| awk -F: '/File size:/{sub("\r", "", $2); print $2}')
(sleep 3) &> /dev/null & spin22 "CodeAssist \e[34mis" ${stl4} "${szf}"
stl3=$(curl -sIL "${sdk_link}" | awk -F: '/content-length:/{sub("\r", "", $2); print $2}' | numfmt --to iec --format "%8.1f" | tail -1)
(sleep 3) &> /dev/null & spin22 "${A1}" ${stl3} "${szf}"
stl2=$(curl -sIL "${ndk_link}" | awk -F: '/content-length:/{sub("\r", "", $2); print $2}' | numfmt --to iec --format "%8.1f" | tail -1)
(sleep 3) &> /dev/null & spin22 "${A2}" ${stl2} "${szf}"
stl=$(curl -sIL "${sdk_tool_link}" | awk -F: '/content-length:/{sub("\r", "", $2); print $2}' | numfmt --to iec --format "%8.1f" | tail -1)
(sleep 3) &> /dev/null & spin22 "${A3} \e[34mis" ${stl} "${szf}"
}
install_package () {
#echo
(apt install ncurses-utils coreutils figlet grep unzip curl openjdk-17 gradle -y) &> /dev/null & spin22 "Packages" " Done " "Installing"
}
dowload_zip () {
#yes | cp x* ${PWd}
if [[ -f ${PWd}/${A1}.zip ]] && [[ "$(cat x01 | awk '{print $1}')" == "$(sha1sum ${PWd}/${A1}.zip|awk '{print $1}')" ]]; then
	(sleep 1) &> /dev/null & spin22 "${A1}" " Done " "Downloading"
else
(wget --tries=3 --continue --quiet -O ${PWd}/${A1}.zip "${sdk_link}") & progress ${A1};
fi
if [[ -f ${PWd}/${A2}.zip ]] && [[ "$(cat x02 | awk '{print $1}')" == "$(sha1sum ${PWd}/${A2}.zip|awk '{print $1}')" ]]; then
	(sleep 1) &> /dev/null & spin22 "${A2}" " Done " "Downloading"
else
(wget --tries=3 --continue --quiet -O ${PWd}/${A2}.zip "${ndk_link}") & progress ${A2};
fi
if [[ -f ${PWd}/${A3}.zip ]] && [[ "$(cat x03 | awk '{print $1}')" == "$(sha1sum ${PWd}/${A3}.zip|awk '{print $1}')" ]]; then
	(sleep 1) &> /dev/null & spin22 "${A3}" " Done " "Downloading"
else
(wget --tries=3 --continue --quiet -O ${PWd}/${A3}.zip "${sdk_tool_link}") & progress ${A3}
fi
sleep 2
(sha1sum -c ${PWd}/{x01,x02,x03}) &> /dev/null
if [[ ! $? == 0  ]]; then
	echo -e "\e[31mdownload failed..\e[0m"
	echo -e "Plz run command : \e[4;32mbash android-sdk.sh --install-sdk\e[0m"
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
if [[ "$1" == "install" ]]; then
        check_internet
	logo $(tput cols) "ANDROSDK";
	dowload_zip
	sdk_setup
fi
if [[ "$1" == "size" ]]; then
	check_internet
	logo $(tput cols) "ANDROSDK";
        d_size
	fi
fi 
if [[ "$1" == "help" ]]; then
        usage
fi
if [[ "$1" == "" ]]; then
	usage
fi
