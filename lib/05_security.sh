#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

#
# Vérifie que l'utilisateur a bien les droits root
# Si l'utilisateur n'a pas les droits root, on quitte le script
#
function is_root()
{
    if [ "${UID}" -ne "0" ]; then
        echo "You must be root. No root has small dick :-)"
        exit ${ERRORS["no_root"]}
    fi
    
    return 0
}


#
# Vérifie que le nombre d'arguments est correct pour la fonction
# @param    string      Nom de la fonction vérifiant ses paramètres
# @param    int         Nombre de paramètres reçu
# @param    int         Nombre de paramètres attendu
#
function check_num_args()
{
  local function_name=${1}
  local args_get=${2}
  local args_expect=${3}

  if [ ${args_expect} -ne ${args_get} ]; then
    logFatal "Nombre d'argument incorrect pour la fonction '${function_name}' - Recu : ${args_get} - Attendu : ${args_expect}" 1
    exit ${ERRORS["bad_num_args"]}
  fi
  
  return 0
}
