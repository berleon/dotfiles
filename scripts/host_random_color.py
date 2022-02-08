#! /usr/bin/env python3

import platform
import hashlib
import sys

hostname = platform.node()
colors = list(range(0, 16)) + list(range(17, 232))
m = hashlib.sha1()
m.update(hostname.encode())
idx = bytearray(m.digest())[0] % len(colors)
sys.stdout.write("{:0>3}".format(colors[idx]))
