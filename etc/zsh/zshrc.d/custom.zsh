# Setup the environment {{{1
if type brew &>/dev/null; then FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"; fi
if [[ -n "${SSH_CONNECTION}" && "$TERM" == "alacritty" ]]; then export TERM=xterm-256color; fi
if [[ -n "${GPG_TTY:-}" ]]; then export GPG_TTY=$(tty); fi
export STARSHIP_CONFIG="/etc/starship.toml"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export EDITOR="${EDITOR:-vim}"
export BAT_CONFIG_PATH="$HOME/.config/bat.conf"
export PAGER="${PAGER:-bat}"
export FZF_DEFAULT_OPTS="--ansi"

# Loading Modules {{{1
zmodload "zsh/attr" "zsh/cap" "zsh/clone" "zsh/complete" "zsh/complist" "zsh/computil" "zsh/curses" \
  "zsh/langinfo" "zsh/mathfunc" "zsh/parameter" "zsh/regex" "zsh/sched" "zsh/system" "zsh/termcap" \
  "zsh/terminfo" "zsh/zle" "zsh/zleparameter" "zsh/zpty" "zsh/zselect" "zsh/zutil"

autoload promptinit && promptinit
autoload bashcompinit && bashcompinit
autoload compinit && compinit
autoload colors && colors

# Helper functions {{{1
function has_bin(){ for var in "$@"; do which $var 2>/dev/null >&2; done; }
function source_if_exists(){ for var in "$@"; do test ! -r "$var" || source "$var"; done; }
function maybe_run_bin(){ if has_bin "$1"; then eval "$@"; fi; }
function maybe_eval_bin(){ if has_bin "$1"; then eval "$($*)"; fi; }
function maybe_add_fpath(){ if test ! -d "$1"; then return; fi; export -U FPATH="$1${FPATH:+:$FPATH}" ;}
function maybe_add_fpaths(){ for p in "$@"; do maybe_add_fpath "$p"; done; }
function maybe_add_path(){ if test ! -d "$1"; then return; fi; export -U PATH="$1${PATH:+:$PATH}" ;}
function maybe_add_paths(){ for p in "$@"; do maybe_add_path "$p"; done; }
# starts one or multiple args as programs in background
function bg() { for ((i=2;i<=$#;i++)); do ${@[1]} ${@[$i]} &> /dev/null &; done; }
function scp_to_same(){ scp -rp "$1" "$2:$1" ;}
function uuid() { # Usage: uuid
  C="89ab"
  for ((N=0;N<16;++N)); do
      B="$((RANDOM%256))"
      case "$N" in
          6)  printf '4%x' "$((B%16))" ;;
          8)  printf '%c%x' "${C:$RANDOM%${#C}:1}" "$((B%16))" ;;
          3|5|7|9) printf '%02x-' "$B" ;;
          *) printf '%02x' "$B" ;;
      esac
  done
  printf '\n'
}

# maybe_add_fpaths "$zsh_dir/completions" "$zsh_dir/functions" 
maybe_add_paths  \
  "$HOME/.cargo/bin" \
  "$HOME/.fzf/bin" \
  "${GOPATH:-$HOME/go}/bin" \
  "${GOROOT:-/usr/lib/go}/bin" \
  "$HOME/.local/bin" \
  "$HOME/.pyenv/bin" \
  "$HOME/.pyenv/shims" \
  "$HOME/.rbenv/bin" \
  "$HOME/.rbenv/shims" \
  "/Library/Apple/usr/bin" \
  "/bin" \
  "/opt/homebrew/bin" \
  "/opt/homebrew/sbin" \
  "/sbin" \
  "/usr/bin" \
  "/usr/local/bin" \
  "/usr/local/sbin" \
  "/usr/sbin" 

# Third-Party Hooks {{{1
source_if_exists "$HOME/.profile"
source_if_exists "$HOME/.rbenv/completions/rbenv.zsh"
source_if_exists "${XDG_CONFIG_DIR}/zsh/plugins/skim.zsh"
source_if_exists "${HOME}/.iterm2_shell_integration.zsh"
source_if_exists "$HOME/.nix-profile/etc/profile.d/nix.sh"
source_if_exists "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh";
source_if_exists "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";

maybe_eval_bin direnv hook zsh
maybe_eval_bin rbenv init -
maybe_eval_bin pyenv init -
maybe_eval_bin starship init zsh
maybe_eval_bin zoxide init --cmd="goto" zsh

# Standard ZSH Options                                              {{{1
#=======================================================================
setopt cbases cprecedences
setopt autocd autopushd pushdsilent pushdignoredups pushdtohome
setopt cdablevars interactivecomments printexitvalue shortloops
setopt localloops localoptions localpatterns
setopt pipefail vi evallineno

# Autocompletion
setopt hashdirs hashcmds 
setopt aliases 
setopt automenu 
setopt autoparamslash 
setopt autoremoveslash 
setopt completealiases 
setopt promptbang promptcr promptsp promptpercent promptsubst transientrprompt 
setopt listambiguous 
setopt listpacked 
setopt listrowsfirst 
setopt autolist 
setopt markdirs

setopt banghist 
setopt histbeep 
setopt inc_append_history
setopt histexpiredupsfirst 
setopt histignorealldups 
setopt histnostore 
setopt histfcntllock 
setopt histfindnodups 
setopt histreduceblanks 
setopt histsavebycopy 
setopt histverify 
setopt sharehistory

# Shell History
HISTFILE="$HOME/.zhistory" 
SAVEHIST=50000  # Total lines to save in zsh history.
HISTSIZE=1000   # Lines of history to save to save from the current session.

unsetopt correct correctall 

# Job Control
unsetopt flowcontrol   #Disable ^S & ^Q.
setopt autocontinue autoresume bgnice checkjobs notify longlistjobs
setopt checkrunningjobs 

# zstyle {{{1
zstyle ':completion:*'                cache-path        "~/.zcompletion.cache"
zstyle ':completion:*'                completer         _complete _match _approximate 
zstyle ':completion:*'                file-list         list=20 insert=10
zstyle ':completion:*'                squeeze-slashes   true
zstyle ':completion:*'                use-cache         on
zstyle ':completion:*:*:kill:*'       menu              yes select
zstyle ':completion:*:(all-|)files'   ignored-patterns  '(|*/)CVS'
zstyle ':completion:*:default'        list-dirs-first   true
zstyle ':completion:*:approximate:*'  max-errors        1 numeric
zstyle ':completion:*:cd:*'           ignore-parents    parent pwd
zstyle ':completion:*:cd:*'           ignored-patterns  '(*/)#CVS'
zstyle ':completion:*:functions'      ignored-patterns  '_*'
zstyle ':completion:*:kill:*'         force-list        always
zstyle ':completion:*:match:*'        original          only
zstyle ':completion:*:rm:*'           file-patterns     '*.log:log-files' '%p:all-files'
