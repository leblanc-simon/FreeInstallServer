#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

#
# This function with all alphabetic characters converted to uppercase.
# @param    string      $1|STDIN string
# @return   string
# @see      http://codebase.tuxnet24.de/index.php?ref=snippet&space=1&container=21&snippets=138
#
function strtoupper() 
{
    if [ -n "$1" ]; then
        echo $1 | tr '[:lower:]' '[:upper:]'
    else
        cat - | tr '[:lower:]' '[:upper:]'
    fi
}


#
# Retourne la date actuelle
# @return   string      la date actuelle
#
function get_date()
{
    local str_date=`date "+%Y-%m-%d:%H:%M:%S"`
    echo "${str_date}"
}
