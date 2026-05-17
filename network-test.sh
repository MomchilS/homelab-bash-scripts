#!/bin/bash

# Ensure tmux is installed
if ! command -v tmux &> /dev/null; then
    apt-get update && apt-get install tmux -y
fi

TARGET_DIR="/var/lib/vz/template/iso"
SESSION_NAME="net_test_$(date +%s)"

tmux new-session -d -s "$SESSION_NAME" -c "$TARGET_DIR"

# Pane 1 (Bottom Left): nload
tmux split-window -v -t "$SESSION_NAME"
tmux send-keys -t "$SESSION_NAME":0.1 "nload vmbr0" Enter

# Pane 2 (Bottom Right): ping
tmux split-window -h -t "$SESSION_NAME":0.1
tmux send-keys -t "$SESSION_NAME":0.2 "ping -O 1.1.1.1" Enter

# Pane 3 (Far Right): Automated Kernel Log Watcher
tmux split-window -h -t "$SESSION_NAME":0.2
tmux send-keys -t "$SESSION_NAME":0.3 "dmesg -wT | grep -E 'eth|enp|vmbr|link|bridge'" Enter

# Attach to the session
tmux attach-session -t "$SESSION_NAME"
