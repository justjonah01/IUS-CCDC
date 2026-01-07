  GNU nano 7.2                            user_audit.sh                                       
#!/bin/bash

printf "%-15s %-6s %-10s %-25s %-8s %-5s %-5s\n" \
       "USER" "UID" "TYPE" "LAST LOGIN" "PWD" "SUDO" "SSH"
echo "--------------------------------------------------------------------------"

while IFS=: read -r user _ uid _ _ home _; do
    [ "$uid" -ge 1000 ] && type="Human" || type="System"

    lastlogin=$(lastlog -u "$user" | awk 'NR==2 {print $4, $5, $6, $7}')
    [ -z "$lastlogin" ] && lastlogin="Never"

    pwd=$(passwd -S "$user" 2>/dev/null | awk '{print $2}')

    sudo="No"
    groups "$user" 2>/dev/null | grep -Eq '\b(sudo|wheel)\b' && sudo="Yes"

    ssh="No"
    [ -f "$home/.ssh/authorized_keys" ] && ssh="Yes"

    printf "%-15s %-6s %-10s %-25s %-8s %-5s %-5s\n" \
           "$user" "$uid" "$type" "$lastlogin" "$pwd" "$sudo" "$ssh"
done < /etc/passwd
