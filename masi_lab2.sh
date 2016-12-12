#!bin/bash

afni*icedtea-7-plugin

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
sudo dpkg -i google-chrome-stable_current_amd64.deb &&
rm -f google-chrome-stable_current_amd64.deb

echo ". /etc/fsl/5.0/fsl.sh" >> /etc/skel/.profile
apt-get install -f

#Add one of the following lines according to your distribution to your /etc/apt/sources.list:
#deb http://download.virtualbox.org/virtualbox/debian trusty contrib

apt-get update
su landmaba
ssh-keygen -t rsa
cat .ssh/id_rsa.pub | ssh landmaba@oak.accre.vanderbilt.edu 'cat >> .ssh/authorized_keys'
mkdir /home-local
chmod 777 /home-local/

# if cannot snap use apt-get
apt-get --assume-yes install cvs subversion fsl-complete mricron dicomnifti afni* xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic blackbox


/share/sshfs/mount_sshfs.sh

### Prasanna Tools

#try to snap
#sudo apt-get install liblapack-dev -y ; sudo apt-get install liblapack3 -y ; sudo apt-get install libopenblas-base -y ; sudo apt-get install libopenblas-dev -y ;

#snapped
#sudo apt-get install python-dipy
'''
mkdir tmp
cd tmp
cp /fs2/masi/parvatp/Projects/AMICOInstallation/spams-python-v2.5-svn2014-07-04.tar.gz .
gunzip spams-python-v2.5-svn2014-07-04.tar.gz
tar -xvf spams-python-v2.5-svn2014-07-04.tar
'''

# Change to spams-python directory
cd spams-python
cp /fs2/masi/parvatp/Projects/AMICOInstallation/setup.py .
# Install dependencies first
sudo apt-get install libatlas-dev
sudo apt-get install libatlas3gf-base
sudo ln -s /usr/lib/libblas.so.3 /usr/lib/libblas.so
sudo ln -s /usr/lib/liblapack.so.3 /usr/lib/libblas.so
python setup.py build
sudo python setup.py install
cd ../

#Install AMICO

cp /fs2/masi/parvatp/Projects/AMICOInstallation/AMICO-master.zip .
unzip AMICO-master.zip
cd AMICO-master/python
sudo pip install .
rm -r tmp


echo "deb http://download.virtualbox.org/virtualbox/debian trusty contrib" >> /etc/apt/sources.list
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -


sudo apt-get update
