# WF utils
A small mostly bash set of scripts to scratch at itches loosely grouped into directories by function.

## i3
workspace management
  * `i3/i3-back_within_output` -- a daemon that tracks history of workspace switches within a single output (monitor) and can cycle through them
  * `i3/i3-ws-menu` -- menu with all workspaces (move/create, rename)
  * `i3/swapscreens.py` -- swap workspaces between two outputs
  * `i3/zim-i3-go.bash` -- used as a custom `zim wiki` tool, parses notebook page title and text to go to workspace and open terminals @ `host:/dir` there

## mail
 * `mail/redirmail.bash` -- lighter `afew -m` for moving mail in `mailbox` format matching `notmuch` queries
 * `mail/sendmarkdown.bash`-- tool to render markdown into multipart email (used with `mutt`)

## other (not working)
 * `savemulti.pl`     -- takes the output of head and saves to the corresponding files. Not practical
 * `virtual_disp/add` -- an attempt to increase display surface by creating an unattached monitor/screen to send to a phone. The phone's screen would then be managed by the computers window manager.  NOT WORKING
