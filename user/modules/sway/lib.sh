#!/usr/bin/env bash

current_workspace() {
  swaymsg -t get_workspaces | jq '.[] | select(.focused==true) | .name'
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
fi
