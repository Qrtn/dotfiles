### zgenom
# install if zgenom not present
[[ -f "${HOME}/.zgenom/zgenom.zsh" ]] || git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"

# load zgenom
source "${HOME}/.zgenom/zgenom.zsh"

zgenom autoupdate

# if the init script doesn't exist
if ! zgenom saved; then
  # specify plugins here
  # zgenom load romkatv/powerlevel10k powerlevel10k
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-history-substring-search
  # zgenom load softmoth/zsh-vim-mode
  zgenom load agkozak/zsh-z
  zgenom load supercrabtree/k
  # generate the init script from plugins above
  zgenom save
fi
######

### Completion/shell config
unsetopt beep
setopt autocd
setopt extendedglob
setopt histignoredups
setopt autopushd
setopt menu_complete
setopt share_history

zstyle :compinstall filename '/Users/jeffrey/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

zmodload zsh/complist
autoload -Uz compinit
compinit

bindkey -v
bindkey -M menuselect '^[[Z' reverse-menu-complete

bindkey -M vicmd 'K' history-substring-search-up
bindkey -M vicmd 'J' history-substring-search-down
####

# Exports
export EDITOR=nvim
export VISUAL="$EDITOR"

export CLICOLOR=1
export PATH="/Users/jeffrey/Documents/lassie/development/bin:/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/usr/local/sbin:$PATH"
##

# NVM
export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
###

### Aliases
alias ez='zgenom update && exec zsh'

alias l='ls -l'
alias ll='ls -l'
alias la='ls -la'

alias cat='bat'

function t() {
    tmux new-session -A -s "${1:-Default}"
}
alias t2='t 2'
alias t3='t 3'

alias vi='nvim'
alias vim='nvim'

alias pi='if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi'
alias pm='pyenv shell miniconda3-latest'
alias p3='pi; pyenv shell 3.10.1'
alias ip='pi; pm; ipython'

alias setup_vim='mkdir -p $HOME/cache/dein && curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s -- $HOME/.cache/dein'

alias gd='git diff'
alias gdc='git diff --cached'
alias gg='ga && gca && gp'
alias gs='git status'
alias gst='git stash'
alias gsi='git stash --include-untracked'
alias gsp='git stash pop'
alias gstp='gsp'
alias gnb='gst --include-untracked && gco main && gpom && gsp && gco -b'
alias gp='git push'
alias gpj='git push; git push origin -f $(git symbolic-ref --short HEAD):jeffrey'
alias gpu='git pull'
alias gpm='git pull origin main'
alias gpom='gpm'
alias gc='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcm='git checkout main; git pull'
alias gcom='gcm'
alias ga='git add -u'
alias gas='git add .'
alias gca='git commit -m add'
alias gpj='git push origin -f $(git branch --show-current):jeffrey'
alias gsw='git switch -'
alias nrg='npm run generate'
alias npg='npx prisma generate'
alias pu='npx prisma generate; npx prisma migrate deploy'
alias sz='source ~/.zshrc'
alias vz='vi ~/.zshrc'
alias nrw='npm run watch'
alias nw='nrw'
alias nrl='npm run lint'
alias nl='nrl'
alias gda='gcloud compute instances attach-disk --disk windows-vm-shared --mode ro'
alias gdw='gcloud compute instances attach-disk --disk windows-vm-shared --mode rw'
alias gdd='gcloud compute instances detach-disk --disk windows-vm-shared'
alias prune_agent_server='gcloud compute ssh agent-server --zone us-west2-c --command="docker system prune -af"'
alias ns='npx ts-node -r dotenv/config -r tsconfig-paths/register'
alias pr='poetry run python src/main.py'
alias pra='poetry run poe all'
######

# Lassie GCP
function csp() {
    cloud_sql_proxy "-instances=adroit-coral-304806:us-west2:lassie-${1:-development}=tcp:${2:-5432}"
}

alias gcurl='curl --header "Authorization: Bearer $(gcloud auth print-identity-token)" --header "user-email: jeffrey@golassie.com" --header "Content-Type: application/json"'

function gcurlp() {
    gcurl "https://setter-production-2rpjf63lrq-wl.a.run.app/$1" ${@:1}
}
function gcurll() {
    gcurl "http://localhost:8080/$1" ${@:1}
}
function gcurlj() {
    gcurl "https://setter-development-jeffrey-2rpjf63lrq-wl.a.run.app/$1" ${@:1}
}

alias gacurl='curl --header "Authorization: Bearer $(gcloud auth print-identity-token --audiences 612084636142-nrprtntf52b8h8o5aii2tiacvoioend0.apps.googleusercontent.com)" --header "user-email: jeffrey@golassie.com" --header "Content-Type: application/json"'

function scrape() {
    gcurl -X POST "https://setter-production-2rpjf63lrq-wl.a.run.app/retriever/scrape/remittances" -d "{
        \"practiceUuids\": [\"$1\"],
        \"backfillDays\": 60
    }"
}
##

# History file config
HISTFILE=~/.histfile
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
##

# Vim mode config
KEYTIMEOUT=1
MODE_CURSOR_VIINS="blinking bar"
MODE_CURSOR_REPLACE="steady underline"
MODE_CURSOR_VICMD="block"
MODE_CURSOR_SEARCH="steady underline"
MODE_CURSOR_VISUAL="steady bar"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL"
##

export PATH="/Users/jeffrey/.local/bin:/opt/homebrew/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/mysql-client/bin:/opt/homebrew/opt/libpq/bin:$PATH"
