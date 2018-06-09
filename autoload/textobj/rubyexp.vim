let s:self_path=expand("<sfile>")
execute 'ruby require "' . s:self_path . '.rb"'

function! textobj#rubyexp#select_a() abort
  return s:select()
endfunction

function! textobj#rubyexp#select_i() abort
  return s:select()
endfunction

function! s:select() abort
  let bn = bufnr('%')
  let off = 0
  let pos = s:get_range()
  let start_pos = [bn, pos[0], pos[1]+1, off]
  let end_pos = [bn, pos[2], pos[3], off]

  return ['v', start_pos, end_pos]
endfunction

function! s:get_range() abort
  ruby <<RUBY
    bufnr = Vim.evaluate("bufnr('%')")
    pos = Vim.evaluate("getpos('.')")
    line = pos[1]
    col = pos[2]-1
    source = Vim.evaluate("getbufline(#{bufnr}, 1, '$')").join("\n")
    range = Rubyexp.range(line, col, source)
    Vim.command "let s:result = #{JSON.generate(range)}"
RUBY
  let result = s:result
  unlet s:result
  return result
endfunction
