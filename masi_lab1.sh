#!bin/bash
#Begin post domain install from IT
echo "leafnode: 127.0.0.1" >> /etc/hosts.allow
echo "leafnode: ALL" >> /etc/hosts.deny
sed -i 's/session sufficient pam_lsass.so/session \[success=ok default=ignore\] pam_lsass.so/g' /etc/pam.d/common-session
echo "username=masinas" >> /root/.smbcredentials
echo "password=qazwsxed" >> /root/.smbcredentials
echo 'deb http://linux.dell.com/repo/community/ubuntu trusty openmanage' | sudo tee -a /etc/apt/sources.list.d/linux.dell.com.sources.list
gpg --keyserver pool.sks-keyservers.net --recv-key 1285491434D8786F
gpg -a --export 1285491434D8786F | sudo apt-key add -
sudo apt-get update
sudo apt-get install srvadmin-all
sudo service dataeng start
/opt/dell/srvadmin/sbin/omreport chassis
mkdir /share
chmod 777 /share
mkdir /share2
chmod 777 /share2
mkdir /share3
chmod 777 /share3
mkdir /home-nfs
chmod 777 /home-nfs
echo "kyuss:/ /home-nfs nfs4 _netdev,auto 0 0" >> /etc/fstab
echo "//swift/share /share cifs credentials=/root/.smbcredentials3,iocharset=utf8,file_mode=0777,dir_mode=0777 0 0" >> /etc/fstab
echo "//swift/share2 /share2 cifs credentials=/root/.smbcredentials3,iocharset=utf8,file_mode=0777,dir_mode=0777 0 0" >> /etc/fstab
echo "//swift/share3 /share3 cifs credentials=/root/.smbcredentials3,iocharset=utf8,file_mode=0777,dir_mode=0777 0 0" >> /etc/fstab

echo "username=masinas" >> /root/.smbcredentials2
echo "password=qazwsxed" >> /root/.smbcredentials2

apt-get install cifs-utils nfs-common
mount -t cifs //10.20.201.81/share2update /share -o password=qazwsxed,username=masinas
# mount 10.20.201.81:/share /share
cp /share/hosts.local.example /etc/hosts.local
#nano /etc/hosts.local # - ASK BL
cp /share/masi-sync.sh /root/
cat  <(echo "*/15 * * * *  cp /share/hosts.global /etc/hosts.global && cat /etc/hosts.local /etc/hosts.global > /etc/hosts") | crontab -
cat  <(echo "@daily /root/masi-sync.sh /2 /share/sshfs/mount_sshfs.sh") | crontab -
cat  <(echo "@daily /opt/pbis/bin/ad-cache --delete-group --name masi-users && /opt/pbis/bin/enum-members masi-users") | crontab -
#sleep 60 - ASK BL
#<wait for hosts to update or run the above lines yourself>

#Fix NFS:
echo"[General]

Verbosity = 0
Pipefs-Directory = /run/rpc_pipefs
# set your own domain here, if id differs from FQDN minus hostname
Domain = localdomain

[Mapping]

Nobody-User = nobody
Nobody-Group = nogroup" >> /etc/idmapd.conf

mount /home-nfs/
echo"[SeatDefaults]
greeter-session=unity-greeter
allow-guest=false
greeter-show-remote-login=false
greeter-show-manual-login=true" >>
/usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
#wget -O- http://neuro.debian.net/lists/trusty.us-tn.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
#sudo apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 2649A5A9
sudo apt-get update
sudo /opt/likewise/bin/lwregshell set_value '[HKEY_THIS_MACHINE\Services\lsass\Parameters\Providers\ActiveDirectory]' LoginShellTemplate /bin/bash
sudo /opt/likewise/bin/lwregshell set_value '[HKEY_THIS_MACHINE\Services\lsass\Parameters\Providers\Local]' LoginShellTemplate /bin/bash
sudo /opt/likewise/bin/lwsm refresh lsass
sudo /opt/likewise/bin/lw-ad-cache --delete-all
cd /home
ls
mv local local.old
ln -s /home-nfs/local /home/local
reboot now

