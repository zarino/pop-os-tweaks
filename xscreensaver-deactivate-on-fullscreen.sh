#!/bin/bash

# https://askubuntu.com/a/1131752

# enumerate all the attached screens
displays=""
while read id
do
    displays="$displays $id"
done< <(xvinfo | sed -n 's/^screen #\([0-9]\+\)$/\1/p')

checkFullscreen(){
    # loop through every display looking for a fullscreen window
    for display in $displays
    do
        #get id of active window and clean output
        activ_win_id=`DISPLAY=:0.${display} xprop -root _NET_ACTIVE_WINDOW`
        activ_win_id=${activ_win_id:40:9}

        # Check if Active Window (the foremost window) is in fullscreen state
        isActivWinFullscreen=`DISPLAY=:0.${display} xprop -id $activ_win_id | grep _NET_WM_STATE_FULLSCREEN`
        if [[ "$isActivWinFullscreen" == *NET_WM_STATE_FULLSCREEN* ]];then
            xscreensaver-command -deactivate
        fi
    done
}

while sleep $((30)); do
    checkFullscreen
done

exit 0
