#!/usr/bin/env bash

# 2017-07-17 -- docker probably has a idomatic way to do this
#               should probably be in runit otherwise

docker ps | grep davmail -q && exit 0
docker run -p1143:1143 -v ~/.davmail.properties:/etc/davmail/davmail.properties jberrenberg/davmail
