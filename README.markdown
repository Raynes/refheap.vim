# refheap.vim

This is a tiny little Vim plugin for pasting to
[RefHeap](https://refheap.com).

# Installation

The majority of this plugin is written in Python. Because of this,
you'll need to have a copy of Vim that is compiled with +python enabled.
This plugin also makes use of a Python library for copying text to the
system clipboard in a cross platform way called xerox, so you'll need
that as well. You can install it like so:

```
pip install xerox
```

If you don't have pip:

```
easy_install xerox
```

If you're on Windows, you'll need to install the pywin32 library as well
(in the same way you installed xerox).

On Linux, xerox uses xclip, so you'll need to install that if your
distro doesn't already have it. On OS X, you'll need pbcopy installed,
but it should be installed by default. On Windows, you shouldn't need
anything but the pywin32 library.

You'll want to copy `plugin/` to `~/.vim`. If you're using pathogen, you
already know what to do.

# Usage

This library defines four commands: :RefheapBuffer,
:RefheapBufferPrivate, :RefheapRegion, :RefheapRegionPrivate. It does
not create keybindings for anything, so if you want those, you'll need
to define them yourself.

By default, your pastes will be anonymous. If you want to associate them
with an account, add the following to your `.vimrc`:

```
let g:refheap_token = 'yourtokenhere'
let g:refheap_user = 'username'
```

You can get your API token by logging in and navigating to the [RefHeap
API](https://refheap.com/api) page. Your username is in the upper right
corner next to the 'logout' button.