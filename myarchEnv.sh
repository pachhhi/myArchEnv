#!/bin/bash

#ENV
GREEN="\033[32m"
RED="\033[31m"
BLUE="\033[34m"
RESET="\033[0m"

#Verify user permissions 
USER_HOME=$(eval echo "~$SUDO_USER")

if [[ $EUID -ne 0 ]]; then
	echo -e "${GREEN}λ > This script must be run as root${RESET}"
	exit 1
fi

#Verify distro
source /etc/os-release
distro="$ID"

if [[ $distro != "arch" && $distro != "manjaro" ]]; then
	echo -e "${RED}λ > Your distro need be Arch or Arch-based  ${RESET}"
	exit 1
fi


#Verify connection and Update system
echo -e "${BLUE} > Verify connection.. ${RESET}"
systemctl enable NetworkManager
ping -c 1 8.8.8.8 &> /dev/null
if [ $? -eq 0 ]; then 
	echo -e "${GREEN} You are connected to internet ${RESET}"; 
else 
	echo -e "${RED} You are offline... :( ${RESET}" exit 1;
fi

#sudo pacman -Syu --noconfirm

#Make config dir
echo -e "${GREEN}λ > Creating config dir in ${USER_HOME} ${RESET}"
#mkdir -p "$USER_HOME/myarchEnvconfig"

#Installing drivers for GPU
#pacman -S --noconfirm x86-video-amdgpu mesa vulkan-radeon libva-mesa-driver

#Download packages for BSPWM
function configBSPWM() {
	
#	pacman -S --noconfirm xorg-server xorg-xinit xorg-xrandr xorg-xsetroot bspwm sxhkd picom rofi kitty zsh feh lightdm lightdm-gtk-greeter
#	mkdir -p "$USER_HOME/myarchEnvconfig/.config/{bspwm,sxhkd,picom,kitty,rofi}"	
	echo -e "${BLUE} > Making config for bspwm ${RESET}"
}
configBSPWM

#Download packages for HYPRLAND
#pacman -S --noconfirm hyprland waybar wofi xdg-desktop-portal-hyprland wayland wayland-protocols xwayland sddm
#systemctl enable sddm

#Download packages for KDE
#pacman -S --noconfirm plasma kde-applications

#Functions

function installAUR() {
	echo -e "${BLUE}λ > Installing AUR in ${USER_HOME} ${RESET}"
	#sudo pacman -S --needed base-devel git
	#git clone https://aur.archlinux.org/yay.git $USER_HOME/myarchEnvconfig
	#cd $USER_HOME/myarchEnvconfig/yay/
	#makepkg -si
	echo -e "${GREEN} > Installed! ${RESET}"

}

function initInstall() {
	echo -e "${GREEN} >Do you want make a custom install? (default/custom)${RESET}"
	read choice

	case $choice in
		default)
			echo -e "${GREEN} > Preparing install..${RESET}"
			
			configBSPWM
			wait

			installAUR
			wait


			;;
		custom)
			echo -e "${GREEN} > Preparing custom install.. ${RESET}"
			
			echo -e "${GREEN} > Do you want install BSPWM? ${RESET}"
			read bspwm
			if [ $bspwm == y ]; then
				echo -e "${GREEN} > Installing BSPWM.. ${RESET}"
				#configBSPWM
			fi
			;;
		*)
			echo -e "${RED} > Choice (default) or (custom) ${RESET}"
			;;
	esac
}

initInstall
