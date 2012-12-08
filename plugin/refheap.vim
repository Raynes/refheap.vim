if !has('python')
  echo "Refheap requires that your Vim be compiled with +python."
  finish
endif

if exists('loaded_refheap')
  finish
endif

let loaded_refheap = 1

" Define our commands.
command! -range -nargs=? Refheap call refheap#Refheap(<line1>, <line2>, <f-args>)

