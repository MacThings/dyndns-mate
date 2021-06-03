#!/bin/bash
#

ScriptHome=$(echo $HOME)
ScriptTmpPath="$HOME"/.ddm_temp
MY_PATH="`dirname \"$0\"`"
cd "$MY_PATH"
if [ ! -d "$ScriptTmpPath" ]; then
    mkdir "$ScriptTmpPath"
fi

################################################################
####################### Helper Function ########################
################################################################

function _helpDefaultRead()
{
    VAL=$1

    if [ ! -z "$VAL" ]; then
    defaults read "${ScriptHome}/Library/Preferences/dyndnsmate.slsoft.de.plist" "$VAL"
    fi
}

function _helpDefaultWrite()
{
    VAL=$1
    local VAL1=$2

    if [ ! -z "$VAL" ] || [ ! -z "$VAL1" ]; then
    defaults write "${ScriptHome}/Library/Preferences/dyndnsmate.slsoft.de.plist" "$VAL" "$VAL1"
    fi
}

function _helpDefaultWriteBool()
{
    VAL=$1
    local VAL1=$2

    if [ ! -z "$VAL" ] || [ ! -z "$VAL1" ]; then
    defaults write "${ScriptHome}/Library/Preferences/dyndnsmate.slsoft.de.plist" "$VAL1" -bool $VAL
    fi
}

function _helpDefaultDelete()
{
    VAL=$1

    if [ ! -z "$VAL" ]; then
    defaults delete "${ScriptHome}/Library/Preferences/dyndnsmate.slsoft.de.plist" "$VAL"
    fi
}

real_ip=$( curl ipecho.net/plain )
hostname=$( _helpDefaultRead "Hostname" )
dyndns_ip=$( dig +short $hostname )
_helpDefaultWrite "IP" "$real_ip"

function set_plist()
{

     if [[ "$update" == *"good"* ]] || [[ "$update" == *"nochg"* ]] || [[ "$update" == *"not changed"* ]] || \
        [[ "$update" == *"Updated"* ]] || [[ "$update" == *"OK"* ]]; then
        _helpDefaultWriteBool YES "UpdateOK"
        echo "ok"
        echo "$scheme" > /usr/local/bin/dyndnsmate
    else
        _helpDefaultWriteBool NO "UpdateOK"
        echo "error"
    fi
}

function check_status()
{
    real_ip=$( curl ipecho.net/plain )
    hostname=$( _helpDefaultRead "Hostname" )
    dyndns_ip=$( dig +short $hostname )
    
    if [[ "$real_ip" = "$dyndns_ip" ]]; then
        _helpDefaultWriteBool YES "UpdateOK"
    else
        _helpDefaultWriteBool NO "UpdateOK"
    fi

}

function check_daemon()
{
    daemon_check=$( launchctl list |grep de.slsoft.dyndnsmate )
    if [[ "$daemon_check" = "" ]]; then
        _helpDefaultWriteBool NO "Daemon"
        rm /usr/local/bin/dyndnsmate
    else
        _helpDefaultWriteBool YES "Daemon"
    fi
}

function install_daemon()
{
    interval=$( _helpDefaultRead "Interval" )
    interval=$(( $interval * 60 ))
    cp de.slsoft.dyndnsmate.plist "$ScriptHome"/Library/LaunchAgents/.
    chmod 644 "$ScriptHome"/Library/LaunchAgents/de.slsoft.dyndnsmate.plist
    ../bin/PlistBuddy -c "Set :StartInterval $interval" "$ScriptHome"/Library/LaunchAgents/de.slsoft.dyndnsmate.plist
    launchctl load -w "$ScriptHome"/Library/LaunchAgents/de.slsoft.dyndnsmate.plist
}

function uninstall_daemon()
{
    launchctl unload -w "$ScriptHome"/Library/LaunchAgents/de.slsoft.dyndnsmate.plist
    rm "$ScriptHome"/Library/LaunchAgents/de.slsoft.dyndnsmate.plist
}

function changeip()
{
    hostname=$( _helpDefaultRead "Hostname" )
    username=$( _helpDefaultRead "Login" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl https://nic.changeip.com/nic/update&u=$username&p=$password&hostname=$hostname&ip=$real_ip&set=1 )
    scheme=$( echo "curl https://nic.changeip.com/nic/update&u=$username&p=$password&hostname=$hostname&ip=$real_ip&set=1" )
    
    set_plist
}

function dnsmadeeasy()
{
    hostname=$( _helpDefaultRead "Hostname" )
    username=$( _helpDefaultRead "Login" )
    password=$( _helpDefaultRead "Password" )
    optional=$( _helpDefaultRead "Optional" )
    
    update=$( curl https://cp.dnsmadeeasy.com/servlet/updateip?username=$username@$hostname&password=$password&id=$optional&ip=$real_ip )
    scheme=$( echo "curl https://cp.dnsmadeeasy.com/servlet/updateip?username=$username@$hostname&password=$password&id=$optional&ip=$real_ip" )
}


function duckdns()
{
    hostname=$( _helpDefaultRead "Hostname" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl -s -k https://www.duckdns.org/update?domains=$hostname&token=$password&ip=$real_ip )
    scheme=$( echo "curl -s -k https://www.duckdns.org/update?domains=$hostname&token=$password&ip=$real_ip" )
    
    set_plist
}

function dyn()
{
    hostname=$( _helpDefaultRead "Hostname" )
    username=$( _helpDefaultRead "Login" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl -4 -s "https://$username:$password@members.dyndns.org/nic/update?hostname=$hostname&myip=$real_ip" )
    scheme=$( echo "curl -4 -s \"https://$username:$password@members.dyndns.org/nic/update?hostname=$hostname&myip=$real_ip\"" )
    
    set_plist
}

function easydns()
{
    hostname=$( _helpDefaultRead "Hostname" )
    username=$( _helpDefaultRead "Login" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl --silent --user "$username:$password" https://members.easydns.com/dyn/dyndns.php?wildcard=off&hostname=$hostname&myip=$real_ip )
    scheme=$( echo "curl --silent --user \"$username:$password\" https://members.easydns.com/dyn/dyndns.php?wildcard=off&hostname=$hostname&myip=$real_ip" )
    
    set_plist
}

function freedns()
{
    hostname=$( _helpDefaultRead "Hostname" )
    username=$( _helpDefaultRead "Login" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl https://$username:$password@freedns.afraid.org/nic/update?hostname=$hostname&myip=$real_ip )
    scheme=$( echo "https://$username:$password@freedns.afraid.org/nic/update?hostname=$hostname&myip=$real_ip" )
    
    set_plist
}

function google()
{
    hostname=$( _helpDefaultRead "Hostname" )
    username=$( _helpDefaultRead "Login" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl https://$username:$password@domains.google.com/nic/update?hostname=$hostname )
    scheme=$( echo "curl https://$username:$password@domains.google.com/nic/update?hostname=$hostname" )
    
    set_plist
}

function hurricane()
{
    hostname=$( _helpDefaultRead "Hostname" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl https://dyn.dns.he.net/nic/update?hostname=$hostname&password=$password&myip=$real_ip )
    scheme=$( echo "https://dyn.dns.he.net/nic/update?hostname=$hostname&password=$password&myip=$real_ip" )
    
    set_plist
}

function noip()
{
    hostname=$( _helpDefaultRead "Hostname" )
    username=$( _helpDefaultRead "Login" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl -s -k -u $username:$password "https://dynupdate.no-ip.com/nic/update?hostname=$hostname&myip=$real_ip" )
    scheme=$( echo "curl -s -k -u $username:$password \"https://dynupdate.no-ip.com/nic/update?hostname=$hostname&myip=$real_ip\"" )
    
    set_plist
}

function strato()
{
    hostname=$( _helpDefaultRead "Hostname" )
    username=$( _helpDefaultRead "Login" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl --silent --show-error --insecure --user $username:$password https://dyndns.strato.com/nic/update?hostname=&hostname )
    scheme=$( echo "curl --silent --show-error --insecure --user $username:$password https://dyndns.strato.com/nic/update?hostname=&hostname" )
    
    set_plist
}

### Tools Section ###
function check_input()
{
    hostname=$( _helpDefaultRead "HostnameTools" )
    check=$( dig +noall +answer "$hostname" )
    if [[ "$check" == "" ]]; then
        _helpDefaultWriteBool YES "WrongHost"
    else
        _helpDefaultWriteBool NO "WrongHost"
    fi
}

function show_ip()
{
    hostname=$( _helpDefaultRead "HostnameTools" )
    dig +short "$hostname"
}

function ping_host()
{
    hostname=$( _helpDefaultRead "HostnameTools" )
    ping -c 3 "$hostname"
}

function dig_host()
{
    hostname=$( _helpDefaultRead "HostnameTools" )
    dig "$hostname"
}

function whois_host()
{
    hostname=$( _helpDefaultRead "HostnameTools" )
    whois "$hostname"
}

$1
exit 0


