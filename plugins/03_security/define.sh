#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

function security_get_name()
{
    echo "security"
    return 0
}


function security_get_description()
{
    echo "Installation de la partie securite"
    return 0
}


function security_get_default()
{
    echo "on"
    return 0
}
