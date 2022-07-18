#!/bin/bash

# - iNFO -----------------------------------------------------------------------------
#
#        Author: wuseman <wuseman@nr1.nu>
#      FileName: wsubfind.sh
#       Version: 1.0
#
#       Created: 2022-07-15 (09:32:23)
#      Modified: 2022-07-18 (03:07:19)
#
#           iRC: wuseman (Libera/EFnet/LinkNet) 
#       Website: https://www.nr1.nu/
#        GitHub: https://github.com/wuseman/
#
# - Descrpiption --------------------------------------------------------------------
#
#      No description has been added
#
# - LiCENSE -------------------------------------------------------------------------
#
#      Copyright (C) 2021, wuseman                                     
#                                                                       
#      This program is free software; you can redistribute it and/or modify 
#      it under the terms of the GNU General Public License as published by 
#      the Free Software Foundation; either version 3 of the License, or    
#      (at your option) any later version.                                  
#                                                                       
#      This program is distributed in the hope that it will be useful,      
#      but WITHOUT ANY WARRANTY; without even the implied warranty of       
#      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        
#      GNU General Public License for more details.                         
#                                                                       
#      You must obey the GNU General Public License. If you will modify     
#      the file(s), you may extend this exception to your version           
#      of the file(s), but you are not obligated to do so.  If you do not   
#      wish to do so, delete this exception statement from your version.    
#      If you delete this exception statement from all source files in the  
#      program, then also delete it here.                                   
#
#      You should have received a copy of the GNU General Public License
#      along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# - End of Header -------------------------------------------------------------

SOURCE="https://crt.sh/?q"
userAgent='Mozilla/5.0 (ThisIsNotAnAppleDevice; Android 1.1; S20 Ultra) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/13.2'

okMSG() {
    echo -e "[\e[1;32m*\e[0m] $*"
}

errMSG() {
    echo -e "[\e[1;31m*\e[0m] $*"
}

if [[ -z $1 ]]; then 
    errMSG "duh, you forgot something important, try ./wsubfind.sh host.com"
    exit 
fi

printf '%59s\n' |tr ' ' '-'
printf 'wsubfind v1.0%46s\n' "[status]"
printf '%59s\n' |tr ' ' '-'

curl -sL ${SOURCE}=$1 \
    |grep -i $1 \
    |awk -F[\<\>] '{print $3}' \
    |awk '!seen[$0]++' \
    |sort \
    |grep $1|grep -v crt.sh > hosts.txt

seq 1 50|parallel -j50 -a hosts.txt 'ping -c 1 {} >/dev/null \
    && echo -e "{} \r ................................................. [....\e[1;32mup\e[0m]\rHost: https://{} " \
    || echo -e "{} \r ................................................. [....\e[1;31mdn\e[0m]\rHost: https://{} "' 2>/dev/null|awk 'length < 140'

printf '%59s\n' |tr ' ' '-'
echo -e "Found: $(cat hosts.txt|wc -l) subdomains for $1"
printf '%59s\n' |tr ' ' '-'

rm hosts.txt > /dev/null
