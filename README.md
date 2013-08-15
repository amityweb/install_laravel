Laravel-install
===============

Installation script for Laravel 4 (inc. Generator Guard and Profiler packages)


## This script does the following:

1 - Create project directory 

2 - Download the Laravel 4 master

3 - Install and run composer 

4 - Create MYSQL database 

5 - Config Laravel database connection 
  * generate key
  * setup folder permission

## Setup

Download the script to your local machine with this command: 

    wget --no-check-certificate https://github.com/amityweb/install_laravel/raw/master/install_laravel.sh 

Set file permissions:

    chmod 755 install_laravel.sh

And then run:

    sh install_laravel.sh
