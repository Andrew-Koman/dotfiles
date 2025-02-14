# Setup fzf
# ---------

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--multi"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    if type fd &> /dev/null; then
        fd --hidden --follow --exclude ".git" . "$1"
    else
        fdfind --hidden --follow --exclude ".git" . "$1"
    fi
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    if type fd &> /dev/null; then
        fd --type d --hidden --follow --exclude ".git" . "$1"
    else
        fdfind --type d --hidden --follow --exclude ".git" . "$1"
    fi
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
    local command=$1
    shift

    # cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    case "$command" in
        cd)           fzf --preview 'eza --tree --level=3 --color=always --icons=auto --classify=auto --hyperlink {} | head -200'   "$@" ;;
        export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        kill)         fzf --preview 'procs'                    "$@" ;;
        *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
    esac
}

