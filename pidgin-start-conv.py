#!/usr/bin/python
# coding=utf8

import sys
import dbus
import re

bus = dbus.SessionBus()
bus_obj = bus.get_object(
    "im.pidgin.purple.PurpleService",
    "/im/pidgin/purple/PurpleObject")
purple = dbus.Interface(bus_obj, "im.pidgin.purple.PurpleInterface")
accounts = {}
for acc_id in purple.PurpleAccountsGetAllActive():
    accounts[acc_id] = {
        'name': purple.PurpleAccountGetUsername(acc_id),
        'proto': purple.PurpleAccountGetProtocolName(acc_id)}

buddies = {}
for acc_id in accounts:
    accntname = accounts[acc_id]['name']

    if re.match('.*lncd.slack.com', accntname):
        buddies['RAs'] = {
            'acc_id': acc_id,
            'acc_nm': accntname,
            'name': 'RAs',
            'alias': 'RAs'}
    for buddy_id in purple.PurpleFindBuddies(acc_id, ''):
        # only show online buddies. not useful for slack
        # #if not purple.PurpleBuddyIsOnline(buddy_id):
        # #    continue

        buddy_name = purple.PurpleBuddyGetName(buddy_id)
        buddy_alias = buddy_name[0:buddy_name.find('@')]
        actual_alias = purple.PurpleBuddyGetAlias(buddy_id)

        # restrict non slack to family
        if not re.match('.*slack.com', accntname) and \
           buddy_alias not in [
                   'seeforan',
                   'emily.mente',
                   'roseforan22',
                   '0cevxsqzkayum2wigyufx8sda5']:
            continue

        buddies[buddy_alias] = {
            'acc_id': acc_id,
            'acc_nm': accntname,
            'name'  : buddy_name,
            'alias' : actual_alias}

if len(sys.argv) == 2:
    if sys.argv[1].startswith('-h'):
        sys.stdout.write(
            'usage: {0} [-h|--help] [buddy-alias]\n'.format(
                sys.argv[0]))
    else:
        buddy = buddies[sys.argv[1]]
        purple.PurpleConversationNew(1, buddy['acc_id'], buddy['name'])
else:
    for buddy_alias in buddies:
        sys.stdout.write('{1}@{2}\t{0}\n'.format(buddy_alias,buddies[buddy_alias]['alias'],\
                buddies[buddy_alias]['acc_nm']))
