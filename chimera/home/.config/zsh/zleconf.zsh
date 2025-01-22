# History search should use the
# existing text in the BUFFER, if any.
function {
    local dir name
    for dir in {for,back}ward; do 
        name="history-incremental-search-$dir"
        eval 'function '$name' {
            local txt="${BUFFER## }"
            local pre="${BUFFER%$txt}"
            BUFFER=; zle .'$name' -- $txt
            BUFFER="${pre}${BUFFER}"
        }'
        zle -N $name
    done
}

# vim: et ts=4 sts=4 sw=4 isk+=-
