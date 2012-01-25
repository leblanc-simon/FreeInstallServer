#!/bin/bash

#
# This file is part of the FreeInstallServer.
# (c) 2011  Simon Leblanc <contact@leblanc-simon.eu>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

function base_install()
{
    execute "${INSTALL_BIN} update"
    execute "${INSTALL_BIN} upgrade"
    
    execute "${INSTALL_BIN} install bzr git-core subversion python-subversion build-essential lftp proftpd at fail2ban ntp zip htp rsync iptables"
    
    return 0
}
