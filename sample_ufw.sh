#function that enables firewall and allows ports 53 and 22
#!/bin/bash
#function firewall_enable ( )
#{
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
#}

#firewall_enable
