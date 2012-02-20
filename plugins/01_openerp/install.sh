#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

function openerp_install_postgresql()
{
    ${INSTALL_BIN} install postgresql
    
    # Modif parametres postgres (work_mem, maintenance_work_mem, autovacuum, effective_cache_size) voir formule
    # cat /proc/meminfo  | grep "MemTotal" | awk '{print $2}'
    #Voir parametre
    # si <8 Go : 32 Mo
    # si 8<RAM<16 Go : 64 Mo
    # Si >16 Go : 128 Mo
    local ram=`cat /proc/meminfo  | grep "MemTotal" | awk '{print $2}'`
    if [ ${ram} < 8388608 ]; then
	    local work_mem='32'
    elif [ $RAM > 16777216 ]; then
	    local work_mem='128'
    else
	    local work_mem='64'
    fi
    perl -pi -e "s/#work_mem = 1MB/work_mem = ${work_mem}MB/" ${openerp_postgres_config}
    perl -pi -e "s/#maintenance_work_mem = 16MB/maintenance_work_mem = ${work_mem}MB/" ${openerp_postgres_config}
    perl -pi -e 's/#autovacuum/autovacuum/' ${openerp_postgres_config}
    perl -pi -e 's/autovacuum = on/autovacuum = off/' ${openerp_postgres_config}
    
    return 0
}


function openerp_install_openerp()
{
    ${INSTALL_BIN} install python-lxml python-mako python-egenix-mxdatetime \
                           python-dateutil python-psycopg2 python-pychart \
                           python-pydot python-tz python-reportlab python-yaml \
                           python-vobject python-cherrypy3 python-setuptools
                           
    # Création utilisateur openerp + mdp par défault
    local salt=$(head -c 10 /dev/urandom | perl -e 'use MIME::Base64 qw(encode_base64);print encode_base64(<>);' | sed "s/\(.\{2\}\).*/\1/")
    local cpass=$(perl -e "print crypt('${openerp_pass}', '${salt}');")
    adduser -c ${openerp_user} -m -s /bin/bash -p ${cpass} ${openerp_user}
    if [ "$?" != "0" ]; then
      logFatal "L'utilisateur \"${openerp_user}\" n'a pas été créé !"
    fi
    
    # Création repertoires serveur et logs
    mkdir -p /home/${openerp_user}/openerp/log
    if [ "$?" != "0" ]; then
      logFatal "Impossible de créer le répertoire /home/${openerp_user}/openerp/log"
    fi
        
    # Téléchargement serveur, addon et web sur http://www.openerp.com/download/stable/source/ selon version
    mkdir /home/${openerp_user}/install_source
    if [ "$?" != "0" ]; then
      logFatal "Impossible de créer le répertoire /home/${openerp_user}/install_source"
    fi
    
    cd /home/${openerp_user}/install_source/
    wget "http://www.openerp.com/download/stable/source/openerp-server-${openerp_version}.tar.gz" -O openerp-server.tar.gz
    if [ "$?" != "0" ]; then
      logFatal "Impossible de télécharger openerp-server.tar.gz"
    fi
    
    wget "http://www.openerp.com/download/stable/source/openerp-web-${openerp_version}.tar.gz" -O openerp-web.tar.gz
    if [ "$?" != "0" ]; then
      logFatal "Impossible de télécharger openerp-web.tar.gz"
    fi

    # Détar sur /home/openerp/server /home/openerp/web /home/openerp/addons avec chown pour openerp
    tar -xzf openerp-server.tar.gz
    if [ "$?" != "0" ]; then
      logFatal "Impossible de décompresser openerp-server.tar.gz"
    fi
    mv openerp-server-${openerp_version} /home/${openerp_user}/openerp/server
    tar -xzf openerp-web.tar.gz
    if [ "$?" != "0" ]; then
      logFatal "Impossible de décompresser openerp-web.tar.gz"
    fi
    mv openerp-web-${openerp_version} /home/${openerp_user}/openerp/web

    # Populate 
    # Suppression de cette ligne en 6.1
    /home/${openerp_user}/openerp/web/lib/populate.sh

    # Suppression cherry*
    rm -rf /home/${openerp_user}/openerp/web/lib/cherry*
    
    return 0
}


function openerp_install_create_db()
{
    # En tant que postgres, créer user openerp avec mdp généré (avec envoi par mail + affichage fichier log :
    local pass_gen=`head -c 10 /dev/urandom | perl -e 'use MIME::Base64 qw(encode_base64);print encode_base64(<>);' | sed "s/\(.\{8\}\).*/\1/"`
    psql -c "CREATE USER ${openerp_user} WITH PASSWORD '${pass_gen}' CREATEDB NOCREATEUSER;"
    logInfo "Mot de passe user postgres ${openerp_user} : ${pass_gen}"
    
    return 0
}

function openerp_install()
{
    install_openerp=0
    install_postgres=0
    create_db=0
    for option in ${@}; do
        option=$(echo ${option} | sed 's/"//g')
        if [ "${option}" == "postgresql" ]; then
            openerp_install_postgresql
        elif [ "${option}" == "openerp" ]; then
            openerp_install_openerp
        elif [ "${option}" == "create_db" ]; then
            openerp_install_create_db
        fi
    done
}
