#!/bin/sh

killall polybar

polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched."

# vim: et ts=2 sw=2 sts=2 ai si ft=sh
