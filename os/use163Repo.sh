#! /bin/bash

rpm -aq|grep yum|xargs rpm -e --nodeps

wget http://mirrors.163.com/centos/6.7/os/x86_64/Packages/yum-3.2.29-69.el6.centos.noarch.rpm
wget http://mirrors.163.com/centos/6.7/os/x86_64/Packages/yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
wget http://mirrors.163.com/centos/6.7/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.30-30.el6.noarch.rpm
wget http://mirrors.163.com/centos/6.7/os/x86_64/Packages/python-iniparse-0.3.1-2.1.el6.noarch.rpm

rpm -ivh python*
rpm -ivh yum*

mv /etc/yum.repos.d/rhel-source.repo /etc/yum.repos.d/rhel-source.repo.bak
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -P /etc/yum.repos.d/
perl -pi -e "s/$releasever/6.7/g" /etc/yum.repos.d/CentOS6-Base-163.repo