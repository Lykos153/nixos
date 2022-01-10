#!/usr/bin/env bash

current_workspace() {
  swaymsg -t get_workspaces | jq '.[] | select(.focused==true) | .name'
}

current_output() {
  swaymsg -t get_outputs | jq '.[] | select(.focused==true) | .name'
}

next_workspace() {
  # set -x
  workspaces="$(swaymsg -t get_workspaces | jq ".[] | select(.output==$(current_output)) | .name")"
  cur="$(current_workspace)"
  echo_next="0"
  while IFS= read -r workspace; do
    if [ "$echo_next" -eq 1 ] && [ -n "$workspace" ]; then
      swaymsg workspace number "$workspace"
      return
    elif [ "$workspace" = "$cur" ]; then
      echo_next=1
    fi
  done <<< "$workspaces"
}

previous_workspace() {
  # set -x
  workspaces="$(swaymsg -t get_workspaces | jq ".[] | select(.output==$(current_output)) | .name")"
  cur="$(current_workspace)"
  last_workspace=""
  while IFS= read -r workspace; do
    if [ "$workspace" = "$cur" ] && [ -n "$last_workspace" ]; then
        swaymsg workspace number "$last_workspace"
      return
    else
      last_workspace="$workspace"
    fi
  done <<< "$workspaces"
}

other_output() {
  swaymsg -t get_outputs | jq ".[] | select(.current_workspace!=$(current_workspace) and .active==true) | .name"
}

workspace_to_other_output() {
  swaymsg move workspace to output "$(other_output)"
}

get_current_layout() {
  swaymsg -t get_tree | jq -r 'recurse(.nodes[];.nodes!=null)|select(.nodes[].focused).layout'
}


sourced=0
if [ -n "$ZSH_EVAL_CONTEXT" ]; then 
  case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "$KSH_VERSION" ]; then
  [ "$(cd $(dirname -- $0) && pwd -P)/$(basename -- $0)" != "$(cd $(dirname -- ${.sh.file}) && pwd -P)/$(basename -- ${.sh.file})" ] && sourced=1
elif [ -n "$BASH_VERSION" ]; then
  (return 0 2>/dev/null) && sourced=1 
else # All other shells: examine $0 for known shell binary filenames
  # Detects `sh` and `dash`; add additional shell filenames as needed.
  case ${0##*/} in sh|dash) sourced=1;; esac
fi

if [ ${sourced} -eq 0 ]; then
  if [ "$1" == "container-to-other-output" ]; then
    swaymsg "mark switch_x; move container to output $(other_output); [con_mark="switch_x"] focus; unmark switch_x"
  elif [ "$1" == "workspace-to-other-output" ]; then
    workspace_to_other_output
  elif [ "$1" == "switch-outputs" ]; then
    other_workspace=$(swaymsg -t get_outputs | jq ".[] | select(.name==$(other_output)) | .current_workspace")
    workspace_to_other_output
    swaymsg workspace $other_workspace
    workspace_to_other_output
  elif [ "$1" == "scrollwheel_focus" ]; then
    if [ "$(get_current_layout)" == "splitv" ]; then
      if [ "$2" == "up" ]; then
        swaymsg focus up
      else
        swaymsg focus down
      fi
    else
      if [ "$2" == "up" ]; then
        swaymsg focus left
      else
        swaymsg focus right
      fi
    fi
  elif [ "$1" == "next_workspace" ]; then
    next_workspace
  elif [ "$1" == "previous_workspace" ]; then
    previous_workspace
  fi
fi