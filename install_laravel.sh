#!/bin/sh
#
#   This script will download and install Laravel 4 
#   Adapted by Laurence Cope 
#	Based on https://github.com/natanshalva/Laravel-install
#
#	Download: 
#

# install laravel 4 

if [ $# -ne 0 ]
   then
   echo "Please enter a folder to create; Usage $0 <dir\>"
   exit 2
fi
   
_dir="$1"

if [ -d $_dir ] ; then

    printf "\n \n The directory: $_dir already exist. would you like to delete it first? (y/n) \n\r" ;
    read answer
    if [ $answer = y ] ; then
        rm -rf $_dir ;
    else 
        return
    fi  
fi

printf "\n \n Creating new dir name: $_dir \n \n\r"

mkdir $_dir

printf "\n Assigning $_dir 777 permissions \n\r"
chmod -R 777 $_dir

cd $_dir; 

pwd ;

# ------- Laravel Download -----------

_laravel4="https://github.com/laravel/laravel/archive/master.zip"

printf "\n Fetching Laravel 4 from: $_laravel4\n\r"

printf "\n Downloading and unzipping Laravel 4\n\r";
wget $_laravel4 ;

# ------- Laravel Unzip -----------

mv master laravel.zip
unzip 'laravel.zip' ;


printf "\n Assigning $_dir 777 permissions \n" ;
chmod -R 777 ../$_dir ;


pwd ;
rsync -avz laravel-master/ ./
printf "\n we are in: " ;
pwd
printf "\n Verifying installation  -  file list: \n" ;
ls -la;

printf "\n Removing zip and laravel-develop folder \n"
rm -rf laravel-master laravel.zip ;



# ------- Composer Install -----------


printf "\n install composer \n"
eval "curl -s https://getcomposer.org/installer | php"

if [ -d /usr/local/bin/composer ] ; then
    echo "ok, we see you have composer file in /usr/local/bin/composer"
else 
   echo "we are moving the composer to /usr/local/bin/composer \n
   for more info: http://getcomposer.org/doc/00-intro.md" 
   eval "cp composer.phar /usr/local/bin/composer" 
fi 


printf "\n install composer - php composer.phar install \n"
if [ -f ./composer.json ] ; then 
        eval "php composer.phar install"
else 
    printf "\n Oops, can't find composer.json \n";
    # exit the sctipt 
    return;
fi  


pwd ;

# ------- Artisan -----------

if [ -f ./artisan ] ; then 
    printf "\n php artisan key \n" ;
    eval "php artisan key:generate"  
else 
    printf "\n Can't find artisan file. \n";
    # exit the sctipt 
    return;
fi  


# ------- Create Database -----------

printf "\n \n Create database with the same name as the file directory (y/n) \n\r"
read answer
if [ $answer = y ] ; then

    printf "\n Enter mysql user name \n\r"
    read _user

    printf "\n Enter mysql password \n\r"
    read _pass

	_db = $_user_$_dir
	
    if [ -d /var/lib/mysql/$_db ] ; then

        printf "\n Database already exists, whould you like to delete it and create new one ? (y/n) \n\r"
        read answer
        if [ $answer = y ] ; then
            mysqladmin -u $_user -p"$_pass" drop $_db ;
            printf "\n Deleting database \n"
            printf "\n Creating new database $_db \n "
            mysqladmin -u $_user -p"$_pass" create $_db
        fi

    else
        printf "\n Creating database $_db \n "
        mysqladmin -u $_user -p"$_pass" create $_db
    fi

    printf  "\n \n ---------- Database installation complete --------------- \n"

    printf "\n Configuring database name and the user in Laravel 4 config ./app/config/database.php"

    printf "\n create ./app/config/database.php.orig file \n"
    mv ./app/config/database.php ./app/config/database.php.orig ;

    sed "s/'database'  => 'database'/'database'  => '$_db'/g  
         s/'username'  => 'root'/'username'  => '$_user'/g  
         s/'password'  => ''/'password'  => '$_pass'/g"  ./app/config/database.php.orig > ./app/config/database.php

fi


printf "\n \n ************ DONE! **************  \n \n" ;


