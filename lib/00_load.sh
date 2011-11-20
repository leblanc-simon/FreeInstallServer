#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

scripts=$(ls "${LIB_DIRECTORY}" | grep -v '00_load' | sort)

for script in ${scripts}; do
  source "${LIB_DIRECTORY}/${script}"
done
