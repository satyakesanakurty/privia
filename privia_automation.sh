#!/bin/sh

#function that disables usb
function usb_disable ()
{
	#TODO: We need to check with an onpremise machine
	echo "blacklist usb-storage" | sudo tee -a /etc/modprobe.d/blacklist.conf
	sudo update-initramfs -u
}

#function that enables firewall and allows ports 53 and 22
function firewall_enable ()
{
	#installing firewall if not installed
	uninstalled=$(sudo dpkg --get-selections | grep ufw)
	if [ -z "$uninstalled" ]
	then
		sudo apt install ufw -y	#install ufw firewall
	#making firewall active if inactive
	else 
		status=$(sudo ufw status | head -1 | cut -d : -f 2) #storing the status of firewall
		if [ $status = 'inactive' ]
		then
			sudo ufw reset		#deleting all the previous rules
		fi
	fi
	#case when firewall is active an if ports other than 53 and 22 are open. 
	open_ports=$(sudo ufw status | awk '{if(NR>4)print}' | cut -d " " -f 1 | grep -v 22 | grep -v 53)
	if [ -z "$open_ports" ]
		#do nothing if no ports are open other than 22 and 53
	then
	else
		#resetting the rules if any port other than 53 and 22 are open
		sudo ufw reset		#deleting all the rules
	fi
	
	sudo ufw allow 53 #allows port 53
	sudo ufw allow 22 #allows port 22
	sudo ufw enable   #enabling the firewall
}

# updating and upgrading packages
function package_update()
{
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt-get dist-upgrade
}

#function that disables the print access.
function disable_print_screen ()
{
	sudo chmod -x /usr/bin/gnome-screenshot
}

#main function
function main ()
{
	usb_disable
	firewall_enable
	package_update
	disable_print_screen
}

#calling main
main