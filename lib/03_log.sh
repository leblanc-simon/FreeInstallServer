#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

LOG_FILENAME="${LOG_DIRECTORY}/install.log"

#
# Ajoute un contenu dans un fichier
# @param    string      Le nom du fichier
# @param    string      Le contenu à ajouter
#
function write_file()
{
    local filename=${1}
    local content=${2}
    
    if [ ! -f "${filename}" ]; then
        touch "${filename}"
    fi
    
    echo "${content}" >> "${filename}" && return 0
}


#
# Log un événement
# @param    string      niveau de log (fatal | error | info)
# @param    string      contenu à logger
# @param    int         affiche le contenu du log à l'écran
#
function logger()
{
    local level=${1}
    local content=${2}
    local screen=${3}
    
    log_content="$(strtoupper ${level})	$(get_date)	${content}"
    write_file "${LOG_FILENAME}" "$log_content"
    
    if [ "${screen}" -eq "1" ]; then
        echo "$log_content"
    fi
    
    return 0
}


#
# Log un événement de type erreur fatal
# @param    string      contenu à logger
#
function logFatal()
{
    local content=${1}
    logger "fatal" "${content}" 1 
    
    exit ${ERRORS["log_fatal"]}
}


#
# Log un événement de type erreur
# @param    string      contenu à logger
#
function logError()
{
    local content=${1}
    logger "error" "${content}" 1
    
    return 0
}


#
# Log un événement de type info
# @param    string      contenu à logger
#
function logInfo()
{
    local content=${1}
    logger "info" "${content}" 0
    
    return 0
}


#
# Crée le répertoire des logs
#
function create_log_dir()
{
    mkdir -p "${LOG_DIRECTORY}"
    
    if [ "$?" -ne "0" ]; then
        logFatal "Impossible de creer le repertoire de log : ${LOG_DIRECTORY}"
    fi
    
    return 0
}
