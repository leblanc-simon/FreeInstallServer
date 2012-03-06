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
    execute "${INSTALL_BIN} -o Dpkg::Options::=--force-confold upgrade"
    
    # Configuration des options par défaut (évite d'avoir les fenêtres qui pose les questions)
    ## Proftpd toune avec inetd
    debconf-set-selections <<< "proftpd-basic shared/proftpd/inetd_or_standalone select	inetd"
    
    execute "${INSTALL_BIN} install bzr git-core subversion python-subversion build-essential lftp proftpd-basic at fail2ban ntp zip htp rsync iptables"
    
    return 0
}
