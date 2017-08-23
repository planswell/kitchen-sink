#!/bin/bash
# Ensure exit codes other than 0 fail the build
set -e
# Check for asdf
if ! asdf | grep version; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf;
fi
# Add plugins for asdf
asdf plugin-list | grep -q erlang || asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-list | grep -q elixir || asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install
# Get dependencies
yes | mix deps.get
yes | mix local.rebar
# Exit successfully
exit 0
