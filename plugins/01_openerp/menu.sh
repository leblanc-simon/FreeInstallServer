#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

include_script ${path}/config.sh

options[openerp]=$(dialog --stdout \
                --backtitle "${title}" \
                --title "${title}" \
                --checklist "Sélectionnez les éléments à installer" 20 61 5 \
                "postgresql"    "Installation de PostgreSQL"        on \
                "openerp"       "installation d'OpenEPR"            on \
                "create_db"     "Création de la base de données"    on
                )

openerp_version=""
openerp_user=""
openerp_pass=""

for option in ${options[openerp]}; do
    option=$(echo ${option} | sed 's/"//g')
    
    if [ "${option}" == "openerp" ]; then
        openerp_version=$(${DIALOG} --stdout \
                        --backtitle "Version d'OpenERP" \
                        --title "Version d'OpenERP" \
                        --inputbox "Version d'OpenERP souhaitée" 20 61 "${openerp_default_version}"
                        )
                        
        openerp_user=$(${DIALOG} --stdout \
                        --backtitle "Nom d'utilisateur d'OpenERP" \
                        --title "Nom d'utilisateur d'OpenERP" \
                        --inputbox "Nom d'utilisateur d'OpenERP souhaité" 20 61 "${openerp_default_user}"
                        )
                        
        openerp_pass=$(${DIALOG} --stdout \
                        --backtitle "Mot de passe d'OpenERP" \
                        --title "Mot de passe d'OpenERP" \
                        --inputbox "Mot de passe d'OpenERP souhaité" 20 61 "${openerp_default_pass}"
                        )
    fi
done
