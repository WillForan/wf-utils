#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# disable/enable slack account
#

import pydbus
import re

bus = pydbus.SessionBus()
purple = bus.get(
    "im.pidgin.purple.PurpleService",
    "/im/pidgin/purple/PurpleObject")


for acc_id in purple.PurpleAccountsGetAllActive():
    name = purple.PurpleAccountGetUsername(acc_id)
    proto = purple.PurpleAccountGetProtocolName(acc_id)
    if re.match('Slack', proto):
        print(name)
        print(proto)
        purple.PurpleAccountSetEnabled(acc_id, "Pidgin", False)
        purple.PurpleAccountSetEnabled(acc_id, "Pidgin", True)
