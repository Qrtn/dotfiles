# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt autocd extendedglob
unsetopt beep
bindkey -v # End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/jeffrey/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt histignoredups
setopt autopushd

bindkey "^?" backward-delete-char

setopt menu_complete
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

export EDITOR=vim
export VISUAL=vim

export CLICOLOR=1
export ZSH_AUTOSUGGEST_STRATEGY=history

export PATH=~/Documents/bin:"$PATH"

alias ll='ls -l'
alias zshbundle='antibody bundle <~/.zsh_plugins.txt >~/.zsh_plugins.sh'
alias gtkwave='/Applications/gtkwave.app/Contents/Resources/bin/gtkwave'
alias t='tmux new-session -A -s Default'
#alias mvi='mvim --remote-silent'

alias vi='nvim'
alias vim='nvim'

potd() {
    local potd_dir=~/Documents/uiuc/cs225_potd
    cd $potd_dir

    for file in ~/Downloads/(potd|gotw)-*.sh(.); do
        mv $file .
        sh ./$(basename $file)
    done
}

alias pi='if which pyenv > /dev/null; then eval "$(pyenv init - --no-rehash)"; fi'
alias pm='pyenv shell miniconda3-latest'
alias p3='pi; pyenv shell 3.8.1'
alias ip='pi; pm; ipython'
alias 126gh='p3; pushd ~/Documents/uiuc/misc/cs126_ca/repo-fetcher; python repo-fetcher.py --open; popd'
alias audacity='~/Applications/Audacity.app/Contents/MacOS/Audacity'

#export MODE_CURSOR_VICMD="block"
#export MODE_CURSOR_VIINS="blinking bar"
#export MODE_CURSOR_SEARCH="steady underline"

#export KEYTIMEOUT=1

source ~/.zsh_plugins.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias finddata='lsof | grep /Volumes/Data'
alias secureinput='ioreg -l -w 0 | grep SecureInput'

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
