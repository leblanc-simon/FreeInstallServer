#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

# On inclue le fichier de configuration
. "$(pwd)/config.sh"

# On inclue les bibliothèque
. "${LIB_DIRECTORY}/00_load.sh"

# On initialise les répertoires
create_essentials_dirs

# On install dialog si besoin
has_dialog=$(${DIALOG} -v)
if [ "$?" != 0 ]; then
    ${INSTALL_BIN} install dialog
fi

# On récupère l'ensemble des plugins
plugins=$(ls "${PLUGINS_DIRECTORY}" | sort)

# On demande les plugins a executer
plugin_options=$(list_plugins_for_menu "${plugins}")

choices=$(echo ${plugin_options} | xargs ${DIALOG} --stdout --backtitle "Choisissez les plugins à installer" --title "Plugins à installer" --checklist "Sélectionnez le ou les plugins à installer sur le serveur" 20 61 5)

if [ "${choices}" == "" ]; then
    echo "nothing to do"
    exit 0
fi

# On affiche les différents écrans d'accueil des plugins
options=()
for choice in ${choices}; do
    choice=$(echo ${choice} | sed 's/"//g')
    path=$(get_plugin_path ${choice})
    
    include_script ${path}/define.sh
    
    menu="${path}/menu.sh"
    if [ -f ${menu} ]; then
        title=$(${choice}_get_description)
        include_script ${menu}
    fi
done

# On execute les différentes installation des plugins
for choice in ${choices}; do
    choice=$(echo ${choice} | sed 's/"//g')
    path=$(get_plugin_path ${choice})
    
    install="${path}/install.sh"
    if [ -f ${install} ]; then
        include_script ${install}
        ${choice}_install ${options[${choice}]}
    fi
done

