if !has('python')
  echo "Refheap requires that your Vim be compiled with +python."
  finish
endif

if !exists('g:refheap_token')
  let g:refheap_token = ''
endif

if !exists('g:refheap_username')
  let g:refheap_username = ''
endif

if !exists('g:refheap_api_url')
  let g:refheap_api_url = 'https://refheap.com/api/'
endif

" I didn't come up with this, but it seems to work for getting the currently
" selected region.
function! GetVisualSelection()
  try
    let a_save = @a
    normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

" Define our commands.
command! -range -nargs=0 RefheapRegion python refheap_region()
command! -range -nargs=0 RefheapRegionPrivate python refheap_region_private()
command! -nargs=0 RefheapBuffer python refheap_buffer()
command! -nargs=0 RefheapBufferPrivate python refheap_buffer_private()

python << EOF

import vim
import json
import urllib
import urllib2
import xerox

REFHEAP_URL = vim.eval('g:refheap_api_url')

LANGUAGES = {"clj": "Clojure",
             "cljs": "Clojure",
             "fy": "Fancy",
             "groovy": "Groovy",
             "factor": "Factor",
             "io": "Io",
             "ioke": "Ioke",
             "lua": "Lua",
             "pl": "Perl",
             "perl": "Perl",
             "py": "Python",
             "rb": "Ruby",
             "mirah": "Duby",
             "tcl": "Tcl",
             "ada": "Ada",
             "c": "C",
             "cpp": "C++",
             "d": "D",
             "dylan": "Dylan",
             "flx": "Felix",
             "fortran": "Fortran",
             "nim": "Nimrod",
             "go": "Go",
             "java": "Java",
             "def": "Modula-2",
             "mod": "Module-2",
             "ooc": "ooc",
             "m": "Objective-C",
             "pro": "Prolog",
             "prolog": "Prolog",
             "scala": "Scala",
             "vala": "Vala",
             "boo": "Boo",
             "cs": "C#",
             "fs": "F#",
             "n": "Nemerle",
             "vb": "VB.NET",
             "lisp": "Common Lisp",
             "erl": "Erlang",
             "hs": "Haskell",
             "lhs": "Literate Haskell",
             "ml": "OCaml",
             "scm": "Scheme",
             "rkt": "Scheme",
             "ss": "Scheme",
             "v": "Verilog",
             "r": "R",
             "abap": "ABAP",
             "applescript": "AppleScript",
             "ahk": "Autohotkey",
             "awk": "Awk",
             "sh": "Bash",
             "bat": "Batch",
             "bf": "Brainfuck",
             "befunge": "Befunge",
             "ns2": "NewSpeak",
             "ps": "PostScript",
             "proto": "Protobuf",
             "r3": "REBOL",
             "st": "Smalltalk",
             "cmake": "CMake",
             "dpatch": "Darcs Patch",
             "diff": "Diff",
             "init": "INI",
             "properties": "Java Properties",
             "rst": "rST",
             "tex": "LaTeX",
             "vim": "VimL",
             "yaml": "YAML",
             "coffeescript": "CoffeeScript",
             "css": "CSS",
             "html": "HTML",
             "xml": "XML",
             "haml": "HAML",
             "js": "Javascript",
             "php": "PHP",
             "sass": "SASS",
             "txt": "Plain Text",
             "scaml": "Scaml"}

def buffer_contents():
    return '\n'.join(vim.current.buffer)

def selected():
    return vim.eval('GetVisualSelection()')

def refheap(text, priv):
    data = {'language': LANGUAGES.get(vim.eval('expand("%:e")'), "Plain Text"),
            'contents': text}
    username = vim.eval('g:refheap_username')
    token = vim.eval('g:refheap_token')
    if username and token:
        data['username'] = username
        data['token'] = token
    if priv:
        data['private'] = priv
    req = urllib2.Request(REFHEAP_URL + "paste", urllib.urlencode(data))
    try:
        res = json.loads(urllib2.urlopen(req).read())['url']
        xerox.copy(res)
        print "Copied " + res + " to your clipboard."
    except urllib2.HTTPError, e:
        print e.read()

def refheap_buffer():
    refheap(buffer_contents(), "false")

def refheap_buffer_private():
    refheap(buffer_contents(), "true")

def refheap_region():
    refheap(selected(), "false")

def refheap_region_private():
    refheap(selected(), "true")

EOF
