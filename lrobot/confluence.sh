
set -x
# centos install confluence 6.3 how to 
#https://www.cnblogs.com/kevingrace/p/7607442.html
# need confluence_keygen.jar to patch atlassian-extras-decoder-v2-3.2.jar, rename to atlassian-extras-2.4.jar,
# after patch, rename back and place back  

yum -y install mariadb mariadb-server
systemctl start mariadb
systemctl enable mariadb
systemctl stop firewalld
systemctl disable firewalld
yum install -y unzip
yum install -y git aria2
yum install -y net-tools
yum install -y python-pip
pip install --upgrade pip

do_download() {
git clone https://github.com/sdvcrx/pan-baidu-download.git
( cd pan-baidu-download/ && pip install -r requirements.txt )
python pan-baidu-download/bddown_cli.py download https://pan.baidu.com/s/1AH-GDQRyq2DJPOIrCECh2g
python pan-baidu-download/bddown_cli.py download https://pan.baidu.com/s/1cWxoY5P4SGrD7YBQNL_QOw
python pan-baidu-download/bddown_cli.py download https://pan.baidu.com/s/1yOT9a4WCx9IsjtNL3ABNLQ
python pan-baidu-download/bddown_cli.py download https://pan.baidu.com/s/1za0uLU0z6TPM5iNhkXfQFA
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
wget https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.6.6-x64.bin

}
#do_download
systemctl stop confluence
service confluence stop
/etc/init.d/confluence stop
pkill java
userdel confluence
rpm -ivh jdk-8u131-linux-x64.rpm
rm -rf /opt/atlassian/
rm -rf /var/atlassian/
chmod a+x atlassian-confluence-*.bin
#./atlassian-confluence-5.6.6-x64.bin
./atlassian-confluence-6.3.1-x64.bin
#create database confluence default character set utf8 collate utf8_bin;
#grant all on confluence.* to 'confluence'@'%' identified by 'confluence0987654321';
/etc/init.d/confluence restart
sleep 20
/etc/init.d/confluence stop
chown -R confluence:confluence /var/atlassian/application-data
chmod -R 777 /var/atlassian/application-data
rm -rf mysql驱动/
unzip mysql-connector-java-5.0.8-bin.jar.zip
/usr/bin/cp  mysql驱动/mysql-connector-java-5.0.8-bin.jar /opt/atlassian/confluence/lib/

install_for_631() {
/usr/bin/cp  atlassian-extras-decoder-v2-3.2.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.2.jar
/usr/bin/cp  atlassian-universal-plugin-manager-plugin-2.22.jar /opt/atlassian/confluence/confluence/WEB-INF/atlassian-bundled-plugins/atlassian-universal-plugin-manager-plugin-2.22.1.jar
}
install_for_566() {
ls /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-*
rm -rf /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-*
rm -rf confluence5.6.6-crack/
unzip confluence5.6.6-crack.zip
/usr/bin/cp  confluence5.6.6-crack/jar/* /opt/atlassian/confluence/confluence/WEB-INF/lib/
}
#install_for_566
install_for_631

/etc/init.d/confluence start

