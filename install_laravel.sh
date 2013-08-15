#!/bin/sh
#
#   This script will download and install Laravel 4 
#   Adapted by Laurence Cope 
#	Based on https://github.com/natanshalva/Laravel-install
#


# ------- Set some Variables -----------
_domain=playground.amitywebsolutions.co.uk
_laravel="https://github.com/laravel/laravel/archive/master.zip"

# ------- Enter Password -----------
printf "\n Enter your password \n\r"
stty -echo
read _pass
stty echo

# ------- Choose Project Name -----------

if [ "$#" == "0" ]; then
	printf "\n\rPlease enter a project name\n\r\n\rUsage $0 <dir>\n\r\n\r"
    exit 1
fi

_subdir=$1.$_domain
_dir="/home/$USER/domains/$_subdir"

# ------- Create Sub Domain -----------

sudo virtualmin create-domain --domain $_subdir --parent $_domain --pass $_pass --default-features


# ------- Laravel Download -----------

printf "\n Fetching Laravel 4 from: $_laravel\n\r"

printf "\n Downloading and unzipping Laravel 4\n\r";
wget $_laravel ;

# ------- Laravel Unzip -----------
mv master $_dir/laravel.zip
cd $_dir;
unzip 'laravel.zip' ;

rsync -avz laravel-master/ ./
printf "\n we are in: " ;
pwd
printf "\n Verifying installation  -  file list: \n" ;
ls -la;

printf "\n Removing zip and laravel-develop folder \n"
rm -rf laravel-master laravel.zip ;

# Move public files to public_html
mv public/* public_html
mv public/.* public_html
rm -Rf public

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

printf "\n \n Create database (y/n) \n\r"
read answer
if [ $answer = y ] ; then

    _db="$USER"_$1
	
	virtualmin create-database.pl --domain $_domain --name $_db --type mysql

    printf  "\n \n ---------- Database installation complete --------------- \n"

    printf "\n Configuring database name and the user in Laravel 4 config $_dir/app/config/database.php"

    printf "\n create app/config/database.php.orig file \n"
    mv app/config/database.php app/config/database.php.orig ;

    sed "s/'database'  => 'database'/'database'  => '$_db'/g  
         s/'username'  => 'root'/'username'  => '$USER'/g  
         s/'password'  => ''/'password'  => '$_pass'/g"  app/config/database.php.orig > app/config/database.php

fi






printf "\n \n ************ DONE! **************  \n \n" ;


