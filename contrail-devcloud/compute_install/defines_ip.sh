type=$(echo "$eth" | sed -n -e "s/\(.*\)[0-9.]\+/\1/gp" )

if [ "$type" = "xenbr" ]; then
        re_sed_ipaddr='.*ddr:\([0-9.]\+\).*'
        re_sed_bcast='.*cast:\([0-9.]\+\).*'
        re_sed_mask='.*ask:\([0-9.]\+\).*'
else
        re_sed_ipaddr='.*inet \([0-9.]\+\).*'
        re_sed_bcast='.*cast \([0-9.]\+\).*'
        re_sed_mask='.*ask \([0-9.]\+\).*'
fi

ipaddr=$( ifconfig $eth | sed -n -e "s/$re_sed_ipaddr/\1/gp" )
bcast=$( ifconfig $eth | sed -n -e "s/$re_sed_bcast/\1/gp" )
mask=$( ifconfig $eth | sed -n -e "s/$re_sed_mask/\1/gp" )

#ipgw=$( route |grep efault|awk '{print $2}' )
# Hardcoding this for devcloud
ipgw=192.168.56.1

#ipprefix=$( ipcalc -p "$ipaddr" "$mask" | sed -n -e "s/.*PREFIX=\(.*\)/\1/gp" )
# ipcalc command in Debian is different. Hard coding this for now for devcloud. Should revisit
ipprefix=24
