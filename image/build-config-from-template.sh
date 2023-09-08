#!/bin/bash

# check to make sure that the arguments are passed in correctly
if [ "$#" -lt 2 ]; then
    echo "syntax: ./build-config-from-template.sh <template> <output-config>"
    exit 1
fi

template="$1"
config="$2"

# check to make sure that the template file exists
if [ ! -f "$template" ]; then
    echo "template file $template not found"
    exit 2
fi

# check to make sure that we don't overwrite an exsiting config file
if [ -e "$config" ]; then
    echo "config file $config already exists; won't overwrite"
    exit 3
fi

cp $template $config

# Escapes a value so that sed can use it for replacement.
# For example, if you want to replace DESTINATION with "/photos", you have to escape the slash before passing it to sed.
# From https://stackoverflow.com/a/2705678/22480693
function sed_escape() {
    ESCAPED=$(printf '%s\n' "$1" | sed -e 's/[\/&]/\\&/g')
}


function process_envar() {
    envar=$1
    default="$2"

    if [[ -z "${!envar}" ]]; then
        if [[ -z "${default}" ]]; then
            echo "no envar $envar specified and no default exists; removing line from config $config"
            sed -i "/${envar}/d" $config
        else
            echo "no envar $envar specified; specifying default value $default in $config"
	    sed_escape "$default"
            sed -i "s/${envar}/${ESCAPED}/g" $config
	fi
    else
        echo "substituting value ${!envar} for ${envar} in config $config"
	sed_escape "${!envar}"
        sed -i "s/${envar}/${ESCAPED}/g" $config
    fi
}

process_envar "SB_API_KEY"
process_envar "SB_API_SECRET"
process_envar "SB_USER_TOKEN"
process_envar "SB_USER_SECRET"
process_envar "SB_DESTINATION" "/photos"
process_envar "SB_FILE_NAMES"
process_envar "SB_USE_METADATA_TIMES"
process_envar "SB_FORCE_METADATA_TIMES"
process_envar "SB_WRITE_CSV"
process_envar "SB_FORCE_VIDEO_DOWNLOAD"
process_envar "SB_CONCURRENT_ALBUMS"
process_envar "SB_CONCURRENT_DOWNLOADS"

exit 0
