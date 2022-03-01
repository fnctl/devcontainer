autoload -U select-word-style edit-command-line up-line-or-beginning-search down-line-or-beginning-search
function bindkey_all(){ bindkey -M emacs "$1" $2; bindkey -M viins "$1" $2; bindkey -M vicmd "$1" $2; }

# Use bash-style word separators (such as dirs).
select-word-style bash

# Use emacs key bindings
bindkey -e

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() { echoti smkx; }
  function zle-line-finish() { echoti rmkx; }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Custom Keybind Functions!
function find-files-in-directory() { BUFFER=" fzf --ansi -i --preview 'grep -rI --color=always --line-number \"{}\" .'"; zle accept-line; }; 
function open-files() { BUFFER=' vim -p $(find . -type f | fzf -m)'; zle accept-line; } 

# Define all custom keybind functions with ZLE.
zle -N find-files-in-directory
zle -N open-files
zle -N edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search


# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then bindkey_all "${terminfo[kpp]}" up-line-or-history; fi
# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then bindkey_all "${terminfo[knp]}" down-line-or-history; fi
# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then bindkey_all "${terminfo[kcuu1]}" up-line-or-beginning-search; fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then bindkey_all "${terminfo[kcud1]}" down-line-or-beginning-search; fi
# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then bindkey_all "${terminfo[khome]}" beginning-of-line; fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then bindkey_all "${terminfo[kend]}"  end-of-line; fi
# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then bindkey_all "${terminfo[kcbt]}" reverse-menu-complete; fi
bindkey_all '^?' backward-delete-char; # [Backspace] - delete backward

# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; 
then bindkey_all "${terminfo[kdch1]}" delete-char;
else bindkey_all "^[[3~" delete-char; bindkey_all "^[3;5~" delete-char; fi

bindkey_all '^[[3;5~' kill-word;     # [Ctrl-Delete] - delete whole forward-word
bindkey_all '^[[1;5C' forward-word;  # [Ctrl-RightArrow] - move forward one word
bindkey_all '^[[1;5D' backward-word; # [Ctrl-LeftArrow] - move backward one word
bindkey '\ew' kill-region            # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'              # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space                               # [Space] - don't do history expansion

# Edit the current command line in $EDITOR
bindkey '\C-x\C-e' edit-command-line
bindkey "\C-x\C-x" open-files

# file rename magick
bindkey "^[m" copy-prev-shell-word

bindkey "^[e" edit-command-line
bindkey "^[d" find-files-in-directory
bindkey "^[n" open-files
bindkey "^[f" find-files-in-directory

bindkey '\C-x\C-e'     edit-command-line
bindkey '\C-k'         up-line-or-history
bindkey '\C-j'         down-line-or-history
bindkey '\C-h'         backward-word
bindkey '\C-w'         backward-kill-word
bindkey '^[h'          run-help
bindkey '\C-b'         backward-word
bindkey '\C-a'         beginning-of-line
bindkey '\C-e'         end-of-line
bindkey '\C-f'         forward-word
bindkey '\C-l'         forward-word
bindkey " "            magic-space