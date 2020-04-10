#!/bin/bash

#function that disables usb
function usb_disable ()
{
	#TODO: We need to check with an onpremise machine
	not_blacklisted=$(cat /etc/modprobe.d/blacklist.conf | grep usb-storage)
	#case when the usb-storage isn't blocked
	if [ -z "$not_blacklisted" ]
	then
		 echo "blacklist usb-storage" | sudo tee -a /etc/modprobe.d/blacklist.conf
        	 sudo update-initramfs -u
	fi
}


#function that enables firewall and allows ports 53 and 22
function firewall_enable ()
{
	#case:1 --installing firewall if not installed
        uninstalled=$(sudo dpkg --get-selections | grep ufw)
        if [ -z "$uninstalled" ]
        then
                sudo apt install ufw -y #install ufw firewall

        #case:2 --making firewall active if inactive
        else
                status=$(sudo ufw status | head -1 | cut -d : -f 2) #storing the status of firewall
                if [ $status = 'inactive' ]
                then
                        echo y | sudo ufw reset          #deleting all the previous rules
                fi
        fi

        #case:3 --when firewall is active an if ports other than 53 and 22 are open.
        open_ports=$(sudo ufw status | awk '{if(NR>4)print}' | cut -d " " -f 1 | grep -v 22 | grep -v 53)
        if [ -z "$open_ports" ]
        then
                #do nothing if no ports are open other than 22 and 53
                echo "no ports other than 22 and 53 are open"
        else
                #resetting the rules if any port other than 53 and 22 are open
                echo y | sudo ufw reset          #deleting all the rules
        fi

        sudo ufw allow 53 #allows port 53
        sudo ufw allow 22 #allows port 22
        echo y | sudo ufw enable #enabling the firewall

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
	#sudo chmod -x /usr/bin/gnome-screenshot
	echo "doing nothing as of now"
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
