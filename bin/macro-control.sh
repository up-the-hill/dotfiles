#!/bin/bash

# Configuration
RECORDING_FILE="/tmp/macro_recording.yml"
PID_FILE="/tmp/macro_record.pid"
REPLAY_PID_FILE="/tmp/macro_replay.pid"

start_recording() {
  if [ -f "$PID_FILE" ]; then
    echo "Already recording."
    exit 1
  fi
  # Using --all to record from all devices takes too long
  # Currently using event24(keyd virtual keyboard) for me, change in future if needed
  # We use setsid to run it in its own session to avoid it being killed by parent.
  setsid libinput record --show-keycodes /dev/input/event24 -o "$RECORDING_FILE" >/dev/null 2>&1 &
  RECORD_PID=$!
  echo "$RECORD_PID" >"$PID_FILE"
  notify-send "Macro" "Recording started..."
}

stop_recording() {
  if [ ! -f "$PID_FILE" ]; then
    echo "Not recording."
    return
  fi
  PID=$(cat "$PID_FILE")
  # Send SIGINT to allow libinput record to finish the YAML file
  kill -SIGINT "$PID"

  # Wait for the process to finish flushing the file
  while kill -0 "$PID" 2>/dev/null; do
    sleep 0.1
  done

  # Remove the last 6 lines (the stop shortcut, Meta+t for me)
  if [ -f "$RECORDING_FILE" ]; then
    head -n -6 "$RECORDING_FILE" >"$RECORDING_FILE.tmp" && mv "$RECORDING_FILE.tmp" "$RECORDING_FILE"
  fi

  rm "$PID_FILE"
  notify-send "Macro" "Recording stopped."
}

stop_replay() {
  if [ ! -f "$REPLAY_PID_FILE" ]; then
    echo "Not replaying."
    return
  fi
  PID=$(cat "$REPLAY_PID_FILE")
  # Kill children (libinput replay) and the script itself
  pkill -P "$PID"
  kill "$PID"
  rm "$REPLAY_PID_FILE"
  notify-send "Macro" "Replay stopped."
}

replay_recording() {
  if [ -f "$REPLAY_PID_FILE" ]; then
    notify-send "Macro" "Already replaying!"
    exit 1
  fi

  local count=$1
  if [ -z "$count" ]; then
    count=$(kdialog --title "Macro Replay" --inputbox "Enter number of repetitions:" "1")
    # If user cancels or enters nothing, default to 0 or exit
    if [ $? -ne 0 ] || [ -z "$count" ]; then
      exit 0
    fi
  fi

  if [ ! -f "$RECORDING_FILE" ]; then
    notify-send "Macro" "No recording found!"
    exit 1
  fi

  echo $$ >"$REPLAY_PID_FILE"
  # Ensure the PID file is removed on exit if not killed
  trap "rm -f $REPLAY_PID_FILE" EXIT

  notify-send "Macro" "Replaying ($count times)..."
  # Replaying usually requires root or input group access
  for ((i = 0; i < count; i++)); do
    libinput replay --once --replay-after=0 "$RECORDING_FILE" >/dev/null 2>&1
  done
  notify-send "Macro" "Replay finished."
}

# Main logic
case "$1" in
toggle)
  if [ -f "$PID_FILE" ]; then
    stop_recording
  else
    start_recording
  fi
  ;;
replay)
  replay_recording "$2"
  ;;
stop)
  if [ -f "$PID_FILE" ]; then
    stop_recording
  fi
  if [ -f "$REPLAY_PID_FILE" ]; then
    stop_replay
  fi
  ;;
*)
  echo "Usage: $0 {toggle|replay [count]|stop}"
  exit 1
  ;;
esac
