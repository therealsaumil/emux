#!/usr/bin/env python

import sys
import subprocess

inbound_port = -1
outbound_port = -1

try:
    add_or_drop = sys.argv[1]
    inbound_port = int(sys.argv[2])
    outbound_port = int(sys.argv[3])
except:
    print 'USAGE: portfwd (add|drop) LOCAL_PORT REMOTE_PORT'
    exit(1)

invalid = False
if not add_or_drop.lower() in ['add', 'drop']:
    print '(add|drop) must be the word \'add\' or \'drop\''
    invalid = True

if not (8000 <= inbound_port <= 8080):
    print 'LOCAL_PORT value must be between 8000 and 8080 (inclusive). Value received: %i' % inbound_port
    invalid = True

if not (0 < outbound_port < 65536):
    print 'REMOTE_PORT value must be between 0 and 65536. Value received: %i' % outbound_port
    invalid = True

if invalid:
    exit(1)

cmd = 'iptables -%s PREROUTING -t nat -i eth0 -p tcp --dport %i -j DNAT --to 192.168.100.2:%i' % (
    'A' if add_or_drop == 'add' else 'D',
    inbound_port,
    outbound_port
)

list_rules = 'iptables -t nat -nL'
current_rules = subprocess.check_output(list_rules.split(' '))
for rule in current_rules.splitlines():
    if 'tcp dpt:%i' % inbound_port in rule:
        print 'Found another rule on that inbound port. Deleting before adding the new one'
        cur_rule_outbound_port = int(rule.split(':')[-1])
        
        drop_cmd = 'iptables -%s PREROUTING -t nat -i eth0 -p tcp --dport %i -j DNAT --to 192.168.100.2:%i' % (
            'D',
            inbound_port,
            cur_rule_outbound_port
        )

        print 'Executing %s' % drop_cmd
        subprocess.check_output(drop_cmd.split(' '))

print 'Executing %s' % cmd
subprocess.check_output(cmd.split(' '))
