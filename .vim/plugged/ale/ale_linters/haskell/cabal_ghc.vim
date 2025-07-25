" Author: Eric Wolf <ericwolf42@gmail.com>
" Description: ghc for Haskell files called with cabal exec

call ale#Set('haskell_cabal_ghc_options', '-fno-code -v0')

function! ale_linters#haskell#hls#GetProjectRoot(buffer) abort
    let l:paths = join(
    \   ale#path#Upwards(expand('#' . a:buffer . ':p:h'))[:-2],
    \   ','
    \)
    let l:project_file = globpath(l:paths, '*.cabal')

    " If we still can't find one, use the current file.
    if empty(l:project_file)
        let l:project_file = expand('#' . a:buffer . ':p')
    endif

    return fnamemodify(l:project_file, ':h')
endfunction

function! ale_linters#haskell#cabal_ghc#GetCommand(buffer) abort
    return 'cabal exec -- ghc '
    \   . ale#Var(a:buffer, 'haskell_cabal_ghc_options')
    \   . ' %t'
endfunction

call ale#linter#Define('haskell', {
\   'name': 'cabal_ghc',
\   'aliases': ['cabal-ghc'],
\   'output_stream': 'stderr',
\   'executable': 'cabal',
\   'project_root': function('ale_linters#haskell#cabal_ghc#GetProjectRoot'),
\   'command': function('ale_linters#haskell#cabal_ghc#GetCommand'),
\   'callback': 'ale#handlers#haskell#HandleGHCFormat',
\})
