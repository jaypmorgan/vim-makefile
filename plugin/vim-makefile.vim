let s:previousTarget = "test"

function! s:FindMakefile()
    return readfile("Makefile")
endfunction

function! s:ListTargets(lines)
    let targets = []
    for s in s:lines
        let m = matchstr(s, "^[a-zA-Z0-9_]*")
        if m != ""
            let targets =add(targets, m)
        endif
    endfor
    return targets
endfunction

function! s:PrintTargets(targets)
    let i = 1
    for t in s:targets
        echo i ": " t
        let i = i + 1
    endfor
endfunction

function! Menu()
    echo "Reading targets from: ./MakeFile"
    echo "\n"

    if s:previousTarget != ""
        echo "0 : " s:previousTarget
        echo "\n"
    endif

    let s:file = s:FindMakefile()
    let s:targets = s:ListTargets(s:file)
    call s:PrintTargets(s:targets)

    call inputsave()
    echo "\n"
    let s:selectedTarget = input("[default: 0] > ")

    if s:selectedTarget == 0
        let s:target = s:previousTarget
    else
        let s:target = s:targets[s:selectedTarget-1]
        let s:previousTarget = s:target
    endif

    call inputrestore()
    redraw

    :execute "make " s:target
endfunction

nnoremap <leader>M :call Menu()<CR>
