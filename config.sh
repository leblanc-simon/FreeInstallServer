#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

SCRIPT_DIRECTORY=`( cd -P $(dirname $0); pwd)`
LOG_DIRECTORY="${SCRIPT_DIRECTORY}/logs"
LIB_DIRECTORY="${SCRIPT_DIRECTORY}/lib"
PLUGINS_DIRECTORY="${SCRIPT_DIRECTORY}/plugins"
COMPILATION_DIRECTORY="${SCRIPT_DIRECTORY}/compilation"
TEMPORARY_DIRECTORY="${SCRIPT_DIRECTORY}/tmp"

DIALOG=${DIALOG=dialog}

INSTALL_BIN="apt-get --yes"
