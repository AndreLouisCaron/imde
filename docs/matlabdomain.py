#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
    matlabdomain
    ~~~~~~~~~~~~

    MATLAB domain for Sphinx (http://sphinx.pocoo.org/).

    :copyright: Copyright 2011, André Caron
    :copyright: Copyright 2011, André Caron
    :license: BSD, see LICENSE for details.
"""

  # python standard libary.
import re
import string
import sys

  # docutils api.
from docutils import nodes
from docutils.parsers.rst import directives

  # sphinx api.
from sphinx import addnodes
from sphinx.roles import XRefRole
from sphinx.locale import l_, _
from sphinx.directives import ObjectDescription
from sphinx.domains import Domain, ObjType, Index
from sphinx.util.compat import Directive
from sphinx.util.nodes import make_refnode
from sphinx.util.docfields import Field, TypedField

  # RE to split at word boundaries
wsplit_re = re.compile(r'(\W+)')

  # REs for MATLAB signatures
mat_func_sig_re = re.compile(
    r'''^(?:\[(.*?)\]\s*=)?\s*  # return value(s)
         (?:(\w+)\.)?           # toolbox name
         (\w+)           \s*    # thing name
         (?:\((.*)\))?$         # optional: arguments
         ''', re.VERBOSE)
#  (?[(.+?)]\s*=)? \s*    # return value(s)
#          ([\w.]*:)?      \s*    # toolbox name
mat_retval_re = re.compile(r'([\[\],])')    # split at '[', ']' and ','
mat_paramlist_re = re.compile(r'([\(\),])') # split at '(', ')' and ','

def split_paramlist ():
    pass

class MATLABObject(ObjectDescription):
    """
    Description of a MATLAB language object.
    """

    doc_field_types = [
        TypedField('parameter', label=l_('Parameters'),
                   names=('param', 'parameter', 'arg', 'argument'),
                   typerolename='type', typenames=('type',)),
        Field('returnvalue', label=l_('Returns'), has_arg=False,
              names=('returns', 'return')),
        Field('returntype', label=l_('Return type'), has_arg=False,
              names=('rtype',)),
    ]

    def _add_signature_prefix(self, signode):
        if self.objtype != 'function':
            sig_prefix = self.objtype + ' '
            signode += addnodes.desc_annotation(sig_prefix, sig_prefix)

    def needs_arglist(self):
        return self.objtype == 'function'

    def handle_signature(self, sig, signode):
        return self._handle_function_signature(sig, signode)

    def _resolve_toolbox_name(self, signode, modname, name):
          # if toolbox name is unspecified, use default toolbox as defined
          # using 'current-toolbox' directive.
        if not modname:
            modname = self.options.get(
                'toolbox', self.env.temp_data.get('mat:toolbox', ''))
          # prefix the name with the toolbox name.
        name_prefix = ''
        if modname:
            name_prefix = modname + '.'
        fullname = name_prefix + name
          # register the symbol.
        signode['toolbox'] = modname
        signode['fullname'] = fullname
          # define document nodes for the signature.
        self._add_signature_prefix(signode)
        signode += addnodes.desc_addname(name_prefix, name_prefix)
        signode += addnodes.desc_name(name, name)
          # return fully qualified symbol name.
        return fullname

    def _handle_function_signature(self, sig, signode):
          # extract parts of the signature.
        m = mat_func_sig_re.match(sig)
        if m is None:
            raise ValueError
        retann, toolbox, name, arglist = m.groups()
          # resolve full function name.
        fullname = self._resolve_toolbox_name(signode, toolbox, name)
          # handle (absence of) arguments list.
        if not arglist:
            if self.needs_arglist():
                # for callables, add an empty parameter list
                signode += addnodes.desc_parameterlist()
            if retann:
                signode += addnodes.desc_returns(retann, retann)
            if self.objtype == 'function':
                return fullname + '/0'
            return fullname
        signode += addnodes.desc_parameterlist()
        stack = [signode[-1]]
        counters = [0, 0]
        for token in mat_paramlist_re.split(arglist):
            if token == '[':
                opt = addnodes.desc_optional()
                stack[-1] += opt
                stack.append(opt)
            elif token == ']':
                try:
                    stack.pop()
                except IndexError:
                    raise ValueError
            elif not token or token == ',' or token.isspace():
                pass
            else:
                token = token.strip()
                stack[-1] += addnodes.desc_parameter(token, token)
                if len(stack) == 1:
                    counters[0] += 1
                else:
                    counters[1] += 1
        if len(stack) != 1:
            raise ValueError
        if not counters[1]:
            fullname = '%s/%d' % (fullname, counters[0])
        else:
            fullname = '%s/%d..%d' % (fullname, counters[0], sum(counters))
        if retann:
            signode += addnodes.desc_returns(retann, retann)
        return fullname

    def _get_index_text(self, name):
        if self.objtype == 'function':
            return _('%s (MATLAB function)') % name
        else:
            return ''

    def add_target_and_index(self, name, sig, signode):
        if name not in self.state.document.ids:
            signode['names'].append(name)
            signode['ids'].append(name)
            signode['first'] = (not self.names)
            self.state.document.note_explicit_target(signode)
            if self.objtype =='function':
                finv = self.env.domaindata['mat']['functions']
                fname, arity = name.split('/')
                if '..' in arity:
                    first, last = map(int, arity.split('..'))
                else:
                    first = last = int(arity)
                for arity_index in range(first, last+1):
                    if fname in finv and arity_index in finv[fname]:
                        self.env.warn(
                            self.env.docname,
                            ('duplicate MATLAB function description'
                             'of %s, ') % name +
                            'other instance in ' +
                            self.env.doc2path(finv[fname][arity_index][0]),
                            self.lineno)
                    arities = finv.setdefault(fname, {})
                    arities[arity_index] = (self.env.docname, name)
            else:
                oinv = self.env.domaindata['mat']['objects']
                if name in oinv:
                    self.env.warn(
                        self.env.docname,
                        'duplicate MATLAB object description of %s, ' % name +
                        'other instance in ' + self.env.doc2path(oinv[name][0]),
                        self.lineno)
                oinv[name] = (self.env.docname, self.objtype)

        indextext = self._get_index_text(name)
        if indextext:
            self.indexnode['entries'].append(('single', indextext, name, name))


class MATLABToolbox(Directive):
    """
    Directive to mark description of a new toolbox.
    """

    has_content = False
    required_arguments = 1
    optional_arguments = 0
    final_argument_whitespace = False
    option_spec = {
        'platform': lambda x: x,
        'synopsis': lambda x: x,
        'noindex': directives.flag,
        'deprecated': directives.flag,
    }

    def run(self):
        env = self.state.document.settings.env
        modname = self.arguments[0].strip()
        noindex = 'noindex' in self.options
        env.temp_data['mat:toolbox'] = modname
        env.domaindata['mat']['modules'][modname] = \
            (env.docname, self.options.get('synopsis', ''),
             self.options.get('platform', ''), 'deprecated' in self.options)
        targetnode = nodes.target('', '', ids=['toolbox-' + modname], ismod=True)
        self.state.document.note_explicit_target(targetnode)
        ret = [targetnode]
        # XXX this behavior of the toolbox directive is a mess...
        if 'platform' in self.options:
            platform = self.options['platform']
            node = nodes.paragraph()
            node += nodes.emphasis('', _('Platforms: '))
            node += nodes.Text(platform, platform)
            ret.append(node)
        # the synopsis isn't printed; in fact, it is only used in the
        # modindex currently
        if not noindex:
            indextext = _('%s (toolbox)') % modname
            inode = addnodes.index(entries=[('single', indextext,
                                             'toolbox-' + modname, modname)])
            ret.append(inode)
        return ret

class MATLABCurrentToolbox(Directive):
    """
    This directive is just to tell Sphinx that we're documenting
    stuff in toolbox foo, but links to toolbox foo won't lead here.
    """

    has_content = False
    required_arguments = 1
    optional_arguments = 0
    final_argument_whitespace = False
    option_spec = {}

    def run(self):
        env = self.state.document.settings.env
        modname = self.arguments[0].strip()
        if modname == 'None':
            env.temp_data['mat:toolbox'] = None
        else:
            env.temp_data['mat:toolbox'] = modname
        return []

class MATLABXRefRole(XRefRole):
    def process_link(self, env, refnode, has_explicit_title, title, target):
        refnode['mat:toolbox'] = env.temp_data.get('mat:toolbox')
        if not has_explicit_title:
            title = title.lstrip(':')   # only has a meaning for the target
            target = target.lstrip('~') # only has a meaning for the title
            # if the first character is a tilde, don't display the toolbox/class
            # parts of the contents
            if title[0:1] == '~':
                title = title[1:]
                colon = title.rfind(':')
                if colon != -1:
                    title = title[colon+1:]
        return title, target

class MATLABToolboxIndex(Index):
    """
    Index subclass to provide the MATLAB toolbox index.
    """

    name = 'modindex'
    localname = l_('MATLAB Toolbox Index')
    shortname = l_('modules')

    def generate(self, docnames=None):
        content = {}
        # list of prefixes to ignore
        ignores = self.domain.env.config['modindex_common_prefix']
        ignores = sorted(ignores, key=len, reverse=True)
        # list of all toolboxes, sorted by toolbox name
        toolboxes = sorted(self.domain.data['modules'].iteritems(),
                         key=lambda x: x[0].lower())
        # sort out collapsable toolboxes
        prev_modname = ''
        num_toplevels = 0
        for modname, (docname, synopsis, platforms, deprecated) in toolboxes:
            if docnames and docname not in docnames:
                continue

            for ignore in ignores:
                if modname.startswith(ignore):
                    modname = modname[len(ignore):]
                    stripped = ignore
                    break
            else:
                stripped = ''

            # we stripped the whole toolbox name?
            if not modname:
                modname, stripped = stripped, ''

            entries = content.setdefault(modname[0].lower(), [])

            package = modname.split(':')[0]
            if package != modname:
                # it's a subtoolbox
                if prev_modname == package:
                    # first subtoolbox - make parent a group head
                    entries[-1][1] = 1
                elif not prev_modname.startswith(package):
                    # subtoolbox without parent in list, add dummy entry
                    entries.append([stripped + package, 1, '', '', '', '', ''])
                subtype = 2
            else:
                num_toplevels += 1
                subtype = 0

            qualifier = deprecated and _('Deprecated') or ''
            entries.append([stripped + modname, subtype, docname,
                            'toolbox-' + stripped + modname, platforms,
                            qualifier, synopsis])
            prev_modname = modname

        # apply heuristics when to collapse modindex at page load:
        # only collapse if number of toplevel toolboxes is larger than
        # number of subtoolboxes
        collapse = len(toolboxes) - num_toplevels < num_toplevels

        # sort by first letter
        content = sorted(content.iteritems())

        return content, collapse

class MATLABDomain(Domain):
    """MATLAB language domain."""
    name = 'mat'
    label = 'MATLAB'
    object_types = {
        'function': ObjType(l_('function'), 'function'),
        'toolbox' : ObjType(l_('toolbox' ), 'toolbox'),
    }
    directives = {
        'function':        MATLABObject,
        'toolbox':         MATLABToolbox,
        'current-toolbox': MATLABCurrentToolbox,
    }
    roles = {
        'fn' : MATLABXRefRole(),
        'tb':  MATLABXRefRole(),
    }
    initial_data = {
        'objects'  : {}, # fullname -> docname, objtype
        'functions': {}, # fullname -> arity -> (targetname, docname)
        'modules': {}, # modname -> docname, synopsis, platform, deprecated
    }
    indices = [
        MATLABToolboxIndex,
    ]

    def clear_doc(self, docname):
        for fullname, (fn, _) in self.data['objects'].items():
            if fn == docname:
                del self.data['objects'][fullname]
        for modname, (fn, _, _, _) in self.data['modules'].items():
            if fn == docname:
                del self.data['modules'][modname]
        for fullname, funcs in self.data['functions'].items():
            for arity, (fn, _) in funcs.items():
                if fn == docname:
                    del self.data['functions'][fullname][arity]
            if not self.data['functions'][fullname]:
                del self.data['functions'][fullname]

    def _find_obj(self, env, modname, name, objtype, searchorder=0):
        """
        Find a Python object for "name", perhaps using the given toolbox and/or
        classname.
        """
        if not name:
            return None, None
        if ":" not in name:
            name = "%s:%s" % (modname, name)

        if name in self.data['objects']:
            return name, self.data['objects'][name][0]

        if '/' in name:
            fname, arity = name.split('/')
            arity = int(arity)
        else:
            fname = name
            arity = -1
        if fname not in self.data['functions']:
            return None, None

        arities = self.data['functions'][fname]
        if arity == -1:
            arity = min(arities)
        if arity in arities:
             docname, targetname = arities[arity]
             return targetname, docname
        return None, None

    def resolve_xref(self, env, fromdocname, builder,
                     typ, target, node, contnode):
        if typ == 'mod' and target in self.data['modules']:
            docname, synopsis, platform, deprecated = \
                self.data['modules'].get(target, ('','','', ''))
            if not docname:
                return None
            else:
                title = '%s%s%s' % ((platform and '(%s) ' % platform),
                                    synopsis,
                                    (deprecated and ' (deprecated)' or ''))
                return make_refnode(builder, fromdocname, docname,
                                    'toolbox-' + target, contnode, title)
        else:
            modname = node.get('mat:toolbox')
            searchorder = node.hasattr('refspecific') and 1 or 0
            name, obj = self._find_obj(env, modname, target, typ, searchorder)
            if not obj:
                return None
            else:
                return make_refnode(builder, fromdocname, obj, name,
                                    contnode, name)

    def get_objects(self):
        for refname, (docname, type) in self.data['objects'].iteritems():
            yield (refname, refname, type, docname, refname, 1)


def setup(app):
    app.add_domain(MATLABDomain)
