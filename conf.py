#!/usr/bin/env python
# -*- coding: utf-8 -*-

  # python standard library.
import os
import sys

  # make sure sphinx extensions can be found.
def relative ( path ):
    return os.path.abspath(os.path.join(os.path.dirname(__file__), path))
sys.path.append(relative('docs'))

  # project information.
project = u'imde: Image Multi-Distortion Estimation'
copyright = u'2011, Univeristé de Sherbrooke'
language = 'en-CA'
version = '0.1.0'
release = '0.1.0'

  # project layout.
source_encoding = 'utf-8-sig'
source_suffix = '.rst'
master_doc = 'index'
templates_path = ['.templates']
exclude_patterns = ['.build','code/mex/*']
html_static_path = ['docs/static']

  # goodies.
extensions = [
  'sphinx.ext.pngmath',
  'matlabdomain',
  ]
html_use_smartypants = True

  # styling issues.
add_function_parentheses = True
add_module_names = True
pygments_style = 'sphinx'
html_theme = 'nature'
html_title = 'Image Multi-Distortion Estimation'
html_show_sourcelink = False
html_show_sphinx = False
html_show_copyright = True
html_sidebars = {
  '**': ['globaltoc.html','relations.html'],
  }
htmlhelp_basename = 'imdedoc'
