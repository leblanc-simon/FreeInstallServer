#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

function openerp_get_name()
{
    echo "openerp"
    return 0
}


function openerp_get_description()
{
    echo "Installation d'OpenERP"
    return 0
}


function openerp_get_default()
{
    echo "off"
    return 0
}
