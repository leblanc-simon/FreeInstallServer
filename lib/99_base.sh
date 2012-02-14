#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

#
# Inclusion d'un fichier de script
# @param    string      Le fichier à inclure
#
function include_script()
{
	check_num_args 'include_script' $# 1
	
    local script_name="${1}"
    
    if [ ! -f "${script_name}" ]; then
        logFatal "Le script ${script_name} n'existe pas !"
        exit 3
    fi
    
    logInfo "On inclut ${script_name}"
    source "${script_name}"
    
    return 0
}


#
# Execute et log une commande puis vérifie que cela s'est bien déroulé
# @param    string      La commande à executer avec l'ensemble de ses paramètres
#
function execute()
{
	check_num_args 'execute' $# 1
	
	local str_command="$1"
	
	logInfo "Execution de la commande : ${str_command}"
	result=$(${str_command})
	return_value=$?
	
	if [ "${return_value}" -ne "0" ]; then
    	logError "Erreur dans l'execution de la commande : ${return_value} - ${str_command}"
	logError "${result}"
	fi
	
	if [ "${result}" != "" ]; then
	    echo "${result}"
	fi
	
	return 0
}


#
# Construit la liste des plugins pour le premier écran d'installation
# @param    string      Le listing du répertoire plugin
#
function list_plugins_for_menu()
{
    check_num_args 'list_plugins_for_menu' $# 1
    
    local plugins="${1}"
    local list_plugins=""
    
    for plugin in ${plugins}; do
        clean_name=$(echo ${plugin} | sed -re 's/([0-9]+)_//')
        
        include_script "${PLUGINS_DIRECTORY}/${plugin}/define.sh"
        
        plugin_name=$(${clean_name}_get_name)
        plugin_description=$(${clean_name}_get_description)
        plugin_default=$(${clean_name}_get_default)
        list_plugins="${list_plugins} \"${plugin_name}\" \"${plugin_description}\" ${plugin_default}"
    done
    
    echo ${list_plugins}
    
    return 0
}


#
# Construit le chemin du répertoire du plugin
# @param    string      Le nom du plugin (qui doit être dans le nom du répertoire principal)
# @return   string      Le chemin du répertoire
#
function get_plugin_path()
{
    check_num_args 'get_plugin_path' $# 1
    
    local plugin="${1}"
    
    path=$(ls "${PLUGINS_DIRECTORY}" | grep ${plugin})
    
    echo "${PLUGINS_DIRECTORY}/${path}"
}
