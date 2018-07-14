
set -x
# centos install confluence 6.3 how to 
#https://www.cnblogs.com/kevingrace/p/7607442.html

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
}
#do_download

rm -rf /opt/atlassian/
rm -rf /var/atlassian/
chmod a+x atlassian-confluence-6.3.1-x64.bin
./atlassian-confluence-6.3.1-x64.bin
#create database confluence default character set utf8 collate utf8_bin;
#grant all on confluence.* to 'confluence'@'%' identified by 'confluence0987654321';
/etc/init.d/confluence start
sleep 20
/etc/init.d/confluence stop
cp atlassian-extras-decoder-v2-3.2.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.2.jar
cp atlassian-universal-plugin-manager-plugin-2.22.jar /opt/atlassian/confluence/confluence/WEB-INF/atlassian-bundled-plugins/atlassian-universal-plugin-manager-plugin-2.22.1.jar
rm -rf mysql驱动/
unzip mysql-connector-java-5.0.8-bin.jar.zip
cp mysql驱动/mysql-connector-java-5.0.8-bin.jar /opt/atlassian/confluence/lib/

/etc/init.d/confluence start

