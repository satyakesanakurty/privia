The privia_automation.sh script is used to update the os, install firewall, disable USB and printing in the server.
Will be running this script everyday at 8 am using ANACron.
The cronjob.sh creates a cron file that executes the privia_automation.sh script at 8:00 AM every day.
The privia_automation.sh script should be placed in the absolute path "/home/ubuntu". Example, it looks like /home/ubuntu/privia_automation.sh.
Execute cronjob.sh script with the following command: 
													 sh path/to/cronjob.sh .