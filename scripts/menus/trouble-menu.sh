#!/bin/bash
# A menu driven shell script sample template
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

one(){
	echo "one() called"
        pause
}

# do something in two()
two(){
	echo "two() called"
        pause
}

# function to display menus
show_menus() {

clear
cat << EOF
Notes:
[1]   Only run after you installed PlexDrive
[2-3] Only run after you installed rclone
[4]   Only run after having your download programs and programs configured
[5]   Run only as a last resort

~~~~~~~~~~~~~~~~~~~~
Troubleshooting Menu
~~~~~~~~~~~~~~~~~~~~
1. PlexDrive Mount Test:  Verify your PlexDrive Install
2. RClone Mount Test   :  Check if the RClone mount works
3. UnionFS Mount Test  :  Check if the UnionFS mount works
4. File Sync Checker   :  Check Service to verify File Sync
5. Force Main Reinstall:  Forces Important Scripts to Re-Install
6. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 6 ] " choice
	case $choice in
  	1)
      clear
      ls /mnt/plexdrive4
      echo
      echo "*** PlexDrive4: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: Must have at least 1 item in your Google Drive for the test"
      echo "Note 2: Once you finish the PLEXDRIVE4 setup, you'll see everything!"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;
  	2)
  		clear
  		ls /mnt/rclone
  		echo
      echo "*** RClone: Your Google Drive - If empty, that's not good ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
  		;;
  	3)
  		touch /mnt/rclone-move/uniontest.txt
  		clear
  		ls /mnt/rclone-union
  		echo
      echo "*** UnionFS: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: You should at least see uniontest.txt"
      echo "Note 2: Once you finish the PLEXDRIVE4 setup, you should see the rest"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
  		;;
      4)
        ## create log file if does not exist
        if [ -e "/opt/plexguide/move.log" ]
        then
          echo "Log exists"
        else
          touch /opt/plexguide/move.log
        fi

        ## obtains move.service info and puts into a log to displayed to the user
    		clear
    		systemctl status move >> /opt/plexguide/move.log
        cat /opt/plexguide/move.log
    		echo
        echo "*** View the Log ***"
        echo "Remember, there is a sleep function of 30 minutes after done"
        echo "If you have tons of stuff downloaded, you should see some activity"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
    		;;
    5)
      clear
      rm -r /var/plexguide/dep*
      echo
      echo "*** Exit and Update, and restart the program ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
        ;;
    6)
      exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do

	show_menus
	read_options
done
