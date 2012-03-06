#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

include_script ${path}/config.sh

options[lamp]=$(dialog --stdout \
                --backtitle "${title}" \
                --title "${title}" \
                --checklist "Sélectionnez les éléments à installer" 20 61 5 \
                "apache"    "Installation d'Apache" on \
                "php"       "Installation de PHP"   on \
                "mysql"     "Installation de MySQL" on \
                )

lamp_php_versions=""
lamp_mysql_pass=""

for option in ${options[lamp]}; do
    option=$(echo ${option} | sed 's/"//g')
    
    if [ "${option}" == "php" ]; then
        lamp_php_versions=$(${DIALOG} --stdout \
                        --backtitle "Versions de PHP" \
                        --title "Versions de PHP" \
                        --checklist "Sélectionnez les versions de PHP à installer" 20 61 5 \
                        "5_4" "PHP 5.4" on \
                        "5_3" "PHP 5.3" off \
                        "5_2" "PHP 5.2" off \
                        "4"   "PHP 4"   off \
                        )
        
        lamp_list_default=""
        for php_version in ${lamp_php_versions}; do
          if [ "${lamp_list_default}" == "" ]; then
            lamp_list_default_state="on"
          else
            lamp_list_default_state="off"
          fi
          
          lamp_list_default="${lamp_list_default} ${php_version} \"PHP `echo ${php_version} | sed 's/_/./' | sed 's/\"//g'`\" ${lamp_list_default_state}"
        done
        
        lamp_default_php=$(echo ${lamp_list_default} | xargs ${DIALOG} --stdout \
                        --backtitle "Versions de PHP" \
                        --title "Versions de PHP" \
                        --radiolist "Sélectionnez la version de PHP à utiliser par défaut" 20 61 5
                        )
    fi
    
    if [ "${option}" == "mysql" ]; then
        lamp_mysql_pass=$(${DIALOG} --stdout \
                        --backtitle "Mot de passe root de MySQL" \
                        --title "Mot de passe root de MySQL" \
                        --inputbox "Mot de passe root souhaité" 20 61 "${lamp_default_mysql_pass}"
                        )
    fi
done
