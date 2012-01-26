#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

function lamp_install_apache()
{
    execute "${INSTALL_BIN} install apache2 apache2-utils"
}


function lamp_install_mysql()
{
    # Configuration des options par défaut (évite d'avoir les fenêtres qui pose les questions)
    ## Ajout du mot de passe root de MySQL
    debconf-set-selections <<< "mysql-server-5.1 mysql-server/root_password password ${lamp_mysql_pass}"
    debconf-set-selections <<< "mysql-server-5.1 mysql-server/root_password_again password ${lamp_mysql_pass}"
    
    execute "${INSTALL_BIN} install mysql-server-5.1 mysql-client"
}


function lamp_install_php()
{
    # On récupère la version par défaut disponible via apt-get
    default_version=`apt-cache show php5 | grep -m 1 Version | sed 's/-/ /' | awk '{print $2}' | sed 's/\./ /g' | awk '{print $1"."$2}'`
    
    # Préparation des configure
    install_php53="configure --prefix=/usr/local/php53 --with-config-file-path=/usr/local/lib/php53/ --disable-ipv6 --with-curl --enable-ftp --with-gd --enable-intl --enable-mbstring --with-mcrypt --with-pdo-mysql=mysqlnd --enable-soap --with-xsl --with-zlib --with-openssl --with-pear=/usr/share/php53/pear --with-mysql --enable-exif --with-imap --with-imap-ssl --with-kerberos"
    install_php52="configure --prefix=/usr/local/php52 --with-config-file-path=/usr/local/lib/php52/ --disable-ipv6 --with-curl --enable-ftp --with-gd --enable-intl --enable-mbstring --with-mcrypt --with-pdo-mysql=mysqlnd --enable-soap --with-xsl --with-zlib --with-openssl --with-pear=/usr/share/php52/pear --with-mysql --enable-exif --with-imap --with-imap-ssl --with-kerberos"
    install_php4="configure '--disable-cli' '--disable-discard-path' '--disable-force-cgi-redirect' '--prefix=/usr/local/php4' '--with-config-file-path=/usr/local/lib/php4' '--with-pear=/usr/share/php4' '--with-dbase' '--with-filepro' '--with-xml' '--enable-exif' '--enable-ftp' '--with-db' '--enable-bcmath' '--enable-calendar' '--with-gd' '--enable-gd-native-ttf' '--with-freetype-dir' '--with-gettext' '--with-zlib-dir' '--enable-trans-sid' '--with-imap' '--with-kerberos' '--with-imap-ssl' '--with-openssl' '--enable-sysvsem' '--enable-sysvshm' '--with-dom' '--with-mcrypt' '--with-iconv' '--enable-mbstring=all' '--enable-mbregex' '--with-png-dir=/usr' '--with-jpeg-dir=/usr' '--with-mysql=/usr' '--with-curl' '--with-dom-xslt' '--enable-xslt' '--with-xslt-sablot' '--with-mhash' '--with-mime-magic=/usr/share/misc/magic.mime' '--enable-cgi'"
    
    # On regarde la version disponible via apt-get
    if [ "${default_version}" == "5.2" ]; then
        install_php52=""
    elif [ "${default_version}" == "5.3" ]; then
        install_php53=""
    fi
    
    # On installe chaque version voulue
    for version in ${lamp_php_versions}; do
        version=$(echo ${version} | sed 's/"//g')
        
        # PHP 5.3
        if [ "${version}" == "5_3" ]; then
            if [ "${install_php53}" == "" ]; then
                ${INSTALL_BIN} install php5 libapache2-mod-php5 php5-mysql php5-ffmpeg php5-imagick php5-cli php5-curl php5-gd php5-mcrypt php5-xsl php5-xmlrpc php-pear php-apc php5-dev
            else
                wget http://fr2.php.net/get/php-${lamp_php53_version}.tar.bz2/from/this/mirror -O php-${lamp_php53_version}.tar.bz2 && tar -xjf php-${lamp_php53_version}.tar.bz2 && rm -f php-${lamp_php53_version}.tar.bz2 && ./php-${lamp_php53_version}/${install_php53} && make -f ./php-${lamp_php53_version}/Makefile && make -f ./php-${lamp_php53_version}/Makefile install
            fi
        
        # PHP 5.2
        elif [ "${version}" == "5_2" ]; then
            if [ "${install_php52}" == "" ]; then
                ${INSTALL_BIN} install php5 libapache2-mod-php5 php5-mysql php5-ffmpeg php5-imagick php5-cli php5-curl php5-gd php5-mcrypt php5-xsl php5-xmlrpc php-pear php-apc php5-dev
            else
                wget http://fr2.php.net/get/php-${lamp_php52_version}.tar.bz2/from/this/mirror -O php-${lamp_php52_version}.tar.bz2 && tar -xjf php-${lamp_php52_version}.tar.bz2 && rm -f php-${lamp_php52_version}.tar.bz2 && ./php-${lamp_php52_version}/${install_php52} && make -f ./php-${lamp_php52_version}/Makefile && make -f ./php-${lamp_php52_version}/Makefile install
            fi
        
        # PHP 4
        elif [ "${version}" == "4" ]; then
            wget http://fr2.php.net/get/php-${lamp_php4_version}.tar.bz2/from/this/mirror -O php-${lamp_php4_version}.tar.bz2 && tar -xjf php-${lamp_php4_version}.tar.bz2 && rm -f php-${lamp_php4_version}.tar.bz2 && ./php-${lamp_php4_version}/${install_php4} && make -f ./php-${lamp_php4_version}/Makefile && make -f ./php-${lamp_php4_version}/Makefile install
        fi
    done
    
    # On installe suphp
    
    # On configure suphp
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
