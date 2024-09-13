if [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo 'mcf - mindless config reading tool'
    echo 'usage: mcf (command)'
    echo '-----'
    echo '(round brackets) - required'
    echo '[square brackets] - optional'
    echo '-----'
    echo 'del (path) (key) - deletes a key'
    echo 'get (path) (key) [--no-defaults] - echoes the value for the key'
    echo 'set (path) (key) (value) [--no-overwrite] - sets the value for the given key'
elif [ "$1" == "del" ]; then
    if [ "$2" ] && [ "$3" ]; then
        if [ -f $2 ]; then
            sed -i /$3/d $2
            return 0
        else
            echo "file $2 doesn't exist!"
            return 1
        fi
    else
        echo 'invalid syntax! proper usage:'
        echo 'del (path) (key) - deletes a key'
    fi
elif [ "$1" == "get" ]; then
    if [ "$2" ] && [ "$3" ]; then
        if [ ! -f $2 ]; then
            echo "error: file $2 doesn't exist!"
            return 1
        fi
        while IFS="" read -r p || [ -n "$p" ]; do
            line=$(printf '%s\n' "$p")
            if [[ $line:0:1 == '#' ]]; then
                continue
            fi
            if [[ $line =~ $3= ]]; then
                echo "${line#*=}"
                return 0
            fi
        done < $2
        if [ "$4" == '--no-defaults' ]; then
            echo "error: key $3 not found!"
            return 1
        else
            echo '0'
            return 0
        fi
    else
        echo 'invalid syntax! proper usage:'
        echo 'get (path) (key) [--zero-on-failure]'
    fi
elif [ "$1" == "set" ]; then
    if [ "$2" ] && [ "$3" ] && [ "$4" ]; then
        if [ ! -f $2 ]; then
            echo "file $2 doesn't exist!"
            return 1
        fi
        if [ "$5" == '--no-overwrite' ] && [ $(mcrt get $2 $3 > /dev/null) ]; then
            echo "error: key $3 already exists in file $2!"
            return 1
        fi
        sed -i /$3/d $2
        echo "$3=$4" >> $2
        return 0
    else
        echo 'invalid syntax! proper usage:'
        echo 'set (path) (key) (value) [--no-overwrite]'
    fi
elif [ "$1" ]; then
    echo 'invalid command!'
    echo 'try `mcf help` to see available commands.'
else
    echo 'no arguments provided!'
    echo 'try `mcf help` to see available commands.'
fi
