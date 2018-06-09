if exists('g:loaded_textobj_rubyexp')
  finish
endif

call textobj#user#plugin('rubyexp', {
\      '-': {
\        'select-a': 'ar',  'select-a-function': 'textobj#rubyexp#select_a',
\        'select-i': 'ir',  'select-i-function': 'textobj#rubyexp#select_i'
\      }
\    })

" Fin.  "{{{1

let g:loaded_textobj_rubyexp = 1
