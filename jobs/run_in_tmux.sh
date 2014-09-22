#!/bin/bash
function runMatlabScriptInWindow {
	tmux send-keys -t matlab:$2 "matlab -nodesktop -nojvm -r $1" C-m
}

matlabScript=$1
nRun=$2

sup=$(($nRun-1))
for i in $(eval echo {0..$sup})
do
	cnt=$(($i+1))
	if [[ $i -eq 0 ]]
	then
		echo "$cnt/$nRun"
		echo "Starting matlab..."
		echo "$matlabScript"
		tmux start-server
		tmux new-session -d -s matlab -n run$i
		runMatlabScriptInWindow $matlabScript $i
	else
		echo "$cnt/$nRun"
		echo "Starting matlab..."
		tmux new-window -t matlab:$i -n run$i
		runMatlabScriptInWindow $matlabScript $i
	fi
done

#attach to the session
tmux select-window -t matlab:run0
tmux attach-session -t matlab