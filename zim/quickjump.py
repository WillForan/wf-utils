# -*- coding: utf-8 -*-

# Copyright 2010-2014 Jaap Karssenberg <jaap.karssenberg@gmail.com>

import sys
import gtk



import zim
from zim.plugins import PluginClass
from zim.main import GtkCommand
from zim.notebook import resolve_notebook,get_notebook_list  # find notebook
from zim.main import ZIM_APPLICATION       # launch page


import logging
logger = logging.getLogger('zim.plugins.quickjump')


usagehelp = '''\
usage: zim --plugin quicknote :Path:To:Page [notebook=firstinlist]
'''
class QuickJumpPlugin(PluginClass):
	plugin_info = {
		'name': _('Quick Jump'), # T: plugin name
		'author': 'Will Foran',
		'description': _('''\
Command line utility to quickly jump to a page. 
Use with e.g. find + rofi:
'''), # T: plugin description
	}

class QuickJumpPluginCommand(GtkCommand):

	def parse_options(self, *args):
                if len(args)<=0 or args[0] in ['-help','-h','--help']:
                  print(usagehelp)
                  sys.exit(1)
		self.opts['path']     = args[0]
		if len(args) > 1: self.opts['notebook'] = args[1]

        # when zim is running this is exectued in gtk.main  
        # so logging goes there and sys.exit will kill everything!
	def run(self):
                if 'notebook' in self.opts.keys():
		  notebook = resolve_notebook(self.opts['notebook'])
                else:
		  notebook = get_notebook_list()[0]
                if not notebook or not notebook.uri: 
                   logger.warn('QuickJump could not find notebook')
                   return
                ZIM_APPLICATION.run('--gui', notebook.uri, self.opts['path'])
                
