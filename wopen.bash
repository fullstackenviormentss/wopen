#!/bin/bash
#
# wopen -- command line URL opener with autocomplete
#
# Copyright (C) 2012 Mher Movsisyan <mher.movsisyan@gmail.com>
# Distributed under the GNU General Public License, version 2.0.

WOPEN_CONFIG_FILE="$HOME/.wopen"
WOPEN_HISTORY_FILE="$HOME/.wopen_history"
WOPEN_VERSION="0.1.0"

_wopen_usage()
{
	echo "Usage: wopen [options] URL"
	echo "   Options:"
    echo "      -c: clear URL history"
    echo "      -a NAME: remember URL with alias NAME"
    echo "      -v: print version info"
    echo "      -h: print this message"
}

wopen()
{
    local clear alias

    # POSIX variable, reset in case getopts has been used previously
    OPTIND=1

    while getopts :hvca: OPT; do
        case "$OPT" in
            h)
                _wopen_usage
                return 0
                ;;
            v)
                echo "wopen version ${WOPEN_VERSION}"
                return 0
                ;;
            c)
                clear=1
                ;;
            a)
                alias=$OPTARG
                ;;
            ?)
                _wopen_usage
                return 1
                ;;
        esac
    done

    shift `expr $OPTIND - 1`

    if [[ $# -eq 0 && ! $clear ]]; then
        _wopen_usage
        return 1
    fi

    if [ $clear ]; then
        cat /dev/null > $WOPEN_HISTORY_FILE
    fi

    if [ $# -eq 0 ]; then
        return 0
    fi

    url=$@
    source $WOPEN_CONFIG_FILE
    if [ ${!url} ]; then
        url=${!url}
    fi

    if [[ ! $url == http* ]]; then
        url="http://$url"
    fi
    
    browser="firefox" && [[ "$OSTYPE" == darwin* ]]  && browser="open"
    ${browser} $url

    echo "$@">> $WOPEN_HISTORY_FILE

    if [ $alias ]; then
        echo "$alias=$@" >> $WOPEN_CONFIG_FILE
    fi
}

_wopen() 
{
    local cur urls history

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    urls=`grep -o -e "^[^=]*" $WOPEN_CONFIG_FILE`
    history=`cat $WOPEN_HISTORY_FILE`

    if [[ ${cur} == .* ]]; then
        COMPREPLY=( $(compgen -W "${urls}" -- ${cur:1}) )
    else
        COMPREPLY=( $(compgen -W "${urls} ${history}" -- ${cur}) )
    fi
}

complete -F _wopen wopen
