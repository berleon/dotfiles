#!/usr/bin/env python3

import socket
import subprocess
import sys
import os


def get_clipboard_command():
    """Determine the appropriate clipboard command based on OS and display server."""
    if sys.platform == "darwin":
        return ["pbcopy"]

    # Check for Wayland
    wayland_display = os.environ.get("WAYLAND_DISPLAY")
    xdg_session_type = os.environ.get("XDG_SESSION_TYPE")

    if wayland_display or xdg_session_type == "wayland":
        # Try wl-copy first, fallback to xclip if not available
        try:
            subprocess.run(
                ["wl-copy", "--version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE
            )
            return ["wl-copy"]
        except FileNotFoundError:
            return ["xclip", "-selection", "clipboard"]
    else:
        # X11 or unknown, use xclip
        return ["xclip", "-selection", "clipboard"]


CLIP_COMMAND = get_clipboard_command()


s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(("localhost", int(sys.argv[1])))
s.listen(1)

while True:
    conn, addr = s.accept()
    data = conn.recv(1024)
    text = b""
    while data:
        text += data
        data = conn.recv(1024)
    # print("Received clipboard data from remote host:")
    # print(text.decode("utf-8"))
    # print()
    p = subprocess.Popen(CLIP_COMMAND, stdin=subprocess.PIPE)
    p.communicate(input=text)
    conn.close()
