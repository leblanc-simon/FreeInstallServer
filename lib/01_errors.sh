#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

declare -a ERRORS=()

ERRORS["no_root"]=1
ERRORS["bad_num_args"]=2
ERRORS["log_fatal"]=3
