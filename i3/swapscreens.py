#!/usr/bin/python2.7

# https://i3wm.org/docs/user-contributed/swapping-workspaces.html
# Author: Sagar Behere
# depends on i3-py (pip install i3-py)  https://github.com/ziberna/i3-py

import i3
# retrieve only active outputs
outputs = filter(lambda output: output['active'], i3.get_outputs())

# set current workspace to output 0
i3.workspace(outputs[0]['current_workspace'])

# ..and move it to the other output.
# outputs wrap, so the right of the right is left ;)
i3.command('move', 'workspace to output right')

# rinse and repeat
i3.workspace(outputs[1]['current_workspace'])
i3.command('move', 'workspace to output right')
