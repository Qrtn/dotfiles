# Powerlevel10k instant prompt (must be at very top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zimfw
ZIM_HOME=~/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Auto-install missing modules
if [[ ! -d ${ZIM_HOME}/modules/zsh-autosuggestions ]]; then
  source ${ZIM_HOME}/zimfw.zsh install
fi
# Auto-update weekly (use temp file for timestamp)
_zim_update_file=${ZIM_HOME}/.last_update
if [[ ! -f $_zim_update_file ]] || (( $(date +%s) - $(cat $_zim_update_file) > 604800 )); then
  echo "Updating zimfw modules..."
  source ${ZIM_HOME}/zimfw.zsh update -q
  source ${ZIM_HOME}/zimfw.zsh upgrade -q
  date +%s > $_zim_update_file
fi
unset _zim_update_file
source ${ZIM_HOME}/init.zsh

# Shell options
unsetopt beep
setopt autocd
setopt extendedglob
setopt histignoredups
setopt autopushd
setopt menu_complete
setopt share_history

# Completion styles (zimfw handles compinit)
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# History
HISTFILE=~/.histfile
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

# Environment
export EDITOR=nvim
export VISUAL="$EDITOR"
export CLICOLOR=1

# fnm (fast node manager)
eval "$(fnm env)"

# Path
export PATH="/Users/jeffrey/.local/bin:/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/opt/openvpn/sbin:/opt/homebrew/opt/mysql-client/bin:/opt/homebrew/opt/libpq/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Aliases - Shell
alias ez='zimfw update && exec zsh'
alias sz='source ~/.zshrc'
alias vz='vi ~/.zshrc'

# Aliases - Files
alias l='ls -l'
alias ll='ls -l'
alias la='ls -la'
alias cat='bat'

# Aliases - Tmux
function t() {
    tmux new-session -A -s "${1:-Default}"
}
alias t2='t 2'
alias t3='t 3'

# Aliases - Editor
alias vi='nvim'
alias vim='nvim'
alias setup_vim='mkdir -p $HOME/cache/dein && curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s -- $HOME/.cache/dein'

# Aliases - Python
alias pi='if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi'
alias pm='pyenv shell miniconda3-latest'
alias p3='pi; pyenv shell 3.10.1'
alias ip='pi; pm; ipython'
alias pr='poetry run python src/main.py'
alias pra='poetry run poe all'

# Aliases - Git
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
alias gpj='git push origin -f $(git branch --show-current):jeffrey'
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
alias gsw='git switch -'

# Aliases - Node/NPM
alias nrg='npm run generate'
alias npg='npx prisma generate'
alias pu='npx prisma generate; npx prisma migrate deploy'
alias nrw='npm run watch'
alias nw='nrw'
alias nrl='npm run lint'
alias nl='nrl'
alias ns='npx ts-node -r dotenv/config -r tsconfig-paths/register'

# Aliases - Claude
alias claude='claude --dangerously-skip-permissions'

# Aliases - GCloud
alias gda='gcloud compute instances attach-disk --disk windows-vm-shared --mode ro'
alias gdw='gcloud compute instances attach-disk --disk windows-vm-shared --mode rw'
alias gdd='gcloud compute instances detach-disk --disk windows-vm-shared'
alias prune_agent_server='gcloud compute ssh agent-server --zone us-west2-c --command="docker system prune -af"'

# Functions - Lassie GCP
function csp() {
    cloud_sql_proxy "-instances=adroit-coral-304806:us-west2:lassie-${1:-development}=tcp:${2:-5432}"
}

alias gcurl='curl --header "Authorization: Bearer $(gcloud auth print-identity-token)" --header "user-email: jeffrey@golassie.com" --header "Content-Type: application/json"'
alias gacurl='curl --header "Authorization: Bearer $(gcloud auth print-identity-token --audiences 612084636142-nrprtntf52b8h8o5aii2tiacvoioend0.apps.googleusercontent.com)" --header "user-email: jeffrey@golassie.com" --header "Content-Type: application/json"'

function gcurlp() {
    gcurl "https://setter-production-2rpjf63lrq-wl.a.run.app/$1" ${@:1}
}
function gcurll() {
    gcurl "http://localhost:8080/$1" ${@:1}
}
function gcurlj() {
    gcurl "https://setter-development-jeffrey-2rpjf63lrq-wl.a.run.app/$1" ${@:1}
}

function scrape() {
    gcurl -X POST "https://setter-production-2rpjf63lrq-wl.a.run.app/retriever/scrape/remittances" -d "{
        \"practiceUuids\": [\"$1\"],
        \"backfillDays\": 60
    }"
}

# Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
