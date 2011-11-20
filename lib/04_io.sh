#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

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
