alias ..='cd ..'; alias ...='cd ../..'; alias ....='cd ../../..'; # navigate quicker.
alias apk='sudo apk'; # apk must always be run as the super-user.
alias chgrp='chgrp -c --preserve-root';
alias chmod='chmod -c --preserve-root';
alias chown='chown -c --preserve-root';
alias cp='cp -vi'; # prompt for confirmation, list changes.
alias df='df -H'; alias du='du -ch'; # output sizes in human format.
alias l.='ls -d .* --color=auto'; ## Show hidden files ##
alias list-aliases='bat /etc/zsh/zshrc.d/aliases.zsh'
alias list-bins='for p in $(echo "$PATH" | tr ":" "\n"); do [[ ! -d "$p" ]] || ls -A1 "$p"; done | sort -u'
alias list-env='env | sort'
alias list-fpath='echo "$FPATH" | tr ":" "\n"'
alias list-keybinds='bindkey | grep -v "magic-space"  |tr -d "\""'
alias list-path='echo "$PATH" | tr ":" "\n"'
alias ll='ls -lAh'; ## Use a long listing format ##
alias ln='ln -vi'; # prompt for confirmation, list changes.
alias ls='ls --color=auto'; ## Colorize the ls output ##
alias lss='ls -Alh | sort -k4'
alias memory='free -mlth'; # output system memory info in human format. 
alias mkdir='mkdir -pv'
alias mv='mv -vi'; # prompt for confirmation, output changes.
alias ports='netstat -tulanp'; # quickly check open tcp/udp ports on a host.
alias pscpu='ps auxf | sort -nr -k 3'; # get processes, sorted by CPU.
alias psmem='ps auxf | sort -nr -k 4'; # get processes, sorted by memory.
alias rm='rm -I --preserve-root'; # do not delete / or prompt if deleting more than 3 files at a time #
alias root='sudo -i'; alias su='sudo -i'; # become root easier.
alias sha1='openssl sha1'; # quickly generate a sha1 digest for file/stdin.
alias sha256='openssl sha256'; # quickly generate a sha256 digest for file/stdin.
alias sha384='openssl sha384'; # quickly generate a sha384 digest for file/stdin.
alias sha512='openssl sha512'; # quickly generate a sha512 digest for file/stdin.