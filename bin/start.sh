#!/bin/sh

elixir --cookie ${NODE_COOKIE} --name "simple-budget@${POD_IP}" -S mix phx.server
