let s:previousTarget = ""

function! FindMakefile()
    return readfile("Makefile")
endfunction

function! ListTargets(lines)
    let targets = []
    for s in a:lines
        let m = matchstr(l:s, "^[a-zA-Z0-9_]*")
        if m != ""
            let targets =add(targets, m)
        endif
    endfor
    return targets
endfunction

function! PrintTargets(targets)
    let i = 1
    for t in a:targets
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

    let file = FindMakefile()
    let l:targets = ListTargets(file)
    call PrintTargets(l:targets)

    call inputsave()
    echo "\n"
    let l:selectedTarget = input("[default: 0] > ")

    if l:selectedTarget == 0
        let l:target = s:previousTarget
    else
        let l:target = l:targets[l:selectedTarget-1]
        let s:previousTarget = l:target
    endif
    call inputrestore()

    redraw
    :execute "make " l:target
endfunction

nnoremap <leader>M :call Menu()<CR>
