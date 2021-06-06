#!/bin/bash
#

ScriptHome=$(echo $HOME)
ScriptTmpPath="$HOME"/.ddm_temp
MY_PATH="`dirname \"$0\"`"
cd "$MY_PATH"
if [ ! -d "$ScriptTmpPath" ]; then
    mkdir "$ScriptTmpPath"
fi
AppName="DynDNS Mate.app"

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

function strato()
{
    hostname=$( _helpDefaultRead "Hostname" )
    username=$( _helpDefaultRead "Login" )
    password=$( _helpDefaultRead "Password" )
    update=$( curl --silent --show-error --insecure --user $username:$password https://dyndns.strato.com/nic/update?hostname=&hostname )
    scheme=$( echo "curl --silent --show-error --insecure --user $username:$password https://dyndns.strato.com/nic/update?hostname=&hostname" )
    
    set_plist
}

$1
exit 0


