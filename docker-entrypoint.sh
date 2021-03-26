#!/bin/sh

DEFAULT_HOOKS=/var/lib/zanwe/hooks/default-hooks.yml

exec /usr/local/bin/webhook -verbose -hotreload -hooks=$DEFAULT_HOOKS $@
