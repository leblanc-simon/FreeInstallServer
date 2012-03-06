#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

#
# Installation d'apache
#
function lamp_install_apache()
{
    # Installation de la base d'apache
    execute "${INSTALL_BIN} install apache2 apache2-utils"
    
    # Installation des modules de base
    execute "${INSTALL_BIN} install apache2-suexec libapache2-mod-evasive libapache-mod-security"
}


#
# Installation de MySQL
#
function lamp_install_mysql()
{
    # Configuration des options par défaut (évite d'avoir les fenêtres qui pose les questions)
    ## Ajout du mot de passe root de MySQL
    debconf-set-selections <<< "mysql-server-5.1 mysql-server/root_password password ${lamp_mysql_pass}"
    debconf-set-selections <<< "mysql-server-5.1 mysql-server/root_password_again password ${lamp_mysql_pass}"
    
    execute "${INSTALL_BIN} install mysql-server-5.1 mysql-client"
}

#
# Installation des dépendances de PHP
#
function lamp_install_deps()
{   
    # PHP 5.4
    execute "${INSTALL_BIN} install libxml2-dev libssl-dev libbz2-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libxpm-dev libfreetype6-dev libc-client-dev libicu-dev libmcrypt-dev libxslt-dev"
    
    # PHP 5.3 (à ajouter à PHP 5.4)
    execute "${INSTALL_BIN} install libmysqlclient-dev"
    
    # PHP 5.2 (à ajouter à PHP 5.3)
    execute "${INSTALL_BIN} install libmhash-dev"
    
    # PHP 4 (à ajouter à PHP 5.2)
    execute "${INSTALL_BIN} install flex bison m4"
}


#
# Téléchargement et extraction de l'archive PHP
# @param    string      Le numéro de version de PHP
#
function lamp_install_download_extract_php()
{
    version="$1"
    
    execute "wget http://fr2.php.net/get/php-${version}.tar.bz2/from/this/mirror -O ${TEMPORARY_DIRECTORY}/php-${version}.tar.bz2"
    execute "tar -xjf ${TEMPORARY_DIRECTORY}/php-${version}.tar.bz2 -C ${COMPILATION_DIRECTORY} "
    execute "rm -f ${TEMPORARY_DIRECTORY}/php-${version}.tar.bz2"
}


#
# Compilation de PHP
# @param    string      Le numéro de version de PHP
# @param    string      la ligne de configuration de PHP
#
function lamp_install_compile_php()
{
    version="$1"
    configure="$2"
    
    execute "${COMPILATION_DIRECTORY}/php-${version}/${configure}"
    execute "make -f ${COMPILATION_DIRECTORY}/php-${version}/Makefile"
    execute "make -f ${COMPILATION_DIRECTORY}/php-${version}/Makefile install"
}

#
# Installation de PHP
#
function lamp_install_php()
{   
    # On installe chaque version voulue
    suphp_handler=""
    suphp_mod_apache=""
    
    # Installation des dépendances
    lamp_install_deps
    
    for version in ${lamp_php_versions}; do
        version=$(echo ${version} | sed 's/"//g')
        
        # PHP 5.4
        if [ "${version}" == "5_4" ]; then
            lamp_install_download_extract_php "${lamp_php54_version}"
            lamp_install_compile_php "${lamp_php54_version}" "${lamp_php54_configure}"
            php_path="\/usr\/local\/php54\/bin\/php-cgi"
        
        # PHP 5.3
        elif [ "${version}" == "5_3" ]; then
            lamp_install_download_extract_php "${lamp_php53_version}"
            lamp_install_compile_php "${lamp_php53_version}" "${lamp_php53_configure}"
            php_path="\/usr\/local\/php54\/bin\/php-cgi"
        
        # PHP 5.2
        elif [ "${version}" == "5_2" ]; then
            lamp_install_download_extract_php "${lamp_php52_version}"
            lamp_install_compile_php "${lamp_php52_version}" "${lamp_php52_configure}"
            php_path="\/usr\/local\/php54\/bin\/php-cgi"
        
        # PHP 4
        elif [ "${version}" == "4" ]; then
            lamp_install_download_extract_php "${lamp_php4_version}"
            lamp_install_compile_php "${lamp_php4_version}" "${install_php4}"
            php_path="\/usr\/local\/php4\/bin\/php-cgi"
            
            # Pour garder une cohérence, on renomme le CGI et on place le CLI
            execute "mv /usr/local/php4/bin/php /usr/local/php4/bin/php-cgi"
            execute "cp -p ${COMPILATION_DIRECTORY}/php-${lamp_php4_version}/sapi/cli/php /usr/local/php4/bin/php"
        fi
        
        # Handler suPHP
        current_handler="application\/x-httpd-suphp-${version}=\"php:${php_path}\""
        if [ "${suphp_handler}" == "" ]; then
            suphp_handler="${current_handler}"
        else
            suphp_handler="${suphp_handler}\n${current_handler}"
        fi
        
        if [ "`echo ${lamp_default_php} | sed 's/\"//'`" == "${version}" ]; then
            current_mod_apache="AddType application\/x-httpd-suphp-${version} \.php \.php`echo ${version} | sed 's/_/\./'` \.phtml\n        suPHP_AddHandler application\/x-httpd-suphp-${version}"
        else
            current_mod_apache="AddType application\/x-httpd-suphp-${version} \.php`echo ${version} | sed 's/_/\./'`\n        suPHP_AddHandler application\/x-httpd-suphp-${version}"
        fi
        if [ "${suphp_mod_apache}" == "" ]; then
            suphp_mod_apache="${current_mod_apache}"
        else
            suphp_mod_apache="${suphp_mod_apache}\n        ${current_mod_apache}"
        fi
    done
    
    # On installe suphp
    execute "${INSTALL_BIN} install suphp-common libapache2-mod-suphp"
    
    # On configure suphp
    perl -pi -e 's/umask=0077/umask=0022/' /etc/suphp/suphp.conf
    perl -pi -e 's/docroot=\/var\/www:\${HOME}\/public_html/docroot=\/home/' /etc/suphp/suphp.conf
    perl -pi -e 's/check_vhost_docroot=true/check_vhost_docroot=false/' /etc/suphp/suphp.conf
    perl -pi -e 's/min_gid=100/min_gid=33/' /etc/suphp/suphp.conf
    suphp_handler=`echo -e "${suphp_handler}"`
    perl -pi -e "undef \$/; s/application\/x-httpd-suphp=\"php:\/usr\/bin\/php-cgi\"/${suphp_handler}/" /etc/suphp/suphp.conf
    
    perl -pi -e 's/suPHP_AddHandler application\/x-httpd-suphp//' /etc/apache2/mods-available/suphp.conf
    suphp_mod_apache=`echo -e "${suphp_mod_apache}"`
    perl -pi -e "undef \$/; s/AddType application\/x-httpd-suphp \.php \.php3 \.php4 \.php5 \.phtml/${suphp_mod_apache}/" /etc/apache2/mods-available/suphp.conf
}


function lamp_install()
{
    for option in ${@}; do
        option=$(echo ${option} | sed 's/"//g')
        if [ "${option}" == "apache" ]; then
            lamp_install_apache
        elif [ "${option}" == "mysql" ]; then
            lamp_install_mysql
        elif [ "${option}" == "php" ]; then
            lamp_install_php
        fi
    done
}
