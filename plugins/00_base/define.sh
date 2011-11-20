#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

function base_get_name()
{
    echo "base"
    return 0
}


function base_get_description()
{
    echo "Installation de base"
    return 0
}


function base_get_default()
{
    echo "on"
    return 0
}
