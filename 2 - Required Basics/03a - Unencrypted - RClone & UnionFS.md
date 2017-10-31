![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

# Unencrypted - RClone, UnionFS & Move
WARNING: Chose Either 03A or 03B

![N](https://camo.githubusercontent.com/f77b6479ad8f227f62675fe0c761e4eb207c561d/68747470733a2f2f72636c6f6e652e6f72672f696d672f72636c6f6e652d313230783132302e706e67)

- RClone
  - Mounts your Google Drive (not used as primary due to API Bans)
- UnionFS
  - Moves multiple drives
- Move
  - Made to sync files from your local drive to your google drive

## Setting Up & Installing RClone

```sh
### Creating Folders
sudo mkdir /mnt/rclone-union && sudo mkdir /mnt/rclone-move

### Chaning Permissions
sudo chmod 755 /mnt/rclone-move && sudo chmod 755 /mnt/rclone-union

## To Install Fuse
sudo apt-get install unionfs-fuse

## Installing RClone (Can Copy Entire and Execute Entire Mini Block Below)

cd /tmp
sudo curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
sudo unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb
cd .. && sudo rm -r rclone*
sudo mkdir /mnt/rclone
sudo chmod 755 /mnt/rclone
sudo chown root /mnt/rclone
```

Configure RClone config as Root 

```sh
sudo su
rclone config
```

## Configuring RClone
May change due to version | Currently for version 1.38

- N < For New remote 
- gdrive < for the name
- 9 < For Google Drive (double check the number select incase)
- Enter Your Google ID
- Enter Your Goole Secret
- N < for headless machine #### NOTE: if your on a VM or the actual machine with an interface (GUI), select Y.  
- Enter Your Verification Code
 - Note: If you copy and paste by SELECTING and CLICK the RIGHT Mouse button, it will work; but then you will see it repeat
 -Note: Hold the DEL button to del the extra crap and then paste into a browser to get the verfication code
- N < Configure this as a team drive?
- Y < If asking all is ok?
- N < For New remote
- local < for the name
- 11 < For a Local Drive
- (ignore the question about long file names or 1) type this exactly: /mnt/rclone-move
- Y < Is asking all is ok?
- Q < to quit

### Back to your username

```sh
su [YOURUSERNAME]
```

### Allow multiple connections for fuse

```sh
sudo nano /etc/fuse.conf
```
- remove the (#) symbol before user_allow_other; then press CTRL+X and then save

### Create rclone.service

```sh
sudo nano /etc/systemd/system/rclone.service
```

- Copy the following below into the Nano Edit for rclone.service

```sh
[Unit]
Description=RClone Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/rclone --allow-non-empty --allow-other mount gdrive: /mnt/rclone --bwlimit 8650k --size-only
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
 
[Install]
WantedBy=multi-user.target
```

- Press CTRL+X and then Yes to save

### Start and enable the rclone.service

```sh
sudo systemctl daemon-reload
sudo systemctl enable rclone.service
sudo systemctl start rclone.service
sudo systemctl status rclone.service
```

- Press CTRL + C to exit the status message
 
## Establishing unionfs.service

![N](http://icons.iconarchive.com/icons/hopstarter/hard-drive/72/Device-Hard-Drive-Mac-icon.png)

- Merges your local drive and plexdrive to create a secondary drive
- Required for Sonarr & Radarr

```sh
sudo nano /etc/systemd/system/unionfs.service
```

- Copy and paste the following below for the unionfs.service

```sh
[Unit]
Description=UnionFS Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
### Note, you can change /mnt/plexdrive4 to /mnt/rclone; but can run into API bans with large libraries 
ExecStart=/usr/bin/unionfs -o cow,allow_other,nonempty /mnt/rclone=RW:/mnt/plexdrive4=RO /mnt/rclone-union
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

- Press CTRL+X and then Yes to save

### Start and enable unionfs.service
```sh
sudo systemctl daemon-reload
sudo systemctl enable unionfs.service
sudo systemctl start unionfs.service
sudo systemctl status unionfs.service
```
