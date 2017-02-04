if !exists('g:refheap_token')
  let g:refheap_token = ''
endif

if !exists('g:refheap_username')
  let g:refheap_username = ''
endif

if !exists('g:refheap_api_url')
  let g:refheap_api_url = 'https://www.refheap.com/api/'
endif

if !exists('g:refheap_use_register')
  let g:refheap_use_register = 0
endif

if !exists('g:refheap_register')
  let g:refheap_register = 'r'
endif

" I didn't come up with this, but it seems to work for getting the currently
" selected region.
function! GetVisualSelection()
  try
    let a_save = @a
    silent! normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

" This is easily the most insane I've ever written on purpose.
function! refheap#Refheap(count, line1, line2, ...)
  let lastarg = a:0 == 1 ? ",'" . a:1 . "'" : ''
  execute 'python refheap(' . a:count . ',' . a:line1 . ',' . a:line2 . lastarg . ')'
endfunction

python << EOF

import vim
import json
import urllib
import urllib2

xerox_installed = False
try:
    import xerox
    xerox_installed = True
except:
    pass

REFHEAP_URL = vim.eval('g:refheap_api_url')

LANGUAGES = {
'actionscript': 'ActionScript',
'ada': 'Ada',
'applescript': 'AppleScript',
'apricot': 'Apricot',
'autohotkey': 'Autohotkey',
'autoit': 'AutoIt',
'awk': 'Awk',
'sh': 'Bash',
'bash': 'Bash',
'befunge': 'Befunge',
'blitzmax': 'BlitzMax',
'boo': 'Boo',
'brainfuck': 'Brainfuck',
'c': 'C',
'cs': 'C#',
'cpp': 'C++',
'ceylon': 'Ceylon',
'clojure': 'Clojure',
'cmake': 'CMake',
'cobol': 'COBOL',
'coffeescript': 'CoffeeScript',
'lisp': 'Common Lisp',
'coq': 'Coq',
'css': 'CSS',
'cucumber': 'Cucumber',
'cython': 'Cython',
'd': 'D',
'delphi': 'Delphi',
'diff': 'Diff',
'dtd': 'DTD',
'dylan': 'Dylan',
'elixir': 'Elixir',
'elisp': 'Emacs ',
'erlang': 'Erlang',
'fsharp': 'F#',
'factor': 'Factor',
'fancy': 'Fancy',
'felix': 'Felix',
'fortran': 'Fortran',
'gas': 'Gas',
'glsl': 'GLSL',
'go': 'Go',
'groovy': 'Groovy',
'haml': 'HAML',
'haskell': 'Haskell',
'haxe': 'haXe',
'html': 'HTML',
'hxml': 'HXML',
'ini': 'INI',
'io': 'Io',
'ioke': 'Ioke',
'java': 'Java',
'javascript': 'Javascript',
'julia': 'Julia',
'kotlin': 'Kotlin',
'latex': 'LaTeX',
'llvm': 'LLVM',
'lua': 'Lua',
'makefile': 'Makefile',
'markdown': 'Markdown',
'matlab': 'Matlab',
'mirah': 'Mirah',
'moocode': 'MOOCode',
'mupad': 'MuPAD',
'mysql': 'MySQL',
'nasm': 'NASM',
'nemerle': 'Nemerle',
'newlisp': 'NewLisp',
'newspeak': 'NewSpeak',
'nimrod': 'Nimrod',
'numpy': 'NumPy',
'objc': 'Objective-C',
'ocaml': 'OCaml',
'ooc': 'ooc',
'perl': 'Perl',
'php': 'PHP',
'text': 'Plain Text',
'postscript': 'PostScript',
'prolog': 'Prolog',
'protobuf': 'Protobuf',
'puppet': 'Puppet',
'python': 'Python',
'r': 'R',
'racket': 'Racket',
'rebol': 'REBOL',
'redcode': 'Redcode',
'rpm': 'RPM ',
'rst': 'rST',
'ruby': 'Ruby',
'rust': 'Rust',
'sass': 'SASS',
'scala': 'Scala',
'scaml': 'Scaml',
'scheme': 'Scheme',
'smali': 'Smali',
'smalltalk': 'Smalltalk',
'sql': 'SQL',
'tcl': 'Tcl',
'tcsh': 'TCSH',
'typescript': 'TypeScript',
'vala': 'Vala',
'vb.net': 'VB.NET',
'verilog': 'Verilog',
'vim': 'VimL',
'xml': 'XML',
'yaml': 'YAML',
'': 'Plain Text'
}

def buffer_contents():
    return '\n'.join(vim.current.buffer)

def selected():
    return vim.eval('GetVisualSelection()')

def refheap_req(text, priv):
    ext = vim.eval('expand("%:e")')
    if ext:
        ext = '.' + ext
    data = {'language': ext,
            'contents': text,
            'private': priv}
    username = vim.eval('g:refheap_username')
    token = vim.eval('g:refheap_token')
    if username and token:
        data['username'] = username
        data['token'] = token
    lang = vim.eval('&filetype')
    if lang in LANGUAGES.keys():
        lang = LANGUAGES[lang]
        data['language'] = lang
    req = urllib2.Request(REFHEAP_URL + "paste", urllib.urlencode(data))
    try:
        res = json.loads(urllib2.urlopen(req).read())['url']
        if xerox_installed and vim.eval('g:refheap_use_register') == '0':
            xerox.copy(res)
            print "Copied " + res + " to your clipboard."
        else:
            vim.eval('setreg(g:refheap_register,"'+res+'")')
            print "Copied " + res + " to vim register."
    except urllib2.HTTPError, e:
        print e.read()

def refheap(count, line1 = None, line2 = None, priv = None):
    if priv == "-p":
        priv = "true"
    else:
        priv = "false"
    if count < 1:
        refheap_req(buffer_contents(), priv)
    else:
        refheap_req(selected(), priv)

EOF
