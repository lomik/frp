#!/bin/bash

if [[ ! -z "$FRPC" ]] && [[ ! -z "$FRPS" ]]; then
    echo "frpc and frps are both enabled"
    exit 1
fi

if [[ -z "$FRPC" ]] && [[ -z "$FRPS" ]]; then
    echo "frpc and frps are both disabled"
    exit 1
fi

OUTPUT="[common]
"

if [[ ! -z "$FRPS" ]]; then
    for i in _ {a..z} {A..Z}; do
       for var in `eval echo "\\${!$i@}"`; do
            if [[ "$var" =~ ^FRPS_ ]]; then
                configVar=$(echo "$var" | sed 's/^FRPS_//' | awk '{print tolower($0)}')
                OUTPUT+="${configVar} = ${!var}
"
            fi
       done
    done
fi

if [[ ! -z "$FRPC" ]]; then
    for i in _ {a..z} {A..Z}; do
       for var in `eval echo "\\${!$i@}"`; do
            if [[ "$var" =~ ^FRPC_[^0-9] ]]; then
                configVar=$(echo "$var" | sed 's/^FRPC_//' | awk '{print tolower($0)}')
                OUTPUT+="${configVar} = ${!var}
"
            fi
       done
    done

    for index in `seq 0 1 100`; do
        nameVar="FRPC_${index}_NAME"
        nameValue="${!nameVar}"
        if [ ! -z "$nameValue" ]; then
            OUTPUT+="[${nameValue}]
"
            # find all variables started with FRPC_{$index}_
            prefix="FRPC_${index}_"
            for i in _ {a..z} {A..Z}; do
               for var in `eval echo "\\${!$i@}"`; do
                    if [[ "$var" =~ ^$prefix ]]; then
                        if [[ "$var" != "FRPC_${index}_NAME" ]]; then
                            configVar=$(echo "$var" | sed 's/^FRPC_[0-9]*_//' | awk '{print tolower($0)}')
                            OUTPUT+="${configVar} = ${!var}
"
                        fi
                    fi
               done
            done
        fi
    done
fi

if [ ! -z "$DEBUG" ]; then
    echo "$OUTPUT"
    exit 0
fi


if [[ ! -z "$FRPS" ]]; then
    echo "$OUTPUT" > /opt/frp/frps.ini
    exec /opt/frp/frps -c /opt/frp/frps.ini
fi

if [[ ! -z "$FRPC" ]]; then
    echo "$OUTPUT" > /opt/frp/frpc.ini
    exec /opt/frp/frpc -c /opt/frp/frpc.ini
fi
